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
xcrun simctl io $UDID screenshot --type=png $RAW >/dev/null 2>&1
read X Y W H < <(python3 -I -c 'import json,sys; f=json.load(open(sys.argv[1])); print(f["x"], f["y"], f["width"], f["height"])' $FRAME)
H=$(( H + ${EXTRA:-0} ))
$ROOT/verify/bin/compose crop $RAW $X $Y $W $H 3 $OUT
echo "$OUT"
