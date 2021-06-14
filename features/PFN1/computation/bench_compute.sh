#/usr/bin/bash

export REMORA_VERBOSE=0
export REMORA_PERIOD=1
export REMORA_MODE="FULL"
export REMORA_PLOT_RESULTS=0
MYDIR="$(dirname "$(readlink -f "$0")")"
RUNFILE="$MYDIR/../../../TDAExplore-ML/ml-tda"
RETURNDIR="$PWD"

cd $MYDIR
for RADIUS in 25 50 75 100 125
do 
	for RATIO in 0.4 0.8 1.2 1.6 2.0
	do 
		remora "$RUNFILE" --parameters PFN1.csv --svm TRUE --cores $1 --benchmark TRUE --radius $RADIUS --ratio $RATIO
		Rscript extract_remora.R --radius $RADIUS --ratio $RATIO
	done
done
cd $RETURNDIR
