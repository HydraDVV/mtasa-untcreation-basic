function walkie(thePlayer, cmd, ...)
	if getElementData(thePlayer, "faction") == 1 or getElementData(thePlayer, "faction") == 78 then
		if not (...) then
			outputChatBox("Kullanım: /t [İleti]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]
			local message = table.concat({...}, " ")
			local username = getPlayerName(thePlayer)
			exports.un_global:sendLocalMeAction(thePlayer, "Telsizinin tuşuna basarak konuşmaya başlar.")
			triggerClientEvent(thePlayer,"walkie.sound",thePlayer)
			for key, player in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul Emniyet Müdürlüğü"))) do
				outputChatBox("#6464FF[!]#8B8B8E (CH: 155) ".. factionRankTitle .. " " .. username:gsub("_", " ") .. " : " .. message, player, 0,0,0,true)
				triggerClientEvent(player,"walkie.sound",player)
			end
			for key, player in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul İl Jandarma Komutanlığı"))) do
				outputChatBox("#6464FF[!]#8B8B8E (CH: 156) ".. factionRankTitle .. " " .. username:gsub("_", " ") .. " : " .. message, player, 0,0,0,true)
				triggerClientEvent(player,"walkie.sound",player)
			end
		end
	end
end
addCommandHandler("telsiz", walkie)
addCommandHandler("t", walkie)

function nearWalkie(thePlayer, cmd, ...)
	if getElementData(thePlayer, "faction") == 1 or getElementData(thePlayer, "faction") == 78 then
		if not (...) then
			outputChatBox("Kullanım: /ykt [İleti]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]
			local message = table.concat({...}, " ")
			local username = getPlayerName(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			exports.un_global:sendLocalMeAction(thePlayer, "Telsizinin tuşuna basarak konuşmaya başlar.")
			triggerClientEvent(thePlayer,"walkie.sound",thePlayer)
			for key, player in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul Emniyet Müdürlüğü"))) do
				local tx, ty, tz = getElementPosition(player)
				if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)<70) then
					outputChatBox("#6464FF[!]#8B8B8E (CH: 155) ".. factionRankTitle .. " " .. username:gsub("_", " ") .. " (Yaka Telsizi): " .. message, player, 0,0,0,true)
					triggerClientEvent(player,"walkie.sound",player)
				end
			end
			for key, player in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul İl Jandarma Komutanlığı"))) do
				local tx, ty, tz = getElementPosition(player)
				if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)<70) then
					outputChatBox("#6464FF[!]#8B8B8E (CH: 156) ".. factionRankTitle .. " " .. username:gsub("_", " ") .. " (Yaka Telsizi): " .. message, player, 0,0,0,true)
					triggerClientEvent(player,"walkie.sound",player)
				end
			end
		end
	end
end
addCommandHandler("yaka", nearWalkie)
addCommandHandler("ykt", nearWalkie)

function panicButton(thePlayer, cmd)
	if getElementData(thePlayer, "faction") == 1 or getElementData(thePlayer, "faction") == 78 then
		local theTeam = getPlayerTeam(thePlayer)
		local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
		local factionRanks = getElementData(theTeam, "ranks")
		local factionRankTitle = factionRanks[factionRank]
		local username = getPlayerName(thePlayer)
		triggerClientEvent(thePlayer,"panic.sound",thePlayer)
		for key, player in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul Emniyet Müdürlüğü"))) do
			outputChatBox("#6464FF[!]#8B8B8E (CH: 155) " .. username:gsub("_", " ") .. " panik butonuna bastı, yönelmeniz bekleniyor.", player, 0,0,0,true)
			triggerClientEvent(player,"panic.sound",player)
		end
		for key, player in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul İl Jandarma Komutanlığı"))) do
			outputChatBox("#6464FF[!]#8B8B8E (CH: 156) " .. username:gsub("_", " ") .. " panik butonuna bastı, yönelmeniz bekleniyor.", player, 0,0,0,true)
			triggerClientEvent(player,"panic.sound",player)
		end
	end
end
addCommandHandler("panik", panicButton)

function operator(thePlayer, cmd, ...)
	if getElementData(thePlayer, "faction") == 1 or getElementData(thePlayer, "faction") == 2 or getElementData(thePlayer, "faction") == 78 then
		if not (...) then
			outputChatBox("Kullanım: /op [İleti]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]
			local message = table.concat({...}, " ")
			local username = getPlayerName(thePlayer)
			exports.un_global:sendLocalMeAction(thePlayer, "Telsizinin tuşuna basarak konuşmaya başlar.")
			triggerClientEvent(thePlayer,"walkie.sound",thePlayer)
			for key, player in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul Emniyet Müdürlüğü"))) do
				outputChatBox("#6464FF[!]#8B8B8E (CH: 155) ".. factionRankTitle .. " " .. username:gsub("_", " ") .. " : " .. message, player, 0,0,0,true)
				triggerClientEvent(player,"walkie.sound",player)
			end
			for key, player in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul İl Jandarma Komutanlığı"))) do
				outputChatBox("#6464FF[!]#8B8B8E (CH: 156) ".. factionRankTitle .. " " .. username:gsub("_", " ") .. " : " .. message, player, 0,0,0,true)
				triggerClientEvent(player,"walkie.sound",player)
			end
			for key, player in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul Devlet Hastanesi"))) do
				outputChatBox("#5F5F5F[!]#D55858 (CH: 112) ".. factionRankTitle .. " " .. username:gsub("_", " ") .. ": " .. message, player, 0,0,0,true)
				triggerClientEvent(player,"walkie.sound",player)
			end
		end
	end
end
addCommandHandler("operator", operator)
addCommandHandler("op", operator)