#!/usr/bin/env bash
# Builds the signed Android release APK (prod: https://api.trackbox24.com) into build/trackbox24-<version>.apk,
# to hand out as a file. Like release_ios.sh, the --dart-define pair is what makes it a prod build.
#
# The upload key never enters the repo: the keystore lies outside it (ANDROID_KEYSTORE, by default
# ~/.android-keys/trackbox24.jks) and its passwords are in the macOS Keychain:
#   security add-generic-password -s trackbox24-android-store -a trackbox24 -w   # keystore password
#   security add-generic-password -s trackbox24-android-key -a trackbox24 -w     # key password (often the same)
# android/key.properties is written for the build only and deleted afterwards (gitignored either way).
#
# Bump `version: X.Y.Z+N` in pubspec.yaml first: Android installs an update only over a lower build number.
set -euo pipefail

cd "$(dirname "$0")/.."

API_BASE_URL="${API_BASE_URL:-https://api.trackbox24.com}"
KEYSTORE="${ANDROID_KEYSTORE:-$HOME/.android-keys/trackbox24.jks}"
KEY_ALIAS="${ANDROID_KEY_ALIAS:-upload}"
SDK="${ANDROID_HOME:-$HOME/Library/Android/sdk}"

[[ -f "$KEYSTORE" ]] || { echo "✗ no keystore at $KEYSTORE" >&2; exit 1; }
store_pass=$(security find-generic-password -s trackbox24-android-store -a trackbox24 -w) \
  || { echo "✗ keystore password is not in the Keychain (trackbox24-android-store)" >&2; exit 1; }
key_pass=$(security find-generic-password -s trackbox24-android-key -a trackbox24 -w 2>/dev/null || echo "$store_pass")

props=android/key.properties
trap 'rm -f "$props"' EXIT
umask 077
cat > "$props" <<EOF
storeFile=$KEYSTORE
storePassword=$store_pass
keyAlias=$KEY_ALIAS
keyPassword=$key_pass
EOF

version=$(sed -n 's/^version: //p' pubspec.yaml)
echo "→ version: $version → $API_BASE_URL"

flutter build apk --release \
  --dart-define=FLAVOR=prod \
  --dart-define="API_BASE_URL=$API_BASE_URL"

apk=build/app/outputs/flutter-apk/app-release.apk

# Signed with the upload key, not the debug one (build.gradle.kts falls back to debug without key.properties).
apksigner=$(ls -d "$SDK"/build-tools/*/apksigner | sort -V | tail -1)
if "$apksigner" verify --print-certs "$apk" | grep -q "CN=Android Debug"; then
  echo "✗ the APK is signed with the debug key" >&2
  exit 1
fi

# The prod address made it into the compiled Dart code.
check=$(mktemp -d)
trap 'rm -f "$props"; rm -rf "$check"' EXIT
unzip -q -o "$apk" 'lib/arm64-v8a/libapp.so' -d "$check"
if ! grep -qa "$API_BASE_URL" "$check/lib/arm64-v8a/libapp.so"; then
  echo "✗ $API_BASE_URL is not in the build: it is not a prod one" >&2
  exit 1
fi

out="build/trackbox24-${version%%+*}.apk"
cp "$apk" "$out"
echo "✓ $out ($(du -h "$out" | cut -f1)), signed by: $("$apksigner" verify --print-certs "$out" | sed -n 's/.*certificate DN: //p' | head -1)"
