# $Id: all_pod_files.t,v 1.2 2003/11/10 15:02:08 petdance Exp $
use strict;

use Test::More tests => 2;
use File::Spec;

BEGIN {
    use_ok( "Test::Pod" );
}

my @files = Test::Pod::all_pod_files( "blib" );
my @expected = (
    File::Spec->catfile( qw( blib lib Test Pod.pm ) ),
);
is_deeply( \@files, \@expected, "Got all the distro files" );
