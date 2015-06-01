package JustWrite::Controller::Topic;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

sub view {
  my $c = shift;
  my $db = $c->pg->db;

  $c->session(login => $login);
  $c->redirect_to('index');
}

sub list {
  my $c = shift;
  my $db = $c->pg->db;

  
}

sub edit {
  my $c = shift;
  my $db = $c->pg->db;

  if ($c->session('login')) {
    return $c->redirect_to($from);
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

1;
