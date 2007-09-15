package Kvasir::Output;

use strict;
use warnings;

use Carp qw(croak);

sub new {
    my $self = shift;
    $self = ref $self || $self;
    croak "new() should not be called as a function" if !$self;
    croak "Class '$self' does not override new()";
}

sub pre_process {
    my $self = shift;
    $self = ref $self || $self;
    croak "pre_process() should not be called as a function" if !$self;
    croak "Class '$self' does not override pre_process()";
}

sub process {
    my $self = shift;
    $self = ref $self || $self;
    croak "process() should not be called as a function" if !$self;
    croak "Class '$self' does not override process()";
}

sub post_process {
    my $self = shift;
    $self = ref $self || $self;
    croak "post_process() should not be called as a function" if !$self;
    croak "Class '$self' does not override post_process()";
}

1;
__END__

=head1 NAME

Kvasir::Output - Interface for output classes

=head1 INTERFACE

=head2 CLASS METHODS

=over 4

=item new

Creates a new instance.

=back

=head2 INSTANCE METHODS

=over 4

=item pre_process ( $global )

=item process ( $global, $local )

=item post_process ( $global )

=back

=cut