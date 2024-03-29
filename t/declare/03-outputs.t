#!perl

use strict;
use warnings;

use Test::More tests => 15;

use Kvasir::Declare;

use lib 't/lib';

use Test::Kvasir::Output;

my $output_obj = Test::Kvasir::Output->new();

my $engine = engine {
    output "output1" => instanceof "Test::Kvasir::Output";
    output "output2" => instanceof "Test::Kvasir::Output" => with_args {
        start => 10
    };
    
    output "output3" => does {
        1;
    };
    
    output "output4" => $output_obj;
};

ok($engine->has_output("output1"));
my $output = $engine->_get_output("output1");
ok(defined $output);
is($output->_pkg, "Test::Kvasir::Output");
is_deeply($output->_args, []);

ok($engine->has_output("output2"));
$output = $engine->_get_output("output2");
ok(defined $output);
is($output->_pkg, "Test::Kvasir::Output");
is_deeply($output->_args, [start => 10]);

ok($engine->has_output("output3"));
$output = $engine->_get_output("output3");
ok(defined $output);
is($output->_pkg, "Kvasir::Output::Perl");
is($output->_args->[0]->(), 1);

ok($engine->has_output("output4"));
$output = $engine->_get_output("output4");
ok(defined $output);
ok($output->_pkg == $output_obj);