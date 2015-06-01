package JustWrite::Controller::Subject;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw/from_json/;

sub create {
  my $c = shift;
  my $db = $c->pg->db;

  my $title = $c->param('title');
  my $topics = $c->param('topics');
  my $login = $c->session('login');

  return $c->redirect_to('login') unless $login;

  if ($c->req->method ne 'POST') {
    return $c->render(template => 'subject/create');
  }

  my $subject = $db->query(
    'insert into subject (name) values (?) returning subject_id',
    $title
  );

  $topics = from_json($topics);
  $db->query('insert into topics (name) values (?)', $_) for @{$topics};
  
  $c->render(text => 'good');
}

sub view {
  my $c = shift;
  my $db = $c->pg->db;

  my $sid = $c->param('sid');
  my $login = $c->session('login');

  return $c->redirect_to('login') unless $login;
  return $c->redirect_to('list') unless $sid;

  if ($c->req->method ne 'POST') {
    # Get subject name
    my $subject = $db->query(
      'select name from subject a
       join subject_topic b using a.subject_id=b.subject_id
       join topic c using b.topic_id=c.topic_id
       where user_filter_id = ? and login = ?', 
       $sid, $login
    )->hash;

    return $c->render(template => 'subject/view', error => 'Subject does not exist.')
      unless defined $subject;

    $subject = $subject->to_array;
    return $c->render(template => 'subject/view', subject => $subject);
  }
   
}

sub list {
  my $c = shift;
  my $db = $c->pg->db;
  
  my $login = $c->session('login'); 
  # check if session is set
  return $c->redirect_to('login') unless $login;
  
  my $subjects = $db->query(
    'select * from subject a
     join subject_topic b using a.subject_id=b.subject_id
     join topic c using b.topic_id=c.topic_id
     where login = ?', $login
  )->hashes;
  
  $c->render(template => 'subject/list', subjects => $subjects); 
}

sub delete {
  my $c = shift;
  my $db = $c->pg->db;
  my $sid = $c->param('sid');
  
  # check if session is set
  $c->redirect_to('login') unless $c->session('login');
  
  $db->query('delete from subject where subject_id = ?', $sid);
  
  $c->send({ json => {
      success => \1,
      message => 'Page removed',
  }});
  
}

1;
