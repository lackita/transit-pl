use strict;
use warnings;
no warnings 'uninitialized';

use lib 't/lib';

use Point;
use PointReadHandler;
use Test::More;
use Data::Transit;

# scalars
is_decoded_to('["~#\'",null]', undef);
is_decoded_to('["~#\'","foo"]', "foo");
is_decoded_to('["~#\'",1]', 1);

# arrays
is_decoded_to('[]', []);
is_decoded_to('["foo"]', ["foo"]);

# maps
is_decoded_to('["^ "]', {});
is_decoded_to('[["^ "]]', [{}]);
is_decoded_to('["^ ","foo",1]', {foo => 1});
is_decoded_to('[["^ ","foo",1],"bar"]', [{foo => 1}, "bar"]);
is_decoded_to('["^ ","foo",["^ ","bar",1]]', {foo => {bar => 1}});

# caching
is_decoded_to('[["^ ","foo",1,"fooo",1],["^ ","foo",1,"^0",1]]',[{foo => 1, fooo => 1}, {foo => 1, fooo => 1}]);
is_decoded_to('[["^ ","fooo",1],["^ ","^0",1]]', [{fooo => 1}, {fooo => 1}]);

# custom handlers
is_decoded_to('["~#point","2,3"]', Point->new(2,3), {point => PointReadHandler->new()});
is_decoded_to('[["~#point","2,3"],["^0","3,4"]]', [Point->new(2,3), Point->new(3,4)], {point => PointReadHandler->new()});

# types not in base perl
is_decoded_to('["^ ","~_",1]', {"" => 1});
is_decoded_to('["~#\'",true]', 1);
is_decoded_to('["~#\'",false]', 0);
is_decoded_to('["^ ","~?t",1]', {1 => 1});
is_decoded_to('["^ ","~?f",1]', {0 => 1});
is_decoded_to('["~#\'","~i123"]', 123);
is_decoded_to('["~#\'","~d123.456"]', 123.456);

done_testing();

sub is_decoded_to {
	my ($json, $data, $handlers) = @_;
	my $reader = Data::Transit::reader("json", handlers => $handlers);
	return is_deeply($reader->read($json), $data);
}
