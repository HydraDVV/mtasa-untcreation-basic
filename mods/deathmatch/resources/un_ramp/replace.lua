function applyMods()
   local txd = engineLoadTXD ( "models/lifts.txd")
   engineImportTXD ( txd, 2052 )
   local dff = engineLoadDFF("models/liftposts.dff", 2052 )
   engineReplaceModel(dff, 2052)
   local col = engineLoadCOL ( "models/liftposts.col")
   engineReplaceCOL ( col, 2052 )
   local txd = engineLoadTXD ( "models/lifts.txd")
   engineImportTXD ( txd, 2053 )
   local dff = engineLoadDFF("models/ramps.dff", 2053 )
   engineReplaceModel(dff, 2053)
   local col = engineLoadCOL ( "models/ramps.col")
   engineReplaceCOL ( col, 2053 )
   
   local txd = engineLoadTXD ( "models/stand.txd")
   engineImportTXD ( txd, 2365 )
   local dff = engineLoadDFF("models/stand.dff", 2365 )
   engineReplaceModel(dff, 2365)
   local col = engineLoadCOL ( "models/stand.col")
   engineReplaceCOL ( col, 2365 )
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()),
     function()
         applyMods()
         setTimer (applyMods, 1000, 2)
end
)