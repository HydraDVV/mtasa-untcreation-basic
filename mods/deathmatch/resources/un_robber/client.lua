local screenX, screenY = guiGetScreenSize()

addListener = function(e, f)
    addEvent(e, true)
    addEventHandler(e, root, f)
end
setDevelopmentMode(true)
addListener("rb:createGUI",
    function(min, max, id, data)
        if isElement(window) then
            return
        end
		row = data
        window = guiCreateWindow(677, 391, 585, 294, "Soygun Sistemi - "..row.name, false)
        guiWindowSetSizable(window, false)
		exports.un_global:centerWindow(window)

        lbl = guiCreateLabel(16, 27, 548, 49, "Aşağıdan soyguna katılacak olan oyuncuları yazınız. Soygunun gerçekleşmesi için "..row.settings.pd_available.." aktif polis,\n olması gerekiyor. Ek olarak soyguna en az "..row.settings.min_player.." kişi, en fazla "..row.settings.max_player.." kişi alabilirsiniz. Soygun alanında\n "..(row.settings.victor_tick).." dakika durduğunuz zaman "..exports.un_global:formatMoney(row.settings.victor_amount).."TL para kazanacaksınız.", false, window)
        guiLabelSetHorizontalAlign(lbl, "center", false)
        lbl2 = guiCreateLabel(219, 89, 345, 26, "================================================================", false, window)
        lbl3 = guiCreateLabel(217, 132, 108, 20, "Oyuncu Adı:", false, window)

        gridlist = guiCreateGridList(16, 86, 192, 144, false, window)
        guiGridListAddColumn(gridlist, "Oyuncu Adı", 0.9)
        
        
        edit = guiCreateEdit(330, 125, 234, 33, "", false, window)
        addEventHandler("onClientGUIChanged", edit,
			function(e)
				checkFindingPlayer(e.text)
			end
		)
        add = guiCreateButton(423, 164, 141, 32, "Ekle", false, window)
        lbl4 = guiCreateLabel(356, 200, 208, 28, "", false, window)
        guiLabelSetHorizontalAlign(lbl4, "right", false)
		guiSetInputEnabled(true)
        close = guiCreateButton(16, 238, 265, 41, "İptal", false, window)
        ok = guiCreateButton(299, 238, 265, 41, "Soygunu Başlat", false, window)
		addEventHandler("onClientGUIClick", guiRoot,
			function(b)
				if b == "left" and source == close then
					triggerServerEvent("stopRobbery", localPlayer, localPlayer, id)
					destroyElement(window)
					guiSetInputEnabled(false)
				elseif b == "left" and source == add then
					if isElement(finder) then
						triggerServerEvent("requestRobber", localPlayer, localPlayer, finder, id)
					end
				elseif b == "left" and source == ok then
					triggerServerEvent("stepRobber", localPlayer, localPlayer, id)
				end
			end
		)
    end
)

closeGUI = function()
	if isElement(window) then
		destroyElement(window)
		guiSetInputEnabled(false)
	end
end
addEvent("robberCloseGUI", true)
addEventHandler("robberCloseGUI", root, closeGUI)

addList = function(target, data)
	if isElement(gridlist) then
		local row = guiGridListAddRow(gridlist)
		guiGridListSetItemText(gridlist, row, 1, target.name:gsub("_", " "), false, false)
		
		row = data
	end
end
addEvent("addRobberList", true)
addEventHandler("addRobberList", root, addList)

