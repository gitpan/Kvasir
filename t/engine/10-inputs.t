#!perl

use strict;
use warnings;

use Test::More tests => 5;
use Test::Exception;

use Kvasir::Declare;

my $cnt = 0;

my $engine = engine {
    input "Foo1" => does {
        $cnt++;
        return $cnt;
    };
};

my $input = $engine->_input_handler;
is($input->get("Foo1"), 1);
is($input->get("Foo1"), 1);

throws_ok {
    $input->_clear();
} qr/You are not allowed to clear the input/;

{
    # Small trick because only Kvasir::Engine may clear inputs
    package Kvasir::Runloop;
    $input->_clear();
}

is($input->get("Foo1"), 2);
is($input->get("Foo1"), 2);
