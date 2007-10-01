#!perl

use strict;
use warnings;

use Test::More tests => 8;

BEGIN { use_ok("Kvasir::TypeDecl"); }

my $obj = bless {}, "Foo";
my $type = Kvasir::TypeDecl->new($obj);
isa_ok($type, "Kvasir::TypeDecl");
ok($obj == $type->instantiate);

{
    package A;
    sub new {
        my ($pkg, @args) = @_;
        ::is($pkg, "A");
        ::is(@args, 0);
        return bless {}, $pkg;
    }
}

$type = Kvasir::TypeDecl->new("A");
$obj = $type->instantiate();
isa_ok($obj, "A");

{
    package B;
    sub new {
        my ($pkg, @args) = @_;
        ::is(@args, 2);
        ::is_deeply([@args], [qw(foo baz)]);
        return bless {}, $pkg;
    }
}

$type = Kvasir::TypeDecl->new("B", "foo", "baz");
$obj = $type->instantiate();
