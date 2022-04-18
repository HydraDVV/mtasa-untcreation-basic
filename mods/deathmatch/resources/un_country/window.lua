countryLib = {

	countrys = {
		{1, 'Amerika'},
		{2, 'İngiltere'},
		{3, 'Fransa'},
		{4, 'Rusya'},
		{5, 'Almanya'},
		{6, 'İspanya'},
		{7, 'İtalya'},
		{8, 'Hollanda'},
		{9, 'Portekiz'},
		{10, 'Kanada'},
		{11, 'Yunanistan'},
		{12, 'Çin'},
		{13, 'Japonya'},
		{14, 'Danimarka'},
		{15, 'Fildişi Sahili'},
		{16, 'Polonya'},
		{17, 'Vietnam'},
		{18, 'Macaristan'},
		{19, 'Arjantin'},
		{20, 'Brezilya'},
		{21, 'Surinam'},
		{22, 'Avusturya'},
		{23, 'İsrail'},
		{24, 'Letonya'},
		{25, 'Türkiye'},
	},

	_window = function()
	countryLib = instance;
		if localPlayer:getData('loggedin') == 1 then
			localPlayer:setData('country.window', true)
			showCursor(true)

			font = GuiFont(':un_fonts/files/Roboto-Bold.ttf', 9)

			window = GuiWindow(0, 0, 356, 411, 'Lütfen bir ülke seçimi yapınız!', false)
			window:setSizable(false)
			window:setAlpha(0.75)
			exports.un_global:centerWindow(window)

			list = GuiGridList(9, 25, 337, 303, false, window)
			list:setSortingEnabled(false)
			list:setAlpha(0.93)
			list:addColumn('Ülkeler', 0.9)

			for index, value in ipairs(instance.countrys) do
				local row =  list:addRow()
				list:setItemText(row, 1, value[2], false, false)
			end

			image = guiCreateStaticImage(45, 347, 40, 40, "images/1.png", false, window)

			accept = guiCreateButton(136, 354, 91, 33, "Seçim Yap", false, window)
			accept:setAlpha(0.75)
			speed:setFont(font)

			speed = GuiLabel(547, 481, 145, 21, 'Azami Hız: N/A', false, window)
			speed:setFont(font)

			buy = GuiButton(99, 446, 129, 28, 'Seçim Yap', false, window)
			buy:setAlpha(0.75)
		end
	end,

	_render = function()
	countryLib = instance;
		if localPlayer:getData('loggedin') == 1 then
			if not localPlayer:getData('country.window') and localPlayer:getData('country') == 0 then
				instance._window()
			end
			if localPlayer:getData('country.window') then
				if isElement(list) then
					local selected = guiGridListGetSelectedItem(list)
					selected = selected + 1
					selectedTable = instance.countrys[selected] or false
					if selectedTable then
						guiStaticImageLoadImage(image, 'images/'..selectedTable[1]..'.png')
					end
				end
			end
		end
	end,

	_click = function()
	countryLib = instance;
		if source == accept then
			local selected = guiGridListGetSelectedItem(list)
			if selected == -1 then
				outputChatBox('[UNT]#D0D0D0 Lütfen bir ülke seçimi yapınız!',195,184,116,true)
			else
				selected = selected + 1
				selectedTable = instance.countrys[selected] or false
				if selectedTable then
					localPlayer:setData('country.window', false)
					window:destroy()
					showCursor(false)
					triggerServerEvent('selected.country', localPlayer, selectedTable[1])
				end
			end
		end
	end,

	index = function(self)
		setTimer(self._render, 500, 0)
		addEventHandler('onClientGUIClick',getRootElement(),self._click)
	end,
}

localPlayer:setData('country.window', false)
instance = new(countryLib)
instance:index()