self = {}

self.factions = {
	[1] = true,
	[2] = true,
	[78] = true,
}

addEventHandler("onClientVehicleStartEnter", root,
	function(thePlayer, seat, jacked)
		local playerFaction = tonumber(getElementData(thePlayer, "faction"))
		local vehicleFaction = tonumber(getElementData(source, "faction"))
		if (thePlayer == localPlayer) and (seat == 0) then
			if (self.factions[vehicleFaction] and playerFaction ~= vehicleFaction) then
				cancelEvent()
				outputChatBox(exports.un_pool:getServerSyntax(false, "s").."Bu aracı yalnızca birliğe ait şahıslar kullanabilir.", 255, 0, 0, true)
			end
		end
	end
)