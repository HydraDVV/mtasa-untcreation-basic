function interactRegister(sourceElement, username, password, email, serial, inviteCode)
    local lastClickTick = spam[sourceElement] or 0
    if lastClickTick + 1500 > getTickCount() then
        return
    end
    spam[sourceElement] = getTickCount()
    
    if isValidAccount[username] then
		exports.un_notification:create(sourceElement,"Bu kullanıcı adı ("..username..") zaten kullanılıyor.", "error")
        return
    end

    if isSerialAttachedToAccount[serial] and type(isSerialAttachedToAccount[serial]) == "string" then
        exports.un_notification:create(sourceElement,"Bu serial numarası ("..serial..") zaten bir kullanıcı ile ilişkilendirilmiş. ("..isSerialAttachedToAccount[serial]..")", "error")
        return
    end

    if isEmailAttachedToAccount[email] and type(isEmailAttachedToAccount[serial]) == "string" then
        exports.un_notification:create(sourceElement,"Bu E-Posta adresi ("..email..") zaten bir kullanıcı ile ilişkilendirilmiş. ("..isEmailAttachedToAccount[serial]..")", "error")
        return
    end
    
    inviteCode = tonumber(inviteCode)
    if inviteCode then
        --characters[id] = {ownerAccountName, charname, position, details, charDetails, deathDetails, adminDetails, usedNames, groupID}
        if characters[inviteCode] then
            local details = characters[inviteCode][4] 
            local o = details[7] + 35
            characters[inviteCode][4][7] = o
        end
    end

    local hashPassword1 = hash("sha512", username .. password .. username)
    local hashedPassword = hash("md5", salt .. hashPassword1 .. salt)
    local ip = getPlayerIP(sourceElement)
    local usedIps = toJSON({[ip] = true})
    local usedSerials = toJSON{[serial] = true}
    local usedEmails = toJSON{[email] = true}

    dbExec(connection, "INSERT INTO `accounts` SET `name` = ?, `email` = ?, `password` = ?, `serial` = ?, `ip` = ?, `usedSerials` = ?, `usedEmails` = ?, `usedIps` = ?, `banned` = ?, `registerdatum` = NOW(), `lastlogin` = NOW()", username, email, hashedPassword, serial, ip, usedSerials, usedEmails, usedIps, "false")

    dbQuery(
        function(query)
            local query, query_lines = dbPoll(query, 0)
            if query_lines > 0 then
                Async:foreach(query, 
                    function(row)
                        local id = tonumber(row["id"])
                        local name = tostring(row["name"])
                        local email = tostring(row["email"])
                        local password = tostring(row["password"])
                        local serial = tostring(row["serial"])    
                        local ip = tostring(row["ip"])
                        local registerdatum = tostring(row["registerdatum"])    
                        local lastlogin = tostring(row["lastlogin"])
                        local serial = tostring(row["serial"])
                        local ip = tostring(row["ip"])
                        local usedSerials = tostring(row["usedSerials"])        
                        local usedIps = tostring(row["usedIps"])        
                        local banned = tostring(row["banned"])        
                        local usedEmails = tostring(row["usedEmails"])        
                        usedSerials = fromJSON(usedSerials)
                        usedIps = fromJSON(usedIps)
                        usedEmails = fromJSON(usedEmails)
                        banned = stringToBoolean(banned)
                        accounts[name] = {id, password, serial, email, regdate, lastlogin, ip, usedSerials, usedIps, banned, usedEmails}
                        isValidAccount[name] = true
                        isSerialAttachedToAccount[serial] = name
                        isEmailAttachedToAccount[email] = name
                        idConvertToName[id] = name
						exports.un_notification:create(sourceElement,"Başarıyla kayıt oldunuz, iyi eğlenceler dileriz!", "success")
                        triggerClientEvent(sourceElement, "goBackToLogin", sourceElement)
                    end
                )
            end
        end, 
    connection, "SELECT * FROM `accounts` WHERE `name` = ?", username)
end
addEvent("reg.goRegister", true)
addEventHandler("reg.goRegister", root, interactRegister)