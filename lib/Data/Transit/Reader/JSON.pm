package Data::Transit::Reader::JSON;
use strict;
use warnings;
no warnings 'uninitialized';

use parent 'Data::Transit::Reader';

use JSON;

sub _decode {
	my ($self, $data) = @_;
	return decode_json($data);
}

1;
