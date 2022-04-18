local sx , sy = guiGetScreenSize()
local cbrowser = guiCreateBrowser(sx/2-130,sy-32 , 475 , 75 , true , true , false)
local browser  = guiGetBrowser(cbrowser)

if cbrowser then

    addEventHandler('onClientBrowserCreated', cbrowser,function()
        loadBrowserURL(source , "http://mta/local/index.html")
    end)
end

function drawBrowser()                    
    local hanz = {}
    
    hanz['hunger'] = localPlayer:getData("hunger") or 0
    hanz['thirst'] = localPlayer:getData("thirst") or 0

    table.foreach(hanz , function(k,v)

        executeBrowserJavascript(browser , "document.getElementById('"..k.."').style.width = '"..v.."%';")

    end)
end         
setTimer(drawBrowser , 0 , 0)