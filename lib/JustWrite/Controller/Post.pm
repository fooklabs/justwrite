package JustWrite::Controller::Post;
use Mojo::Base 'Mojolicious::Controller';

use Try::Tiny;

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
      'insert into post (login,title,body, published) values(?, ?, ?, ?) returning post_id',
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
  my $pid = $c->param('post_id');

  if ( my $post = $db->query("select * from post where post_id = '?'", $pid)->hash ) {
    $self->render(template => 'post/view', post => $post);
  }
  else {
    $self->render(template => 'post/view', error => 'No post like that exists.');
  }
  
  
}

sub list {
  my $c = shift;
  my $db = $c->pg->db;

}

1;
