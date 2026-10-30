#!/bin/zsh
# Build compare/<NN>-<id>.png for one component: one row per variant/state, columns
# web dark | iOS dark | web light | iOS light.
#
#   tools/compare.sh <NN> <component-id> <title> <row>...
#   row = <web-variant-slug>:<web-state mid|end>:<ios-variant|->:<ios-wait-seconds>
set -e
ROOT=${0:A:h:h}  # the repository root; this script lives in tools/
N=$1 ID=$2 TITLE=$3
shift 3
IMAGES=() LABELS=()
for row in $@; do
  IFS=: read WV WS IV WAIT <<< "$row"
  LABELS+=("${WV} · ${WS}")
  for theme in dark light; do
    IOS=$ROOT/verify/ios/$N-$ID-$WV-$WS-$theme.png
    $ROOT/tools/simshot.sh $ID $IV $theme $WAIT $IOS >/dev/null
    IMAGES+=($ROOT/reference/shots/phone-$theme/$N-$ID-$WV-$WS.png $IOS)
  done
done
$ROOT/verify/bin/compose grid "$N $TITLE — beautifului.dev vs BeautifulUI" $ROOT/compare/$N-$ID.png \
  "web · dark|SwiftUI · dark|web · light|SwiftUI · light" "${(j:|:)LABELS}" $IMAGES
echo $ROOT/compare/$N-$ID.png
