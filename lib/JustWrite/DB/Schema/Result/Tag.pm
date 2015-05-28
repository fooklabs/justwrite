use utf8;
package JustWrite::DB::Schema::Result::Tag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

JustWrite::DB::Schema::Result::Tag

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

=head1 TABLE: C<tag>

=cut

__PACKAGE__->table("tag");

=head1 ACCESSORS

=head2 tag_id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'tag_tag_id_seq'

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 count

  data_type: 'bigint'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "tag_id",
  {
    data_type         => "bigint",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "tag_tag_id_seq",
  },
  "name",
  { data_type => "text", is_nullable => 0 },
  "count",
  { data_type => "bigint", default_value => 0, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</tag_id>

=back

=cut

__PACKAGE__->set_primary_key("tag_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<tag_name_uq>

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("tag_name_uq", ["name"]);

=head1 RELATIONS

=head2 book_tags

Type: has_many

Related object: L<JustWrite::DB::Schema::Result::BookTag>

=cut

__PACKAGE__->has_many(
  "book_tags",
  "JustWrite::DB::Schema::Result::BookTag",
  { "foreign.tag_id" => "self.tag_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 post_tags

Type: has_many

Related object: L<JustWrite::DB::Schema::Result::PostTag>

=cut

__PACKAGE__->has_many(
  "post_tags",
  "JustWrite::DB::Schema::Result::PostTag",
  { "foreign.tag_id" => "self.tag_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-05-28 01:56:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:H2sZaJrhJWA2TXRjW0SBrg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
