	--
-- vgScoreboard v1.0
-- Client-side script.
-- By Alberto "ryden" Alonso
--
-- Coded for Valhalla Gaming MTA roleplay server.
local font = exports["un_fonts"]:getFont("Roboto",10)
local boldFont = exports["un_fonts"]:getFont("BoldFont",10)

local riverFont = dxCreateFont("scoreboard/go3v2.ttf",69)

local SCOREBOARD_WIDTH				= 400
local SCOREBOARD_HEIGHT				= 460
local rectangleHeight 				= 30
local SCOREBOARD_HEADER_HEIGHT		= 20
local SCOREBOARD_TOGGLE_CONTROL		= "tab"
local SCOREBOARD_PGUP_CONTROL		= "mouse_wheel_up"
local SCOREBOARD_PGDN_CONTROL		= "mouse_wheel_down"
local SCOREBOARD_DISABLED_CONTROLS	= { "next_weapon",
										"previous_weapon",
										"aim_weapon",
										"radio_next",
										"radio_previous" }
local SCOREBOARD_TOGGLE_TIME		= 700
local SCOREBOARD_POSTGUI			= true
local SCOREBOARD_INFO_BACKGROUND	= { 0, 0, 0, 0 }
local riverScoreboardBackground		= { 20, 20, 20, 200 }
local riverScoreboardBackgroundII	= { 20, 20, 20, 200 }
local SCOREBOARD_SERVER_NAME_COLOR	= { 200, 200, 200, 255 }
local riverBigFontColor 			= { 255,255,255,255 }
local SCOREBOARD_PLAYERCOUNT_COLOR	= { 255, 255, 255, 255 }
local SCOREBOARD_HEADERS_COLOR		= { 255, 255, 255, 255 }
local SCOREBOARD_SEPARATOR_COLOR	= { 255, 255, 255, 0 }
local SCOREBOARD_SCROLL_BACKGROUND	= { 55, 55, 55, 100 }
local SCOREBOARD_SCROLL_FOREGROUND	= { 66, 66, 66, 200 }
local SCOREBOARD_SCROLL_HEIGHT		= 30
local SCOREBOARD_COLUMNS_WIDTH		= { 0.08, 0.50, 0.20, 0.19, 0.04 }
local SCOREBOARD_ROW_GAP			= 0

local g_isShowing = false
local g_currentWidth = 0
local g_currentHeight = 0
local g_scoreboardDummy
local g_windowSize = { guiGetScreenSize () }
local g_localPlayer = getLocalPlayer ()
local g_currentPage = 0
local g_players
local g_oldControlStates

local SCOREBOARD_X = math.floor ( ( g_windowSize[1] - SCOREBOARD_WIDTH ) / 2 )
local SCOREBOARD_Y = math.floor ( ( g_windowSize[2] - SCOREBOARD_HEIGHT ) / 1.6 )
riverScoreboardBackground = tocolor ( unpack ( riverScoreboardBackground ) )
riverScoreboardBackgroundII = tocolor ( unpack ( riverScoreboardBackgroundII ) )
SCOREBOARD_SERVER_NAME_COLOR = tocolor ( unpack ( SCOREBOARD_SERVER_NAME_COLOR ) )
riverBigFontColor = tocolor ( unpack ( riverBigFontColor ) )
SCOREBOARD_PLAYERCOUNT_COLOR = tocolor ( unpack ( SCOREBOARD_PLAYERCOUNT_COLOR ) )
SCOREBOARD_HEADERS_COLOR = tocolor ( unpack ( SCOREBOARD_HEADERS_COLOR ) )
SCOREBOARD_SCROLL_BACKGROUND = tocolor ( unpack ( SCOREBOARD_SCROLL_BACKGROUND ) )
SCOREBOARD_SCROLL_FOREGROUND = tocolor ( unpack ( SCOREBOARD_SCROLL_FOREGROUND ) )
SCOREBOARD_SEPARATOR_COLOR = tocolor ( unpack ( SCOREBOARD_SEPARATOR_COLOR ) )
for k=1,#SCOREBOARD_COLUMNS_WIDTH do
	SCOREBOARD_COLUMNS_WIDTH[k] = math.floor ( SCOREBOARD_COLUMNS_WIDTH[k] * SCOREBOARD_WIDTH )
