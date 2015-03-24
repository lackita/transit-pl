package Data::Transit::Writer;
use strict;
use warnings;
no warnings 'uninitialized';

use Data::Transit::Cache;
use JSON;
use Carp qw(confess);

sub new {
	my ($class, $output, %args) = @_;
	bless {
		%args,
		output => $output,
		cache => Data::Transit::Cache->new(),
	}, $class;
}

sub write {
	my ($self, $data, @remainder) = @_;
	confess("write only takes one argument") if scalar(@remainder) > 0;

	my $output = $self->{output};
	if (ref($data) ne '') {
		print $output encode_json($self->_convert($data));
	} else {
		print $output encode_json($self->_wrap_top_level_scalar($self->_convert($data)));
	}
}

sub _convert {
	my ($self, $data) = @_;
	return $self->_convert_array($data) if ref($data) eq 'ARRAY';
	return $self->_convert_map($data) if ref($data) eq 'HASH';
	return $data if ref($data) eq '';
	return $self->_convert_custom($data);
}

sub _cache_convert {
	my ($self, $data) = @_;
	return $self->_convert($self->_cache($data));
}

sub _cache {
	my ($self, $data) = @_;
	if (length($data) > 3 && $self->{cache}->contains($data)) {
		return $self->{cache}->get($data);
	} else {
		$self->{cache}->set($data);
	}
	return $data;
}

sub _convert_array {
	my ($self, $array) = @_;
	return [map {$self->_convert($_)} @$array];
}

sub _convert_map {
	my ($self, $map) = @_;
	return $self->_wrap_map(map {
		$self->_cache_convert($_) => $self->_convert($map->{$_})
	} keys %$map);
}

sub _convert_custom {
	my ($self, $data) = @_;
	my $handler = $self->{handlers}->{ref($data)};
	return $self->_convert($self->_wrap_custom($self->_cache("~#" . $handler->tag($data)), $handler->rep($data)));
}

1;
