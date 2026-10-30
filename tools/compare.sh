#!/bin/zsh
# Build compare/<NN>-<id>.jpg for one component: one row per variant/state, columns
# web dark | iOS dark | web light | iOS light.
#
#   tools/compare.sh <NN> <component-id> <title> <row>...
#   row = <web-variant-slug>:<web-state mid|end|t<ms>|name>:<ios-variant|->:<ios-wait-seconds>[:<ios-state>[:<extra-pt>]]
set -e
ROOT=${0:A:h:h}  # the repository root; this script lives in tools/
N=$1 ID=$2 TITLE=$3
[[ -x $ROOT/verify/bin/compose ]] || { mkdir -p $ROOT/verify/bin; swiftc -O $ROOT/tools/compose.swift -o $ROOT/verify/bin/compose; }
shift 3
IMAGES=() LABELS=()
for row in $@; do
  IFS=: read WV WS IV WAIT ISTATE IEXTRA <<< "$row"
  LABELS+=("${WV} · ${WS}${ISTATE:+ · iOS state $ISTATE}")
  for theme in dark light; do
    IOS=$ROOT/verify/ios/$N-$ID-$WV-$WS${ISTATE:+-$ISTATE}-$theme.png
    EXTRA=${IEXTRA:-0} $ROOT/tools/simshot.sh $ID $IV $theme $WAIT $IOS $ISTATE >/dev/null
    # Anything but mid/end comes from shoot-timeline.mjs (fresh page load per capture).
    if [[ $WS != mid && $WS != end ]]; then WEB=$ROOT/reference/shots/timeline-$theme/$N-$ID-$WV-$WS.png
    else WEB=$ROOT/reference/shots/phone-$theme/$N-$ID-$WV-$WS.png; fi
    IMAGES+=($WEB $IOS)
  done
done
# Full-size PNG stays local in verify/; the repository keeps a 1600 px JPEG.
mkdir -p $ROOT/verify/compare-png
PNG=$ROOT/verify/compare-png/$N-$ID.png
$ROOT/verify/bin/compose grid "$N $TITLE — beautifului.dev vs BeautifulUI" $PNG \
  "web · dark|SwiftUI · dark|web · light|SwiftUI · light" "${(j:|:)LABELS}" $IMAGES
sips -s format jpeg -s formatOptions 72 --resampleWidth 1600 $PNG --out $ROOT/compare/$N-$ID.jpg >/dev/null
echo $ROOT/compare/$N-$ID.jpg
