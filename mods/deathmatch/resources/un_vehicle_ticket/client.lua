
local sx, sy = guiGetScreenSize()

local ped = createPed(97, 1562.21875, -1674.4609375, 16.1953125, 180)
setElementFrozen(ped, true)
setElementData( ped, "talk", 1, false )
setElementData( ped, "name", "Seda Yıldız", false )
setElementInterior(ped, 0)
setElementDimension(ped, 0)

setElementData(localPlayer, "ceza:panel",nil)
setElementData(localPlayer, "ceza:sorgu",nil)

function sorgu ()
	if not getElementData(localPlayer, "loggedin") then return end
	if getElementData(localPlayer, "ceza:sorgu") then return end
	setElementData(localPlayer, "ceza:sorgu", true)
	sorgu_arka = guiCreateWindow(sx/2-450/2,sy/2-100/2,450,100, "UNT - Ceza Sorgulama", false)
	guiWindowSetSizable(sorgu_arka , false)
	sorgu_yazi = guiCreateLabel(15, 30, 100, 25, "Araç ID:", false, sorgu_arka)
	aracid_edit = guiCreateEdit(70, 25, 450, 25, "", false, sorgu_arka)
	sorgu_onay = guiCreateButton(0,55,200,50,"Sorgula",false,sorgu_arka)
	sorgu_vazgec = guiCreateButton(225,55,450,50,"Arayüzü Kapat",false,sorgu_arka)
	guiSetFont(sorgu_yazi, "default-bold")
	guiSetFont(aracid_edit, "default-bold")
	guiSetFont(sorgu_onay, "default-bold")
	guiSetFont(sorgu_vazgec, "default-bold")
end
addEvent("ceza:npc",true)
addEventHandler("ceza:npc",root,sorgu)

aracid = ""
fiyat2 = 0
function cezaode (fiyat,arac)
	ceza_arka = guiCreateWindow(sx/2-450/2,sy/2-100/2,450,100, "UNT - Ceza Ödeme", false)
	ceza_onay = guiCreateButton(0,25,450,30,"Cezayı Öde ($"..exports.un_global:formatMoney(fiyat)..")",false,ceza_arka)
	ceza_vazgec = guiCreateButton(0,25+35,450,30,"Arayüzü Kapat",false,ceza_arka)
	fiyat2 = fiyat
	aracid = arac
end
addEvent("ceza:ode",true)
addEventHandler("ceza:ode",root,cezaode)

function panel (arac)
	if not getElementData(localPlayer, "loggedin") then return end
	if getElementData(localPlayer, "faction") == 1 or getElementData(localPlayer, "faction") == 78 then
		if getElementData(localPlayer, "ceza:panel") then return end
		setElementData(localPlayer, "ceza:panel", true)
		aracid = arac
		arkaplan = guiCreateWindow(sx/2-450/2,sy/2-100/2,450,139, "UNT - Ceza Sistemi", false)
		guiWindowSetSizable(arkaplan , false)
		cezayazi = guiCreateLabel(15, 30, 100, 25, "Ceza Fiyatı:", false, arkaplan)
		sebepyazi = guiCreateLabel(15, 60, 100, 25, "Ceza Nedeni:", false, arkaplan)
		ceza = guiCreateEdit(100, 25, 100, 25, "", false, arkaplan)
		sebep = guiCreateEdit(100, 55, 100, 25, "", false, arkaplan)
		onay = guiCreateCheckBox(10, 110, 222, 65, "Ceza makbuzunu onaylıyorum.", false, false, arkaplan)
		onay_buton = guiCreateButton(225,25,450,25,"Onayla",false,arkaplan)
		vazgec_buton = guiCreateButton(225,55,450,25,"Arayüzü Kapat",false,arkaplan)
		guiSetFont(cezayazi, "default-bold")
		guiSetFont(sebepyazi, "default-bold")
		guiSetFont(ceza, "default-bold")
		guiSetFont(sebep, "default-bold")
		guiSetFont(onay, "default-bold")
	end
end

addEventHandler("onClientGUIClick", root, function(btn) 
	if btn == "left" then
	if source == ceza_onay then
		triggerServerEvent("ceza:ode",localPlayer, aracid, fiyat2)
		destroyElement(ceza_arka)
	end
	if source == ceza_vazgec then
		destroyElement(ceza_arka)
	end
		if source == sorgu_onay then
			if not tonumber(guiGetText(aracid_edit)) then outputChatBox("[!]#ffffff Araç ID Kısmına bir sayı değeri giriniz.",255,100,100,true) return end
			if guiGetText(aracid_edit) == "" or guiGetText(aracid_edit) == " " or tonumber(guiGetText(aracid_edit)) <= 0 then outputChatBox("[!]#ffffff Lütfen geçerli bir sayı giriniz.",255,100,100,true) return end
			
			triggerServerEvent("ceza:sorgu",localPlayer, tonumber(guiGetText(aracid_edit)))
			destroyElement(sorgu_arka)
			setElementData(localPlayer, "ceza:sorgu",nil)
		end
		if source == sorgu_vazgec then
			destroyElement(sorgu_arka)
			setElementData(localPlayer, "ceza:sorgu",nil)
		end
		
		if source == vazgec_buton then
			destroyElement(arkaplan)
			setElementData(localPlayer, "ceza:panel",nil)
		end
		if source  == onay_buton then
			if(guiCheckBoxGetSelected(onay))then
				if not tonumber(guiGetText(ceza)) then outputChatBox("[!]#ffffff Lütfen ceza kısmına bir sayı değeri giriniz.",255,100,100,true) return end
				if guiGetText(sebep) == "" or guiGetText(sebep) == " " then outputChatBox("[!]#ffffff Ceza sebebini boş bırakamazsınız.",255,100,100,true) return end
				triggerServerEvent("ceza:islemler",localPlayer, getElementData(aracid, "dbid"), tonumber(guiGetText(ceza)), guiGetText(sebep))
				destroyElement(arkaplan)
				setElementData(localPlayer, "ceza:panel",nil)
			else
				outputChatBox("[!]#ffffff Bu işlemi yapmak için onay vermeniz gerekli.",255,100,100,true)
			end
		end	
	end
end)