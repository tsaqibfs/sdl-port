#!/bin/sh

# Set path to your Android keystore and your keystore alias here, or put them in your environment
PASS=
[ -n "$ANDROID_UPLOAD_KEYSTORE_PASS" ] && PASS="-storepass:env ANDROID_UPLOAD_KEYSTORE_PASS"
[ -n "$ANDROID_UPLOAD_KEYSTORE_PASS_FILE" ] && PASS="-storepass:file $ANDROID_UPLOAD_KEYSTORE_PASS_FILE"

cd ../../../../

APPNAME=`grep AppName AndroidAppSettings.cfg | sed 's/.*=//' | tr -d '"' | tr " '/" '---'`
APPVER=`grep AppVersionName AndroidAppSettings.cfg | sed 's/.*=//' | tr -d '"' | tr " '/" '---'`

rm -rf supertux-tmp
mkdir -p supertux-tmp
cd supertux-tmp
unzip ../$APPNAME-$APPVER.aab || exit 1
rm -rf META-INF
mv assetpack/assets/* assetpack/
rm ../$APPNAME-$APPVER.aab
zip -r ../$APPNAME-$APPVER.aab .
cd ..
rm -rf supertux-tmp
# Sign with the new certificate
echo Using keystore $ANDROID_UPLOAD_KEYSTORE_FILE and alias $ANDROID_UPLOAD_KEYSTORE_ALIAS
stty -echo
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore $ANDROID_UPLOAD_KEYSTORE_FILE $PASS $APPNAME-$APPVER.aab $ANDROID_UPLOAD_KEYSTORE_ALIAS || exit 1
stty echo
echo
