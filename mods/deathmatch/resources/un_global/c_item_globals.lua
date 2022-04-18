function hasSpaceForItem( ... )
	return call( getResourceFromName( "un_items" ), "hasSpaceForItem", ... )
end

function hasItem( element, itemID, itemValue )
	return call( getResourceFromName( "un_items" ), "hasItem", element, itemID, itemValue )
end

function getItemName( itemID )
	return call( getResourceFromName( "un_items" ), "getItemName", itemID )
end
