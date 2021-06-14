#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RUNFILE="$MYDIR/../../../TDAExplore-ML/ml-tda"
RETURNDIR="$PWD"

cd $MYDIR
"$RUNFILE" --parameters bbbc16.csv --svm TRUE --cores $1 --plot TRUE --imagedir computation_results --ratio 2.0 --radius 75 
cd $RETURNDIR