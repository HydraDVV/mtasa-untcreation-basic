local sw, sh = guiGetScreenSize()
local zoom = 1920/sw
local renderData = {}
local renderTarget = nil
local actualspeed = 0
local lastPosition = 0
local selectElement = nil
local updateRenderTarget = false
local content = {}
local data = {
    fonts = {
        light = dxCreateFont('data/fonts/light.ttf', 12/zoom),
        regular = dxCreateFont('data/fonts/regular.ttf', 12/zoom),
        bold = dxCreateFont('data/fonts/bold.ttf', 12/zoom),
        bold_big = dxCreateFont('data/fonts/bold.ttf', 22/zoom),
    },
    images = {
        assets = dxCreateTexture('data/images/images.png'),
        pointer = dxCreateTexture('data/images/pointer.png'),
        background = dxCreateTexture('data/images/background.png', 'dxt5'),
    }
}

local offsets = {
    [1] = {0, 0, 185, 146},
    [2] = {198, 0, 185, 146},
    [3] = {396, 0, 185, 146},
    [4] = {595, 0, 185, 146},
    [5] = {794, 0, 185, 146},
}

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

function isScreenElementInPosition(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function isMouseIn(x, y, w, h)
    if isCursorShowing(localPlayer) then
        local cursorX, cursorY = getCursorPosition()
        local mouseX, mouseY = cursorX * sw, cursorY * sh
        if (mouseX > x and mouseX < x + w) and (mouseY > y and mouseY < y + h) then
            return true
        end
        return false 
    end
    return false
end

local function dxVector(x, y, w, h)
	return {x = x, y = y, width = w, height = h}
end

function createButton(x, y, w, h, text, dropRight, dropRightState)
	if isMouseIn(x, y, w, h) then
	    dxDrawRectangle(x, y, w, h, tocolor(50, 50, 50, 180))
	else 
 		dxDrawRectangle(x, y, w, h, tocolor(50, 50, 50, 230))
	end
	dxDrawText(text, x + w/2, y + h/2, center, center, tocolor(190, 190, 190, 230), 1, data.fonts.light, "center", "center")
   	dxDrawRectangle(x, y, 2/zoom, h, tocolor(60, 60, 60, 230))
   	dxDrawRectangle(x, y, w, 2/zoom, tocolor(60, 60, 60, 230))	
   	dxDrawRectangle(x, y + h, w + 2/zoom, 2/zoom, tocolor(60, 60, 60, 230))
   	dxDrawRectangle(x + w, y, 2/zoom, h, tocolor(60, 60, 60, 230))
end

function createRectangle(x, y, w, h)
    dxDrawRectangle(x, y, w, h, tocolor(20, 20, 20, 200))
    dxDrawRectangle(x, y, 2/zoom, h, tocolor(60, 60, 60, 230))
    dxDrawRectangle(x, y, w, 2/zoom, tocolor(60, 60, 60, 230))	
    dxDrawRectangle(x, y + h, w + 2/zoom, 2/zoom, tocolor(60, 60, 60, 230))
    dxDrawRectangle(x + w, y, 2/zoom, h, tocolor(60, 60, 60, 230))
end

function createContent(elements)
	for i,v in ipairs(content) do
		if v == elements then
			return false
		end
	end
	table.insert(content, elements)
end

function createAlgorithm(seed)
	content = {}
    math.randomseed(seed)
    local elements = {}
    for i = 1, 7 do
        elements[i] = {image = math.random(1, 5), x = renderData["image"].width*(i-1), y = renderData["image"].height*0.2}
        lastPosition = renderData["image"].width*i-1
        createContent(elements[i].image)
    end
    return elements
end

function createAlgorithmMegaRPG()
	local elements = {}
	elements[1] = {image = 1, x = 0, y = renderData["image"].height*0.2}
	elements[2] = {image = 2, x = renderData["image"].width*1, y = renderData["image"].height*0.2}
	elements[3] = {image = 3, x = renderData["image"].width*2, y = renderData["image"].height*0.2}
	elements[4] = {image = 1, x = renderData["image"].width*3, y = renderData["image"].height*0.2}
	elements[5] = {image = 2, x = renderData["image"].width*4, y = renderData["image"].height*0.2}
	elements[6] = {image = 4, x = renderData["image"].width*5, y = renderData["image"].height*0.2}
	elements[7] = {image = 1, x = renderData["image"].width*6, y = renderData["image"].height*0.2}
	elements[8] = {image = 2, x = renderData["image"].width*7, y = renderData["image"].height*0.2}
	elements[9] = {image = 5, x = renderData["image"].width*8, y = renderData["image"].height*0.2}			
	lastPosition = renderData["image"].width*8
	for i,v in ipairs(elements) do
		 createContent(v.image)
	end
	return elements
end

function moveRoulette(dt)
    for i,v in ipairs(renderData["elements"]) do
        if v.x+renderData["image"].width < 0 then
            v.x = v.x+lastPosition-1*actualspeed
        else
            v.x = v.x-1*actualspeed
        end
    end
    updateRenderTarget = true
    actualspeed = math.max(actualspeed - 0.5 * (dt * 0.008), 0)
    if actualspeed <= 0 then
        updateRenderTarget = false
        removeEventHandler("onClientPreRender", root, moveRoulette)
        triggerServerEvent("onPlayerSelectedRoulet", localPlayer, selectElement)
    end
end

function showRoulette()
    if updateRenderTarget then
        dxSetRenderTarget(renderTarget, true)
        dxSetBlendMode("modulate_add")
        for i, v in ipairs(renderData["elements"]) do
            if isScreenElementInPosition(renderData["rouletteBar"].x+v.x, renderData["rouletteBar"].y, renderData["image"].width, renderData["image"].height, renderData["scan"].x, renderData["scan"].y, renderData["scan"].width, renderData["scan"].height) then
                selectElement = v.image
            end
            dxDrawImageSection(v.x, v.y, renderData["image"].width, renderData["image"].height, offsets[v.image][1], offsets[v.image][2], offsets[v.image][3], offsets[v.image][4], data.images.assets)
        end
        dxSetBlendMode("blend")
        dxSetRenderTarget(false)
        updateRenderTarget = false
    end
    local money = getElementData(localPlayer, 'money') or 0
    dxDrawRectangle(renderData["background"].x, renderData["background"].y, renderData["background"].width, renderData["background"].height, tocolor(20, 20, 20, 180))
    createButton(renderData["buttonLosuj"].x, renderData["buttonLosuj"].y, renderData["buttonLosuj"].width, renderData["buttonLosuj"].height, "Tıkla Oyna (₺70.000)", nil)
    createButton(renderData["buttonClose"].x, renderData["buttonClose"].y, renderData["buttonClose"].width, renderData["buttonClose"].height, "Arayüzü Kapat", nil)
    dxDrawImage(renderData["rouletteBar"].x, renderData["rouletteBar"].y, renderData["rouletteBar"].width, renderData["rouletteBar"].height, renderTarget)
    dxDrawImage(renderData["rouletteBar"].x, renderData["rouletteBar"].y, renderData["rouletteBar"].width, renderData["rouletteBar"].height, data.images.background)
    dxDrawImage(renderData["pointer"].x, renderData["pointer"].y, renderData["pointer"].width, renderData["pointer"].height, data.images.pointer)
    local width = dxGetTextWidth("Rulet System - UNT:Creation", 1, data.fonts.bold_big)
    dxDrawText("Rulet System - UNT:Creation", renderData["textBox"].x-width/2, renderData["textBox"].y, renderData["textBox"].width, renderData["textBox"].height, tocolor(255, 255, 255, 255), 1, data.fonts.bold_big)
    local width = dxGetTextWidth(string.format("Üzerinizdeki Para: %d", money), 1, data.fonts.bold)
    dxDrawText(string.format("Üzerinizdeki Para: %d", money), renderData["textKey"].x-width/2, renderData["textKey"].y, renderData["textKey"].width, renderData["textKey"].height, tocolor(255, 255, 255, 255), 1, data.fonts.bold)
 	local height = dxGetFontHeight(1, data.fonts.bold)
    local x, y = renderData["textContent"].x-renderData["image"].width/2, renderData["textContent"].y+height+25/zoom
    local offset = x
end

function onClientClick(btn, state)
    if btn == "left" and state == "down" then
        if isMouseIn(renderData["buttonLosuj"].x, renderData["buttonLosuj"].y, renderData["buttonLosuj"].width, renderData["buttonLosuj"].height) then
            if not isEventHandlerAdded("onClientPreRender", root, moveRoulette) and getElementDimension(localPlayer) == 35 and getElementData(localPlayer, "money") > 70000 then
            	setElementData(localPlayer, "money", tonumber(getElementData(localPlayer, "money") - 70000))
            	math.randomseed(os.clock()*math.random())
                actualspeed = math.random(55, 65)
                addEventHandler("onClientPreRender", root, moveRoulette)
            end
        end
        if isMouseIn(renderData["buttonClose"].x, renderData["buttonClose"].y, renderData["buttonClose"].width, renderData["buttonClose"].height) then
            removeEventHandler("onClientRender", root, showRoulette)
            removeEventHandler("onClientClick", root, onClientClick)
            showCursor(false)
        end
    end
end

function roulette()
    if getElementDimension(localPlayer) == 35 then
        if not isEventHandlerAdded("onClientRender", root, showRoulette) then
            addEventHandler("onClientRender", root, showRoulette)
            addEventHandler("onClientClick", root, onClientClick)
            showCursor(true)
            renderData["background"] = dxVector(0, 0, sw, sh)
            renderData["buttonLosuj"] = dxVector(860/zoom, 680/zoom, 200/zoom, 40/zoom)
            renderData["textBox"] = dxVector( (460+500)/zoom, 350/zoom, 800/zoom, 200/zoom)
            renderData["textKey"] = dxVector( (860+100)/zoom, 735/zoom, 800/zoom, 200/zoom)
            renderData["textContent"] = dxVector( (860+100)/zoom, 850/zoom, 800/zoom, 200/zoom)
            renderData["buttonClose"] = dxVector(10/zoom, sh-50/zoom, 200/zoom, 40/zoom)
            renderData["rouletteBar"] = dxVector(460/zoom, 440/zoom, 1000/zoom, 200/zoom)
            renderData["image"] = dxVector(0, 0, 185/zoom, 146/zoom)
            renderData["pointer"] = dxVector( (renderData["rouletteBar"].x+renderData["rouletteBar"].width/2) - (28/zoom)/2, (renderData["rouletteBar"].y+renderData["rouletteBar"].height/2)-(227/zoom)/2 , 28/zoom, 227/zoom)
            renderTarget = dxCreateRenderTarget(renderData["rouletteBar"].width, renderData["rouletteBar"].height, true)
            renderData["scan"] = dxVector(renderData["pointer"].x+13/zoom, renderData["pointer"].y+10/zoom, 2/zoom, 206/zoom)
            renderData["elements"] = createAlgorithmMegaRPG()
            updateRenderTarget = true
            selectElement = false
        else
            removeEventHandler("onClientRender", root, showRoulette)
            removeEventHandler("onClientClick", root, onClientClick)
            destroyElement( renderTarget )
            showCursor(false)
            renderData = {}
            updateRenderTarget = true
            selectElement = false
        end
    end
end
addCommandHandler("rulet", roulette)