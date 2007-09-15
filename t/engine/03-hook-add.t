#!perl

use strict;
use warnings;

use Test::More tests => 9;
use Test::Exception;

use Kvasir::Constants;
use Kvasir::Engine;

my $engine = Kvasir::Engine->new();

# Pre hook
throws_ok {
	$engine->add_hook(undef);
} qr/Name is undefined/;

throws_ok {
	$engine->add_hook("_foo");
} qr/Name '_foo' is invalid/;

throws_ok {
	$engine->add_hook(foo => 0);
} qr/Hook '0' doesn't look like a valid class name/;

throws_ok {
	$engine->add_hook(foo => "");
} qr/Hook '' doesn't look like a valid class name/;

throws_ok {
	$engine->add_hook(foo => bless {}, "Foo");
} qr/Hook 'Foo' is an instance and not a class/;

throws_ok {
	$engine->add_hook(foo => "Kvasir::Input::NonExistent");
} qr{Can't locate Kvasir/Input/NonExistent.pm};

throws_ok {
	$engine->add_hook(foo => "Kvasir::Rule");	
} qr/Hook 'Kvasir::Rule' does not conform to Kvasir::Hook/;

lives_ok {
	$engine->add_hook(foo => "Kvasir::Hook");
};

ok($engine->has_hook("foo"));