package Kvasir::Hook;

use strict;
use warnings;

use Carp qw(croak);

sub new {
    my $self = shift;
    $self = ref $self || $self;
    croak "new() should not be called as a function" if !$self;
    croak "Class '$self' does not override new()";
}

sub invoke {
    my $self = shift;
    $self = ref $self || $self;
    croak "invoke() should not be called as a function" if !$self;
    croak "Class '$self' does not override invoke()";
}

1;
__END__

=head1 NAME

Kvasir::Hook - Base class for engine hooks

=head1 INTERFACE

=head2 CLASS METHODS

=over 4

=item new 

Returns a new instance.

=back

=head2 INSTANCE METHODS

=over 4

=item invoke

This method is invoked by the engine and should return either VA_ABORT (to stop execution) or VA_CONTINUE.

=cut