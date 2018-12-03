package App::DiffDBSchemaUtils;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

our %args_dbconnect = (
    dsn1 => {
        schema => 'str*',
        req => 1,
        pos => 0,
        tags => ['category:db-connection'],
    },
    username1 => {
        schema => 'str*',
        tags => ['category:db-connection'],
    },
    password1 => {
        schema => 'str*',
        tags => ['category:db-connection'],
    },
    dsn2 => {
        schema => 'str*',
        req => 1,
        pos => 1,
        tags => ['category:db-connection'],
    },
    username2 => {
        schema => 'str*',
        tags => ['category:db-connection'],
    },
    password2 => {
        schema => 'str*',
        tags => ['category:db-connection'],
    },
);

#$SPEC{dump_db_schema} = {
#    v => 1.1,
#    args => {
#        %args_dbconnect,
#    },
#};
#sub dump_db_schema {
#    require DBIx::Connect::Any;
#
#    my %args = @_;
#
#    my $dbh = DBIx::Connect::Any->connect(
#        $args{dsn}, $args{username}, $args{password},
#        {RaiseError=>1});
#
#}

$SPEC{diff_db_schema} = {
    v => 1.1,
    args => {
        %args_dbconnect,
    },
};
sub diff_db_schema {
    require DBIx::Connect::Any;

    my %args = @_;

    my $dbh1 = DBIx::Connect::Any->connect(
        $args{dsn1}, $args{username1}, $args{password1},
        {RaiseError=>1});
    my $dbh2 = DBIx::Connect::Any->connect(
        $args{dsn2}, $args{username2}, $args{password2},
        {RaiseError=>1});

    require DBIx::Diff::Schema;

    my $res = DBIx::Diff::Schema::diff_db_schema($dbh1, $dbh2);
    [200, "OK", $res];
}

1;
# ABSTRACT: Utilities related to diff-ing DB schemas

=head1 DESCRIPTION

This distribution includes several utilities:

#INSERT_EXECS_LIST


=head1 SEE ALSO

L<DBIx::Diff::Schema>
