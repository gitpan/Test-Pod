# $Id: Makefile.PL,v 1.13 2003/11/10 05:41:57 petdance Exp $
use ExtUtils::MakeMaker;

WriteMakefile (
    'NAME'           => 'Test::Pod',
    'VERSION_FROM'   => 'lib/Pod.pm',
    'PREREQ_PM'      => {
	'Pod::Simple'           => '2.04',
	'Test::More'            => '0',
	'Test::Builder::Tester' => '0',
	'File::Find'		=> '0',
    },
    'PM' => {
	'lib/Pod.pm' => '$(INST_LIBDIR)/Pod.pm',
    },
    'MAN3PODS' => {
	'lib/Pod.pm' => '$(INST_MAN3DIR)/Test::Pod.3',
    },

    clean => { FILES => 'Test-Pod-*' },
);

