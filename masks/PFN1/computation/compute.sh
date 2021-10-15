#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RUNFILE="$MYDIR/../../../TDAExplore-ML/convolve-tda"
RETURNDIR="$PWD"

cd $MYDIR
TRAINFILE=$(ls ../../../features/PFN1/computation/computation_results/ | grep -v .*plots.*)
"$RUNFILE" --training "../../../features/PFN1/computation/computation_results/$TRAINFILE" --folders ../../../data/PFN1KO/CTRL,../../../data/PFN1KO/KO --svm TRUE --cores $1 --directory computation_results --svm TRUE --separate TRUE --lines TRUE --classes Control,Knockout --negate TRUE
cd $RETURNDIR
