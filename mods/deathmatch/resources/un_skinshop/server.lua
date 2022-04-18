local mysql = exports.un_mysql

function _skinAl(thePlayer, id)
if not exports["un_global"]:hasMoney(thePlayer, 2500) then outputChatBox("[!] #ffffffSkin almaya paranız yetmiyor. #ffFF00(2.500TL)", thePlayer, 255,0,0,true) return end
	outputChatBox("[+] #ffffffBaşarılı şekilde "..id.." id'li skini satın aldınız.", thePlayer, 0,255,0,true)
	exports["un_global"]:takeMoney(thePlayer,2500)
	exports["un_items"]:giveItem(thePlayer, 16, id)
	setElementModel(thePlayer, id)
end
addEvent("skins >> satinal", true)
addEventHandler("skins >> satinal", root, _skinAl)