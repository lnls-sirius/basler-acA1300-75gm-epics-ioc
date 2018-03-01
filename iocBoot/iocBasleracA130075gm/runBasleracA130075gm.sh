#!/bin/sh

# Source environment
. ./checkEnv.sh

# Parse command-line options
. ./parseCMDOpts.sh "$@"

# Check last command return status
if [ $? -ne 0 ]; then
	echo "Could not parse command-line options" >&2
	exit 1
fi

if [ -z "$SERIAL_NUMBER" ]; then
    echo "\$SERIAL_NUMBER is not set, Please use -s option" >&2
    exit 7
fi

if [ -z "$EPICS_CA_MAX_ARRAY_BYTES" ]; then
    export EPICS_CA_MAX_ARRAY_BYTES="8000000"
fi

cd "$IOC_BOOT_DIR"

P="$P" R="$R" SERIAL_NUMBER="$SERIAL_NUMBER" "$IOC_BIN" stBasleracA130075gm.cmd