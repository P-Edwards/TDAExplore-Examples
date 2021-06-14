#/usr/bin/bash

MYDIR="$(dirname "$(readlink -f "$0")")"
RUNFILE="$MYDIR/plotting.R"
RETURNDIR="$PWD"

cd $MYDIR
Rscript "$RUNFILE"
cd $RETURNDIR