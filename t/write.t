use strict;
use warnings;

use Test::More;
use Data::Transit;

# scalars
is(Data::Transit::writer()->write("foo"), '["~#\'","foo"]');
is(Data::Transit::writer()->write(1), '["~#\'",1]');
is(Data::Transit::writer()->write(undef), '["~#\'",null]');

# arrays
is(Data::Transit::writer()->write([]), '[]');
is(Data::Transit::writer()->write(["foo"]), '["foo"]');

# maps
is(Data::Transit::writer()->write({}), "[\"^ \"]");
is(Data::Transit::writer()->write([{}]), "[[\"^ \"]]");
is(Data::Transit::writer()->write({foo => 1}), '["^ ","foo",1]');
is(Data::Transit::writer()->write([{foo => 1}, "bar"]), '[["^ ","foo",1],"bar"]');

# caching
is(Data::Transit::writer()->write([{fooo => 1}, {fooo => 1}]), '[["^ ","fooo",1],["^ ","^0",1]]');
is(Data::Transit::writer()->write([{foo => 1}, {foo => 1}]), '[["^ ","foo",1],["^ ","foo",1]]');

done_testing();
