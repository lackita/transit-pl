package Data::Transit::Writer::JSON;
use strict;
use warnings;
no warnings 'uninitialized';

use parent 'Data::Transit::Writer';

sub _wrap_top_level_scalar {
	my ($self, $converted_data) = @_;
	return ["~#'", $converted_data];
}

sub _wrap_map {
	my ($self, @converted_map) = @_;
	return ["^ ", @converted_map];
}

sub _wrap_custom {
	my ($self, $tag, $handled_data) = @_;
	return [$tag, $handled_data];
}

1;
