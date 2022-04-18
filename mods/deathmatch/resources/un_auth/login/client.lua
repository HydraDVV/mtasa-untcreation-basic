local login = {}
local hover
f = "files/"
sx, sy = guiGetScreenSize()
lastClickTick = getTickCount()
screen = {guiGetScreenSize()}
s = {guiGetScreenSize()}
box = {250, 145}
pos = {s[1]/2 -box[1]/2,s[2]/2 - box[2]/2}
leftX, downY = (50) , (s[2]/2 - 40/2) * 2 

local sx, sy = guiGetScreenSize()
panelLogBox = {300,230}
panelLogin = {s[1]/2 -panelLogBox[1]/2,s[2]/2 - panelLogBox[2]/2}
panelRegBox = {300,280}
panelRegis = {s[1]/2 -panelRegBox[1]/2,s[2]/2 - panelRegBox[2]/2}
panelCharRegBox = {300,580}
panelLoginCharBox = {300,300}
panelLoginCharPanel = {s[1]/50.5 -panelLoginCharBox[1]/6.5,s[2]/1 - panelLoginCharBox[2]/2}
banBox = {450,195}

sx, sy = guiGetScreenSize()
screenSize = {sx, sy}
saveJSON = {}

function onLoginStart()
end
addEventHandler("onClientResourceStart", resourceRoot, onLoginStart)

function startLoginPanel()
    if getElementData(localPlayer, "loggedin") == 1 then
    else
        alpha = 0
        multipler = 2
        showCursor(true)
        setElementData(localPlayer, "keysDenied", true)
        setElementData(localPlayer, "hudVisible", false)
        page = "Login"
        addEventHandler("onClientRender", root, drawnLogin, true, "low-5")
        createTextBars(page)
        bindKey("enter", "down", loginInteraction)
        
        if not flashing then
            logoAnim = "összeilleszt";
            logoTick = getTickCount();
            setTimer(function()
                logoAnim = 'moveUP';
                logoTick = getTickCount();

                loginAnim = 'fadeIn';
                loginTick = getTickCount();

                setTimer(function() 
                    flashing = true  
                end, 1000, 1)
            end, 1700, 1)
        end
    end
end

function onLoginStop()
    exports['un_blur']:removeBlur("Loginblur")
end
addEventHandler("onClientResourceStop", resourceRoot, onLoginStop)

screenSize = {guiGetScreenSize()}
getCursorPos = getCursorPosition
function getCursorPosition()
    if isCursorShowing() then
        local x,y = getCursorPos()
        x, y = x * screenSize[1], y * screenSize[2] 
        return x,y
    else
        return -5000, -5000
    end
end

cursorState = isCursorShowing()
cursorX, cursorY = getCursorPosition()

function isInBox(dX, dY, dSZ, dM, eX, eY)
    if eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM then
        return true
    else
        return false
    end
end

function isInSlot(xS,yS,wS,hS)
    if isCursorShowing() then
        local cursorX, cursorY = getCursorPosition()
        if isInBox(xS,yS,wS,hS, cursorX, cursorY) then
            return true
        else
            return false
        end
    end 
end

function createTextBars(type)
    if type == "Login" then
        local text = ""
        if text:gsub(" ", "") == "" then
            text = "kullanıcı adı"
        end
        CreateNewBar("Login.Name", {0,0,0,0}, {30, text, false, tocolor(255,255,255,255), {"FontAwesome", 12}, 0.8, "center", "center", false}, 1)
        
        local text = ""
        if text:gsub(" ", "") == "" then
            text = "şifre"
        end
        CreateNewBar("Login.Password", {0,0,0,0}, {25, text, false, tocolor(255,255,255,255), {"FontAwesome", 12}, 0.8, "center", "center",false}, 2, true)
    elseif type == "Register" then
        local screen = {guiGetScreenSize()}
        local defSize = {0,0}
        local defMid = {0,0}
        
        local text = ""
        if text:gsub(" ", "") == "" then
            text = "kullanıcı adı"
        end
        CreateNewBar("Register.Name", {defMid[1], defMid[2], defSize[1], defSize[2]}, {30, text, false, tocolor(255,255,255,255), {"FontAwesome", 12}, 0.8, "center", "center", false}, 1)
        
        local text = ""
        if text:gsub(" ", "") == "" then
            text = "e-posta"
        end
        CreateNewBar("Register.Email", {defMid[1], defMid[2] + 32, defSize[1], defSize[2]}, {25, text, false, tocolor(255,255,255,255), {"FontAwesome", 12}, 0.8, "center", "center", false}, 2)
        
        local text = ""
        if text:gsub(" ", "") == "" then
            text = "şifre"
        end
        CreateNewBar("Register.Password1", {defMid[1], defMid[2] + 64, defSize[1], defSize[2]}, {25, text, false, tocolor(255,255,255,255), {"FontAwesome", 12}, 0.8, "center", "center", false}, 3)
        
        local text = ""
        if text:gsub(" ", "") == "" then
            text = "şifre tekrar"
        end
        CreateNewBar("Register.Password2", {defMid[1], defMid[2] + 96, defSize[1], defSize[2]}, {25, text, false, tocolor(255,255,255,255), {"FontAwesome", 12}, 0.8, "center", "center", false}, 4)
        
        local text = ""
        if text:gsub(" ", "") == "" then
            text = ""
        end
		
        CreateNewBar("Register.InviteCode", {defMid[1], defMid[2] + 128, defSize[1], defSize[2]}, {25, text, true, tocolor(255,255,255,255), {"FontAwesome", 12}, 0.8, "center", "center"}, 4, true)
    elseif type == "Age" then
        -- CreateNewBar("Char-Reg.Age", {sx/2 - 300/2, sy/2 - 40/2, 300, 40}, {2, "", true, tocolor(255,255,255,255), {"FontAwesome", 12}, 1, "center", "center", false}, 1, true)
     end
end

function dxDrawBorder(x, y, w, h, radius, color)
	dxDrawRectangle(x - radius, y, radius, h, color)
	dxDrawRectangle(x + w, y, radius, h, color)
	dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
	dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end

function dxCreateBorder(x,y,w,h,color)
	dxDrawRectangle(x,y-1,w+1,1,color) -- Fent
	dxDrawRectangle(x,y+1,1,h,color) -- Bal Oldal
	dxDrawRectangle(x+1,y+h,w,1,color) -- Lent Oldal
	dxDrawRectangle(x+w,y-1,1,h+1,color) -- Jobb Oldal
end

local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil

local function removeCamHandler()
    if(sm.moov == 1)then
	   sm.moov = 0
       showLoginChar = true  
    end
end

local function camRender()
    if (sm.moov == 1) then
	   local x1,y1,z1 = getElementPosition(sm.object1)
	   local x2,y2,z2 = getElementPosition(sm.object2)
	   setCameraMatrix(x1,y1,z1,x2,y2,z2)
    end
end
addEventHandler("onClientPreRender",root,camRender)

function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
    if(sm.moov == 1)then return false end
        sm.object1 = createObject(1337,x1,y1,z1)
        setElementData(sm.object1,"camObj",true)
        sm.object2 = createObject(1337,x1t,y1t,z1t)
        setElementAlpha(sm.object1,0)
        setElementAlpha(sm.object2,0)
        setObjectScale(sm.object1,0.01)
        setObjectScale(sm.object2,0.01)
        moveObject(sm.object1,time,x2,y2,z2,0,0,0,"InOutQuad")
        moveObject(sm.object2,time,x2t,y2t,z2t,0,0,0,"InOutQuad")
        sm.moov = 1
        setTimer(removeCamHandler,time,1)
        setTimer(destroyElement,time,1,sm.object1)
        setTimer(destroyElement,time,1,sm.object2)
    return true
end

function dxCreateBorder(x, y, w, h, radius, color)
	dxDrawRectangle(x - radius, y, radius, h, color)
	dxDrawRectangle(x + w, y, radius, h, color)
	dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
	dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end

function playVideo (posX, posY, width, height, url, duration, canClose, postGUI)
    if not posX or not posY or not width or not height or not url then
        return false
    end
    local webBrowser = false
    if not isElement (webBrowser) then
        webBrowser = createBrowser (width, height, false, false)
        addEventHandler("onClientBrowserCreated", webBrowser, function()
            loadBrowserURL (source, url)
            addEventHandler ( "onClientBrowserDocumentReady" , source , function (url) 
                function webBrowserRender ()
                    dxDrawImage (posX, posY, width, height, webBrowser, 0, 0, 0, tocolor(255,255,255,255), postGUI)
                end
                addEventHandler ("onClientRender", getRootElement(), webBrowserRender)
            end)
        end)    
    end
end

function stopLoginPanel()
    --outputChatBox(page)
    if page == "Login" then
        RemoveBar("Login.Name")
        RemoveBar("Login.Password")
        removeEventHandler("onClientRender", root, drawnLogin)
        unbindKey("enter", "down", loginInteraction)
        --stopLogoAnimation()
    end
end

