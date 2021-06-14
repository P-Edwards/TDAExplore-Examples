#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RUNFILE="$MYDIR/../../../TDAExplore-ML/ml-tda"
RETURNDIR="$PWD"

cd $MYDIR
"$RUNFILE" --parameters mito.csv --svm TRUE --cores $1 --plot TRUE --pca TRUE --folds 10 --imagedir computation_results
cd $RETURNDIR