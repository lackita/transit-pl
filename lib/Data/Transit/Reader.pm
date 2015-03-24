package Data::Transit::Reader;
use strict;
use warnings;
no warnings 'uninitialized';

use JSON;

sub new {
	my ($class, %args) = @_;
	return bless {
		cache => [],
		cache_counter => 0,
	}, $class;
}

sub read {
	my ($self, $json) = @_;
	return $self->_convert(decode_json($json));
}

sub _convert_from_cached {
	my ($self, $data) = @_;
	if ($data =~ /^\^(\d+)$/) {
		return $self->{cache}->[$1];
	}
	$self->{cache}->[$self->{cache_counter}++] = $data;
	return $self->_convert($data);
}

sub _convert {
	my ($self, $json) = @_;
	if (ref($json) eq 'ARRAY') {
		return $json->[1] if $json->[0] eq "~#'";
		return $self->_convert_map($json) if $json->[0] eq "^ ";
		return [map {$self->_convert($_)} @$json];
	}
	return $json;
}

sub _convert_map {
	my ($self, $map) = @_;
	my %map = @{$map}[1..$#{$map}];
	return {map {$self->_convert_from_cached($_) => $self->_convert($map{$_})} keys %map};
}

1;
