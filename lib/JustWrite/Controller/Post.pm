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
  my $slug = lc $title =~ s/[^\w\s]//rg;
  $slug =~ s/\h+/_/g;
  $slug = substr( $slug, 0, 50 );
  # return $c->redirect_to($from) if !$stub;

    # Strip out any HTML the user may have added
  my $hs = HTML::Strip->new();

  $body = $hs->parse($body);
  $body = markdown($body);


  # Generate a random 6 character string.
  my $pid = $c->random;
  my $count = $db->query('select count(post_uuid) from post where post_uuid = ?', $pid)->hash->{count};
  $pid .= $count + 1;

  # try {
    my $result = $db->query(
      'insert into post (post_uuid,login,title,slug,body,published) values(?, ?, ?, ?, ?, ?) returning post_id',
      $pid,
      $login,
      $title,
      $slug,
      $body,
      'true'
    )->hash;

    if ( my $post_id = $result->{post_id} ) {
      $topics = from_json($topics);
      for ( @{$topics} ) {
        $db->query('insert into topic (name) values (?)', $_);
        $db->query('insert into post_to_topic (post,topic) values (?,?)', $post_id, $_);
      }
      $c->redirect_to("/p/:$pid/:$slug");
    }
  #   else {
  #     # $c->render(eror)
  #   }
  # } catch {
  #   # $c->render(error page);
  # }

}

sub view {
  my $c = shift;
  my $db = $c->pg->db;
  my $pid = $c->param('id');
  my $slug = $c->param('slug');

  try {
    my $post = $db->query(
      'select * from post a join post_to_topic b on a.post_id=b.post where post_uuid = ?',
      $pid
    )->hashes;

    if ( $post->[0]->{login} ) {
      $post = $post->to_array;
      print Dumper $post;
      return $c->render(template => 'post/view', post => $post);
    }
    else {

    }
  } catch {

  }
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

sub topic {
  my $c = shift;
  my $db = $c->pg->db;
  my $id = $c->param('id');



}
1;
