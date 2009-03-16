package FreeBMD::Events;

use strict;
use warnings;

use CGI 'unescape';
use Carp;

our $VERSION = '0.01';

my @types = qw(B D M);

sub parse {
    my $class = shift;
    my $file = shift;

    open my $fh, '<', $file or croak "$file: $!";

    $_ = do { local $/; <$fh> };

    my ($text) = /var searchData = new Array \(\s*\n(.+?)\)/s;

    my @data = map { s/^"//; s/",$//; $_ } split /\n/, unescape $text;

    my %prev;
    my @events;
    while (my @rec = splice @data, 0, 2) {
	my %cur;
	@cur{'type', 'qtr', 'year'} = (split /;/, $rec[0])[1, 2 ,3];
        @cur{'surname', 'forename', 'age', 'district', 'volume', 'page'} =
          (split /;/, $rec[1])[1,2,3,5,6,7];

        $cur{type} = $types[$cur{type}];
        $cur{qtr}  = "Q$cur{qtr}";

        for (keys %cur) {
            $cur{$_} ||= $prev{$_} || '';
            delete $cur{$_} unless $cur{$_} =~ /\S/;
        }

        %prev = %cur;

        push @events, FreeBMD::Event->new(\%cur);

        if (@data && $data[0] =~ /^\d/) {
	    $rec[1] = shift @data;
	    redo;
	}
    }

    return @events;
}

package FreeBMD::Event;

use Moose;

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

sub to_string {
    my $self = shift;

    my $string = $template;

    $string =~ s/\[\s*(\w+)\s+]/$self->$1/eg;

    return $string;
}

1;
