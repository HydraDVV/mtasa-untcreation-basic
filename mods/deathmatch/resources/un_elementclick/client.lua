Click = Service:new('element-interface')
author = 'github.com/bekiroj'
activated = false
font = DxFont('Roboto.ttf', 9)
localPlayer = getLocalPlayer()
dxDrawRectangle = dxDrawRectangle
dxDrawText = dxDrawText

Click.character = function()
	if localPlayer:getData('loggedin') == 1 then
	if localPlayer:getData('dead') == 1 then return end
		if activated then
			Click.close()
		else
			activated = true
			counter = 0
			size = 25
			Click.pullCharOptions()
			for index, value in ipairs(pulledCharOptions) do
				counter = counter + 1.28
			end
			Click.Charender = Timer(
				function()
					local elementPos = localPlayer:getPosition()
					local x, y = getScreenFromWorldPosition(elementPos)
					dxDrawRectangle(x, y, 150, size*counter, tocolor(0,0,0,255))
					dxDrawOuterBorder(x, y, 150, size*counter, 2, tocolor(10,10,10,250))
					for key, value in pairs(pulledCharOptions) do
						if isMouseInPosition(x, y, 150, size+7) then
							dxDrawRectangle(x, y, 150, size+7, tocolor(5,5,5,250))
							dxDrawText(value[1], x+15, y+7, 150, size+7, tocolor(200,200,200,250), 1, font)
						else
							dxDrawRectangle(x, y, 150, size+7, tocolor(5,5,5,225))
							dxDrawText(value[1], x+15, y+7, 150, size+7, tocolor(200,200,200,250), 1, font)
						end
						if isMouseInPosition(x, y, 150, size+7) and getKeyState("mouse1") then
							Click.close()
							value[2]()
						end
						y = y + 32
					end
				end,
			0, 0)
		end
	end
end

Click.constructor = function(button, state, _,_,_,_,_, clickedElement)
	if localPlayer:getData('loggedin') == 1 then
	if localPlayer:getData('dead') == 1 then return end
		if button == 'right' and state == 'down' then
			if isElement(clickedElement) then
				if clickedElement ~= localPlayer then
					local type =  clickedElement.type
					if type == 'vehicle' or type == 'player' or type == 'ped' and getElementData(clickedElement, "name") then
						if activated then
							Click.close()
						else
							activated = true
							counter = 0
							size = 25
							Click.pullOptions(clickedElement)
							for index, value in ipairs(pulledOptions) do
								counter = counter + 1.28
							end
							Click.render = Timer(
								function()
									if getDistanceBetweenPoints3D(localPlayer.position.x, localPlayer.position.y, localPlayer.position.z, clickedElement.position.x, clickedElement.position.y, clickedElement.position.z) < 3 then
										local elementPos = clickedElement:getPosition()
										local x, y = getScreenFromWorldPosition(elementPos)
										dxDrawRectangle(x, y, 150, size*counter, tocolor(0,0,0,255))
										dxDrawOuterBorder(x, y, 150, size*counter, 2, tocolor(10,10,10,250))
										for key, value in pairs(pulledOptions) do
											if isMouseInPosition(x, y, 150, size+7) then
												dxDrawRectangle(x, y, 150, size+7, tocolor(5,5,5,250))
												dxDrawText(value[1], x+15, y+7, 150, size+7, tocolor(200,200,200,250), 1, font)
											else
												dxDrawRectangle(x, y, 150, size+7, tocolor(5,5,5,225))
												dxDrawText(value[1], x+15, y+7, 150, size+7, tocolor(200,200,200,250), 1, font)
											end
											if isMouseInPosition(x, y, 150, size+7) and getKeyState("mouse1") then
												Click.close()
												value[2]()
											end
											y = y + 32
										end
									else
										Click.close()
									end
								end,
							0, 0)
						end
					end
				end
			end
		end
	end
end

