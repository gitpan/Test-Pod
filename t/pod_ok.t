# $Id: pod_ok.t,v 1.1 2002/08/19 05:26:35 comdog Exp $
use strict;

use Test::Pod tests => 9;

pod_ok( "t/pod/good.pod" );
pod_ok( "t/pod/good.pod",         POD_OK       );
pod_ok( "t/pod/good.pod",         POD_WARNINGS );
pod_ok( "t/pod/good.pod",         POD_ERRORS   );

pod_ok( "t/pod/bad.pod",          POD_ERRORS   );

pod_ok( "t/pod/warning.pod",      POD_WARNINGS );
pod_ok( "t/pod/warning.pod",      POD_ERRORS   );

pod_ok( "t/pod/no_pod.pod",       NO_POD       );

pod_ok( "t/pod/doesnt_exist.pod", NO_FILE      );
