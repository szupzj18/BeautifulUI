#!/bin/zsh
# Generate, build and install the Catalog on this project's own simulator.
set -e
ROOT=${0:A:h:h}  # the repository root; this script lives in tools/
UDID=$(cat $ROOT/verify/sim-udid.txt)
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
