#!perl

use strict;
use warnings;

use Test::More tests => 4;
use Test::AbstractMethod;

BEGIN { use_ok("Kvasir::Rule"); }

for my $method (qw(evaluate)) {
	call_abstract_method_ok("Kvasir::Rule", $method);
	call_abstract_class_method_ok("Kvasir::Rule", $method);
	call_abstract_function_ok("Kvasir::Rule", $method);
}