# $Id: check_pod.t,v 1.3 2002/09/06 04:06:12 comdog Exp $

use Test::More tests => 5;

use Test::Pod;

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