function drawnLogin()
    hover = nil
    --generateFonts()
    
    if logoAnim == 'összeilleszt' then
        logoSize = {125, 125};
        logoDef = {screen[1]/2 - logoSize[1]/2, screen[2]/2 - logoSize[2]/2}
        defLeft = {interpolateBetween(logoDef[1] - 50, logoDef[2] + 50,0, logoDef[1], logoDef[2],255, (getTickCount() - logoTick) / 1700, 'OutQuad')}
        defRight = {interpolateBetween(logoDef[1] + 50, logoDef[2] - 50,0, logoDef[1], logoDef[2],255, (getTickCount() - logoTick) / 1700, 'OutQuad')}
    elseif logoAnim == 'moveUP' then
        logoSize = {125, 125};
        logoDef = {screen[1]/2 - logoSize[1]/2, screen[2]/2 - logoSize[2]/2}
        moveProgress = (getTickCount() - loginTick) / 1200;
        defLeft = {interpolateBetween(logoDef[1], logoDef[2],255, logoDef[1], logoDef[2] - 110,255, (getTickCount() - logoTick) / 1200, 'OutQuad')}
        defRight = {interpolateBetween(logoDef[1], logoDef[2],255, logoDef[1], logoDef[2] - 110,255, (getTickCount() - logoTick) / 1200, 'OutQuad')}
        
        --updateLogoPos({defMid[1] + (defSize[1]/2), loginPos[1] - 50})
    elseif logoAnim == 'hide' then
        logoSize = {125, 125};
        logoDef = {screen[1]/2 - logoSize[1]/2, screen[2]/2 - logoSize[2]/2}
        moveProgress = (getTickCount() - loginTick) / 1200;
        defLeft = {interpolateBetween(logoDef[1], logoDef[2] - 110,255, logoDef[1], logoDef[2],0, (getTickCount() - logoTick) / 1500, 'OutQuad')}
        defRight = {interpolateBetween(logoDef[1], logoDef[2] - 110,255, logoDef[1], logoDef[2],0, (getTickCount() - logoTick) / 1500, 'OutQuad')}
    end

    if loginAnim == 'fadeIn' then
        defSize = {250, 28}
        defMid = {screen[1]/2 - defSize[1]/2, screen[2]/2 - defSize[2]/2}

        loginPos = {interpolateBetween(defMid[2] + 50,0,0, defMid[2],220,255, (getTickCount() - loginTick) / 1200, 'OutQuad')}
        loginAlpha = {interpolateBetween(0,0,0, 40,0,0, (getTickCount() - loginTick) / 1200, 'OutQuad')}
        
        --[[if (getTickCount() - loginTick) / 1200 >= 1 then
            updateLogoPos({defMid[1] + (defSize[1]/2), loginPos[1] - 90})
        end--]]
    elseif loginAnim == 'fadeIn2' then
        defSize = {250, 28}
        defaultt = {screen[1]/2 - defSize[1]/2, screen[2]/2 - defSize[2]/2}
        defMid = {interpolateBetween(defaultt[1] + (defSize[1] + 10),defaultt[2],0, defaultt[1],defaultt[2],0, (getTickCount() - loginTick) / 2400, 'OutQuad')}

        loginPos = {interpolateBetween(defMid[2],0,0, defMid[2],220,255, (getTickCount() - loginTick) / 1700, 'OutQuad')}
        loginAlpha = {interpolateBetween(0,0,0, 40,0,0, (getTickCount() - loginTick) / 1700, 'OutQuad')}
        
        if (getTickCount() - loginTick) / 1200 >= 1 then
            --updateLogoPos({defMid[1] + (defSize[1]/2), loginPos[1] - 90})
        end
    elseif loginAnim == 'fadeOut' then
        defSize = {250, 28}
        defaultt = {screen[1]/2 - defSize[1]/2, screen[2]/2 - defSize[2]/2}
        defMid = {interpolateBetween(defaultt[1],defaultt[2],0, defaultt[1] + (defSize[1] + 10),defaultt[2],0, (getTickCount() - loginTick) / 2400, 'OutQuad')}

        loginPos = {interpolateBetween(defMid[2],220,255, defMid[2],0,0, (getTickCount() - loginTick) / 1700, 'OutQuad')}
        loginAlpha = {interpolateBetween(40,0,0, 0,0,0, (getTickCount() - loginTick) / 1700, 'OutQuad')}
    else

    end

    if (moveProgress) then
        local font = exports['un_fonts']:getFont("FontAwesome", 12)
		local zX, zY = guiGetScreenSize()

        UpdatePos("Login.Name", {defMid[1], loginPos[1], defSize[1], defSize[2]})
        UpdatePos("Login.Password", {defMid[1], loginPos[1] + 32, defSize[1], defSize[2]})
        UpdateAlpha("Login.Name", tocolor(200, 200, 200, 255))
        UpdateAlpha("Login.Password", tocolor(200, 200, 200, 255))
        
		-- arkaplan
		setCameraMatrix(0, 0, 0, 0, 0, 0)
		dxDrawImage(0, 0,zX, zY, "files/bg.png",0,0,0, tocolor(255,255,255,255))
		dxDrawRectangle(0, 0, zX, zY, tocolor(0, 0, 0, 210), false);
		
		-- çerçeve
        dxDrawRoundedRectangle(defMid[1] - 20, loginPos[1] - 50, defSize[1] + 40, defSize[2] + 150, tocolor(22, 22, 22, 255), { 0.3, 0.3, 0.3, 0.3 }, false);
        dxDrawRoundedRectangle(defMid[1] - 20, loginPos[1] - 50, defSize[1] + 40, defSize[2], tocolor(11, 11, 11, 255), { 0.3, 0.3, 0.3, 0.3 }, false);
		dxDrawImage(defMid[1] + 245, loginPos[1] - 47, 20, 20, "files/c.png", 0, 0, 0, tocolor(57, 200, 57, 255), false)
		dxDrawImage(defMid[1] + 220, loginPos[1] - 47, 20, 20, "files/c.png", 0, 0, 0, tocolor(200, 57, 57, 255), false)
		dxDrawImage(defMid[1] + 195, loginPos[1] - 47, 20, 20, "files/c.png", 0, 0, 0, tocolor(200, 170, 57, 255), false)
		dxDrawImage(defMid[1] + 20, loginPos[1] - 250, 212, 212, "files/logo.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		
        dxDrawRoundedRectangle(defMid[1], loginPos[1], defSize[1], defSize[2], tocolor(33, 33, 33, 255), { 0.3, 0.3, 0.3, 0.3 }, false);
        dxDrawRoundedRectangle(defMid[1], loginPos[1] + 32, defSize[1], defSize[2], tocolor(33, 33, 33, 255), { 0.3, 0.3, 0.3, 0.3 }, false);
        if isInSlot(defMid[1], loginPos[1], defSize[1], defSize[2]) then
            dxDrawRoundedRectangle(defMid[1], loginPos[1], defSize[1], defSize[2], tocolor(38, 38, 38, 255), { 0.3, 0.3, 0.3, 0.3 }, false);
        elseif isInSlot(defMid[1], loginPos[1] + 32, defSize[1], defSize[2]) then
            dxDrawRoundedRectangle(defMid[1], loginPos[1] + 32, defSize[1], defSize[2], tocolor(38, 38, 38, 255), { 0.3, 0.3, 0.3, 0.3 }, false);
        end

        if isInSlot(defMid[1], loginPos[1] + 60, defSize[1] - 200, defSize[2] - 10) then
            hover = "Login"
			dxDrawText('giriş yap', defMid[1] - 100, loginPos[1] + 135, defMid[1] + defSize[1] - 100, loginPos[1], tocolor(200, 200, 200, 200),1, exports['un_fonts']:getFont('Roboto',9), 'center', 'center')
        end

        if isInSlot(defMid[1] + 122, loginPos[1] + 60, defSize[1] - 120, defSize[2] - 10) then
            hover = "Register"
			dxDrawText('hesabın yok mu? kayıt ol!', defMid[1] + 75, loginPos[1] + 135, defMid[1] + defSize[1] + 50, loginPos[1], tocolor(200, 200, 200, 200),1, exports['un_fonts']:getFont('Roboto',9), 'center', 'center')
        end

        dxDrawText("", defMid[1] + 9, loginPos[1] + 3, 0,0, tocolor(200, 200, 200, 255),1, font)
        dxDrawText("", defMid[1] + 10, loginPos[1] + 36, 0,0, tocolor(200, 200, 200, 255),1, font)
		
        dxDrawText('©UNT', defMid[1] + 255, loginPos[1] - 45, defMid[1] - defSize[1], loginPos[1] - defSize[2], tocolor(200, 200, 200, 200),1, exports['un_fonts']:getFont('Roboto',11), 'center', 'center')
        dxDrawText('giriş yap', defMid[1] - 100, loginPos[1] + 135, defMid[1] + defSize[1] - 100, loginPos[1], tocolor(200, 200, 200, 200),1, exports['un_fonts']:getFont('Roboto',9), 'center', 'center')
        dxDrawText('hesabın yok mu? kayıt ol!', defMid[1] + 75, loginPos[1] + 135, defMid[1] + defSize[1] + 50, loginPos[1], tocolor(200, 200, 200, 200),1, exports['un_fonts']:getFont('Roboto',9), 'center', 'center')
		
    end
end

function random ()
r, g, b = math.random(0,255), math.random(0,255), math.random(0,255)
end
setTimer(random, 1000, 0)

forgotState = "Search>1"
forgotMatch = nil
forgotCode = nil
forgetAttempts = 0
function createForgotPanel()
    forgetAttempts = 0
    forgotState = "Search>1"
    forgotMatch = nil
    forgotCode = nil
    addEventHandler("onClientRender", root, drawForgotPanel, true, "low-5")
end

local start, startTick
function destroyForgetPanel()
    start = false
    startTick = getTickCount()
end

startAnimationTime = 500
startAnimation = "InOutQuad"
function drawForgotPanel()
    local alpha
    local nowTick = getTickCount()
    if start then
        local elapsedTime = nowTick - startTick
        local duration = (startTick + startAnimationTime) - startTick
        local progress = elapsedTime / duration
        local alph = interpolateBetween(
            0, 0, 0,
            255, 0, 0,
            progress, startAnimation
        )
        
        alpha = alph
    else
        
        local elapsedTime = nowTick - startTick
        local duration = (startTick + startAnimationTime) - startTick
        local progress = elapsedTime / duration
        local alph = interpolateBetween(
            255, 0, 0,
            0, 0, 0,
            progress, startAnimation
        )
        
        alpha = alph
        
        if progress >= 1 then
            alpha = 0
            removeEventHandler("onClientRender",root,drawForgotPanel)
            triggerServerEvent("destroyCode", localPlayer, localPlayer, nil, true)
            RemoveBar("ForgetPass")
            RemoveBar("ForgetCode")
            RemoveBar("ChangePass")
            page = oPage
            oPage = nil
            return
        end
    end
    
    local font = exports['un_fonts']:getFont("RobotoB", 11)
    local font2 = exports['un_fonts']:getFont("Roboto", 10)
    
    if forgotState == "Search>1" then
        local w,h = 241, 135
    
        local r,g,b = exports['un_core']:getServerColor("blue")
        local text = "Találat:"
        local blue = exports['un_core']:getServerColor("blue", true)
        if forgotMatch then
            if type(forgotMatch) == "string" then -- nincs
                text = "Nincs találat "..blue..forgotMatch.."#9c9c9c-ra/re"
            elseif type(forgotMatch) == "table" then -- van
                local accName, emailName = unpack(forgotMatch)
                text = "Találat: " .. blue .. accName
            end
        end

        local textWidth = dxGetTextWidth(text, 1, font2, true)

        if textWidth + 20 >= w then
            w = textWidth + 20
        end

        dxDrawRectangle(sx - 10 - w, sy - 60 - 10 - h, w, h, tocolor(44,44,44,alpha))
        dxDrawRectangle(sx - 10 - w + 1, sy - 60 - 10 - h + 1, w - 2, 32, tocolor(0,0,0,alpha*0.3))
        
        specHover = nil
        if isInSlot(sx - 10 - 18, sy - 60 - 10 - h + 1, 18, 18, tocolor(0,0,0,alpha*0.3)) then
            specHover = "close"
            local r,g,b = exports['un_core']:getServerColor("red")
            dxDrawImage(sx - 10 - 241 + 1, sy - 60 - 10 - h + 1, 241 - 2, 32, "files/close.png", 0,0,0, tocolor(r,g,b,alpha))
        else
            dxDrawImage(sx - 10 - 241 + 1, sy - 60 - 10 - h + 1, 241 - 2, 32, "files/close.png", 0,0,0, tocolor(156,156,156,alpha))
        end
        dxDrawText("Elfelejtett jelszó", sx - 10 - w, sy - 60 - 10 - h + 1, sx - 10, sy - 60 - 10 - h + 1 + 32, tocolor(156,156,156,alpha), 1, font, "center", "center")
        UpdatePos("ForgetPass", {sx - 10 - w + 3, sy - 60 - 10 - h + 1 + 32 + 3, w - 6, 32})
        if isInSlot(sx - 10 - w + 3, sy - 60 - 10 - h + 1 + 32 + 3, w - 6, 32) then
            local r,g,b = exports['un_core']:getServerColor("blue")
            dxDrawRectangle(sx - 10 - w + 3, sy - 60 - 10 - h + 1 + 32 + 3, w - 6, 32, tocolor(r,g,b,alpha*0.6))
            dxDrawImage(sx - 10 - w + 3, sy - 60 - 10 - h + 1 + 32 + 3, 241 - 6, 32, "files/pen.png", 0,0,0, tocolor(0,0,0,alpha))
            UpdateAlpha("ForgetPass", tocolor(0, 0, 0, alpha))
        else
            dxDrawRectangle(sx - 10 - w + 3, sy - 60 - 10 - h + 1 + 32 + 3, w - 6, 32, tocolor(0,0,0,alpha*0.3))
            dxDrawImage(sx - 10 - w + 3, sy - 60 - 10 - h + 1 + 32 + 3, 241 - 6, 32, "files/pen.png", 0,0,0, tocolor(156,156,156,alpha))
            UpdateAlpha("ForgetPass", tocolor(156, 156, 156, alpha))
        end
        if isInSlot(sx - 10 - w + 3, sy - 60 - 10 - h + 1 + 32 + 3 + 32 + 1, w - 6, 32) then
            local r,g,b = exports['un_core']:getServerColor("blue")
            local text = "Találat:"
            local blue = exports['un_core']:getServerColor("blue", true)
            if forgotMatch then
                if type(forgotMatch) == "string" then -- nincs
                    text = "Nincs találat "..forgotMatch.."-ra/re"
                elseif type(forgotMatch) == "table" then -- van
                    local accName, emailName = unpack(forgotMatch)
                    text = "Találat: " .. accName
                end
            end
            dxDrawRectangle(sx - 10 - w + 3, sy - 60 - 10 - h + 1 + 32 + 3 + 32 + 1, w - 6, 32, tocolor(r,g,b,alpha*0.6))
            dxDrawText(text, sx - 10 - w + 3, sy - 60 - 10 - h + 1 + 32 + 3 + 32 + 1, sx - 10 - w + 3 + w - 6, sy - 60 - 10 - h + 1 + 32 + 3 + 32 + 1 + 32, tocolor(0,0,0,alpha), 1, font2, "center", "center", false, false, false, true)
        else
            local text = "Találat:"
            local blue = exports['un_core']:getServerColor("blue", true)
            if forgotMatch then
                if type(forgotMatch) == "string" then -- nincs
                    text = "Nincs találat "..blue..forgotMatch.."#9c9c9c-ra/re"
                elseif type(forgotMatch) == "table" then -- van
                    local accName, emailName = unpack(forgotMatch)
                    text = "Találat: " .. blue .. accName
                end
            end
            dxDrawRectangle(sx - 10 - w + 3, sy - 60 - 10 - h + 1 + 32 + 3 + 32 + 1, w - 6, 32, tocolor(0,0,0,alpha*0.3))
            dxDrawText(text, sx - 10 - w + 3, sy - 60 - 10 - h + 1 + 32 + 3 + 32 + 1, sx - 10 - w + 3 + w - 6, sy - 60 - 10 - h + 1 + 32 + 3 + 32 + 1 + 32, tocolor(156,156,156,alpha), 1, font2, "center", "center", false, false, false, true)
        end
        if isInSlot(sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 1 + 32 + 3 + 32 + 1 + 32 + 3, 174, 27) then
            specHover = "Search"
            local r,g,b = exports['un_core']:getServerColor("blue")
            dxDrawRectangle(sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 1 + 32 + 3 + 32 + 1 + 32 + 3, 174, 27, tocolor(r,g,b,alpha*0.6))
            dxDrawText("Keresés", sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 1 + 32 + 3 + 32 + 1 + 32 + 3, sx - 10 - w/2 - 174/2 + 174, sy - 60 - 10 - h + 1 + 32 + 3 + 32 + 1 + 32 + 3 + 27, tocolor(0,0,0,alpha), 1, font2, "center", "center")
        else
            dxDrawRectangle(sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 1 + 32 + 3 + 32 + 1 + 32 + 3, 174, 27, tocolor(0,0,0,alpha*0.3))
            dxDrawText("Keresés", sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 1 + 32 + 3 + 32 + 1 + 32 + 3, sx - 10 - w/2 - 174/2 + 174, sy - 60 - 10 - h + 1 + 32 + 3 + 32 + 1 + 32 + 3 + 27, tocolor(156, 156, 156, alpha), 1, font2, "center", "center")
        end
    elseif forgotState == "Send" then
        local w,h = 241, 102
    
        local r,g,b = exports['un_core']:getServerColor("blue")
        local text = "Találat:"
        local blue = exports['un_core']:getServerColor("blue", true)
        if forgotMatch then
            if type(forgotMatch) == "string" then -- nincs
                text = "Nincs találat "..blue..forgotMatch.."#9c9c9c-ra/re"
            elseif type(forgotMatch) == "table" then -- van
                local accName, emailName = unpack(forgotMatch)
                text = "Találat: " .. blue .. accName
            end
        end

        local textWidth = dxGetTextWidth(text, 1, font2, true)

        if textWidth + 20 >= w then
            w = textWidth + 20
        end

        dxDrawRectangle(sx - 10 - w, sy - 60 - 10 - h, w, h, tocolor(44,44,44,alpha))
        dxDrawRectangle(sx - 10 - w + 1, sy - 60 - 10 - h + 1, w - 2, 32, tocolor(0,0,0,alpha*0.3))
        
        specHover = nil
        if isInSlot(sx - 10 - 18, sy - 60 - 10 - h + 1, 18, 18, tocolor(0,0,0,alpha*0.3)) then
            specHover = "close"
            local r,g,b = exports['un_core']:getServerColor("red")
            dxDrawImage(sx - 10 - 241 + 1, sy - 60 - 10 - h + 1, 241 - 2, 32, "files/close.png", 0,0,0, tocolor(r,g,b,alpha))
        else
            dxDrawImage(sx - 10 - 241 + 1, sy - 60 - 10 - h + 1, 241 - 2, 32, "files/close.png", 0,0,0, tocolor(156,156,156,alpha))
        end
        dxDrawText("Elfelejtett jelszó", sx - 10 - w, sy - 60 - 10 - h + 1, sx - 10, sy - 60 - 10 - h + 1 + 32, tocolor(156,156,156,alpha), 1, font, "center", "center")
        if isInSlot(sx - 10 - w + 3, sy - 60 - 10 - h  + 3 + 32 + 1, w - 6, 32) then
            local r,g,b = exports['un_core']:getServerColor("blue")
            local text = "Találat:"
            local blue = exports['un_core']:getServerColor("blue", true)
            if forgotMatch then
                if type(forgotMatch) == "string" then -- nincs
                    text = "Nincs találat "..forgotMatch.."-ra/re"
                elseif type(forgotMatch) == "table" then -- van
                    local accName, emailName = unpack(forgotMatch)
                    text = "Találat: " .. accName
                end
            end
            dxDrawRectangle(sx - 10 - w + 3, sy - 60 - 10 - h  + 3 + 32 + 1, w - 6, 32, tocolor(r,g,b,alpha*0.6))
            dxDrawText(text, sx - 10 - w + 3, sy - 60 - 10 - h  + 3 + 32 + 1, sx - 10 - w + 3 + w - 6, sy - 60 - 10 - h  + 3 + 32 + 1 + 32, tocolor(0,0,0,alpha), 1, font2, "center", "center", false, false, false, true)
        else
            local text = "Találat:"
            local blue = exports['un_core']:getServerColor("blue", true)
            if forgotMatch then
                if type(forgotMatch) == "string" then -- nincs
                    text = "Nincs találat "..blue..forgotMatch.."#9c9c9c-ra/re"
                elseif type(forgotMatch) == "table" then -- van
                    local accName, emailName = unpack(forgotMatch)
                    text = "Találat: " .. blue .. accName
                end
            end
            dxDrawRectangle(sx - 10 - w + 3, sy - 60 - 10 - h + 3 + 32 + 1, w - 6, 32, tocolor(0,0,0,alpha*0.3))
            dxDrawText(text, sx - 10 - w + 3, sy - 60 - 10 - h + 3 + 32 + 1, sx - 10 - w + 3 + w - 6, sy - 60 - 10 - h + 3 + 32 + 1 + 32, tocolor(156,156,156,alpha), 1, font2, "center", "center", false, false, false, true)
        end
        if isInSlot(sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3, 174, 27) then
            specHover = "Send"
            local r,g,b = exports['un_core']:getServerColor("blue")
            dxDrawRectangle(sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3, 174, 27, tocolor(r,g,b,alpha*0.6))
            dxDrawText("Email küldése", sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3, sx - 10 - w/2 - 174/2 + 174, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3 + 27, tocolor(0,0,0,alpha), 1, font2, "center", "center")
        else
            dxDrawRectangle(sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3, 174, 27, tocolor(0,0,0,alpha*0.3))
            dxDrawText("Email küldése", sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3, sx - 10 - w/2 - 174/2 + 174, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3 + 27, tocolor(156, 156, 156, alpha), 1, font2, "center", "center")
        end
    elseif forgotState == "Code" then
        local w,h = 241, 102

        dxDrawRectangle(sx - 10 - w, sy - 60 - 10 - h, w, h, tocolor(44,44,44,alpha))
        dxDrawRectangle(sx - 10 - w + 1, sy - 60 - 10 - h + 1, w - 2, 32, tocolor(0,0,0,alpha*0.3))
        
        specHover = nil
        if isInSlot(sx - 10 - 18, sy - 60 - 10 - h + 1, 18, 18, tocolor(0,0,0,alpha*0.3)) then
            specHover = "close"
            local r,g,b = exports['un_core']:getServerColor("red")
            dxDrawImage(sx - 10 - 241 + 1, sy - 60 - 10 - h + 1, 241 - 2, 32, "files/close.png", 0,0,0, tocolor(r,g,b,alpha))
        else
            dxDrawImage(sx - 10 - 241 + 1, sy - 60 - 10 - h + 1, 241 - 2, 32, "files/close.png", 0,0,0, tocolor(156,156,156,alpha))
        end
        dxDrawText("Elfelejtett jelszó", sx - 10 - w, sy - 60 - 10 - h + 1, sx - 10, sy - 60 - 10 - h + 1 + 32, tocolor(156,156,156,alpha), 1, font, "center", "center")
        UpdatePos("ForgetCode", {sx - 10 - w + 3, sy - 60 - 10 - h  + 3 + 32 + 1, w - 6, 32})
        if isInSlot(sx - 10 - w + 3, sy - 60 - 10 - h  + 3 + 32 + 1, w - 6, 32) then
            local r,g,b = exports['un_core']:getServerColor("blue")
            dxDrawRectangle(sx - 10 - w + 3, sy - 60 - 10 - h  + 3 + 32 + 1, w - 6, 32, tocolor(r,g,b,alpha*0.6))
            dxDrawImage(sx - 10 - w + 3, sy - 60 - 10 - h  + 3 + 32 + 1, 241 - 6, 32, "files/pen.png", 0,0,0, tocolor(0,0,0,alpha))
            UpdateAlpha("ForgetCode", tocolor(0, 0, 0, alpha))
        else
            dxDrawRectangle(sx - 10 - w + 3, sy - 60 - 10 - h + 3 + 32 + 1, w - 6, 32, tocolor(0,0,0,alpha*0.3))
            dxDrawImage(sx - 10 - w + 3, sy - 60 - 10 - h  + 3 + 32 + 1, 241 - 6, 32, "files/pen.png", 0,0,0, tocolor(156, 156, 156,alpha))
            UpdateAlpha("ForgetCode", tocolor(156, 156, 156, alpha))
        end
        if isInSlot(sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3, 174, 27) then
            specHover = "Send"
            local r,g,b = exports['un_core']:getServerColor("blue")
            dxDrawRectangle(sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3, 174, 27, tocolor(r,g,b,alpha*0.6))
            dxDrawText("Kód ellenőrzése", sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3, sx - 10 - w/2 - 174/2 + 174, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3 + 27, tocolor(0,0,0,alpha), 1, font2, "center", "center")
        else
            dxDrawRectangle(sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3, 174, 27, tocolor(0,0,0,alpha*0.3))
            dxDrawText("Kód ellenőrzése", sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3, sx - 10 - w/2 - 174/2 + 174, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3 + 27, tocolor(156, 156, 156, alpha), 1, font2, "center", "center")
        end
    elseif forgotState == "Password" then
        local w,h = 241, 102

        dxDrawRectangle(sx - 10 - w, sy - 60 - 10 - h, w, h, tocolor(44,44,44,alpha))
        dxDrawRectangle(sx - 10 - w + 1, sy - 60 - 10 - h + 1, w - 2, 32, tocolor(0,0,0,alpha*0.3))
        
        specHover = nil
        if isInSlot(sx - 10 - 18, sy - 60 - 10 - h + 1, 18, 18, tocolor(0,0,0,alpha*0.3)) then
            specHover = "close"
            local r,g,b = exports['un_core']:getServerColor("red")
            dxDrawImage(sx - 10 - 241 + 1, sy - 60 - 10 - h + 1, 241 - 2, 32, "files/close.png", 0,0,0, tocolor(r,g,b,alpha))
        else
            dxDrawImage(sx - 10 - 241 + 1, sy - 60 - 10 - h + 1, 241 - 2, 32, "files/close.png", 0,0,0, tocolor(156,156,156,alpha))
        end
        dxDrawText("Elfelejtett jelszó", sx - 10 - w, sy - 60 - 10 - h + 1, sx - 10, sy - 60 - 10 - h + 1 + 32, tocolor(156,156,156,alpha), 1, font, "center", "center")
        UpdatePos("ChangePass", {sx - 10 - w + 3, sy - 60 - 10 - h  + 3 + 32 + 1, w - 6, 32})
        if isInSlot(sx - 10 - w + 3, sy - 60 - 10 - h  + 3 + 32 + 1, w - 6, 32) then
            local r,g,b = exports['un_core']:getServerColor("blue")
            dxDrawRectangle(sx - 10 - w + 3, sy - 60 - 10 - h  + 3 + 32 + 1, w - 6, 32, tocolor(r,g,b,alpha*0.6))
            dxDrawImage(sx - 10 - w + 3, sy - 60 - 10 - h  + 3 + 32 + 1, 241 - 6, 32, "files/pen.png", 0,0,0, tocolor(0,0,0,alpha))
            UpdateAlpha("ChangePass", tocolor(0, 0, 0, alpha))
        else
            dxDrawRectangle(sx - 10 - w + 3, sy - 60 - 10 - h + 3 + 32 + 1, w - 6, 32, tocolor(0,0,0,alpha*0.3))
            dxDrawImage(sx - 10 - w + 3, sy - 60 - 10 - h  + 3 + 32 + 1, 241 - 6, 32, "files/pen.png", 0,0,0, tocolor(156, 156, 156,alpha))
            UpdateAlpha("ChangePass", tocolor(156, 156, 156, alpha))
        end
        if isInSlot(sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3, 174, 27) then
            specHover = "Send"
            local r,g,b = exports['un_core']:getServerColor("blue")
            dxDrawRectangle(sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3, 174, 27, tocolor(r,g,b,alpha*0.6))
            dxDrawText("Jelszó megváltoztatása", sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3, sx - 10 - w/2 - 174/2 + 174, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3 + 27, tocolor(0,0,0,alpha), 1, font2, "center", "center")
        else
            dxDrawRectangle(sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3, 174, 27, tocolor(0,0,0,alpha*0.3))
            dxDrawText("Jelszó megváltoztatása", sx - 10 - w/2 - 174/2, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3, sx - 10 - w/2 - 174/2 + 174, sy - 60 - 10 - h + 3 + 32 + 1 + 32 + 3 + 27, tocolor(156, 156, 156, alpha), 1, font2, "center", "center")
        end
    end
end

addEvent("ForgetPass>Search", true)
addEventHandler("ForgetPass>Search", localPlayer,
    function(e, val)
        forgotMatch = val
        
        if type(forgotMatch) == "table" then -- van
            forgotState = "Send"
            RemoveBar("ForgetPass")
            RemoveBar("ForgetCode")
            RemoveBar("ChangePass")
        end
    end
)

addEvent("ForgetPass>Send", true)
addEventHandler("ForgetPass>Send", localPlayer,
    function(e, val)
        forgetAttempts = 0
        forgotCode = val
        forgotState = "Code"
        CreateNewBar("ForgetCode", {0,0,0,0}, {10, "Kódom", false, tocolor(156,156,156,0), {"Roboto", 10}, 1, "center", "center"}, -10)
    end
)

function login.onClick(b, s)
if not getElementData(localPlayer,"loggedin") then
    if page == "passwordForget" then
        if b == "left" and s == "down" then
            if specHover then
                if specHover == "close" then
                    if lastClickTick + 500 > getTickCount() then
                        -- outputChatBox("return > fastClick")
                        return
                    end
                    lastClickTick = getTickCount()
                    destroyForgetPanel()
                end
                
                if forgotState == "Search>1" then
                    if specHover == "Search" then
                        if lastClickTick + 1000 > getTickCount() then
                            -- outputChatBox("return > fastClick")
                            return
                        end
                        lastClickTick = getTickCount()

                        if GetText("ForgetPass") then
                            if #GetText("ForgetPass") >= 6 then
                                triggerServerEvent("ForgetPass>Search", localPlayer, localPlayer, GetText("ForgetPass"))
                            else
                                exports.un_notification:create("Lütfen minimum 6 karakter kullanın!", "error")
                            end
                        end
                    end
                elseif forgotState == "Send" then
                    if specHover == "Send"  then
                        if lastClickTick + 1000 > getTickCount() then
                            -- outputChatBox("return > fastClick")
                            return
                        end
                        lastClickTick = getTickCount()
                        triggerServerEvent("ForgetPass>Send", localPlayer, localPlayer, forgotMatch)
                    end
                elseif forgotState == "Code" then
                    if specHover == "Send" then
                        if lastClickTick + 500 > getTickCount() then
                            -- outputChatBox("return > fastClick")
                            return
                        end
                        lastClickTick = getTickCount()
                        
                        if GetText("ForgetCode") then
                            if #GetText("ForgetCode") == 10 then
                                if GetText("ForgetCode") == forgotCode then
                                    triggerServerEvent("destroyCode", localPlayer, localPlayer, nil, true)
                                    forgotState = "Password"
                                    RemoveBar("ForgetPass")
                                    RemoveBar("ForgetCode")
                                    RemoveBar("ChangePass")
                                    exports.un_notification:create("Kod doğru. Yeni şifrenizi giriniz!", "success")
                                    CreateNewBar("ChangePass", {0,0,0,0}, {25, "Yeni şifreniz...", false, tocolor(156,156,156,0), {"Roboto", 10}, 1, "center", "center", not saveJSON["canSeePassword"]}, -10)
                                else
                                    forgetAttempts = forgetAttempts + 1
                                    if forgetAttempts < 3 then
                                        exports.un_notification:create("Kod yanlış "..(3 - forgetAttempts).." deneme hakkınız kaldı!", "error")
                                    elseif forgetAttempts >= 3 then
                                        forgotState = "Send"
                                        RemoveBar("ForgetPass")
                                        RemoveBar("ForgetCode")
                                        RemoveBar("ChangePass")
                                        exports.un_notification:create("Kodu 3 defa yanlış girdiğiniz için tekrar istemeniz gerekecek!", "error")
                                    end
                                end
                            else
                                exports.un_notification:create("Kod 10 karakter olmalıdır!", "error")
                            end
                        end
                    end
                elseif forgotState == "Password" then
                    if specHover == "Send" then
                        if lastClickTick + 500 > getTickCount() then
                            -- outputChatBox("return > fastClick")
                            return
                        end
                        lastClickTick = getTickCount()
                        
                        if GetText("ChangePass") then
                            if #GetText("ChangePass") >= 6 then
                                triggerServerEvent("change.accpw", localPlayer, forgotMatch[1], GetText("ChangePass"))
                                SetText("Login.Name", forgotMatch[1])
                                SetText("Register.Name", forgotMatch[1])
                                SetText("Register.Email", forgotMatch[2])
                                SetText("Login.Password", GetText("ChangePass"))
                                SetText("Register.Password1", GetText("ChangePass"))
                                SetText("Register.Password2", GetText("ChangePass"))
                                exports.un_notification:create("Şifre değişikliği başarılı oldu.", "success")
                                destroyForgetPanel()
                            else
                                exports.un_notification:create("Şifre en az 6 karakter uzunluğunda olmalıdır!", "error")
                            end
                        end
                    end
                end
            end
        end
    end
    
    if page == "Login" or page == "Register" or page == "RPTest" then
        if b == "left" and s == "down" then
            if specHover then
                if lastClickTick + 500 > getTickCount() then
                    -- outputChatBox("return > fastClick")
                    return
                end
                lastClickTick = getTickCount()

                if specHover == "forgetPass" then
                    if page ~= "aszf" and page ~= "passwordForget" then
                        start = true
                        startTick = getTickCount()
                        createForgotPanel()
                        CreateNewBar("ForgetPass", {0,0,0,0}, {30, "Email cím / Felhasználónév", false, tocolor(156,156,156,0), {"Roboto", 10}, 1, "center", "center"}, -10)
                        oPage = page
                        page = "passwordForget"
                    end
                --[[
                elseif specHover == "aszf" then
                    if page ~= "aszf" and page ~= "passwordForget" then
                        oPage = page
                        page = "aszf"
                        requestBrowserDomains({aszfUrl})
                        createAszfBrowser()
                    end]]
                end

                specHover = nil
                return
            end
        end
    end
    
    if page == "Login" then
        if b == "left" and s == "down" then
            if hover == "Bubble" then
                if lastClickTick + 500 > getTickCount() then
                    -- outputChatBox("return > fastClick")
                    return
                end
                lastClickTick = getTickCount()
                
                playSound("files/bubble.mp3")
                
                saveJSON["Clicked"] = not saveJSON["Clicked"]
                if not saveJSON["Clicked"] then
                    saveJSON["Username"] = ""
                    saveJSON["Password"] = ""
                end 
            elseif hover == "Login" then
                return loginInteraction()
            elseif hover == "Register" then
                if lastClickTick + 1700 > getTickCount() then
                    -- outputChatBox("return > fastClick")
                    return
                end
                lastClickTick = getTickCount()
                playSound("files/bubble.mp3")
            
                --local time = 2500
                --changeCameraPos(1, 1, 2, 2500)
                
                --smoothMoveCamera(2075.4697265625, -1220.9239501953, 23.4, 2256.162109375, -1220.7332763672, 31.479625701904, 2084.0437011719, -1224.5490722656, 32.802700042725, 2084.8530273438, -1224.9874267578, 32.411842346191, 2500)
                
               
                loginAnim = 'fadeOut';
                loginTick = getTickCount();

                regTick = getTickCount();
                regAnim = 'fadeInReg';
                --stopLogoAnimation()
                startRegisterPanel()
                --page = "IDGOUT"

                setTimer(function()
                    page = "Login"    
                    stopLoginPanel()
                    page = "Register"   
                    createTextBars(page)
                end, 1700, 1)
            end
        end
    end
end
end
addEventHandler("onClientClick", root, login.onClick)

function idgLoading()
    stopLoginPanel()
    stopLoginSound()
    page = "InGame"
    startLoadingScreen("Login", 1)
    lastClickTick = getTickCount()
end
addEvent("idgLoading", true)
addEventHandler("idgLoading", root, idgLoading)

function loginInteraction()
    if getElementData(localPlayer, "loggedin") == 1 then
    else
        if page == "Login" then
            if lastClickTick + 1550 > getTickCount() then
                return
            end
            
            lastClickTick = getTickCount()
            
            playSound("files/bubble.mp3")
            
            local username = GetText("Login.Name")
            local password = GetText("Login.Password")

            if saveJSON["Clicked"] then
                saveJSON["Username"] = username
                saveJSON["Password"] = password
            end

            triggerServerEvent("accounts:login:attempt", getLocalPlayer(), username, password, false)
        end 
	end
end

function cameraSpawn(hp)
    exports['un_blur']:removeBlur("Loginblur")
    stopLoadingScreen()
    setCameraTarget(localPlayer, localPlayer)
    fadeCamera(true, 0)
    resetFarClipDistance()

    if hp > 0 then
        local x1, y1, z1 = getElementPosition(localPlayer)
        local x2, y2, z2 = x1, y1, z1
        z1 = z1 + 150
        local x3, y3, z3 = getElementPosition(localPlayer)
        z3 = z3 + 1.5
        local x4, y4, z4 = x3, y3, z3
        local time = 6500
        setCameraMatrix(x1, y1, z1, x2, y2, z2)
        setTimer(
            function()
                exports['un_core']:smoothMoveCamera(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4, time)
                fadeCamera(true, 0)
                setTimer(
                    function()
                        exports['un_controls']:toggleAllControls(true, "low")
                        exports['un_custom-chat']:showChat(true)
                        setElementData(localPlayer, "keysDenied", false)
                        setElementData(localPlayer, "hudVisible", true)
                        page = "InGame"
                        triggerServerEvent("unFreeze", localPlayer, localPlayer, hp)
                        setCameraTarget(localPlayer, localPlayer)
                        accID = getElementData(localPlayer, "acc >> id")
                        version = exports['un_core']:getServerData('version')
                        datum = exports['un_core']:getTime()
                        ping = getPlayerPing(localPlayer)
                    end, time, 1
                )
            end, 500, 1
        )
    else 
        triggerServerEvent("unFreeze", localPlayer, localPlayer, hp)
        setCameraTarget(localPlayer, localPlayer)
        accID = getElementData(localPlayer, "acc >> id")
        version = exports['un_core']:getServerData('version')
        datum = exports['un_core']:getTime()
        ping = getPlayerPing(localPlayer)
    end 
end
addEvent("cameraSpawn", true)
addEventHandler("cameraSpawn", root, cameraSpawn)

addEventHandler("onClientResourceStop", resourceRoot,
    function()
        if farclip then
            setFarClipDistance(farclip)
        end
    end
)

addEvent("loadScreen", true)
addEventHandler("loadScreen", root,
    function()
        stopSituations()
        --stopLogoAnimation()
        stopLoginPanel()
        stopLoginSound()
        startLoadingScreen("Login", 1)
    end
)

addEventHandler("onClientResourceStart", resourceRoot, 
    function()
        if getElementData(localPlayer, "loggedIn") then
            accID = getElementData(localPlayer, "acc >> id")
            version = exports['un_core']:getServerData('version')
            datum = exports['un_core']:getTime()
            ping = getPlayerPing(localPlayer)
            --createRender("drawnDetails", drawnDetails)
        end
    end
)


--[[
function drawnDetails()
    --dxDrawRectangle(sx - 85, sy - 14, 85, 14) , clear
    dxDrawText("caseRoleplay ["..version.."] - Account ID: "..accID.." - FPS: "..fps.." - Ping: "..ping.." - "..datum, sx - 90, sy - 6, sx - 90, sy - 6, tocolor(255, 255, 255, 110), 1, "ariel", "right", "center", false, false, false, true)
end--]]

local sounds = {}
soundActive = false

local inhover
local currentMusic, randomMusic
local loginMusics = {
	[1] = 'In My Mind';
	[2] = 'Burn The House Down'; 
	[3] = 'The Ocean';
	[4] = 'On My Way';
    [5] = 'Blinding Lights';
};

function startLoginSound()
    randomMusic = math.random(1, 5);
    currentMusic = randomMusic
    sounds["element"] = playSound('http://music.caseroleplay.com/' .. randomMusic .. '.mp3', true)
    a = setTimer(
        function()
            setSoundVolume(sounds["element"], saveJSON["soundVolume"])
        end, 350, 1
    )
    soundActive = true
    addEventHandler("onClientRender", root, onSoundPlayRender, true, "low-5")
    addEventHandler("onClientRender", root, drawnSoundMultipler, true, "low-5")
    --addEventHandler("onClientRender", root, drawExtraButtons, true, "low-5")
end

function stopLoginSound()
    --removeEventHandler("onClientRender", root, drawExtraButtons)
    if isTimer(a) then
        killTimer(a)
    end
    if isElement(sounds["element"]) then
        destroyElement(sounds["element"])
        sounds["element"] = nil
    end
    soundActive = false
    
    removeEventHandler("onClientRender", root, drawnSoundMultipler)
    removeEventHandler("onClientRender", root, onSoundPlayRender)
end

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 180)
		end
		if (not bgColor) then
			bgColor = borderColor
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);
        
        --Sarkokba pötty:
        dxDrawRectangle(x + 0.5, y + 0.5, 1, 2, borderColor, postGUI); -- bal felső
        dxDrawRectangle(x + 0.5, y + h - 1.5, 1, 2, borderColor, postGUI); -- bal alsó
        dxDrawRectangle(x + w - 0.5, y + 0.5, 1, 2, borderColor, postGUI); -- bal felső
        dxDrawRectangle(x + w - 0.5, y + h - 1.5, 1, 2, borderColor, postGUI); -- bal alsó
	end
