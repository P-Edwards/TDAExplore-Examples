#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RUNFILE="$MYDIR/../../../TDAExplore-ML/convolve-tda"
RETURNDIR="$PWD"

cd $MYDIR
TRAINFILE=$(ls ../../../features/TB4/computation/computation_results/ | grep -v .*plots.*)
"$RUNFILE" --training "../../../features/TB4/computation/computation_results/$TRAINFILE" --folders ../../../data/TBeta4KD/CTRL,../../../data/TBeta4KD/KD --svm TRUE --cores $1 --directory computation_results --svm TRUE --separate TRUE --lines TRUE --classes Control,Knockdown --negate TRUE
cd $RETURNDIR