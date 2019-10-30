# basler-acA1300-75gm-epics-ioc

### Overall

Repository containing the EPICS IOC support for the Basler acA1300-75gm camera.

### Building

In order to build the IOC, from the top level directory, run:

```sh
$ make clean uninstall install
```
### Running

In order to run the IOC, from the top level directory, run:

```sh
$ cd iocBoot/iocBasleracA130075gm &&
$ ./runBasleracA130075gm.sh -s "SERIAL_NUMBER"
```

where `SERIAL_NUMBER` is the serial number of the device to connect to. The options
that you can specify (after `./runBasleracA130075gm.sh`) are:

- `-s SERIAL_NUMBER`: serial number of the camera to connect to
- `-P PREFIX1`: the value of the EPICS `$(P)` macro used to prefix the PV names
- `-R PREFIX2`: the value of the EPICS `$(R)` macro used to prefix the PV names
- `-t TELNET_PORT`: telnet port to use for connecting to procServ (defaults to 20000)
- `-A HL_PREFIX`: the prefix to use for the high level PVs defined in the IOC
- `-H HTTP_PORT`: the HTTP server port to use for ffmpeg server (default 8080)
- `-n FFMPEG_PORT`: the ffmpeg server port name to use. This will be displayed on the server index page

In some situations it is desired to run the process using procServ,
which enables the IOC to be controlled by the system. In order to
run the IOC with procServ, instead of the previous command, run:

```sh
$ ./runProcServ.sh -t "TELNET_PORT" -s "SERIAL_NUMBER" -P "PREFIX1" -R "PREFIX2" -A "HL_PREFIX" -H "HTTP_PORT" -n "FFMPEG_PORT"
```

where the options are as previously described.

