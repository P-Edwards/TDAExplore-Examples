#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RETURNDIR="$PWD"

cd $MYDIR
Rscript computation.R --parameters parameters.csv --cores $1
cd $RETURNDIR