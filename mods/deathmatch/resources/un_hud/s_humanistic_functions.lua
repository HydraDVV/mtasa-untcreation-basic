local mysql = exports.un_mysql
addEvent("kaydet:dakikavesaat", true)
function veriKaydetDakikaveSaat(client)
	local minutesplayed = getElementData(client, "minutesPlayed")
	local hoursplayed = getElementData(client, "hoursplayed")
	local id = getElementData(client, "dbid") -- account:character:id
	if id then
		dbExec(mysql:getConnection(),"UPDATE `characters` SET `minutesPlayed`='"..minutesplayed.."' WHERE `id`='"..id.."' ")
		dbExec(mysql:getConnection(),"UPDATE `characters` SET `hoursplayed`='"..hoursplayed.."' WHERE `id`='"..id.."' ")
	end
end
addEventHandler("kaydet:dakikavesaat",getRootElement(), veriKaydetDakikaveSaat)

addEvent("kaydet:seviyevesaat", true)
function veriKaydetSeviyeveAmac(client)
	local level = getElementData(client, "level")
	local hoursaim = getElementData(client, "hoursaim")
	local id = getElementData(client, "dbid") -- account:character:id
	if id then
		dbExec(mysql:getConnection(),"UPDATE `characters` SET `level`='"..level.."' WHERE `id`='"..id.."' ")
		dbExec(mysql:getConnection(),"UPDATE `characters` SET `hoursaim`='"..hoursaim.."' WHERE `id`='"..id.."' ")
	end
end
addEventHandler("kaydet:seviyevesaat",getRootElement(), veriKaydetSeviyeveAmac)

function setHunger(thePlayer, commandName, targetPlayerName, hunger)
	if exports.un_integration:isPlayerDeveloper(thePlayer) then
		if not targetPlayerName or not hunger then
			outputChatBox("SÖZDİZİMİ: /" .. commandName .. " [Oyuncu Adı / ID] [Açlık]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if not targetPlayer then
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Oyuncu henüz giriş yapmadı.", thePlayer, 255, 0, 0 )
			else
				setElementData(targetPlayer, "hunger", tonumber(hunger))
				dbExec(mysql:getConnection(), "UPDATE characters SET hunger='"..tonumber(hunger).."' WHERE id='"..getElementData(targetPlayer, "dbid").."'")
			end
		end
	end
end
addCommandHandler("sethunger", setHunger)

-- /setthirst for Admin+
function setThirst(thePlayer, commandName, targetPlayerName, thirst)
	if exports.un_integration:isPlayerDeveloper(thePlayer) then
		if not targetPlayerName or not thirst then
			outputChatBox("SÖZDİZİMİ: /" .. commandName .. " [Oyuncu Adı / ID] [Susuzluk]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if not targetPlayer then
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Oyuncu henüz giriş yapmadı.", thePlayer, 255, 0, 0 )
			else
				setElementData(targetPlayer, "thirst", tonumber(thirst))
				dbExec(mysql:getConnection(), "UPDATE characters SET thirst='"..tonumber(thirst).."' WHERE id='"..getElementData(targetPlayer, "dbid").."'")
			end
		end
	end
end
addCommandHandler("setthirst", setThirst)