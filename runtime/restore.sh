#!/usr/bin/env sh

cd "$(dirname "$0")"/..

. ./.env || exit 1

FDATA='volumes/app'

DBHOST='127.0.0.1'
DBNAME="$MYSQL_DATABASE"
DBUSER="$MYSQL_USER"
DBPASS="$MYSQL_PASSWORD"

r_files() {
    if test -z "$1"; then
        echo "Error: no backup file provided."
        exit 1
    fi
    (tar -C "$FDATA" -xzf "$1") || exit 1
    echo OK
}

r_database() {
    if test -z "$1"; then
        echo "Error: no backup file provided."
        exit 1
    fi
    gzip -c -d "$1" | \
    make --silent \
        mysql-x ARGS="mysql --host $DBHOST -u$DBUSER -p$DBPASS -D $DBNAME" | \
        gzip -f -c -4 ||
        exit 1
    echo OK
}

if test "$1" = "files"; then
    r_files "$2"
    exit
fi

if test "$1" = "database"; then
    r_database "$2"
    exit
fi

echo "Usage: ./restore.sh <files|database> backup_file.tgz"
