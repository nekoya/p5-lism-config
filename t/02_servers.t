use strict;
use warnings;

use Test::More tests => 4;
use Test::Exception;

use FindBin::libs;
use Lism::Config;

my $conf = Lism::Config->new( filename => "$FindBin::Bin/mock/test.yaml" );

is_deeply $conf->servers('dball'), [qw(
dbm01 dbm02
dbs01 dbs02 dbs03
)], "servers of 'dball'";

is_deeply $conf->servers([qw/op app memd/]), [qw(
op01 op02
app01 app02 app03 app04
memd01
)], "servers of 'op, app, memd' (unique array)";

is_deeply $conf->servers('all'), [qw(
app01 app02 app03 app04
dbm01 dbm02 dbs01 dbs02 dbs03
memd01 op02
op01
spare01 spare02
)], "all servers";

throws_ok { $conf->servers('none') } qr/^none is not exists key\./;
