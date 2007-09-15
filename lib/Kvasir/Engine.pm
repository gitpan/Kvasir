package Kvasir::Engine;

use strict;
use warnings;

use Carp qw(croak);
use Scalar::Util qw(blessed);

use Kvasir::Constants;
use Kvasir::Data;
use Kvasir::Util qw(is_valid_package_name);
use Kvasir::Runloop;

use Kvasir::Engine::Actions;
use Kvasir::Engine::Hooks;
use Kvasir::Engine::Inputs;
use Kvasir::Engine::Outputs;
use Kvasir::Engine::Rules;

use Object::Tiny qw(
	_actions
	_hooks
	_inputs
	_outputs
	_rule_order
	_post_hooks
	_pre_hooks
	_rules

);

sub new {
	my $pkg = shift;

	my $self = bless {
		_actions    => Kvasir::Data->new(),
		_hooks	    => Kvasir::Data->new(),
		_inputs		=> Kvasir::Data->new(),
		_outputs    => Kvasir::Data->new(),
		_post_hooks => [],
		_pre_hooks  => [],
		_rules		=> Kvasir::Data->new(),
		_rule_order => [],
	}, $pkg;
		
	return $self;
}

sub run {
	my $self = shift;
	    
    my $runloop = Kvasir::Runloop->new();

    $runloop->add_engine($self);
    $runloop->run();
}

1;
__END__

=head1 NAME

Kvasir::Engine - Analysis worker

=head1 INTERFACE

=head2 CLASS METHODS

=over 4

=item new

Creates a new worker.

=back

=head2 INSTANCE METHODS

=over 4

=item add_rule ( $rule )

Adds a rule to the worker.

=item add_pre_hook ( $callback )

Adds a new hook that is run before every iteration.

=item add_post_hook ( $callback )

Adds a new hook that is run after every iteration.

=item run ( $work_callback )

Runs the worker.

=back

=head3 Actions

=over 4

=item actions

Returns the names of all registered actions.

=item has_action ( NAME )

Checks if the engine has a registered action with the given I<NAME>.

=item add_action ( NAME => ACTION )

Registers the I<ACTION> as I<NAME> in the engine.

=back

=head3 Hooks

=over 4

=item hooks

Returns the names of all registered hooks.

=item has_hook ( NAME )

Checks if the engine has a registered hook with the given I<NAME>.

=item add_hook ( NAME => HOOK )

Registers the I<HOOK> as I<NAME> in the engine.

=item add_pre_hook ( NAME )

Adds the hook with the given I<NAME> to the list of hooks to run before each iteration.

=item add_post_hook ( NAME )

Adds the hook with the given I<NAME> to the list of hooks to run after each iteration.

=back

=head3 Inputs

=over 4

=item inputs

Returns the names of all registered inputs

=item has_input ( NAME )

Checks if the engine has a registered input with the given I<NAME>.

=item add_input ( NAME => INPUT )

Registers the I<INPUT> as I<NAME> in the engine.

=back

=head3 Outputs

=over 4

=item outputs

Returns the names of all registered outputs

=item has_output ( NAME )

Checks if the engine has a registered output with the given I<NAME>.

=item add_output ( NAME => OUTPUT )

Registers the I<OUTPUT> as I<NAME> in the engine.

=back

=head3 Rules

=over 4

=item rules

Returns the names of all registered rules

=item has_rule ( NAME )

Checks if the engine has a registered rule with the given I<NAME>.

=item add_rule ( NAME => OUTPUT )

Registers the I<OUTPUT> as I<NAME> in the engine.

=item add_rule_action ( NAME => ACTION )

Connects the rule I<NAME> to the action I<ACTION>.

=item rule_order

Returns a list of names matching the rules in the order they'll be evaluated.

=item set_rule_order ( LIST )

Sets which order the rules should be evaluated. The list should be the names of the rules.

=back

=cut