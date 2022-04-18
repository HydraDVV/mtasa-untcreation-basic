local mysql = exports.un_mysql

armoredCars = { [427]=true, [528]=true, [432]=true, [601]=true, [428]=true } -- Enforcer, FBI Truck, Rhino, SWAT Tank, Securicar
totalTempVehicles = 0
respawnTimer = nil
local bikeCol = createColPolygon(1861.970703125, -1835.9697265625, 1861.97265625, -1854.5107421875, 1883.892578125, -1854.5595703125, 1883.744140625, -1863.375,1901.1484375, -1858.3095703125, 1890.7646484375, -1840.1259765625, 1861.9765625, -1835.958984375)
local wangs1Col = createColPolygon(2110.2470703125, -2124.2861328125, 2160.1142578125, -2141.283203125, 2143.494140625, -2162.3798828125, 2134.7724609375, -2173.365234375, 2111.951171875, -2165.77734375, 2110.306640625, -2124.455078125)
local wangs2Col = createColPolygon(2138.9677734375, -1125.140625, 2138.65234375, -1155.388671875, 2124.37890625, -1155.615234375, 2123.4560546875, -1160.6806640625, 2114.5341796875, -1160.771484375,  2117.6103515625, -1119.68359375, 2138.9677734375, -1125.140625)
local wangs3Col = createColPolygon(563.21484375, -1256.9873046875, 571.3759765625, -1294.1748046875, 511.19921875, -1295.34375, 549.2548828125, -1261.8525390625, 563.1650390625, -1257.6083984375)

-- EVENTS
addEvent("onVehicleDelete", false)
-- WORKAROUND ABIT
function getVehicleName(vehicle)
	return exports.un_global:getVehicleName(vehicle)
end

function respawnTheVehicle(vehicle)
	setElementCollisionsEnabled(vehicle, true)
	respawnVehicle(vehicle)
end

-- pavlov ^-^
function reloadVehicleByAdmin(thePlayer, commandName, vehID)
	if exports.un_integration:isPlayerHeadAdmin( thePlayer ) then
		local veh = false
		if not vehID or not tonumber(vehID) or (tonumber(vehID) % 1 ~= 0 ) then
			veh = getPedOccupiedVehicle(thePlayer) or false
			if veh then
				vehID = getElementData(veh, "dbid") or false
				if not vehID then
					exports.un_notification:create(thePlayer,"Bir araçta olmalısın. /reloadveh [Araç ID]", "error")
					return false
				end
			end
		end

		if not vehID or not tonumber(vehID) or (tonumber(vehID) % 1 ~= 0 ) then
				exports.un_notification:create(thePlayer,"Bir araçta olmalısın. /reloadveh [Araç ID]", "error")
			return false
		end

		--[[
		local vehs = getElementsByType("vehicle")
		for i, v in pairs (vehs) do
			if getElementData(v,"dbid") == tonumber(vehID) then
				destroyElement(theVehicle)
				break
			end
		end
		]]

		exports["un_vehicle"]:reloadVehicle(tonumber(vehID))
		exports.un_notification:create(thePlayer,""..vehID.." ID'li aracı tekrar yükledin.", "success")

		addVehicleLogs(tonumber(vehID), commandName, thePlayer)
		exports.un_logs:dbLog(thePlayer, 4, { veh, thePlayer }, commandName)
		return true
	end
end
addCommandHandler("reloadveh", reloadVehicleByAdmin)
addCommandHandler("reloadvehicle", reloadVehicleByAdmin)


function togVehReg(admin, command, target, status)
	if (exports.un_integration:isPlayerAdmin(admin)) then
		if not (target) or not (status) then
			outputChatBox("KULLANIM: /" .. command .. " [Veh ID] [0- Off, 1- On]", admin, 255, 194, 14)
		else
			local username = getPlayerName(admin):gsub("_"," ")
			local pv = exports.un_pool:getElement("vehicle", tonumber(target))

			if (pv) then
					local vid = getElementData(pv, "dbid")
					local stat = tonumber(status)
					if isElementAttached(pv) then
					detachElements(pv)
					end
					if (stat == 0) then
						dbExec(mysql:getConnection(), "UPDATE vehicles SET registered = '0' WHERE id='" .. (vid) .. "'")
						setElementData(pv, "registered", 0)
						outputChatBox("You have toggled the registration to unregistered on vehicle #" .. vid .. ".", admin)

						addVehicleLogs(getElementData(pv, "dbid"), command.." OFF", admin)
						exports.un_logs:dbLog(admin, 4, { pv, admin }, command.." OFF")
					elseif (stat == 1) then
						dbExec(mysql:getConnection(), "UPDATE vehicles SET registered = '1' WHERE id='" .. (vid) .. "'")
						setElementData(pv, "registered", 1)
						outputChatBox("You have toggled the registration to registered on vehicle #" .. vid .. ".", admin)

						addVehicleLogs(getElementData(pv, "dbid"), command.." ON", admin)
						exports.un_logs:dbLog(admin, 4, { pv, admin }, command.." ON")
					end
				else
					outputChatBox("That's not a vehicle.", admin, 255, 194, 14)
				end
			end
		end
	end
addCommandHandler("togreg", togVehReg)

function togVehPlate(admin, command, target, status)
	if (exports.un_integration:isPlayerAdmin(admin)) then
		if not (target) or not (status) then
			outputChatBox("KULLANIM: /" .. command .. " [Veh ID] [0- Off, 1- On]", admin, 255, 194, 14)
		else
			local username = getPlayerName(admin):gsub("_"," ")
			local pv = exports.un_pool:getElement("vehicle", tonumber(target))

			if (pv) then
					local vid = getElementData(pv, "dbid")
					local stat = tonumber(status)
					if isElementAttached(pv) then
					detachElements(pv)
					end
					if (stat == 0) then
						dbExec(mysql:getConnection(), "UPDATE vehicles SET show_plate = '0' WHERE id='" .. (vid) .. "'")

						setElementData(pv, "show_plate", 0)

						outputChatBox("You have toggled the plates to off, on vehicle #" .. vid .. ".", admin)

						addVehicleLogs(getElementData(pv, "dbid"), command.." OFF", admin)
						exports.un_logs:dbLog(admin, 4, { pv, admin }, command.." OFF")
					elseif (stat == 1) then
						dbExec(mysql:getConnection(), "UPDATE vehicles SET show_plate = '1' WHERE id='" .. (vid) .. "'")
						setElementData(pv, "show_plate", 1)
						outputChatBox("You have toggled the plates to on, on vehicle #" .. vid .. ".", admin)

						addVehicleLogs(getElementData(pv, "dbid"), command.." ON", admin)
						exports.un_logs:dbLog(admin, 4, { pv, admin }, command.." ON")
					end
				else
					outputChatBox("That's not a vehicle.", admin, 255, 194, 14)
				end
			end
		end
	end
addCommandHandler("togplate", togVehPlate)

function togVehVin(admin, command, target, status)
	if (exports.un_integration:isPlayerAdmin(admin)) then
		if not (target) or not (status) then
			outputChatBox("KULLANIM: /" .. command .. " [Veh ID] [0- Off, 1- On]", admin, 255, 194, 14)
		else
			local username = getPlayerName(admin):gsub("_"," ")
			local pv = exports.un_pool:getElement("vehicle", tonumber(target))

			if (pv) then
					local vid = getElementData(pv, "dbid")
					local stat = tonumber(status)
					if isElementAttached(pv) then
					detachElements(pv)
					end
					if (stat == 0) then
						dbExec(mysql:getConnection(), "UPDATE vehicles SET show_vin = '0' WHERE id='" .. (vid) .. "'")

						setElementData(pv, "show_vin", 0)

						outputChatBox("You have toggled the VIN to off, on vehicle #" .. vid .. ".", admin)

						addVehicleLogs(getElementData(pv, "dbid"), command.." OFF", admin)
						exports.un_logs:dbLog(admin, 4, { pv, admin }, command.." OFF")
					elseif (stat == 1) then
						dbExec(mysql:getConnection(), "UPDATE vehicles SET show_vin = '1' WHERE id='" .. (vid) .. "'")
						setElementData(pv, "show_vin", 1)

						outputChatBox("You have toggled the VIN to on, on vehicle #" .. vid .. ".", admin)

						addVehicleLogs(getElementData(pv, "dbid"), command.." ON", admin)
						exports.un_logs:dbLog(admin, 4, { pv, admin }, command.." ON")
					end
				else
					outputChatBox("That's not a vehicle.", admin, 255, 194, 14)
				end
			end
		end
	end
addCommandHandler("togvin", togVehVin)

function spinCarOut(thePlayer, commandName, targetPlayer, round)
	if (exports.un_integration:isPlayerAdmin(thePlayer)) then
		if not targetPlayer then
			exports.un_notification:create(thePlayer,"/spinout [Karakter Adı & ID] [Çevireceğin Sayı]", "info")
		else
			if not round or not tonumber(round) or tonumber( round ) % 1 ~= 0 or tonumber( round ) > 100 then
				round = 1
			end
			local targetPlayer = exports.un_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local targetVehicle = getPedOccupiedVehicle(targetPlayer)
			if targetVehicle == false then
				exports.un_notification:create(thePlayer,"Hedef oyuncu aracın içerisinde değil.", "error")
			else
				exports.un_notification:create(thePlayer,""..getPlayerName(targetPlayer).." isimli oyuncunun aracını "..tostring(round).." kez çevirdin.", "success")
				local delay = 50
				setTimer(function()
					setElementAngularVelocity ( targetVehicle, 0, 0, 0.2 )
					delay = delay + 50
				end, delay, tonumber(round))
			end
		end
	end
end
addCommandHandler("spinout", spinCarOut, false, false)

-- /unflip
function unflipCar(thePlayer, commandName, targetPlayer)
	if exports.un_integration:isPlayerTrialAdmin(thePlayer) or getElementData(thePlayer, "faction") == 4 or exports.un_integration:isPlayerSupporter(thePlayer) then
		if not targetPlayer or not exports.un_integration:isPlayerTrialAdmin(thePlayer) then
			if not (isPedInVehicle(thePlayer)) then
				exports.un_notification:create(thePlayer,"Bir aracın içerisinde değilsin.", "error")
			else
				local veh = getPedOccupiedVehicle(thePlayer)
				local rx, ry, rz = getVehicleRotation(veh)
				setVehicleRotation(veh, 0, ry, rz)
				exports.un_notification:create(thePlayer,"Başarıyla aracını düz çevirdin.", "success")
				addVehicleLogs(getElementData(veh, "dbid"), commandName, thePlayer)
			end
		else
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer):gsub("_"," ")

				if (logged==0) then
					exports.un_notification:create(thePlayer,"Bu oyuncu oyuna giriş yapmamış", "error")
				else
					local pveh = getPedOccupiedVehicle(targetPlayer)
					if pveh then
						local rx, ry, rz = getVehicleRotation(pveh)
						setVehicleRotation(pveh, 0, ry, rz)
						if getElementData(thePlayer, "hiddenadmin") == 1 then
							exports.un_notification:create(targetPlayer,"Gizli bir yetkili aracınızı düz çevirdi.", "success")
						else
							exports.un_notification:create(targetPlayer,""..username.." isimli yetkili aracınızı düz çevirdi.", "success")
						end
						outputChatBox("You unflipped " .. targetPlayerName:gsub("_"," ") .. "'s car.", thePlayer, 0, 255, 0)
						exports.un_notification:create(thePlayer,""..targetPlayerName:gsub("_"," ").." isimli oyuncunun aracını düz çevirdiniz.", "success")

						addVehicleLogs(getElementData(pveh, "dbid"), commandName, thePlayer)
						exports.un_logs:dbLog(thePlayer, 4, { pveh, thePlayer }, command)
					else
						exports.un_notification:create(thePlayer,""..targetPlayerName:gsub("_"," ").." isimli oyuncu aracın içerisinde değil.", "error")
					end
				end
			end
		end
	end
