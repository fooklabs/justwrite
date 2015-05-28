use utf8;
package JustWrite::DB::Schema::Result::PostTag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

JustWrite::DB::Schema::Result::PostTag

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

=head1 TABLE: C<post_tag>

=cut

__PACKAGE__->table("post_tag");

=head1 ACCESSORS

=head2 post_tag_id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'post_tag_post_tag_id_seq'

=head2 post_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 tag_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "post_tag_id",
  {
    data_type         => "bigint",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "post_tag_post_tag_id_seq",
  },
  "post_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "tag_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</post_tag_id>

=back

=cut

__PACKAGE__->set_primary_key("post_tag_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<post_tag_uq>

=over 4

=item * L</post_id>

=item * L</tag_id>

=back

=cut

__PACKAGE__->add_unique_constraint("post_tag_uq", ["post_id", "tag_id"]);

=head1 RELATIONS

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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KYQd57svMEmumFSoiOXoHA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
