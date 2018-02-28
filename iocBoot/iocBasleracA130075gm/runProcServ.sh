#!/bin/sh

# Use defaults if not set
if [ -z "${BASLER_ACA130075GM_DEVICE_TELNET_PORT}" ]; then
   BASLER_ACA130075GM_DEVICE_TELNET_PORT=20000
fi

# Run run*.sh scripts with procServ
/usr/local/bin/procServ -f -n basler_acA1300_75gm_${BASLER_ACA130075GM_INSTANCE} -i ^C^D ${BASLER_ACA130075GM_DEVICE_TELNET_PORT} ./runBasleracA130075gm.sh "$@"
