package JustWrite::Controller::Topic;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

sub view {
  my $c = shift;
  my $db = $c->pg->db;

  $c->render('topic/view');
}

sub list {
  my $c = shift;
  my $db = $c->pg->db;

  # Select all rows non-blocking
  Mojo::IOLoop->delay(
    sub {
      my $delay = shift;
      $db->query('select * from ' => $delay->begin);
    },
    sub {
      my ($delay, $err, $results) = @_;
      $results->hashes->map(sub { $_->{name} })->join("\n")->say;
    }
  )->wait;

}

sub edit {
  my $c = shift;
  my $db = $c->pg->db;

}

1;
