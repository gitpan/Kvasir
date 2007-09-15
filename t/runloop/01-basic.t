#!perl

use strict;
use warnings;

use Test::More tests => 9;
use Test::Exception;

use Scalar::Util qw(refaddr);

BEGIN { use_ok("Kvasir::Runloop"); }

use Kvasir::Constants;
use Kvasir::Engine;

my $runloop = Kvasir::Runloop->new();
ok(defined $runloop);
isa_ok($runloop, "Kvasir::Runloop");
ok(refaddr $runloop == $$runloop);

throws_ok {
    $runloop->add_engine(undef);
} qr/Engine is undefined/;

throws_ok {
    $runloop->add_engine("foo");
} qr/Engine is not a Kvasir::Engine instance/;

throws_ok {
    $runloop->add_engine(bless {}, "Foo");
} qr/Engine is not a Kvasir::Engine instance/;

my $engine = Kvasir::Engine->new();

lives_ok {
    $runloop->add_engine($engine);
};

throws_ok {
    $runloop->add_engine($engine);
} qr/Engine already exists/;
