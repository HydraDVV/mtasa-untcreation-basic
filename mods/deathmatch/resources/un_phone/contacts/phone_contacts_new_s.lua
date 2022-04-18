local mysql = exports.un_mysql
addEvent("phone:addContact", true)
function addPhoneContact(name, number, phoneBookPhone)
	if (client) then
		outputChatBox("Telefon rehber sistemi bir süre in-aktif.", client, 255,0,0)
	end
end
addEventHandler("phone:addContact", getRootElement(), addPhoneContact)