end


function drawnSoundMultipler()    
    if page ~= "Unknown" then
        inhover = nil
        --[[
        roundedRectangle(sx/2 - 330/2, sy - 70, 330, 50, tocolor(217, 124, 14, math.min(220, alpha or 255)), tocolor(217, 124, 14, math.min(220, alpha or 255)))
        dxDrawImage(sx/2 - 360/2, sy - 75, 360, 55, f .. "sound-wallpaper.png", 0,0,0, tocolor(255,255,255, alpha or 255))
        local pos = sx/2 - 113 + ((113 + 111) * saveJSON["soundVolume"])
        dxDrawLine(sx/2 - 113 - 1, sy - 44, pos - 1, sy - 44, tocolor(156, 156, 156, math.min(220, alpha or 255)), 3)
        --dxDrawRectangle(sx/2 - 113, sy - 48, 113 + 111, 8)
        dxDrawImage(pos - 32/2, sy - 44 - 32/2, 32, 32, f .. "sound-pointer.png", 0,0,0, tocolor(156, 156, 156, alpha or 255))
        dxDrawText(math.floor(saveJSON["soundVolume"] * 100) .. "%", sx/2 + (330/2 - 25), sy - 67, sx/2 + (330/2 - 25), sy - 70 + 50, tocolor(255,255,255,alpha or 255), 1, fonts["default-regular"], "center", "center")]]
        
        local posx, posy, sx, sy = 10, sy - 60, 270, 50

		--exports['pb_job']:createBlur(posx, posy, sx, sy , 200)
		dxDrawRectangle(posx, posy, sx, sy , tocolor(33, 33, 33, 200))
		dxDrawBorder(posx, posy, sx, sy, 2, tocolor(33, 33, 33, 150))

		dxDrawRectangle(posx + 2, posy + 2, 46, 46 , tocolor(22, 22, 22, 120))

		startsound = '';
		stopSound = '';
		sound = '';
		
		left = '';
		right = '';
        volume = '';
        
        local font = exports['un_fonts']:getFont("FontAwesome", 12)
        local font2 = exports['un_fonts']:getFont("FontAwesome", 16)
        local iconsBig = exports['un_fonts']:getFont("FontAwesome", 18)

		dxDrawText(sound, posx + 24, posy + 13, posx + 24, 0, tocolor(200, 200, 200, 255), 0.82, iconsBig, 'center', 'top')

		if isInSlot(posx + 74 +  135, posy + 7, 16, 16) then
            inhover = 1
			dxDrawText(left, posx + 74 +  140, posy + 7, posx + 74 +  140, 0, tocolor(61, 122, 188, 255), 0.55, font2, 'center', 'top')
		else
			dxDrawText(left, posx + 74 +  140, posy + 7, posx + 74 +  140, 0, tocolor(200, 200, 200, 255), 0.55, font2, 'center', 'top')
		end

		if isInSlot(posx + (74 + 40) +  130, posy + 7, 16, 16) then
            inhover = 2
			dxDrawText(right, posx + (74 + 40) +  140, posy + 7, posx + (74 + 40) +  140, 0, tocolor(61, 122, 188, 255), 0.55, font2, 'center', 'top')
		else
			dxDrawText(right, posx + (74 + 40) +  140, posy + 7, posx + (74 + 40) +  140, 0, tocolor(200, 200, 200, 255), 0.55, font2, 'center', 'top')
		end

		if isSoundPaused(sounds["element"]) then
			if isInSlot(posx + (74 + 20) +  135, posy + 7, 15, 15) then
                inhover = 3
				dxDrawText(startsound, posx + (74 + 20) +  140, posy + 7, posx + (74 + 20) +  140, 0, tocolor(124, 197, 118, 255), 0.55, font2, 'center', 'top')
			else
				dxDrawText(startsound, posx + (74 + 20) +  140, posy + 7, posx + (74 + 20) +  140, 0, tocolor(200, 200, 200, 255), 0.55, font2, 'center', 'top')
			end
		else
			if isInSlot(posx + (74 + 20) +  135, posy + 7, 15, 15) then
                inhover = 4
				dxDrawText(stopSound, posx + (74 + 20) +  140, posy + 7, posx + (74 + 20) +  140, 0, tocolor(210, 49, 49, 255), 0.55, font2, 'center', 'top')
			else
				dxDrawText(stopSound, posx + (74 + 20) +  140, posy + 7, posx + (74 + 20) +  140, 0, tocolor(200, 200, 200, 255), 0.55, font2, 'center', 'top')
			end		
		end

		musicName = loginMusics[currentMusic]
		musicVolume = saveJSON["soundVolume"];
		pointpos = posx + 55 + (musicVolume * 200)
		linergb = {124, 197, 118};
		if (musicVolume * 100) >= 0 and (musicVolume * 100) < 35 then
			linergb = {210, 49, 49};
		elseif (musicVolume * 100) >= 35 and (musicVolume * 100) < 70 then
			linergb = {255, 168, 0};
		else
			linergb = {124, 197, 118};
		end
		dxDrawText(volume, posx + 55 + 2, posy + 8, 0,0, tocolor(200, 200, 200,255),0.55, font2, 'left', 'top')
		dxDrawText(math.ceil(musicVolume * 100) .. "%", posx + 80, posy + 6, 0,0, tocolor(230, 230, 230,255),0.8, font, 'left', 'top')
		
		dxDrawText(musicName, posx + 140, posy - 21, posx + 140,0, tocolor(230, 230, 230,255),0.8, font, 'center', 'top')
		
		roundedRectangle(posx + 55, posy + 35, 200, 5, tocolor(22, 22, 22, 100))
		
		r, g, b = unpack(linergb);
		roundedRectangle(posx + 55, posy + 35, (musicVolume * 200), 5, tocolor(r, g, b, 100))
		dxDrawCircle(pointpos, posy + 36, 8, 0, 360, tocolor(200, 200, 200, 255), tocolor(200, 200, 200, 255), 64, 1)
    end
