local coordPositions = {
    [1] = {
        name = "Restoran",
        pos = {2329.76171875, 8.1240234375, 26.518367767334, 180},
        int = 0,
        dim = 0,
        settings = {
            min_player = 1,
            max_player = 5,
            pd_available = 1,
            wait_tick = 1000*60*60*24*7,
            victor_tick = 8,
            victor_amount = 20000,
        }
    },
    [2] = {
        name = "Banka",
        pos = {2306.974609375, -7.8720703125, 26.7421875, 264},
        int = 0,
        dim = 0,
        settings = {
            min_player = 5,
            max_player = 8,
            pd_available = 6,
            wait_tick = 1000*60*60*24*13,
            victor_tick = 13,
            victor_amount = 100000,
        }
    }	
}
constructor = function()
    availableRobberys = {}
    collisions = {}
    limits = {}
	timers = {}
	player_blocks = {}
    for id, row in pairs(coordPositions) do
        availableRobberys[id] = {
            action = 1,
            players = {},
            leader = false,
            limit = false,
			settings = {}
        }
        local col = createColSphere(row.pos[1], row.pos[2], row.pos[3], 15)
        setElementDimension(col, row.dim)
        setElementInterior(col, row.int)
        setElementData(col, "id", id)
        table.insert(collisions, col)
		
		local ped = createPed(189, unpack(row.pos))
		ped.dimension = row.dim
		ped.interior = row.int
		ped.frozen = true
		ped:setData("robber", true)
    end

end
addEventHandler("onResourceStart", resourceRoot, constructor)

checkCollision = function(player)
    for id, col in ipairs(collisions) do
        if isElementWithinColShape(player, col) then
		
            return true, getElementData(col, "id") 
        end
    end
    return false
end

