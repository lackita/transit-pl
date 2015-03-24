package Data::Transit::Writer::JSONVerbose;
use strict;
use warnings;
no warnings 'uninitialized';

use parent 'Data::Transit::Writer';

use JSON;
use Carp qw(confess);

sub _wrap_scalar {
	my ($self, $converted_data) = @_;
	return {"~#'" => $converted_data};
}

sub _cache_convert {
	my ($self, $data) = @_;
	return $self->_convert($data);
}

sub _wrap_map {
	my ($self, %converted_map) = @_;
	return \%converted_map;
}

sub _wrap_custom {
	my ($self, $tag, $handled_data) = @_;
	return {$tag => $handled_data};
}

1;