end
addCommandHandler("unflip", unflipCar, false, false)

-- /flip
function flipCar(thePlayer, commandName, targetPlayer)
	if exports.un_integration:isPlayerTrialAdmin(thePlayer) or getElementData(thePlayer,"faction") == 4 or exports.un_integration:isPlayerSupporter(thePlayer) then -- SFTR, working on motorbikes etc
		if not targetPlayer or not exports.un_integration:isPlayerTrialAdmin(thePlayer) then
			if not (isPedInVehicle(thePlayer)) then
				outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
			else
				local veh = getPedOccupiedVehicle(thePlayer)
				local rx, ry, rz = getVehicleRotation(veh)
				setVehicleRotation(veh, 180, ry, rz)
				fixVehicle (veh)
				outputChatBox("Your car was flipped!", thePlayer, 0, 255, 0)
				addVehicleLogs(getElementData(veh, "dbid"), commandName, thePlayer)
			end
		else
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer):gsub("_"," ")

				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local pveh = getPedOccupiedVehicle(targetPlayer)
					if pveh then
						local rx, ry, rz = getVehicleRotation(pveh)
						setVehicleRotation(pveh, 180, ry, rz)
						if getElementData(thePlayer, "hiddenadmin") == 1 then
							outputChatBox("Your car was flipped by a Hidden Admin.", targetPlayer, 0, 255, 0)
						else
							outputChatBox("Your car was flipped by " .. username .. ".", targetPlayer, 0, 255, 0)
						end
						outputChatBox("You flipped " .. targetPlayerName:gsub("_"," ") .. "'s car.", thePlayer, 0, 255, 0)

						addVehicleLogs(getElementData(pveh, "dbid"), commandName, thePlayer)
						exports.un_logs:dbLog(thePlayer, 4, { pveh, thePlayer }, command)
					else
						outputChatBox(targetPlayerName:gsub("_"," ") .. " is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("flip", flipCar, false, false)

-- /unlockcivcars
function unlockAllCivilianCars(thePlayer, commandName)
	if (exports.un_integration:isPlayerTrialAdmin(thePlayer)) then
		local count = 0
		for key, value in ipairs(exports.un_pool:getPoolElementsByType("vehicle")) do
			if (isElement(value)) and (getElementType(value)) then
				local id = getElementData(value, "dbid")

				if (id) and (id>=0) then
					local owner = getElementData(value, "owner")
					if (owner==-2) then
						setVehicleLocked(value, false)
						addVehicleLogs(id, commandName, thePlayer)
						count = count + 1
					end
				end
			end
		end
		outputChatBox("Unlocked " .. count .. " civilian vehicles.", thePlayer, 255, 194, 14)
		--addVehicleLogs(getElementData(pveh, "dbid"), commandName, thePlayer)
		exports.un_logs:dbLog(thePlayer, 4, { thePlayer }, commandName)
	end
end
addCommandHandler("unlockcivcars", unlockAllCivilianCars, false, false)

-- /veh
local leadplus = { [425] = true, [520] = true, [447] = true, [432] = true, [444] = true, [556] = true, [557] = true, [441] = true, [464] = true, [501] = true, [465] = true, [564] = true, [476] = true }
function createTempVehicle(thePlayer, commandName, vehShopID)
	if exports.un_integration:isPlayerSeniorAdmin(thePlayer) then
		if not vehShopID or not tonumber(vehShopID) then
			exports.un_notification:create(thePlayer,"/veh [Araç ID (/vehlib)]", "info")
			return false
		else
			vehShopID = tonumber(vehShopID)
		end

		local vehShopData = getInfoFromVehShopID(vehShopID)
		if not vehShopData then
			exports.un_notification:create(thePlayer,"/veh [Araç ID (/vehlib)]", "info")
			return false
		end


		local vehicleID = vehShopData.vehmtamodel
		if not vehicleID or not tonumber(vehicleID) then -- vehicle is specified as name
			outputChatBox("Upss, hatalı bir şeyler deniyorsun.", thePlayer, 255, 0, 0)
			return false
		else
			vehicleID = tonumber(vehicleID)
		end

		local r = getPedRotation(thePlayer)
		local x, y, z = getElementPosition(thePlayer)
		x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
		y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )


		local plate = tostring( getElementData(thePlayer, "account:id") )
		if #plate < 8 then
			plate = " " .. plate
			while #plate < 8 do
				plate = string.char(math.random(string.byte('A'), string.byte('Z'))) .. plate
				if #plate < 8 then
				end
			end
		end

		local veh = createVehicle(vehicleID, x, y, z, 0, 0, r, plate)

		if not (veh) then
			outputChatBox("Upss, hatalı bir şeyler deniyorsun.", thePlayer, 255, 0, 0)
			return false
		end

		if (armoredCars[vehicleID]) then
			setVehicleDamageProof(veh, true)
		end

		totalTempVehicles = totalTempVehicles + 1
		local dbid = (-totalTempVehicles)
		exports.un_pool:allocateElement(veh, dbid)

		--setVehicleColor(veh, col1, col2, col1, col2)

		setElementInterior(veh, getElementInterior(thePlayer))
		setElementDimension(veh, getElementDimension(thePlayer))

		setVehicleOverrideLights(veh, 1)
		setVehicleEngineState(veh, false)
		setVehicleFuelTankExplodable(veh, false)
		setVehicleVariant(veh, exports['un_vehicle']:getRandomVariant(getElementModel(veh)))

		setElementData(veh, "dbid", dbid)
		setElementData(veh, "fuel", exports["un_vehicle_fuel"]:getMaxFuel(veh))
		setElementData(veh, "Impounded", 0)
		setElementData(veh, "engine", 0, false)
		setElementData(veh, "oldx", x, false)
		setElementData(veh, "oldy", y, false)
		setElementData(veh, "oldz", z, false)
		setElementData(veh, "faction", -1)
		setElementData(veh, "owner", -1, false)
		setElementData(veh, "job", 0, false)
		setElementData(veh, "handbrake", 0, true)
		exports['un_vehicle_interiors']:add( veh )

		--Custom properties
		setElementData(veh, "brand", vehShopData.vehbrand, true)
		setElementData(veh, "model", vehShopData.vehmodel, true)
		setElementData(veh, "year", vehShopData.vehyear, true)
		setElementData(veh, "vehicle_shop_id", vehShopData.id, true)

		--Load Handlings
		loadHandlingToVeh(veh, vehShopData.handling)

		exports.un_logs:dbLog(thePlayer, 6, thePlayer, "VEH ".. vehShopID .. " created with ID " .. dbid)
		exports.un_notification:create(thePlayer,""..getVehicleName(veh).." isimli aracı spawnladınız. ID: (#"..dbid..")", "success")
	else
		exports.un_notification:create(thePlayer,"Bu komutu kullanabilmek için A4 Lider Yetkili ve üstü olmalısın.", "success")
	end
end
addCommandHandler("veh", createTempVehicle, false, false)

-- /oldcar
function getOldCarID(thePlayer, commandName, targetPlayerName)
	local showPlayer = thePlayer
	if exports.un_integration:isPlayerTrialAdmin(thePlayer) and targetPlayerName then
		targetPlayer = exports.un_global:findPlayerByPartialNick(thePlayer, targetPlayerName)
		if targetPlayer then
			if getElementData(targetPlayer, "loggedin") == 1 then
				thePlayer = targetPlayer
			else
				outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				return
			end
		else
			return
		end
	end

	local oldvehid = getElementData(thePlayer, "lastvehid")

	if not (oldvehid) then
		outputChatBox("You have not been in a vehicle yet.", showPlayer, 255, 0, 0)
	else
		outputChatBox("Old Vehicle ID: " .. tostring(oldvehid) .. ".", showPlayer, 255, 194, 14)
		setElementData(showPlayer, "vehicleManager:oldCar", oldvehid, false)
	end
end
addCommandHandler("oldcar", getOldCarID, false, false)

-- /thiscar
function getCarID(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)

	if (veh) then
		local dbid = getElementData(veh, "dbid")
		outputChatBox("Current Vehicle ID: " .. dbid, thePlayer, 255, 194, 14)
		setElementData(showPlayer, "vehicleManager:oldCar", dbid, false)
	else
		outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("thiscar", getCarID, false, false)

-- /gotocar
function gotoCar(thePlayer, commandName, id)
	if exports.un_integration:isPlayerTrialAdmin(thePlayer) or exports.un_integration:isPlayerSupporter(thePlayer) or exports.un_integration:isPlayerScripter(thePlayer) or exports.un_integration:isPlayerVehicleConsultant(thePlayer) then
		if not (id) then
			exports.un_notification:create(thePlayer,"Kullanım: /gotocar [Araç ID]", "info")
		else
			local theVehicle = exports.un_pool:getElement("vehicle", tonumber(id))
			if theVehicle then
				local rx, ry, rz = getVehicleRotation(theVehicle)
				local x, y, z = getElementPosition(theVehicle)
				x = x + ( ( math.cos ( math.rad ( rz ) ) ) * 5 )
				y = y + ( ( math.sin ( math.rad ( rz ) ) ) * 5 )

				setElementPosition(thePlayer, x, y, z)
				setPedRotation(thePlayer, rz)
				setElementInterior(thePlayer, getElementInterior(theVehicle))
				setElementDimension(thePlayer, getElementDimension(theVehicle))

				exports.un_logs:dbLog(thePlayer, 6, theVehicle, commandName)

				addVehicleLogs(id, commandName, thePlayer)
				exports.un_notification:create(thePlayer,"Başarıyla aracın yanına ışınlandın.", "success")
			else
				exports.un_notification:create(thePlayer,"Hatalı Araç ID'si girdin..", "error")
			end
		end
	end
end
addCommandHandler("gotocar", gotoCar, false, false)
addCommandHandler("gotoveh", gotoCar, false, false)

-- /getcar
function getCar(thePlayer, commandName, id)
	if exports.un_integration:isPlayerTrialAdmin(thePlayer) or exports.un_integration:isPlayerSupporter(thePlayer) or exports.un_integration:isPlayerScripter(thePlayer) or exports.un_integration:isPlayerVehicleConsultant(thePlayer) then
		if not (id) then
			exports.un_notification:create(thePlayer,"Kullanım: /getcar [Araç ID]", "info")
		else
			local theVehicle = exports.un_pool:getElement("vehicle", tonumber(id))
			if theVehicle then
				local r = getPedRotation(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
				y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )

				if	(getElementHealth(theVehicle)==0) then
					spawnVehicle(theVehicle, x, y, z, 0, 0, r)
				else
					setElementPosition(theVehicle, x, y, z)
					setVehicleRotation(theVehicle, 0, 0, r)
				end

				setElementInterior(theVehicle, getElementInterior(thePlayer))
				setElementDimension(theVehicle, getElementDimension(thePlayer))

				exports.un_logs:dbLog(thePlayer, 6, theVehicle, commandName)

				addVehicleLogs(id, commandName, thePlayer)
				exports.un_notification:create(thePlayer,"Başarıyla aracı yanına getirdin.", "success")
			else
				exports.un_notification:create(thePlayer,"Hatalı Araç ID'si girdin.", "error")
			end
		end
	end
