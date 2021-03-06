addEventHandler("onClientChangeChar", getRootElement(), function ()
		local enabled = getElementData(localPlayer, "supervising")
		if (enabled == true) then
			setElementData(localPlayer, "supervising", false)
		end
 	end)

-- bekiroj / 2020 haziran 1
-- RECON
local reconTarget = nil
local reconTargets = {}
local pointer = 0

local function addToReconTable(id)
	for i, existingId in pairs(reconTargets) do
		if existingId == id then
			return false
		end
	end
	table.insert(reconTargets, id)
	return true
end

function toggleRecon(state, targetPlayer)
	if state then
		local cur = exports.un_data:load("reconCurpos")
		if not cur then
			cur = {}
			cur.x, cur.y, cur.z = getElementPosition(localPlayer)
			cur.rx, cur.ry, cur.rz = getElementRotation(localPlayer)
			cur.dim = getElementDimension(localPlayer)
			cur.int = getElementInterior(localPlayer)
		end
		cur.target = getElementData(targetPlayer, "playerid")
		reconTarget = targetPlayer
		exports.un_data:save(cur, "reconCurpos")

		setElementData(localPlayer, "reconx", true , false)
		setElementCollisionsEnabled ( localPlayer, false )
		setElementAlpha(localPlayer, 0)
		setPedWeaponSlot(localPlayer, 0)
		
		local t_dim = getElementDimension(targetPlayer)
		local t_int = getElementInterior(targetPlayer)
		setElementDimension(localPlayer, t_dim)
		setElementInterior(localPlayer, t_int)
		setCameraInterior(t_int)

		local x1, y1, z1 = getElementPosition(targetPlayer)
		attachElements(localPlayer, targetPlayer, 0, 0, 5)
		setElementPosition(localPlayer, x1, y1, z1+5)
		setCameraTarget(targetPlayer)
		return triggerServerEvent("admin:recon:async:activate", localPlayer, cur)
	else
		local cur = exports.un_data:load("reconCurpos")
		if cur then
			detachElements(localPlayer)
			setElementData(localPlayer, "reconx", false , false)

			setElementPosition(localPlayer, cur.x, cur.y, cur.z)
			setElementRotation(localPlayer, cur.rx, cur.ry, cur.rz)

			setElementDimension(localPlayer, cur.dim)
			setElementInterior(localPlayer, cur.int)
			setCameraInterior(cur.int)
			
			setCameraTarget(localPlayer, nil)
			setElementAlpha(localPlayer, 255)
			setElementCollisionsEnabled ( localPlayer, true )

			exports.un_data:save(nil, "reconCurpos")
			reconTarget = nil
			return triggerServerEvent("admin:recon:async:deactivate", localPlayer, cur)
		end
	end
end

function reconPlayer(commandName, targetPlayer)
	if source then localPlayer = source end
	if getElementData(localPlayer, "loggedin") == 1 and exports.un_integration:isPlayerTrialAdmin(localPlayer) then
		local reconx = getElementData(localPlayer, "reconx")
		if not (targetPlayer) then
			if not reconx then
				return outputChatBox("|| UNT || /" .. commandName .. " [Player Partial Nick]", 255, 194, 14)
			end
			if toggleRecon(false) then
				reconTargets = {}
				pointer = 0
				outputChatBox("Recon turned off.", 0, 255, 0)
			end
		else
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(localPlayer, targetPlayer)
			if not targetPlayer then 
				return outputChatBox("Player not found.", 255, 194, 14)
			end
			
			if getElementData(targetPlayer, "loggedin") ~= 1 then
				return outputChatBox("Player is not logged in.", 255, 0, 0)
			end


			
			if targetPlayer == localPlayer then
				return outputChatBox("[-] #f9f9f9Kendini izleyemezsin.", 255,0,0,true)
			end

			if exports.un_freecam:isEnabled (localPlayer) then
				exports.un_freecam:toggleFreecam("dropme")
			end

			if toggleRecon(true, targetPlayer) then
			
			if exports.un_integration:isPlayerDeveloper(targetPlayer) then
				if exports.un_integration:isPlayerDeveloper(localPlayer) then
				toggleRecon(true, targetPlayer)
				else
				outputChatBox("#575757UNT:#ffffff Bu adam?? izleyecek y??re??in yok.", 255, 0, 0, true)
				toggleRecon(false, localPlayer)
				end
			return end
				outputChatBox("[-]#f9f9f9 " .. targetPlayerName .. " isimli oyuncuyu ??u anda izliyorsun.", 20, 230, 40,true)
				if addToReconTable(getElementData(targetPlayer, "playerid")) then
					pointer = #reconTargets
				end
			end
		end
		else
			outputChatBox("[-]#f9f9f9 ??zg??n??m ama bu komutu art??k sadece A1 Stajyer Yetkili ve ??st?? kullanabilecek.", 230, 30, 30, true)
	end
