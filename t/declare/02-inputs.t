#!perl

use strict;
use warnings;

use Test::More tests => 12;

use Kvasir::Declare;

my $engine = engine {
    input "input1" => instanceof "Test::Kvasir::Input";
    input "input2" => instanceof "Test::Kvasir::Input" => with_args {
        start => 10
    };
    
    input "input3" => does {
        1;
    };
};

ok($engine->has_input("input1"));
my $input = $engine->_get_input("input1");
ok(defined $input);
is($input->{pkg}, "Test::Kvasir::Input");
is_deeply($input->{args}, []);

ok($engine->has_input("input2"));
$input = $engine->_get_input("input2");
ok(defined $input);
is($input->{pkg}, "Test::Kvasir::Input");
is_deeply($input->{args}, [{start => 10}]);

ok($engine->has_input("input3"));
$input = $engine->_get_input("input3");
ok(defined $input);
is($input->{pkg}, "Kvasir::Input::Perl");
is($input->{args}->[0]->(), 1);