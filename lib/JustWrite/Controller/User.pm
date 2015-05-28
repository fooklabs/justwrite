package JustWrite::Controller::User;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;


sub login {
  my $c = shift;
  my $db = $c->pg->db;
  my $login    = $c->param('login');
  my $password = $c->param('password');

  if ($c->session('login')) {
    return $c->redirect_to('index');
  }
  if ($c->req->method ne 'POST') {
    return $c->render(template => 'user/register');
  }

  my $user = $db->query('select * from "user" where login = ?', $login)->hash;

  return $c->render(template => 'user/register', error => 'invalid username')
    unless defined $user->{login};

  return $c->render(template => 'user/register', error => 'invalid password')
    unless $c->check_password($password, $user->{password});

  $c->session(login => $login);
  $c->redirect_to('index');
}

sub register {
  my $c = shift;
  my $validation = $c->validation;
  my $db = $c->pg->db;

  if ($c->session('login')) {
    return $c->redirect_to('index');
  }
  if ($c->req->method ne 'POST') {
    return $c->render(template => 'user/register');
  }

  $validation->required('login')->like(qr/^\w+$/)->size(3, 15);
  $validation->required('repassword')->equal_to('password');
  $validation->required('password')->size(5, 255);
  my $output = $validation->output;

  $validation->error(login => ['not available'])
    if $db->query('select * from "user" where login = ?', $output->{login})->hash;

  return $c->render(template => 'user/register', error => '', status => 400) if $validation->has_error;

  my $user = $db->query(
    'insert into "user" (login,password) values(?,?) returning login',
    $output->{login},
    $c->bcrypt($output->{password})
  )->hash->{login};

  $c->session(login => $output->{login});
  $c->redirect_to('index');
}

sub logout {
  my $c = shift;

  $c->session(login => undef);
  $c->redirect_to('index');
}

1;
