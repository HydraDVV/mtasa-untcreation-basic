local alan = createColSphere(1590.9909667969, 1796.5489501953, 2083.376953125, 3)
setElementInterior(alan, 10)
setElementDimension(alan, 180)

local pickup = createPickup(1590.9909667969, 1796.5489501953, 2083.376953125, 3, 1239)
setElementData(pickup, "informationicon:information", "#CC3333/tedaviol#ffffff\nİstanbul Devlet Hastanesi")
setElementInterior(pickup, 10)
setElementDimension(pickup, 180)

function treatment(thePlayer, cmd)
	if not isElementWithinColShape(thePlayer, alan) then return end
	if (getElementData(thePlayer, "vipver") >= 3) then
		setElementHealth(thePlayer, 100)
		outputChatBox('[!]#ffffff VIP olduğunuz için tedavi işleminiz ücretsiz gerçekleşmiştir.',thePlayer,255,0,0,true)
	return end
	if exports.un_global:takeMoney(thePlayer, 5000) then
		setElementHealth(thePlayer, 100)
		outputChatBox('[!]#ffffff 5000₺ ödeyerek başarıyla tedavi oldunuz.',thePlayer,255,0,0,true)
	else
		outputChatBox('[!]#ffffff Tedavi olabilmek için 5000₺ ödemeniz gerekmektedir.',thePlayer,255,0,0,true)
	end
end
addCommandHandler("tedaviol", treatment)