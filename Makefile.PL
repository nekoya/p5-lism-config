use inc::Module::Install;
name 'Lism-Config';
all_from 'lib/Lism/Config.pm';

requires 'Any::Moose';
requires 'Config::YAML';

author_tests('xt');

test_requires 'Test::More';
test_requires 'Test::Exception';
include 'Sub::Uplevel';

use_test_base;
auto_include;
WriteAll;
