
BEGIN {

    # For historical reasons, alias *Types::Bool with JSON::PP::Boolean
    *Types::Bool:: = *JSON::PP::Boolean::;

    # JSON/PP/Boolean.pm is redundant
    $INC{'JSON/PP/Boolean.pm'} ||= __FILE__
      unless $ENV{TYPES_BOOL_NICE};
}

package Types::Bool;

# ABSTRACT: Booleans as objects for Perl

use 5.005;

sub new { bless \( my $dummy = $_[1] ? 1 : 0 ), $_[0] }

BEGIN {
    require overload;
    if ( $ENV{TYPES_BOOL_LOUD} ) {
        my @o = grep __PACKAGE__->overload::Method($_), qw(0+ ++ --);
        my @s = grep __PACKAGE__->can($_), qw(true false is_bool);
        push @s, '$VERSION' if $Types::Bool::VERSION;
        if ( @o || @s ) {
            my $p = ref do { bless \( my $dummy ), __PACKAGE__ };
            my @f;
            push @f, join( ', ', @s ) if @s;
            push @f, 'overloads on ' . join( ', ', @o ) if @o;
            warn join( ' and ', @f ), qq{ defined for $p elsewhere};
        }
    }

    overload->import(
        '0+' => sub { ${ $_[0] } },
        '++' => sub { $_[0] = ${ $_[0] } + 1 },
        '--' => sub { $_[0] = ${ $_[0] } - 1 },
        fallback => 1,
    ) unless __PACKAGE__->overload::Method('0+');

    require constant;
    constant->import( true => __PACKAGE__->new(1) )
      unless __PACKAGE__->can('true');
    constant->import( false => __PACKAGE__->new(0) )
      unless __PACKAGE__->can('false');

    unless ( __PACKAGE__->can('is_bool') ) {
        require Scalar::Util;
        *is_bool = sub ($) { Scalar::Util::blessed( $_[0] ) and $_[0]->isa(__PACKAGE__) };
    }

    $Types::Bool::VERSION = '2.98010'
      unless $Types::Bool::VERSION;

    $Types::Bool::ALT_VERSION = '2.98010';
}

sub to_bool ($) { $_[0] ? true : false }

@Types::Bool::EXPORT_OK = qw(true false is_bool to_bool);

BEGIN {
    if ( "$]" < 5.008003 ) {    # Inherit from Exporter (if needed)
        require Exporter;
        my $EXPORTER_VERSION = Exporter->VERSION;
        $EXPORTER_VERSION =~ tr/_//d;
        push @Types::Bool::ISA, qw(Exporter) if $EXPORTER_VERSION < 5.57;
    }
}

sub import {                  # Load Exporter only if needed
    return unless @_ > 1;

    require Exporter;

    no warnings 'redefine';
    *import = sub {
        return unless @_ > 1;
        goto &Exporter::import;
    };
    goto &Exporter::import;
}

1;
