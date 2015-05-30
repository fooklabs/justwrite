package JustWrite::Controller::Post;
use Mojo::Base 'Mojolicious::Controller';

use Try::Tiny;
use Data::Dumper;

sub create {
  my $c = shift;
  my $db = $c->pg->db;
  my $title    = $c->param('title');
  my $body     = $c->param('body');
  my $tags     = $c->every_param('tag[]');
  my $login    = $c->session('login');

  my $pid;
  if ( $login ) {
    $pid = $db->query(
      'insert into post (login,title,body,published) values(?, ?, ?, ?) returning post_id',
      $login,
      $title,
      $body,
      'true'
    )->hash->{post_id};
  }
  else {
    $pid = $db->query(
      'insert into post (title,body,published) values(?, ?, ?) returning post_id',
      $title,
      $body,
      'true'
    )->hash->{post_id};
  }

  for my $tag ( @{$tags} ) {
    try {
      $db->query('insert into tag (name) values (?)', $tag);
    };
    $db->query('insert into post_tag (post_id, tag_name) values (?, ?)', $pid, $tag);
  }

  $c->render(text => 'good');
}

sub view {
  my $c = shift;
  my $db = $c->pg->db;
  my $pid = $c->param('pid');

  print "$pid\n";

  if ( my $post = $db->query('select * from post a join post_tag b on a.post_id=b.post_id where a.post_id = ?', $pid)->hashes ) {
    $post = $post->to_array;
    print Dumper $post;
    return $c->render(template => 'post/view', post => $post);
  }

  $c->render(text => 'good');

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
    return $c->render(text => body);
  }
  
  $db->query('update post set body = ? where post_id = ?', $body, $pid);
  $c->render(text => $body);
}

1;
