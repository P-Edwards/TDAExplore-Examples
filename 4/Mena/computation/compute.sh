#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RUNFILE="$MYDIR/../../../TDAExplore-ML/convolve-tda"
RETURNDIR="$PWD"

cd $MYDIR
TRAINFILE=$(ls ../../../3/Mena/computation/computation_results/ | grep -v .*plots.*)
"$RUNFILE" --training "../../../3/Mena/computation/computation_results/$TRAINFILE" --folders ../../../data/mena_whole_only/ap4,../../../data/mena_whole_only/fp4 --svm TRUE --cores $1 --directory computation_results --svm TRUE --separate TRUE
cd $RETURNDIR