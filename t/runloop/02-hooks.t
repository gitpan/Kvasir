#!perl

use strict;
use warnings;

use Test::More tests => 12;

use Kvasir::Constants;
use Kvasir::Engine;
use Kvasir::Runloop;

my $i = 0;
my $engine = Kvasir::Engine->new();
$engine->add_hook(hook1 => "Kvasir::Hook::Perl", undef, sub { ok(++$i == 1) });
$engine->add_pre_hook("hook1");
$engine->add_hook(hook2 => "Kvasir::Hook::Perl", undef, sub { ok(++$i == 2) });
$engine->add_pre_hook("hook2");
my $cb = Kvasir::Runloop::_mk_runloop($engine);
$cb->();

$engine = Kvasir::Engine->new();
$engine->add_hook(hook1 => "Kvasir::Hook::Perl", undef, sub { ok(++$i == 3) });
$engine->add_post_hook("hook1");
$engine->add_hook(hook2 => "Kvasir::Hook::Perl", undef, sub { ok(++$i == 4) });
$engine->add_post_hook("hook2");
$cb = Kvasir::Runloop::_mk_runloop($engine);
$cb->();

# Arguments
$engine = Kvasir::Engine->new();
$engine->add_hook(hook1 => "Kvasir::Hook::Perl", undef, sub {
    my ($self, $input, $global, $local) = @_[KV_SELF, KV_INPUT, KV_GLOBAL, KV_LOCAL];

    isa_ok($self, "Kvasir::Hook::Perl");
    isa_ok($input, "Kvasir::InputHandler");
    isa_ok($global, "Kvasir::Data");
    isa_ok($local, "Kvasir::Data");
});

$engine->add_pre_hook("hook1");
$engine->add_post_hook("hook1");

$cb = Kvasir::Runloop::_mk_runloop($engine);
$cb->();