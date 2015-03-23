package Data::Transit;
use strict;
use warnings;
no warnings 'uninitialized';

use Data::Transit::Writer::JSON;

sub writer {
	my ($format, $output, %args) = @_;
	return Data::Transit::Writer::JSON->new($output, %args);
}

1;
