local miktar = 12250

function cpay(thePlayer)
	if getElementData(thePlayer, "vip") == 1 then
		miktar = 12275
	elseif getElementData(thePlayer, "vip") == 2 then
		miktar = 12300
	elseif getElementData(thePlayer, "vip") == 3 then
		miktar = 12325
	elseif getElementData(thePlayer, "vip") == 4 then
		miktar = 12350
	end
	exports.un_global:giveMoney(thePlayer, miktar)
	outputChatBox("[!] #FFFFFFTebrikler, bu turdan "..miktar.."₺ kazandınız!", thePlayer, 0, 255, 0, true) -- 520
end
addEvent("cigar:pay", true)
addEventHandler("cigar:pay", getRootElement(), cpay)

function cstopJob(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setElementPosition(thePlayer, 2455.34765625, -2643.5400390625, 13.662845611572)
	setElementRotation(thePlayer, 0, 0, 267.11743164063)
end
addEvent("cigar:exitVeh", true)
addEventHandler("cigar:exitVeh", getRootElement(), cstopJob)

function cigarAnti(thePlayer, seat, door)
	local vehicleModel = getElementModel(source)
	local vehicleJob = getElementData(source, "job")
	local playerJob = getElementData(thePlayer, "job")
	if vehicleModel == 459 and vehicleJob == 8 then
	   	if seat ~= 0 then
	    	cancelEvent()
			outputChatBox("[!] #FFFFFFMeslek aracına binemezsiniz.",thePlayer, 255, 0, 0, true)
	   	elseif seat == 0 then
	   		if playerJob ~= 8 then
	   			cancelEvent()
	   			outputChatBox("[!] #FFFFFFBu araca binmek meslekte olmanız gerekmektedir.", thePlayer, 255, 0, 0, true)
	   		end
	   	end
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), cigarAnti)