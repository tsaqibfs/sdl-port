#!/bin/sh

# Set path to your Android keystore and your keystore alias here, or put them in your environment
[ -z "$ANDROID_KEYSTORE_FILE" ] && ANDROID_KEYSTORE_FILE=~/.android/debug.keystore
[ -z "$ANDROID_KEYSTORE_ALIAS" ] && ANDROID_KEYSTORE_ALIAS=androiddebugkey
PASS=
[ -n "$ANDROID_KEYSTORE_PASS" ] && PASS="--ks-pass env:ANDROID_KEYSTORE_PASS"
[ -n "$ANDROID_KEYSTORE_PASS_FILE" ] && PASS="--ks-pass file:$ANDROID_KEYSTORE_PASS_FILE"

OUT=`pwd`/../../../../SuperTux-with-data.apk
rm -f $OUT $OUT-aligned
cp ../../../../project/app/build/outputs/apk/release/app-release.apk $OUT || exit 1
cd supertux/data || exit 1
zip -r $OUT * || exit 1
zipalign 4 $OUT $OUT-aligned || exit 1
apksigner sign --ks $ANDROID_KEYSTORE_FILE --ks-key-alias $ANDROID_KEYSTORE_ALIAS $PASS $OUT-aligned || exit 1
mv $OUT-aligned $OUT
