package Kvasir::Rule::Perl;

use strict;
use warnings;

use Carp qw(croak);

use base qw(Kvasir::Cv Kvasir::Rule);

sub evaluate {
    my $self = shift;
    return $self->($self, @_);
}

1;
__END__

=head1 NAME

Kvasir::Rule::Perl - Use a code reference as an rule

=cut

=head1 INTERFACE

=head2 CLASS METHODS

=over 4

=item new ( CODE )

Creates a new instance. The argument I<CODE> must be a reference to a subroutine - either 
anoynmous or named.

=back

=head2 INSTANCE METHODS

=over 4

=item evaluate

Calls the subroutine.

=back

None
