< envPaths

epicsEnvSet("TOP", "../..")

# Set the maximum Channel Access array size
errlogInit(20000)

dbLoadDatabase("$(TOP)/dbd/basleracA130075gm.dbd")
basleracA130075gm_registerRecordDeviceDriver(pdbbase) 

# Prefix for all records
epicsEnvSet("PREFIX", "$(P)$(R)")
# The port name for the detector
epicsEnvSet("PORT",   "ARV1")
# The queue size for all plugins
epicsEnvSet("QSIZE",  "20")
# The maximim image width; used for row profiles in the NDPluginStats plugin
epicsEnvSet("XSIZE",  "1280")
# The maximim image height; used for column profiles in the NDPluginStats plugin
epicsEnvSet("YSIZE",  "1024")
# The maximum number of time series points in the NDPluginStats plugin
epicsEnvSet("NCHANS", "2048")
# The maximum number of frames buffered in the NDPluginCircularBuff plugin
epicsEnvSet("CBUFFS", "500")
# The search path for database files
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")

aravisCameraConfig("$(PORT)", "Basler-$(SERIAL_NUMBER)")
asynSetTraceMask("$(PORT)",0,0x21)

# Template needed by IOC from aravisGigE
dbLoadRecords("$(ARAVISGIGE)/db/aravisCamera.template", "P=$(PREFIX),R=cam1:,PORT=$(PORT),ADDR=0,TIMEOUT=1")
# Auto-generated template from camera xml file
dbLoadRecords("$(TOP)/db/Basler_acA1300_75gm.template","P=$(PREFIX),R=cam1:,PORT=$(PORT),ADDR=0,TIMEOUT=1")
# Sirius-naming-convention compliant PVs
dbLoadRecords("$(TOP)/db/BaslerSiriusStandard.db","P=$(P),R=$(R)")

# Create a standard arrays plugin
NDStdArraysConfigure("Image1", 5, 0, "$(PORT)", 0, 0)
# Allow for cameras up to 1280x1024x3 for RGB
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),TYPE=Int16,FTVL=SHORT,NELEMENTS=3932160")

# Load all other plugins using commonPlugins.cmd
< $(ADCORE)/iocBoot/commonPlugins.cmd
set_requestfile_path("$(ADPILATUS)/prosilicaApp/Db")

#asynSetTraceMask("$(PORT)",0,255)
#asynSetTraceMask("$(PORT)",0,3)

< save_restore.cmd

iocInit()

# save things every thirty seconds
create_monitor_set("auto_settings_basler_acA1300_75gm.req", 30,"P=$(P)$(R), R=")
# The following line is necessary because of the save file name used in save_restore.cmd
set_savefile_name("auto_settings_basler_acA1300_75gm.req", "auto_settings_${P}${R}.sav")
