package Test::Kvasir::Rule;

use strict;
use warnings;

use Carp qw(croak);

use base qw(Kvasir::Rule);

sub new {
    my ($pkg, %args) = @_;
    my $self = bless { %args }, $pkg;
    return $self;
}

1;
__END__

=head1 NAME

Test::Kvasir::Rule - Test rule class

=head1 INTERFACE

=head2 CLASS METHODS

=over 4

=item new

Creates a new instace.

=back

=cut