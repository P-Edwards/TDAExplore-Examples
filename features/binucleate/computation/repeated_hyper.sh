#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RETURNDIR="$PWD"

cd $MYDIR
Rscript ../../repeated_computation_hyper.R --parameters binucleate.csv --cores $1
cd $RETURNDIR