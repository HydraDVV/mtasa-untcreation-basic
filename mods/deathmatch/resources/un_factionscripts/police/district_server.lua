function weaponDistrict_doDistrict(name)
	exports["un_chat"]:districtIC(client, _, "Çevreden silah sesleri duyabilirsin.")
end
addEvent("weaponDistrict:doDistrict", true)
addEventHandler("weaponDistrict:doDistrict", root, weaponDistrict_doDistrict)