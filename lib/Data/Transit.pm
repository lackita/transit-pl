package Data::Transit;
use strict;
use warnings;

use Data::Transit::Writer;

sub writer {
	my ($format, $output) = @_;
	return Data::Transit::Writer->new($format, $output);
}

1;
