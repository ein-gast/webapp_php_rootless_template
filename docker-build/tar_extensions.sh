#!/usr/bin/env sh

Z_EXTDIR=/usr/local/lib/php/extensions
Z_LIBSDIR=/usr/lib
EXTLIST="*.so"
LIBLIST="libpng16 libjpeg libfreetype libbz2 libonig"

FILELITS=""
for SOPATTERN in $EXTLIST; do
    for SOFILE in "$Z_EXTDIR"/**/"$SOPATTEN"; do
        FILELITS="$FILELITS $SOFILE"
    done
done

for SOPATTEN in $LIBLIST; do
    for SOFILE in "$Z_LIBSDIR/$SOPATTEN".so*; do
        FILELITS="$FILELITS $SOFILE"
    done
done

tar -cf /sofiles.tar $FILELITS
