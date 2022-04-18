--By pavlov&bekiroj

function SkinYukle5708()
    local txd = engineLoadTXD ('Dosyalar/1.txd')
    engineImportTXD(txd,5708)
    local dff = engineLoadDFF('Dosyalar/2.dff',5708)
    engineReplaceModel(dff,5708)
end
addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),SkinYukle5708)

--By pavlov&bekiroj