Ban = Service:new('ban-system')
author = 'github.com/bekiroj'
mysql = exports.un_mysql

function SmallestID()
	local query = dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM bans AS e1 LEFT JOIN bans AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result = dbPoll(query, -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end

Ban.constructor = function()
    Ban.timer = Timer(
		function()
            dbQuery(
                function(qh)
                    local res, rows, err = dbPoll(qh, 0)
                    if rows > 0 then
                        local row = res[1]
                        local banid = row.id
                        local hours = row.hours
                        newhours = hours - 1
                        if hours == 0 then
                            dbExec(mysql:getConnection(), "DELETE FROM `bans` WHERE `id`='"..banid.."'")
                        else
                            dbExec(mysql:getConnection(),"UPDATE bans SET hours='"..newhours.."' WHERE id='"..banid.."'")
                        end
                    end
                end,
            mysql:getConnection(), "SELECT * FROM bans")
		end,
    3600000, 0)
    addEventHandler('onPlayerJoin', root, Ban.check)
    addCommandHandler('pban', Ban.online)
    addCommandHandler('oban', Ban.offline)
    addCommandHandler('unban', Ban.unban)
    addCommandHandler('cban', Ban.charban)
    addCommandHandler('uncban', Ban.uncharban)
end

Ban.check = function()
    local serial = getPlayerSerial(source)
    dbQuery(
        function(qh, source)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                kickPlayer(source, "Sunucudan yasaklısınız.")
                return true
            end
        end,
    {source}, mysql:getConnection(), "SELECT * FROM bans WHERE serial='"..serial.."' LIMIT 1")
end

Ban.online = function(thePlayer, cmd, targetPlayer, hours, ...)
    if exports.un_integration:isPlayerAdminIII(thePlayer) then
        if not (targetPlayer) then
            thePlayer:outputChat('[!]#D0D0D0 /pban [ID] [Saat] [Sebep]',195,184,116,true)
        else
            local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(thePlayer, targetPlayer)
            if targetPlayer then
                if tonumber(hours) and (...) then
                    local reason = table.concat({...}, " ")
                    local username = targetPlayer:getData('account:username')
                    local adminTitle = exports.un_global:getPlayerAdminTitle(thePlayer)
                    local targetSerial = getPlayerSerial(targetPlayer)
                    local smallestID = SmallestID()
                    dbExec(mysql:getConnection(), "INSERT INTO bans SET id='"..smallestID.."', serial='"..targetSerial.."', hours='"..hours.."', reason='"..reason.."', account='"..username.."'")
                    for key, player in ipairs(getElementsByType("player")) do
                        player:outputChat('[YASAKLAMA] '..adminTitle..' isimli yetkili '..targetPlayerName..' isimli oyuncuyu yasakladı. ('..hours..' saat)',255,0,0,true)
                        player:outputChat('[YASAKLAMA] Gerekçe: '..reason..'.',255,0,0,true)
                    end
                    kickPlayer(targetPlayer, thePlayer, reason)
                else
                    thePlayer:outputChat('[!]#D0D0D0 Lütfen geçerli bir saat ve sebep giriniz!',195,184,116,true)
                end
            end
        end
    end
end

Ban.offline = function(thePlayer, cmd, charusername, hours, ...)
    if exports.un_integration:isPlayerAdminIII(thePlayer) then
        if not (charusername) then
            thePlayer:outputChat('[!]#D0D0D0 /oban [Hesap İsmi] [Saat] [Sebep]',195,184,116,true)
        else
            if (charusername) then
                if tonumber(hours) and (...) then
                    local reason = table.concat({...}, " ")
                    local adminTitle = exports.un_global:getPlayerAdminTitle(thePlayer)
                    local smallestID = SmallestID()
                    dbQuery(
                        function(qh)
                            local res, rows, err = dbPoll(qh, 0)
                            if rows > 0 then
                                local row = res[1]
                                local targetSerial = row.mtaserial
                                dbExec(mysql:getConnection(), "INSERT INTO bans SET id='"..smallestID.."', serial='"..targetSerial.."', hours='"..hours.."', reason='"..reason.."', account='"..charusername.."'")
                                thePlayer:outputChat('[!]#D0D0D0 Yasaklama işlemini başarıyla gerçekleştirdiniz!',195,184,116,true)
                                for key, player in ipairs(getElementsByType("player")) do
                                    player:outputChat('[YASAKLAMA] '..adminTitle..' isimli yetkili '..charusername..' hesaplı kullanıcıyı yasakladı. ('..hours..' saat)',255,0,0,true)
                                    player:outputChat('[YASAKLAMA] Gerekçe: '..reason..'.',255,0,0,true)
                                end
                            else
                                thePlayer:outputChat('[!]#D0D0D0 Lütfen geçerli bir kullanıcı adı girdiğinize emin olun!',195,184,116,true)
                            end
                        end,
                    mysql:getConnection(), "SELECT * FROM accounts WHERE username = '"..charusername.."'")
                else
                    thePlayer:outputChat('[!]#D0D0D0 Lütfen geçerli bir saat ve sebep giriniz!',195,184,116,true)
                end
            end
        end
    end
end

Ban.unban = function(thePlayer, cmd, charusername)
    if exports.un_integration:isPlayerAdminIII(thePlayer) then
        if not (charusername) then
            thePlayer:outputChat('[!]#D0D0D0 /unban [Hesap İsmi]',195,184,116,true)
        else
            if (charusername) then
                dbQuery(
                    function(qh)
                        local res, rows, err = dbPoll(qh, 0)
                        if rows > 0 then
                            local row = res[1]
                            dbExec(mysql:getConnection(), "DELETE FROM `bans` WHERE `account`='"..charusername.."'")
                            thePlayer:outputChat('[!]#D0D0D0 Başarıyla yasağı kaldırdınız!',195,184,116,true)
                        else
                            thePlayer:outputChat('[!]#D0D0D0 Lütfen geçerli bir kullanıcı adı girdiğinize emin olun!',195,184,116,true)
                        end
                    end,
                mysql:getConnection(), "SELECT * FROM bans WHERE account = '"..charusername.."'")
            end
        end
    end
end

Ban.charban = function(thePlayer, cmd, charusername)
    if exports.un_integration:isPlayerAdminIII(thePlayer) then
        if not (charusername) then
            thePlayer:outputChat('[!]#D0D0D0 /cban [Ad_Soyad]',195,184,116,true)
        else
            if (charusername) then
                local targetPlayer, targetPlayerName = exports.un_global:findPlayerByPartialNick(thePlayer, charusername)
                local adminTitle = exports.un_global:getPlayerAdminTitle(thePlayer)
                dbQuery(
                    function(qh)
                        local res, rows, err = dbPoll(qh, 0)
                        if rows > 0 then
                            local row = res[1]
                            dbExec(mysql:getConnection(),"UPDATE `characters` SET `cked`='1' WHERE `charactername`='"..charusername.."' ")
                            thePlayer:outputChat('[!]#D0D0D0 Başarıyla karakteri yasakladınız!',195,184,116,true)
                            for key, player in ipairs(getElementsByType("player")) do
                                player:outputChat('[YASAKLAMA] '..adminTitle..' isimli yetkili '..charusername..' isimli oyuncuyu yasakladı.',255,0,0,true)
                                player:outputChat('[YASAKLAMA] Gerekçe: Karakter Ölümü.',255,0,0,true)
                            end
                            if targetPlayer then
                                kickPlayer(targetPlayer, thePlayer)
                            end
                        else
                            thePlayer:outputChat('[!]#D0D0D0 Lütfen geçerli bir isim girdiğinize emin olun!',195,184,116,true)
                        end
                    end,
                mysql:getConnection(), "SELECT * FROM characters WHERE charactername = '"..charusername.."'")
            end
        end
    end
end

Ban.uncharban = function(thePlayer, cmd, charusername)
    if exports.un_integration:isPlayerAdminIII(thePlayer) then
        if not (charusername) then
            thePlayer:outputChat('[!]#D0D0D0 /uncban [Ad_Soyad]',195,184,116,true)
        else
            if (charusername) then
                dbQuery(
                    function(qh)
                        local res, rows, err = dbPoll(qh, 0)
                        if rows > 0 then
                            local row = res[1]
                            dbExec(mysql:getConnection(),"UPDATE `characters` SET `cked`='0' WHERE `charactername`='"..charusername.."' ")
                            thePlayer:outputChat('[!]#D0D0D0 Başarıyla karakter yasağını kaldırdınız!',195,184,116,true)
                        else
                            thePlayer:outputChat('[!]#D0D0D0 Lütfen geçerli bir isim girdiğinize emin olun!',195,184,116,true)
                        end
                    end,
                mysql:getConnection(), "SELECT * FROM characters WHERE charactername = '"..charusername.."'")
            end
        end
    end
end

Ban.constructor()