use utf8;
package JustWrite::DB::Schema::Result::Book;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

JustWrite::DB::Schema::Result::Book

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

=head1 TABLE: C<book>

=cut

__PACKAGE__->table("book");

=head1 ACCESSORS

=head2 book_id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'book_book_id_seq'

=head2 login

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 title

  data_type: 'text'
  is_nullable: 0

=head2 last_updated

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 date_created

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=cut

__PACKAGE__->add_columns(
  "book_id",
  {
    data_type         => "bigint",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "book_book_id_seq",
  },
  "login",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "title",
  { data_type => "text", is_nullable => 0 },
  "last_updated",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
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

=item * L</book_id>

=back

=cut

__PACKAGE__->set_primary_key("book_id");

=head1 RELATIONS

=head2 book_tags

Type: has_many

Related object: L<JustWrite::DB::Schema::Result::BookTag>

=cut

__PACKAGE__->has_many(
  "book_tags",
  "JustWrite::DB::Schema::Result::BookTag",
  { "foreign.book_id" => "self.book_id" },
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

=head2 posts

Type: has_many

Related object: L<JustWrite::DB::Schema::Result::Post>

=cut

__PACKAGE__->has_many(
  "posts",
  "JustWrite::DB::Schema::Result::Post",
  { "foreign.book_id" => "self.book_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-05-28 01:56:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zPzTPwDZxLrX3X/i5Oxg8Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
