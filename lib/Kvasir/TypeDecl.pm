package Kvasir::TypeDecl;

use strict;
use warnings;

use Carp qw(croak);
use Scalar::Util qw(blessed);

sub new {
    my ($pkg, $type, @args) = @_;
    my $self = bless [$type, \@args], $pkg;
    return $self;
}

sub instantiate {
    my $self = shift;
    my $instance = blessed $self->_pkg ? $self->_pkg : $self->_pkg->new(@{$self->_args});
    return $instance;
}

sub _pkg {
    my $self = shift;
    return $self->[0];
}

sub _args {
    my $self = shift;
    return $self->[1];
}

1;
__END__

=head1 NAME

Kvasir::TypeDecl - Helper class for maintaining types used in engines

=head1 SYNOPSIS

  use Kvasir::TypeDecl;
  
  # Will create a Foo::Bar instance by calling new in Foo::Bar
  my $type1 = Kvasir::TypeDecl->new("Foo::Bar");
  my $obj1 = $type1->instantiate();
  
  # Will keep around an already existing reference to an object
  # and return that when instantiating.
  my $existing_obj = get_some_object();
  my $type2 = Kvasir::TypeDecl->new($existing_obj);
  my $obj2 = $type2->instantiate();

=head1 INTERFACE

=head2 CLASS METHODS

=over 4

=item new ( TARGET [, ARGS ... ])

Wraps a type. If I<TARGET> is an object it will be returned when instantiating the type. If not 
C<new> will be called on I<TARGET> with any I<ARGS> passed as a list.

=back

=head2 INSTANCE METHODS

=over 4

=item instantiate

Instantiates the type. See C<new> above for semantics.

=back

=cut
  