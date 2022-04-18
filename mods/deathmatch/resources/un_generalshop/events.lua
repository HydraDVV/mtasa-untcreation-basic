addEvent('shop.giveItem', true)
addEventHandler('shop.giveItem', root, function(item, cash)
  if source:getData('loggedin') == 1 then
    if tonumber(cash) and tonumber(item) then
      if exports.un_global:takeMoney(source, cash) then
        if tonumber(item) == 2 then
          local itemValue = math.random(530, 542) .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9)
          exports.un_global:giveItem(source, item, itemValue)
          source:outputChat('[UNT]#D0D0D0 Başarıyla eşyayı satın aldınız!',195,184,116,true)
        else
          exports.un_global:giveItem(source, item, 1)
          source:outputChat('[UNT]#D0D0D0 Başarıyla eşyayı satın aldınız!',195,184,116,true)
        end
      else
        source:outputChat('[UNT]#D0D0D0 Bu eşyayı alabilmek için yeterli miktarda paranız yok!',195,184,116,true)
      end
    end
  end
end)