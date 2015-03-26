package Data::Transit;
use strict;
use warnings;
no warnings 'uninitialized';

use Carp qw(confess);
use Data::Transit::Reader::JSON;
use Data::Transit::Reader::MessagePack;
use Data::Transit::Reader::JSONVerbose;
use Data::Transit::Writer::JSON;
use Data::Transit::Writer::JSONVerbose;
use Data::Transit::Writer::MessagePack;

=head1 NAME

Data::Transit - Perl implementation of the transit format

=head1 VERSION

Version 0.8.01

=cut

our $VERSION = '0.8.01';

sub reader {
	my ($format, %args) = @_;
	return Data::Transit::Reader::JSON->new(%args) if $format eq 'json';
	return Data::Transit::Reader::JSONVerbose->new(%args) if $format eq 'json-verbose';
	return Data::Transit::Reader::MessagePack->new(%args) if $format eq 'message-pack';
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
