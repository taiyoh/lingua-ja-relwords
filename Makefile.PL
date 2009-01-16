use inc::Module::Install;
name 'Lingua-JA-RelWords';
all_from 'lib/Lingua/JA/RelWords.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
