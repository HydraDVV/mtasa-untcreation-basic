Instance = {
	primary_resources = {'un_mysql', 'un_global', 'un_pool', 'un_data', 'un_fonts'},

	start = function(self)
		for index, resource in ipairs(self.primary_resources) do
			getResourceFromName(resource):start()
		end
		--##
		for index, resource in ipairs(getResources()) do
			resource:start()
		end
	end,
}
addEventHandler('onResourceStart',resourceRoot,function() Instance:start() end)