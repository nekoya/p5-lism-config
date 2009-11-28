use strict;
use warnings;

use Test::More tests => 2;

use FindBin;
use FindBin::libs;
use Lism::Config;

ok my $conf = Lism::Config->new( filename => "$FindBin::Bin/mock/test.yaml" );
is $conf->filename, "$FindBin::Bin/mock/test.yaml";
