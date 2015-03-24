use strict;
use warnings;
no warnings 'uninitialized';

use Test::More;
use Data::Transit;
use JSON;

# scalars
is_decoded_to(["~#'",undef], undef);
is_decoded_to(["~#'","foo"], "foo");
is_decoded_to(["~#'",1], 1);

# arrays
is_decoded_to([], []);
is_decoded_to(["foo"], ["foo"]);

# maps
is_decoded_to(["^ "], {});
is_decoded_to([["^ "]], [{}]);
is_decoded_to(["^ ", "foo", 1], {foo => 1});
is_decoded_to([["^ ", "foo", 1], "bar"], [{foo => 1}, "bar"]);
is_decoded_to(["^ ", "foo", ["^ ", "bar", 1]], {foo => {bar => 1}});

# caching
# is_decoded_to([["^ ", "foo", 1],["^ ", "foo", 1]], [{foo => 1}, {foo => 1}]);
is_decoded_to([["^ ", "fooo", 1],["^ ","^0",1]], [{fooo => 1}, {fooo => 1}]);

done_testing();

sub is_decoded_to {
	my ($json, $data, $handlers) = @_;
	my $reader = Data::Transit::reader("json", handlers => $handlers);
	return is_deeply($reader->read(encode_json($json)), $data);
}
