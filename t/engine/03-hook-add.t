#!perl

use strict;
use warnings;

use Test::More tests => 11;
use Test::Exception;

use Kvasir::Engine;
use Test::Kvasir::Hook;

my $engine = Kvasir::Engine->new();

# Pre hook
throws_ok {
	$engine->add_hook(undef);
} qr/Name is undefined/;

throws_ok {
	$engine->add_hook("_Foo");
} qr/Name '_Foo' is invalid/;

throws_ok {
	$engine->add_hook(Foo => 0);
} qr/Hook '0' doesn't look like a valid class name/;

throws_ok {
	$engine->add_hook(Foo => "");
} qr/Hook '' doesn't look like a valid class name/;

throws_ok {
	$engine->add_hook(Foo => bless {}, "Foo");
} qr/Hook is an instance that does not conform to Kvasir::Hook/;

throws_ok {
	$engine->add_hook(Foo => "Kvasir::Input::NonExistent");
} qr{Can't locate Kvasir/Input/NonExistent.pm};

throws_ok {
	$engine->add_hook(Foo => "Kvasir::Rule");	
} qr/Hook 'Kvasir::Rule' does not conform to Kvasir::Hook/;

lives_ok {
	$engine->add_hook(Foo => "Kvasir::Hook");
};

throws_ok {
	$engine->add_hook(Foo => "Kvasir::Hook");    
} qr/Hook 'Foo' is already defined/;

lives_ok {
    $engine->add_hook(Bar => Test::Kvasir::Hook->new());
};

ok($engine->has_hook("Foo"));