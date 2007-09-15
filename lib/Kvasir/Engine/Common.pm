package Kvasir::Engine;

use strict;
use warnings;

use Scalar::Util qw(blessed);

use Kvasir::Util qw(is_valid_name is_valid_package_name);

sub _check_add_args {
    my ($self, $type, $has, $name, $obj) = @_;
    
    croak "Name is undefined" if !defined $name;
	croak "Name '${name}' is invalid" if !is_valid_name($name);
	croak "${type} is undefined" if !defined $obj;
	
	croak "${type} '${name}' is already defined" if $has->($self, $name);
	
	if (blessed $obj) {
		croak "${type} '", ref($obj), "' is an instance and not a class name";
	}
	else {
		croak "${type} '${obj}' doesn't look like a valid class name" if !is_valid_package_name($obj);
		eval "require ${obj};";
		croak $@ if $@;
		
		croak "${type} '${obj}' does not conform to Kvasir::${type}" if !UNIVERSAL::isa($obj, "Kvasir::${type}");
	}
	
	1;
}

1;
__END__

=head1 NAME

Kvasir::Engine (Common) - Common private methods for the engine

=cut