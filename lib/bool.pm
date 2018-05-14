
BEGIN {
    require Types::Bool;
    *bool:: = *Types::Bool::
}

package bool;

# ABSTRACT: Booleans as objects for Perl

1;
