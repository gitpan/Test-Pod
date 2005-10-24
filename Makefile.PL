# $Id: Makefile.PL 101 2004-04-29 04:39:06Z andy $
use ExtUtils::MakeMaker;

WriteMakefile (
    'NAME'           => 'Test::Pod',
    'VERSION_FROM'   => 'Pod.pm',
    'PREREQ_PM'      => {
        'Pod::Simple'           => '2.04',
        'Test::More'            => '0.62',
        'Test::Builder::Tester' => '1.02',
        'File::Spec'            => 0,
    },
    clean => { FILES => 'Test-Pod-*' },
);

