package Data::Transit::Writer;
use strict;
use warnings;
no warnings 'uninitialized';

use JSON;
use Carp qw(confess);
use Scalar::Util qw(reftype);

sub new {
	my ($class, $format, $output) = @_;
	bless {
		cache => {},
		cache_counter => 0,
		output => $output,
	}, $class;
}

sub write {
	my ($self, $data, @remainder) = @_;
	confess("write only takes one argument") if scalar(@remainder) > 0;

 	my $output = $self->{output};
	if (reftype($data) ne '') {
		print $output encode_json($self->convert($data));
	} else {
		print $output encode_json(["~#'", $self->convert($data)]);
	}
}

sub convert {
	my ($self, $data) = @_;
	return $self->_convert_array($data) if reftype($data) eq 'ARRAY';
	return $self->_convert_map($data) if reftype($data) eq 'HASH';
	return $data;
}

sub cache_convert {
	my ($self, $data) = @_;
	if (length($data) > 3 && defined $self->{cache}{$data}) {
		return "^$self->{cache}{$data}";
	} else {
		$self->{cache}{$data} = $self->{cache_counter}++;
	}
	return $self->convert($data);
}

sub _convert_array {
	my ($self, $array) = @_;
	return [map {$self->convert($_)} @$array];
}

sub _convert_map {
	my ($self, $map) = @_;
	return ["^ ", map {
		$self->cache_convert($_) => $self->convert($map->{$_})
	} keys %$map];
}

1;
