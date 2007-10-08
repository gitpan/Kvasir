#!perl

use strict;
use warnings;

use Test::More tests => 6;

use Kvasir::Constants;
use Kvasir::Engine;
use Kvasir::Runloop;

# Test create _mk_runloop
my $i = 0;

# Actions
my $engine = Kvasir::Engine->new();
$engine->add_rule(rule1 => "Kvasir::Rule::Perl", undef, sub { return KV_MATCH; });
$engine->add_rule(rule2 => "Kvasir::Rule::Perl", undef, sub { return KV_NO_MATCH; });

$engine->add_action(action1 => "Kvasir::Action::Perl", undef, sub { ok(++$i == 1); });
$engine->add_action(action2 => "Kvasir::Action::Perl", undef, sub { ok(++$i == 2); });
$engine->add_action(action3 => "Kvasir::Action::Perl", undef, sub { ok(0); });

$engine->add_rule_action(rule1 => "action1");
$engine->add_rule_action(rule1 => "action2");
$engine->add_rule_action(rule2 => "action3");

my $cb = Kvasir::Runloop::_mk_runloop($engine);
$cb->();

# Arguments
$engine = Kvasir::Engine->new();
$engine->add_rule(rule1 => "Kvasir::Rule::Perl", undef, sub { return KV_MATCH; });
$engine->add_action(action1 => "Kvasir::Action::Perl", undef, sub { 
    my ($self, $input, $global, $local) = @_[KV_SELF, KV_INPUT, KV_GLOBAL, KV_LOCAL];

    isa_ok($self, "Kvasir::Action::Perl");
    isa_ok($input, "Kvasir::InputHandler");
    isa_ok($global, "Kvasir::Data");
    isa_ok($local, "Kvasir::Data");
});
$engine->add_rule_action(rule1 => "action1");

$cb = Kvasir::Runloop::_mk_runloop($engine);
$cb->();
