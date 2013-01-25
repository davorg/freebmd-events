package FreeBMD::Events;

use strict;
use warnings;

use CGI 'unescape';
use Carp;

use FreeBMD::Event;

our $VERSION = '0.01';

my @types = qw(B D M);

=head2 FreeBMD::Events->parse($file)

Parse a file of data and return an array of FreeBMD::Event objects

=cut

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

1;
