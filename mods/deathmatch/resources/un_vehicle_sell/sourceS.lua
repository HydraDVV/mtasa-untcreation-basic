-- // bekiroj
local db = exports.un_mysql

addCommandHandler("satilik",
	function (thePlayer, cmd, fiyat, numara)
		if getElementData(thePlayer, "loggedin") == 1 then
			if isPedInVehicle(thePlayer) then
				local theVehicle = getPedOccupiedVehicle(thePlayer)
				local pdbid = getElementData(thePlayer, "dbid") or 0
				local owner = getElementData(theVehicle, "owner")
				local dbid = getElementData(theVehicle, "dbid")
				if getElementData(theVehicle, "satilikmi") == 0 then
					if owner == pdbid then
						if not tonumber(fiyat) then
							outputChatBox("[!]#ffffff /satilik [Fiyat] [Telefon Numaranız]",thePlayer,151,47,47,true)
						return end
						if not tonumber(numara) then
							outputChatBox("[!]#ffffff /satilik [Fiyat] [Telefon Numaranız]",thePlayer,151,47,47,true)
						return end
						if tonumber(fiyat) <= 0 then
							outputChatBox("[!]#ffffff Geçerli bir fiyat giriniz!",thePlayer,151,47,47,true)
						return end
						if tonumber(numara) <= 0 then
							outputChatBox("[!]#ffffff Geçerli bir numara giriniz!",thePlayer,151,47,47,true)
						return end
						setElementData(theVehicle, "satilikmi", 1)
						setElementData(theVehicle, "fiyat", tonumber(fiyat))
						setElementData(theVehicle, "numara", tonumber(numara))
						dbExec(db:getConnection(),"UPDATE vehicles SET satilikmi='-1', fiyat = "..fiyat..", numara = "..numara.." WHERE id = " .. getElementData(theVehicle, "dbid"))
						exports["un_vehicle"]:reloadVehicle(dbid)
						outputChatBox("[!]#ffffff "..dbid.." ID'li aracınızı ₺"..fiyat.." karşılığında satılığa çıkardınız.",thePlayer,151,47,47,true)
					end
				else
					setElementData(theVehicle, "satilikmi", 0)
					setElementData(theVehicle, "fiyat", 0)
					setElementData(theVehicle, "numara", 0)
					dbExec(db:getConnection(),"UPDATE vehicles SET satilikmi='0', fiyat='0', numara='0' WHERE id = " .. getElementData(theVehicle, "dbid"))
					exports["un_vehicle"]:reloadVehicle(dbid)
				end
			end
		end
	end
)

addCommandHandler("satinal",
	function (thePlayer, cmd)
		if getElementData(thePlayer, "loggedin") == 1 then
			if isPedInVehicle(thePlayer) then
				local theVehicle = getPedOccupiedVehicle(thePlayer)
				local pdbid = getElementData(thePlayer, "dbid") or 0
				local owner = getElementData(theVehicle, "owner")
				local dbid = getElementData(theVehicle, "dbid")
				local fiyat = getElementData(theVehicle, "fiyat")
				if getElementData(theVehicle, "satilikmi") == 0 then return end
				if getElementData(theVehicle, "owner") <= 0 then
					outputChatBox("[!]#ffffff Bir hata meydana geldi.",thePlayer,151,47,47,true)
				return end
				if owner == pdbid then
					outputChatBox("[!]#ffffff Sahibi olduğunuz aracı satın alamazsınız.",thePlayer,151,47,47,true)
				return end
				if exports.un_global:takeMoney(thePlayer, fiyat) then
					dbExec(db:getConnection(),"UPDATE characters SET money = money + "..fiyat.." WHERE id = "..getElementData(theVehicle, "owner"))
					dbExec(db:getConnection(), "UPDATE vehicles SET owner='" .. (pdbid) .. "' WHERE id='" .. (dbid) .. "'")
					dbExec(db:getConnection(),"UPDATE vehicles SET satilikmi='0', fiyat='0', numara='0' WHERE id = " .. getElementData(theVehicle, "dbid"))
					exports['un_items']:deleteAll(3,dbid)
					exports.un_global:giveItem(thePlayer, 3, dbid)
					outputChatBox("[!]#ffffff "..dbid.." ID'li aracı ₺"..fiyat.." karşılığında satın aldınız.",thePlayer,151,47,47,true)
					setElementData(theVehicle, "satilikmi", 0)
					setElementData(theVehicle, "fiyat", 0)
					setElementData(theVehicle, "numara", 0)
					exports["un_vehicle"]:reloadVehicle(dbid)
				else
					outputChatBox("[!]#ffffff Bu aracı satın alabilmek için ₺"..getElementData(theVehicle, "fiyat").." ödemeniz gerekli.",thePlayer,151,47,47,true)
				end
			end
		end
	end
)