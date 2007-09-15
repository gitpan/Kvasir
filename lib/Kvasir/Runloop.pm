package Kvasir::Runloop;

use strict;
use warnings;

use Carp qw(croak);
use List::Util qw(first);
use Scalar::Util qw(refaddr blessed);

use Kvasir::Constants;

my %Engine;
my %Runloop;
my %Initialized;

sub new {
    my ($pkg) = @_;
    my $self = bless \do { my $v; }, $pkg;
    $$self = refaddr $self;

    $Engine{$$self} = [];
    $Runloop{$$self} = [];
    $Initialized{$$self} = 0;

    return $self;
}

sub DESTROY {
    my $self = shift;
    delete $Engine{$$self};
    delete $Initialized{$$self};
    delete $Runloop{$$self};
}

sub add_engine {
    my ($self, $engine) = @_;
    
    croak "Engine is undefined" if !defined $engine;
    croak "Engine is not a Kvasir::Engine instance" if !(blessed $engine && $engine->isa("Kvasir::Engine"));
    
    my $engines = $Engine{$$self};
    if (!first { $_ == $engine } @$engines) {
        push @$engines, $engine;
    }
    else {
        croak "Engine already exists";
    }    
}

sub init {
    my ($self) = @_;
    
    return if $Initialized{$$self};
    
    foreach my $engine (@{$Engine{$$self}}) {
        my $runloop = _mk_runloop($engine);
        $self->_register_runloop($runloop);
    }
}

sub _mk_runloop {
    my $engine = shift;

    my @rules = @{$engine->_rule_order};

    my %action_map  = map {
        my $rule = $engine->_get_rule($_);
        $_ => [@{$rule->{actions}}];
    } @rules;
    
	my %rules       = map {
	    my $rule = $engine->_get_rule($_);
	    my $rule_obj = $rule->{pkg}->new(@{$rule->{args}});
	    $_ => $rule_obj;
    } @rules;
    
    my %actions     = map {
        my $action = $engine->_get_action($_);
        my $action_obj = $action->{pkg}->new(@{$action->{args}});
        $_ => $action_obj;
    } $engine->actions;
    
	my @pre_hooks	= map { $_->{pkg}->new(@{$_->{args}}) } map { $engine->_get_hook($_) } @{$engine->_pre_hooks};
	my @post_hooks	= map { $_->{pkg}->new(@{$_->{args}}) } map { $engine->_get_hook($_) } @{$engine->_post_hooks};

	my $inputs		= $engine->_input_handler;
	my @outputs		= map { $_->{pkg}->new(@{$_->{args}}) } map { $engine->_get_output($_) } sort $engine->outputs;
	
	my $global = Kvasir::Data->new();
	    	
	my $runloop = sub {
		my $local = Kvasir::Data->new();
		
		# Process all pre hooks
		for my $hook (@pre_hooks) {
			my $result = $hook->invoke($inputs, $global, $local);
			return KV_ABORT if $result == KV_ABORT;
		}
		
		# Run rules until we find a matching rule
		my $match;
		PROCESS_RULES: for (@rules) {
		    my $rule = $rules{$_};
			my $result = $rule->evaluate($inputs, $global, $local);
			$match = $_, last PROCESS_RULES if $result == KV_MATCH;
		}
        
        # Run all actions
        if ($match) {
            my $actions = $action_map{$match};
            for (@$actions) {
                my $action = $actions{$_};
                $action->perform($inputs, $global, $local);
            }
        }
        
        # All outputs are always called
		PROCESS_OUTPUT: for my $output (@outputs) {
			$output->process($inputs, $global, $local);
		}
		
		# Process all post hooks
		for my $hook (@post_hooks) {
			my $result = $hook->invoke($hook, $inputs, $global, $local);
			return KV_ABORT if $result == KV_ABORT;
		}
		
		return KV_CONTINUE;
	};
	
	return $runloop;
}

sub _register_runloop {
    my ($self, $runloop) = @_;
    
    my $runloops = $Runloop{$$self};
    if (!first { $_ == $runloop } @$runloops) {
        push @$runloops, $runloop;
    }
    else {
        croak "Runloop already registered";
    }
}

sub _unregister_runloop {
    my ($self, $runloop) = @_;
    
    my $runloops = $Runloop{$$self};
    my @runloops = grep { $_ != $runloop } @$runloops;
    $Runloop{$$self} = \@runloops;
    
}

sub step {
    my $self = shift;
    
    my $runloops = $Runloop{$$self};
    
    if (@$runloops) {
        foreach my $runloop (@$runloops) {
            my $status = $runloop->();
            if ($status == KV_ABORT) {
                $self->_unregister_runloop($runloop);
            }
        }
    }
    
    return scalar @$runloops;
}

sub run {
    my $self = shift;
    
    $self->init();
    
    RUNLOOP: while(1) {
        last RUNLOOP if $self->step() == 0;
    }    
}

1;
__END__

=head1 NAME

Kvasir::Runloop - Runs engine(s)

==head1 INTERFACE

=head2 CLASS METHODS

=over 4

=item new

Creates a new runloop instance.

=back

=head2 INSTANCE METHODS

=over 4

=item add_engine ( ENGINE )

Adds an engine to the runloop.

=item init

Initializes the runloop. Must be called before C<step> in order for 
the runloop to work. It called automaticly by C<run>.

=item step

Performs one iteration in the runloop. Returns 0 when there is no 
more work to perform.

=item run

Runs the engine until there is no more work to perform.

=back

=cut


