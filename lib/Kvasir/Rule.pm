package Kvasir::Rule;

use strict;
use warnings;

use Carp qw(croak);

sub new {
    my $self = shift;
    $self = ref $self || $self;
    croak "new() should not be called as a function" if !$self;
    croak "Class '$self' does not override new()";
}


sub evaluate {
    my $self = shift;
    $self = ref $self || $self;
    croak "evaluate() should not be called as a function" if !$self;
    croak "Class '$self' does not override evaluate()";
}

1;
__END__

=head1 NAME

Kvasir::Rule - Interface for rules

=head1 INTERFACE

=head2 CLASS METHODS

=over 4

=item new

Creates a new instance.

=back

=head2 INSTANCE METHODS

=over 4

=item evaluate ( $global, $local )

Evaluates the rule.

=back
 
=cut
