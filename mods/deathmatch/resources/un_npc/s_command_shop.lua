local mysql = exports.un_mysql

shops = {
    -- Eşya Adı, Fiyat, Türü, Yemek & Su İse Vereceğı Puan / Item ID, Item Value
    [1] = {
        {"Burger", 10, "eat", 20},
        {"Pizza", 14, "eat", 40},
        {"Spagetti", 30, "eat", 20},
        {"Sosisli", 40, "eat", 100},
        {"Tako", 15, "eat", 15},
        {"Donut", 20, "eat", 50},
        {"Su", 7, "drink", 40},
        {"Gazoz", 12, "drink", 50},
    },
    [2] = {
        {"Su", 50, "drink", 20},
        {"Gazoz", 50, "drink", 20},
    },
    [3] = {
        {"Valiz", 1, "item", 163, 1},
        {"Sırt Çantası", 2, "item", 48, 1},
        {"İp", 4, "item", 3, 1},
        {"Göz Bandı", 5, "item", 66, 1},
        {"Maske", 6, "item", 56, 1},
    },
}

function createShop ( id, x, y, z, int, dim, type )
    local int, dim, type = tonumber(int), tonumber(dim), tonumber(type)
    local shop = createColSphere(x, y, z, 2)
    setElementInterior(shop, int)
    setElementDimension(shop, dim)
    exports.un_anticheat:changeProtectedElementDataEx(shop, "id", id, false, true)
    exports.un_anticheat:changeProtectedElementDataEx(shop, "shop", true, false, true)
    exports.un_anticheat:changeProtectedElementDataEx(shop, "type", type, false, true)
end

function getShopFromID ( id )
    for i, v in ipairs (getElementsByType("colshape", resourceRoot)) do
        local data = getElementData(v, "id")
        if data == tonumber(id) then --  tonumber(getElementID(v))
            return v
        end
    end
    return
end


function SmallestID()
    local result = dbPoll(dbQuery(mysql:getConnection(),"SELECT MIN(e1.id+1) AS nextID FROM nshops AS e1 LEFT JOIN nshops AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL"), -1)
    if result then
        local id = tonumber(result["nextID"]) or 1
        return id
    end
    return false
end

function loadAllShops(res)
    local ticks = getTickCount( )
    dbQuery(
        function(qh)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, row in ipairs(res) do
                    local id = tonumber(row["id"])
                    local x = tonumber(row["x"])
                    local y = tonumber(row["y"])
                    local z = tonumber(row["z"])
                    local int = tonumber(row["interior"])
                    local dim = tonumber(row["dimension"])
                    local type = tonumber(row["type"])

                    
                    createShop ( id, x, y, z, int, dim, type )
                end
            end
        end,
    mysql:getConnection(), "SELECT id, x, y, z, interior, dimension, type FROM nshops")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllShops)

