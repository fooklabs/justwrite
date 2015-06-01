package JustWrite;
use Mojo::Base 'Mojolicious';

use Mojo::Pg;
use Mojo::Home;
use Mojo::Util qw( md5_sum );
use Crypt::Eksblowfish::Bcrypt qw/bcrypt en_base64/;

has config_file => sub {
  my $self = shift;
  return $ENV{JUSTWRITE_CONFIG} if $ENV{JUSTWRITE_CONFIG};
  return $self->home->rel_file('justwrite.conf');
};

sub load_config {
  my $app = shift;

  $app->plugin( Config => {
    file => $app->config_file,
  });

  if ( my $secrets = $app->config->{secrets} ) {
    $app->secrets($secrets) if @$secrets;
  } else {
     my $secrets = [md5_sum rand . $$ . time];
     $app->secrets($secrets);
  }
}

# This method will run once at server start
sub startup {
  my $self = shift;

  $self->helper(
    bcrypt => sub {
      my $app = shift;
      my ( $password, $settings ) = @_;

      unless ( defined $settings && $settings =~ /^\$2a\$/ ) {
        my $cost = sprintf('%02d', 6);
        $settings = join( '$', '$2a', $cost, _salt() );
        print "SETTINGS: ".$settings."\n";
      }
      return bcrypt( $password, $settings );
    }
  );

  $self->helper(
    check_password => sub {
      my $app = shift;
      my ( $pass1, $pass2) = @_;

      return 1 if $app->bcrypt($pass1, $pass2) eq $pass2;
    }
  );

  $self->helper( pg => sub {
    state $pg = Mojo::Pg->new(shift->config->{db_string})
  });

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/index');
  $r->any('/register')->to('user#register')->name('register');
  $r->any('/login')->to('user#login')->name('login');
  $r->any('/logout')->to('user#logout')->name('logout');

  $r->post('/p/create')->to('post#create');
  $r->get('/p/view/:pid')->to('post#view');
  $r->get('/p/list/:tid', {tid => 'all'})->to('post#list');
  $r->post('/p/edit')->to('post#edit');
  $r->any('/s/create')->to('subject#create');

}

sub _salt {
    my $num = 999999;
    my $cr = crypt( rand($num), rand($num) ) . crypt( rand($num), rand($num) );
    en_base64(substr( $cr, 4, 16 ));
  }
1;
