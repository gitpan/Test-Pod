# $Id: Makefile.PL,v 1.11 2003/02/25 03:45:54 petdance Exp $
use ExtUtils::MakeMaker;

WriteMakefile (
    'NAME'           => 'Test::Pod',
    'VERSION_FROM'   => 'lib/Pod.pm',
    'PREREQ_PM'      => {
	'IO::Scalar'            => '0',
	'Pod::Simple'           => '0',
	'Test::More'            => '0',
	'Test::Builder::Tester' => '0',
    },
    'PM' => {
	'lib/Pod.pm' => '$(INST_LIBDIR)/Pod.pm',
    },
    'MAN3PODS' => {
	'lib/Pod.pm' => '$(INST_MAN3DIR)/Test::Pod.3',
    },

    clean => { FILES => 'Test-Pod-*' },
);