end
addCommandHandler("getcar", getCar, false, false)
addCommandHandler("getveh", getCar, false, false)

-- This command teleports the specified vehicle to the specified player, /sendcar
function sendCar(thePlayer, commandName, id, toPlayer)
	if exports.un_integration:isPlayerTrialAdmin(thePlayer) or exports.un_integration:isPlayerSupporter(thePlayer) or exports.un_integration:isPlayerVehicleConsultant(thePlayer) then
		if not (id) or not (toPlayer) then
			exports.un_notification:create(thePlayer,"Kullanım: /sendcar [Araç ID] [Karakter Adı & ID]", "info")
		else
			local theVehicle = exports.un_pool:getElement("vehicle", tonumber(id))
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(thePlayer, toPlayer)
			if theVehicle then
				local r = getPedRotation(targetPlayer)
				local x, y, z = getElementPosition(targetPlayer)
				x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
				y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )

				if	(getElementHealth(theVehicle)==0) then
					spawnVehicle(theVehicle, x, y, z, 0, 0, r)
				else
					setElementPosition(theVehicle, x, y, z)
					setVehicleRotation(theVehicle, 0, 0, r)
				end

				setElementInterior(theVehicle, getElementInterior(targetPlayer))
				setElementDimension(theVehicle, getElementDimension(targetPlayer))

				exports.un_logs:dbLog(thePlayer, 6, theVehicle, commandName.." to "..targetPlayerName)

				addVehicleLogs(id, commandName, thePlayer)
				exports.un_notification:create(thePlayer,"Aracı "..targetPlayerName.." isimli oyuncunun yanına gönderdin.", "success")
				if getElementData(thePlayer, "hiddenadmin") == 1 then
					exports.un_notification:create(targetPlayer,"Gizli bir yetkili aracınızı yanınıza gönderdi.", "success")
				else
					exports.un_notification:create(targetPlayer,""..exports.un_global:getPlayerFullIdentity(thePlayer).." isimli yetkili aracınızı yanınıza gönderdi.", "success")
				end
			else
				exports.un_notification:create(thePlayer,"Hatalı Araç ID'si girdin.", "error")
			end
		end
	end
end
addCommandHandler("sendcar", sendCar, false, false)
addCommandHandler("sendvehto", sendCar, false, false)
addCommandHandler("sendveh", sendCar, false, false)

function sendPlayerToVehicle(thePlayer, commandName, toPlayer, id)
	if exports.un_integration:isPlayerTrialAdmin(thePlayer) or exports.un_integration:isPlayerSupporter(thePlayer) then
		if not (id) or not (toPlayer) then
			exports.un_notification:create(thePlayer,"Kullanım: /sendtoveh [Araç ID] [Karakter Adı & ID]", "info")
		else
			local theVehicle = exports.un_pool:getElement("vehicle", tonumber(id))
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(thePlayer, toPlayer)
			if theVehicle then
				local rx, ry, rz = getVehicleRotation(theVehicle)
				local x, y, z = getElementPosition(theVehicle)
				x = x + ( ( math.cos ( math.rad ( rz ) ) ) * 5 )
				y = y + ( ( math.sin ( math.rad ( rz ) ) ) * 5 )

				setElementPosition(targetPlayer, x, y, z)
				setPedRotation(targetPlayer, rz)
				setElementInterior(targetPlayer, getElementInterior(theVehicle))
				setElementDimension(targetPlayer, getElementDimension(theVehicle))

				exports.un_logs:dbLog(thePlayer, 6, theVehicle, commandName.." from "..targetPlayerName)

				addVehicleLogs(id, commandName, thePlayer)

				outputChatBox("Player "..targetPlayerName.." teleported to vehicle.", thePlayer, 255, 194, 14)
				if getElementData(thePlayer, "hiddenadmin") == 1 then
					exports.un_notification:create(targetPlayer,"Gizli bir yetkili seni aracının yanına gönderdi.", "success")
				else
					exports.un_notification:create(targetPlayer,""..exports.un_global:getPlayerFullIdentity(thePlayer).." isimli yetkili aracının yanına gönderdi.", "success")
				end
			else
				exports.un_notification:create(thePlayer,"Hatalı Araç ID'si girdin.", "error")
			end
		end
	end
end
addCommandHandler("sendtoveh", sendPlayerToVehicle, false, false)

function getNearbyVehicles(thePlayer, commandName)
	if exports.un_integration:isPlayerTrialAdmin(thePlayer) then
		outputChatBox("Nearby Vehicles:", thePlayer, 255, 126, 0)
		local count = 0

		for index, nearbyVehicle in ipairs( exports.un_global:getNearbyElements(thePlayer, "vehicle") ) do
			local thisvehid = getElementData(nearbyVehicle, "dbid")
			if thisvehid then
				local vehicleID = getElementModel(nearbyVehicle)
				local vehicleName = getVehicleNameFromModel(vehicleID)
				local owner = getElementData(nearbyVehicle, "owner")
				local faction = getElementData(nearbyVehicle, "faction")
				count = count + 1

				local ownerName = ""

				if faction then
					if (faction>0) then
						local theTeam = exports.un_pool:getElement("team", faction)
						if theTeam then
							ownerName = getTeamName(theTeam)
						end
					elseif (owner==-1) then
						ownerName = "Admin Temp Vehicle"
					elseif (owner>0) then
						ownerName = exports['un_cache']:getCharacterName(owner, true)
					else
						ownerName = "Civilian"
					end
				else
					ownerName = "Car Dealership"
				end

				if (thisvehid) then
					outputChatBox("   " .. vehicleName .. " (" .. vehicleID ..") with ID: " .. thisvehid .. ". Owner: " .. ownerName, thePlayer, 255, 126, 0)
				end
			end
		end

		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyvehicles", getNearbyVehicles, false, false)
addCommandHandler("nearbyvehs", getNearbyVehicles, false, false)