end
local rowsBoundingBox = { { SCOREBOARD_X, -1 }, { -1, -1 }, { -1, -1 }, { -1, -1 }, { -1, -1 } }
rowsBoundingBox[1][2] = SCOREBOARD_X + SCOREBOARD_COLUMNS_WIDTH[1]
rowsBoundingBox[2][1] = rowsBoundingBox[1][2]
rowsBoundingBox[2][2] = rowsBoundingBox[2][1] + SCOREBOARD_COLUMNS_WIDTH[2]
rowsBoundingBox[3][1] = rowsBoundingBox[2][2]
rowsBoundingBox[3][2] = rowsBoundingBox[3][1] + SCOREBOARD_COLUMNS_WIDTH[3]
rowsBoundingBox[4][1] = rowsBoundingBox[3][2]
rowsBoundingBox[4][2] = rowsBoundingBox[4][1] + SCOREBOARD_COLUMNS_WIDTH[4]
rowsBoundingBox[5][1] = rowsBoundingBox[4][2]
rowsBoundingBox[5][2] = SCOREBOARD_X + SCOREBOARD_WIDTH


--[[ Pre-declare some functions ]]--
local onRender
local fadeScoreboard
local drawBackground
local drawScoreboard


--[[
* clamp
Clamps a value into a range.
--]]
local function clamp ( valueMin, current, valueMax )
	if current < valueMin then
		return valueMin
	elseif current > valueMax then
		return valueMax
	else
		return current
	end
end

local function createPlayerCache ( ignorePlayer )
	if ignorePlayer then
		g_players = {}
		
		local players = getElementsByType ( "player" )
	
		for k, player in ipairs(players) do
			if ignorePlayer ~= player then
				table.insert ( g_players, player )
			end
		end
	else
		g_players = getElementsByType ( "player" )
	end

	table.sort ( g_players, function ( a, b )
		local idA = getElementData ( a, "playerid" ) or 0
		local idB = getElementData ( b, "playerid" ) or 0

		if a == g_localPlayer then
			idA = -1
		elseif b == g_localPlayer then
			idB = -1
		end
		
		return tonumber(idA) < tonumber(idB)
	end )
end

addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), function ()
	createPlayerCache ()
end, false )

addEventHandler ( "onClientElementDataChange", root, function ( dataName, dataValue )
	if dataName == "playerid" then
		createPlayerCache ()
	end
end )

addEventHandler ( "onClientPlayerQuit", root, function ()
	createPlayerCache ( source )
end )

local function toggleScoreboard ( show )
	local show = show == true
	
	if show ~= g_isShowing then
		g_isShowing = show
		
		if g_isShowing and g_currentWidth == 0 and g_currentHeight == 0 then
			addEventHandler ( "onClientPreRender", root, onRender, false )
		end
		
		if g_isShowing then
			g_oldControlStates = {}
			for k, control in ipairs ( SCOREBOARD_DISABLED_CONTROLS ) do
				g_oldControlStates[k] = isControlEnabled ( control )
				toggleControl ( control, false )
			end
		else
			for k, control in ipairs ( SCOREBOARD_DISABLED_CONTROLS ) do
				toggleControl ( control, g_oldControlStates[k] )
			end
			g_oldControlStates = nil
		end
	end
end

local function onToggleKey ( key, keyState )
	if not g_scoreboardDummy then
		local elementTable = getElementsByType ( "scoreboard" )
		if #elementTable > 0 then
			g_scoreboardDummy = elementTable[1]
		else
			return
		end
	end
	
	toggleScoreboard ( keyState == "down" and getElementData ( g_scoreboardDummy, "allow" ) )
