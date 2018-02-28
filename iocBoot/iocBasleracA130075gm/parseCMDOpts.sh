#!/bin/sh

while [ "$#" -gt 0 ]; do
    case "$1" in
        "-P") P="$2" ;;
        "-R") R="$2" ;;
        "-s"|"--serial-number") SERIAL_NUMBER="$2" ;;
        *) echo "Usage:" >&2
            echo "  $0 -s SERIAL_NUMBER [-P P_VAL] [-R R_VAL] " >&2
            echo >&2
            echo " Options:" >&2
            echo "  -s or --serial-number                    Configure device serial number" >&2
            echo "  -P                                       Configure value of \$(P) macro" >&2
            echo "  -R                                       Configure value of \$(R) macro" >&2
            exit 2
    esac

    shift 2
done
