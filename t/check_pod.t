# $Id: check_pod.t,v 1.2 2002/08/19 05:43:13 comdog Exp $
use strict;

use Test::More tests => 5;

BEGIN { require Test::Pod; Test::Pod->import };

my $hash = Test::Pod::_check_pod( "t/pod/good.pod" );
ok( $hash->{result} eq POD_OK, "Pod file without errors" );

   $hash = Test::Pod::_check_pod( "t/pod/bad.pod" );
ok( $hash->{result} eq POD_ERRORS, "Pod file with errors"  );

SKIP: {
	skip "Waiting on Pod::Checker fix", 1 
		unless UNIVERSAL::can( 'Pod::Checker', 'num_warnings' );
		
   $hash = Test::Pod::_check_pod( "t/pod/warning.pod" );
ok( $hash->{result} eq POD_WARNINGS, "Pod file with errors"  );
};

   $hash = Test::Pod::_check_pod( "t/pod/no_pod.pod" );
ok( $hash->{result} eq NO_POD, "File with no pod directives"  );

   $hash = Test::Pod::_check_pod( "t/pod/doesnt_exist.pod" );
ok( $hash->{result} eq NO_FILE, "No file found"  );
