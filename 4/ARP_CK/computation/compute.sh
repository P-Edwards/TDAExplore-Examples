#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RUNFILE="$MYDIR/../../../TDAExplore-ML/convolve-tda"
RETURNDIR="$PWD"

cd $MYDIR
TRAINFILE=$(ls ../../../3/ARP_CK/computation/computation_results/ | grep -v .*plots.*)
"$RUNFILE" --training "../../../3/ARP_CK/computation/computation_results/$TRAINFILE" --folders ../../../data/arp/ctrl_666/whole,../../../data/arp/ctrl_689/whole --svm TRUE --cores $1 --directory computation_results --svm TRUE --separate TRUE --lines TRUE --classes CTRL_666,CTRL689 --negate TRUE
cd $RETURNDIR
