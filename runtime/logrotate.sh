#!/usr/bin/env sh

cd "$(dirname "$0")"/..

NKEEP=20

LOG_NG='./volumes/log/nginx/*.log'
LOG_PHP='./volumes/log/php/*.log'

# HOME must be set in CRONTAB if script runs from cron
if test -f "$HOME/.profile"; then
. "$HOME/.profile";
fi

rotate_one() {
    FILE="$1"
    echo "rotating [$FILE]..."
    if test ! -s "$FILE"; then
        return
    fi
    N="$2"
    while test $N -gt 0; do
        P=$(($N - 1))
        PFILE="$(printf %s.%02d.gz "$FILE" "$P")"
        CFILE="$(printf %s.%02d.gz "$FILE" "$N")"
        if test -f "$PFILE"; then
            echo "$CFILE"
            mv -f "$PFILE" "$CFILE"
        fi
        N="$P"
    done
    if test -s "$FILE"; then
        mv -f "$FILE" "$FILE.01"
        gzip -f -4 "$FILE.01"
    fi
}

rotate() {
    for F in $1; do
        rotate_one "$F" "$2"
    done
}

rotate "$LOG_PHP" "$NKEEP"
/usr/bin/env make php-x ARGS='killall -USR1 php-fpm'

rotate "$LOG_NG" "$NKEEP"
/usr/bin/env make nginx-x ARGS='killall -USR1 nginx'
