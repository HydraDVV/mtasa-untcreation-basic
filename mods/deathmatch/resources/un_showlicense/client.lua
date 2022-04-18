localPlayer = getLocalPlayer()
screen = Vector2(guiGetScreenSize())
font = DxFont('components/Roboto.ttf', 10)
localPlayer:setData('card:show', false)

Client = {

  render = function()

  	target = localPlayer:getData('card:target')

  	_close = Timer(
  		function()
  			localPlayer:setData('card:show', false)
  			killTimer(_render)
  		end,
  	3500, 1)

    _render = Timer(
		function()
		    if localPlayer:getData('card:show') and target then
		       	dxDrawImage(screen.x/2-525/2, screen.y/2-475/2, 475, 650, 'components/card.png')
		       	if target:getData('gender') == 0 then
		       		gender = 'Erkek'
		       	elseif target:getData('gender') == 1 then
		       		gender = 'Kadın'
		       	end
		       	dxDrawText(target.name, screen.x/2-418/2, screen.y/2+235/2, 650, 150, tocolor(200,200,200,250), 1, font)
		       	dxDrawText('N/A', screen.x/2-180/2, screen.y/2+90/2, 650, 150, tocolor(200,200,200,250), 1, font)
		       	dxDrawText(gender, screen.x/2-34/2, screen.y/2+90/2, 650, 150, tocolor(200,200,200,250), 1, font)
		       	dxDrawText(target:getData('age'), screen.x/2+107/2, screen.y/2+90/2, 650, 150, tocolor(200,200,200,250), 1, font)
		       	dxDrawText(target:getData('height'), screen.x/2+212/2, screen.y/2+90/2, 650, 150, tocolor(200,200,200,250), 1, font)
		    end
		end,
	0, 0)
  end,

  _constructor = function(self)
    addEvent('card:render', true)
    addEventHandler('card:render', getRootElement(), self.render)
  end,
}

Client:_constructor()