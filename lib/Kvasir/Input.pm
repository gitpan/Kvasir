package Kvasir::Input;

use strict;
use warnings;

use Carp qw(croak);

sub new {
    my $self = shift;
    $self = ref $self || $self;
    croak "new() should not be called as a function" if !$self;
    croak "Class '$self' does not override new()";
}

sub value {
    my $self = shift;
    $self = ref $self || $self;
    croak "value() should not be called as a function" if !$self;
    croak "Class '$self' does not override value()";
}

1;
__END__

=head1 NAME

Kvasir::Input - Base class for providers of rule data

=head1 INTERFACE

=head2 CLASS METHODS

=over 4

=item new 

Should return a new instance.

=back

=head2 INSTANCE METHODS

=over 4

=item value

Called by the engine when a value is requested.

=back

=cut