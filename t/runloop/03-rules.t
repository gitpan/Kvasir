#!perl

use strict;
use warnings;

use Test::More tests => 6;

use Kvasir::Constants;
use Kvasir::Engine;
use Kvasir::Runloop;

# Test create _mk_runloop
my $i = 0;

# Rules
my $engine = Kvasir::Engine->new();
$engine->add_rule(rule1 => "Kvasir::Rule::Perl" => sub { ok(++$i == 1); return KV_NO_MATCH; });
$engine->add_rule(rule2 => "Kvasir::Rule::Perl" => sub { ok(++$i == 2); return KV_MATCH; });

# This should never be ran and if it does it'll produce an error
$engine->add_rule(rule3 => "Kvasir::Rule::Perl" => sub { ok(0); return KV_MATCH; }); 

my $cb = Kvasir::Runloop::_mk_runloop($engine);
$cb->();

# Arguments
$engine = Kvasir::Engine->new();
$engine->add_rule(hook1 => "Kvasir::Rule::Perl" => sub {
    my ($self, $input, $global, $local) = @_[KV_SELF, KV_INPUT, KV_GLOBAL, KV_LOCAL];

    isa_ok($self, "Kvasir::Rule::Perl");
    isa_ok($input, "Kvasir::InputHandler");
    isa_ok($global, "Kvasir::Data");
    isa_ok($local, "Kvasir::Data");
});

$cb = Kvasir::Runloop::_mk_runloop($engine);
$cb->();