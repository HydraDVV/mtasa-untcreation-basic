local fix_vehicle = function(vehicle, player)
  if player:getData('faction') == 1 or player:getData('faction') == 2 or player:getData('faction') == 78 then
    player:outputChat('[UNT]#D0D0D0 Tamir masraflarınızı devlet tarafından karşılandı!',195,184,116,true)
    vehicle:setFrozen(false)
    vehicle:fix()
    for i = 0, 5 do
      vehicle:setDoorState(i, 0)
    end
  else
    if player:getData('vipver') >= 3 then
      player:outputChat('[UNT]#D0D0D0 VIP olduğunuz için aracınız ücretsiz tamir edildi!',195,184,116,true)
      vehicle:setFrozen(false)
      vehicle:fix()
      for i = 0, 5 do
        vehicle:setDoorState(i, 0)
      end
    else
      player:outputChat('[UNT]#D0D0D0 Aracınız başarıyla tamir edildi!',195,184,116,true)
      exports.un_global:takeMoney(player, 2500)
      vehicle:setFrozen(false)
      vehicle:fix()
      for i = 0, 5 do
        vehicle:setDoorState(i, 0)
      end
    end
  end
end

addEvent('vehicle.fix', true)
addEventHandler('vehicle.fix', root, function()
  if source:getData('loggedin') == 1 then
    local vehicle = source.vehicle
    if vehicle then
      vehicle:setFrozen(true)
      source:outputChat('[UNT]#D0D0D0 Aracınız tamir ediliyor lütfen bekleyin!',195,184,116,true)
      setTimer(function(vehicle, source)
        fix_vehicle(vehicle, source)
      end,4500,1,vehicle,source)
    end
  end
end)