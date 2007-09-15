#!perl

use 5.00602;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Kvasir',
    VERSION_FROM        => 'lib/Kvasir.pm',
    LICENSE             => 'MIT',
    PREREQ_PM           => {
        Scalar::Util            => 0,
        Test::More              => 0,
        Test::Exception         => 0,
        List::Util              => 0,
        Object::Tiny            => 0,
        Test::AbstractMethod    => 0,
    },
    ABSTRACT_FROM       => 'lib/Kvasir.pm', 
    AUTHOR              => 'Claes Jakobsson <claesjac@cpan.org>',
    test               =>  {TESTS => 't/*/*.t'},
);