SecondsToClock = function(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return hours..":"..mins..":"..secs
  end
end

startRobbery = function(player, cmd)
    local checkPlace, id = checkCollision(player)
    if checkPlace then
        if availableRobberys[id].action ~= 1 then
            outputChatBox("[!]#ffffff Bu alanda zaten soygun gerçekleştiriliyor.", player, 250, 0, 0, true)
            return
        end
        local count = 0
        for _, player in ipairs(getElementsByType("player")) do
            if (tonumber(getElementData(player, "faction")) == 1) then
                count = count + 1
            end
        end
		if availableRobberys[id].limit and isTimer(availableRobberys[id].limit) then
			local seconds = getTimerDetails(availableRobberys[id].limit)
			outputChatBox("[!]#ffffff Burayı ancak "..SecondsToClock(seconds).." sonra soyabilirsiniz.", player, 250, 0, 0, true)
			return
		end
		if player_blocks[getElementData(player, "dbid")] and isTimer(player_blocks[getElementData(player, "dbid")]) then
			outputChatBox("[!]#ffffff Kısa süre önce soygun yaptığınız için işlem bloke edildi.", player, 250, 0, 0, true)
			return
		end
        if coordPositions[id].settings.pd_available > count then
            outputChatBox("[!]#ffffff Bu soygunu yapabilmek için yeterli polis aktif değil. (İstenilen: "..coordPositions[id].settings.pd_available.." kişi / Varolan: "..count.." kişi)", player, 250, 0, 0, true)
            return
        end
        if availableRobberys[id].limit then
            if isTimer(limits[id]) then
                -- to do
            end
            return
        end
        availableRobberys[id].leader = player;
        availableRobberys[id].action = 2 -- Wait at players
        triggerClientEvent(player, "rb:createGUI", player, coordPositions[id].settings.min_player, coordPositions[id].settings.max_player, id, coordPositions[id])
    end
end
addEvent("startRobbery", true)
addEventHandler("startRobbery", root, startRobbery)

deathCheck = function()
	for id, row in pairs(availableRobberys) do
		for i, player in ipairs(row.players) do
			if player == source then
				table.remove(availableRobberys[id].players, i)
				if #availableRobberys[id].players == 0 then
					availableRobberys[id].players = {}
					availableRobberys[id].settings = {}
					if isTimer(timers[id]) then
						killTimer(timers[id])
					end
					outputChatBox("[!]#ffffff Soygundaki tüm üyeler düştüğü için soygun iptal edildi.", player, 0, 255, 0, true)
					
					setElementData(availableRobberys[id].leader, "robberId", false)
					availableRobberys[id].leader = false
					availableRobberys[id].action = 1
					setElementData(player, "robberId", false)
				end
			end
		end
	end
end
addEventHandler("onPlayerWasted", root, deathCheck)

stopRobbery = function(player, robberId, byAdmin, giveCash)
	local robberId = tonumber(robberId)
	
	if byAdmin then
		if giveCash then
			local players = 0
			for i, plr in ipairs(availableRobberys[robberId].players) do
				players = players + 1
			end
			players = players + 1--leader
			local cash = math.floor(coordPositions[robberId].settings.victor_amount/players)
			for i, plr in ipairs(availableRobberys[robberId].players) do
				exports.un_global:giveMoney(plr, cash)
				player_blocks[getElementData(plr, "dbid")] = setTimer(function() end, 1000*60*6, 1)
				setElementData(plr, "robberId", false)
				outputChatBox("[!]#ffffff Tebrikler, soygundan "..exports.un_global:formatMoney(cash).."₺ kazandınız.", plr, 0, 255, 0, true)
			end
			player_blocks[getElementData(player, "dbid")] = setTimer(function() end, 1000*60*6, 1)
			availableRobberys[robberId].limit = setTimer(
				function()
				
				end,
			coordPositions[robberId].settings.wait_tick, 1)
			setElementData(player, "robberId", false)
			outputChatBox("[!]#ffffff Tebrikler, soygundan "..exports.un_global:formatMoney(cash+1000).."₺ kazandınız.", player, 0, 255, 0, true)
			exports.un_global:giveMoney(player, cash+1000)
		end
	end
	
	availableRobberys[robberId].leader = false
	availableRobberys[robberId].action = 1
	availableRobberys[robberId].settings = {}
	for i, player in ipairs(availableRobberys[robberId].players) do
		setElementData(player, "robberId", false)
		if not byAdmin then
			outputChatBox("[!]#ffffff Soygun lideri soygunu iptal etti.", player, 255, 0, 0, true)
		end
	end
	availableRobberys[robberId].players = {}
end
addEvent("stopRobbery", true)
addEventHandler("stopRobbery", root, stopRobbery)

requestRobber = function(player, target, robberId)
	local row = availableRobberys[robberId]
	
	if #row.players + 1 > coordPositions[robberId].settings.max_player then
		outputChatBox("[!]#ffffff Bu soyguna en fazla "..coordPositions[robberId].settings.max_player.." kişi eklenebilir.", player, 255, 0, 0, true)
	end
	if player_blocks[getElementData(target, "dbid")] and isTimer(player_blocks[getElementData(target, "dbid")]) then
		outputChatBox("[!]#ffffff Davet etmeye çalıştığın kişi kısa süre önce bir soygunda yer aldığı için işlem engellendi.", player, 250, 0, 0, true)
		return
	end
	if row.players and #row.players > 0 then
		for i, p in ipairs(row.players) do
			if p == target then
				outputChatBox("[!]#ffffff Kişi zaten soygunda.", player, 255, 0, 0, true)
			return
			end
		end
	end
	triggerClientEvent(target, "askRobber", target, player, robberId)
end
addEvent("requestRobber", true)
addEventHandler("requestRobber", root, requestRobber)

stepRobber = function(player, robberId)
	local row = availableRobberys[robberId]
	
	if isTimer(timers[robberId]) then return end
	
	if #row.players < coordPositions[robberId].settings.min_player then
		outputChatBox("[!]#ffffff Bu soyguna en az "..coordPositions[robberId].settings.min_player.." kişi eklenilmesi gerekiyor.", player, 255, 0, 0, true)
		return
	end
	availableRobberys[robberId].settings.warn = {}
	for index, plr in ipairs(availableRobberys[robberId].players) do
		if isElement(plr) then
			setElementData(plr, "robberId", robberId)
			availableRobberys[robberId].settings.warn[plr] = 0
		end
	end
	setElementData(player, "robberId", robberId)
	triggerClientEvent(player, "robberCloseGUI", player)
	availableRobberys[robberId].settings.endTick = coordPositions[robberId].settings.victor_tick*60
	availableRobberys[robberId].settings.startTick = coordPositions[robberId].settings.victor_tick*60
	timers[robberId] = setTimer(
		function(robberId)
			availableRobberys[robberId].settings.endTick = availableRobberys[robberId].settings.endTick - 1
			if availableRobberys[robberId].settings.endTick <= 0 then
				stopRobbery(player, robberId, true, true)
				killTimer(timers[robberId])
			end
			if math.floor(availableRobberys[robberId].settings.startTick/2) == availableRobberys[robberId].settings.endTick then
				for index, player in ipairs(getElementsByType("player")) do
					if getElementData(player, "faction") == 1 then
						local x, y, z = unpack(coordPositions[robberId].pos)
						outputChatBox("[SOYGUN] "..getZoneName(x,y,z).." taraflarında bir "..coordPositions[robberId].name.."'de soygun yapılıyor.", player, 72, 52, 212, true)
						triggerClientEvent(player, "robber.createBlip", player, x, y, z)
					end
				end
			end
			for i, player in ipairs(availableRobberys[robberId].players) do
				local check = checkCollision(player)
				if not check then
					availableRobberys[robberId].settings.warn[player] = availableRobberys[robberId].settings.warn[player] + 1
					if availableRobberys[robberId].settings.warn[player] > 25 then
						availableRobberys[robberId].settings.warn[player] = 25
						for i, plr in ipairs(availableRobberys[robberId].players) do
							outputChatBox("(!)#ffffff Soygun "..getPlayerName(player):gsub("_", " ").." adlı oyuncu uzun süre soygun dışında kaldığı için iptal edildi.", plr, 255, 0, 0, true)						
						end
						stopRobbery(availableRobberys[robberId].leader, robberId, true, false)
						outputChatBox("(!)#ffffff Soygun "..getPlayerName(player):gsub("_", " ").." adlı oyuncu uzun süre soygun dışında kaldığı için iptal edildi.", availableRobberys[robberId].leader, 255, 0, 0, true)			
					end
					outputChatBox("(!)#ffffff Soygun süresi boyunca soygun alanında kalın! Uyarı: "..availableRobberys[robberId].settings.warn[player].."/25", player, 255, 0, 0, true)
				else
					availableRobberys[robberId].settings.warn[player] = availableRobberys[robberId].settings.warn[player] - 1
					if availableRobberys[robberId].settings.warn[player] < 0 then
						availableRobberys[robberId].settings.warn[player] = 0
					end
				end
			end
			setElementData(root, "robber:"..robberId, availableRobberys[robberId].settings.endTick)
		end,
	1000, 60*coordPositions[robberId].settings.victor_tick, robberId)
end 
addEvent("stepRobber", true)
addEventHandler("stepRobber", root, stepRobber)

okRequest = function(player, target, robberId)
	
	table.insert(availableRobberys[robberId].players, target)
	
	triggerClientEvent(player, "addRobberList", player, target, availableRobberys[robberId])
end
addEvent("robber->okRequest", true)
addEventHandler("robber->okRequest", root, okRequest)

cancelRequest = function(player, target)
	outputChatBox("(!)#ffffff "..target.name:gsub("_", " ").." adlı oyuncu soygun davetini reddetti.", player, 255, 0, 0, true)
end
addEvent("robber->canceledRequest", true)
addEventHandler("robber->canceledRequest", root, cancelRequest)

addEventHandler("onPlayerQuit", root,
    function()
        for id, row in pairs(availableRobberys) do
            if source == row.leader then
                availableRobberys[id].leader = false
                availableRobberys[id].action = 1
                for i, player in ipairs(row.players) do
					setElementData(player, "robberId", false)
                    outputChatBox("[!]#ffffff Soygun lideri oyundan çıktığı için soygun iptal edildi.", player, 255, 0, 0, true)
                end
                availableRobberys[id].players = {}
				availableRobberys[id].settings = {}
				if isTimer(timers[id]) then
					killTimer(timers[id])
				end
            end
        end
    end
)