function delNearbyVehicles(thePlayer, commandName)
	if exports.un_integration:isPlayerAdmin(thePlayer)  then
		outputChatBox("Deleting Nearby Vehicles:", thePlayer, 255, 126, 0)
		local count = 0

		for index, nearbyVehicle in ipairs( exports.un_global:getNearbyElements(thePlayer, "vehicle") ) do
			local thisvehid = getElementData(nearbyVehicle, "dbid")
			if thisvehid then
				local vehicleID = getElementModel(nearbyVehicle)
				local vehicleName = getVehicleNameFromModel(vehicleID)
				local owner = getElementData(nearbyVehicle, "owner")
				local faction = getElementData(nearbyVehicle, "faction")
				count = count + 1

				local ownerName = ""

				if faction then
					if (faction>0) then
						local theTeam = exports.un_pool:getElement("team", faction)
						if theTeam then
							ownerName = getTeamName(theTeam)
						end
					elseif (owner==-1) then
						ownerName = "Admin Temp Vehicle"
					elseif (owner>0) then
						ownerName = exports['un_cache']:getCharacterName(owner, true)
					else
						ownerName = "Civilian"
					end
				else
					ownerName = "Car Dealership"
				end

				if (thisvehid) then
					deleteVehicle(thePlayer, "delveh", thisvehid)
				end
			end
		end

		if (count==0) then
			outputChatBox("   None was deleted.", thePlayer, 255, 126, 0)
		elseif count == 1 then
			outputChatBox("   One vehicle were deleted.", thePlayer, 255, 126, 0)
		else
			outputChatBox("   "..count.." vehicles were deleted.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("delnearbyvehs", delNearbyVehicles, false, false)
addCommandHandler("delnearbyvehicles", delNearbyVehicles, false, false)

function respawnCmdVehicle(thePlayer, commandName, id)
	if (exports.un_integration:isPlayerTrialAdmin(thePlayer) or exports.un_integration:isPlayerSupporter(thePlayer) or exports.un_integration:isPlayerScripter(thePlayer) or exports.un_integration:isPlayerVehicleConsultant(thePlayer)) then
		if not (id) then
			outputChatBox("KULLANIM: /respawnveh [id]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.un_pool:getElement("vehicle", tonumber(id))
			if theVehicle then
				if isElementAttached(theVehicle) then
					detachElements(theVehicle)
					setElementCollisionsEnabled(theVehicle, true) -- Adams
				end
				
				local dbid = getElementData(theVehicle,"dbid")
				if (dbid<0) then -- TEMP vehicle
					fixVehicle(theVehicle) -- Can't really respawn this, so just repair it
					if armoredCars[ getElementModel( theVehicle ) ] then
						setVehicleDamageProof(theVehicle, true)
					else
						setVehicleDamageProof(theVehicle, false)
					end
					setVehicleWheelStates(theVehicle, 0, 0, 0, 0)
					setElementData(theVehicle, "enginebroke", 0, false)
				else
					exports.un_logs:dbLog(thePlayer, 6, theVehicle, "RESPAWN")

					addVehicleLogs(id, commandName, thePlayer)

					respawnTheVehicle(theVehicle)
					setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
					setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
					if getElementData(theVehicle, "owner") == -2 and getElementData(theVehicle,"Impounded") == 0  then
						setVehicleLocked(theVehicle, false)
					end
				end
				outputChatBox("Vehicle respawned.", thePlayer, 255, 194, 14)
			else
				outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("respawnveh", respawnCmdVehicle, false, false)
addCommandHandler("q", respawnCmdVehicle, false, false)

function respawnGuiVehicle(theVehicle) --Exciter
	local thePlayer = source
	if (exports.un_integration:isPlayerTrialAdmin(thePlayer) or exports.un_integration:isPlayerSupporter(thePlayer) or exports.un_integration:isPlayerScripter(thePlayer) or exports.un_integration:isPlayerVehicleConsultant(thePlayer)) then
		if isElementAttached(theVehicle) then
			detachElements(theVehicle)
			setElementCollisionsEnabled(theVehicle, true)
		end

		local dbid = getElementData(theVehicle,"dbid")
		if (dbid<0) then -- TEMP vehicle
			fixVehicle(theVehicle) -- Can't really respawn this, so just repair it
			if armoredCars[ getElementModel( theVehicle ) ] then
				setVehicleDamageProof(theVehicle, true)
			else
				setVehicleDamageProof(theVehicle, false)
			end
			setVehicleWheelStates(theVehicle, 0, 0, 0, 0)
			setElementData(theVehicle, "enginebroke", 0, false)
		else
			exports.un_logs:dbLog(thePlayer, 6, theVehicle, "RESPAWN")

			local id = tonumber(getElementData(theVehicle, "dbid"))
			addVehicleLogs(id, "respawnveh", thePlayer)

			respawnTheVehicle(theVehicle)
			setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
			setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
			if getElementData(theVehicle, "owner") == -2 and getElementData(theVehicle,"Impounded") == 0  then
				setVehicleLocked(theVehicle, false)
			end
		end
	end
end
addEvent("vehicle_manager:respawn", true)
addEventHandler("vehicle_manager:respawn", getRootElement(), respawnGuiVehicle)

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function respawnAllVehicles(thePlayer, commandName, timeToRespawn)
	if (exports.un_integration:isPlayerTrialAdmin(thePlayer)) then
		if commandName then
			if isTimer(respawnTimer) then
				outputChatBox("Zaten araçlar yeniden spawnlanıyor iptal etmek için /respawnstop.", thePlayer, 255, 0, 0)
			else
				timeToRespawn = tonumber(timeToRespawn) or 30
				timeToRespawn = timeToRespawn < 10 and 10 or timeToRespawn
				for k, arrayPlayer in ipairs(exports.un_global:getAdmins()) do
					local logged = getElementData(arrayPlayer, "loggedin")
					if (logged) then
						if exports.un_integration:isPlayerAdmin(arrayPlayer) then
							outputChatBox( "LeadAdmWarn: " .. getPlayerName(thePlayer) .. " tüm araçları yeniden spawnladı.", arrayPlayer, 255, 194, 14)
						end
					end
				end

				outputChatBox("(( Tüm araçlar "..timeToRespawn.." saniye içinde yenilenecek. ))", root, 255, 0, 0, true)
				respawnTimer = setTimer(respawnAllVehicles, timeToRespawn*1000, 1, thePlayer)
			end
			return
		end
		local tick = getTickCount()
		local vehicles = getElementsByType("vehicle")--exports.un_pool:getPoolElementsByType("vehicle")
		local counter = 0
		local tempcounter = 0
		local tempoccupied = 0
		local radioCounter = 0
		local occupiedcounter = 0
		local unlockedcivs = 0
		local notmoved = 0
		local deleted = 0

		local dimensions = { }
		for k, p in ipairs(getElementsByType("player")) do
			dimensions[ getElementDimension( p ) ] = true
		end

		for k, theVehicle in ipairs(vehicles) do
			if isElement( theVehicle ) then
				local dbid = getElementData(theVehicle, "dbid")
				if not (dbid) or (dbid<0) then -- TEMP vehicle
					local driver = getVehicleOccupant(theVehicle)
					local pass1 = getVehicleOccupant(theVehicle, 1)
					local pass2 = getVehicleOccupant(theVehicle, 2)
					local pass3 = getVehicleOccupant(theVehicle, 3)

					if (dbid and dimensions[dbid + 20000]) or (pass1) or (pass2) or (pass3) or (driver) or (getVehicleTowingVehicle(theVehicle)) or #getAttachedElements(theVehicle) > 0 then
						tempoccupied = tempoccupied + 1
					else
						destroyElement(theVehicle)
						tempcounter = tempcounter + 1
					end
				else
					local driver = getVehicleOccupant(theVehicle)
					local pass1 = getVehicleOccupant(theVehicle, 1)
					local pass2 = getVehicleOccupant(theVehicle, 2)
					local pass3 = getVehicleOccupant(theVehicle, 3)

					if (dimensions[dbid + 20000]) or (pass1) or (pass2) or (pass3) or (driver) or (getVehicleTowingVehicle(theVehicle)) or #getAttachedElements(theVehicle) > 0 then
						occupiedcounter = occupiedcounter + 1
					else
						if isVehicleBlown(theVehicle) then --or isElementInWater(theVehicle) then
							fixVehicle(theVehicle)
							if armoredCars[ getElementModel( theVehicle ) ] then
								setVehicleDamageProof(theVehicle, true)
							else
								setVehicleDamageProof(theVehicle, false)
							end
							for i = 0, 5 do
								setVehicleDoorState(theVehicle, i, 4) -- all kind of stuff missing
							end
							setElementHealth(theVehicle, 300) -- lowest possible health
							setElementData(theVehicle, "enginebroke", 1, false)
						end

						if getElementData(theVehicle, "owner") == -2 and getElementData(theVehicle,"Impounded") == 0 then
							if isElementAttached(theVehicle) then
								detachElements(theVehicle)
								setElementCollisionsEnabled(theVehicle, true) -- Adams
							end
							respawnVehicle(theVehicle)
							setVehicleLocked(theVehicle, false)
							unlockedcivs = unlockedcivs + 1
						else
						if getElementData(theVehicle, "faction") > 0 then
			                            dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `loadstate`='1' WHERE `id`='" .. (dbid) .. "'")
										dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `deleted`='0' WHERE `id`='" .. (dbid) .. "'")
		                end
							local checkx, checky, checkz = getElementPosition( theVehicle )
							if getElementData(theVehicle, "respawnposition") then
								local x, y, z, rx, ry, rz = unpack(getElementData(theVehicle, "respawnposition"))

								if (round(checkx, 6) == x) and (round(checky, 6) == y) then
									notmoved = notmoved + 1
								else
									if isElementAttached(theVehicle) then
										detachElements(theVehicle)
									end
									setElementCollisionsEnabled(theVehicle, true)
									if getElementData(theVehicle, "vehicle:radio") ~= 0 then
										setElementData(theVehicle, "vehicle:radio", 0, true)
										radioCounter = radioCounter + 1
									end
									setElementPosition(theVehicle, x, y, z)
									setVehicleRotation(theVehicle, rx, ry, rz)
									setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
									setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
								
									
									
									if not getElementData(theVehicle, "carshop") then
										if isElementWithinColShape(theVehicle, wangs1Col) or isElementWithinColShape(theVehicle, wangs2Col) or isElementWithinColShape(theVehicle, wangs3Col) or isElementWithinColShape(theVehicle, bikeCol) then
											triggerEvent("onVehicleDelete", theVehicle)
											dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `deleted`='1' WHERE `id`='" .. (dbid) .. "'")
											call( getResourceFromName( "un_items" ), "deleteAll", 3, dbid )
											call( getResourceFromName( "un_items" ), "clearItems", theVehicle )
											exports.un_logs:dbLog(thePlayer, 6, { theVehicle }, "CarShop Delete" )
											destroyElement(theVehicle)
											deleted = deleted + 1
										else
											counter = counter + 1
										end
									end
								end
							else
								--exports.un_global:sendMessageToAdmins("[RESPAWN-ALL] Vehicle #" .. dbid .. " has not been /park'ed!")
								triggerEvent("onVehicleDelete", theVehicle)
								dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `deleted`='1' WHERE `id`='" .. (dbid) .. "'")
								call( getResourceFromName( "un_items" ), "deleteAll", 3, dbid )
								call( getResourceFromName( "un_items" ), "clearItems", theVehicle )
								exports.un_logs:dbLog(thePlayer, 6, { theVehicle }, "CarShop Delete" )
								destroyElement(theVehicle)
								deleted = deleted + 1
							end
						end
						-- fix faction vehicles
						if getElementData(theVehicle, "faction") ~= -1 then
							fixVehicle(theVehicle)
							if (getElementData(theVehicle, "Impounded") == 0) then
								setElementData(theVehicle, "enginebroke", 0, true)
								setElementData(theVehicle, "handbrake", 1, true)
								setTimer(setElementFrozen, 2000, 1, theVehicle, true)
								if armoredCars[ getElementModel( theVehicle ) ] then
									setVehicleDamageProof(theVehicle, true)
								else
									setVehicleDamageProof(theVehicle, false)
								end
							end
						end
					end
				end
			end
		end
		local timeTaken = (getTickCount() - tick)/1000
		outputChatBox(" =-=-=-=-=-=- Tüm Araçlar Yeniden Spawnlandı =-=-=-=-=-=-=", getRootElement(), 255, 194, 14)
	end
end
addCommandHandler("respawnall", respawnAllVehicles, false, false)

function respawnVehiclesStop(thePlayer, commandName)
	if exports.un_integration:isPlayerTrialAdmin(thePlayer) and isTimer(respawnTimer) then
		killTimer(respawnTimer)
		respawnTimer = nil
		if commandName then
			local name = getPlayerName(thePlayer):gsub("_", " ")
			if getElementData(thePlayer, "hiddenadmin") == 1 then
				name = "Hidden Admin"
			end
			outputChatBox( "*** " .. name .. " cancelled the vehicle respawn ***", getRootElement(), 255, 194, 14)
		end
	end
end
addCommandHandler("respawnstop", respawnVehiclesStop, false, false)

function respawnAllCivVehicles(thePlayer, commandName)
    if exports.un_integration:isPlayerTrialAdmin( thePlayer ) or exports.un_integration:isPlayerSupporter(thePlayer) then
        local vehicles = exports.un_pool:getPoolElementsByType("vehicle")
        local counter = 0

        for k, theVehicle in ipairs(vehicles) do
            if getElementData(theVehicle, "tirMeslek") == 1 then
                destroyElement(theVehicle)
            end
            
            local dbid = getElementData(theVehicle, "dbid")
			
            if dbid and dbid > 0 then
                if getElementData(theVehicle, "owner") == -2 or getElementData(theVehicle, "owner") == -1  then
                    if getElementData(theVehicle, "job") > 0 or getElementModel(theVehicle) == 410 or getElementModel(theVehicle) == 468 then
                    local driver = getVehicleOccupant(theVehicle)
                    local pass1 = getVehicleOccupant(theVehicle, 1)
                    local pass2 = getVehicleOccupant(theVehicle, 2)
                    local pass3 = getVehicleOccupant(theVehicle, 3)

                    if not pass1 and not pass2 and not pass3 and not driver and not getVehicleTowingVehicle(theVehicle) and #getAttachedElements(theVehicle) == 0 then
                        if isElementAttached(theVehicle) then
                            detachElements(theVehicle)
                        end
                        exports.un_anticheat:changeProtectedElementDataEx(theVehicle, 'i:left')
                        exports.un_anticheat:changeProtectedElementDataEx(theVehicle, 'i:right')
                        respawnTheVehicle(theVehicle)
                        setVehicleLocked(theVehicle, false)
                        setElementInterior(theVehicle, 0)
                        setElementDimension(theVehicle, 0)
                        exports.un_anticheat:changeProtectedElementDataEx(theVehicle, "vehicle:radio", 0, true)
                        counter = counter + 1
                        end
                    end
                end
            end
        end
        outputChatBox("[-]#f9f9f9 Tüm sivil araçlar respawnlanmıştır.", getRootElement(), 122, 177, 222, true)
        outputChatBox("[-]#f9f9f9 Toplam " .. counter .. " meslek aracı respawnlandı.", thePlayer, 255, 194, 14, true)
    end
end
addCommandHandler("respawnciv", respawnAllCivVehicles)

function respawnFactionVehicles(thePlayer, commandName)
    if exports.un_integration:isPlayerTrialAdmin( thePlayer ) or exports.un_integration:isPlayerSupporter(thePlayer) then
        local vehicles = exports.un_pool:getPoolElementsByType("vehicle")
        local counter = 0

        for k, theVehicle in ipairs(vehicles) do
            
            local dbid = getElementData(theVehicle, "dbid")
			
            if getElementData(theVehicle, "faction") and dbid then
			restoreFaction(dbid)
            end
        end
    end
end
addCommandHandler("respawnfact", respawnFactionVehicles)

function respawnAllInteriorVehicles(thePlayer, commandName, repair)
	local repair = tonumber( repair ) == 1 and exports.un_integration:isPlayerTrialAdmin( thePlayer )
	local dimension = getElementDimension(thePlayer)
	if dimension > 0 and ( exports.un_global:hasItem(thePlayer, 4, dimension) or exports.un_global:hasItem(thePlayer, 5, dimension) ) then
		local vehicles = exports.un_pool:getPoolElementsByType("vehicle")
		local counter = 0

		for k, theVehicle in ipairs(vehicles) do
			if getElementData(theVehicle, "dimension") == dimension then
				local dbid = getElementData(theVehicle, "dbid")
				if dbid and dbid > 0 then
					local driver = getVehicleOccupant(theVehicle)
					local pass1 = getVehicleOccupant(theVehicle, 1)
					local pass2 = getVehicleOccupant(theVehicle, 2)
					local pass3 = getVehicleOccupant(theVehicle, 3)

					if not pass1 and not pass2 and not pass3 and not driver and not getVehicleTowingVehicle(theVehicle) and #getAttachedElements(theVehicle) == 0 then
						local checkx, checky, checkz = getElementPosition( theVehicle )
						if getElementData(theVehicle, "respawnposition") then


							local x, y, z, rx, ry, rz = unpack(getElementData(theVehicle, "respawnposition"))

							if (round(checkx, 6) ~= x) or (round(checky, 6) ~= y) then
								if isElementAttached(theVehicle) then
									detachElements(theVehicle)
								end
								if repair then
									respawnTheVehicle(theVehicle)

									setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
									setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
								else
									setElementPosition(theVehicle, x, y, z)
									setVehicleRotation(theVehicle, rx, ry, rz)
									setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
									setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
								end
								counter = counter + 1
							end
						else
							exports.un_global:sendMessageToAdmins("[Respawn] There's something wrong with vehicle "..dbid)
						end
					end
				end
			end
		end
		outputChatBox("Respawned " .. counter .. " district vehicles.", thePlayer)
	else
		outputChatBox( "Ain't your place, is it?", thePlayer, 255, 0, 0 )
	end
end
addCommandHandler("respawnint", respawnAllInteriorVehicles, false, false)


function respawnDistrictVehicles(thePlayer, commandName)
	if exports.un_integration:isPlayerTrialAdmin( thePlayer ) then
		local zoneName = exports.un_global:getElementZoneName(thePlayer)
		local vehicles = exports.un_pool:getPoolElementsByType("vehicle")
		local counter = 0
		local deleted = 0

		for k, theVehicle in ipairs(vehicles) do
			local vehicleZoneName = exports.un_global:getElementZoneName(theVehicle)
			if (zoneName == vehicleZoneName) then
				local dbid = getElementData(theVehicle, "dbid")
				if dbid and dbid > 0 then
					local driver = getVehicleOccupant(theVehicle)
					local pass1 = getVehicleOccupant(theVehicle, 1)
					local pass2 = getVehicleOccupant(theVehicle, 2)
					local pass3 = getVehicleOccupant(theVehicle, 3)

					if not pass1 and not pass2 and not pass3 and not driver and not getVehicleTowingVehicle(theVehicle) and #getAttachedElements(theVehicle) == 0 then
						local checkx, checky, checkz = getElementPosition( theVehicle )
						if getElementData(theVehicle, "respawnposition") then
							local x, y, z, rx, ry, rz = unpack(getElementData(theVehicle, "respawnposition"))

							if (round(checkx, 6) ~= x) or (round(checky, 6) ~= y) then
								if isElementAttached(theVehicle) then
									detachElements(theVehicle)
								end
								setElementCollisionsEnabled(theVehicle, true)
								setElementPosition(theVehicle, x, y, z)
								setVehicleRotation(theVehicle, rx, ry, rz)
								setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
								setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
								setElementData(theVehicle, "vehicle:radio", 0, true)
								if not getElementData(theVehicle, "carshop") then
									if isElementWithinColShape(theVehicle, wangs1Col) or isElementWithinColShape(theVehicle, wangs2Col) or isElementWithinColShape(theVehicle, wangs3Col) or isElementWithinColShape(theVehicle, bikeCol) then
										triggerEvent("onVehicleDelete", theVehicle)
										dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `deleted`='1' WHERE id='" .. (dbid) .. "'")
										call( getResourceFromName( "un_items" ), "deleteAll", 3, dbid )
										call( getResourceFromName( "un_items" ), "clearItems", theVehicle )
										exports.un_logs:dbLog(thePlayer, 6, { theVehicle }, "CarShop Delete" )
										destroyElement(theVehicle)
										deleted = deleted + 1
									else
										counter = counter + 1
									end
								end
							end
						else
							triggerEvent("onVehicleDelete", theVehicle)
							dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `deleted`='1' WHERE `id`='" .. (dbid) .. "'")
							call( getResourceFromName( "un_items" ), "deleteAll", 3, dbid )
							call( getResourceFromName( "un_items" ), "clearItems", theVehicle )
							exports.un_logs:dbLog(thePlayer, 6, { theVehicle }, "CarShop Delete" )
							destroyElement(theVehicle)
							deleted = deleted + 1
						end
					end
				end
			end
		end
		exports.un_global:sendMessageToAdmins("AdmWrn: ".. getPlayerName(thePlayer) .." respawned " .. counter .. " and deleted " .. deleted .. " district vehicles in '"..zoneName.."'.", thePlayer)
	end
end
addCommandHandler("respawndistrict", respawnDistrictVehicles, false, false)

function addPaintjob(thePlayer, commandName, target, paintjobID)
	if exports.un_integration:isPlayerSeniorAdmin(thePlayer)  then
		if not (target) or not (paintjobID) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Partial Player Nick] [Paintjob ID]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(thePlayer, target)

			if targetPlayer then
				if not (isPedInVehicle(targetPlayer)) then
					outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
				else
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
					paintjobID = tonumber(paintjobID)
					if paintjobID == getVehiclePaintjob(theVehicle) then
						outputChatBox("This Vehicle already has this paintjob.", thePlayer, 255, 0, 0)
					else
						local success = setVehiclePaintjob(theVehicle, paintjobID)

						if (success) then

							addVehicleLogs(getElementData(theVehicle,"dbid"), commandName.." "..paintjobID, thePlayer)

							exports.un_logs:dbLog(thePlayer, 6, { targetPlayer, theVehicle  }, "PAINTJOB ".. paintjobID )
							outputChatBox("Paintjob #" .. paintjobID .. " added to " .. targetPlayerName .. "'s vehicle.", thePlayer)
							outputChatBox("Admin " .. username .. " added Paintjob #" .. paintjobID .. " to your vehicle.", targetPlayer)
							exports['un_vehicle']:saveVehicleMods(theVehicle)
						else
							outputChatBox("Invalid Paintjob ID, or this vehicle doesn't support this paintjob.", thePlayer, 255, 0, 0)
						end
					end
				end
			end
		end
	end

end
addCommandHandler("setpaintjob", addPaintjob, false, false)

function fixPlayerVehicle(thePlayer, commandName, target)
	if exports.un_integration:isPlayerTrialAdmin(thePlayer) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(thePlayer, target)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						fixVehicle(veh)
						setElementData(veh, "enginebroke", 0, false)
						fixVehicle(veh)
						for i = 0, 5 do
							setVehicleDoorState(veh, i, 0)
						end
						outputChatBox("" .. targetPlayerName .. " isimli oyuncunun aracını tamir ettiniz..", thePlayer)
						outputChatBox("Aracın " .. username:gsub("_", " ") .. " isimli yetkili tarafından tamir edildi.", targetPlayer)
						exports.un_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili "..targetPlayerName.." isimli oyuncunun aracını tamir etti.")
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("fixveh", fixPlayerVehicle, false, false)

-----------------------------[SET CAR HP]---------------------------------
function setCarHP(thePlayer, commandName, target, hp)
	if (exports.un_integration:isPlayerSeniorAdmin(thePlayer)) then
		if not (target) or not (hp) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Health]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(thePlayer, target)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						local sethp = setElementHealth(veh, tonumber(hp))

						if (sethp) then
							outputChatBox("You set " .. targetPlayerName .. "'s vehicle health to " .. hp .. ".", thePlayer)
						
						else
							outputChatBox("Invalid health value.", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("setcarhp", setCarHP, false, false)

function fixAllVehicles(thePlayer, commandName)
	if (exports.un_integration:isPlayerHeadAdmin(thePlayer)) then
		local username = getPlayerName(thePlayer)
		for key, value in ipairs(exports.un_pool:getPoolElementsByType("vehicle")) do
			fixVehicle(value)
			if (not getElementData(value, "Impounded")) then
				setElementData(value, "enginebroke", 0, false)
				if armoredCars[ getElementModel( value ) ] then
					setVehicleDamageProof(value, true)
				else
				setVehicleDamageProof(value, false)
				end
			end
		end

	end
end
--addCommandHandler("fixvehs", fixAllVehicles)

-----------------------------[FUEL VEH]---------------------------------
function fuelPlayerVehicle(thePlayer, commandName, target, amount)
	if exports.un_integration:isPlayerTrialAdmin(thePlayer) or exports.un_integration:isPlayerSupporter(thePlayer) then
		if not (target) or not (amount) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Partial Player Nick] [Amount in Liters, 0=Full]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(thePlayer, target)
			local amount = math.floor(tonumber(amount) or 0)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						if exports["un_vehicle_fuel"]:getMaxFuel(getElementModel(veh))<amount or amount==0 then
							amount = exports["un_vehicle_fuel"]:getMaxFuel(getElementModel(veh))
						end
						setElementData(veh, "fuel", amount)
					--	triggerClientEvent(targetPlayer, "syncFuel", veh, getElementData(veh, "fuel"))
						outputChatBox("You refueled " .. targetPlayerName .. "'s vehicle.", thePlayer)
						outputChatBox("Your vehicle was refueled by admin " .. username .. ".", targetPlayer)
					else
						outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("fuelveh", fuelPlayerVehicle, false, false)