end

function sounds.onClick(b, s)
if not getElementData(localPlayer,"loggedin") then
--    outputChatBox(page)
    if page == "Login" or page == "Register" or page == "RPTest" then
        if b == "left" and s == "down" then
            local posx, posy, sx, sy = 10, sy - 60, 270, 50
            if isInSlot(posx + 55, posy + 30, 200, 15) then
                if lastClickTick + 500 > getTickCount() then
                    return
                end
                
                playSound("files/bubble.mp3")
                local cx, cy = getCursorPosition()
                local soundVolume = (cx - (posx + 55)) / (200)
                saveJSON["soundVolume"] = soundVolume
                setSoundVolume(sounds["element"], soundVolume)
                soundClick = true
                
                lastClickTick = getTickCount()
            elseif inhover == 1 then -- left
                if currentMusic - 1 >= 1 then
                    currentMusic = currentMusic - 1
                    if isElement(sounds["element"]) then
                        destroyElement(sounds["element"])
                    end
                    sounds["element"] = playSound('http://music.caseroleplay.com/' .. currentMusic .. '.mp3', true)
                    a = setTimer(
                        function()
                            setSoundVolume(sounds["element"], saveJSON["soundVolume"])
                        end, 350, 1
                    )
                else
                    currentMusic = 5
                    if isElement(sounds["element"]) then
                        destroyElement(sounds["element"])
                    end
                    sounds["element"] = playSound('http://music.caseroleplay.com/' .. currentMusic .. '.mp3', true)
                    a = setTimer(
                        function()
                            setSoundVolume(sounds["element"], saveJSON["soundVolume"])
                        end, 350, 1
                    )
                end
            elseif inhover == 2 then -- right
                if currentMusic + 1 <= 5 then
                    currentMusic = currentMusic + 1
                    if isElement(sounds["element"]) then
                        destroyElement(sounds["element"])
                    end
                    sounds["element"] = playSound('http://music.caseroleplay.com/' .. currentMusic .. '.mp3', true)
                    a = setTimer(
                        function()
                            setSoundVolume(sounds["element"], saveJSON["soundVolume"])
                        end, 350, 1
                    )
                else
                    currentMusic = 1
                    if isElement(sounds["element"]) then
                        destroyElement(sounds["element"])
                    end
                    sounds["element"] = playSound('http://music.caseroleplay.com/' .. currentMusic .. '.mp3', true)
                    a = setTimer(
                        function()
                            setSoundVolume(sounds["element"], saveJSON["soundVolume"])
                        end, 350, 1
                    )
                end
            elseif inhover == 3 then -- stop
                setSoundPaused(sounds["element"], false)
            elseif inhover == 4 then -- play
                setSoundPaused(sounds["element"], true)
            end
        elseif b == "left" and s == "up" then
            if soundClick then
                soundClick = false
            end
        end
    end
