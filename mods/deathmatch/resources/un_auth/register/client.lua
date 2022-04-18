local reg = {}

function startRegisterPanel()
    alpha = 0
    multipler = 2
    page = "Register"
    addEventHandler("onClientRender", root, drawnRegister, true, "low-5")
    createTextBars(page)
    bindKey("enter", "down", registerInteraction)
end

function stopRegisterPanel()
    if page == "Register" then
        RemoveBar("Register.Name")
        RemoveBar("Register.Email")
        RemoveBar("Register.Password1")
        RemoveBar("Register.Password2")
        RemoveBar("Register.InviteCode")
        removeEventHandler("onClientRender", root, drawnRegister)
        unbindKey("enter", "down", registerInteraction)
    end
end

function registerInteraction()
    if lastClickTick + 1550 > getTickCount() then
        --outputChatBox("return > fastClick")
        return
    end

    lastClickTick = getTickCount()
    
    playSound("files/bubble.mp3")
    
    local username = GetText("Register.Name") -- textbars["Register.Name"][2][2]
    local email = GetText("Register.Email") --textbars["Register.Email"][2][2]
    local password = GetText("Register.Password1") --textbars["Register.Password1"][2][2]
    local password2 = GetText("Register.Password2") --textbars["Register.Password2"][2][2]
    local inviteCode = GetText("Register.InviteCode")
    
    if not email:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?") then
        exports.un_notification:create("E-Posta adresi geçersiz! (Örnek: unt-roleplaymta@gmail.com)", "error")
        return
    end
    
    if string.lower(password) ~= string.lower(password2) then
        exports.un_notification:create("Şifreler uyuşmuyor!", "error")
        return
    end

    if saveJSON["Clicked"] then
        --local hashedPassword = hash("sha512", username .. password .. username)
        --local hashedPassword2 = hash("md5", salt .. hashedPassword .. salt)
        saveJSON["Username"] = username
        saveJSON["Password"] = password
    end

    local serial = getElementData(localPlayer, "mtaserial")
    
    if tonumber(inviteCode) then
        for k,v in pairs(getElementsByType("player")) do
            local accID = tonumber(v:getData("acc >> id") or 0) 
            if accID == tonumber(inviteCode) then
                v:setData("char >> premiumPoints", v:getData("char >> premiumPoints") + 35)
                triggerServerEvent("addBox", localPlayer, v, "info", "Davet kodunuzu kullandıkları için size 35 premium puan verdik!")
                inviteCode = nil
                break
            end
        end
    end
    triggerServerEvent("accounts:register:attempt",getLocalPlayer(),username,password,password, email)
   -- triggerServerEvent("accounts:register:attempt",getLocalPlayer(),username,password,password, "@")
end

