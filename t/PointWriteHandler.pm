package PointWriteHandler;

sub new {
	my ($class) = @_;
	return bless {}, $class;
}

sub tag {
	return 'point';
}

sub rep {
	my ($self, $p) = @_;
	return [$p->{x},$p->{y}];
}

sub stringRep {
	return undef;
}

1;
