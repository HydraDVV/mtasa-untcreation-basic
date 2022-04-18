addEvent('horserace.takemoney', true)
addEventHandler('horserace.takemoney', root, function()
  if source:getData('loggedin') == 1 then
    exports.un_global:takeMoney(source, 5000)
  end
end)

addEvent('horserace.givemoney', true)
addEventHandler('horserace.givemoney', root, function()
  if source:getData('loggedin') == 1 then
    exports.un_global:giveMoney(source, 12500)
  end
end)