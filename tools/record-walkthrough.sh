#!/bin/zsh
# Record demo/walkthrough-raw.mp4 on this project's simulator while the WalkthroughTests UI
# test drives the Catalog (dark pass over all components, then three in light).
set -e
ROOT=${0:A:h:h}  # the repository root; this script lives in tools/
UDID=$(cat $ROOT/verify/sim-udid.txt)
RAW=$ROOT/demo/walkthrough-raw.mp4
cd $ROOT/Catalog
xcodebuild build-for-testing -project Catalog.xcodeproj -scheme Catalog -destination "id=$UDID" \
  -derivedDataPath $ROOT/verify/DerivedData >| $ROOT/verify/uitest-build.log 2>&1
xcrun simctl status_bar $UDID override --time "9:41" --batteryState charged --batteryLevel 100 --wifiBars 3 --cellularBars 4
xcrun simctl io $UDID recordVideo --codec=h264 --force $RAW >| $ROOT/verify/record.log 2>&1 &
REC=$!
sleep 2
xcodebuild test-without-building -project Catalog.xcodeproj -scheme Catalog -destination "id=$UDID" \
  -derivedDataPath $ROOT/verify/DerivedData -only-testing:CatalogUITests/WalkthroughTests >| $ROOT/verify/uitest-record.log 2>&1 || echo "UI test exit $?"
sleep 1
kill -INT $REC
wait $REC || true
grep -E "passed \(|failed \(" $ROOT/verify/uitest-record.log
ls -la $RAW
