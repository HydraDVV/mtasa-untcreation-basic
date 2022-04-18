local mysql = exports.un_mysql
vipPlayers = {}

addEventHandler("onResourceStart", resourceRoot, function()
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					loadVIP(row.char_id)
				end
			end
		end,
	mysql:getConnection(), "SELECT `char_id` FROM `vipPlayers`")
end)

addEventHandler("onResourceStop", resourceRoot, function()
	for _, player in pairs(getElementsByType("player")) do
		local charID = tonumber(getElementData(player, "dbid"))
		if charID then
			saveVIP(charID)
		end
	end
end)

addEventHandler("onPlayerQuit", root, function()
	local charID = getElementData(source, "dbid")
	if not charID then return false end
	saveVIP(charID)
end)

function loadVIP(charID)
	local charID = tonumber(charID)
	if not charID then return false end
	
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					local vipType = tonumber(row["vip_type"]) or 0
					local endTick = tonumber(row["vip_end_tick"]) or 0
					if vipType > 0 then
						vipPlayers[charID] = {}
						vipPlayers[charID].type = vipType
						vipPlayers[charID].endTick = endTick
						local targetPlayer = exports.un_global:getPlayerFromCharacterID(charID)
						if targetPlayer then
							setElementData(targetPlayer, "vipver", vipType)
						end
					end
				end
			end
		end,
	mysql:getConnection(), "SELECT `vip_type`, `vip_end_tick` FROM `vipPlayers` WHERE char_id='"..charID.."'")
end

function saveVIP(charID)
	local charID = tonumber(charID)
	if not charID then return false end
	if not vipPlayers[charID] then return false end
	
	local success = dbExec(mysql:getConnection(), "UPDATE `vipPlayers` SET vip_end_tick='"..(vipPlayers[charID].endTick).."' WHERE char_id="..charID.." LIMIT 1")
	if not success then
		return
	end
end

function removeVIP(charID)
	if not vipPlayers[charID] then return false end	
	local query = dbExec(mysql:getConnection(), "DELETE FROM `vipPlayers` WHERE char_id="..charID.." LIMIT 1")
	if query then
		local targetPlayer = exports.un_global:getPlayerFromCharacterID(charID)
		if targetPlayer then
			setElementData(targetPlayer, "vipver", 0)
			outputChatBox("[-] #ffffffVIP süreniz sona erdi. Yeni VIP satın almak için ( /market )", targetPlayer, 255, 109, 51, true)
		end
		vipPlayers[charID] = nil
		return true
	end
	return false
end

function checkExpireTime()
	for charID, data in pairs(vipPlayers) do
		if (charID and data) then
			if vipPlayers[charID] then
				if vipPlayers[charID].endTick and vipPlayers[charID].endTick <= 0 then

					local success = removeVIP(charID)
					if success then
					end

				elseif vipPlayers[charID].endTick and vipPlayers[charID].endTick > 0 then

					vipPlayers[charID].endTick = math.max(vipPlayers[charID].endTick - (60 * 1000), 0)
					saveVIP(charID)
					
					if vipPlayers[charID].endTick == 0 then
						local success = removeVIP(charID)
						if success then
						end
					end

				end
			end
		end
	end
end
setTimer(checkExpireTime, 60 * 1000, 0)

addCommandHandler("vipver", function(thePlayer, cmdName, idOrNick, vipRank, days)
	if exports.un_integration:isPlayerHeadAdmin(thePlayer) then
		if (not idOrNick or not tonumber(vipRank) or not tonumber(days) or (tonumber(vipRank) < 0 or tonumber(vipRank) > 4)) then
			outputChatBox("► #ffffffKullanım: /"..cmdName.." <oyuncu id> <vip rank (1-2-3-4)> <gün>", thePlayer, 250, 85, 85, true)
		else
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(thePlayer, idOrNick)
			if targetPlayer then
				local charID = tonumber(getElementData(targetPlayer, "dbid"))
				if not charID then
					return outputChatBox("► #ffffffOyuncu bulunamadı.", thePlayer, 250, 85, 85, true)
				end
				
				local endTick = math.max(days, 1) * 24 * 60 * 60 * 1000
				if not isPlayerVIP(charID) then
					local id = SmallestID()
					
					local success = dbExec(mysql:getConnection(), "INSERT INTO `vipPlayers` (`id`, `char_id`, `karakterIsmi`, `vip_type`, `vip_end_tick`) VALUES ('"..id.."', '"..charID.."', '"..getPlayerName(targetPlayer).."', '"..(vipRank).."', '"..(endTick).."')") or false
					if not success then
						return
					end
				
					outputChatBox("► #ffffff"..targetPlayerName.." isimli oyuncuya başarıyla "..days.." günlük VIP verdiniz.", thePlayer, 0, 255, 0, true)
					outputChatBox("► #ffffff"..getPlayerName(thePlayer).." isimli yetkili size "..days.." günlük VIP ["..vipRank.."] verdi.", targetPlayer, 0, 255, 0, true)
				
					--exports.un_global:updateNametagColor(targetPlayer)
					loadVIP(charID)
				else
					local success = dbExec(mysql:getConnection(), "UPDATE `vipPlayers` SET vip_end_tick= vip_end_tick + "..endTick.." WHERE char_id="..charID.." and vip_type="..vipRank.." LIMIT 1")
					if not success then
						return
					end
					
					outputChatBox("► #ffffff"..targetPlayerName.." isimli oyuncunun VIP süresine "..days.." gün eklediniz.", thePlayer, 0, 255, 0, true)
					outputChatBox("► #ffffff"..getPlayerName(thePlayer).." isimli yetkili VIP ["..vipRank.."] sürenizi "..days.." gün uzattı.", targetPlayer, 0, 255, 0, true)
					
					loadVIP(charID)
				end
			else
				outputChatBox("► #ffffffOyuncu bulunamadı.", thePlayer, 250, 85, 85, true)
			end
		end
	else 
		outputChatBox("► #ffffffBu özelliği kullanabilmek için yeterli yetkiniz yok.", thePlayer, 250, 85, 85, true)
	end
end)

