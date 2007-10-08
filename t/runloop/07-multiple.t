#!perl

use strict;
use warnings;

use Test::More tests => 2;

use Kvasir::Constants;
use Kvasir::Runloop;
use Kvasir::Engine;

my $i = 0;

my $engine1 = Kvasir::Engine->new();
$engine1->add_hook(hook1 => "Kvasir::Hook::Perl", undef, sub { ok(++$i == 1); return KV_ABORT; });
$engine1->add_pre_hook("hook1");

my $engine2 = Kvasir::Engine->new();
$engine2->add_hook(hook1 => "Kvasir::Hook::Perl", undef, sub { ok(++$i == 2); return KV_ABORT; });
$engine2->add_pre_hook("hook1");

my $runloop = Kvasir::Runloop->new();
$runloop->add_engine($engine1);
$runloop->add_engine($engine2);

$runloop->run();
