txd = engineLoadTXD ( "object.txd" )
engineImportTXD ( txd, 5762 )
dff = engineLoadDFF ( "object.dff" )
engineReplaceModel ( dff, 5762 )
engineSetModelLODDistance(5762, 10000)