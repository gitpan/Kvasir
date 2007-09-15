#!perl

use strict;
use warnings;

use Test::More tests => 2;

use Kvasir::Engine;

my $engine = Kvasir::Engine->new();

$engine->add_rule(foo => "Test::Kvasir::Rule");
$engine->add_rule(baz => "Test::Kvasir::Rule");
$engine->add_rule(bar => "Test::Kvasir::Rule");

is_deeply([$engine->rule_order], [qw(foo baz bar)]);

$engine->set_rule_order(qw(foo bar baz));

is_deeply([$engine->rule_order], [qw(foo bar baz)]);