# $Id: Makefile.PL,v 1.3 2002/08/20 20:15:29 comdog Exp $
use ExtUtils::MakeMaker;

use Test::Manifest qw(get_t_files);

WriteMakefile
        (
        'NAME'      => 'Test::Pod',
        'VERSION'   => '0.6',
 		'PREREQ_PM' => {
 			'Test::Builder' => undef,
 			'Test::More'  => undef,
 			'Pod::Checker'  => undef,
 			},
        'PM'        => 
        	{
            'lib/Pod.pm' => '$(INST_LIBDIR)/Pod.pm',
            },
 
 		depend => { Makefile => 't/test_manifest' },
        test   => { TESTS => scalar get_t_files() },
        );

