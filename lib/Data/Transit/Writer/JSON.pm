package Data::Transit::Writer::JSON;
use strict;
use warnings;
no warnings 'uninitialized';

use parent 'Data::Transit::Writer';

use JSON;
use Data::Transit::Cache;
use Carp qw(confess);

sub new {
	my ($class, $output, %args) = @_;
	my $self = $class->SUPER::new($output, %args);
	$self->{cache} = Data::Transit::Cache->new();
	return $self;
}

sub _wrap_scalar {
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
