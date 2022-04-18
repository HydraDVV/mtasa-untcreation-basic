-- Misc

local function sortTable( a, b )
	if b[2] < a[2] then
		return true
	end

	if b[2] == a[2] and b[4] > a[4] then
		return true
	end

	return false
end

local function getPlayerScripterRank( player )
	if exports.un_integration:isPlayerLeadScripter( player ) then
		return "Scripter"
	elseif exports.un_integration:isPlayerScripter( player ) then
		return "Deneme Scripter"
	elseif exports.un_integration:isPlayerTester( player ) then
		return "Deneme"
	else
		return ""
	end
end

local function getPlayerSupportRank( player )
	if exports.un_integration:isPlayerSupporter( player ) then
		return "Rehber"
	else
		return ""
	end
end

function showStaff( thePlayer, commandName )
	local logged = getElementData(thePlayer, "loggedin")
	local info = {}
	local isOverlayDisabled = getElementData(thePlayer, "hud:isOverlayDisabled")

	if(logged==1) then
		local players = exports.un_global:getAdmins()
		local counter = 0

		admins = {}

		if not isOverlayDisabled then
			table.insert(info, {"Üst Yönetim Kurulu", 255, 194, 14, 255, 1, "title"})
			table.insert(info, {""})
		end

		for k, arrayPlayer in ipairs(players) do
			local hiddenAdmin = getElementData(arrayPlayer, "hiddenadmin")
			local logged = getElementData(arrayPlayer, "loggedin")

			if logged == 1 then
				if getElementData( arrayPlayer, "admin_level" ) > 0 and getElementData(arrayPlayer, "uyk") == 1 then
					admins[ #admins + 1 ] = { arrayPlayer, getElementData( arrayPlayer, "admin_level" ), getElementData( arrayPlayer, "duty_admin" ), exports.un_global:getPlayerName( arrayPlayer ) }
				end
			end
		end

		table.sort( admins, sortTable )

		for k, v in ipairs(admins) do
			arrayPlayer = v[1]
			local adminTitle = exports.un_global:getPlayerAdminTitle(arrayPlayer)
			local hiddenAdmin = getElementData(arrayPlayer, "hiddenadmin")
			if hiddenAdmin == 0 or exports.un_integration:isPlayerTrialAdmin(arrayPlayer) then
				v[4] = v[4] .. " (" .. tostring(getElementData(arrayPlayer, "account:username")) .. ")"

				if(v[3]==1)then
					if tonumber(getElementData( arrayPlayer, "admin_level" )) > 1 or getElementData(arrayPlayer, "uyk_duty") == 1 and tonumber(getElementData( arrayPlayer, "admin_level" )) < 7 then
						table.insert(info, {"    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." - Görevde", 0, 127, 255, 255, 1, "default"})
					else
						table.insert(info, {"    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." - Görevde", 0, 255, 0, 200, 1, "default"})
					end
				else
					if isOverlayDisabled then
						outputChatBox("    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." Görevde Değil", thePlayer, 100, 100, 100)
					else
						table.insert(info, {"    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").."Görevde Değil", 200, 200, 200, 200, 1, "default"})
					end
				end	
				
			end
		end

		if #admins == 0 then
			if isOverlayDisabled then
				outputChatBox("   Aktif yetkili yok.", thePlayer)
			else
				table.insert(info, {"    Aktif yetkili yok.", 255, 255, 255, 200, 1, "default"})
			end
		end
	end
	
	if not isOverlayDisabled then
		table.insert(info, {" ", 100, 100, 100, 255, 1, "default"})
	end

	if(logged==1) then
		local players = exports.un_global:getAdmins()
		local counter = 0

		admins = {}

		if not isOverlayDisabled then
			table.insert(info, {"Yetkili Takımı", 255, 194, 14, 255, 1, "title"})
			table.insert(info, {""})
		end

		for k, arrayPlayer in ipairs(players) do
			local hiddenAdmin = getElementData(arrayPlayer, "hiddenadmin")
			local logged = getElementData(arrayPlayer, "loggedin")

			if logged == 1 then
				if getElementData( arrayPlayer, "admin_level" ) > 0 and getElementData(arrayPlayer, "uyk") == 0 then
					admins[#admins + 1] = { arrayPlayer, getElementData( arrayPlayer, "admin_level" ), getElementData( arrayPlayer, "duty_admin" ), exports.un_global:getPlayerName( arrayPlayer ) }
				end
			end
		end

		table.sort( admins, sortTable )

		for k, v in ipairs(admins) do
			arrayPlayer = v[1]
			local adminTitle = exports.un_global:getPlayerAdminTitle(arrayPlayer)
			local hiddenAdmin = getElementData(arrayPlayer, "hiddenadmin")
			if hiddenAdmin == 0 or exports.un_integration:isPlayerTrialAdmin(arrayPlayer) then
				v[4] = v[4] .. " (" .. tostring(getElementData(arrayPlayer, "account:username")) .. ")"

				if(v[3]==1)then
					if isOverlayDisabled then
						outputChatBox("    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." Görevde", thePlayer, 0, 200, 10)
					else
						table.insert(info, {"    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." Görevde", 0, 255, 0, 200, 1, "default"})
					end
				else
					if isOverlayDisabled then
						outputChatBox("    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." Görevde Değil", thePlayer, 100, 100, 100)
					else
						table.insert(info, {"    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." Görevde Değil", 200, 200, 200, 200, 1, "default"})
					end
				end
			end
		end

		if #admins == 0 then
			if isOverlayDisabled then
				outputChatBox("    Aktif yetkili yok.", thePlayer)
			else
				table.insert(info, {"    Aktif yetkili yok.", 255, 255, 255, 200, 1, "default"})
			end
		end
	end

	if not isOverlayDisabled then
		table.insert(info, {" ", 100, 100, 100, 255, 1, "default"})
	end

	--GMS--
	if(logged==1) then
		local players = exports.un_global:getGameMasters()
		local counter = 0

		admins = {}
		if isOverlayDisabled then
			outputChatBox("", thePlayer, 255, 194, 14)
		else
			table.insert(info, {"Rehber Takımı", 255, 194, 14, 255, 1, "title"})
			table.insert(info, {""})
		end
		for k, arrayPlayer in ipairs(players) do
			local logged = getElementData(arrayPlayer, "loggedin")
			if logged == 1 then
				if exports.un_integration:isPlayerSupporter(arrayPlayer) then
					admins[ #admins + 1 ] = { arrayPlayer, getElementData( arrayPlayer, "account:gmlevel" ), getElementData( arrayPlayer, "duty_supporter" ), exports.un_global:getPlayerName( arrayPlayer ) }
				end
			end
		end

		for k, v in ipairs(admins) do
			arrayPlayer = v[1]
			local adminTitle = getPlayerSupportRank(arrayPlayer)

			v[4] = v[4] .. " (" .. tostring(getElementData(arrayPlayer, "account:username")) .. ")"

			if(v[3] == 1)then
				if isOverlayDisabled then
					outputChatBox("    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." - Görevde", thePlayer, 0, 200, 10)
				else
					table.insert(info, {"    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." - Görevde", 0, 255, 0, 200, 1, "default"})
				end
			else
				if isOverlayDisabled then
					outputChatBox("    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." - Görevde Değil", thePlayer, 100, 100, 100)
				else
					table.insert(info, {"    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." - Görevde Değil", 200, 200, 200, 200, 1, "default"})
				end
			end
		end

		if #admins == 0 then
			if not isOverlayDisabled then
				table.insert(info, {"    Aktif rehber yok.", 255, 255, 255, 200, 1, "default"})
				table.insert(info, {"", 255, 255, 255, 200, 1, "default"})
			end
		end

		for k, arrayPlayer in ipairs(players) do
			local logged = getElementData(arrayPlayer, "loggedin")
			if logged == 1 then
				if exports.un_integration:isPlayerScripter(arrayPlayer) then
					local hiddenAdmin = getElementData(arrayPlayer, "hiddenadmin")
					local adminTitle = getPlayerScripterRank( arrayPlayer )
					local stuffToPrint
					if (hiddenAdmin == 1) then
						stuffToPrint = "    (Hidden) "..tostring(adminTitle).." "..exports.un_global:getPlayerName(arrayPlayer).." ("..getElementData(arrayPlayer, "account:username")..")"
					else
						stuffToPrint = "    "..tostring(adminTitle).." "..exports.un_global:getPlayerName(arrayPlayer).." ("..getElementData(arrayPlayer, "account:username")..")"
					end
					if (hiddenAdmin == 0 or ( exports.un_integration:isPlayerTrialAdmin(thePlayer) or exports.un_integration:isPlayerScripter(thePlayer) ) ) then
						local r, g, b = 0, 255, 0 --hud colour
						local cR, cG, cB = 0, 200, 10 --chatbox colour
						if(hiddenAdmin == 1) then
							r, g, b = 200, 200, 200
							cR, cG, cB = 100, 100, 100
						end
						if isOverlayDisabled then
							outputChatBox(stuffToPrint, thePlayer, cR, cG, cB)
						else
							table.insert(info, {stuffToPrint, r, g, b, 255, 1, "default"})
						end
						counter = counter + 1
					end
				end
			end
		end

		if counter == 0 then
			if not isOverlayDisabled then
				table.insert(info, {"", 255, 255, 255, 255, 1, "default"})
				table.insert(info, {"", 255, 255, 255, 255, 1, "default"})
				table.insert(info, {"", 255, 255, 255, 255, 1, "default"})
				table.insert(info, {"                                            "})
			end
		end

	end

	if logged == 1 then
		if not isOverlayDisabled then
			exports.un_hud:sendTopRightNotification(thePlayer, info, 350)
		end
	end
end
addCommandHandler("admin", showStaff, false, false)
addCommandHandler("admins", showStaff, false, false)

function toggleOverlay(thePlayer, commandName)
	if getElementData(thePlayer, "hud:isOverlayDisabled") then
		setElementData(thePlayer, "hud:isOverlayDisabled", false)
		outputChatBox("You enabled overlay menus.",thePlayer)
	else
		setElementData(thePlayer, "hud:isOverlayDisabled", true)
		outputChatBox("You disabled overlay menus.", thePlayer)
	end
end
addCommandHandler("toggleOverlay", toggleOverlay, false, false)
addCommandHandler("togOverlay", toggleOverlay, false, false)