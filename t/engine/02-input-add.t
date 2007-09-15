#!perl

use strict;
use warnings;

use Test::More tests => 12;
use Test::Exception;

use Kvasir::Engine;

my $engine = Kvasir::Engine->new();

# Input
throws_ok {
	$engine->add_input(undef);
} qr/Name is undefined/;

throws_ok {
	$engine->add_input(2342 => undef);
} qr/Name '2342' is invalid/;

throws_ok {
	$engine->add_input(Foo => undef);
} qr/Input is undefined/;

throws_ok {
	$engine->add_input(Foo => "");
} qr/Input '' doesn't look like a valid class name/;

throws_ok {
	$engine->add_input(Foo => 2554);
} qr/Input '2554' doesn't look like a valid class name/;

throws_ok {
	$engine->add_input(foo => bless {}, "Foo");
} qr/Input 'Foo' is an instance and not a class/;

throws_ok {
	$engine->add_input(Foo => 'Kvasir::Input::NonExistent');
} qr{Can't locate Kvasir/Input/NonExistent.pm};

throws_ok {
	$engine->add_input(Foo => "Kvasir::Rule");	
} qr/Input 'Kvasir::Rule' does not conform to Kvasir::Input/;

lives_ok {
	$engine->add_input(Foo => "Kvasir::Input");
};

# Getting
my $input = $engine->_get_input("Foo");
is($input->{pkg}, "Kvasir::Input");

throws_ok {
	$engine->_get_input("Bar");
} qr/Can't find input 'Bar'/;

is_deeply([$engine->inputs], ['Foo']);