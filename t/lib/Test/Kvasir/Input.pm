package Test::Kvasir::Input;

use strict;
use warnings;

use Carp qw(croak);

use base qw(Kvasir::Input);

sub new {
    my ($pkg, %args) = @_;
    my $self = bless { %args }, $pkg;
    return $self;
}

1;
__END__

=head1 NAME

Test::Kvasir::Input - Test input class

=head1 INTERFACE

=head2 CLASS METHODS

=over 4

=item new

Creates a new instace.

=back

=cut