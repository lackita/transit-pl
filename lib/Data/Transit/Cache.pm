package Data::Transit::Cache;
use strict;
use warnings;
no warnings 'uninitialized';

sub new {
	my ($class) = @_;
	bless {
		cache => {},
		counter => 0,
	}, $class;
}

sub contains {
	my ($self, $value) = @_;
	return defined $self->{cache}{$value};
}

sub set {
	my ($self, $value) = @_;
	$self->{cache}{$value} = $self->{counter}++;
}

sub get {
	my ($self, $value) = @_;
	return "^$self->{cache}{$value}" if length($value) > 3 && defined $self->{cache}{$value};
	return $value;
}

1;
