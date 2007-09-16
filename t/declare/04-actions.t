#!perl

use strict;
use warnings;

use Test::More tests => 15;

use Kvasir::Declare;
use Test::Kvasir::Action;

my $action_obj = Test::Kvasir::Action->new();

my $engine = engine {
    action "action1" => instanceof "Test::Kvasir::Action";
    action "action2" => instanceof "Test::Kvasir::Action" => with_args {
        start => 10
    };
    
    action "action3" => does {
        1;
    };
    
    action "action4" => $action_obj;
};

ok($engine->has_action("action1"));
my $action = $engine->_get_action("action1");
ok(defined $action);
is($action->_pkg, "Test::Kvasir::Action");
is_deeply($action->_args, []);

ok($engine->has_action("action2"));
$action = $engine->_get_action("action2");
ok(defined $action);
is($action->_pkg, "Test::Kvasir::Action");
is_deeply($action->_args, [{start => 10}]);

ok($engine->has_action("action3"));
$action = $engine->_get_action("action3");
ok(defined $action);
is($action->_pkg, "Kvasir::Action::Perl");
is($action->_args->[0]->(), 1);

ok($engine->has_action("action4"));
$action = $engine->_get_action("action4");
ok(defined $action);
ok($action->_pkg == $action_obj);