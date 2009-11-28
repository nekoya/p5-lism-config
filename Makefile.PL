use inc::Module::Install;
name 'Lism-Config';
all_from 'lib/Lism/Config.pm';

requires 'Config::YAML';
requires 'Any::Moose';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
