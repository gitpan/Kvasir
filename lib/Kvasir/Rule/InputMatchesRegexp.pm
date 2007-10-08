package Kvasir::Rule::InputMatchesRegexp;

use strict;
use warnings;

use Kvasir::Constants;

use base qw(Kvasir::Rule);

sub new {
    my ($pkg, %args) = @_;
    
    # Compile regexps
    my %re;
    while (my ($input, $re) = each %args) {
        $re{$input} = $re;
    }
    my $self = bless { %re }, $pkg;
    
    return $self;
}

sub evaluate {
    my ($self, $input) = @_;
    
    # If we have nothing to match aginst it's a no match
    return KV_NO_MATCH unless %{$self};
    
    # The order we evaulate each change in is not relevant
    while (my ($name, $re) = each %{$self}) {
        my $v1 = $input->get($name);

        if ($v1 !~ $re) {
            return KV_NO_MATCH;
        }
    }
    
    # All thresholds passed therefore we have a match
    return KV_MATCH;
}

1;
__END__

=head1 NAME

Kvasir::Rule::InputMatchesRegexp - Generic rule for matching inputs against regular expressions

=head1 SYNOPSIS

  use Kvasir::Declare;
  
  my $engine = engine {
      rule 'valid_name' => instanceof Kvasir::Rule::InputMatchesRegexp => with_args {
          'name' => qr/^\w+$/;
      }
  }
  
=head1 DESCRIPTION

This is a generic rule that matches input against regular expressions (Perl5). All 
defined inputs must match their respective regexp for the rule to match. If no 
inputs are defined or any input doesn't match its regexp the rule does not match.

=head1 USAGE

=head2 Rule arguments

This rule expects a hash reference as its argument, which is what C<< with_args >> provides, 
where the key is the name of an input and the value is the regexp to match against. 

=begin PRIVATE

=over 4

=item new

L<Kvasir::Rule/new>

=item evaluate

L<Kvasir::Rule/evaulate>

=back

=end PRIVATE

=cut
