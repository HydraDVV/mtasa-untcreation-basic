
screen = Vector2(guiGetScreenSize())

ped = createPed(31, 161.5302734375, -81.19140625, 1001.8046875, 179.14855957031)
ped.frozen = true;
ped.interior = 18;
ped.dimension = 14;
ped:setData('sellClothing', true)

bakim = false

font1 = dxCreateFont('files/Font1.ttf', 10)
font2 = dxCreateFont('files/Font2.otf', 9)


settings = {
    selected = {
        pos = {0,0},
        state = nil,
        veh_id = nil,
        skin_model = nil,
	},
	buttons = {
		{btn = 'Kıyafet satın al'},
        {btn = 'Kapat'}
    },
}


addEventHandler ( "onClientClick", getRootElement(), function(button, state, sx, sy, _, _, _, element ) 
    if  element and element:getData('sellClothing') and button == 'right' and state == 'down' then 
        if getDistanceBetweenPoints3D(Vector3(localPlayer.position), Vector3(element.position)) < 3 then 
			if bakim and not exports.un_integration:isPlayerDeveloper(localPlayer) then 
				outputChatBox('[!]#ffffff Şuanda yenilikler yapılıyor, lütfen açılmasını bekleyiniz.', 255, 0, 0, true)
			return end 
            if not settings.selected.state then 
                settings.selected.pos = {sx, sy}
                settings.selected.state = true
                addEventHandler('onClientRender', root, render)
            else 
                settings.selected.pos = {0, 0}
                settings.selected.state = nil
                removeEventHandler('onClientRender', root, render)
            end
        end 
    end 
end)

click = 0
render = function()
    x, y, w, h = settings.selected.pos[1], settings.selected.pos[2], 200, 112
    linedRectangle(x, y, w, h, tocolor(18, 18, 18, 220), tocolor(18, 18, 18, 255), 2)
    dxDrawRectangle(x, y, w, 30, tocolor(0, 0, 0, 150))
    dxDrawText('Unt:Creation', x, y + 5, x+w, y+h,tocolor(255, 255 ,255, 160),1, font2, "center", "top", false, false, false, true)
    for k,v in ipairs(settings.buttons) do 
        drawButton('Alern'..k, v.btn, x, y + 40+(k*35)-35, w, 30, {255, 255, 255}, {0, 0, 0})
        if isInBox(x, y + 40+(k*35)-35, w, 30) then 
            if getKeyState('mouse1') and click+800 <= getTickCount() then 
                click = getTickCount()
                if v.btn == settings.buttons[1].btn then 
					
					removeEventHandler('onClientRender', root, render)
					addEventHandler('onClientRender', root, render2)
					settings.selected.state = true
				elseif v.btn == settings.buttons[2].btn then 
					removeEventHandler('onClientRender', root, render)
                end
            end 
        end 
    end 
end 

local scrollNum = 0
local maxShowed = 12
veh_x, vey_y, veh_z = 179.7998046875, -88.3896484375, 1002.0234375

