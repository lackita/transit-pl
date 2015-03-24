package Data::Transit;
use strict;
use warnings;
no warnings 'uninitialized';

use Carp qw(confess);
use Data::Transit::Reader::JSON;
use Data::Transit::Writer::JSON;
use Data::Transit::Writer::JSONVerbose;
use Data::Transit::Writer::MessagePack;

sub reader {
	my ($format, %args) = @_;
	return Data::Transit::Reader::JSON->new(%args) if $format eq 'json';
	confess "unknown reader format: $format";
}

sub writer {
	my ($format, $output, %args) = @_;
	return Data::Transit::Writer::JSON->new($output, %args) if $format eq 'json';
	return Data::Transit::Writer::JSONVerbose->new($output, %args) if $format eq 'json-verbose';
	return Data::Transit::Writer::MessagePack->new($output, %args) if $format eq 'message-pack';
	confess "unknown writer format: $format";
}

1;
