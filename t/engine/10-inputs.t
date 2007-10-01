#!perl

use strict;
use warnings;

use Test::More tests => 14;
use Test::Exception;

use Kvasir::Constants;
use Kvasir::Data;
use Kvasir::Declare;

my $cnt = 0;

my $engine = engine {
    input "Foo1" => does {
        $cnt++;
        return $cnt;
    };
    
    input "Foo2" => does {
        my ($self, $input, $global, $local) = @_[KV_SELF, KV_INPUT, KV_GLOBAL, KV_LOCAL];
        
        isa_ok($self, "Kvasir::Input::Perl");
        isa_ok($input, "Kvasir::InputHandler");
        isa_ok($global, "Kvasir::Data");
        isa_ok($local, "Kvasir::Data");
        isnt($global, $local);        
    }
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

throws_ok {
    $input->set_global("global");
} qr/Not a Kvasir::Data instance/;

throws_ok {
    $input->set_local("local");
} qr/Not a Kvasir::Data instance/;

lives_ok {
    $input->set_global(Kvasir::Data->new());    
};

lives_ok {
    $input->set_local(Kvasir::Data->new());    
};

$input->get("Foo2");