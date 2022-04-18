oldkey = nil
addEventHandler('onClientKey', root, function(key, press)
    if press then
        if key == "k" or key == "x" or key == "F5" or key == "g" or key == "z" or key == "F1" or key == "F2" or key == "F3" then
            if getElementData(localPlayer, "key.spam") then
                cancelEvent()
            else
                if oldkey == key then
                    setElementData(localPlayer, "key.spam", true)
                    setTimer(function()
                        setElementData(localPlayer, "key.spam", false)
                    end, 1000, 1)
                else
                    setElementData(localPlayer, "key.spam", false)
                end
                oldkey = key
            end
        end
    end
end
)