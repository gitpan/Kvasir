#!perl

use strict;
use warnings;

use Test::More tests => 18;

use Kvasir::Declare;

my $engine = engine {
    rule "rule1" => instanceof "Test::Kvasir::Rule";
    rule "rule2" => instanceof "Test::Kvasir::Rule" => with_args {
        start => 10,
    };
    
    rule "rule3" => does {
        1;
    };
    
    action "action1" => does {};
    action "action2" => does {};
    action "action3" => does {};
    
    run "action1" => when qw(rule1 rule2);
    run "action2" => when "rule2";
    run "action3" => when qw(rule3);
};

ok($engine->has_rule("rule1"));
my $rule = $engine->_get_rule("rule1");
ok(defined $rule);
is($rule->{pkg}, "Test::Kvasir::Rule");
is_deeply($rule->{args}, []);

ok($engine->has_rule("rule2"));
$rule = $engine->_get_rule("rule2");
ok(defined $rule);
is($rule->{pkg}, "Test::Kvasir::Rule");
is_deeply($rule->{args}, [{start => 10}]);

ok($engine->has_rule("rule3"));
$rule = $engine->_get_rule("rule3");
ok(defined $rule);
is($rule->{pkg}, "Kvasir::Rule::Perl");
is($rule->{args}->[0]->(), 1);

ok($engine->has_action("action1"));
ok($engine->has_action("action2"));
ok($engine->has_action("action3"));

is_deeply($engine->_rules->{rule1}->{actions}, ['action1']);
is_deeply($engine->_rules->{rule2}->{actions}, ['action1', 'action2']);
is_deeply($engine->_rules->{rule3}->{actions}, ['action3']);