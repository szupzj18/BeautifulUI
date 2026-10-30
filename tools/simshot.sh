#!/bin/zsh
# Launch the Catalog on this project's own simulator at one component/variant/theme,
# screenshot it and crop to the demo surface.
#
#   tools/simshot.sh <component-id> <variant|-> <dark|light> <wait-seconds> <out.png> [state]
#
# EXTRA=<pt> in the environment extends the crop below the surface (for overflowing popovers).
# Expects the app already built into verify/DerivedData (see tools/build-catalog.sh).
set -e
ROOT=${0:A:h:h}  # the repository root; this script lives in tools/
UDID=$(cat $ROOT/verify/sim-udid.txt)
BUNDLE=com.chrispan.BeautifulUICatalog
COMPONENT=$1 VARIANT=$2 THEME=$3 WAIT=$4 OUT=$5 STATE=${6:-}
RAW=$ROOT/verify/sim-raw/${COMPONENT}-${VARIANT}-${THEME}.png
mkdir -p $ROOT/verify/sim-raw

DATA=$(xcrun simctl get_app_container $UDID $BUNDLE data)
FRAME=$DATA/Documents/surface-frame.json
[[ -f $FRAME ]] && : >| $FRAME
xcrun simctl terminate $UDID $BUNDLE >/dev/null 2>&1 || true
ARGS=(-component $COMPONENT -theme $THEME -shot YES)
[[ $VARIANT != - ]] && ARGS+=(-variant $VARIANT)
[[ -n $STATE ]] && ARGS+=(-state $STATE)
xcrun simctl launch $UDID $BUNDLE $ARGS >/dev/null
sleep $WAIT
# The page reports its surface frame once laid out; wait for one that lies on screen (402 × 874).
for attempt in 1 2 3 4 5 6 7 8 9 10; do
  FRAME_LINE=$(python3 -I -c 'import json,sys
try:
    f=json.load(open(sys.argv[1]))
except Exception:
    sys.exit(1)
ok = f["x"] >= 0 and f["y"] >= 0 and f["x"] + f["width"] <= 402.5 and f["y"] + f["height"] <= 874.5
print(f["x"], f["y"], f["width"], f["height"]) if ok else sys.exit(1)' $FRAME) && break
  sleep 0.5
done
[[ -n $FRAME_LINE ]] || { echo "no on-screen surface frame for $COMPONENT $VARIANT $THEME" >&2; exit 1; }
xcrun simctl io $UDID screenshot --type=png $RAW >/dev/null 2>&1
read X Y W H <<< "$FRAME_LINE"
H=$(( H + ${EXTRA:-0} ))
$ROOT/verify/bin/compose crop $RAW $X $Y $W $H 3 $OUT
echo "$OUT"
