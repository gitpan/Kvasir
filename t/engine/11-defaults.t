#!perl

use lib 't/lib';

use strict;
use warnings;

use Test::More tests => 6;
use Test::Exception;

use Test::Kvasir::Action;
use Test::Kvasir::Hook;
use Test::Kvasir::Input;
use Test::Kvasir::Output;
use Test::Kvasir::Rule;

use Kvasir::Engine;

my $engine = Kvasir::Engine->new();

ok(!$engine->has_defaults("d1"));

$engine->add_defaults(d1 => { foo => 1 });

ok($engine->has_defaults("d1"));

throws_ok {
   $engine->add_defaults("d1" => {});
} qr/Defaults 'd1' is already defined/;

throws_ok {
   $engine->add_defaults("d2" => []);
} qr/Expected hash reference but got 'ARRAY'/;

$engine->add_action("a1" => "Test::Kvasir::Action", [qw(d1)]);
my $action = $engine->_get_action("a1")->instantiate($engine);
is($action->{foo}, 1);

$engine->add_action("a2" => "Test::Kvasir::Action", [qw(d1)], foo => 2);
$action = $engine->_get_action("a2")->instantiate($engine);
is($action->{foo}, 2);
