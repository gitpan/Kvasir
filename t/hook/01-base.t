#!perl

use strict;
use warnings;

use Test::More tests => 4;
use Test::AbstractMethod;

BEGIN { use_ok("Kvasir::Hook") }

for my $method (qw(invoke)) {
	call_abstract_method_ok("Kvasir::Hook", $method);
	call_abstract_class_method_ok("Kvasir::Hook", $method);
	call_abstract_function_ok("Kvasir::Hook", $method);
}

