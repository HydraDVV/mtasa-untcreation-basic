
addEventHandler('onClientResourceStart', resourceRoot,
function()
local txd = engineLoadTXD('object.txd',true)
engineImportTXD(txd, 8068)
engineSetModelLODDistance(8068, 5500)
end)
