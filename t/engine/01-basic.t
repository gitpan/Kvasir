#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Test::Exception;

BEGIN { use_ok("Kvasir::Engine"); }

my $engine = Kvasir::Engine->new();
isa_ok($engine, "Kvasir::Engine");
