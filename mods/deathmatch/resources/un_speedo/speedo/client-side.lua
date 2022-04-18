--[[
// ** @author: Ne0R`
// ** en düzenli speedo :D
--]]

local sx, sy = guiGetScreenSize()
local pw, ph = 110, 110
local sw, sh = (sx-pw)-15, (sy-ph)+35
local npw, nph = 72, 72
local iW, iH = 20, 20

local fonts = {
	exports['un_fonts']:getFont('RobotoB',25),
	exports['un_fonts']:getFont('Roboto',10),
	exports['un_fonts']:getFont('RobotoB',12)
}

local fuel = 0

function syncFuel(ifuel)
	if not (ifuel) then
		fuel = 100
	else
		fuel = ifuel
	end
end
addEvent('syncFuel', true)
addEventHandler('syncFuel', getRootElement(), syncFuel)

addEventHandler('onClientElementDataChange', root, function(key, old, new)
	if source.type == 'player' or source.type == 'vehicle' then
		if key == 'seatbelt' then
			playerSeatbelt = new
		elseif key == 'lights' then
			vehLights = new
		elseif key == 'handbrake' then
			vehBrake = new
		end
	end
end
)

local riverSpeedo = function()
	if localPlayer.vehicle then
		local vehicle = localPlayer:getOccupiedVehicle()
		local kilometre = exports.un_global:getVehicleVelocity(vehicle, localPlayer)
		local FuelPer = getElementData(getPedOccupiedVehicle(getLocalPlayer()),"fuel") or 0
		local vehLights = vehicle:getData('lights')
		local vehBrake = vehicle:getData('handbrake')
		local playerSeatbelt = localPlayer:getData('seatbelt')
			dxDrawText(string.format('%03d',kmh), sw, sh-20, sw, sh, tocolor(255, 255, 255, 255), 0.8, fonts[1], 'center', 'center', false, false, false, false, false)
			dxDrawText('km/s', sw, sh+20, sw, sh, tocolor(255, 255, 255, 255), 1, fonts[2], 'center', 'center', false, false, false, false, false)
			dxDrawText('%'..tostring(math.floor(FuelPer)), sw+110, sh-80, sw, sh, tocolor(255, 255, 255, 255), 0.8, fonts[3], 'center', 'center', false, false, false, false, false)
			
        	hou_circle(sw, sh, pw, ph, tocolor(0, 0, 0, 35), 220, 285, 5)
        	hou_circle(sw, sh, pw, ph, tocolor(200, 200, 200, 200), 220, kilometre/1.6, 5)
			
        	hou_circle(sw+50, sh+5, npw, nph, tocolor(0, 0, 0, 35), 1, 170, 6)
        	hou_circle(sw+50, sh+5, npw, nph, tocolor(200, 200, 200, 200), 1, FuelPer, 6)
			
			dxDrawImage(sw+55, sh-5, iW, iH,'speedo/olds/gasolina.png', 0, 0, 0, tocolor(255,255,255), true)
			

			if vehLights == 1 then
				dxDrawImage(sw-70, sh+30, 16, 16,'speedo/olds/farol.png', 0, 0, 0, tocolor(255, 255, 255, 255), true)
			else
				dxDrawImage(sw-70, sh+30, 16, 16,'speedo/olds/farol.png', 0, 0, 0, tocolor(255, 255, 255, 75), true)
			end
			
			if playerSeatbelt then
				dxDrawImage(sw-90, sh+30, 14, 16,'speedo/olds/cinto.png', 0, 0, 0, tocolor(255, 255, 255, 255), true)
			else
				dxDrawImage(sw-90, sh+30, 14, 16,'speedo/olds/cinto.png', 0, 0, 0, tocolor(255, 255, 255, 75), true)
			end

			if vehBrake == 1 then
				dxDrawImage(sw-135, sh+29, 21, 21,'speedo/olds/handbrake.png', 0, 0, 0, tocolor(255, 255, 255, 255), true)
			else
				dxDrawImage(sw-135, sh+29, 21, 21,'speedo/olds/handbrake.png', 0, 0, 0, tocolor(255, 255, 255, 75), true)
			end

			if vehicle:getEngineState(true) then
				dxDrawImage(sw-110, sh+30, 16, 16,'speedo/olds/freio.png', 0, 0, 0, tocolor(255, 255, 255, 255), true)
			else
				dxDrawImage(sw-110, sh+30, 16, 16,'speedo/olds/freio.png', 0, 0, 0, tocolor(255, 255, 255, 75), true)
			end

	end
end
addEventHandler('onClientRender', root, riverSpeedo)

function hiz()
if localPlayer.vehicle then
local vehicle = localPlayer:getOccupiedVehicle()
kmh = math.floor(exports.un_global:getVehicleVelocity(vehicle, localPlayer))
	end
end		
setTimer(hiz, 350, 0)