Click.close = function()
	pulledOptions = {}
	pulledCharOptions = {}
	activated = false
	if isTimer(Click.render) then
		killTimer(Click.render)
	end
	if isTimer(Click.Charender) then
		killTimer(Click.Charender)
	end
end

Click.pullOptions = function(element)
	local type =  element.type
	if type == 'vehicle' then
	  if element:getData('carshop') then

	    pulledOptions = {
  			{"Sat??n Al ("..exports.un_global:formatMoney(getElementData(element,"carshop:cost")).."???)", function()
  		  		triggerServerEvent("carshop:buyCar", element, "cash")
  			end,},
  			{"Detaylar??n?? ??ncele", function()
  		  		triggerServerEvent("carshop:infoCar", localPlayer, element)
  			end,},
  			{"Vazge??", function()
			end,},
  		}
	  else
  		pulledOptions = {
  			{"Kap?? Kontrol??", function()
  		  	exports["un_vehicle"]:openVehicleDoorGUI(element)
  			end,},
  			{"Ceza Kes", function()
  		  		exports["un_vehicle_ticket"]:panel(element)
  			end,},
  			{"Ara?? Bagaj??(??naktif)", function()
  		  	
  			end,},
  			{"Vazge??", function()
			end,},
  		}
  	end
	elseif type == 'player' then
		pulledOptions = {
			{"??st??n?? Ara", function()
				if getElementData(element, "ipbagli") or getElementData(element, "kelepce") then
					local target = getPlayerFromName(getPlayerName(element))
					triggerServerEvent("friskShowItems", localPlayer, target)
				else
					outputChatBox("??zerini aramak istedi??iniz ki??i ba??l?? veya kelep??eli de??il..", 255, 0, 0)
				end
			end,},
			{"Ellerini Ba??la/????z", function()
				local target = getPlayerFromName(getPlayerName(element))
				if not getElementData(element, "ipbagli") then
					triggerServerEvent("ipbagla",localPlayer,localPlayer,target)
				else
					triggerServerEvent("ipcoz",localPlayer,localPlayer,target)
				end
			end,},
			{"G??zlerini Ba??la/????z", function()
				local target = getPlayerFromName(getPlayerName(element))
				if not getElementData(element, "g??zbandaj??") then
					triggerServerEvent("gozbagla",localPlayer,localPlayer,target)
				else
					triggerServerEvent("gozcoz",localPlayer,localPlayer,target)
				end
			end,},
			{"Kelep??ele/????kar", function()
				local target = getPlayerFromName(getPlayerName(element))
				if not getElementData(element, "kelepce") then
					if exports["un_items"]:hasItem(localPlayer, 45) then
						triggerServerEvent("kelepcele",localPlayer,target,"ver")
					else
						outputChatBox("Bunu yapabilmek i??in kelep??eye ihtiyac??n??z var..", 255, 0, 0)
					end
				else
					triggerServerEvent("kelepcele",localPlayer,target,"al")
				end
			end,},
			{"Vazge??", function()
			end,},
		}
	elseif type == 'ped' then
		pulledOptions = {
			{"Etkile??im", function()
				triggerEvent("npc:konus",localPlayer,element)
			end,},
			{"Vazge??", function()
			end,},
		}
	end
end

Click.pullCharOptions = function()
	pulledCharOptions = {
		{"Karakter De??i??tir", function()
			exports.un_notification:create("Devam etmek i??in 'ENTER' / Yeni bir karakter olu??turmak i??in 'SPACE' tu??lar??n?? kullan??n!", "info")
			executeCommandHandler("saveme")
			exports["un_auth"]:options_logOut(localPlayer)
		end,},
		{"Vazge??", function()
		end,},
	}
end

addEventHandler('onClientClick', root, Click.constructor)
bindKey( "F10", "down", Click.character)

function toggleCursor()
    if (isCursorShowing()) then
        showCursor(false)
    else
        showCursor(true)
    end
end
addCommandHandler("togglecursor", toggleCursor)
bindKey("m", "down", "togglecursor")