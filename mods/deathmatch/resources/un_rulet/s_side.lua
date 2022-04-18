function onPlayerSelectedRoulet(elementSelect)
	if elementSelect == 1 then
		outputChatBox("[!] #ffffffTebrikler, ruletten 50.000₺ kazandın!", source, 0, 255, 29,true)
		exports.un_global:giveMoney(source, 50000)
	elseif elementSelect == 2 then
		outputChatBox("[!] #ffffffTebrikler, ruletten 60.000₺ kazandın!", source, 0, 255, 29,true)
		exports.un_global:giveMoney(source, 60000)
	elseif elementSelect == 3 then
		outputChatBox("[!] #ffffffTebrikler, ruletten 70.000₺ kazandın!", source, 0, 255, 29,true)
		exports.un_global:giveMoney(source, 70000)
	elseif elementSelect == 4 then
		outputChatBox("[!] #ffffffTebrikler, ruletten 80.000₺ kazandın!", source, 0, 255, 29,true)
		exports.un_global:giveMoney(source, 80000)
	elseif elementSelect == 5 then
		outputChatBox("[!] #ffffffTebrikler, ruletten 90.000₺ kazandın!", source, 0, 255, 29,true)
		exports.un_global:giveMoney(source, 90000)
	end
end
addEvent("onPlayerSelectedRoulet", true)
addEventHandler("onPlayerSelectedRoulet", root, onPlayerSelectedRoulet)