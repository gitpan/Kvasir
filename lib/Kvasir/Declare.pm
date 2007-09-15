package Kvasir::Declare;

use strict;
use warnings;

use Carp;
use List::Util qw(first);
use Scalar::Util qw(blessed);

use Kvasir::Engine;

use Kvasir::Action::Perl;
use Kvasir::Hook::Perl;
use Kvasir::Input::Perl;
use Kvasir::Output::Perl;
use Kvasir::Rule::Perl;

use Kvasir::Util qw(is_existing_package);

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT = qw(
    action
    as
    does
    engine 
    input 
    instanceof
    load_module
    output
    prehook
    posthook
    with_args
    rule
    when
    run
);

our $current_engine;

sub engine(&) {
    my ($sub, $name) = @_;

    my $engine = Kvasir::Engine->new();

    local $current_engine = $engine;
    $sub->();
    
    if (defined $name) {
        Kvasir::Engine->register_engine($name => $engine);
    }
    
    return $engine;
}

sub as($) {
    return $_[0];
}

sub does(&) {
    my $cv = shift;
    my $does = bless [$cv], "_Does";
    return $does;
}

{
    my %Classes;
    sub load_module($) {
        my $class = shift;
        if (!exists $Classes{$class}) {
            eval "require $class;";
            croak $@ if $@;
            $Classes{$class} = 1;
        }
        
        1;        
    }
}

sub instanceof($) {
    my $class = shift;
    load_module($class) if !is_existing_package($class);
    my $instanceof = bless [$class], "_InstanceOf";
    return $instanceof;
}

sub with_args($) {
    my $args = shift;
    croak "Arguments must be a hash reference" if ref $args ne 'HASH';
    my $with_args = bless [$args], "_WithArgs";
    return $with_args;
}

sub when(@) {
    for (@_) {
        croak "Rule '$_' does not exist" if !$current_engine->has_rule($_);
    }
    my $rules = bless [@_], "_When";
    return $rules;
}

sub run(@) {
    my @when = grep { blessed $_ && $_->isa('_When') } @_;
    my @actions = grep { !(blessed $_ && $_->isa('_When')) } @_;
    
    croak "Unkown input for 'run'" if @_ > @when + @actions;
    
    for (@actions) {
        croak "Action '$_' does not exist" if !$current_engine->has_action($_);
    }
    
    # Add all actions to each rule
    foreach my $rule (map { @$_ } @when) {
        foreach my $action (@actions) {
            $current_engine->add_rule_action($rule => $action);
        }
    }
}

sub _get_command {
    my $kind = shift;
    my $does_class = shift;
        
    croak "Can't use keyword '${kind}' outside an engine declaration" if !$current_engine;
        
    my @isa = grep { blessed $_ && $_->isa('_InstanceOf') } @_;
    croak "Multiple 'instanceof' declared" if @isa > 1;
    
    my @args = grep { blessed $_ && $_->isa('_WithArgs') } @_;
    croak "Multiple 'with_args' declared" if @args > 1;
    
    my @does = grep { blessed $_ && $_->isa('_Does') } @_;
    croak "Multiple 'does' declared" if @does > 1;
    
    my $cmd;

    if (@isa) {
        @args = @args ? (shift @args)->[0] : ();
        $cmd = (shift @isa)->[0];
    }
    elsif (@does) {
        @args = (shift @does)->[0];
        $cmd = $does_class;
    }
    else {
        croak "Can't fingure out how to create ${kind} because we have neither 'instanceof' nor 'does'";
    }
    
    return ($cmd, @args);
}

sub action ($@) {
    my $name = shift;    
    my ($action, @args) = _get_command("action", "Kvasir::Action::Perl", @_);    
    $current_engine->add_action($name => $action, @args);
}

sub input ($@) {
    my $name = shift;
    my ($input, @args) = _get_command("input", "Kvasir::Input::Perl", @_);    
    $current_engine->add_input($name => $input, @args);
}

