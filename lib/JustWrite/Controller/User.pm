package JustWrite::Controller::User;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;


sub login {
  my $c = shift;
  my $login    = $c->param('login');
  my $password = $c->param('password');

  if ($c->session('login')) {
    return $c->redirect_to('index');
  }
  if ($c->req->method ne 'POST') {
    return $c->render(template => 'user/register');
  }

  my $user = $c->db->resultset('User')->find({login => $login});

  return $c->render(template => 'user/register', error => 'invalid username')
    unless defined $user;

  return $c->render(template => 'user/register', error => 'invalid password')
    unless $c->check_password($password, $user->password);

  $c->session(login => $login);
  $c->redirect_to('index');
}

sub register {
  my $c = shift;
  my $validation = $c->validation;
  my $db = $c->db;

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
  print Dumper $output;
  $validation->error(login => ['not available'])
    if $db->resultset('User')->find({ login => $output->{login} });
  return $c->render(template => 'user/register', status => 400) if $validation->has_error;

  my $user = $db->resultset('User')->create({
    login    => $output->{login},
    password => $c->bcrypt($output->{password})
  });

  $c->session(login => $output->{login});
  $c->redirect_to('index');
}

sub logout {
  my $c = shift;

  $c->session(login => undef);
  $c->redirect_to('index');
}

1;
