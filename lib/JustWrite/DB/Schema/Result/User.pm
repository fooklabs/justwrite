use utf8;
package JustWrite::DB::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

JustWrite::DB::Schema::Result::User

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

=head1 TABLE: C<user>

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 login

  data_type: 'text'
  is_nullable: 0

=head2 password

  data_type: 'text'
  is_nullable: 0

=head2 font

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "login",
  { data_type => "text", is_nullable => 0 },
  "password",
  { data_type => "text", is_nullable => 0 },
  "font",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</login>

=back

=cut

__PACKAGE__->set_primary_key("login");

=head1 RELATIONS

=head2 books

Type: has_many

Related object: L<JustWrite::DB::Schema::Result::Book>

=cut

__PACKAGE__->has_many(
  "books",
  "JustWrite::DB::Schema::Result::Book",
  { "foreign.login" => "self.login" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 comments

Type: has_many

Related object: L<JustWrite::DB::Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "JustWrite::DB::Schema::Result::Comment",
  { "foreign.login" => "self.login" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 posts

Type: has_many

Related object: L<JustWrite::DB::Schema::Result::Post>

=cut

__PACKAGE__->has_many(
  "posts",
  "JustWrite::DB::Schema::Result::Post",
  { "foreign.login" => "self.login" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-05-28 01:56:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:exUZn+MR6h0ePZh+yg0oPQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
