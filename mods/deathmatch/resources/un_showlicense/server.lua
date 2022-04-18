Server = {

  license = function(player, cmd, target)
    if player:getData('loggedin') == 1 then
      if target then
        local target, targetName = exports.un_global:findPlayerByPartialNick(player, target)
        if target then
	         if getDistanceBetweenPoints3D(player.position.x, player.position.y, player.position.z, target.position.x, target.position.y, target.position.z) < 3 then
	           if not target:getData('card:show') then
	             player:outputChat('[!]#D2D2D2 '..target.name:gsub('_', ' ')..' isimli kişiye kimliğinizi gösterdiniz.',145,60,60,true)
	             target:outputChat('[!]#D2D2D2 '..player.name:gsub('_', ' ')..' isimli kişi size kimliğini gösterdi.',145,60,60,true)
	             target:setData('card:show', true)
	             target:setData('card:target', player)
	             triggerClientEvent(target, 'card:render', target)
	           else
	             player:outputChat('[!]#D2D2D2 '..target.name:gsub('_', ' ')..' isimli kişi şuanda başka bir kimliğe göz gezdiriyor.',145,60,60,true)
	           end
	        end
        end
      end
    end
  end,

  drivelicense = function(player, cmd, target)
    if player:getData('loggedin') == 1 then
      if target then
        local target, targetName = exports.un_global:findPlayerByPartialNick(player, target)
        if target then
	         if getDistanceBetweenPoints3D(player.position.x, player.position.y, player.position.z, target.position.x, target.position.y, target.position.z) < 3 then
	         		local carlicense = player:getData('license.car') or 0
	         		local bikelicense = player:getData('license.bike') or 0
	         		if carlicense == 1 then
	         			carlicense = 'Var'
	         		else
	         			carlicense = 'Yok'
	         		end
	         		if bikelicense == 1 then
	         			bikelicense = 'Var'
	         		else
	         			bikelicense = 'Yok'
	         		end
	            player:outputChat('[!]#D2D2D2 '..target.name:gsub('_', ' ')..' isimli kişiye ehliyetinizi gösterdiniz.',145,60,60,true)
	            target:outputChat('[!]#D2D2D2 '..player.name:gsub('_', ' ')..' isimli kişi size ehliyetini gösterdi.',145,60,60,true)
	            target:outputChat('[!]#D2D2D2 Araba ehliyeti: '..carlicense..' / Motor Ehliyeti: '..bikelicense..'',145,60,60,true)
	        end
        end
      end
    end
  end,

  _constructor = function(self)
    addCommandHandler('kimlikgoster', self.license)
    addCommandHandler('ehliyetgoster', self.drivelicense)
  end,
}

Server:_constructor()