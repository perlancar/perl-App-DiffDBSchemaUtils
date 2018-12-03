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

our %args_dbconnect_mysql = %args_dbconnect;
delete $args_dbconnect_mysql{dsn1};
delete $args_dbconnect_mysql{dsn2};
%args_dbconnect_mysql = (
    %args_dbconnect_mysql,
    db1 => {
        summary => 'Name of the first MySQL database',
        schema => 'str*',
        req => 1,
        pos => 0,
        tags => ['category:db-connection'],
    },
    db2 => {
        summary => 'Name of the second MySQL database',
        schema => 'str*',
        req => 1,
        pos => 1,
        tags => ['category:db-connection'],
    },
);

our %args_dbconnect_pg = %args_dbconnect;
delete $args_dbconnect_pg{dsn1};
delete $args_dbconnect_pg{dsn2};
%args_dbconnect_pg = (
    %args_dbconnect_pg,
    db1 => {
        summary => 'Name of the first PostgreSQL database',
        schema => 'str*',
        req => 1,
        pos => 0,
        tags => ['category:db-connection'],
    },
    db2 => {
        summary => 'Name of the second PostgreSQL database',
        schema => 'str*',
        req => 1,
        pos => 1,
        tags => ['category:db-connection'],
    },
);

our %args_dbconnect_sqlite = %args_dbconnect;
delete $args_dbconnect_sqlite{dsn1};
delete $args_dbconnect_sqlite{dsn2};
%args_dbconnect_sqlite = (
    %args_dbconnect_sqlite,
    db1 => {
        summary => 'Path to the first SQLite database',
        schema => 'str*',
        req => 1,
        pos => 0,
        tags => ['category:db-connection'],
    },
    db2 => {
        summary => 'Path to the second SQLite database',
        schema => 'str*',
        req => 1,
        pos => 1,
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
    summary => 'Diff two database schemas',
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

$SPEC{diff_mysql_schema} = {
    v => 1.1,
    summary => 'Diff two MySQL database schemas',
    description => <<'_',

Convenient thin wrapper for `diff_db_schema`, when you have two MySQL databases.
Instead of having to specify two DSN's, you just specify two database names.

_
    args => {
        %args_dbconnect_mysql,
    },
};
sub diff_mysql_schema {
    my %args = @_;

    $args{dsn1} = "DBI:mysql:database=".(delete $args{db1});
    $args{dsn2} = "DBI:mysql:database=".(delete $args{db2});
    diff_db_schema(%args);
}

$SPEC{diff_pg_schema} = {
    v => 1.1,
    summary => 'Diff two PostgreSQL database schemas',
    description => <<'_',

Convenient thin wrapper for `diff_db_schema`, when you have two PostgreSQL
databases. Instead of having to specify two DSN's, you just specify two database
names.

_
    args => {
        %args_dbconnect_pg,
    },
};
sub diff_pg_schema {
    my %args = @_;

    $args{dsn1} = "DBI:Pg:dbname=".(delete $args{db1});
    $args{dsn2} = "DBI:Pg:dbname=".(delete $args{db2});
    diff_db_schema(%args);
}

$SPEC{diff_sqlite_schema} = {
    v => 1.1,
    summary => 'Diff two SQLite database schemas',
    description => <<'_',

Convenient thin wrapper for `diff_db_schema`, when you have two SQLite
databases. Instead of having to specify two DSN's, you just specify two database
paths.

_
    args => {
        %args_dbconnect_pg,
    },
};
sub diff_sqlite_schema {
    my %args = @_;

    $args{dsn1} = "DBI:SQLite:dbname=".(delete $args{db1});
    $args{dsn2} = "DBI:SQLite:dbname=".(delete $args{db2});
    diff_db_schema(%args);
}

1;
# ABSTRACT: Utilities related to diff-ing DB schemas

=head1 DESCRIPTION

This distribution includes several utilities:

#INSERT_EXECS_LIST


=head1 SEE ALSO

L<DBIx::Diff::Schema>

For MySQL: L<MySQL::Diff> and its CLI L<mysqldiff> which can compare live
database schemas or database schemas specified as SQL. Outputs SQL statements
that express the difference.
