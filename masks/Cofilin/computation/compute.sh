#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RUNFILE="$MYDIR/../../../TDAExplore-ML/convolve-tda"
RETURNDIR="$PWD"

cd $MYDIR
TRAINFILE=$(ls ../../../features/Cofilin/computation/computation_results/ | grep -v .*plots.*)
"$RUNFILE" --training "../../../features/Cofilin/computation/computation_results/$TRAINFILE" --folders ../../../data/Cofilin1KD/CTRL,../../../data/Cofilin1KD/KD --svm TRUE --cores $1 --directory computation_results --svm TRUE --separate TRUE --lines TRUE --classes Control,Knockdown --negate TRUE
cd $RETURNDIR
