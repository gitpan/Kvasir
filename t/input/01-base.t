#!perl

use strict;
use warnings;

use Test::More tests => 4;
use Test::AbstractMethod;

BEGIN { use_ok("Kvasir::Input"); }

for my $method (qw(value)) {
	call_abstract_method_ok("Kvasir::Input", $method);
	call_abstract_class_method_ok("Kvasir::Input", $method);
	call_abstract_function_ok("Kvasir::Input", $method);
}