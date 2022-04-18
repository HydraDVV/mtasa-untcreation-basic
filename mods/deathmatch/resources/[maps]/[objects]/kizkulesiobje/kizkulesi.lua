function replaceModel()
  txd = engineLoadTXD("data/kz.txd", 17014 )
  engineImportTXD(txd, 17014)
  dff = engineLoadDFF("data/kz.dff", 17014 )
  engineReplaceModel(dff, 17014)
  col = engineLoadCOL("data/kz.col", 17014 )
  engineReplaceCOL(col, 17014)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)