# $Id: Makefile.PL,v 1.12 2003/10/12 03:50:46 petdance Exp $
use ExtUtils::MakeMaker;

WriteMakefile (
    'NAME'           => 'Test::Pod',
    'VERSION_FROM'   => 'lib/Pod.pm',
    'PREREQ_PM'      => {
	'Pod::Simple'           => '2.04',
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

