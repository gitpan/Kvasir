#!perl

use strict;
use warnings;

use Test::More tests => 5;

use Kvasir::Constants;
use Kvasir::Data;
use Kvasir::Engine;
use Kvasir::Runloop;

my $engine = Kvasir::Engine->new();
$engine->add_hook(hook1 => "Kvasir::Hook::Perl", undef, sub { 
    my $global = $_[KV_GLOBAL];
    isa_ok($global, "Kvasir::Data");
    is_deeply([$global->keys], []);
    
    return KV_ABORT;
});

$engine->add_pre_hook("hook1");

my $runloop = Kvasir::Runloop->new();
$runloop->add_engine($engine);
$runloop->run();

# Using a global data
my $data = Kvasir::Data->new();
$data->set(test => 1);

$engine = Kvasir::Engine->new();
$engine->add_hook(hook1 => "Kvasir::Hook::Perl", undef, sub { 
    my $global = $_[KV_GLOBAL];
    isa_ok($global, "Kvasir::Data");
    ok($global->exists("test"));
    is($global->get("test"), 1);
    return KV_ABORT;
});

$engine->add_pre_hook("hook1");

$runloop = Kvasir::Runloop->new();
$runloop->add_engine($engine, $data);
$runloop->run();
