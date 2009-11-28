package Lism::Config;
use Any::Moose;

our $VERSION = '0.01';

use Config::YAML;
use List::MoreUtils qw/uniq/;

has 'filename' => (
    is         => 'ro',
    isa        => 'Str',
    lazy_build => 1,
);

has 'config' => (
    is         => 'rw',
    isa        => 'Config::YAML',
    lazy_build => 1,
);

sub _build_filename {
    my $self = shift;
    for my $filename ( qw(
        $ENV{ LISM_CONFIG }
        $ENV{ HOME } . 'config.yaml'
        $ENV{ HOME } . 'config.yml'
        ) ) {
        return $_ if -f $_;
    }
}

sub _build_config {
    my $self = shift;
    $self->config(Config::YAML->new(config => $self->filename));
}

sub AUTOLOAD {
    my $self = shift;
    my $class = ref $self or return;
    our $AUTOLOAD;
    Carp::croak "$AUTOLOAD is invalid method"
        unless $AUTOLOAD =~ /^${class}::(\w+)$/;
    my $method = $1;
    Carp::croak "$method is not exists key." unless exists($self->config->{ $method });
    $self->config->{ $method };
}

sub servers {
    my ($self, $kinds) = @_;
    return unless $kinds;
    $kinds = [ $kinds ] unless ref $kinds eq 'ARRAY';

    my $servers = $self->config->{ servers };
    my @results;
    for my $kind ( @$kinds ) {
        if ( $kind eq 'all' ) {
            push @results, @{ $servers->{ $_ } } for sort keys %$servers;
        } elsif ( exists($servers->{ $kind }) ) {
            push @results, @{ $servers->{ $kind } };
        } else {
            Carp::croak "$kind is not exists key.";
        }
    }
    return [uniq @results];
}
1;
__END__

=head1 NAME

Lism::Config - Our configuration class, based on Config::YAML

=head1 SYNOPSIS

  use Lism::Config;
  my $conf = Lism::Config->new;

  my $conf = Lism::Config->new( filename => "/path/to/config.yaml" );

  $conf->servers('all');            # all servers
  $conf->servers(qw[app dbslave]);  # server class(es)

  $conf->name;  # get data from YAML

=head1 DESCRIPTION

Lism::Config is our configuration class, based on Config::YAML.

Additional features
- servers method

You can extend Lism::Config for your project.

  package Lism::Config::YourProject;
  use Any::Moose;
  extends 'Lism::Config';
  
  1;

If you want to more custom method, you may implement methods on it.

=head1 CONFIGURATION FILE

Lism::Config find files,
-$ENV{LISM_CONFIG}
-$HOME/config.yaml
-$HOME/config.yml

=head1 AUTHOR

Ryo Miyake E<lt>ryo.studiom@gmail.com<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
