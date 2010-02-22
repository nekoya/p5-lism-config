use strict;
use warnings;

use Test::More tests => 2;

use FindBin;

use Lism::Config;

my $filename = "$FindBin::Bin/mock/test.yaml";
ok my $conf = Lism::Config->new(filename => $filename), 'create instance';
is $conf->filename, $filename, 'assert filename';
