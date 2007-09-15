#!perl

use strict;
use warnings;

use Test::More tests => 26;

use Kvasir::Declare;

my $engine = engine {
    prehook "hook1" => instanceof "Test::Kvasir::Hook";
    prehook "hook2" => instanceof "Test::Kvasir::Hook" => with_args {
        start => 10
    };
    
    prehook "hook3" => does {
        1;
    };

    posthook "hook4" => instanceof "Test::Kvasir::Hook";
    posthook "hook5" => instanceof "Test::Kvasir::Hook" => with_args {
        start => 10
    };
    
    posthook "hook6" => does {
        1;
    };
};

ok($engine->has_hook("hook1"));

my $hook = $engine->_get_hook("hook1");
ok(defined $hook);
is($hook->{pkg}, "Test::Kvasir::Hook");
is_deeply($hook->{args}, []);

ok($engine->has_hook("hook2"));
$hook = $engine->_get_hook("hook2");
ok(defined $hook);
is($hook->{pkg}, "Test::Kvasir::Hook");
is_deeply($hook->{args}, [{start => 10}]);

ok($engine->has_hook("hook3"));
$hook = $engine->_get_hook("hook3");
ok(defined $hook);
is($hook->{pkg}, "Kvasir::Hook::Perl");
is($hook->{args}->[0]->(), 1);

is_deeply($engine->_pre_hooks, [qw(hook1 hook2 hook3)]);

ok($engine->has_hook("hook4"));
$hook = $engine->_get_hook("hook4");
ok(defined $hook);
is($hook->{pkg}, "Test::Kvasir::Hook");
is_deeply($hook->{args}, []);

ok($engine->has_hook("hook5"));
$hook = $engine->_get_hook("hook5");
ok(defined $hook);
is($hook->{pkg}, "Test::Kvasir::Hook");
is_deeply($hook->{args}, [{start => 10}]);

ok($engine->has_hook("hook6"));
$hook = $engine->_get_hook("hook6");
ok(defined $hook);
is($hook->{pkg}, "Kvasir::Hook::Perl");
is($hook->{args}->[0]->(), 1);

is_deeply($engine->_post_hooks, [qw(hook4 hook5 hook6)]);
