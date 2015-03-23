package PointWriteHandler;

sub new {
	my ($class) = @_;
	return bless {}, $class;
}

sub tag {
	return 'point';
}

sub rec {
	my ($self, $p) = @_;
	return [$p->{x},$p->{y}];
}

sub string_rep {
	return undef;
}

1;
