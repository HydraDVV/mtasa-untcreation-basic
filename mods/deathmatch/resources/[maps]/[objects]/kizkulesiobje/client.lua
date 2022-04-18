--
local pedName = "Zehra Yüksel"
local kizkulesiNPC = createPed(93, 527.65466308594, -2041.4318847656, 2.015625)
setElementRotation(kizkulesiNPC, 0, 0, 295)
setElementFrozen(kizkulesiNPC, true)
setElementData(kizkulesiNPC, "name", "Zehra Yüksel")
setElementData(kizkulesiNPC, "nametag", true)

function clickObject(button, state, absX, absY, wx, wy, wz, element)
	if (element) and (getElementType(element)=="ped") and (button=="right") and (state=="down") then --if it's a right-click on a object
		if (element == kizkulesiNPC) then
			local rcMenu = exports["zrd_rightclick"]:create("Kız Kulesi")
			local row = exports["zrd_rightclick"]:addRow("Bilgi Al")
			local row2 = exports["zrd_rightclick"]:addRow("Kıyafetin çok güzelmiş.")
			addEventHandler("onClientGUIClick", row,  function (button, state)
				bilgiVer()
			end, true)
			addEventHandler("onClientGUIClick", row2,  function (button, state)
				biletAl()
			end, true)			
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickObject, true)

function biletAl()
	local bilgiList = {
		"[Türkçe] " .. pedName .. " diyor ki: Teşekkür ederim.",
	}
	for i, v in ipairs (bilgiList) do
		triggerServerEvent("sendLocalText", getRootElement(), getLocalPlayer(), v, 255, 255, 255, 10, {}, false, true)
	end
end


function bilgiVer()
	local bilgiList = {
		"[Türkçe] " .. pedName .. " diyor ki: Kız kulesi, Üsküdar'ın sembolü haline gelmiştir ve Bizans devrinden kalan tek eserdir.",
		"[Türkçe] " .. pedName .. " diyor ki: M.Ö. 24 yıllarına kadar uzanan tarihi bir geçmişe sahip olan kule, Karadeniz'in Marmara ile birleştiği yerde küçük bir ada üzerine kurulmuştur.",
		"[Türkçe] " .. pedName .. " diyor ki: Detaylı bilgi almak isterseniz internetten Kız Kulesi'ni araştırabilirsiniz.",
	}
	for i, v in ipairs (bilgiList) do
		triggerServerEvent("sendLocalText", getRootElement(), getLocalPlayer(), v, 255, 255, 255, 10, {}, false, true)
	end
end