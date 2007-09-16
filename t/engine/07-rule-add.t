#!perl

use strict;
use warnings;

use Test::More tests => 14;
use Test::Exception;

use Kvasir::Engine;
use Test::Kvasir::Rule;

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
} qr/Rule is an instance that does not conform to Kvasir::Rule/;

throws_ok {
	$engine->add_rule(Foo => 'Kvasir::Rule::NonExistent');
} qr{Can't locate Kvasir/Rule/NonExistent.pm};

throws_ok {
	$engine->add_rule(Foo => "Kvasir::Action");	
} qr/Rule 'Kvasir::Action' does not conform to Kvasir::Rule/;

lives_ok {
	$engine->add_rule(Foo => "Kvasir::Rule");
};

throws_ok {
	$engine->add_rule(Foo => "Kvasir::Rule");    
} qr/Rule 'Foo' is already defined/;

lives_ok {
	$engine->add_rule(Bar => Test::Kvasir::Rule->new());
};

# Getting
my $input = $engine->_get_rule("Foo");
isa_ok($input, "Kvasir::TypeDecl");

throws_ok {
	$engine->_get_rule("Baz");
} qr/Rule 'Baz' does not exist/;

is_deeply([sort $engine->rules], [qw(Bar Foo)]);

