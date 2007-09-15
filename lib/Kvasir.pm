package Kvasir;

use strict;
use warnings;

our $VERSION = "0.01";

1;
__END__

=head1 NAME

Kvasir - General rule engine for analysis and stuff like that

=head1 SYNOPSIS

  use Kvasir::Declare;
  
  my $engine = engine {
      prehook "has_more_email" => instanceof "MyApp::HasMoreEmails";
      
      # Returns an Email::Simple instance
      input "email" => instanceof "MyApp::GetEmail";
      
      input "from" => does {
            my $input = $_[KV_INPUT];
            return $input->get("email")->header("From");
      };
      
      rule "is_spam" => instanceof "MyApp::SpamDetector";
      
      rule "is_from_boss" => does {
          my $input = $_[KV_INPUT];
          
          if ($input->get("from") =~ /theboss@company\.com/) {
              return KV_MATCH;
          }
          
          return KV_NO_MATCH;
      }
      
      action "mark_for_deletion" => does {
          my $local = $_[KV_LOCAL];
          $local->set("delete-email" => 1);
      };
      
      trigger "mark_for_deletion"" => when qw(is_spam is_from_boss);
      
      post_hook "process_mail" => does {
          my ($input, $local) = @_[KV_INPUT, KV_LOCAL];
          
          if ($local->get("delete-mail") == 1) {
              MyApp::EmailHandler->delete($input->get("email"));
          }
          
          return KV_CONTINUE;
      };
  };
  
  $engine->run();

=head1 DESCRIPTION

Kvasir is a generic rule based processing engine. Processing is done while neither any pre nor post iteration hook 
aborts processing. Each engine supports multiple pre- and posthooks, inputs, output, actions and rules. An action is 
attached to one or several rules and is executed if any of the rules matches. Input is processed when needed and only 
once per iteration.

Multiple engines can be run in parallel in a runloop. Runloops can be ran until no more data is available for processing 
or by a single step at a time. This way multiple runloops may be executed simultaneously.

=head1 USAGE

Kvasir has a declarative interface via L<Kvasir::Declare> which is the simplest way to define engines. The synopsis shows 
an exmaple that could be implemented (with reservations for syntax errors).

=head2 Declarative interface

L<Kvasir::Declare>

=head2 Runloops

Runloops transforms engines into something executable and runs them.

L<Kvasir::Runloop>

=head2 Inputs, Outputs, Rules, Hooks, Actions

The components that makes up an engine.

L<Kvasir::Input>, L<Kvasir::Output>, L<Kvasir::Rule>, L<Kvasir::Hook>, L<Kvasir::Action>

=head1 BUGS AND LIMITATIONS

Please report any bugs or feature requests to C<bug-kvasir@rt.cpan.org>, 
or through the web interface at L<http://rt.cpan.org>.

=head1 AUTHOR

Claes Jakobsson C<< <claesjac@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2007, Versed Solutions C<< <info@versed.se> >>. All rights reserved.

This software is released under the MIT license cited below.

=head2 The "MIT" License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

=cut