end
addEvent("admin:recon", true)
addEventHandler("admin:recon", root, reconPlayer)
addCommandHandler("recon", reconPlayer)

addEventHandler ( "onClientElementDataChange", root,
function ( dataName )
	if getElementType ( source ) == "player" and dataName == "reconx" then
		if getElementData(source, "reconx") then
			addEventHandler("onClientRender", root, displayReconInfo)
		else
			setElementData(localPlayer, "recon:whereToDisplayY", nil)
			removeEventHandler("onClientRender", root, displayReconInfo)
		end
	end
end )

function getZoneNameEx(x, y, z)
	local zone = getZoneName(x, y, z)
	if zone == 'East Beach' then
		return 'Bayrampa??a'
	elseif zone == 'Ganton' then
		return 'Ba??c??lar'
	elseif zone == 'East Los Santos' then
		return 'Bayrampa??a'
	elseif zone == 'Las Colinas' then
		return '??atalca'
	elseif zone == 'Jefferson' then
		return 'Esenler'
	elseif zone == 'Glen Park' then
		return 'Esenler'
	elseif zone == 'Downtown Los Santos' then
		return 'Ka????thane'
	elseif zone == 'Commerce' then
		return 'Beyo??lu'
	elseif zone == 'Market' then
		return 'Mecidiyek??y'
	elseif zone == 'Temple' then
		return '4. Levent'
	elseif zone == 'Vinewood' then
		return 'Kemerburgaz'
	elseif zone == 'Richman' then
		return '4. Levent'
	elseif zone == 'Rodeo' then
		return 'Sar??yer'
	elseif zone == 'Mulholland' then
		return 'Kemerburgaz'
	elseif zone == 'Red County' then
		return 'Kemerburgaz'
	elseif zone == 'Mulholland Intersection' then
		return 'Kemerburgaz'
	elseif zone == 'Los Flores' then
		return 'Sancak Tepe'
	elseif zone == 'Willowfield' then
		return 'Zeytinburnu'
	elseif zone == 'Playa del Seville' then
		return 'Zeytinburnu'
	elseif zone == 'Ocean Docks' then
		return '??kitelli'
	elseif zone == 'Los Santos' then
		return '??stanbul'
	elseif zone == 'Los Santos International' then
		return 'Atat??rk Havaliman??'
	elseif zone == 'Jefferson' then
		return 'Esenler'
	elseif zone == 'Verdant Bluffs' then
		return 'R??meli Hisar??'
	elseif zone == 'Verona Beach' then
		return 'Atak??y'
	elseif zone == 'Santa Maria Beach' then
		return 'Florya'
	elseif zone == 'Marina' then
		return 'Bak??rk??y'
	elseif zone == 'Idlewood' then
		return 'G??ng??ren'
	elseif zone == 'El Corona' then
		return 'K??????k??ekmece'
	elseif zone == 'Unity Station' then
		return 'Merter'
	elseif zone == 'Little Mexico' then
		return 'Taksim'
	elseif zone == 'Pershing Square' then
		return 'Taksim'
	elseif zone == 'Las Venturas' then
		return 'Edirne'
	else
		return zone
	end
end

local function tableToString(table)
	local text = ""
	for i, id in ipairs(table) do
		text = text..id..", "
	end
	return #text>0 and string.sub(text, 1, #text-2) or "None"
