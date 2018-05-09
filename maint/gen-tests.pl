#!/usr/bin/env perl

use 5.014;
use strict;
use warnings;

use Path::Class qw(file);

for my $m (qw(Types::Serialiser JSON::PP Cpanel::JSON::XS)) {
    for (qw(t/02-basic.t t/03-is-bool.t t/04-to-bool.t)) {
        my $t = file($_);

        my $d = $m =~ s/::/-/gr;

        {    # Before
            my $content = $t->slurp =~ s/(^use Types::Bool.*$)/use $m ();\n$1\n/smr;

            my $n = file( 't', join( '-', 'before', $d, $t->basename ) );
            $n->parent->mkpath unless -e $n->parent;
            $n->spew($content);
            say $n;
        }

        {    # After
            my $content = $t->slurp =~ s/(^use Types::Bool.*$)/$1\nuse $m ();\n/smr;

            my $n = file( 't', join( '-', 'after', $d, $t->basename ) );
            $n->parent->mkpath unless -e $n->parent;
            $n->spew($content);
            say $n;
        }

    }
}
