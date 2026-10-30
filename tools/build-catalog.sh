#!/bin/zsh
# Generate, build and install the Catalog on this project's own simulator.
set -e
ROOT=${0:A:h:h}  # the repository root; this script lives in tools/
# A simulator of this project's own, created on first use.
if [[ ! -s $ROOT/verify/sim-udid.txt ]]; then
  mkdir -p $ROOT/verify
  xcrun simctl create "BeautifulUI Catalog" com.apple.CoreSimulator.SimDeviceType.iPhone-17-Pro >| $ROOT/verify/sim-udid.txt
fi
UDID=$(cat $ROOT/verify/sim-udid.txt)
xcrun simctl boot $UDID 2>/dev/null || true
cd $ROOT/Catalog
xcodegen generate --quiet
LOG=$ROOT/verify/build-catalog.log
xcodebuild -project Catalog.xcodeproj -scheme Catalog -destination "id=$UDID" \
  -derivedDataPath $ROOT/verify/DerivedData build >| $LOG 2>&1 || { grep -E "error:" $LOG | head -20; echo "BUILD FAILED (see $LOG)"; exit 1; }
grep -E "BUILD SUCCEEDED" $LOG
APP=$ROOT/verify/DerivedData/Build/Products/Debug-iphonesimulator/BeautifulUI\ Catalog.app
[[ -d $APP ]] || { echo "no app built"; exit 1; }
xcrun simctl install $UDID "$APP"
echo installed
