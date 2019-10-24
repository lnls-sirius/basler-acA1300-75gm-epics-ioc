# Many of the parameters defined in this file are also in plugins_settings.req so if autosave is being
# use the autosave value will replace the value passed to this file.

# $(PREFIX)      Prefix for all records
# $(PORT)        The port name for the detector.  In autosave.
# $(QSIZE)       The queue size for all plugins.  In autosave.
# $(XSIZE)       The maximum image width; used to set the maximum size for row profiles in the NDPluginStats plugin and 1-D FFT
#                   profiles in NDPluginFFT.
# $(YSIZE)       The maximum image height; used to set the maximum size for column profiles in the NDPluginStats plugin
# $(NCHANS)      The maximum number of time series points in the NDPluginStats, NDPluginROIStats, and NDPluginAttribute plugins
# $(CBUFFS)      The maximum number of frames buffered in the NDPluginCircularBuff plugin
# $(MAX_THREADS) The maximum number of threads for plugins which can run in multiple threads. Defaults to 5.

# Create a transform plugin
NDTransformConfigure("TRANSF1", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("$(ADCORE)/db/NDTransform.template", "P=$(PREFIX), R=Transf1, PORT=TRANSF1, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT)")

# Create 2 processing plugins
NDProcessConfigure("PROC1", $(QSIZE), 0, "TRANSF1", 0, 0, 0, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDProcess.template", "P=$(PREFIX), R=Proc1, PORT=PROC1, ADDR=0, TIMEOUT=1, NDARRAY_PORT=TRANSF1")
NDProcessConfigure("PROC2", $(QSIZE), 0, "PROC1", 0, 0, 0, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDProcess.template", "P=$(PREFIX), R=Proc2, PORT=PROC2, ADDR=0, TIMEOUT=1, NDARRAY_PORT=PROC1")

# Create a ROI plugin
NDROIConfigure("ROI1", $(QSIZE), 0, "PROC2", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROI.template",       "P=$(PREFIX),R=ROI1,  PORT=ROI1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=PROC2")

# Create 2 statistics plugins
NDStatsConfigure("STATS1", $(QSIZE), 0, "PROC2", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDStats.template",     "P=$(PREFIX),R=Stats1,  PORT=STATS1,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),NDARRAY_PORT=PROC2")
NDTimeSeriesConfigure("STATS1_TS", $(QSIZE), 0, "STATS1", 1, 23, 0, 0, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(PREFIX),R=Stats1TS, PORT=STATS1_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=STATS1,NDARRAY_ADDR=1,NCHANS=$(NCHANS),ENABLED=1")

NDStatsConfigure("STATS2", $(QSIZE), 0, "ROI1",    0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDStats.template",     "P=$(PREFIX),R=Stats2,  PORT=STATS2,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),NDARRAY_PORT=ROI1")
NDTimeSeriesConfigure("STATS2_TS", $(QSIZE), 0, "STATS2", 1, 23, 0, 0, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(PREFIX),R=Stats2TS, PORT=STATS2_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=STATS2,NDARRAY_ADDR=1,NCHANS=$(NCHANS),ENABLED=1")

# Create a DimFei plugin
NDDimFeiConfigure("DIMFEI1", $(QSIZE), 0, "PROC2", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("$(DIMFEI)/db/NDDimFei.template", "P=$(PREFIX), R=DimFei1, PORT=DIMFEI1, ADDR=0, TIMEOUT=1, NDARRAY_PORT=PROC2")

# Create an overlay plugin with 4 overlays
NDOverlayConfigure("OVER1", $(QSIZE), 0, "PROC2", 0, 4, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("$(ADCORE)/db/NDOverlay.template", "P=$(PREFIX), R=Over1, PORT=OVER1, ADDR=0, TIMEOUT=1, NDARRAY_PORT=PROC2")
dbLoadRecords("$(ADCORE)/db/NDOverlayN.template","P=$(PREFIX), R=Over1A, NAME=CentroidNDStats, SHAPE=0, O=Over1, PORT=OVER1, ADDR=0, TIMEOUT=1")
dbLoadRecords("$(ADCORE)/db/NDOverlayN.template","P=$(PREFIX), R=Over1B, NAME=CentroidDimFei, SHAPE=0, O=Over1, PORT=OVER1, ADDR=1, TIMEOUT=1")
dbLoadRecords("$(ADCORE)/db/NDOverlayN.template","P=$(PREFIX), R=Over1C, NAME=CenterCal, SHAPE=0, O=Over1, PORT=OVER1, ADDR=2, TIMEOUT=1")
dbLoadRecords("$(ADCORE)/db/NDOverlayN.template","P=$(PREFIX), R=Over1D, NAME=CenterReal, SHAPE=0, O=Over1, PORT=OVER1, ADDR=3, TIMEOUT=1")

# Create 1 color conversion plugin
NDColorConvertConfigure("CC1", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDColorConvert.template", "P=$(PREFIX), R=CC1, PORT=CC1, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT)")

# Load ffmpegServer plugin
ffmpegServerConfigure(8080)
ffmpegStreamConfigure("FfmStream1", 2, 0, "$(PORT)", 0, -1, 0)
dbLoadRecords("$(FFMPEGSERVER)/db/ffmpegStream.template", "P=$(PREFIX), R=ffmstream1, PORT=FfmStream1, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT)")
#ffmpegFileConfigure("FfmFile1", 16, 0, "$(PORT)", 0, -1, 0)
#dbLoadRecords("$(FFMPEGSERVER)/db/ffmpegFile.template", "P=$(PREFIX), R=ffmfile1, PORT=FfmFile1, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT)")
