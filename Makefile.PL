#!perl

use 5.00602;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Kvasir',
    VERSION_FROM        => 'lib/Kvasir.pm',
    LICENSE             => 'MIT',
    PREREQ_PM           => {
        List::Util              => 0,
        Object::Tiny            => 0,
        Scalar::Util            => 0,
        Test::AbstractMethod    => 0,
        Test::Exception         => 0,
        Test::More              => 0,
    },
    ABSTRACT_FROM       => 'lib/Kvasir.pm', 
    AUTHOR              => 'Claes Jakobsson <claesjac@cpan.org>',
    test               =>  {TESTS => 't/*/*.t'},
);