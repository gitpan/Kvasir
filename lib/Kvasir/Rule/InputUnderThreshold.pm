package Kvasir::Rule::InputUnderThreshold;

use strict;
use warnings;

use Kvasir::Constants;

use base qw(Kvasir::Rule);

sub new {
    my ($pkg, %args) = @_;
    my $self = bless { %args }, $pkg;
    return $self;
}

sub evaluate {
    my ($self, $input) = @_;
    
    # If we have nothing to match aginst it's a no match
    return KV_NO_MATCH unless %{$self};
    
    # The order we evaulate each change in is not relevant
    while (my ($name, $change) = each %{$self}) {
        my $v1 = $input->get($name);

        if ($change && ($v1 / $change) >= 1) {
            return KV_NO_MATCH;
        }
        
        if (!$change && $v1) {
            return KV_NO_MATCH;
        }
    }
    
    # All thresholds passed therefore we have a match
    return KV_MATCH;
}

1;

=head1 NAME

Kvasir::Rule::InputUnderThreshold - Generic rule for checking input thresholds

=head1 SYNOPSIS

  use Kvasir::Declare;
  
  my $engine = engine {
      rule 'valid_name' => instanceof Kvasir::Rule::InputUnderThreshold => with_args {
          'input_1' => 5,
          'input_2' => -5,
      }
  }
  
=head1 DESCRIPTION

This is a generic rule that checks if the value from an input is does not pass a 
threshold relative to 0. This can be used to model change matrices where a row 
represets a rule.

The following table shows the conditions when it matches

  Input | Threshold | Result
  ------+-----------+-------
  x     | 0         | match
  > y   | y > 0     | no match
  > y   | y < 0     | match 
  < y   | y < 0     | no match
  < y   | y > 0     | match
    
=head1 USAGE

=head2 Rule arguments

This rule expects a hash reference as its argument, which is what C<< with_args >> provides, 
where the key is the name of an input and the value is the expected threshold value. 

=begin PRIVATE

=over 4

=item new

L<Kvasir::Rule/new>

=item evaluate

L<Kvasir::Rule/evaulate>

=back

=end PRIVATE

=cut
