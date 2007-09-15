#!perl

use strict;
use warnings;

use Test::More tests => 12;

use Kvasir::Declare;

my $engine = engine {
    output "output1" => instanceof "Test::Kvasir::Output";
    output "output2" => instanceof "Test::Kvasir::Output" => with_args {
        start => 10
    };
    
    output "output3" => does {
        1;
    };
};

ok($engine->has_output("output1"));
my $output = $engine->_get_output("output1");
ok(defined $output);
is($output->{pkg}, "Test::Kvasir::Output");
is_deeply($output->{args}, []);

ok($engine->has_output("output2"));
$output = $engine->_get_output("output2");
ok(defined $output);
is($output->{pkg}, "Test::Kvasir::Output");
is_deeply($output->{args}, [{start => 10}]);

ok($engine->has_output("output3"));
$output = $engine->_get_output("output3");
ok(defined $output);
is($output->{pkg}, "Kvasir::Output::Perl");
is($output->{args}->[0]->(), 1);
