#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RETURNDIR="$PWD"

cd $MYDIR
Rscript ../../repeated_computation.R --parameters liver_cr.csv --cores $1
cd $RETURNDIR