function makeShop ( thePlayer, commandName, type )
    if not exports.un_integration:isPlayerLeadAdmin(thePlayer) then    return end
    local type = tonumber(type)
    if not type then
        outputChatBox("Tip 1: Yemek Satıcısı", thePlayer, 255, 255, 255)
        outputChatBox("Tip 2: İçecek Satıcısı", thePlayer, 255, 255, 255)
        outputChatBox("Tip 3: Eşya Satıcısı", thePlayer, 255, 255, 255)
        return
    end
    local x, y, z = getElementPosition(thePlayer)
    local int = getElementInterior(thePlayer)
    local dim = getElementDimension(thePlayer)
    local id = SmallestID( )
    local result = dbExec(mysql:getConnection(), "INSERT INTO nshops SET id='', x='"  .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', interior='" .. (int) .. "', dimension='" .. (dim) .. "', type='" .. (type) .. "' ")
    if (result) then
        createShop ( id, x, y, z, int, dim, type )
        outputChatBox("Shop başarıyla oluşturuldu! (ID: '"..id.."')",thePlayer, 0, 255, 0)
    end
end
addCommandHandler("makenewshop",makeShop)

function delShop( thePlayer, commandName, shopID )
    if not exports.un_integration:isPlayerSeniorAdmin(thePlayer) then return end
    local id = tonumber(shopID)
    if not id then
        outputChatBox("Komut: /"..commandName.." [Shop ID]", thePlayer, 255, 255, 255)
        return
    end
    local shop = getShopFromID(id)
    if not shop then
        outputChatBox("Girdiğiniz ID'e sahip bir shop bulunamadı!", thePlayer, 255, 0, 0)
        return
    end
    local result = dbExec(mysql:getConnection(), "DELETE FROM nshops WHERE id='" .. (id) .. "'")
    if (result) then
        if isElement(shop) then
            destroyElement(shop)
        end
        outputChatBox("* Bir shop silindi! (ID: "..id..")",thePlayer, 0, 255, 0)
    end
end
addCommandHandler("delshop",delShop)

function getNearbyShops(thePlayer, commandName)
    if not exports.un_integration:isPlayerSeniorAdmin(thePlayer) then return end
    local posX, posY, posZ = getElementPosition(thePlayer)
    outputChatBox("Yakındaki Shop Alanları:", thePlayer, 255, 126, 0)
    local count = 0
    for i, v in ipairs (getElementsByType("colshape", resourceRoot)) do
        local x, y, z = getElementPosition(v)
        local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
        if (distance<=50) then
            --local dbid = tonumber(getElementID(v))
            local dbid = tonumber(getElementData(v, "id"))
            local type = tonumber(getElementData(v, "type"))
            outputChatBox("   ID " .. dbid .. ", Tip: "..type..".", thePlayer, 255, 126, 0)
            count = count + 1
        end
    end
    if (count==0) then
        outputChatBox("   Yok xD", thePlayer, 255, 126, 0)
    end
end
addCommandHandler("nearbyshops", getNearbyShops, false, false)

-- Buying xD

function buy(thePlayer, cmd, itemname)
    for i, v in ipairs (getElementsByType("colshape", resourceRoot)) do
        local isShop = getElementData(v, "shop")
        if isShop then
            id = getElementData(v, "id")
        --end
    --end
    --local shop = getShopFromID(id)
    --if (isElementWithinColShape(thePlayer, shop)) then
        --local type = getElementData(shop, "type")
            if (isElementWithinColShape(thePlayer, v)) then
                local type = getElementData(v, "type")
                if not itemname then
                    --for i, v in ipairs (shops) do
                        for k, s in ipairs (shops[type]) do
                            outputChatBox("#68fb00[!]#FFFFFF "..s[1].." - ₺"..s[2], thePlayer,255,0,0,true)
                        end
                    --end
                    return
                end
                for k, s in ipairs (shops[type]) do
                    --for k, s in ipairs (shops[i]) do
                        if itemname == s[1]:lower() then
                            if exports.un_global:hasMoney(thePlayer, s[2]) then
                                if s[3] == "eat" then
                                    hunger = getElementData(thePlayer, "hunger")
                                    exports.un_anticheat:changeProtectedElementDataEx(thePlayer, "hunger", hunger+s[4])
                                    exports.un_global:applyAnimation(thePlayer, "FOOD", "EAT_Burger", 2000, false, true, true)
                                    --break
                                elseif s[3] == "drink" then
                                    thirst = getElementData(thePlayer, "thirst")

                                    if thirst + s[4] > 100 then 
                                        s[4] = 100 - thirst
                                    end

                                    exports.un_anticheat:changeProtectedElementDataEx(thePlayer, "thirst", thirst+s[4])
                                    exports.un_global:applyAnimation(thePlayer, "BAR", "dnk_stndM_loop", 2000, false, true, true)
                                    --break
                                elseif s[3] == "item" then
                                    exports.un_global:giveItem(thePlayer, s[4], s[5])
                                end
                                exports.un_global:takeMoney(thePlayer, s[2])

                            break
                            else
                                outputChatBox(exports.un_pool:getServerSyntax(false, "w").." Cebindeki bozukluklar mı bitti adamım?.",thePlayer,255, 255, 255, true)
                            end
                        else
                           -- outputChatBox(tostring(s[1]:lower()),thePlayer)
                           -- outputChatBox(exports.un_pool:getServerSyntax(false, "w").." girdiğiniz yemek ismi yanlış.",thePlayer,255, 255, 255, true)
                        end
                    --end
                end
            --else
                --outputChatBox("Bir shop alanında değilsiniz", thePlayer)
            end
        end
    end
end
addCommandHandler("satinal", buy)