#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RUNFILE="$MYDIR/../../../TDAExplore-ML/ml-tda"
RETURNDIR="$PWD"

cd $MYDIR
TRAINFILE=$(ls ../../../features/PFN1/computation/computation_results/ | grep -v .*plots.*)
FULLPATH="../../../features/PFN1/computation/computation_results/$TRAINFILE"
"$RUNFILE" --parameters parameters.csv --cores $1 --plot TRUE --training $FULLPATH --radius 75
cd $RETURNDIR