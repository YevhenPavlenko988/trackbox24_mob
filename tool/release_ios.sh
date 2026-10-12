#!/usr/bin/env bash
# Builds the iOS release for TestFlight and uploads it.
#
# The --dart-define pair is the whole point of this script: without it the build falls back to the dev flavor
# and the app on a real phone talks to http://localhost:8080 («Немає зв'язку із сервером»).
#
# Bump `version: X.Y.Z+N` in pubspec.yaml first — App Store Connect refuses a build number it has already seen.
set -euo pipefail

cd "$(dirname "$0")/.."

API_BASE_URL="${API_BASE_URL:-https://api.trackbox24.com}"
ASC_KEY_ID="${ASC_KEY_ID:-ASTHSL8FSM}"
ASC_ISSUER_ID="${ASC_ISSUER_ID:-6d2add13-776d-4802-865a-53b08f7db6a8}"

echo "→ $(grep '^version:' pubspec.yaml) → $API_BASE_URL"

flutter build ipa --release --export-method app-store \
  --dart-define=FLAVOR=prod \
  --dart-define="API_BASE_URL=$API_BASE_URL"

# Proves the flavor actually made it into the binary, before anything reaches TestFlight. The ipa is a zip,
# so the compiled Dart code has to be unpacked to be searched.
check=$(mktemp -d)
trap 'rm -rf "$check"' EXIT
unzip -q -o build/ios/ipa/trackbox24_mob.ipa -d "$check"
if ! grep -qa "$API_BASE_URL" "$check/Payload/Runner.app/Frameworks/App.framework/App"; then
  echo "✗ $API_BASE_URL is not in the build: it is not a prod one" >&2
  exit 1
fi

xcrun altool --upload-app --type ios -f build/ios/ipa/trackbox24_mob.ipa \
  --apiKey "$ASC_KEY_ID" --apiIssuer "$ASC_ISSUER_ID"