function drawnRegister()
    hover = nil
    if regAnim == 'fadeInReg' then
        defSize = {250, 28}
        defaultt = {screen[1]/2 - defSize[1]/2, screen[2]/2 - defSize[2]/2}
        defMid = {interpolateBetween(defaultt[1] - (defSize[1] + 10),defaultt[2],0, defaultt[1],defaultt[2],0, (getTickCount() - regTick) / 2400, 'OutQuad')}

        regPos = {interpolateBetween(defMid[2],0,0, defMid[2],220,255, (getTickCount() - regTick) / 1700, 'OutQuad')}
        regAlpha = {interpolateBetween(0,0,0, 40,0,0, (getTickCount() - regTick) / 1700, 'OutQuad')}
        
        if (getTickCount() - regTick) / 1700 >= 1 then
            --updateLogoPos({defMid[1] + (defSize[1]/2), regPos[1] - 90})
        end
        
    elseif regAnim == 'fadeIn2' then

    elseif regAnim == 'fadeOut' then
        defSize = {250, 28}
        defaultt = {screen[1]/2 - defSize[1]/2, screen[2]/2 - defSize[2]/2}
        defMid = {interpolateBetween(defaultt[1],defaultt[2],0, defaultt[1] - (defSize[1] + 10), defaultt[2],0, (getTickCount() - regTick) / 2400, 'OutQuad')}

        regPos = {interpolateBetween(defMid[2],220,255, defMid[2],0,0, (getTickCount() - regTick) / 1700, 'OutQuad')}
        regAlpha = {interpolateBetween(40,0,0, 0,0,0, (getTickCount() - regTick) / 1700, 'OutQuad')}
    else

    end
    
    if (moveProgress) then
		local font = exports['un_fonts']:getFont("FontAwesome", 12)
		local zX, zY = guiGetScreenSize()
        UpdatePos("Register.Name", {defMid[1], regPos[1], defSize[1], defSize[2]})
        UpdatePos("Register.Email", {defMid[1], regPos[1] + 32, defSize[1], defSize[2]})
        UpdatePos("Register.Password1", {defMid[1], regPos[1] + 64, defSize[1], defSize[2]})
        UpdatePos("Register.Password2", {defMid[1], regPos[1] + 96, defSize[1], defSize[2]})
        --UpdatePos("Register.InviteCode", {defMid[1], regPos[1] + 128, defSize[1], defSize[2]})
        UpdateAlpha("Register.Name", tocolor(200, 200, 200, 255))
        UpdateAlpha("Register.Email", tocolor(200, 200, 200, 255))
        UpdateAlpha("Register.Password1", tocolor(200, 200, 200, 255))
        UpdateAlpha("Register.Password2", tocolor(200, 200, 200, 255))
        --UpdateAlpha("Register.InviteCode", tocolor(255, 255, 255, regPos[3]))
        
		setCameraMatrix(0, 0, 0, 0, 0, 0)
		dxDrawImage(0, 0,zX, zY, "files/bg.png",0,0,0, tocolor(255,255,255,255))
		dxDrawRectangle(0, 0, zX, zY, tocolor(0, 0, 0, 210), false);
		
        dxDrawRoundedRectangle(defMid[1] - 20, regPos[1] - 40, defSize[1] + 40, defSize[2] + 180, tocolor(22, 22, 22, 255), { 0.3, 0.3, 0.3, 0.3 }, false);
        dxDrawRoundedRectangle(defMid[1] - 20, regPos[1] - 40, defSize[1] + 40, defSize[2], tocolor(11, 11, 11, 255), { 0.3, 0.3, 0.3, 0.3 }, false);
		dxDrawImage(defMid[1] + 245, regPos[1] - 37, 20, 20, "files/c.png", 0, 0, 0, tocolor(57, 200, 57, 255), false)
		dxDrawImage(defMid[1] + 220, regPos[1] - 37, 20, 20, "files/c.png", 0, 0, 0, tocolor(200, 57, 57, 255), false)
		dxDrawImage(defMid[1] + 195, regPos[1] - 37, 20, 20, "files/c.png", 0, 0, 0, tocolor(200, 170, 57, 255), false)
		dxDrawImage(defMid[1] + 20, regPos[1] - 230, 212, 212, "files/logo.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		
        dxDrawRoundedRectangle(defMid[1], regPos[1], defSize[1], defSize[2], tocolor(33, 33, 33, 255), { 0.3, 0.3, 0.3, 0.3 }, false);
        dxDrawRoundedRectangle(defMid[1], regPos[1] + 32, defSize[1], defSize[2], tocolor(33, 33, 33, 255), { 0.3, 0.3, 0.3, 0.3 }, false);
        dxDrawRoundedRectangle(defMid[1], regPos[1] + 64, defSize[1], defSize[2], tocolor(33, 33, 33, 255), { 0.3, 0.3, 0.3, 0.3 }, false);
        dxDrawRoundedRectangle(defMid[1], regPos[1] + 96, defSize[1], defSize[2], tocolor(33, 33, 33, 255), { 0.3, 0.3, 0.3, 0.3 }, false);
		
        if isInSlot(defMid[1], regPos[1], defSize[1], defSize[2]) then
            dxDrawRoundedRectangle(defMid[1], regPos[1], defSize[1], defSize[2], tocolor(38, 38, 38, 255), { 0.3, 0.3, 0.3, 0.3 }, false);
        elseif isInSlot(defMid[1], regPos[1] + 32, defSize[1], defSize[2]) then
            dxDrawRoundedRectangle(defMid[1], regPos[1] + 32, defSize[1], defSize[2], tocolor(38, 38, 38, 255), { 0.3, 0.3, 0.3, 0.3 }, false);
        elseif isInSlot(defMid[1], regPos[1] + 64, defSize[1], defSize[2]) then
            dxDrawRoundedRectangle(defMid[1], regPos[1] + 64, defSize[1], defSize[2], tocolor(38, 38, 38, 255), { 0.3, 0.3, 0.3, 0.3 }, false);
        elseif isInSlot(defMid[1], regPos[1] + 96, defSize[1], defSize[2]) then
            dxDrawRoundedRectangle(defMid[1], regPos[1] + 96, defSize[1], defSize[2], tocolor(38, 38, 38, 255), { 0.3, 0.3, 0.3, 0.3 }, false);
        end

        if isInSlot(defMid[1] - 3, regPos[1] + 124, defSize[1] - 175, defSize[2] - 15) then
            hover = "Register"
			dxDrawText('hesap oluştur', defMid[1] - 100, regPos[1] + 60, defMid[1] + defSize[1] - 80, regPos[1] + 80 + 60 + defSize[2] + 32, tocolor(200, 200, 200, 255),1, exports['un_fonts']:getFont('Roboto',9), 'center', 'center')
        end

        if isInSlot(defMid[1] + 119, regPos[1] + 124, defSize[1] - 117, defSize[2] - 15) then
            hover = "Login"
        dxDrawText('hesabın var mı? giriş yap!', defMid[1] + 200, regPos[1] + 60, defMid[1] + defSize[1] - 80, regPos[1] + 80 + 60 + defSize[2] + 32, tocolor(200, 200, 200, 255),1, exports['un_fonts']:getFont('Roboto',9), 'center', 'center')
        end

        dxDrawText("", defMid[1] + 9, regPos[1] + 3, 0,0, tocolor(200, 200, 200, 255),1, font)
        dxDrawText("", defMid[1] + 9, regPos[1] + 35, 0,0, tocolor(200, 200, 200, 255),1, font)
        dxDrawText("", defMid[1] + 10, regPos[1] + 35 + 32, 0,0, tocolor(200, 200, 200, 255),1, font)
        dxDrawText("", defMid[1] + 10, regPos[1] + 35 + 64, 0,0, tocolor(200, 200, 200, 255),1, font)

        dxDrawText('hesap oluştur', defMid[1] - 100, regPos[1] + 60, defMid[1] + defSize[1] - 80, regPos[1] + 80 + 60 + defSize[2] + 32, tocolor(200, 200, 200, 255),1, exports['un_fonts']:getFont('Roboto',9), 'center', 'center')
        dxDrawText('hesabın var mı? giriş yap!', defMid[1] + 200, regPos[1] + 60, defMid[1] + defSize[1] - 80, regPos[1] + 80 + 60 + defSize[2] + 32, tocolor(200, 200, 200, 255),1, exports['un_fonts']:getFont('Roboto',9), 'center', 'center')
        
        dxDrawText('©UNT', defMid[1] + 255, regPos[1] - 25, defMid[1] - defSize[1], regPos[1] - defSize[2], tocolor(200, 200, 200, 200),1, exports['un_fonts']:getFont('Roboto',11), 'center', 'center')

    end
end

function reg.onClick(b, s)
    if page == "Register" then
        if b == "left" and s == "down" then
            if hover == "aszfClick" then
                if lastClickTick + 500 > getTickCount() then
                    -- outputChatBox("return > fastClick")
                    return
                end
                lastClickTick = getTickCount()
                
                playSound("files/bubble.mp3")
                
                aszfClicked = not aszfClicked
            elseif hover == "Login" then
                if lastClickTick + 1700 > getTickCount() then
                    --outputChatBox("return > fastClick")
                    return
                end
                playSound("files/bubble.mp3")
                
                loginAnim = 'fadeIn2';
                loginTick = getTickCount();

                regTick = getTickCount();
                regAnim = 'fadeOut';
                --stopLogoAnimation()
                
                --updateLogoPos({defMid[1] + (defSize[1]/2), loginPos[1] - 90})
                startLoginPanel()
                --Clear()
                --page = "IDGOUT"

                setTimer(function()
                    page = "Register"
                    stopRegisterPanel()
                    page = "Login"
                    createTextBars(page)
                end, 1700, 1)
                
                lastClickTick = getTickCount()
            elseif hover == "Register" then
                return registerInteraction()
            end
        end
    end
end
addEventHandler("onClientClick", root, reg.onClick)

addEvent("goBackToLogin", true)
addEventHandler("goBackToLogin", localPlayer,
    function()
        playSound("files/bubble.mp3")
                
        loginAnim = 'fadeIn2';
        loginTick = getTickCount();

        regTick = getTickCount();
        regAnim = 'fadeOut';
        --stopLogoAnimation()

        --updateLogoPos({defMid[1] + (defSize[1]/2), loginPos[1] - 90})
        startLoginPanel()
        Clear()
        --page = "IDGOUT"

        setTimer(function()
            page = "Register"
            stopRegisterPanel()
            page = "Login"
            createTextBars(page)
        end, 1700, 1)

        lastClickTick = getTickCount()
    end
)


