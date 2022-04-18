addCommandHandler("kelepce",function(plr,cmd,target)
	if  plr:getTeam():getName() == "İstanbul Emniyet Müdürlüğü" or plr:getTeam():getName() == "İstanbul İl Jandarma Komutanlığı" then

		if not target then
			outputChatBox("Kullanım : /"..cmd.." <Oyuncu İD> Yazarak kelepçeleyebilirsiniz.",plr,255,194,14,true)
		return end

		local target, targetPlayerName = exports.un_global:findPlayerByPartialNick(plr, target)
		
		if target then

			if getElementData(target, "kelepce") then
				kelepcele(target, "al")
				exports.un_global:sendLocalMeAction(plr, "Sağ ve sol eli ile şahsın bileğindeki kelepçeyi çözer.")
			return end

			exports.un_global:sendLocalMeAction(plr, "Sağ elini teçhizat kemerine atar ve bir kelepçe çıkarıp şahsın bileklerine geçirir.")
			kelepcele(target, "ver")
		end
	end
end)

addEvent("ipbagla",true)
addEventHandler("ipbagla",root,function(plr,target)
if not exports["un_items"]:hasItem(plr,46) then outputChatBox("[!]#ffffff Maalesef üzerinizde ip yok.",plr,255,100,100,true) return end
	local target, targetPlayerName = exports.un_global:findPlayerByPartialNick(plr, target)
	local x,y,z = getElementPosition(plr)
	local x2,y2,z2 = getElementPosition(target)
	if getDistanceBetweenPoints3D(x,y,z,x2,y2,z2) > 3 then
		outputChatBox("[!]#ffffff Şahıs çok uzağınızda.",plr,255,100,100,true)
	return end
	if target then
		if getElementData(target, "ipbagli") then
			outputChatBox("[!]#ffffff Bağlamaya çalıştığınız kişi zaten bağlı.",plr,255,100,100,true)
		return end

		if getElementData(plr, "ipbagli") then
			outputChatBox("[!]#ffffff İp ile bağlanmışken başka birisini bağlayamazsınız.",plr,255,100,100,true)
		return end

		exports.un_global:sendLocalMeAction(plr, "Şahsın sağ ve sol ellerini birleştirerek ip ile sıkıca bağlar.")
		outputChatBox("[!]#ffffff ["..getPlayerName(target).."] adlı kişinin ellerini bağladınız.",plr,100,100,255,true)
		outputChatBox("[!]#ffffff ["..getPlayerName(plr).."] adlı kişi ellerinizi bağladı.",target,100,100,255,true)
		kelepcele(target, "ipver")
		exports["un_items"]:takeItem(plr, 46)
	end
end)


addEvent("ipcoz",true)
addEventHandler("ipcoz",root,function(plr,target)
	if not getElementData(target, "ipbagli") then outputChatBox("[!]#ffffff İpini çözmeye çalıştığınız kişinin elleri bağlı değil",plr,255,100,100,true) return end

	local x,y,z = getElementPosition(plr)
	local x2,y2,z2 = getElementPosition(target)
	
	if getDistanceBetweenPoints3D(x,y,z,x2,y2,z2) > 3 then
		outputChatBox("[!]#ffffff Şahıs çok uzağınızda.",plr,255,100,100,true)
	return end
		
	if target then
		if getElementData(plr, "ipbagli") then
			outputChatBox("[!]#ffffff İp ile bağlanmışken başka birisini bağlayamazsınız.",plr,255,100,100,true)
		return end

		exports.un_global:sendLocalMeAction(plr, "Şahsın bileklerindeki ipi keserek çözer.")
		outputChatBox("[!]#ffffff ["..getPlayerName(target).."] adlı kişinin ellerini çözdünüz.",plr,100,100,255,true)
		outputChatBox("[!]#ffffff ["..getPlayerName(plr).."] adlı kişi ellerinizi çözdü.",target,100,100,255,true)
		kelepcele(target, "ipal")
	end
end)

addEvent("gozbagla",true)
addEventHandler("gozbagla",root,function(plr,target)
	if not exports["un_items"]:hasItem(plr,66) then outputChatBox("[!]#ffffff Maalesef üzerinizde bandaj yok.",plr,255,100,100,true) return end
	local target, targetPlayerName = exports.un_global:findPlayerByPartialNick(plr, target)
	local x,y,z = getElementPosition(plr)
	local x2,y2,z2 = getElementPosition(target)
	if getDistanceBetweenPoints3D(x,y,z,x2,y2,z2) > 3 then
		outputChatBox("[!]#ffffff Şahıs çok uzağınızda.",plr,255,100,100,true)
	return end
	if target then
		if getElementData(target, "gözbandajı") then
			outputChatBox("[!]#ffffff Gözünü bağlamaya çalıştığınız kişinin zaten gözleri bağlı",plr,255,100,100,true)
		return end
		outputChatBox("[!]#ffffff ["..getPlayerName(target).."] adlı kişinin gözlerini bağladınız.",plr,100,100,255,true)
		outputChatBox("[!]#ffffff ["..getPlayerName(plr).."] adlı kişi gözlerinizi bağladı.",target,100,100,255,true)
		fadeCamera(target, false)
		setElementData(target, "gözbandajı",true)
		exports["un_items"]:takeItem(plr, 66)
	end
end)


addEvent("gozcoz",true)
addEventHandler("gozcoz",root,function(plr,target)
	if not getElementData(target, "gözbandajı") then outputChatBox("[!]#ffffff Gözlerini çözmeye çalıştığınız kişinin gözleri bağlı değil",plr,255,100,100,true) return end
	local x,y,z = getElementPosition(plr)
	local x2,y2,z2 = getElementPosition(target)
	if getDistanceBetweenPoints3D(x,y,z,x2,y2,z2) > 3 then
		outputChatBox("[!]#ffffff Şahıs çok uzağınızda.",plr,255,100,100,true)
	return end
	if target then	
		outputChatBox("[!]#ffffff ["..getPlayerName(target).."] adlı kişinin gözlerini çözdünüz.",plr,100,100,255,true)
		outputChatBox("[!]#ffffff ["..getPlayerName(plr).."] adlı kişi gözlerinizi çözdü.",target,100,100,255,true)
		fadeCamera(target, true)
		setElementData(target, "gözbandajı",nil)
	end
end)

function engelle(source)
	if getElementData(source, "kelepce") then
		for i, v in ipairs(controls) do
			toggleControl(source, v, false)
		end	
	end
	if getElementData(source, "ipbagli") then
		for i, v in ipairs(controls) do
			toggleControl(source, v, false)
		end	
	end
end

addEventHandler ( 'onPlayerWeaponSwitch', getRootElement ( ),
	function ( previousWeaponID, currentWeaponID )
		if getElementData(source, "kelepce") then
			setPedWeaponSlot(source, 0)
		return end
		if getElementData(source, "ipbagli") then
			setPedWeaponSlot(source, 0)
		return end
	end
)