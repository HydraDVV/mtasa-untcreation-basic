wRightClick = nil
bInventory = nil
bCloseMenu = nil
ax, ay = nil
localPlayer = getLocalPlayer()
safe = nil

local function requestInventory(button)
	if button=="left" and not getElementData(localPlayer, "exclusiveGUI") then
		triggerServerEvent( "openFreakinInventory", getLocalPlayer(), safe, ax, ay )
		hideSafeMenu()
	end
end



function clickSafe(button, state, absX, absY, wx, wy, wz, element)
	if getElementData(getLocalPlayer(), "exclusiveGUI") then
		return
	end
	if element and getElementType( element ) == "object" and button == "right" and state == "down" and getElementModel(element) == 2332 then
		local x, y, z = getElementPosition(localPlayer)
		
		if getDistanceBetweenPoints3D(x, y, z, wx, wy, wz) <= 3 then
			if (wRightClick) then
				hideSafeMenu()
			end
			
			local dimension = getElementDimension(getLocalPlayer())
			if ( dimension < 19000 and ( hasItem(getLocalPlayer(), 5, dimension) or hasItem(getLocalPlayer(), 4, dimension) ) ) or ( dimension >= 20000 and hasItem(getLocalPlayer(), 3, dimension-20000) ) or ((getElementData(getLocalPlayer(),"admin_level") >= 2) and (getElementData(getLocalPlayer(),"duty_admin") == 1 )) then
				showCursor(true)
				ax = absX
				ay = absY
				safe = element
				showSafeMenu()
				setTimer(function()
					outputChatBox("#575757UNT:#f9f9f9 Uzun süredir işlem yapmadığın için panel kapatıldı.", 255, 0, 0, true)
					hideSafeMenu()
				end, 10000, 1)
			else
				outputChatBox("#575757UNT:#f9f9f9 Bu kasanın anahtarına sahip değilsin.", 255, 0, 0, true)
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickSafe, true)

function showSafeMenu()
	wRightClick = guiCreateWindow(ax, ay, 150, 100, "Kasalar", false)

	bInventory = guiCreateButton(0.05, 0.23, 0.87, 0.2, "Envanter", true, wRightClick)
	addEventHandler("onClientGUIClick", bInventory, requestInventory, false)
	
	bCloseMenu = guiCreateButton(0.05, 0.63, 0.87, 0.2, "Arayüzü Kapat", true, wRightClick)
	addEventHandler("onClientGUIClick", bCloseMenu, hideSafeMenu, false)
end

function hideSafeMenu()
	if (isElement(bCloseMenu)) then
		destroyElement(bCloseMenu)
	end
	bCloseMenu = nil
	
	if (isElement(wRightClick)) then
		destroyElement(wRightClick)
	end
	wRightClick = nil
	
	ax = nil
	ay = nil


	showCursor(false)
	triggerEvent("cursorHide", localPlayer)
	setElementData(localPlayer, "exclusiveGUI", false, false)
end
