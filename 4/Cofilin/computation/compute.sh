#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RUNFILE="$MYDIR/../../../TDAExplore-ML/convolve-tda"
RETURNDIR="$PWD"

cd $MYDIR
TRAINFILE=$(ls ../../../3/Cofilin/computation/computation_results/ | grep -v .*plots.*)
"$RUNFILE" --training "../../../3/Cofilin/computation/computation_results/$TRAINFILE" --folders ../../../data/cofilin/cofilin_ctrls_whole,../../../data/cofilin/cofilin_kd_whole --svm TRUE --cores $1 --directory computation_results --svm TRUE --separate TRUE
cd $RETURNDIR