#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Kvasir::Engine;

BEGIN { use_ok("Kvasir::Declare"); }

my $engine = engine {};
isa_ok($engine, "Kvasir::Engine");
