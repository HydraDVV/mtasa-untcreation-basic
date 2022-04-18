addCommandHandler("maske",function(plr)
	if not exports["un_items"]:hasItem(plr,56) then outputChatBox("[!]#ffffff Üzerinizde maske yok!",plr,255,100,100,true) return end
	local vip = plr:getData("vipver") or 0
	if vip > 1 or getElementData(plr, "faction") == 1 or getElementData(plr, "faction") == 78 then		
		if not plr:getData("maske:tak") then
			plr:outputChat("[!]#ffffff Maskenizi taktınız.",0,255,0,true)
			plr:setData("maske:tak", true)
			random = "Gizli (#"..getElementData(plr, "dbid")..")"
			exports.un_anticheat:changeProtectedElementDataEx(plr, "fakename", random, true)
		else
			plr:outputChat("[!]#ffffff Maskenizi çıkardınız.",0,255,0,true)
			exports.un_anticheat:changeProtectedElementDataEx(plr, "fakename", false, true)
			plr:setData("maske:tak", nil)
		end
	end
end)