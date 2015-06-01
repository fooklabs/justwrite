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


}

sub edit {
  my $c = shift;
  my $db = $c->pg->db;

}

1;