end
bindKey ( SCOREBOARD_TOGGLE_CONTROL, "both", onToggleKey )

local function onScrollKey ( direction )
	if g_isShowing then
		if direction then
			g_currentPage = g_currentPage + 1
			playSound("scoreboard/wheel.wav")
		else
			g_currentPage = g_currentPage - 1
			if g_currentPage < 0 then
				g_currentPage = 0
				playSound("scoreboard/wheel.wav")
			end
		end
	end
end
bindKey ( SCOREBOARD_PGUP_CONTROL, "down", function () onScrollKey ( false ) end )
bindKey ( SCOREBOARD_PGDN_CONTROL, "down", function () onScrollKey ( true ) end )

onRender = function ( timeshift )
	local drawIt = false
	
	if g_isShowing then
		if not getElementData ( g_scoreboardDummy, "allow" ) then
			toggleScoreboard ( false )
		elseif g_currentWidth < SCOREBOARD_WIDTH or g_currentHeight < SCOREBOARD_HEIGHT then
			drawIt = fadeScoreboard ( timeshift, 1 )
		else
			drawIt = true
		end
	else
		drawIt = fadeScoreboard ( timeshift, -1 )
	end
	
	if drawIt then
		drawScoreboard ()
	end
end

fadeScoreboard = function ( timeshift, multiplier )
	local growth = ( timeshift / SCOREBOARD_TOGGLE_TIME ) * multiplier

	g_currentWidth = clamp ( 0, g_currentWidth + ( SCOREBOARD_WIDTH * growth ), SCOREBOARD_WIDTH )
	g_currentHeight = clamp ( 0, g_currentHeight + ( SCOREBOARD_HEIGHT / growth ), SCOREBOARD_HEIGHT )
	
	if g_currentWidth == 0 or g_currentHeight == 0 then
		g_currentWidth = 0
		g_currentHeight = 0
		removeEventHandler ( "onClientPreRender", root, onRender )
		return false
	else
		return true
	end
end

