use utf8;
package JustWrite::DB::Schema::Result::BookTag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

JustWrite::DB::Schema::Result::BookTag

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

=head1 TABLE: C<book_tag>

=cut

__PACKAGE__->table("book_tag");

=head1 ACCESSORS

=head2 book_tag_id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'book_tag_book_tag_id_seq'

=head2 book_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 tag_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "book_tag_id",
  {
    data_type         => "bigint",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "book_tag_book_tag_id_seq",
  },
  "book_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "tag_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</book_tag_id>

=back

=cut

__PACKAGE__->set_primary_key("book_tag_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<book_tag_uq>

=over 4

=item * L</book_id>

=item * L</tag_id>

=back

=cut

__PACKAGE__->add_unique_constraint("book_tag_uq", ["book_id", "tag_id"]);

=head1 RELATIONS

=head2 book

Type: belongs_to

Related object: L<JustWrite::DB::Schema::Result::Book>

=cut

__PACKAGE__->belongs_to(
  "book",
  "JustWrite::DB::Schema::Result::Book",
  { book_id => "book_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 tag

Type: belongs_to

Related object: L<JustWrite::DB::Schema::Result::Tag>

=cut

__PACKAGE__->belongs_to(
  "tag",
  "JustWrite::DB::Schema::Result::Tag",
  { tag_id => "tag_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-05-28 01:56:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2TXl//DX+7tx232MaJcJFw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
