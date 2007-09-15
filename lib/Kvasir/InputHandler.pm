package Kvasir::InputHandler;

use strict;
use warnings;

use Carp qw(croak);
use Scalar::Util qw(refaddr);

my %InputCache;

sub new {
    my ($pkg, %inputs) = @_;
    my $self = bless \%inputs, $pkg;

    $InputCache{refaddr $self} = {};

    return $self;
}

sub _clear {
    my $self = shift;
    
    my $caller = caller;
    croak "You are not allowed to clear the input" if $caller ne "Kvasir::Engine";
    
    $InputCache{refaddr $self} = {};
}

sub DESTROY {
    my $self = shift;
    
    delete $InputCache{refaddr $self};
}

sub get {
    my ($self, $input) = @_;
    
    my $addr = refaddr $self;
    my $cache = $InputCache{$addr};
    if (exists $cache->{$input}) {
        return $cache->{$input};
    }
    
    croak "I don't know anything about '${input}'" if !exists $self->{$input};
    
    my $value = $self->{$input}->value();
    $cache->{$input} = $value;
    
    return $value;
}

1;
__END__

=head1 NAME

Kvasir::InputManager - Manages input retrieval

=head1 INTERFACE

=head2 CLASS METHODS

=over 4

=item new ( INPUTS )

Creates a new input manager for the given I<INPUTS>. I<INPUTS> must be a list of key/value pairs.

=back

=head2 INSTANCE METHODS

=over 4

=item get ( INPUT )

Retrieves the value from the input whose name is I<INPUT>. If the input does not exist an exception is thrown.

=back

None

=cut
