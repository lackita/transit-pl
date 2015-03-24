package Data::Transit;
use strict;
use warnings;
no warnings 'uninitialized';

use Carp qw(confess);
use Data::Transit::Writer::JSON;
use Data::Transit::Writer::JSONVerbose;

sub writer {
	my ($format, $output, %args) = @_;
	return Data::Transit::Writer::JSON->new($output, %args) if $format eq 'json';
	return Data::Transit::Writer::JSONVerbose->new($output, %args) if $format eq 'json-verbose';
	confess "unknown format: $format";
}

1;