render2 = function()
	w, h = 350,400
	
	x, y, w, h = screen.x - w - 10, screen.y / 2 - h / 2, w, h
	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 150))
	x, y, w, h = x + 2, y + 2, w - 4, h - 4
	dxDrawRectangle(x, y, w, h, tocolor(10, 10, 10, 200))
	dxDrawRectangle(x, y, w, 35, tocolor(30, 30, 30, 200))
	dxDrawText('Unt:Creation - Kıyafet Mağazası ', x, y, w + x, 35 + y, tocolor(255, 255, 255), 1, font1, 'center', 'center')
	dxDrawText('Kıyafetler', x, y + 40, w + x, h + y, tocolor(200, 50, 50), 1, font2, 'center', 'top')
	x, y, w, h = x + 6, y + 6 + 35, w - 12, h - 12 - 35
	dxDrawRectangle(x, y, w, h, tocolor(30, 30, 30, 200))
	dxDrawText('ID', x + 10, y + 20 , w + x, h + y, tocolor(200, 200, 200), 1, font2, 'left', 'top')
	dxDrawText('Fiyat', x - 10, y + 20 , w + x - 10, 20 + y + 20, tocolor(200, 200, 200), 1, font2, 'right', 'top')
	dxDrawRectangle(x, y + 40, w, 1, tocolor(200, 200, 200, 200))
	local elem = 0
	local pngNum = 0
	eren = 0
	for key, value in pairs(skins) do 
	eren = eren + 1
		if value[2] == (getElementData(localPlayer, "gender") or 0) then 
			if (key > scrollNum and elem < maxShowed) then
				elem = elem + 1
				if isInBox(x, y + 50 + (elem * 25) - 25, w, 20) then
					 if getKeyState('mouse1') and click+800 <= getTickCount() then 
						click = getTickCount()
						settings.selected.veh_id = key
						settings.selected.skin_model = value[1]
						createSkin(value[1], 180.5107421875, -88.228515625, 1002.0234375)
					 end 
				end 
				if settings.selected.veh_id == key then 
					linedRectangle(x, y + 50 + (elem * 25) - 25, w, 20, tocolor(70, 70, 70, 150-70), tocolor(70, 70, 70, 150), 3)
				else 
					dxDrawRectangle(x, y + 50 + (elem * 25) - 25, w, 20, tocolor(50, 50, 50, 150))
				end
				dxDrawText("ID "..value[1], x + 10, y + 50 + (elem * 25) - 25 , w + x, 20 + y + 50 + (elem * 25) - 25, tocolor(200, 200, 200), 1, font2, 'left', 'center')
				dxDrawText(convertNumber(500)..'₺', x - 10, y + 50 + (elem * 25) - 25 , w + x - 10, 20 + y + 50 + (elem * 25) - 25, tocolor(200, 200, 200), 1, font2, 'right', 'center')
			end
		end
	end
	drawButton('Alern.remove', 'Arayüzü Kapat', x, y + h + 15, w, 30, {255, 255, 255}, {0, 0, 0})
	if isInBox(x, y + h + 15, w, 30) then
		if getKeyState('mouse1') and click+800 <= getTickCount() then 
			click = getTickCount()
			settings = {
				selected = {
					pos = {0,0},
					state = nil,
					veh_id = nil,
					skin_model = nil,
				},
				buttons = {
					{btn = 'Kıyafet satın al'},
					{btn = 'Kapat'}
				},
			}
			setCameraTarget(localPlayer)
			showChat(true)
			if isTimer(Timercik) then killTimer(Timercik) end
			if isElement(tempPed) then destroyElement(tempPed) end 
			removeEventHandler('onClientRender', root, render2)
		end 
	end 
	if settings.selected.veh_id then 
		drawButton('Alern.buyVehicle', 'Satın Al', x, y + h + 15 + 35, w, 30, {255, 255, 255}, {0, 0, 0})
		if isInBox(x, y + h + 15 + 35, w, 30) then
			if getKeyState('mouse1') and click+800 <= getTickCount() then 
				click = getTickCount()
				triggerServerEvent('skins >> satinal', localPlayer, localPlayer, settings.selected.skin_model)
				settings = {
					selected = {
						pos = {0,0},
						state = nil,
						veh_id = nil,
						skin_model = nil,
					},
					buttons = {
						{btn = 'Kıyafet satın al'},
						{btn = 'Kapat'}
					},
				}
				setCameraTarget(localPlayer)
				showChat(true)
				if isTimer(Timercik) then killTimer(Timercik) end
				if isElement(tempPed) then destroyElement(tempPed) end 
				removeEventHandler('onClientRender', root, render2)
			end 
		end 
	end 
	dxDrawScroll(x + w, y, 5, h, #skins, maxShowed, scrollNum, tocolor(100, 100, 100, 255), tocolor(200, 200, 200, 255))
end 

function dxDrawScroll(x, y, w, h, counts, maxCount, number, renk1, renk2)
	if(counts> maxCount) then
		dxDrawRectangle(x, y, w, h, renk1 or tocolor(0,0,0,200))
		dxDrawRectangle(x, y+((number)*(h/(counts))), w, h/math.max((counts/maxCount),1), renk2 or tocolor(124, 197, 118, 255))
	end
end

showChat(true)
setCameraTarget(localPlayer)

function createSkin (model, x, y, z)
	if isTimer(Timercik) then killTimer(Timercik) end
	if isElement(tempPed) then destroyElement(tempPed) end 
		tempPed = createPed(model,x,y,z)
		setElementInterior(tempPed, 18)
		setElementDimension(tempPed, 14)
		setCameraMatrix(175.86950683594, -88.27970123291, 1003.8013916016, 176.81080627441, -88.252174377441, 1003.4649658203)
    Timercik = Timer(function()
		if isElement(tempPed) then
			rx, ry, rz = getElementRotation(tempPed)
			setElementRotation(tempPed, rx, ry, rz+2)
		end
    end, 0, 0)
	showChat(false)
end

bindKey("mouse_wheel_down", "down",
	function()
		if settings.selected.state then
			if scrollNum < #skins - maxShowed then
				scrollNum = scrollNum + 1
			end
		end
	end
)

bindKey("mouse_wheel_up", "down",
	function()
	if settings.selected.state then
			if scrollNum > 0 then
				scrollNum = scrollNum - 1
			end
		end
	end
)

buttonkey = {}
drawButton = function (key, text, x, y, w, h, textColor, rectangleColor)
	if not buttonkey[key] then buttonkey[key] = {} buttonkey[key].alpha = 80 end  
	if isInBox(x, y, w, h) then 
	if buttonkey[key].alpha  < 255 then buttonkey[key].alpha = buttonkey[key].alpha + 5 end 
		linedRectangle(x, y, w, h, tocolor(rectangleColor[1], rectangleColor[2], rectangleColor[3], buttonkey[key].alpha-70), tocolor(rectangleColor[1], rectangleColor[2], rectangleColor[3], buttonkey[key].alpha), 2)
		dxDrawText(text, x, y, x+w, y+h, tocolor(textColor[1], textColor[2], textColor[3], buttonkey[key].alpha),1, font2, "center", "center", false, false, false, true)
	else 
		buttonkey[key].alpha = 0
		linedRectangle(x, y, w, h, tocolor(rectangleColor[1], rectangleColor[2], rectangleColor[3], 50), tocolor(rectangleColor[1], rectangleColor[2], rectangleColor[3], 80), 2)
		dxDrawText(text, x, y, x+w, y+h, tocolor(textColor[1], textColor[2], textColor[3], 150),1, font2, "center", "center", false, false, false, true)
	end 
end

linedRectangle = function (x,y,w,h,color,color2,size)
    if not color then
        color = tocolor(0,0,0,180)
    end
    if not color2 then
        color2 = color
    end
    if not size then
        size = 3
    end
	dxDrawRectangle(x, y, w, h, color)
	dxDrawRectangle(x - size, y - size, w + (size * 2), size, color2)
	dxDrawRectangle(x - size, y + h, w + (size * 2), size, color2)
	dxDrawRectangle(x - size, y, size, h, color2)
	dxDrawRectangle(x + w, y, size, h, color2)
end

isInBox = function (xS,yS,wS,hS)
	if(isCursorShowing()) then
		local cursorX, cursorY = getCursorPosition()
		sX,sY = guiGetScreenSize()
		cursorX, cursorY = cursorX*sX, cursorY*sY
		if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
			return true
		else
			return false
		end
	end	
end

convertNumber = function ( number )  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')    
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end