function fuelAllVehicles(thePlayer, commandName)
	if (exports.un_integration:isPlayerTrialAdmin(thePlayer)) then
		local username = getPlayerName(thePlayer)
		for key, value in ipairs(exports.un_pool:getPoolElementsByType("vehicle")) do
			setElementData(value, "fuel", exports["un_vehicle_fuel"]:getMaxFuel(getElementModel(value)), false)
		end
		--outputChatBox("All vehicles refuelled by Admin " .. username .. ".")
		executeCommandHandler("ann", thePlayer, "All vehicles refuelled by Admin " .. username .. ".")
		exports.un_logs:dbLog(thePlayer, 6, { thePlayer  }, "FUELVEHS" )
	end
end
addCommandHandler("fuelvehs", fuelAllVehicles, false, false)

-----------------------------[SET COLOR]---------------------------------
function setPlayerVehicleColor(thePlayer, commandName, target, ...)
	if (exports.un_integration:isPlayerTrialAdmin(thePlayer) or exports.un_integration:isPlayerScripter(thePlayer)) then
		if not tonumber(target) or not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Vehicle ID] [Colors ...]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			for i,c in ipairs(exports.un_pool:getPoolElementsByType("vehicle")) do
				if (getElementData(c, "dbid") == tonumber(target)) then
					theVehicle = c
					break
				end
			end

			if theVehicle then
				-- parse colors
				local colors = {...}
				local col = {}
				for i = 1, math.min( 4, #colors ) do
					local r, g, b = getColorFromString(#colors[i] == 6 and ("#" .. colors[i]) or colors[i])
					if r and g and b then
						col[i] = {r=r, g=g, b=b}
					elseif tonumber(colors[1]) and tonumber(colors[1]) >= 0 and tonumber(colors[1]) <= 255 then
						col[i] = math.floor(tonumber(colors[i]))
					else
						outputChatBox("Invalid color: " .. colors[i], thePlayer, 255, 0, 0)
						return
					end
				end
				if not col[2] then col[2] = col[1] end
				if not col[3] then col[3] = col[1] end
				if not col[4] then col[4] = col[2] end

				local set = false
				if type( col[1] ) == "number" then
					set = setVehicleColor(theVehicle, col[1], col[2], col[3], col[4])
				else
					set = setVehicleColor(theVehicle, col[1].r, col[1].g, col[1].b, col[2].r, col[2].g, col[2].b, col[3].r, col[3].g, col[3].b, col[4].r, col[4].g, col[4].b)
				end

				if set then
					outputChatBox("Vehicle's color was set.", thePlayer, 0, 255, 0)
					exports['un_vehicle']:saveVehicleMods(theVehicle)
					exports.un_logs:dbLog(thePlayer, 6, {  theVehicle  }, "SETVEHICLECOLOR ".. table.concat({...}, " ") )

					addVehicleLogs(getElementData(theVehicle,"dbid"), commandName..table.concat({...}, " "), thePlayer)

				else
					outputChatBox("Invalid Color ID.", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("Vehicle is not found. Is it a permanent vehicle?", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setcolor", setPlayerVehicleColor, false, false)
-----------------------------[GET COLOR]---------------------------------
function getAVehicleColor(thePlayer, commandName, carid)
	if (exports.un_integration:isPlayerTrialAdmin(thePlayer) or exports.un_integration:isPlayerScripter(thePlayer)) then
		if not (carid) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Car ID]", thePlayer, 255, 194, 14)
		else
			local acar = nil
			for i,c in ipairs(getElementsByType("vehicle")) do
				if (getElementData(c, "dbid") == tonumber(carid)) then
					acar = c
				end
			end
			if acar then
				local col =  { getVehicleColor(acar, true) }
				outputChatBox("Vehicle's colors are:", thePlayer)
				outputChatBox("1. " .. col[1].. "," .. col[2] .. "," .. col[3] .. " = " .. ("#%02X%02X%02X"):format(col[1], col[2], col[3]), thePlayer)
				outputChatBox("2. " .. col[4].. "," .. col[5] .. "," .. col[6] .. " = " .. ("#%02X%02X%02X"):format(col[4], col[5], col[6]), thePlayer)
				outputChatBox("3. " .. col[7].. "," .. col[8] .. "," .. col[9] .. " = " .. ("#%02X%02X%02X"):format(col[7], col[8], col[9]), thePlayer)
				outputChatBox("4. " .. col[10].. "," .. col[11] .. "," .. col[12] .. " = " .. ("#%02X%02X%02X"):format(col[10], col[11], col[12]), thePlayer)
			else
				outputChatBox("Invalid Car ID.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("getcolor", getAVehicleColor, false, false)

function removeVehicle(thePlayer, commandName, id)
	if exports.un_integration:isPlayerHeadAdmin(thePlayer) then
		local dbid = tonumber(id)
		if not dbid or dbid%1~=0 or dbid <=0 then
			dbid = getElementData(thePlayer, "vehicleManager:deletedVeh") or false
			if not dbid then
				outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
				return false
			end
		end
		dbQuery(
			function(qh, thePlayer, id)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, row in ipairs(res) do
						if row["deleted"] == "0" then
							outputChatBox(" Please use /delveh "..dbid.." first.", thePlayer, 255, 0, 0)
							return false
						else
							dbExec(mysql:getConnection(), "DELETE FROM `vehicles` WHERE `id`='" .. (dbid) .. "'")
							dbExec(mysql:getConnection(), "DELETE FROM `vehicle_logs` WHERE `vehID`='" .. (dbid) .. "'")
							call( getResourceFromName( "un_items" ), "deleteAll", 3, dbid )

							local adminUsername = getElementData(thePlayer, "account:username")
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							local adminTitle = exports.un_global:getPlayerAdminTitle(thePlayer)

							exports.un_global:sendMessageToAdmins("[VEHICLE]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " isimli yetkili #" .. dbid .. " ID'li aracı SQL'den sildi.")
							return true
						end
					end
				end
			end,
		{thePlayer, id}, mysql:getConnection(), "SELECT `deleted` FROM `vehicles` WHERE id='" .. (dbid) .. "'")
	else
		outputChatBox("You don't have permission to remove vehicles from SQL.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("removeveh", removeVehicle, false, false)
addCommandHandler("removevehicle", removeVehicle, false, false)

function clearVehicleInventory(theVehicle)
	if theVehicle then
		local count = 0
		for key, item in pairs(exports["un_items"]:getItems(theVehicle)) do
			exports.un_global:takeItem(theVehicle, item[1], item[2])
			count = count + 1
		end
		return count
	else
		--outputDebugString("[VEH MANAGER] / vehicle commands / clearVehicleInventory() / element not found.")
		return false
	end
end

function adminClearVehicleInventory(thePlayer, commandName, vehicle)
	if exports.un_integration:isPlayerTrialAdmin(thePlayer) then
		vehicle = tonumber(vehicle)
		if vehicle and (vehicle%1==0) then
			for _, theVehicle in pairs(getElementsByType("vehicle")) do
				if getElementData(theVehicle, "dbid") == vehicle then
					vehicle = theVehicle
					break
				end
			end
		end

		if not isElement(vehicle) then
			vehicle = getPedOccupiedVehicle(thePlayer) or false
		end

		if not vehicle then
			outputChatBox("KULLANIM: /" .. commandName .. " [ID]     -> Clear all items in a vehicle inventory.", thePlayer, 255, 194, 14)
			outputChatBox("KULLANIM: /" .. commandName .. "          -> Clear all items in current vehicle inventory.", thePlayer, 255, 194, 14)
			return false
		end

		outputChatBox("Deleted "..(clearVehicleInventory(vehicle) or "0").." item(s) from vehicle's inventory.",thePlayer)

	else
		outputChatBox("Only Admins can perform this command. Operation cancelled.", thePlayer, 255,0,0)
	end
end
addCommandHandler("clearvehinv", adminClearVehicleInventory, false, false)
addCommandHandler("clearvehicleinventory", adminClearVehicleInventory, false, false)

function restoreVehicle(thePlayer, commandName, id)
	if exports.un_integration:isPlayerTrialAdmin(thePlayer) then
		local dbid = tonumber(id)
		if not (dbid) then
			outputChatBox("KULLANIM: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.un_pool:getElement("vehicle", dbid)
			local adminUsername = getElementData(thePlayer, "account:username")
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local adminTitle = exports.un_global:getPlayerAdminTitle(thePlayer)
			local adminID = getElementData(thePlayer, "account:id")
			if not theVehicle then
				if dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `deleted`='0', `chopped`='0' WHERE `id`='" .. (dbid) .. "'") then
					call( getResourceFromName( "un_vehicle" ), "loadOneVehicle", dbid )
					outputChatBox("   Restoring vehicle ID #"..dbid.."...", thePlayer)
					setTimer(function()
						outputChatBox("   Restoring vehicle ID #"..dbid.."...Done!", thePlayer)
						local theVehicle1 = exports.un_pool:getElement("vehicle", dbid)
						exports.un_logs:dbLog(thePlayer, 6, { theVehicle1 }, "RESTOREVEH" )
						addVehicleLogs(dbid, commandName, thePlayer)

						local vehicleID = getElementModel(theVehicle1)
						local vehicleName = getVehicleNameFromModel(vehicleID)
						local owner = getElementData(theVehicle1, "owner")
						local faction = getElementData(theVehicle1, "faction")
						local ownerName = ""
						if faction then
							if (faction>0) then
								local theTeam = exports.un_pool:getElement("team", faction)
								if theTeam then
									ownerName = getTeamName(theTeam)
								end
							elseif (owner==-1) then
								ownerName = "Admin Temp Vehicle"
							elseif (owner>0) then
								ownerName = exports['un_cache']:getCharacterName(owner, true)
							else
								ownerName = "Civilian"
							end
						else
							ownerName = "Car Dealership"
						end

						if hiddenAdmin == 0 then
						exports.un_global:sendMessageToAdmins("[VEHICLE]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has restore a " .. vehicleName .. " (ID: #" .. dbid .. " - Owner: " .. ownerName..").")
						else
							exports.un_global:sendMessageToAdmins("[VEHICLE]: A hidden admin has restore a " .. vehicleName .. " (ID: #" .. dbid .. " - Owner: " .. ownerName..").")
						end
					end, 2000,1)

				else
					outputChatBox(" Database Error!", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox(" Vehicle ID #"..dbid.." is existed in game, please use /delveh first.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("restoreveh", restoreVehicle, false, false)
addCommandHandler("restorevehicle", restoreVehicle, false, false)

function restoreFaction(id)
		local dbid = tonumber(id)
		if not (dbid) then
			outputDebugString ( "Yüklenemedi" )
		else
			local theVehicle = exports.un_pool:getElement("vehicle", dbid)
			if theVehicle then
				if dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `deleted`='0', `chopped`='0' WHERE `id`='" .. (dbid) .. "'") then
					call( getResourceFromName( "un_vehicle" ), "loadOneVehicle", dbid )
					--outputChatBox("   Restoring vehicle ID #"..dbid.."...", thePlayer)
					outputDebugString ( "Yükleniyor" )
					setTimer(function()
						--outputChatBox("   Restoring vehicle ID #"..dbid.."...Done!", thePlayer)
						outputDebugString ( "yüklendi" )
						local theVehicle1 = exports.un_pool:getElement("vehicle", dbid)
						exports.un_logs:dbLog(thePlayer, 6, { theVehicle1 }, "RESTOREVEH" )
						--addVehicleLogs(dbid, commandName, thePlayer)

						local vehicleID = getElementModel(theVehicle1)
						local vehicleName = getVehicleNameFromModel(vehicleID)
						local owner = getElementData(theVehicle1, "owner")
						local faction = getElementData(theVehicle1, "faction")
						local ownerName = ""
						if faction then
							if (faction>0) then
								local theTeam = exports.un_pool:getElement("team", faction)
								if theTeam then
									ownerName = getTeamName(theTeam)
								end
							elseif (owner==-1) then
								ownerName = "Admin Temp Vehicle"
							elseif (owner>0) then
								ownerName = exports['un_cache']:getCharacterName(owner, true)
							else
								ownerName = "Civilian"
							end
						else
							ownerName = "Car Dealership"
						end

						--if hiddenAdmin == 0 then
						--exports.un_global:sendMessageToAdmins("[VEHICLE]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has restore a " .. vehicleName .. " (ID: #" .. dbid .. " - Owner: " .. ownerName..").")
						--else
							--exports.un_global:sendMessageToAdmins("[VEHICLE]: A hidden admin has restore a " .. vehicleName .. " (ID: #" .. dbid .. " - Owner: " .. ownerName..").")
						--nd
					end, 2000,1)

				else
				outputDebugString ( "veritabanı hatası" )
					--outputChatBox(" Database Error!", thePlayer, 255, 0, 0)
				end
			else
			outputDebugString ( "Böyle bir araç yok" )
				--outputChatBox(" Vehicle ID #"..dbid.." is existed in game, please use /delveh first.", thePlayer, 255, 0, 0)
			end
		end
end
addEvent("restoreFaction", true)
addEventHandler("restoreFaction", getRootElement(), restoreFaction) 

function deleteVehicle(thePlayer, commandName, id)
	if exports.un_integration:isPlayerHeadAdmin(thePlayer) or exports.un_integration:isPlayerScripter(thePlayer) then
		local dbid = tonumber(id)
		if not (dbid) then
			outputChatBox("KULLANIM: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.un_pool:getElement("vehicle", dbid)
			local adminUsername = getElementData(thePlayer, "account:username")
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local adminTitle = exports.un_global:getPlayerAdminTitle(thePlayer)
			local adminID = getElementData(thePlayer, "account:id")
			if theVehicle then
				
	            if exports.un_data:load(getElementData(thePlayer, "account:id").."/"..commandName) ~= dbid then
	            	local inactiveText = ""
	                local owner_last_login = getElementData(theVehicle, "owner_last_login")
					if owner_last_login and tonumber(owner_last_login) then
						local owner_last_login_text, owner_last_login_sec = exports.un_datetime:formatTimeInterval(owner_last_login)
						inactiveText = inactiveText.." Owner last seen "..owner_last_login_text.." "
					else
						inactiveText = inactiveText.." Owner last seen is irrelevant, "
					end
	                local lastused = getElementData(theVehicle, "lastused")
					if lastused and tonumber(lastused) then
						local lastusedText, lastusedSeconds = exports.un_datetime:formatTimeInterval(lastused)
						inactiveText = inactiveText.."Last used "..lastusedText..", "
					else
						inactiveText = inactiveText.."Last used is irrelevant, "
					end
					outputChatBox("This vehicle is still active. "..inactiveText.." Please /"..commandName.." "..dbid.." again to proceed.", thePlayer, 255, 0, 0)
					exports.un_data:save(dbid, getElementData(thePlayer, "account:id").."/"..commandName)
					return false
	            end
				local vehicleID = getElementModel(theVehicle)
				local vehicleName = getVehicleNameFromModel(vehicleID)
				local owner = getElementData(theVehicle, "owner")
				local faction = getElementData(theVehicle, "faction")
				local ownerName = ""
				if faction then
					if (faction>0) then
						local theTeam = exports.un_pool:getElement("team", faction)
						if theTeam then
							ownerName = getTeamName(theTeam)
						end
					elseif (owner==-1) then
						ownerName = "Admin Temp Vehicle"
					elseif (owner>0) then
						ownerName = exports['un_cache']:getCharacterName(owner, true)
					else
						ownerName = "Civilian"
					end
				else
					ownerName = "Car Dealership"
				end

				triggerEvent("onVehicleDelete", theVehicle)
				if (dbid<0) then -- TEMP vehicle
					destroyElement(theVehicle)
				else
					dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `deleted`='"..tostring(adminID).."' WHERE `id`='" .. (dbid) .. "'")
					exports.un_logs:dbLog(thePlayer, 6, { theVehicle }, "DELVEH" )
					destroyElement(theVehicle)

					if hiddenAdmin == 0 then
						exports.un_global:sendMessageToAdmins("[VEHICLE]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has deleted a " .. vehicleName .. " (ID: #" .. dbid .. " - Owner: " .. ownerName..").")
					else
						exports.un_global:sendMessageToAdmins("[VEHICLE]: A hidden admin has deleted a " .. vehicleName .. " (ID: #" .. dbid .. " - Owner: " .. ownerName..").")
					end
					addVehicleLogs(dbid, commandName, thePlayer)

					call( getResourceFromName( "un_items" ), "deleteAll", 3, dbid )
					call( getResourceFromName( "un_items" ), "clearItems", theVehicle )

					for k, theObject in ipairs(getElementsByType("object", getResourceRootElement(getResourceFromName("un_item_world")))) do
					local itemID = getElementData(theObject, "itemID")
					local itemValue = getElementData(theObject, "itemValue")
					if itemID == 3 and itemValue == dbid then
						destroyElement(theObject)
						dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE itemid='3' AND itemvalue='" .. (dbid) .. "'")
					end
				end

					setElementData(thePlayer, "vehicleManager:deletedVeh", dbid, false)
				end
				outputChatBox("   Deleted a " .. vehicleName .. " (ID: #" .. dbid .. " - Owner: " .. ownerName..").", thePlayer, 255, 126, 0)
			else
				outputChatBox("No vehicles with that ID found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delveh", deleteVehicle, false, false)
addCommandHandler("deletevehicle", deleteVehicle, false, false)

-- DELTHISVEH
function deleteThisVehicle(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	local dbid = getElementData(veh, "dbid")
	if (exports.un_integration:isPlayerTrialAdmin(thePlayer)) then
		if not (isPedInVehicle(thePlayer)) then
			outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
		else
			deleteVehicle(thePlayer, "delveh", dbid)
		end
	else
		outputChatBox("You do not have the permission to delete permanent vehicles.", thePlayer, 255, 0, 0)
	return
	end
end
addCommandHandler("delthisveh", deleteThisVehicle, false, false)

function setVehicleFaction(thePlayer, theCommand, vehicleID, factionID)
	if exports.un_integration:isPlayerSeniorAdmin(thePlayer) then
		if not (vehicleID) or not (factionID) then
			outputChatBox("KULLANIM: /" .. theCommand .. " [vehicleID] [factionID]", thePlayer, 255, 194, 14)
		else
			local owner = -1
			local theVehicle = exports.un_pool:getElement("vehicle", vehicleID)
			local factionElement = exports.un_pool:getElement("team", factionID)
			if theVehicle then
				if (tonumber(factionID) == -1) then
					owner = getElementData(thePlayer, "account:character:id")
				else
					if not factionElement then
						outputChatBox("No faction with that ID found.", thePlayer, 255, 0, 0)
						return
					end
				end

				dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `owner`='".. (owner) .."', `faction`='" .. (factionID) .. "', `loadstate`='1' WHERE id = '" .. (vehicleID) .. "'")

				local x, y, z = getElementPosition(theVehicle)
				local int = getElementInterior(theVehicle)
				local dim = getElementDimension(theVehicle)
				exports['un_vehicle']:reloadVehicle(tonumber(vehicleID))
				local newVehicleElement = exports.un_pool:getElement("vehicle", vehicleID)
				setElementPosition(newVehicleElement, x, y, z)
				setElementInterior(newVehicleElement, int)
				setElementDimension(newVehicleElement, dim)
				outputChatBox("Done.", thePlayer)

				exports.un_logs:dbLog(thePlayer, 4, { pveh, theVehicle }, theCommand.." "..factionID)
				addVehicleLogs(vehicleID, theCommand.." "..factionID, thePlayer)
			else
				outputChatBox("No vehicle with that ID found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setvehiclefaction", setVehicleFaction)
addCommandHandler("setvehfaction", setVehicleFaction)

function vergiFiyat(thePlayer)
	if exports.un_integration:isPlayerSeniorAdmin(thePlayer) then
	local veh = getPedOccupiedVehicle(thePlayer)
		if not veh then
			exports.un_notification:create(thePlayer,"Bu komutu sadece aracın içerisinde kullanabilirsin.", "error")
		return end
			local vehicleID = getElementData(veh, "dbid")
	
				local faizDeger = 0
				local vergiDeger = 0
				dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `faizkilidi`='" .. (faizDeger) .. "', `vergi`='" .. (vergiDeger) .. "' WHERE id = '" .. (vehicleID) .. "'")
				setElementData(veh, "vergi", false)
				setElementData(veh, "faizkilidi", false)
				exports.un_notification:create(thePlayer,"Başarıyla aracın vergi borcunu sıfırladın.", "success")
	end
end
addCommandHandler("vergisifirla", vergiFiyat)

--Adding/Removing tint
function setVehTint(admin, command, target, status)
	if exports.un_integration:isPlayerHeadAdmin(admin) then
		if not (target) or not (status) then
			outputChatBox("KULLANIM: /" .. command .. " [player] [0- Off, 1- On]", admin, 255, 194, 14)
		else
			local username = getPlayerName(admin):gsub("_"," ")
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(admin, target)

			if (targetPlayer) then
				local pv = getPedOccupiedVehicle(targetPlayer)
				if (pv) then
					local vid = getElementData(pv, "dbid")
					local stat = tonumber(status)
					if (stat == 1) then
						dbExec(mysql:getConnection(), "UPDATE vehicles SET tintedwindows = '1' WHERE id='" .. (vid) .. "'")
						for i = 0, getVehicleMaxPassengers(pv) do
							local player = getVehicleOccupant(pv, i)
							if (player) then
								triggerEvent("setTintName", pv, player)
							end
						end

						setElementData(pv, "tinted", true, true)
						triggerClientEvent("tintWindows", pv)
						outputChatBox("You have added tint to vehicle #" .. vid .. ".", admin)
						for k, arrayPlayer in ipairs(exports.un_global:getAdmins()) do
							local logged = getElementData(arrayPlayer, "loggedin")
							if (logged) then
								if exports.un_integration:isPlayerAdmin(arrayPlayer) then
									outputChatBox( "LeadAdmWarn: " .. getPlayerName(admin):gsub("_"," ") .. " added tint to vehicle #" .. vid .. ".", arrayPlayer, 255, 194, 14)
								end
							end
						end

						exports.un_logs:dbLog(admin, 6, {pv, targetPlayer}, "SETVEHTINT 1" )

						addVehicleLogs(vid, command.." on", admin)

					elseif (stat == 0) then
						dbExec(mysql:getConnection(), "UPDATE vehicles SET tintedwindows = '0' WHERE id='" .. (vid) .. "'")
						for i = 0, getVehicleMaxPassengers(pv) do
							local player = getVehicleOccupant(pv, i)
							if (player) then
								triggerEvent("resetTintName", pv, player)
							end
						end
						setElementData(pv, "tinted", false, true)
						triggerClientEvent("tintWindows", pv)
						outputChatBox("You have removed tint from vehicle #" .. vid .. ".", admin)
						for k, arrayPlayer in ipairs(exports.un_global:getAdmins()) do
							local logged = getElementData(arrayPlayer, "loggedin")
							if (logged) then
								if exports.un_integration:isPlayerAdmin(arrayPlayer) then
									outputChatBox( "LeadAdmWarn: " .. getPlayerName(admin):gsub("_"," ") .. " removed tint from vehicle #" .. vid .. ".", arrayPlayer, 255, 194, 14)
								end
							end
						end
						exports.un_logs:dbLog(admin, 4, {pv, targetPlayer}, "SETVEHTINT 0" )
						addVehicleLogs(vid, command.." off", admin)
					end
				else
					outputChatBox("Player not in a vehicle.", admin, 255, 194, 14)
				end
			end
		end
	end
end
addCommandHandler("setvehtint", setVehTint)

function setVehiclePlate(thePlayer, theCommand, vehicleID, ...)
	if exports.un_integration:isPlayerHeadAdmin(thePlayer) or exports.un_integration:isPlayerLeadScripter(thePlayer) or exports.un_integration:isPlayerVehicleConsultant(thePlayer) then
		if not (vehicleID) or not (...) then
			outputChatBox("KULLANIM: /" .. theCommand .. " [vehicleID] [Text]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.un_pool:getElement("vehicle", vehicleID)
			if theVehicle then
				--if exports['un_vehicle']:hasVehiclePlates(theVehicle) then
					local plateText = table.concat({...}, " ")
					if (exports.un_vehicle_plate:checkPlate(plateText)) then
						for index, value in ipairs(getElementsByType("vehicle")) do
							if getVehiclePlateText(value) == plateText then
								usingPlateText = true
							else
								usingPlateText = false
							end
						end
						if not (usingPlateText) then
							local insertnplate = dbExec(mysql:getConnection(), "UPDATE vehicles SET plate='" .. (plateText) .. "' WHERE id = '" .. (vehicleID) .. "'")
							local x, y, z = getElementPosition(theVehicle)
							local int = getElementInterior(theVehicle)
							local dim = getElementDimension(theVehicle)
							exports['un_vehicle']:reloadVehicle(tonumber(vehicleID))
							local newVehicleElement = exports.un_pool:getElement("vehicle", vehicleID)
							setElementPosition(newVehicleElement, x, y, z)
							setElementInterior(newVehicleElement, int)
							setElementDimension(newVehicleElement, dim)
							outputChatBox("Done.", thePlayer)

							addVehicleLogs(vehicleID, theCommand.." "..plateText, thePlayer)
						else
							outputChatBox("This plate is already in use! =( umadbro?", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("Invalid plate text specified.", thePlayer, 255, 0, 0)
					end
				--else
				--	outputChatBox("This vehicle doesn't have any plates.", thePlayer, 255, 0, 0)
				--end
			else
				outputChatBox("No vehicles with that ID found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setvehicleplate", setVehiclePlate)
addCommandHandler("setvehplate", setVehiclePlate)

-- /entercar
function warpPedIntoVehicle2(player, car, ...)
	local dimension = getElementDimension(player)
	local interior = getElementInterior(player)

	setElementDimension(player, getElementDimension(car))
	setElementInterior(player, getElementInterior(car))
	if warpPedIntoVehicle(player, car, ...) then
		setElementData(player, "realinvehicle", 1, false)
		return true
	else
		setElementDimension(player, dimension)
		setElementInterior(player, interior)
	end
	return false
end

function enterCar(thePlayer, commandName, targetPlayerName, targetVehicle, seat)
	if exports.un_integration:isPlayerTrialAdmin(thePlayer) or exports.un_integration:isPlayerSupporter(thePlayer) then
		targetVehicle = tonumber(targetVehicle)
		seat = tonumber(seat)
		if targetPlayerName and targetVehicle then
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(thePlayer, targetPlayerName)
			if targetPlayer then
				local theVehicle = exports.un_pool:getElement("vehicle", targetVehicle)
				if theVehicle then
					if seat then
						local occupant = getVehicleOccupant(theVehicle, seat)
						if occupant then
							removePedFromVehicle(occupant)
							outputChatBox("Admin " .. getPlayerName(thePlayer):gsub("_", " ") .. " has put " .. targetPlayerName .. " onto your seat.", occupant)
							setElementData(occupant, "realinvehicle", 0, false)
						end

						if warpPedIntoVehicle2(targetPlayer, theVehicle, seat) then

							outputChatBox("Admin " .. getPlayerName(thePlayer):gsub("_", " ") .. " has warped you into this " .. getVehicleName(theVehicle) .. ".", targetPlayer)
							outputChatBox("You warped " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", thePlayer)
						else
							outputChatBox("Unable to warp " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", thePlayer, 255, 0, 0)
						end
					else
						local found = false
						local maxseats = getVehicleMaxPassengers(theVehicle) or 2
						for seat = 0, maxseats  do
							local occupant = getVehicleOccupant(theVehicle, seat)
							if not occupant then
								found = true
								if warpPedIntoVehicle2(targetPlayer, theVehicle, seat) then
									outputChatBox("Admin " .. getPlayerName(thePlayer):gsub("_", " ") .. " has warped you into this " .. getVehicleName(theVehicle) .. ".", targetPlayer)
									outputChatBox("You warped " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", thePlayer)
								else
									outputChatBox("Unable to warp " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", thePlayer, 255, 0, 0)
								end
								break
							end
						end

						if not found then
							outputChatBox("No free seats.", thePlayer, 255, 0, 0)
						end
					end

					addVehicleLogs(targetVehicle, commandName.." "..targetPlayerName, thePlayer)
				else
					outputChatBox("Vehicle not found", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [player] [car ID] [seat]", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("entercar", enterCar, false, false)
addCommandHandler("enterveh", enterCar, false, false)
addCommandHandler("entervehicle", enterCar, false, false)

function switchSeat(thePlayer, commandName, seat)
	if true then
		outputChatBox("This command is temporarily disabled.", thePlayer, 255, 0, 0)
		return false
	end
	if not tonumber(seat) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Seat]" ,thePlayer, 255, 194, 14)
	else
		seat = tonumber(seat)
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then

			local maxSeats = getVehicleMaxPassengers(theVehicle)
			if seat <= maxSeats then
				local occupant = getVehicleOccupant(theVehicle, seat)
				if not occupant then
					if seat == 0 then
						if not getElementData(thePlayer, "license.car.cangetin") and getElementData(theVehicle, "owner") == -2 then -- Fixed your script, pavlov. - Adams
							outputChatBox("(( This DoL Car is for the Driving Test only. ))", thePlayer, 255, 194, 14)
							return false
						end

						local job = getElementData(theVehicle, "job")
						if job ~= 0 then -- Fixed your script, pavlov. - Adams
							outputChatBox("(( This vehicle is for Job System only. ))", thePlayer, 255, 194, 14)
							return false
						end
					end

					warpPedIntoVehicle2(thePlayer, theVehicle, seat)
					outputChatBox("You switched into seat "..seat..".", thePlayer, 0, 255, 0)
				else
					outputChatBox("Unable to switch seats.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Unable to switch seats.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Unable to switch seats.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("switchseat", switchSeat, false, false)

function setOdometer(thePlayer, theCommand, vehicleID, odometer)
	if exports.un_integration:isPlayerTrialAdmin(thePlayer) or exports.un_integration:isPlayerScripter(thePlayer) then
		if not tonumber(vehicleID) or not tonumber(odometer) then
			outputChatBox("KULLANIM: /" .. theCommand .. " [vehicleID] [odometer]", thePlayer, 255, 194, 14)
			--outputChatBox("Remember to add three extra digits at the end. If desired odometer value is 222, write 222000", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.un_pool:getElement("vehicle", vehicleID)
			if theVehicle then
				local oldOdometer = tonumber(getElementData(theVehicle, 'odometer'))
				local actualOdometer = tonumber(odometer) * 1000
				if oldOdometer and dbExec(mysql:getConnection(), "UPDATE vehicles SET odometer='" .. (actualOdometer) .. "' WHERE id = '" .. (vehicleID) .. "'") then
					addVehicleLogs(tonumber(vehicleID), "setodometer " .. odometer .. " (from " .. math.floor(oldOdometer/1000) .. ")", thePlayer)

					setElementData(theVehicle, 'odometer', actualOdometer, false )

					outputChatBox("Vehicle odometer set to " .. odometer .. ".", thePlayer, 0, 255, 0)
					for _, v in pairs(getVehicleOccupants(theVehicle)) do
						triggerClientEvent(v, "realism:distance", theVehicle, actualOdometer)
					end
				end
			end
		end
	end
end
addCommandHandler("setodometer", setOdometer)
addCommandHandler("setmilage", setOdometer)

function damageproofVehicle(thePlayer, theCommand, theFaggot)
	if exports.un_integration:isPlayerSeniorAdmin(thePlayer) then
		if not (theFaggot) then
			outputChatBox("KULLANIM: /" .. theCommand .. " [Target Player Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(thePlayer, theFaggot)
			local targetVehicle = getPedOccupiedVehicle(targetPlayer)
			if not targetVehicle then
				outputChatBox("This player is not in a vehicle.", thePlayer, 255, 0, 0)
				return
			end
			if targetVehicle then
				local vehID = getElementData(targetVehicle, "dbid")
				if isVehicleDamageProof(targetVehicle) then
					dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `bulletproof`='0' WHERE `id`='"..vehID.."'")
					setVehicleDamageProof(targetVehicle, false)
					outputChatBox("This vehicle is no longer damageproof.", targetPlayer)
					outputChatBox("Vehicle ID " .. vehID .. " is no longer damageproof.", thePlayer)
					exports.un_logs:dbLog("ac"..tostring(getElementData(thePlayer, "dbid")), 4, "veh"..vehID, " Removed vehicle damage proof ")
				else
					setVehicleDamageProof(targetVehicle, true)
					dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `bulletproof`='1' WHERE `id`='"..vehID.."'")
					outputChatBox("This vehicle is now damageproof.", targetPlayer)
					outputChatBox("Vehicle ID " .. vehID .. " is now damageproof.", thePlayer)
					exports.un_logs:dbLog("ac"..tostring(getElementData(thePlayer, "dbid")), 4, "veh"..vehID, " Enabled vehicle damage proof ")
				end
			end
		end
	end
end
addCommandHandler("setdamageproof", damageproofVehicle)
addCommandHandler("setbulletproof", damageproofVehicle)
addCommandHandler("sbp", damageproofVehicle)
addCommandHandler("sdp", damageproofVehicle)


-- AUTO CIV RESPAWN & FUEL --
function autoRespawnAllCivVehicles()
	local vehicles = exports.un_pool:getPoolElementsByType("vehicle")
	local counter = 0

	for k, theVehicle in ipairs(vehicles) do
		local dbid = getElementData(theVehicle, "dbid")
		if dbid and dbid > 0 then
			if getElementData(theVehicle, "owner") == -2 then
				local driver = getVehicleOccupant(theVehicle)
				local pass1 = getVehicleOccupant(theVehicle, 1)
				local pass2 = getVehicleOccupant(theVehicle, 2)
				local pass3 = getVehicleOccupant(theVehicle, 3)

				if not pass1 and not pass2 and not pass3 and not driver and not getVehicleTowingVehicle(theVehicle) and #getAttachedElements(theVehicle) == 0 then
					if isElementAttached(theVehicle) then
						detachElements(theVehicle)
					end
				
					respawnTheVehicle(theVehicle)
					setVehicleLocked(theVehicle, false)
					setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
					setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
					setElementData(theVehicle, "vehicle:radio", 0, true)
					setElementData(theVehicle, "fuel", 100, true)
					counter = counter + 1
				end
			end
		end
	end
	--outputChatBox(" ==> Tüm sivil araçlar respawnlanmıştır ve benzinleri doldurulmuştur. <==", getRootElement(), 255, 194, 14)
end
setTimer(autoRespawnAllCivVehicles, 3600000, 0)