askPlayer = function(askedPlayer, robberId)
	if isElement(raceAsking) then return end
	raceAsking = guiCreateWindow((screenX - 455) / 2, screenY - 160, 455, 125, "Soygun Daveti - ( Gelen: "..getPlayerName(askedPlayer).." )", false)
	guiWindowSetSizable(raceAsking, false)

	theLabel = guiCreateLabel(12, 25, 433, 40, getPlayerName(askedPlayer) .. " isimli kişi sizi soyguna davet ediyor, kabul ediyor musunuz?", false, raceAsking)
	guiLabelSetHorizontalAlign(theLabel, "center", true)
	guiLabelSetVerticalAlign(theLabel, "center")
	kabulBtn = guiCreateButton(12, 75, 215, 30, "Evet", false, raceAsking)
	guiSetProperty(kabulBtn, "NormalTextColour", "FFAAAAAA")
	addEventHandler("onClientGUIClick", kabulBtn,
		function()
			destroyElement(raceAsking)
			triggerServerEvent("robber->okRequest",askedPlayer,askedPlayer, localPlayer, robberId)
		end
	)

	reddetBtn = guiCreateButton(235, 75, 210, 30, "Hayır", false, raceAsking)
	guiSetProperty(reddetBtn, "NormalTextColour", "FFAAAAAA")
	addEventHandler("onClientGUIClick", reddetBtn, 
		function()
			destroyElement(raceAsking)
			triggerServerEvent("robber->canceledRequest",askedPlayer,askedPlayer, localPlayer)
		end
	)
end
addEvent("askRobber", true)
addEventHandler("askRobber", root, askPlayer)

local blip = false
addEvent("robber.createBlip", true)
addEventHandler("robber.createBlip", root,
	function(x, y, z)
		if not isElement(blip) then
			blip = createBlip(x, y, z, 30)
			setTimer(destroyElement, 1000*60*3, 1, blip)
		end
	end
)

getDistanceFromElement = function(from, to)
	if not from or not to then return end
	local x, y, z = getElementPosition(from)
	local x1, y1, z1 = getElementPosition(to)
	return getDistanceBetweenPoints3D(x, y, z, x1, y1, z1)
end

checkFindingPlayer = function(text)
	finderName = nil
	finderCount = 0
	finder = nil
	for k, player in ipairs(getElementsByType("player")) do
		playerName = getPlayerName(player)
		dist = getDistanceFromElement(localPlayer, player)
		if player ~= localPlayer and dist <= 20 then
			if string.find(playerName, text) and text ~= "" then
				finderCount = finderCount + 1
				finderName = getPlayerName(player)
				finder = player
			end
		end
	end

	if finder then
		if finderCount > 1 then
			findingText = "Birden fazla bulundu."
		else
			if finderCount == 0 then
				findingText = "Bulunamadı."
			elseif finderCount == 1 then
				findingText = "Bulundu! Bulunan: "..finderName
			end
		end
	else
		findingText = "Bulunamadı."
	end
	if isElement(lbl4) then
		guiSetText(lbl4, findingText)
	end
end

function SecondsToClock(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return hours..":"..mins..":"..secs
  end
end
setElementData(localPlayer, "robberId", false)
local lastClick = getTickCount()
addEventHandler("onClientRender", root,
    function()
		if lastClick+1500 <= getTickCount() then
			lastClick = getTickCount()
			target = getPedTarget(localPlayer)
			if isElement(target) and getElementData(target, "robber") then
				local team = getPlayerTeam(localPlayer)
				dist = getDistanceFromElement(localPlayer, target)
				if dist <= 10 and team and isElement(team) and getElementData(team, "type") == 0 or getElementData(team, "type") == 1 and getPedWeapon(localPlayer) ~= 0 then 
					triggerServerEvent("startRobbery", localPlayer, localPlayer)
				end
			end
		end
        if getElementData(localPlayer, "robberId") then
			--@remaing:
			local remaing = SecondsToClock(getElementData(root, "robber:"..getElementData(localPlayer, "robberId")))
			if remaing then
				dxDrawText("Soygun Süresi:", screenX/2-250/2, screenY-120, 250+(screenX/2-250/2), 250, tocolor(255, 255, 255), 2, "sans", "center", "top")

				dxDrawText(remaing, screenX/2-250/2, screenY-90, 250+(screenX/2-250/2), 250, tocolor(255, 255, 255), 3, "sans", "center", "top")
			end
		end
    end
)