end
local sw, sh = guiGetScreenSize()
function displayReconInfo()

	--reconTarget = localPlayer
	if not reconTarget or not isElement(reconTarget) or getElementData(reconTarget, "loggedin") ~= 1 then
		setElementData(localPlayer, "recon:whereToDisplayY", nil)
		return removeEventHandler("onClientRender", root, displayReconInfo)
	end

	local w, h = 760, 105
	local x, y = (sw-w)/2, sh-h-30
	setElementData(localPlayer, "recon:whereToDisplayY", y)
    dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 100), true)
    local ox, oy = 507, 396
	local xo, yo = x-ox, y-oy
	local text = ""
    dxDrawText("HP: "..math.floor( getElementHealth( reconTarget )), 517+xo, 423+yo, 706+xo, 440+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    dxDrawText("Target: "..exports.un_global:getPlayerFullIdentity(reconTarget,3,true), 517+xo, 406+yo, 887+xo, 423+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    local weapon = getPedWeapon( reconTarget )
	if weapon then
		weapon = getWeaponNameFromID( weapon )
	else
		weapon = "N/A"
	end
    dxDrawText("Weapon: "..weapon, 517+xo, 440+yo, 706+xo, 457+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    dxDrawText("AP: "..math.floor( getPedArmor( reconTarget ) ), 706+xo, 423+yo, 887+xo, 440+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    dxDrawText("Skin: "..getElementModel( reconTarget ), 706+xo, 440+yo, 887+xo, 457+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    dxDrawText("Money: $"..exports.un_global:formatMoney(getElementData(reconTarget, "money")), 517+xo, 457+yo, 706+xo, 474+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    dxDrawText("Bank: $"..exports.un_global:formatMoney(getElementData(reconTarget, "bankmoney")), 706+xo, 457+yo, 887+xo, 474+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    local veh = "Press Arrow Left/Right to swap between reconning targets ("..tableToString(reconTargets)..")"
    local vehicle = getPedOccupiedVehicle( reconTarget )
    if vehicle then
    	veh = "Vehicle: " .. exports.un_global:getVehicleName( vehicle ) .. " (" ..getVehicleName( vehicle ).." - ID #"..getElementData( vehicle, "dbid" ) .. " - HP: "..math.floor( getElementHealth( vehicle ))..")"
    end
    dxDrawText(veh, 517+xo, 474+yo, 1257+xo, 491+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
	text = "Citizen"
	local fid = getElementData(reconTarget, "faction") or 0
	if fid > 0 then
		local theFaction = getPlayerTeam(reconTarget)
		if theFaction then
			text = getTeamName(theFaction)
			local ranks = getElementData(theFaction, "ranks")
			if ranks then
				local rank = getElementData(reconTarget, "factionrank")
				local fRank = ranks[rank] and ranks[rank] or false
				if fRank then
					text = text.." ("..fRank..")"
				end
			end
		end
	end
	local loc = getZoneNameEx(getElementPosition(reconTarget))
	local int = getElementInterior(reconTarget)
	local dim = getElementDimension(reconTarget)
	--[[
	if getElementInterior(localPlayer) ~= int then
		setElementInterior(localPlayer, int)
	end
	if getElementDimension(localPlayer) ~= dim then
		setElementDimension(localPlayer, dim)
	end
	]]
	if dim > 0 then
		loc = "Inside interior ID #"..dim
	end
    dxDrawText("Faction: "..text, 887+xo, 406+yo, 1257+xo, 423+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    dxDrawText("Location: "..loc, 887+xo, 423+yo, 1257+xo, 440+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    dxDrawText("Interior: "..int, 887+xo, 440+yo, 1076+xo, 457+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    dxDrawText("Dimension: "..dim, 1076+xo, 440+yo, 1257+xo, 457+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    local hoursplayed = getElementData(reconTarget, "hoursplayed")
    hoursplayed = tonumber(hoursplayed) or "Unknown"
    dxDrawText("Hoursplayed: "..hoursplayed, 887+xo, 457+yo, 1076+xo, 474+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
    dxDrawText("Ping: "..getPlayerPing(reconTarget), 1076+xo, 457+yo, 1257+xo, 474+yo, tocolor(255, 255, 255, 255), 1.00, "default", "left", "top", false, false, true, false, false)
end
--addEventHandler("onClientRender", root, displayReconInfo)

local function getTarget(order)
	if #reconTargets < 2 then
		return false, "Please /recon more players to be able to swap between them."
	end
	if order == "arrow_r" then
		pointer = pointer + 1
		if not reconTargets[pointer] then
			pointer = 1
			local target = exports.un_global:findPlayerByPartialNick(localPlayer, reconTargets[pointer])
			if not target then
				table.remove(reconTargets, pointer)
				return false, "This player has just logged out."
			else
				return reconTargets[pointer]
			end
		else
			local target = exports.un_global:findPlayerByPartialNick(localPlayer, reconTargets[pointer])
			if not target then
				table.remove(reconTargets, pointer)
				return false, "This player has just logged out."
			else
				return reconTargets[pointer]
			end
		end
	else
		pointer = pointer - 1
		if not reconTargets[pointer] then
			pointer = #reconTargets
			local target = exports.un_global:findPlayerByPartialNick(localPlayer, reconTargets[pointer])
			if not target then
				table.remove(reconTargets, pointer)
				return false, "This player has just logged out."
			else
				return reconTargets[pointer]
			end
		else
			local target = exports.un_global:findPlayerByPartialNick(localPlayer, reconTargets[pointer])
			if not target then
				table.remove(reconTargets, pointer)
				return false, "This player has just logged out."
			else
				return reconTargets[pointer]
			end
		end
	end
end

addEventHandler( "onClientKey", root, function(button,press) 
	if getElementData(localPlayer, "reconx") and press then
	    if button == "arrow_l" or button == "arrow_r" then
	    	local target, reason = getTarget(button)
	    	if target then
	    		triggerEvent("admin:recon", localPlayer, nil, target)
	    	else
	    		outputChatBox(reason, 255,0,0)
	    	end
	    	--cancelEvent()
	    end
	end
end )