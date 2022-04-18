deletefiles =
{ "data/kz.col",
"data/kz.dff", 
"data/kz.txd", }

function onStartResourceDeleteFiles()
for i=1, #deletefiles do
fileDelete(deletefiles[i])
end
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), onStartResourceDeleteFiles)
