#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RUNFILE="$MYDIR/../../../TDAExplore-ML/ml-tda"
RETURNDIR="$PWD"

cd $MYDIR
"$RUNFILE" --parameters binucleate.csv --svm TRUE --cores $1 --plot TRUE --pca FALSE --multisvm FALSE --imagedir computation_results --ratio 2.0 --radius 75
cd $RETURNDIR
