#!/bin/sh

set -e 

usage () {
    echo "Usage:" >&2
    echo "  $1 [-t PROCSERV_TELNET_PORT] [-P P_VAL] [-R R_VAL] -s SERIAL_NUMBER [-H HTTP_PORT] [-n FFMPEG_PORT] " >&2
    echo >&2
    echo " Options:" >&2
    echo "  -t                  Configure procServ telnet port" >&2
    echo "  -P                  Configure value of \$(P) macro" >&2
    echo "  -R                  Configure value of \$(R) macro" >&2
    echo "  -s                  Configure device serial number" >&2
    echo "  -A                  Configure alias prefix for high level PVs" >&2
    echo "  -H                  Configure HTTP server port" >&2
    echo "  -n                  Configure MPEG stream port name. This is the name shown in HTTP server index page" >&2
}

while getopts ":t:P:R:s:A:H:n:" opt; do
  case $opt in
    t) DEVICE_TELNET_PORT="$OPTARG" ;;
    P) P="$OPTARG" ;;
    R) R="$OPTARG" ;;
    s) SERIAL_NUMBER="$OPTARG" ;;
    A) NEW_PREFIX="$OPTARG";;
    H) HTTP_PORT="$OPTARG";;
    n) FFMPEG_PORT="$OPTARG";;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage $0
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      usage $0
      exit 1
      ;;
  esac
done

# if getopts did not process all input
if [ "$OPTIND" -le "$#" ]; then
    echo "Invalid argument at index '$OPTIND' does not have a corresponding option." >&2
    usage $0
    exit 1
fi
