#!perl

use strict;
use warnings;

use Test::More tests => 14;
use Test::Exception;

use Kvasir::Engine;
use Test::Kvasir::Action;

my $engine = Kvasir::Engine->new();

# Action
throws_ok {
	$engine->add_action(undef);
} qr/Name is undefined/;

throws_ok {
	$engine->add_action(2342 => undef);
} qr/Name '2342' is invalid/;

throws_ok {
	$engine->add_action(Foo => undef);
} qr/Action is undefined/;

throws_ok {
	$engine->add_action(Foo => "");
} qr/Action '' doesn't look like a valid class name/;

throws_ok {
	$engine->add_action(Foo => 2554);
} qr/Action '2554' doesn't look like a valid class name/;

throws_ok {
	$engine->add_action(Foo => bless({}, "Bar"));
} qr/Action is an instance that does not conform to Kvasir::Action/;

throws_ok {
	$engine->add_action(Foo => 'Kvasir::Action::NonExistent');
} qr{Can't locate Kvasir/Action/NonExistent.pm};

throws_ok {
	$engine->add_action(Foo => "Kvasir::Rule");	
} qr/Action 'Kvasir::Rule' does not conform to Kvasir::Action/;

lives_ok {
	$engine->add_action(Foo => "Kvasir::Action");
};

throws_ok {
	$engine->add_action(Foo => "Kvasir::Action");    
} qr/Action 'Foo' is already defined/;

lives_ok {
	$engine->add_action(Bar => Test::Kvasir::Action->new());
};

# Getting
my $input = $engine->_get_action("Foo");
is($input->_pkg, "Kvasir::Action");

throws_ok {
	$engine->_get_action("Baz");
} qr/Can't find action 'Baz'/;

is_deeply([sort $engine->actions], [qw(Bar Foo)]);