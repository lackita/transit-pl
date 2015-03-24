package Data::Transit::Writer::JSONVerbose;
use strict;
use warnings;
no warnings 'uninitialized';

use parent 'Data::Transit::Writer';

sub new {
	my ($self, $output, %args) = @_;
	for my $handler_class (keys %{$args{handlers}}) {
		$args{handlers}{$handler_class} = $args{handlers}{$handler_class}->getVerboseHandler();
	}
	return $self->SUPER::new($output, %args);
}

sub _wrap_top_level_scalar {
	my ($self, $converted_data) = @_;
	return {"~#'" => $converted_data};
}

sub _cache {
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