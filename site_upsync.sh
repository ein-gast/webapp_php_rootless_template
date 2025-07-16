#!/usr/bin/env bash

cd "$(dirname "$0")"

source site_sync_cfg || exit 1

#busybox
export BB_GLOBBING=0
#ash / bash
set -o noglob

F_EXCLUDE=".sync-exclude"
truncate -s 0 "$F_EXCLUDE"
for EXCL in $DATA_EXCLUDE; do
    echo "$EXCL" >> "$F_EXCLUDE"
done

# sync 1
for FILE in $SITE_FILES; do
    TO="$RSYNC_SITE_PATH/$FILE"
    echo "$FILE -> $TO"
    rsync \
        -l \
        -e ssh -ptrv --delete \
        ./$FILE $TO || exit 1
#     -og --chown=www-data:www-data \
done

echo "$EXCLUDE"
# sync 2
for DATA in $DATA_FOLDERS; do
    TO="$RSYNC_SITE_PATH/$DATA"
    echo "$DATA -> $TO"
    rsync \
        -l \
        -e ssh -ptrv --delete \
        --exclude-from="$F_EXCLUDE" \
        ./$DATA $TO || exit 1
        #$EXCLUDE \
done
