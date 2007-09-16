#!perl

use strict;
use warnings;

use Test::More tests => 2;

use Kvasir::Engine;

my $engine = Kvasir::Engine->new();

$engine->add_rule(Foo => "Test::Kvasir::Rule");
$engine->add_rule(baz => "Test::Kvasir::Rule");
$engine->add_rule(bar => "Test::Kvasir::Rule");

is_deeply([$engine->rule_order], [qw(Foo baz bar)]);

$engine->set_rule_order(qw(Foo bar baz));

is_deeply([$engine->rule_order], [qw(Foo bar baz)]);