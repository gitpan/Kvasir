#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Test::Exception;

use Kvasir::Constants;
use Kvasir::Engine;
use Kvasir::Hook::Perl;

# Single hook
my $engine = Kvasir::Engine->new();

$engine->add_hook(hook1 => "Kvasir::Hook::Perl" => sub {});
$engine->add_post_hook("hook1");

is_deeply($engine->_post_hooks, [qw(hook1)]);
# Multiple hooks

$engine = Kvasir::Engine->new();

$engine->add_hook(hook1 => "Kvasir::Hook::Perl" => sub {});
$engine->add_hook(hook2 => "Kvasir::Hook::Perl" => sub {});

$engine->add_post_hook("hook1");
$engine->add_post_hook("hook2");

is_deeply($engine->_post_hooks, [qw(hook1 hook2)]);
