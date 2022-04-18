--MAXIME

hotlines = {
	[155] = "Emniyet Müdürlüğü",
	[156] = "İl Jandarma Komutanlığı",
	[112] = "Sağlık Müdürlüğü",
}

function isNumberAHotline(theNumber)
	local challengeNumber = tonumber(theNumber)
	return hotlines[challengeNumber]
end