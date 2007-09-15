package Kvasir::Util;

use strict;
use warnings;

use Carp qw(croak);

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT = qw();
our @EXPORT_OK = qw(
    is_existing_package
    is_valid_name 
    is_valid_package_name
);

our %EXPORT_TAGS = ();

sub is_valid_name {
    my $name = pop;
    
    return $name =~ m/^ [A-Za-z] [A-Za-z0-9_]* $/x;
}

sub is_valid_package_name {
    my $pkg = pop;
    
    return $pkg =~ m/[[:alpha:]_] \w* (?: (?: :: | ') \w+ )*/x; #
}

sub is_existing_package {
    my $pkg = pop;
    no strict 'refs';
    return defined %{"${pkg}::"} ? 1 : 0;
}

1;
__END__

=head1 NAME

Kvasir::Util - Utility functions for Kvasir

=head1 INTERFACE

=head2 FUNCTIONS

=over 4

=item is_existing_package ( PACKAGE )

Checks if the package I<PACKAGE> exists or not.

=item is_valid_name ( NAME )

Checks if the given I<NAME> is a valid name to assign inputs, outputs, hooks, rules and actions.

=item is_valid_package_name ( NAME )

Checks if the given I<NAME> is a valid package name or not.

=back

=cut
