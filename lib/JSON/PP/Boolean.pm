
use Types::Bool ();

package JSON::PP::Boolean;

$JSON::PP::Boolean::VERSION = '2.98004'
  unless $JSON::PP::Boolean::VERSION;

1;

=encoding utf8

=head1 NAME

JSON::PP::Boolean - dummy module providing JSON::PP::Boolean

=head1 SYNOPSIS

 # do not "use" yourself

=head1 DESCRIPTION

This module exists only to provide overload resolution for Storable and similar modules. See
L<Types::Bool> for more info about this class.

=head1 AUTHOR

This idea is from L<JSON::XS::Boolean> written by Marc Lehmann.

=cut

