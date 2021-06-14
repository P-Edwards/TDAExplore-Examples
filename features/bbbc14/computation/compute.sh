#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RUNFILE="$MYDIR/../../../TDAExplore-ML/ml-tda"
RETURNDIR="$PWD"

cd $MYDIR
"$RUNFILE" --parameters bbbc14.csv --svm TRUE --cores $1 --plot TRUE --imagedir computation_results --ratio 2.0 --radius 75 
cd $RETURNDIR