addCommandHandler("vipal", function(thePlayer, cmdName, idOrNick)
	if exports.un_integration:isPlayerHeadAdmin(thePlayer) then
		if (not idOrNick) then
			outputChatBox("► #ffffffKullanım: /"..cmdName.." <oyuncu id/isim>", thePlayer, 250, 85, 85, true)
		else
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(thePlayer, idOrNick)
			if targetPlayer then
				local charID = tonumber(getElementData(targetPlayer, "dbid"))
				if not charID then
					return outputChatBox("► #ffffffOyuncu bulunamadı.", thePlayer, 250, 85, 85, true)
				end
				
				if isPlayerVIP(charID) then
					local success = removeVIP(charID)
					if success then
						outputChatBox("► #ffffff"..targetPlayerName.." adlı oyuncunun VIP üyeliğini aldınız.", thePlayer, 0, 255, 0, true)
					end
				else
					outputChatBox("► #ffffffOyuncunun VIP üyeliği yok.", thePlayer, 250, 85, 85, true)
				end
			else
				outputChatBox("► #ffffffOyuncu bulunamadı.", thePlayer, 250, 85, 85, true)
			end
		end
	else 
		outputChatBox("► #ffffffBu özelliği kullanabilmek için yeterli yetkiniz yok.", thePlayer, 250, 85, 85, true)
	end
end)

addCommandHandler("vipsure", function(thePlayer, cmd, id)
	if id then
	local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(thePlayer, id)
	local id = getElementData(targetPlayer, "dbid")
		if (exports.un_integration:isPlayerTrialAdmin(thePlayer)) then
			if vipPlayers[id] then
				local vipType = vipPlayers[id].type
				local remaining = vipPlayers[id].endTick
				local remainingInfo = secondsToTimeDesc(remaining/1000)
	
				return outputChatBox("► #ffffff"..getPlayerName(targetPlayer).." adlı karakterin kalan VIP ["..vipType.."]süresi: "..remainingInfo, thePlayer, 235, 199, 82, true)
			end
			return outputChatBox("► #ffffff"..getPlayerName(targetPlayer).." adlu karakterin VIP üyeliği bulunmamaktadır.", thePlayer, 250, 85, 85, true)
		end
	end

	local charID = getElementData(thePlayer, "dbid")
	if not charID then return false end

	if vipPlayers[charID] then
		local vipType = vipPlayers[charID].type
		local remaining = vipPlayers[charID].endTick
		local remainingInfo = secondsToTimeDesc(remaining/1000)

		outputChatBox("[-] #ffffffKalan VIP ["..vipType.."] süreniz: "..remainingInfo, thePlayer, 235, 199, 82, true)
		outputChatBox("► #ffffffVIP Seviyeniz: "..vipType.."", thePlayer, 230, 118, 245, true)
		outputChatBox("► #ffffffKalan VIP Süreniz: "..remainingInfo, thePlayer, 70, 184, 161, true)
	else
		outputChatBox("► #ffffffVIP sürenizi görebilmek için öncelikle /market'ten VIP satın almalısınız.", thePlayer, 250, 85, 85, true)
	end
end)

function addVIP(targetPlayer, vipRank, days)
	if targetPlayer and vipRank and days then
		local charID = tonumber(getElementData(targetPlayer, "dbid"))
		if not charID then
			return false
		end
		
		local endTick = math.max(days, 1) * 24 * 60 * 60 * 1000
		if not isPlayerVIP(charID) then
			local id = SmallestID()
			local success = dbExec(mysql:getConnection(), "INSERT INTO `vipPlayers` (`id`, `char_id`, `karakterIsmi`, `vip_type`, `vip_end_tick`) VALUES ('"..id.."', '"..charID.."', '"..getPlayerName(targetPlayer).."', '"..(vipRank).."', '"..(endTick).."')") or false
			if not success then
				return
			end
			loadVIP(charID)
		else
		
			local success = dbExec(mysql:getConnection(), "UPDATE `vipPlayers` SET vip_end_tick= vip_end_tick + "..endTick.." WHERE char_id="..charID.." and vip_type="..vipRank.." LIMIT 1")
			if not success then
				return
			end
			
			loadVIP(charID)
		end
	end
end