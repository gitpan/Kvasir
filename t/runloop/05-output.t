#!perl

use strict;
use warnings;

use Test::More tests => 5;

use Kvasir::Constants;
use Kvasir::Engine;
use Kvasir::Runloop;

# Test create _mk_runloop
my $i = 0;

# Actions
my $engine = Kvasir::Engine->new();
$engine->add_output(output1 => "Kvasir::Output::Perl", undef, sub { ok(++$i == 1); });

my $cb = Kvasir::Runloop::_mk_runloop($engine);
$cb->();

# Arguments
$engine = Kvasir::Engine->new();
$engine->add_output(output1 => "Kvasir::Output::Perl", undef, sub { 
    my ($self, $input, $global, $local) = @_[KV_SELF, KV_INPUT, KV_GLOBAL, KV_LOCAL];

    isa_ok($self, "Kvasir::Output::Perl");
    isa_ok($input, "Kvasir::InputHandler");
    isa_ok($global, "Kvasir::Data");
    isa_ok($local, "Kvasir::Data");
});

$cb = Kvasir::Runloop::_mk_runloop($engine);
$cb->();
