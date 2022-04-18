addEvent("ceza:islemler",true)
addEvent("ceza:sorgu",true)
addEvent("ceza:ode",true)

mysql = exports.un_mysql
tablo = {}

addEventHandler("ceza:ode",root,function(aracid, fiyat)
	if  exports.un_global:getMoney(source) < fiyat then
		outputChatBox("[!]#ffffff Yeterli paranız yok.",source,255,0,0,true)
	return end
	local arac = exports.un_pool:getElement("vehicle", tonumber(aracid))
	exports.un_global:takeMoney(source, fiyat)
	outputChatBox("[!]#ffffff ["..aracid.."] numaralı  aracın borcu ödenmiştir.",source,100,255,100,true)
	dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `ceza`='0', ceza_sebep='Yok' WHERE `id`='" .. aracid .."'")	
	setElementData(arac, "enginebroke", 0)
	exports["un_vehicle"]:reloadVehicle(aracid)
end)

addEventHandler("ceza:sorgu",root,function(aracid)
	if not tablo[source] then tablo[source] = {} end
	local arac = exports.un_pool:getElement("vehicle",tonumber(aracid))
	if not arac then 
		outputChatBox("[!]#ffffff Böyle bir araç yok",source,255,0,0,true)
	return end
	if tablo[source].zaman then
		outputChatBox("[!]#ffffff Zaten bir sorgu var.",source,255,0,0,true)
	return end
	local ceza = getElementData(arac, "ceza") or 0
	outputChatBox("[!]#ffffff Araç ceza sorgusu yapılıyor...",source,100,100,255,true)
	tablo[source].kim = source
	if tonumber(ceza) <= 0 then
		outputChatBox("[!]#ffffff Aracın herhangi bir cezası bulunamadı",source,100,255,100,true)
		tablo = {}
	else
		triggerClientEvent(source,"ceza:ode",source,ceza,aracid)
	end
end)

addEventHandler("ceza:islemler",root,function(aracid, ceza,sebep)
	local arac = exports.un_pool:getElement("vehicle", tonumber(aracid))
	dbExec(mysql:getConnection(),"UPDATE `vehicles` SET `ceza`='"..ceza.."', ceza_sebep='"..sebep.."' WHERE `id`='" .. aracid .."'")	
	setElementData(arac, "enginebroke", 1)	
	exports["un_vehicle"]:reloadVehicle(aracid)
	outputChatBox("[!]#ffffff ["..aracid.."] numaralı araca cezayı başarıyla kestiniz.",source,100,255,100,true)
end)