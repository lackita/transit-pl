package Data::Transit::Writer;
use strict;
use warnings;
no warnings 'uninitialized';

use JSON;
use Data::Transit::Cache;
use Carp qw(confess);

sub new {
	my ($class, $format, $output, %args) = @_;
	bless {
		%args,
		cache => Data::Transit::Cache->new(),
		output => $output,
	}, $class;
}

sub write {
	my ($self, $data, @remainder) = @_;
	confess("write only takes one argument") if scalar(@remainder) > 0;

	my $output = $self->{output};
	if (ref($data) ne '') {
		print $output encode_json($self->convert($data));
	} else {
		print $output encode_json(["~#'", $self->convert($data)]);
	}
}

sub convert {
	my ($self, $data) = @_;
	return $self->_convert_array($data) if ref($data) eq 'ARRAY';
	return $self->_convert_map($data) if ref($data) eq 'HASH';
	return $data if ref($data) eq '';

	my $handler = $self->{handlers}->{ref($data)};
	return $self->convert(["~#" . $handler->tag($data), $handler->rec($data)]);
}

sub cache_convert {
	my ($self, $data) = @_;
	if (length($data) > 3 && $self->{cache}->contains($data)) {
		return $self->{cache}->get($data);
	} else {
		$self->{cache}->set($data);
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
