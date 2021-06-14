#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RUNFILE="$MYDIR/../../../TDAExplore-ML/ml-tda"
RETURNDIR="$PWD"

cd $MYDIR
"$RUNFILE" --parameters arp_ctrl.csv --svm TRUE --cores $1 --plot TRUE --imagedir computation_results
cd $RETURNDIR