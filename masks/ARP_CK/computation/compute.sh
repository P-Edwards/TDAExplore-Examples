#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RUNFILE="$MYDIR/../../../TDAExplore-ML/convolve-tda"
RETURNDIR="$PWD"

cd $MYDIR
TRAINFILE=$(ls ../../../features/ARP_CK/computation/computation_results/ | grep -v .*plots.*)
"$RUNFILE" --training "../../../features/ARP_CK/computation/computation_results/$TRAINFILE" --folders ../../../data/CK-666/KD,../../../data/arp/CK-666/CTRL --svm TRUE --cores $1 --directory computation_results --svm TRUE --separate TRUE --lines TRUE --classes CTRL_666,CTRL689 --negate TRUE
cd $RETURNDIR
