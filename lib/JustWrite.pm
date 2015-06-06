package JustWrite;
use Mojo::Base 'Mojolicious';

use Mojo::Pg;
use Mojo::Home;
use Mojo::Util qw( md5_sum );
use Crypt::Eksblowfish::Bcrypt qw/bcrypt en_base64/;
use Math::Base36 ':all';

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
  my $app = shift;

  $app->load_config;

  $app->helper(
    bcrypt => sub {
      my $self = shift;
      my ( $password, $settings ) = @_;

      unless ( defined $settings && $settings =~ /^\$2a\$/ ) {
        my $cost = sprintf('%02d', 6);
        $settings = join( '$', '$2a', $cost, _salt() );
        print "SETTINGS: ".$settings."\n";
      }
      return bcrypt( $password, $settings );
    }
  );

  $app->helper(
    check_password => sub {
      my $self = shift;
      my ( $pass1, $pass2) = @_;
      return 1 if $app->bcrypt($pass1, $pass2) eq $pass2;
    }
  );

  $app->helper(
    random => sub {
      return lc encode_base36(time);
    }
  );
  $app->helper( pg => sub {
    state $pg = Mojo::Pg->new(shift->config->{db_string})
  });

  # Router
  my $r = $app->routes;

  # Posts: Can be created, updated, viewed, listed

  # Normal route to controller
  $r->get('/')->to(cb => sub {
    my $c = shift;
    $c->render(template => 'index');
  })->name('index');

  # Register / login / logout
  $r->any('/register')->to('user#register')->name('register');
  $r->any('/login')->to('user#login')->name('login');


  # If not logged in posts can be created/viewed/listed
  $r->get('/p')->to('post#list');
  $r->get('/p/:id/:slug')->to('post#view', slug => '');
  $r->post('/p/new')->to('post#create');


  # Links can be created/viewed/listed
  # $r->get('/l')->to('link#list');
  # $r->get('/l/:id/:slug')->to('link#view');
  # $r->post('/l/new')->to('link#create');

  # Comments can be viewed/listed
  # $r->post('/c/view/:type')->to('comment#view');
  # $r->post('/c/list/:type')->to('comment#list');

  # Topics can be viewed/listed
  # $r->get('/t/:name')->to('topic#view');
  # $r->get('/t/:filter')->to('topic#list', filter => 'new');

  # Users can be viewed
  # $r->get('/u/:user')->to('user#view');

  # Books can be viewed/listed
  # $r->get('/b')->to('book#list');
  # $r->get('/b/:id/:slug')->to('book#view');

  # my $auth = $r->under( sub {
  #   my $self = shift;
  #   return $self->is_auth || $self->auth_fail;
  # });

  # Got to be logged in to log out :)
  # $auth->any('/logout')->to('user#logout')->name('logout');
  # And to delete your account
  # $auth->any('/delete')->to('user#delete');

  # People logged in can edit their own posts
  # $auth->get('/p/save')->to('post#update');

  # They can edit their own links
  # $auth->get('/l/save')->to('link#update');

  # They can create comments
  # They can update comments
  # $r->post('/c/new/:type')->to('comment#create');
  # $r->post('/c/save/:type')->to('comment#update');

  # They can create subjects
  # They can update subjects
  # They can view subjects
  # And delete them
  # $r->post('/s/new')->to('subject#create');
  # $r->get('/s/save')->to('subject#update');

  # They can create books
  # They can update books
  # $r->post('/b/new')->to('book#create');
  # $r->get('/b/save')->to('book#update');


  # If they have over a certain reputation in a topic they can
  # Add related topics
  # Add topics to posts in the topic and add the topic to posts in other topics
  # Same as above, but for links
  # $r->post('/t/save/:name')->to('topic#save');
}

sub _salt {
    my $num = 999999;
    my $cr = crypt( rand($num), rand($num) ) . crypt( rand($num), rand($num) );
    en_base64(substr( $cr, 4, 16 ));
  }
1;
