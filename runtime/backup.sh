#!/usr/bin/env sh

cd "$(dirname "$0")"/..

. ./.env || exit 1

FDATA='volumes/app'

DBHOST='127.0.0.1'
DBNAME="$MYSQL_DATABASE"
DBUSER="$MYSQL_USER"
DBPASS="$MYSQL_PASSWORD"

b_files() {
    (tar -C "$FDATA" -czf - .) || exit 1
}

b_database() {
    make --silent \
        mysql-x ARGS="mysqldump --single-transaction --create-options -q --host $DBHOST -u$DBUSER -p$DBPASS $DBNAME" |
        gzip -f -c -4 ||
        exit 1
}

if test "$1" = "files"; then
    b_files
    exit
fi

if test "$1" = "database"; then
    b_database
    exit
fi

echo "Usage: ./backup.sh <files|database>"
