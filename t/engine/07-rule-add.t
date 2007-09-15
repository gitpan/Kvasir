#!perl

use strict;
use warnings;

use Test::More tests => 12;
use Test::Exception;

use Kvasir::Engine;

my $engine = Kvasir::Engine->new();

# Rule
throws_ok {
	$engine->add_rule(undef);
} qr/Name is undefined/;

throws_ok {
	$engine->add_rule(2342 => undef);
} qr/Name '2342' is invalid/;

throws_ok {
	$engine->add_rule(Foo => undef);
} qr/Rule is undefined/;

throws_ok {
	$engine->add_rule(Foo => "");
} qr/Rule '' doesn't look like a valid class name/;

throws_ok {
	$engine->add_rule(Foo => 2554);
} qr/Rule '2554' doesn't look like a valid class name/;

throws_ok {
	$engine->add_rule(Foo => bless({}, "Bar"));
} qr/Rule 'Bar' is an instance and not a class/;

throws_ok {
	$engine->add_rule(Foo => 'Kvasir::Rule::NonExistent');
} qr{Can't locate Kvasir/Rule/NonExistent.pm};

throws_ok {
	$engine->add_rule(Foo => "Kvasir::Action");	
} qr/Rule 'Kvasir::Action' does not conform to Kvasir::Rule/;

lives_ok {
	$engine->add_rule(Foo => "Kvasir::Rule");
};

# Getting
my $input = $engine->_get_rule("Foo");
is_deeply($input, {pkg => 'Kvasir::Rule', args => [], actions => []});

throws_ok {
	$engine->_get_rule("Bar");
} qr/Rule 'Bar' does not exist/;

is_deeply([$engine->rules], ['Foo']);

