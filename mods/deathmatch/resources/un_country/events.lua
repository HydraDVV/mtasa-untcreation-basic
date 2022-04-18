local mysql = exports.un_mysql

addEvent('selected.country', true)
addEventHandler('selected.country', root, function(selected)
  if source:getData('loggedin') == 1 then
    if selected then
      if dbExec(mysql:getConnection(),"UPDATE `characters` SET `ulke`='"..selected.."' WHERE `id`='"..getElementData(source, "dbid").."'") then
          source:setData('country', selected)
          source:outputChat('[UNT]#D0D0D0 Başarıyla ülke seçimi yaptınız!',195,184,116,true)
      else
        source:outputChat('[UNT]#D0D0D0 Bir sorun meydana geldi!',195,184,116,true)
      end
    else
      source:outputChat('[UNT]#D0D0D0 Bir sorun meydana geldi!',195,184,116,true)
    end
  end
end)