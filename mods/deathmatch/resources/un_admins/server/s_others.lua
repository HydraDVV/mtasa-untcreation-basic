local mysql = exports.un_mysql

function getKey(thePlayer, commandName)
	if exports.un_integration:isPlayerHeadAdmin(thePlayer) then
		local adminName = getPlayerName(thePlayer):gsub(" ", "_")
		local veh = getPedOccupiedVehicle(thePlayer)
		if veh then
			local vehID = getElementData(veh, "dbid")
			
			givePlayerItem(thePlayer, "giveitem" , adminName, "3" , tostring(vehID))
			
			return true
		else
			local intID = getElementDimension(thePlayer)
			if intID then
				local foundIntID = false
				local keyType = false
				local possibleInteriors = getElementsByType("interior")
				for _, theInterior in pairs (possibleInteriors) do
					if getElementData(theInterior, "dbid") == intID then
						local intType = getElementData(theInterior, "status")[1] 
						if intType == 0 or intType == 2 or intType == 3 then
							keyType = 4 --Yellow key
						else
							keyType = 5 -- Pink key
						end
						foundIntID = intID
						break
					end
				end
				
				if foundIntID and keyType then
					givePlayerItem(thePlayer, "giveitem" , adminName, tostring(keyType) , tostring(foundIntID))
					
					return true
				else
					outputChatBox(" You're not in any vehicle or possible interior.", thePlayer, 255,0 ,0 )
					return false
				end
			end
		end
	end
end
addCommandHandler("getkey", getKey, false, false)

function generateFakeIdentity(player, cmd)
	local birlik = getElementData(player, "faction")
	if birlik == 4 then
		if getElementData(player, "fakename") then
			exports.un_anticheat:changeProtectedElementDataEx(player, "fakename", false, true)
			exports.un_notification:create(player,"Sahte kimliğini sildin.", "error")
			return false
		end
		
		local name = exports.un_global:createRandomMaleName()
		
		exports.un_anticheat:changeProtectedElementDataEx(player, "fakename", name, true)
		exports.un_notification:create(player,"Başarıyla sahte kimliğini aktif ettin.", "success")
		triggerEvent("fakemyid", player)
	end
end
addCommandHandler("sahtekimlik", generateFakeIdentity, false, false)

function setSvPassword(thePlayer, commandName, password)
	if exports.un_integration:isPlayerTrialAdmin(thePlayer) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Password without spaces, empty to remove pw] - Set/remove server's password", thePlayer, 255, 194, 14)
		if password and string.len(password) > 0 then
			if setServerPassword(password) then
				exports.un_global:sendMessageToStaff("[SYSTEM] "..exports.un_global:getPlayerFullIdentity(thePlayer).." has set server's password to '"..password.."'.", true)
			end
		else
			if setServerPassword('') then
				exports.un_global:sendMessageToStaff("[SYSTEM] "..exports.un_global:getPlayerFullIdentity(thePlayer).." has removed server's password.", true)
			end
		end
	end
end
addCommandHandler("setserverpassword", setSvPassword, false, false)
addCommandHandler("setserverpw", setSvPassword, false, false)

