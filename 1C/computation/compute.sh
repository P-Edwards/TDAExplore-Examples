#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RUNFILE="$MYDIR/../../TDAExplore-ML/convolve-tda"
RETURNDIR="$PWD"

cd $MYDIR
"$RUNFILE" --image "$MYDIR/../../data/gene/ctrl/whole/33_WHOLE.tif" --directory computation_results --tsne TRUE --patches 2000 --radius 75 --cores $1 --separate TRUE
cd $RETURNDIR