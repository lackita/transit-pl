use strict;
use warnings;

use Test::More;
use Data::Transit;

# scalars
is_converted_to("foo", '["~#\'","foo"]');
is_converted_to(1, '["~#\'",1]');
is_converted_to(undef, '["~#\'",null]');

# arrays
is_converted_to([], '[]');
is_converted_to(["foo"], '["foo"]');

# maps
is_converted_to({}, "[\"^ \"]");
is_converted_to([{}], "[[\"^ \"]]");
is_converted_to({foo => 1}, '["^ ","foo",1]');
is_converted_to([{foo => 1}, "bar"], '[["^ ","foo",1],"bar"]');

# caching
is_converted_to([{fooo => 1}, {fooo => 1}], '[["^ ","fooo",1],["^ ","^0",1]]');
is_converted_to([{foo => 1}, {foo => 1}], '[["^ ","foo",1],["^ ","foo",1]]');

done_testing();

sub is_converted_to {
	my ($data, $json) = @_;
	my $output;
	open my ($output_fh), '>>', \$output;
	Data::Transit::writer("json", $output_fh)->write($data);
	is($output, $json);
}
