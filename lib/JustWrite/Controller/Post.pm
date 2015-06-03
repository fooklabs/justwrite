package JustWrite::Controller::Post;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw/from_json/;
use HTML::Strip;

use Text::Markdown 'markdown';

use Try::Tiny;
use Data::Dumper;

sub create {
  my $c = shift;
  my $db = $c->pg->db;

  my $title    = $c->param('title');
  my $body     = $c->param('body');
  my $topics   = $c->param('topics');
  my $login    = $c->session('login') // 'anonymous';

  # Build the stub
  my $stub = $title =~ s/[^\w\s]//rg;
  $stub =~ s/\h+/_/g;
  return $c->redirect_to($from) if !$stub;

    # Strip out any HTML the user may have added
  my $hs = HTML::Strip->new();

  $body = $hs->parse($body);
  $body = markdown($body);


  # Generate a random 6 character string.
  my $pid = $c->random;
  while ( my $b = $db->query('
    select title from post where id = ? and stub = ?', $pid, $stub)
  ) {
    $pid = $c->random;
  }





  $db->query(
    'insert into post (login,title,body,published) values(?, ?, ?, ?)',
    $login,
    $title,
    $body,
    'true'
  )->hash->{post_id};
  $topics = from_json($topics);
  try {
    $db->query('insert into topic (name) values (?)', $_);
    $db->query('insert into post_to_topic (post,topic) values (?,?)', $pid, $_);
  } for @{$topics};

  $c->redirect_to("/p/:$pid/:$stub");
}

sub view {
  my $c = shift;
  my $db = $c->pg->db;
  my $pid = $c->param('pid');

  my $post = $db->query(
    'select * from post a join post_to_topic b on a.post_id=b.post where post_uuid = ?',
    $pid
  )->hashes;
  #$post = $post->to_array;
  return $c->render(template => 'post/view', post => $post);

}

sub list {
  my $c = shift;
  my $db = $c->pg->db;
  my $tid = $c->param('tid');

  if ( my $list = $db->query('select * from post')->hashes ) {
    $list = $list->to_array;
    return $c->render(template => 'post/list', post => $list);
  }
  $c->render(text => 'good');
}

sub edit {
  my $c = shift;
  my $db = $c->pg->db;

  my $pid =   $c->param('id');
  my $login = $c->param('login');
  my $body =  $c->param('value');

  if ( $c->session('login') ne $login ) {
    return $c->render(text => $body);
  }

  $db->query('update post set body = ? where post_id = ?', $body, $pid);
  $c->render(text => $body);
}

1;