end
end
addEventHandler("onClientClick", root, sounds.onClick)

local minX = 265
local maxX = 65

addEventHandler("onClientCursorMove", root, 
    function(_, _, x, y)
        if soundClick then
            --outputChatBox("X: "..x.." | MaxX: "..maxX.." | MinX: "..minX)
            if x >= maxX and x <= minX then
                --outputChatBox("asd")
                local soundVolume = (x - (65)) / (200)
                saveJSON["soundVolume"] = soundVolume
                --outputChatBox("asd>> "..soundVolume)
                setSoundVolume(sounds["element"], soundVolume)
            end
        end
    end
)

local sx2, sy2 = guiGetScreenSize();
local bx, by = sx2, sy2

local boxes = 40;
local startColor, endColor = {150, 150, 150}, {255, 255, 255}
function onSoundPlayRender()
    if isElement(sounds["element"]) and not isSoundPaused(sounds["element"]) then
        local soundFFT = getSoundFFTData(sounds["element"], 8192, 256) or {};
        if (soundFFT) then
            local l = sx2/2 - bx/2
            local t = sy2/2 + by/2
            local w = bx/boxes

            local soundVolume = saveJSON["soundVolume"];
            local multipler = 2.0 * (soundVolume)
            for i = 0, boxes do
            	if (soundFFT) ~= nil then
            		local numb = soundFFT[i] or 0
                	local sr = (numb * multipler) or 0

	                if sr > 0 then
		                local r, g, b = interpolateBetween(startColor[1], startColor[2], startColor[3], endColor[1], endColor[2], endColor[3], sr, "Linear")
		                dxDrawRectangle(l + (i*w), t, w, -1 * sr * 256, tocolor(r, g, b, 240))
		            end
		        end
            end
        end
    end
