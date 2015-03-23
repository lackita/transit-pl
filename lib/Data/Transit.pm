package Data::Transit;
use strict;
use warnings;

use Data::Transit::Writer;

sub writer {
	return Data::Transit::Writer->new();
}

1;
