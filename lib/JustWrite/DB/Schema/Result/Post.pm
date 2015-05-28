use utf8;
package JustWrite::DB::Schema::Result::Post;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

JustWrite::DB::Schema::Result::Post

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

=head1 TABLE: C<post>

=cut

__PACKAGE__->table("post");

=head1 ACCESSORS

=head2 post_id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'post_post_id_seq'

=head2 login

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 book_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 1

=head2 book_order

  data_type: 'integer'
  is_nullable: 1

=head2 title

  data_type: 'text'
  is_nullable: 0

=head2 body

  data_type: 'text'
  is_nullable: 0

=head2 interesting

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 not_interesting

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 shit_writing

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 good_writing

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 outdated

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 inaccurate

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 public_writeable

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 published

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 date_created

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=cut

__PACKAGE__->add_columns(
  "post_id",
  {
    data_type         => "bigint",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "post_post_id_seq",
  },
  "login",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "book_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 1 },
  "book_order",
  { data_type => "integer", is_nullable => 1 },
  "title",
  { data_type => "text", is_nullable => 0 },
  "body",
  { data_type => "text", is_nullable => 0 },
  "interesting",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "not_interesting",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "shit_writing",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "good_writing",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "outdated",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "inaccurate",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "public_writeable",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "published",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "date_created",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</post_id>

=back

=cut

__PACKAGE__->set_primary_key("post_id");

=head1 RELATIONS

=head2 book

Type: belongs_to

Related object: L<JustWrite::DB::Schema::Result::Book>

=cut

__PACKAGE__->belongs_to(
  "book",
  "JustWrite::DB::Schema::Result::Book",
  { book_id => "book_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 comments

Type: has_many

Related object: L<JustWrite::DB::Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "JustWrite::DB::Schema::Result::Comment",
  { "foreign.post_id" => "self.post_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

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

=head2 post_tags

Type: has_many

Related object: L<JustWrite::DB::Schema::Result::PostTag>

=cut

__PACKAGE__->has_many(
  "post_tags",
  "JustWrite::DB::Schema::Result::PostTag",
  { "foreign.post_id" => "self.post_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-05-28 01:56:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nVb/Kh+KIZ80cApmIlwKJA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
