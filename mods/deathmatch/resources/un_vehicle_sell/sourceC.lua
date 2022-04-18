-- // bekiroj

function yazim ()
	for key, veh in ipairs(getElementsByType("vehicle")) do
		if (isElement(veh)) and isElementStreamedIn(veh) then
			local lpx, lpy, lpz = getElementPosition(getLocalPlayer())
			local rvx, rvy, rvz = getElementPosition(veh)
			local distance = getDistanceBetweenPoints3D(lpx, lpy, lpz, rvx, rvy, rvz)
			local lim = 7
			if (isElementOnScreen(veh)) and (distance<lim) then
				local lx, ly, lz = getCameraMatrix()
				local collision, cx, cy, cz, element = processLineOfSight(lx, ly, lz, rvx, rvy, rvz+2, true, true, true, true, false, false, true, false)					
				if not (collision) then
					local x, y, z = getElementPosition(veh)
					local sx, sy = getScreenFromWorldPosition(x, y, z, 100, false)								
					if (sx) and (sy) then
						if (distance < 1) then distance = 1 end
						if (distance > 2) then distance = 2 end
						local offset = 70 / distance
						local scale = 2-(distance/10)		
						local font = "default-bold"
						if getElementData(veh, "satilikmi") == 0 then return end
						yazi2 = "Satılık: ₺"..getElementData(veh, "fiyat").."\nİletişim: "..getElementData(veh, "numara")..""
						dxDrawText(yazi2, sx, sy, (sx-offset)+130 / distance, sy+20 / distance, tocolor(0, 0, 0, 255), 0.8, font, "center", "center", false, false, false)	
						dxDrawText(yazi2, sx, sy+1, (sx-offset)+130 / distance, sy+20 / distance, tocolor(0, 0, 0, 255), 0.8, font, "center", "center", false, false, false)									
						dxDrawText(yazi2, sx, sy+2, (sx-offset)+130 / distance, sy+20 / distance, tocolor(0, 200, 0, 255), 0.8, font, "center", "center", false, false, false)
					end
				end	
			end
		end
	end
end
addEventHandler("onClientRender",root,yazim)