use inc::Module::Install;

name     'DBICx-CORM';
all_from 'lib/DBICx/CORM.pm';
author   'Pedro Melo <melo@cpan.org>';

build_requires 'Test::More';

WriteAll;

