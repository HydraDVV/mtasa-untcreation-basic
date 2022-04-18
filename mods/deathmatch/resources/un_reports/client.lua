
local sx, sy = guiGetScreenSize()
local browser = guiCreateBrowser(0, 0, sx, sy, true, true, false)
guiSetVisible(browser, false)
local theBrowser = guiGetBrowser(browser)

addEventHandler("onClientBrowserCreated", theBrowser, 
	function()
		loadBrowserURL(source, "http://mta/local/index.html")
	end
)

addEvent("reports.send",true)
addEventHandler("reports.send",root,function(value)
		if value == "" then 
				outputChatBox(""..exports.installer:getServerName()..":#F9F9F9 Lütfen bir rapor açıklaması giriniz.",57,57,57,true) 
			return false 
		elseif value == "Sorununuzu detaylıca anlatınız." then 
				outputChatBox(""..exports.installer:getServerName()..":#F9F9F9 Lütfen bir rapor açıklaması giriniz.",57,57,57,true) 
			return false 
		end

	if getElementData(getLocalPlayer(), "reportNum") then
			outputChatBox(""..exports.installer:getServerName()..":#F9F9F9 Şu raporun --> #" .. (getElementData(getLocalPlayer(), "reportNum")).. " hala beklemede. Lütfen bekle ya da /er yazarak önceki raporunu kapat.",255,0,0,true)
	else
		triggerServerEvent("clientSendReport", getLocalPlayer(),  getLocalPlayer(), value, 2)
		reportClose()
	end
end)

bindKey("F2","down",function()
	if not guiGetVisible(browser,true) then
		reportOpen()
	else
		reportClose()
	end
end)

function reportOpen()
	guiSetVisible(browser,true)
	guiSetInputEnabled(true)
	showCursor(true)
end

function reportClose()
	guiSetVisible(browser,false)
	guiSetInputEnabled(false)
	showCursor(false)
end
addEvent("reports.close",true)
addEventHandler("reports.close",root,reportClose)