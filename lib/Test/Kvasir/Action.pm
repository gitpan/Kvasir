package Test::Kvasir::Action;

use strict;
use warnings;

use Carp qw(croak);

use base qw(Kvasir::Action);

sub new {
    my ($pkg, $args) = @_;
    $args = $args || {};
    my $self = bless { %$args }, $pkg;
    return $self;
}

1;
__END__

=head1 NAME

Test::Kvasir::Action - Test action class

=head1 INTERFACE

=head2 CLASS METHODS

=over 4

=item new

Creates a new instace.

=back

=cut