function sehreGonder(thePlayer, cmd, target)
	if exports.un_integration:isPlayerSupporter(thePlayer) or exports.un_integration:isPlayerTrialAdmin(thePlayer) then
		if not target then
			outputChatBox("| Komut |: /" .. cmd .. " [Oyuncunun Adı]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick( thePlayer, target )
			if isPedInVehicle(targetPlayer) then
				outputChatBox("[!] #f0f0f0Kişi araçta olduğu için işlem iptal edildi.", thePlayer, 0, 255, 0, true)
			return end
			setElementPosition(targetPlayer, 1539.7998046875, -1722.1484375, 13.55456161499)
			setElementInterior(targetPlayer, 0)
			setElementDimension(targetPlayer, 0)
			outputChatBox("[!] #f0f0f0Başarıyla şehre gönderildiniz!", targetPlayer, 0, 255, 0, true)
			outputChatBox("[!] #f0f0f0Kişi başarıyla şehre gönderildi!", thePlayer, 0, 255, 0, true)
			exports.un_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili "..targetPlayerName.." isimli oyuncuyu şehre ışınladı")
		end
	end
end
addCommandHandler("sehre", sehreGonder)

function AdminLoungeTeleport(sourcePlayer)
	if (exports.un_integration:isPlayerDeveloper(sourcePlayer) or exports.un_integration:isPlayerSupporter(sourcePlayer)) then
		setElementPosition(sourcePlayer, 275.761475, -2052.245605, 3085.291962 )
		setPedGravity(sourcePlayer, 0.008)
		setElementDimension(sourcePlayer, 0)
		setElementInterior(sourcePlayer, 0)
		
	end
end

addCommandHandler("adminlounge", AdminLoungeTeleport)
addCommandHandler("gmlounge", AdminLoungeTeleport)

function setDonator(thePlayer, commandName, targetPlayerName, etiketLevel)
local targetName = exports.un_global:getPlayerFullIdentity(thePlayer, 1)
	if exports.un_integration:isPlayerDeveloper(thePlayer) then
		if not targetPlayerName or not tonumber(etiketLevel)  then
			outputChatBox("Kullanım: #ffffff/" .. commandName .. " [İsim/ID] [VİP]", thePlayer, 255, 194, 14, true)
		else
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if not targetPlayer then
				
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Player is not logged in.", thePlayer, 255, 0, 0 )
			else
				dbExec(mysql:getConnection(),"UPDATE `characters` SET `donator`="..etiketLevel.." WHERE `id`='"..getElementData(targetPlayer, "dbid").."'")
				setElementData(targetPlayer, "donator", tonumber(etiketLevel))
				outputChatBox("[!]#ffffff".. targetPlayerName .. " adlı kişinin donator seviyesini " .. etiketLevel .. " yaptın.", thePlayer, 0, 255, 0, true)
			    outputChatBox("[!]#ffffff"..targetName.." tarafından donator seviyeniz " .. etiketLevel .. " yapıldı.", targetPlayer, 0, 255, 0,true)
			
			end
		end
	else
	    outputChatBox( "[!]#ffffffBu işlemi yapmaya yetkiniz bulunmamaktadır.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("donatorver", setDonator)

function setetiket(thePlayer, commandName, targetPlayerName, etiketLevel)
local targetName = exports.un_global:getPlayerFullIdentity(thePlayer, 1)
	if exports.un_integration:isPlayerDeveloper(thePlayer) then
		if not targetPlayerName or not tonumber(etiketLevel)  then
			outputChatBox("Kullanım: #ffffff/" .. commandName .. " [İsim/ID] [VİP]", thePlayer, 255, 194, 14, true)
		else
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if not targetPlayer then
				
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Player is not logged in.", thePlayer, 255, 0, 0 )
			else
				dbExec(mysql:getConnection(),"UPDATE `characters` SET `etiket`="..etiketLevel.." WHERE `id`='"..getElementData(targetPlayer, "dbid").."'")
				setElementData(targetPlayer, "etiket", tonumber(etiketLevel))
				outputChatBox("[!]#ffffff".. targetPlayerName .. " adlı kişinin etiket seviyesini " .. etiketLevel .. " yaptın.", thePlayer, 0, 255, 0, true)
			    outputChatBox("[!]#ffffff"..targetName.." tarafından etiket seviyeniz " .. etiketLevel .. " yapıldı.", targetPlayer, 0, 255, 0,true)
			
			end
		end
	else
	    outputChatBox( "[!]#ffffffBu işlemi yapmaya yetkiniz bulunmamaktadır.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("etiketver", setetiket)

function giveuyk(thePlayer, cmd, komut, targetPlayerName)

    if not (exports.un_integration:isPlayerDeveloper(thePlayer)) then return end
    
    local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(thePlayer, targetPlayerName)
    local targetName = exports.un_global:getPlayerFullIdentity(thePlayer, 1)

    if not komut then
        outputChatBox("[!]#ffffff /uyk [Ver] [Al] [ID]", thePlayer, 0, 255, 0, true)
    return end

    if not targetPlayerName then
        outputChatBox("[!]#ffffff /uyk [Ver] [Al] [ID]", thePlayer, 0, 255, 0, true)
    return end

    if komut == "ver" then
        dbExec(mysql:getConnection(),"UPDATE `accounts` SET `uyk`='1' WHERE `id`='"..getElementData(targetPlayer, "account:id").."'")
		setElementData(targetPlayer, "uyk", 1)
        outputChatBox("[!]#ffffff".. targetPlayerName .. " adlı Kişiye uyk yetkisi verildi.", thePlayer, 0, 255, 0, true)
	    outputChatBox("[!]#ffffff"..targetName.." tarafından size uyk yetkisi verildi.", targetPlayer, 0, 255, 0,true)
    end

    if komut == "al" then
        dbExec(mysql:getConnection(),"UPDATE `accounts` SET `uyk`='0' WHERE `id`='"..getElementData(targetPlayer, "account:id").."'")
		setElementData(targetPlayer, "uyk", 0)
		setElementData(targetPlayer, "uyk_duty", false)
        outputChatBox("[!]#ffffff".. targetPlayerName .. " adlı kişinin uyk yetkisini aldın.", thePlayer, 0, 255, 0, true)
	    outputChatBox("[!]#ffffff"..targetName.." tarafından uyk yetkin alındı.", targetPlayer, 0, 255, 0,true)
    end
end
addCommandHandler("uyk", giveuyk)

function youtuberd(thePlayer, cmd, komut, targetPlayerName)

    if not (exports.un_integration:isPlayerDeveloper(thePlayer)) then return end
    
    local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick( thePlayer, targetPlayerName )
    local targetName = exports.un_global:getPlayerFullIdentity(thePlayer, 1)

    if not komut then
        outputChatBox("[!]#ffffff /youtuber [Ver] [Al] [ID]", thePlayer, 0, 255, 0, true)
    return end

    if not targetPlayerName then
        outputChatBox("[!]#ffffff /youtuber [Ver] [Al] [ID]", thePlayer, 0, 255, 0, true)
    return end

    if komut == "ver" then
        dbExec(mysql:getConnection(),"UPDATE `characters` SET `youtuber`='1' WHERE `id`='"..getElementData(targetPlayer, "dbid").."'")
		setElementData(targetPlayer, "youtuber", 1)
        outputChatBox("[!]#ffffff".. targetPlayerName .. " Adlı Kişiye Youtuber Yetkisi Verildi.", thePlayer, 0, 255, 0, true)
	    outputChatBox("[!]#ffffff"..targetName.." Tarafından size Youtuber yetkisi verildi.", targetPlayer, 0, 255, 0,true)
    end

    if komut == "al" then
        dbExec(mysql:getConnection(),"UPDATE `characters` SET `youtuber`='0' WHERE `id`='"..getElementData(targetPlayer, "dbid").."'")
		setElementData(targetPlayer, "youtuber", 0)
        outputChatBox("[!]#ffffff".. targetPlayerName .. " adlı kişinin Youtuber yetkisini aldın.", thePlayer, 0, 255, 0, true)
	    outputChatBox("[!]#ffffff"..targetName.." tarafından Youtuber yetkin alındı.", targetPlayer, 0, 255, 0,true)
    end
end
addCommandHandler("youtuber", youtuberd)

function rpplus(thePlayer, cmd, komut, targetPlayerName)

    if not (exports.un_integration:isPlayerDeveloper(thePlayer)) then return end
    
    local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick( thePlayer, targetPlayerName )
    local targetName = exports.un_global:getPlayerFullIdentity(thePlayer, 1)

    if not komut then
        outputChatBox("[!]#ffffff /rp+ [Ver] [Al] [ID]", thePlayer, 0, 255, 0, true)
    return end

    if not targetPlayerName then
        outputChatBox("[!]#ffffff /rp+ [Ver] [Al] [ID]", thePlayer, 0, 255, 0, true)
    return end

    if komut == "ver" then
        dbExec(mysql:getConnection(),"UPDATE `characters` SET `rplus`='1' WHERE `id`='"..getElementData(targetPlayer, "dbid").."'")
		setElementData(targetPlayer, "rplus", 1)
        outputChatBox("[!]#ffffff".. targetPlayerName .. " Adlı Kişiye rplus Yetkisi Verildi.", thePlayer, 0, 255, 0, true)
	    outputChatBox("[!]#ffffff"..targetName.." Tarafından size rplus yetkisi verildi.", targetPlayer, 0, 255, 0,true)
    end

    if komut == "al" then
        dbExec(mysql:getConnection(),"UPDATE `characters` SET `rplus`='0' WHERE `id`='"..getElementData(targetPlayer, "dbid").."'")
		setElementData(targetPlayer, "rplus", 0)
        outputChatBox("[!]#ffffff".. targetPlayerName .. " adlı kişinin rplus yetkisini aldın.", thePlayer, 0, 255, 0, true)
	    outputChatBox("[!]#ffffff"..targetName.." tarafından rplus yetkin alındı.", targetPlayer, 0, 255, 0,true)
    end
end
addCommandHandler("rp+", rpplus)

function muteVoice(thePlayer, commandName, targetPlayer, ...)
	if exports.un_integration:isPlayerTrialAdmin(thePlayer) or exports.un_integration:isPlayerSupporter(thePlayer) then
	    local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(thePlayer, targetPlayer)	
		if targetPlayer then
			if not getElementData(targetPlayer, "voicemute") then 
			exports['un_admins']:addAdminHistory(targetPlayer, thePlayer, "Susturma Cezası", 8, 1)
			setElementData(targetPlayer, "voicemute", true)
			exports.un_notification:create(thePlayer,""..getPlayerName(targetPlayer).." adlı oyuncuyu susturdunuz.", "success")
			exports.un_notification:create(targetPlayer,""..getPlayerName(thePlayer).." isimli yetkili sizi susturdu.", "success")
			exports.un_global:sendMessageToAdmins("AdmCMD: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun mikrofonunu susturdu.")
			else
			setElementData(targetPlayer, "voicemute", nil)		
			exports.un_notification:create(thePlayer,""..getPlayerName(targetPlayer).." adlı oyuncuyunun susturmasını kaldırdınız.", "success")
			exports.un_notification:create(targetPlayer,""..getPlayerName(targetPlayer).." isimli yetkili susturma cezanızı kaldırdı. Bir dahakine dikkat edin.", "success")
			exports.un_global:sendMessageToAdmins("AdmCMD: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun mikrofonunun susturmasını kaldırdı.")			
			end
		else
			exports.un_notification:create(thePlayer,"Kullanımı: /voicemute [Karakter Adı & ID]", "error")
		end
	end
end
addCommandHandler("voicemute", muteVoice)

function setCountry(thePlayer, commandName, targetPlayerName)
local targetName = exports.un_global:getPlayerFullIdentity(thePlayer, 1)
	if exports.un_integration:isPlayerTrialAdmin(thePlayer) then
		if not targetPlayerName then
			outputChatBox("Kullanım: #ffffff/" .. commandName .. " [İsim/ID]", thePlayer, 255, 194, 14, true)
		else
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if not targetPlayer then
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Player is not logged in.", thePlayer, 255, 0, 0 )
			else
				dbExec(mysql:getConnection(),"UPDATE `characters` SET `country`='0' WHERE `id`='"..getElementData(targetPlayer, "dbid").."'")
				setElementData(targetPlayer, "country", tonumber(0))
			end
		end
	else
	    outputChatBox( "[!]#ffffffBu işlemi yapmaya yetkiniz bulunmamaktadır.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("ulkesifirla", setCountry)