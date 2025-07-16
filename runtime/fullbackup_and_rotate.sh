#!/usr/bin/env sh

cd "$(dirname "$0")"/..

. ./site_sync_cfg || exit 1

NKEEP=5

BACKUP_DIR='./backups'
BACKUP_PREFIX="$SITE_HTTP_HOST"'_'
LOCK="${BACKUP_DIR}"/"${BACKUP_PREFIX}.lock"

# HOME must be set in CRONTAB if script runs from cron
if test -f "$HOME/.profile"; then
    . "$HOME/.profile"
fi

backup() {
    echo "Backuping..."
    SUFFIX="$(date +%Y%m%d_%H%M%S)"
    TARGET="${BACKUP_DIR}"/"${BACKUP_PREFIX}${SUFFIX}"
    echo "$TARGET"
    TARGET_D="$TARGET/db.tar.gz"
    TARGET_F="$TARGET/vol.tar.gz"
    mkdir -p "$TARGET" || exit 1
    ./runtime/backup.sh database >"$TARGET_D"
    ./runtime/backup.sh files    > "$TARGET_F"
    echo "OK"
}

rotate() {
    echo "Rotating..."
    TODELETE="$(find "$BACKUP_DIR" -maxdepth 1 -type d -name "$BACKUP_PREFIX"'*' | sort -r | tail -n +$(($NKEEP+1)) )"
IFS="
"
    for DELME in $TODELETE; do
        if test -d "$DELME"; then
            echo "del: $DELME"
            rm -f "$DELME"/*
            rmdir "$DELME"
        fi
    done
    echo "OK"
}

lock() {
    mkdir -p "${BACKUP_DIR}" || exit 1
    if test -f "$LOCK"; then
        echo "Error: Locked!"
        exit 1
    fi
    touch "$LOCK"
}

unlock() {
    if test -f "$LOCK"; then
        rm "$LOCK"
    fi
}

lock
trap unlock EXIT

backup
rotate
