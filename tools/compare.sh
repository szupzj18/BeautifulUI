#!/bin/zsh
# Build compare/<NN>-<id>.jpg for one component: one row per variant/state, columns
# SwiftUI dark | SwiftUI light. Every screenshot is taken from the Catalog on a simulator.
#
#   tools/compare.sh <NN> <component-id> <title> <row>...
#   row = <variant-slug>:<state-label>:<ios-variant|->:<ios-wait-seconds>[:<ios-state>[:<extra-pt>]]
#
# <variant-slug> and <state-label> only name the row (and the screenshot file); the app is driven by
# <ios-variant>, <ios-wait-seconds> and <ios-state>.
# COMPOSE_ONLY=1 skips the simulator and reuses the screenshots already in verify/ios/.
set -e
ROOT=${0:A:h:h}  # the repository root; this script lives in tools/
N=$1 ID=$2 TITLE=$3
[[ -x $ROOT/verify/bin/compose ]] || { mkdir -p $ROOT/verify/bin; swiftc -O $ROOT/tools/compose.swift -o $ROOT/verify/bin/compose; }
shift 3
IMAGES=() LABELS=()
for row in $@; do
  IFS=: read WV WS IV WAIT ISTATE IEXTRA <<< "$row"
  LABELS+=("${WV} · ${WS}${ISTATE:+ · state $ISTATE}")
  for theme in dark light; do
    IOS=$ROOT/verify/ios/$N-$ID-$WV-$WS${ISTATE:+-$ISTATE}-$theme.png
    if [[ -z $COMPOSE_ONLY ]]; then
      EXTRA=${IEXTRA:-0} $ROOT/tools/simshot.sh $ID $IV $theme $WAIT $IOS $ISTATE >/dev/null
    fi
    IMAGES+=($IOS)
  done
done
# Full-size PNG stays local in verify/; the repository keeps the JPEG.
mkdir -p $ROOT/verify/compare-png
PNG=$ROOT/verify/compare-png/$N-$ID.png
$ROOT/verify/bin/compose grid "$N $TITLE — BeautifulUI" $PNG \
  "SwiftUI · dark|SwiftUI · light" "${(j:|:)LABELS}" $IMAGES
sips -s format jpeg -s formatOptions 72 $PNG --out $ROOT/compare/$N-$ID.jpg >/dev/null
echo $ROOT/compare/$N-$ID.jpg
