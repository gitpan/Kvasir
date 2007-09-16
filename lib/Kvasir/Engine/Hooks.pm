use strict;
use warnings;

use Carp qw(croak);

use Kvasir::Engine::Common;

sub add_hook {
	my ($self, $name, $hook, @args) = @_;
    $self->_check_add_args('Hook', \&has_hook, $name, $hook);
	$self->_hooks->{$name} = {pkg => $hook, args => \@args};
}

sub hooks {
	my $self = shift;
	return $self->_hooks->keys;
}

sub has_hook {
    my ($self, $name) = @_;
    return $self->_hooks->exists($name);
}

sub _get_hook {
	my ($self, $name) = @_;

	if ($self->has_hook($name)) {
		return $self->_hooks->get($name);
	}
    else {
	    croak "Can't find hook '$name'";
    }
}

sub add_pre_hook {
    my ($self, $name) = @_;
    
    if ($self->has_hook($name)) {
        push @{$self->_pre_hooks}, $name;
    }
    else {
        croak "Can't add hook '$name' because it does not exist";
    }
}

sub add_post_hook {
    my ($self, $name) = @_;
    
    if ($self->has_hook($name)) {
        push @{$self->_post_hooks}, $name;
        return;
    }
    else {
        croak "Can't add hook '$name' because it does not exist";
    }
}

1;
__END__