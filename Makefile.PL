# $Id: Makefile.PL,v 1.5 2002/08/29 22:08:06 comdog Exp $
use ExtUtils::MakeMaker;

use Test::Manifest qw(get_t_files);

WriteMakefile
        (
        'NAME'      => 'Test::Pod',
        'VERSION'   => '0.62',
 		'PREREQ_PM' => {
 			'IO::Null'       => undef,
 			'Pod::Checker'   => undef,
 			'Test::Manifest' => undef,
 			'Test::Builder'  => undef,
 			'Test::More'     => undef,
 			},
        'PM'        => 
        	{
            'lib/Pod.pm' => '$(INST_LIBDIR)/Pod.pm',
            },
 
		depend => { Makefile => 't/test_manifest' },
        test   => { TESTS => scalar get_t_files() },
        );

