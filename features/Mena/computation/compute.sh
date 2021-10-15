#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RUNFILE="$MYDIR/../../../TDAExplore-ML/ml-tda"
RETURNDIR="$PWD"

cd $MYDIR
"$RUNFILE" --parameters mena_inhibitor.csv --svm TRUE --cores $1 --plot TRUE --imagedir computation_results --pca TRUE --ratio 1.0 --folds 10
cd $RETURNDIR
