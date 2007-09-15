package Kvasir::Engine;

use strict;
use warnings;

use Carp qw(croak);

use Kvasir::Engine::Common;

sub add_output {
	my ($self, $name, $output, @args) = @_;
    $self->_check_add_args('Output', \&has_output, $name, $output);
	$self->_outputs->set($name => {pkg => $output, args => \@args});
}

sub outputs {
	my $self = shift;
	return $self->_outputs->keys;
}

sub has_output {
    my ($self, $name) = @_;
    return $self->_outputs->exists($name);
}

sub _get_output {
	my ($self, $name) = @_;

	if ($self->has_output($name)) {
		return $self->_outputs->get($name);
	}

	croak "Can't find output '$name'";
}

1;
__END__

=head1 NAME

Kvasir::Engine (Output) - Output management

=head1 SEE ALSO

L<Kvasir::Engine>.

=cut