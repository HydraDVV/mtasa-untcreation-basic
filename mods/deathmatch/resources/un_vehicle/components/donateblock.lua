local donateAraclar = { [529]=true,[490]=true,[602]=true,[412]=true,[402]=true,[405]=true,[561]=true,[483]=true}

addEventHandler("onVehicleStartEnter" , root , function(player)
    local model 	= source.model
    local owner 	= source:getData("owner")
	local seat  	= getPedOccupiedVehicleSeat(player)
	if seat == 0 then		
		if donateAraclar[model] and owner ~= player:getData("dbid") then
			exports.un_notification:create(player,"Donate araçları sadece sahipleri kullanabilir.", "error")
			cancelEvent()
		end
	end
end)