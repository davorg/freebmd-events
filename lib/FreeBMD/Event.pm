package FreeBMD::Event;

use strict;
use warnings;

use CGI 'unescape';
use Carp;

use Moose;

our $VERSION = '0.01';

has 'type'     => (is => 'rw', isa => 'Str', required => 1);
has 'qtr'      => (is => 'rw', isa => 'Str', required => 1);
has 'year'     => (is => 'rw', isa => 'Int', required => 1);
has 'surname'  => (is => 'rw', isa => 'Str', required => 1);
has 'forename' => (is => 'rw', isa => 'Str', required => 1);
has 'age'      => (is => 'rw', isa => 'Int');
has 'district' => (is => 'rw', isa => 'Str', required => 1);
has 'volume'   => (is => 'rw', isa => 'Str', required => 1);
has 'page'     => (is => 'rw', isa => 'Str', required => 1);

my $template = '[ type ] Q[ qtr ] [ year ]
[ surname ] [ forename ]
[ district ] [ volume ] [ page ]';

=head2 $event->to_string

Return a string representation of an event.

=cut

sub to_string {
    my $self = shift;

    my $string = $template;

    $string =~ s/\[\s*(\w+)\s+]/$self->$1/eg;

    return $string;
}

1;
