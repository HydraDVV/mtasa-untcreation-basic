mysql = exports.un_mysql

function giveFishLicense(usingGC)
	dbExec(mysql:getConnection(), "UPDATE characters SET fish_license='1' WHERE charactername='" .. (getPlayerName(source)) .. "' LIMIT 1")
	exports.un_anticheat:changeProtectedElementDataEx(source, "license.fish", 1)
	exports.un_hud:sendBottomNotification(source, "Department of Motor Vehicles", "Congratulations! You now have a permit for fishing the waters of San Andreas." )
	exports.un_global:giveItem(source, 154, getPlayerName(source):gsub("_"," "))
	executeCommandHandler("stats", source, getPlayerName(source))
end
addEvent("acceptFishLicense", true)
addEventHandler("acceptFishLicense", getRootElement(), giveFishLicense)