drawBackground = function ()
	local headerHeight = clamp ( 0, SCOREBOARD_HEADER_HEIGHT, g_currentHeight )
	
	if g_currentHeight > SCOREBOARD_HEADER_HEIGHT then
		dxDrawRectangle ( SCOREBOARD_X - 3, SCOREBOARD_Y + 5,
		SCOREBOARD_WIDTH + 5, SCOREBOARD_HEIGHT,
		riverScoreboardBackground, SCOREBOARD_POSTGUI )

		dxDrawRectangle ( SCOREBOARD_X - 3, SCOREBOARD_Y - 30,
		SCOREBOARD_WIDTH + 5, SCOREBOARD_HEIGHT -143*3,
		riverScoreboardBackgroundII, SCOREBOARD_POSTGUI )

		dxDrawRectangle ( SCOREBOARD_X - 3, SCOREBOARD_Y - 10 + SCOREBOARD_HEADER_HEIGHT + g_currentHeight - SCOREBOARD_HEADER_HEIGHT + 15,
		g_currentWidth + 5, rectangleHeight,
		tocolor(20,20,20,220), SCOREBOARD_POSTGUI )

		dxDrawRectangle (SCOREBOARD_X - 3, (SCOREBOARD_Y - 10 + SCOREBOARD_HEADER_HEIGHT) + (g_currentHeight - SCOREBOARD_HEADER_HEIGHT) + (15),
		(g_currentWidth / getElementData ( g_scoreboardDummy, "maxPlayers" )) * tostring(#g_players), rectangleHeight, tocolor(37,37,37,220), SCOREBOARD_POSTGUI )

	end
end

local function drawRowBounded ( id, name, level, ping, colors, font, top )
	local bottom = clamp ( 0, top + dxGetFontHeight ( 1, font ), SCOREBOARD_Y + g_currentHeight )
	local maxWidth = SCOREBOARD_X + g_currentWidth
	
	if bottom < top then return end
	
	local left = rowsBoundingBox[1][1]
	local right = clamp ( 0, rowsBoundingBox[1][2], maxWidth )
	if left < right then
		dxDrawText ( id, left, top, right, bottom,
					 colors[1], 1, font, "right", "top",
					 true, false, SCOREBOARD_POSTGUI )

		left = rowsBoundingBox[2][1] + 17
		right = clamp ( 0, rowsBoundingBox[2][2], maxWidth )
		if left < right then
			dxDrawText ( name, left, top, right, bottom,
						 colors[2], 1, font, "left", "top",
						 true, false, SCOREBOARD_POSTGUI )
						 
			left = rowsBoundingBox[3][1]
			right = clamp ( 0, rowsBoundingBox[3][2], maxWidth )
			if left < right then
				dxDrawText ( level, left, top, right, bottom,
							 colors[3], 1, font, "left", "top",
							 true, false, SCOREBOARD_POSTGUI )
			
				left = rowsBoundingBox[4][1]
				right = clamp ( 0, rowsBoundingBox[4][2], maxWidth )
				if left < right then
					dxDrawText ( ping, left, top, right, bottom,
								 colors[3], 1, font, "left", "top",
								 true, false, SCOREBOARD_POSTGUI )
				end
			end
		end
	end
end

local function drawScrollBar ( top, position )
	local left = rowsBoundingBox[5][1]
	local right = clamp ( 0, rowsBoundingBox[5][2], SCOREBOARD_X + g_currentWidth )
	local bottom = clamp ( 0, SCOREBOARD_Y + SCOREBOARD_HEIGHT, SCOREBOARD_Y + g_currentHeight )
	
	if left < right and top < bottom then
		dxDrawRectangle ( left, top, right - left, bottom - top, SCOREBOARD_SCROLL_BACKGROUND, SCOREBOARD_POSTGUI )
		
		local top = top + position * ( SCOREBOARD_Y + SCOREBOARD_HEIGHT - SCOREBOARD_SCROLL_HEIGHT - top )
		bottom = clamp ( 0, top + SCOREBOARD_SCROLL_HEIGHT, SCOREBOARD_Y + g_currentHeight )
		
		if top < bottom then
			dxDrawRectangle ( left, top, right - left, bottom - top, SCOREBOARD_SCROLL_FOREGROUND, SCOREBOARD_POSTGUI )
		end
	end
end

drawScoreboard = function ()
	if not g_players then return end

	drawBackground ()
	
	local serverName = getElementData ( g_scoreboardDummy, "serverName" ) or "MTA server"
	local maxPlayers = getElementData ( g_scoreboardDummy, "maxPlayers" ) or 0
	local RiverRoleplay = getElementData( g_scoreboardDummy, "river:roleplay" )
	serverName = tostring ( serverName )
	maxPlayers = tonumber ( maxPlayers )
	RiverRoleplay = tostring( RiverRoleplay )

	local left, top, right, bottom = SCOREBOARD_X + 75, SCOREBOARD_Y - 10, SCOREBOARD_X + g_currentWidth - 2, SCOREBOARD_Y + SCOREBOARD_HEADER_HEIGHT - 2
	
	local rivergameL, rivergameT, rivergameR, rivergameB = SCOREBOARD_X - 10, SCOREBOARD_Y -130, SCOREBOARD_X + g_currentWidth - 2, SCOREBOARD_Y + SCOREBOARD_HEADER_HEIGHT - 2

	dxDrawText ( serverName, left+15, top-13, right, bottom,
				 SCOREBOARD_SERVER_NAME_COLOR, 1, boldFont, "left", "top",
				 true, false, SCOREBOARD_POSTGUI )

	local usagePercent = (#g_players / maxPlayers)
	local strPlayerCount = "Aktif Oyuncular: " .. tostring(#g_players) .. "/" .. tostring(maxPlayers) .. ""
	
	local offset = SCOREBOARD_WIDTH - dxGetTextWidth ( strPlayerCount, 1, font ) - 4
	left = left + offset
	if left < right then
		dxDrawText ( strPlayerCount, (SCOREBOARD_X + 4 + (g_currentWidth / 2.2)) - 60, SCOREBOARD_Y - 8 + SCOREBOARD_HEADER_HEIGHT - 9 + g_currentHeight + 8.5, 2000, 1000,
					SCOREBOARD_PLAYERCOUNT_COLOR, 1, font, "left", "top",
					true, false, SCOREBOARD_POSTGUI )
	end
	
	left, top, bottom = SCOREBOARD_X, SCOREBOARD_Y + SCOREBOARD_HEADER_HEIGHT + 2, SCOREBOARD_Y + g_currentHeight - 2

	local rowHeight = dxGetFontHeight ( 1, font )
	
	drawRowBounded ( "ID", "Karakter İsmi", "Seviye", "Ping",
					 { SCOREBOARD_HEADERS_COLOR, SCOREBOARD_HEADERS_COLOR, SCOREBOARD_HEADERS_COLOR, SCOREBOARD_HEADERS_COLOR },
					 font, top )
	
				 
	top = top + rowHeight + 3
	
	right = clamp ( 0, rowsBoundingBox[4][2] - 5, SCOREBOARD_X + g_currentWidth )
	if top < SCOREBOARD_Y + g_currentHeight then
		dxDrawLine ( SCOREBOARD_X + 15, top, right, top, SCOREBOARD_SEPARATOR_COLOR, 1, SCOREBOARD_POSTGUI )
	end
	top = top + 3
	
	local renderEntry = function ( player )
		local playerID = getElementData ( player, "playerid" ) or 0
		playerID = tostring ( playerID )
		local playerName = getPlayerName ( player )
		playerName = tostring ( playerName ):gsub( "_", " " )
		local playerPing = getPlayerPing ( player )
		playerPing = tostring ( playerPing )
		local playerLevel = getElementData ( player, "level") or 0
		playerLevel = tostring ( playerLevel )
		local r, g, b = getPlayerNametagColor ( player )
		local playerColor = tocolor ( r, g, b, 255 )
		
		local colors = { playerColor, playerColor, playerColor }
		
		top = top
		if (getElementData(localPlayer, "duty_admin") == 1)	then
			if getElementData(player, "loggedin") == 1 then
				playerName = playerName .. " (" .. getElementData(player, "account:username") .. ")"
			end
		end
		drawRowBounded ( playerID, playerName, playerLevel, playerPing, colors, font, top )
	end
	
	local playersPerPage = math.floor ( ( SCOREBOARD_Y + SCOREBOARD_HEIGHT - top ) / ( rowHeight + SCOREBOARD_ROW_GAP ) )
	
	local playerShift = math.floor ( playersPerPage / 2 )
	
	local playersToSkip = playerShift * g_currentPage
	if (#g_players - playersToSkip) < playersPerPage then
		if (#g_players - playersToSkip) < playerShift then
			g_currentPage = g_currentPage - 1
			if g_currentPage < 0 then g_currentPage = 0 end
		end

		playersToSkip = #g_players - playersPerPage + 1
	end
	
	if playersToSkip < 0 then
		playersToSkip = 0
	end

	for k=playersToSkip + 1, #g_players do
		local player = g_players [ k ]
		
		if top < bottom - rowHeight - SCOREBOARD_ROW_GAP then
			renderEntry ( player )
			top = top + rowHeight + SCOREBOARD_ROW_GAP
		else break end
	end

	drawScrollBar ( SCOREBOARD_Y + SCOREBOARD_HEADER_HEIGHT + rowHeight + 8, playersToSkip / ( #g_players - playersPerPage + 1 ) )
end

function isVisible ( )
	return g_isShowing
end

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200)
		end
		if (not bgColor) then
			bgColor = borderColor
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI)
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI)
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI)
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI)
	end
end