sub output ($@) {
    my $name = shift;
    my ($output, @args) = _get_command("output", "Kvasir::Output::Perl", @_);    
    $current_engine->add_output($name => $output, @args);
}

sub prehook ($@) {
    my $name = shift;    
    my ($hook, @args) = _get_command("prehook", "Kvasir::Hook::Perl", @_);    
    $current_engine->add_hook($name => $hook, @args);
    $current_engine->add_pre_hook($name);
}

sub posthook ($@) {
    my $name = shift;    
    my ($hook, @args) = _get_command("posthook", "Kvasir::Hook::Perl", @_);    
    $current_engine->add_hook($name => $hook, @args);
    $current_engine->add_post_hook($name);
}

sub rule ($@) {
    my $name = shift;    
    my ($rule, @args) = _get_command("rule", "Kvasir::Rule::Perl", @_);    
    $current_engine->add_rule($name => $rule, @args);
}

1;
__END__

=head1 NAME

Kvasir::Declare - Declarative interface for Kvasir engines

=head1 SYNOPSIS

  use Kvasir::Constants;
  use Kvasir::Declare;
  
  my $engine = engine {
      input "input1" => instanceof "MyApp::Input";
      input "input2" => instanceof "MyApp::OtherInput";

      rule "rule1" => instanceof "MyApp::Rule" => with_args { input => "input1" };
      rule "rule2" => instanceof "MyApp::Rule" => with_args { input => "input2" };

      rule "rule3" => does {
          my ($input, $global, $local) = @_[KV_INPUT, KV_GLOBAL_DATA, KV_LOCAL_DATA];

          if ($input->get("input1") < 5 &&
              $input->get("input1") > 10) {
              return KV_MATCH;  
          }

          return KV_NO_MATCH;
      }; 

      action "action1" => does {
          my $result = complex_calculation();
          $_[KV_LOCAL]->set("result" => $result);
      };
            
      prehook "check_date" => does {
          return KV_CONTINUE;
      };
      
      run "action1" => when qw(rule1 rule2 rule3);
  };
  
  $engine->run();

=head1 INTERFACE

=head2 FUNCTIONS

=over 4

=item engine BLOCK

Creates a new engine.

=item action NAME [=> instanceof CLASS [ => with_args ARGS]]

=item action NAME => does BLOCK

Creates a new action and registers it in the engine as I<NAME>.

=item input NAME [=> instanceof CLASS [ => with_args ARGS]]

=item input NAME => does BLOCK

Creates a new input and registers it in the engine as I<NAME>.

=item output NAME [=> instanceof CLASS [ => with_args ARGS]]

=item output NAME => does BLOCK

Creates a new output and registers it in the engine as I<NAME>.

=item prehook NAME [=> instanceof CLASS [ => with_args ARGS]]

=item prehook NAME => does BLOCK

Creates a new prehook and registers it in the engine as I<NAME>.

Prehooks are evaulated in the order they are declared.

=item posthook NAME [=> instanceof CLASS [ => with_args ARGS]]

=item posthook NAME => does BLOCK

Creates a new posthook and registers it in the engine as I<NAME>.

Posthooks are evaulated in the order they are declared.

=item rule NAME [=> instanceof CLASS [ => with_args ARGS]]

=item rule NAME => does BLOCK

Creates a new rule and registers it in the engine as I<NAME>.

Rules are evaulated in the order they are declared unless an order has 
explicitly been defined using C<rule_order>. d

=item run ACTIONS => when RULES

Runs the list of I<ACTION> when the given I<RULES> matches.

=item as NAME

Checks that I<NAME> is a valid name and returns it if so. Otherwise throws an exception.

=item instanceof CLASS

Marks the declared entity to be an instance of the given I<CLASS>.

=item does BLOCK

Marks the declared entity to be implemented via a Perl subroutine.

=item load_module MODULE

Load the module I<MODULE>.

=back

=cut