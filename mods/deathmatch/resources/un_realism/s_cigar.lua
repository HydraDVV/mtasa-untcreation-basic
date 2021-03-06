addEvent("realism:startsmoking", true)
addEventHandler("realism:startsmoking", getRootElement(),
	function(hand)
		if not (hand) then
			hand = 0
		else
			hand = tonumber(hand)
		end	
		
		triggerClientEvent("realism:smokingsync", source, true, hand)
		exports.un_anticheat:changeProtectedElementDataEx(source, "realism:smoking", true, false )
		exports.un_anticheat:changeProtectedElementDataEx(source, "realism:smoking:hand", hand, false )
	end
);


function Bind1(thePlayer)
    local sigara = getElementData(thePlayer, "realism:smoking")
    duman = createObject(2012,0,0,0) 
    if (sigara) then
       exports.un_global:applyAnimation(thePlayer, "SMOKING", "M_smkstnd_loop", 6000, false, true, true)
       triggerEvent("realism:startsmoking", thePlayer, 0)
       setTimer ( function()
        exports.un_bone_attach:attach(duman,thePlayer,1,0,0,0,0,266,0)
        end, 5000, 1 )
       setTimer ( function()
        exports.un_bone_attach:detach(duman) 
        moveObject(duman, 1 ,0 ,0 ,0) 
        end, 8000, 1 )
   end
end

function Bind2(thePlayer)
    local sigara = getElementData(thePlayer, "realism:smoking")
    duman = createObject(2012,0,0,0) 
    if (sigara) then
       exports.un_global:applyAnimation(thePlayer, "GANGS", "smkcig_prtl", 8000, false, true, true)
       triggerEvent("realism:startsmoking", thePlayer, 1)
       setTimer ( function()
        exports.un_bone_attach:attach(duman,thePlayer,1,0,0,0,0,266,0)
        end, 5000, 1 )
       setTimer ( function()
        exports.un_bone_attach:detach(duman) 
        moveObject(duman, 1 ,0 ,0 ,0) 
        end, 8000, 1 ) 
   end
end

function saniye(thePlayer)
    local sigara = getElementData(thePlayer, "realism:smoking")
    if (sigara) then
        setTimer( function()
            stopSmoking(thePlayer)
            end, 180000, 1)
    end
end
addEvent("realism:sigarasaniye", true)
addEventHandler("realism:sigarasaniye", getRootElement(), saniye)


function theBinds(thePlayer, commandName)
    bindKey ( thePlayer, "1", "down", Bind1 )
    bindKey ( thePlayer, "2", "down", Bind2 )
end
addEvent("realism:smokingbinds", true)
addEventHandler("realism:smokingbinds", getRootElement(), theBinds)

function stopSmoking(thePlayer)
	if not thePlayer then
		thePlayer = source
	end
	
	if (isElement(thePlayer)) then	
		local isSmoking = getElementData(thePlayer, "realism:smoking")
		local smokingJoint = getElementData(thePlayer, "realism:joint") -- If the player is smoking a Joint, not a ciggy
        if (smokingJoint) then
                triggerClientEvent("realism:smokingsync", thePlayer, false, 0)
                exports.un_anticheat:changeProtectedElementDataEx(thePlayer, "realism:joint", false, false )
                exports.un_anticheat:changeProtectedElementDataEx(thePlayer, "realism:smoking", false, false )
                return
        end
        if (isSmoking) then
                triggerClientEvent("realism:smokingsync", thePlayer, false, 0)
                exports.un_anticheat:changeProtectedElementDataEx(thePlayer, "realism:smoking", false, false )
        end
	end
end
addEvent("realism:stopsmoking", true)
addEventHandler("realism:stopsmoking", getRootElement(), stopSmoking)

function stopSmokingCMD(thePlayer)
    local isSmoking = getElementData(thePlayer, "realism:smoking")
    local smokingJoint = getElementData(thePlayer, "realism:joint")
    if (smokingJoint) then
        stopSmoking(thePlayer)
        exports.un_global:sendLocalMeAction(thePlayer, "throws their joint on the ground.")
        return
    end
    if (isSmoking) then
        stopSmoking(thePlayer)
        unbindKey ( thePlayer, "1", "down", Bind1 )
        unbindKey ( thePlayer, "2", "down", Bind2 )
        exports.un_global:sendLocalMeAction(thePlayer, "sa?? elindeki sigaray?? yere atar.")
    end
end
addCommandHandler("sigaraat", stopSmokingCMD)

function changeSmokehand(thePlayer)
	local isSmoking = getElementData(thePlayer, "realism:smoking")
	if (isSmoking) then
		local smokingHand = getElementData(thePlayer, "realism:smoking:hand")
		triggerClientEvent("realism:smokingsync", thePlayer, true, 1-smokingHand)
		exports.un_anticheat:changeProtectedElementDataEx(thePlayer, "realism:smoking:hand",1-smokingHand, false )
	end
end
addCommandHandler("switchhand", changeSmokehand)

function passJointCMD(thePlayer, commandName, target)
    if (not target) then
        outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick/ID]", thePlayer, 255, 194, 14)
        return
    end
   
    local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(thePlayer, target)
    if (not targetPlayer) then
        outputChatBox("B??yle bir oyuncu bulunamad??.", thePlayer, 255, 0, 0)
        return
    end
    if (thePlayer == targetPlayer) then
        outputChatBox("Ah, zaten bunu i??iyorsun.", thePlayer, 255, 0, 0)
        return
    end
   
    local x, y, z = getElementPosition(thePlayer)
    local tx, ty, tz = getElementPosition(targetPlayer)
    if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz) <= 3) then
        local smokingJoint = getElementData(thePlayer, "realism:joint")
        if (smokingJoint) then
            stopSmoking(thePlayer)
            exports.un_anticheat:changeProtectedElementDataEx(thePlayer, "realism:joint", false, false )
            exports.un_anticheat:changeProtectedElementDataEx(thePlayer, "realism:smoking", false, false )
            exports.un_global:sendLocalMeAction(thePlayer, "passes a joint to " .. targetPlayerName .. ".")
            outputChatBox( "(( /throwaway f??rlatak i??in, /switchhand el de??i??tirmek i??in , /passjoint d??nmek i??in ))", targetPlayer )
            setElementData(targetPlayer, "realism:joint", true)
            triggerEvent("realism:startsmoking", targetPlayer, 0)
        end
    else
        outputChatBox("Yeterince yak??n de??ilsin " .. targetPlayerName .. "!", thePlayer, 255, 0, 0)
    end
end
addCommandHandler("passjoint", passJointCMD, false, false)

-- Sync to new players
addEvent("realism:smoking.request", true)
addEventHandler("realism:smoking.request", getRootElement(), 
	function ()
		local players = exports.un_pool:getPoolElementsByType("player")
		for key, thePlayer in ipairs(players) do
			local isSmoking = getElementData(thePlayer, "realism:smoking")
			if (isSmoking) then
				local smokingHand = getElementData(thePlayer, "realism:smoking:hand")
				triggerClientEvent(source, "realism:smokingsync", thePlayer, isSmoking, smokingHand)
			end
		end
	end
);