use utf8;
package JustWrite::DB::Schema::Result::Comment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

JustWrite::DB::Schema::Result::Comment

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<comment>

=cut

__PACKAGE__->table("comment");

=head1 ACCESSORS

=head2 comment_id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'comment_comment_id_seq'

=head2 login

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 post_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 body

  data_type: 'text'
  is_nullable: 0

=head2 path

  data_type: 'ltree'
  is_nullable: 0

=head2 created

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=cut

__PACKAGE__->add_columns(
  "comment_id",
  {
    data_type         => "bigint",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "comment_comment_id_seq",
  },
  "login",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "post_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "body",
  { data_type => "text", is_nullable => 0 },
  "path",
  { data_type => "ltree", is_nullable => 0 },
  "created",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</comment_id>

=back

=cut

__PACKAGE__->set_primary_key("comment_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<post_body_uq>

=over 4

=item * L</post_id>

=item * L</body>

=back

=cut

__PACKAGE__->add_unique_constraint("post_body_uq", ["post_id", "body"]);

=head1 RELATIONS

=head2 login

Type: belongs_to

Related object: L<JustWrite::DB::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "login",
  "JustWrite::DB::Schema::Result::User",
  { login => "login" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 post

Type: belongs_to

Related object: L<JustWrite::DB::Schema::Result::Post>

=cut

__PACKAGE__->belongs_to(
  "post",
  "JustWrite::DB::Schema::Result::Post",
  { post_id => "post_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-05-28 01:56:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RBZ8C1fe56rPb0zCYAwrqg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