end


local eCache = {
    ["vehicle"] = {},
    ["ped"] = {},
    ["boat"] = {},
}

local timers = {}

function changeCameraPos(id, oid2, id2, time)
    local x0, y0, z0, x1, y1, z1 = unpack(cameraPos[id][oid2])
    --outputChatBox(x0 .. " " .. y0 .. " " .. z0)
    local x2, y2, z2, x3, y3, z3 = unpack(cameraPos[id][id2])
    --outputChatBox(x2 .. " " .. y2 .. " " .. z2)
    --outputChatBox(time)
    smoothMoveCamera(x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3, time)
    setTimer(
        function()
            setCameraMatrix(x2, y2, z2, x3, y3, z3)
        end, time, 1
    )
end

function createSituation(id, refresh, id2)
	--farclip = getFarClipDistance( )
	setFarClipDistance(200)
    local id = id or 1
    local id2 = id2 or 1
    setCameraMatrix(unpack(cameraPos[id][id2]))
    setTimer(
        function()
            if id == 1 then
                for k,v in pairs(vehicles[id]) do
                    local x,y,z,rot = unpack(v)
                    local model, pedModel = valiableVehicles[math.random(1,#valiableVehicles)], valiableSkins[math.random(1,#valiableSkins)]
                    local veh = createVehicle(model, x,y,z)
                    local ped = createPed(pedModel, 0,0,0)
                    setElementFrozen(ped, true)
                    warpPedIntoVehicle(ped, veh)
                    setVehicleHandling(veh, "maxVelocity", math.random(50, 80))
                    setElementRotation(veh, 0, 0, rot)
                    setElementDimension(veh, getElementDimension(localPlayer))
                    setElementDimension(ped, getElementDimension(localPlayer))
                    eCache["vehicle"][veh] = true
                    eCache["vehicle"][ped] = true
                    setTimer(setPedControlState, 300, 1, ped, "accelerate", true)
                end
                
                for k,v in pairs(boats[id]) do
                    local x,y,z,rot,model = unpack(v)
                    local veh = createVehicle(model, x,y,z)
                    --local ped = createPed(pedModel, 0,0,0)
                    --setElementFrozen(veh, true)
                    --warpPedIntoVehicle(ped, veh)
                    setVehicleHandling(veh, "maxVelocity", math.random(50, 80))
                    setElementRotation(veh, 0, 0, rot)
                    setElementDimension(veh, getElementDimension(localPlayer))
                    --setElementDimension(ped, getElementDimension(localPlayer))
                    eCache["boat"][veh] = true
                    --eCache["vehicle"][ped] = true
                    --setTimer(setPedControlState, 300, 1, ped, "accelerate", true)
                end

                timers["refilTimer"] = setTimer(
                    function()
                        for k,v in pairs(eCache["vehicle"]) do
                            if isElement(k) then
                                destroyElement(k)
                            end
                            eCache["vehicle"][k] = nil
                        end

                        for k,v in pairs(vehicles[id]) do
                            local x,y,z,rot = unpack(v)
                            local model, pedModel = valiableVehicles[math.random(1,#valiableVehicles)], valiableSkins[math.random(1,#valiableSkins)]
                            local veh = createVehicle(model, x,y,z)
                            local ped = createPed(pedModel, 0,0,0)
                            setElementFrozen(ped, true)
                            warpPedIntoVehicle(ped, veh)
                            setVehicleHandling(veh, "maxVelocity", math.random(50, 80))
                            setElementRotation(veh, 0, 0, rot)
                            setElementDimension(veh, getElementDimension(localPlayer))
                            setElementDimension(ped, getElementDimension(localPlayer))
                            eCache["vehicle"][veh] = true
                            eCache["vehicle"][ped] = true
                            setTimer(setPedControlState, 300, 1, ped, "accelerate", true)
                        end
                    end, 15000, 0
                )

                for k,v in pairs(peds[id]) do
                    local x,y,z,rot,walk,animDetails = unpack(v)
                    local pedModel = valiableSkins[math.random(1,#valiableSkins)]
                    local ped = createPed(pedModel, x,y,z)
                    setElementDimension(ped, getElementDimension(localPlayer))
                    setElementRotation(ped, 0, 0, rot)
                    if not walk then
                        setElementFrozen(ped, true)
                        setPedAnimation(ped, unpack(animDetails))
                    else
                        setTimer(setPedControlState, 300, 1, ped, "forwards", true)
                        setTimer(setPedControlState, 300, 1, ped, "walk", true)
                    end
                    eCache["ped"][ped] = true
                end

                timers["refilTimer2"] = setTimer(
                    function()
                        for k,v in pairs(eCache["ped"]) do
                            if getPedControlState(k, "forwards") then
                                destroyElement(k)
                                eCache["ped"][k] = nil
                            end
                        end

                        for k,v in pairs(peds[id]) do
                            local x,y,z,rot,walk,animDetails = unpack(v)
                            local pedModel = valiableSkins[math.random(1,#valiableSkins)]
                            if walk then
                                local ped = createPed(pedModel, x,y,z)
                                setElementDimension(ped, getElementDimension(localPlayer))
                                setElementRotation(ped, 0, 0, rot)
                                setTimer(setPedControlState, 300, 1, ped, "forwards", true)
                                setTimer(setPedControlState, 300, 1, ped, "walk", true)
                                eCache["ped"][ped] = true
                            end
                        end
                    end, 30000, 0
                )
            end
        end, 500, 1
    )
end

function stopSituations()
    --setFarClipDistance(farclip)
    resetFarClipDistance()
    if isTimer(timers["refilTimer"]) then
        killTimer(timers["refilTimer"])
    end
    if isTimer(timers["refilTimer2"]) then
        killTimer(timers["refilTimer2"])
    end
    for k,v in pairs(eCache) do
        for k2, v2 in pairs(eCache[k]) do
            if isElement(k2) then
                k2:destroy()
                eCache[k][k2] = nil
            end
        end
    end
end


textbars = {}
local state = false
local oText = "*****************************************************************************************************************************************"
local disabledKey = {
    ["capslock"] = true,
    ["lctrl"] = true,
    ["rctrl"] = true,
    ["lalt"] = true,
    ["ralt"] = true,
    ["home"] = true,
    [";"] = true,
    ["'"] = true,
    ["]"] = true,
    ["["] = true,
    ["="] = true,
    ["_"] = true,
    ["á"] = true,
    ["é"] = true,
    ["ű"] = true,
    ["#"] = true,
    ["\\"] = true,
    ["/"] = true,
    --["."] = true,
    [","] = true,
    ['"'] = true,
    ["_"] = true,
    ["-"] = true,
    ["*"] = true,
    ["-"] = true,
    ["+"] = true,
    ["//"] = true,
    --[" "] = true,
    [""] = true,
}

local subWord = {
    [";"] = "é",
    ["#"] = "á",
    ["["] = "ő",
    ["]"] = "ú",
    ["="] = "ó",
    ["/"] = "ü",
}

local changeKey = {
    ["num_0"] = "0",
    ["num_1"] = "1",
    ["num_2"] = "2",
    ["num_3"] = "3",
    ["num_4"] = "4",
    ["num_5"] = "5",
    ["num_6"] = "6",
    ["num_7"] = "7",
    ["num_8"] = "8",
    ["num_9"] = "9",
}
local guiState = false
local now = 0
local tick = 0
 
local instantBars = {
    ["Test"] = true
}
--[[
Bar felépítése tábla alapján:
textbars["Bar név"] = {{details(x,y,w,h)}, {options(hosszúság, defaultText, onlyNumber, color, font, fontsize, alignX, alingY, secured)}, id}
A defaultText állandóan változik azaz nem kell külön text változó táblába
]]

local gui 

function onGuiBlur2()
    --outputChatBox("asd")
    setTimer(onGuiBlur, 100, 1)
end
--bindKey("F8", "down", onGuiBlur2)

function CreateNewBar(name, details, options, id, needRefresh)
    textbars[name] = {details, options, id}
    if instantBars[name] then --name == "Char-Reg.Age" or name == "Char-Reg.Name" or name == "Char-Reg.Weight" or name == "Char-Reg.Height" then
        now = name
        SetText(now, "") -- textbars[now][2][2] = ""
        --outputChatBox(k)
        tick = 250

        if isElement(gui) then
            removeEventHandler("onClientGUIBlur", gui, onGuiBlur)
            if isTimer(checkTimers) then killTimer(checkTimers) end
            removeEventHandler("onClientGUIChanged", gui, onGuiChange)
            destroyElement(gui)
        end
        gui = GuiEdit(-1, -1, 1, 1, "", true)
        --setTimer(function() gui:setProperty("AlwaysOnTop", "True") end, 100, 1)
        gui.maxLength = textbars[now][2][1]
        --guiEditSetCaretIndex(gui, 1)
        --guiSetProperty(gui, "AlwaysOnTop", "True")
        if isTimer(guiBringToFrontTimer) then killTimer(guiBringToFrontTimer) end
        guiBringToFrontTimer = setTimer(guiBringToFront, 50, 1, gui)

        addEventHandler("onClientGUIBlur", gui, onGuiBlur, true)
        
        checkTimers = setTimer(onGuiBlur, 150, 0)
        addEventHandler("onClientGUIChanged", gui, onGuiChange, true)
        
        --setElementData(localPlayer, "bar >> Use", true)
        guiState = true
        allSelected = false
    end
    
    if not state then
        addEventHandler("onClientRender", root, DrawnBars, true, "low-5")
        state = true
    end
    
    if name == "ForgetPass" or needRefresh then
        if state then
            removeEventHandler("onClientRender", root, DrawnBars)
            addEventHandler("onClientRender", root, DrawnBars, true, "low-5")
        end
    end
end

function RemoveBar(name)
    if textbars[name] then
        if now == name and isElement(gui) then
            removeEventHandler("onClientGUIBlur", gui, onGuiBlur)
            if isTimer(checkTimers) then killTimer(checkTimers) end
            removeEventHandler("onClientGUIChanged", gui, onGuiChange)
            destroyElement(gui)
            
            guiState = false
            tick = 0
            now = nil
        end
        
        textbars[name] = nil
        
        for k,v in pairs(textbars) do
            return
        end
        
        if state then
            removeEventHandler("onClientRender", root, DrawnBars)
            --setElementData(localPlayer, "bar >> Use", false)
            state = false
        end
    end
end

function Clear()
    textbars = {}
    if isElement(gui) then
        removeEventHandler("onClientGUIBlur", gui, onGuiBlur)
        if isTimer(checkTimers) then killTimer(checkTimers) end
        removeEventHandler("onClientGUIChanged", gui, onGuiChange)
        destroyElement(gui)
    end
    if instantBars[now] then --now == "Char-Reg.Age" or now == "Char-Reg.Name" or now == "Char-Reg.Weight" or now == "Char-Reg.Height" then
        --setElementData(localPlayer, "bar >> Use", false)
        guiState = false
        tick = 0
        now = 0
    end
    if state then
        removeEventHandler("onClientRender", root, DrawnBars)
        --setElementData(localPlayer, "bar >> Use", false)
        state = false
    end
end

function UpdatePos(name, details)
    if textbars[name] then
        textbars[name][1] = details
        if not state then
            addEventHandler("onClientRender", root, DrawnBars, true, "low-5")
            state = true
        end
    end
end

function UpdateAlpha(name, newColor)
    if textbars[name] then
        textbars[name][2][4] = newColor
        if not state then
            addEventHandler("onClientRender", root, DrawnBars, true, "low-5")
            state = true
        end
    end
end

function GetText(name)
   return textbars[name][2][2]
end

function SetText(name, val)
    if textbars[name] then
        textbars[name][2][2] = val
        return true
    end
    
    return false
end

local subTexted = {
    ["CharRegisterHeiht"] = " kg",
    ["CharRegisterWeight"] = " cm",
    ["CharRegisterAge"] = " yaş",
}

function DrawnBars()
    for k,v in pairs(textbars) do
        local details = v[1]
        local x,y,w,h = unpack(details)
        --dxDrawRectangle(x,y,w,h,tocolor(0,0,0,180))
        local w,h = x + w, y + h
        --outputChatBox("x:"..x)
        --outputChatBox("y:"..y)
        --outputChatBox("w:"..w)
        --outputChatBox("h:"..h)
        --outputChatBox("k:"..k)
        local options = v[2]
        local text = options[2]
        local color = options[4]
        local fontName = options[5]
        local font = exports['un_fonts']:getFont("Roboto",11)
        local fontsize = options[6]
        local alignX = options[7]
        local alignY = options[8]
        local secured = options[9]
        --local rot1,rot2,rot3 = unpack(options[10])
        
        if secured then
            text = utfSub(oText, 1, #options[2])
        end
        
        if not instantBars[now] then -- then
            if now == k then
                tick = tick + 5
                if tick >= 425 then
                    tick = 0
                elseif tick >= 250 then
                    text = text .. "|"
                end 
            end

           if k == "Char-Reg.Height" then
                if text ~= "Boy" then
                    local color = exports['un_coloration']:getServerColor("yellow", true)
                    text = text .. color .. " cm"
                end
            end
            
            if k == "Char-Reg.Weight" then
                if text ~= "Kilo" then
                    local color = exports['un_coloration']:getServerColor("yellow", true)
                    text = text .. color .. " kg"
                end
            end
            
            if k == "Char-Reg.Age" then
                if text ~= "Yaş" then
                    local color = exports['un_coloration']:getServerColor("yellow", true)
                    text = text .. color .. " yaş"
                end
            end
            if subTexted[k] then
                text = text .. subTexted[k]
            end
            
            --dxDrawRectangle(x,y,w - x,h - y, tocolor(0,0,0,120))
            dxDrawText(text, x,y, w,h, color, fontsize, font, alignX, alignY, false, false, false, true)
        end
    end
end

local allSelected = false

addEventHandler("onClientClick", root,
    function(b, s)
        local screen = {guiGetScreenSize()}
        local defSize = {250, 28}
        local defMid = {screen[1]/2 - defSize[1]/2, screen[2]/2 - defSize[2]/2}
        if s == "down" then
            local x,y,w,h = defMid[1] + defSize[1] - 25, defMid[2] + 38, 20, 20
            --outputChatBox("asd2.-1")
            if isInSlot(x,y,w,h) and page == "Login" then
                --outputChatBox("asd2")
                saveJSON["canSeePassword"] = not saveJSON["canSeePassword"]
                if textbars["Login.Password"] then
                    --outputChatBox("asd2.1")
                    textbars["Login.Password"][2][9] = not saveJSON["canSeePassword"]
                    return
                end
                
                if textbars["Register.Password1"] then
                    --outputChatBox("asd2.1")
                    textbars["Register.Password1"][2][9] = not saveJSON["canSeePassword"]
                    textbars["Register.Password2"][2][9] = not saveJSON["canSeePassword"]
                    return
                end
            end
            if instantBars[now] then --now == "Char-Reg.Age" or now == "Char-Reg.Name" or now == "Char-Reg.Weight" or now == "Char-Reg.Height" then
                return
            end
            for k,v in pairs(textbars) do
                local x,y,w,h = unpack(v[1])
                if isInSlot(x,y,w,h) then
                    if bitExtract(v[2][4], 24, 8) >= 255 then
                        now = k
                        SetText(now, "") --textbars[now][2][2] = ""
                        --outputChatBox(k)
                        tick = 250

                        if isElement(gui) then
                            removeEventHandler("onClientGUIBlur", gui, onGuiBlur)
                            if isTimer(checkTimers) then killTimer(checkTimers) end
                            removeEventHandler("onClientGUIChanged", gui, onGuiChange)
                            destroyElement(gui)
                        end
                        gui = GuiEdit(-1, -1, 1, 1, GetText(now), true)
                        --setTimer(function() gui:setProperty("AlwaysOnTop", "True") end, 100, 1)
                        gui.maxLength = textbars[now][2][1]
                        --guiEditSetCaretIndex(gui, 1)
                        --guiSetProperty(gui, "AlwaysOnTop", "True")
                        if isTimer(guiBringToFrontTimer) then killTimer(guiBringToFrontTimer) end
                        guiBringToFrontTimer = setTimer(guiBringToFront, 50, 1, gui)

                        addEventHandler("onClientGUIBlur", gui, onGuiBlur, true)
                        checkTimers = setTimer(onGuiBlur, 150, 0)
                        addEventHandler("onClientGUIChanged", gui, onGuiChange, true)
                        return
                    end
                end
            end
            ----setElementData(localPlayer, "bar >> Use", false)
            guiState = false
            tick = 0
            now = 0
            
            if isElement(gui) then
                removeEventHandler("onClientGUIBlur", gui, onGuiBlur)
                if isTimer(checkTimers) then killTimer(checkTimers) end
                removeEventHandler("onClientGUIChanged", gui, onGuiChange)
                destroyElement(gui)
            end
        end
    end
)

function onGuiBlur()
    if isElement(gui) then
        guiBringToFront(gui)
    end
end

local specIgnore = {
    ["Char-Reg.Name"] = true,
    ["Register.Email"] = true,
    ["Login.Name"] = true,
    ["ForgetPass"] = true,
    ["ForgetCode"] = true,
}

function onGuiChange()
    playSound("files/key.mp3")
    
    if textbars[now][2][3] then --if now == "Char-Reg.Age" or now == "Char-Reg.Weight" or now == "Char-Reg.Height" then
        if tonumber(guiGetText(gui)) then
            SetText(now, guiGetText(gui))
        else
            guiSetText(gui, "")
            SetText(now, guiGetText(gui))
            guiEditSetCaretIndex(gui, #GetText(now))
        end
        
        return
    end
    
	--[[
    if not specIgnore[now] then
        local st = ""
        for k in string.gmatch(guiGetText(gui), "%w+") do
            st = st .. k
        end
        guiSetText(gui, st)
        guiEditSetCaretIndex(gui, #guiGetText(gui))
        SetText(now, guiGetText(gui))
    end    --]]
    
    if now == "Char-Reg.Name" then
        local st = ""
        for k in string.gmatch(guiGetText(gui), "[%a+%s]") do
            st = st .. k
        end
        guiSetText(gui, st)
        guiEditSetCaretIndex(gui, #guiGetText(gui))
        SetText(now, guiGetText(gui))
        
        if utfSub(guiGetText(gui), #guiGetText(gui), #guiGetText(gui)) == "_" then
            guiSetText(gui, utfSub(guiGetText(gui), 1, #guiGetText(gui) - 1))
            guiEditSetCaretIndex(gui, #guiGetText(gui))
            exports.un_notification:create("'_' Yerine boşluk kullanabilirsiniz.", "error")
        end
        
        if utfSub(guiGetText(gui), #guiGetText(gui), #guiGetText(gui)) == " " and utfSub(guiGetText(gui), #guiGetText(gui) - 1, #guiGetText(gui) - 1) == " " then
            guiSetText(gui, utfSub(guiGetText(gui), 1, #guiGetText(gui) - 1))
            guiEditSetCaretIndex(gui, #guiGetText(gui))
        end
        
        SetText(now, guiGetText(gui))
    else
        SetText(now, guiGetText(gui):gsub(" ", ""))
    end
    
    guiSetText(gui, GetText(now))
    guiEditSetCaretIndex(gui, #GetText(now))
    
    local b = utfSub(GetText(now), #GetText(now), #GetText(now))
    local a2 = utfSub(GetText(now), 1, #GetText(now) - 1)
    if changeKey[b] then 
        b = changeKey[b] 
    end

    if disabledKey[b] then
        local b2 = " " .. b .. " "
        if subWord[b] or b2 == " \ " then
            SetText(now, a2)
            return
        elseif tonumber(b) then
            SetText(now, a2)
            return
        end
    end
end

addEventHandler("onClientKey", root,
    function(b, s)
        if isElement(gui) and s and now and tostring(now) ~= "" and tostring(now) ~= " " then
            if b == "enter" then
                if now == "Login.Name" then 
                    loginInteraction()
                elseif now == "Login.Password" then 
                    loginInteraction()
                elseif now == "Register.Name" then 
                    registerInteraction()
                elseif now == "Register.Email" then 
                    registerInteraction()
                elseif now == "Register.Password1" then 
                    registerInteraction()
                elseif now == "Register.Password2" then 
                    registerInteraction()
                -- elseif now == "Register.InviteCode" then 
                    -- registerInteraction()
                end 
                --[[
                if now == "Char-Reg.Age" then
                    ageNext()
                elseif now == "Char-Reg.Name" then
                    nameNext()
                elseif now == "Char-Reg.Height" then
                    heightNext()
                elseif now == "Char-Reg.Weight" then
                    weightNext()
                end]]
            elseif b == "tab" then
                if now == "ForgetPass" then
                    return
                end
                
                local idTable = {}
                --idTable[k] = i
                for k,v in pairs(textbars) do
                    local i = textbars[k][3]
                    idTable[k] = i
                    idTable[i] = k
                end
                local newNum = idTable[now] + 1
                if idTable[newNum] then
                    now = idTable[newNum]
                    
                    if isElement(gui) then
                        removeEventHandler("onClientGUIBlur", gui, onGuiBlur)
                        if isTimer(checkTimers) then killTimer(checkTimers) end
                        removeEventHandler("onClientGUIChanged", gui, onGuiChange)
                        destroyElement(gui)
                    end
                    gui = GuiEdit(-1, -1, 1, 1, GetText(now), true)
                    --setTimer(function() gui:setProperty("AlwaysOnTop", "True") end, 100, 1)
                    gui.maxLength = textbars[now][2][1]
                    guiEditSetCaretIndex(gui, #GetText(now))
                    --guiSetProperty(gui, "AlwaysOnTop", "True")
                    if isTimer(guiBringToFrontTimer) then killTimer(guiBringToFrontTimer) end
                    guiBringToFrontTimer = setTimer(guiBringToFront, 50, 1, gui)
                    
                    addEventHandler("onClientGUIBlur", gui, onGuiBlur, true)
                    checkTimers = setTimer(onGuiBlur, 150, 0)
                    addEventHandler("onClientGUIChanged", gui, onGuiChange, true)
                else    
                    now = idTable[1]
                    
                    if isElement(gui) then
                        removeEventHandler("onClientGUIBlur", gui, onGuiBlur)
                        if isTimer(checkTimers) then killTimer(checkTimers) end
                        removeEventHandler("onClientGUIChanged", gui, onGuiChange)
                        destroyElement(gui)
                    end
                    gui = GuiEdit(-1, -1, 1, 1, GetText(now), true)
                    --setTimer(function() gui:setProperty("AlwaysOnTop", "True") end, 100, 1)
                    gui.maxLength = textbars[now][2][1]
                    guiEditSetCaretIndex(gui, #GetText(now))
                    --guiSetProperty(gui, "AlwaysOnTop", "True")
                    if isTimer(guiBringToFrontTimer) then killTimer(guiBringToFrontTimer) end
                    guiBringToFrontTimer = setTimer(guiBringToFront, 50, 1, gui)
                    
                    addEventHandler("onClientGUIBlur", gui, onGuiBlur, true)
                    checkTimers = setTimer(onGuiBlur, 150, 0)
                    addEventHandler("onClientGUIChanged", gui, onGuiChange, true)
                end
                return
            end
        end
    end
)