#!/usr/bin/env bash
# Builds the iOS release for TestFlight and uploads it.
#
# The --dart-define pair is the whole point of this script: without it the build falls back to the dev flavor
# and the app on a real phone talks to http://localhost:8080 («Немає зв'язку із сервером»).
#
# Bump `version: X.Y.Z+N` in pubspec.yaml first — App Store Connect refuses a build number it has already seen.
#
# Signing and upload both go through the App Store Connect API key (Admin role: only Admin may use the cloud
# distribution certificate), so no Apple ID has to be signed in to Xcode. The key file is
# ~/.appstoreconnect/private_keys/AuthKey_<ASC_KEY_ID>.p8.
set -euo pipefail

cd "$(dirname "$0")/.."

API_BASE_URL="${API_BASE_URL:-https://api.trackbox24.com}"
ASC_KEY_ID="${ASC_KEY_ID:-SM83FXH9F8}"
ASC_ISSUER_ID="${ASC_ISSUER_ID:-6d2add13-776d-4802-865a-53b08f7db6a8}"
ASC_KEY_PATH="${ASC_KEY_PATH:-$HOME/.appstoreconnect/private_keys/AuthKey_$ASC_KEY_ID.p8}"
TEAM_ID="TS795CZCPW"

[[ -f "$ASC_KEY_PATH" ]] || { echo "✗ no API key at $ASC_KEY_PATH" >&2; exit 1; }
auth=(-allowProvisioningUpdates -authenticationKeyPath "$ASC_KEY_PATH"
  -authenticationKeyID "$ASC_KEY_ID" -authenticationKeyIssuerID "$ASC_ISSUER_ID")

echo "→ $(grep '^version:' pubspec.yaml) → $API_BASE_URL"

# Flutter writes the dart-defines and the version into the Xcode project; xcodebuild archives and signs.
flutter build ios --release --config-only \
  --dart-define=FLAVOR=prod \
  --dart-define="API_BASE_URL=$API_BASE_URL"

archive=build/ios/archive/Runner.xcarchive
rm -rf "$archive" build/ios/ipa
xcodebuild -quiet -workspace ios/Runner.xcworkspace -scheme Runner -configuration Release \
  -destination 'generic/platform=iOS' -archivePath "$archive" archive "${auth[@]}"

options=$(mktemp)
trap 'rm -f "$options"' EXIT
cat > "$options" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>method</key><string>app-store-connect</string>
<key>teamID</key><string>$TEAM_ID</string>
<key>signingStyle</key><string>automatic</string>
<key>destination</key><string>export</string>
</dict></plist>
EOF
xcodebuild -quiet -exportArchive -archivePath "$archive" -exportPath build/ios/ipa \
  -exportOptionsPlist "$options" "${auth[@]}"

# Proves the flavor actually made it into the binary, before anything reaches TestFlight. The ipa is a zip,
# so the compiled Dart code has to be unpacked to be searched.
check=$(mktemp -d)
trap 'rm -f "$options"; rm -rf "$check"' EXIT
unzip -q -o build/ios/ipa/trackbox24_mob.ipa -d "$check"
if ! grep -qa "$API_BASE_URL" "$check/Payload/Runner.app/Frameworks/App.framework/App"; then
  echo "✗ $API_BASE_URL is not in the build: it is not a prod one" >&2
  exit 1
fi

xcrun altool --upload-app --type ios -f build/ios/ipa/trackbox24_mob.ipa \
  --apiKey "$ASC_KEY_ID" --apiIssuer "$ASC_ISSUER_ID"
