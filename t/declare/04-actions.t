#!perl

use strict;
use warnings;

use Test::More tests => 12;

use Kvasir::Declare;

my $engine = engine {
    action "action1" => instanceof "Test::Kvasir::Action";
    action "action2" => instanceof "Test::Kvasir::Action" => with_args {
        start => 10
    };
    
    action "action3" => does {
        1;
    };
};

ok($engine->has_action("action1"));
my $action = $engine->_get_action("action1");
ok(defined $action);
is($action->{pkg}, "Test::Kvasir::Action");
is_deeply($action->{args}, []);

ok($engine->has_action("action2"));
$action = $engine->_get_action("action2");
ok(defined $action);
is($action->{pkg}, "Test::Kvasir::Action");
is_deeply($action->{args}, [{start => 10}]);

ok($engine->has_action("action3"));
$action = $engine->_get_action("action3");
ok(defined $action);
is($action->{pkg}, "Kvasir::Action::Perl");
is($action->{args}->[0]->(), 1);
