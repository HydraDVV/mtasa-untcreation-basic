Fix = Service:new('fix-system')
author = 'github.com/bekiroj'
font = DxFont('components/Roboto.ttf', 9)
screen = Vector2(guiGetScreenSize())
show = false
dxDrawRectangle = dxDrawRectangle
dxDrawImage = dxDrawImage
dxDrawText = dxDrawText
zone = createMarker(1911.162109375, -1776.2392578125, 13.3828125, "cylinder", 5, 255, 255, 0, 0)

Fix.constructor = function()
	addEventHandler("onClientMarkerHit", zone, Fix.enteredZone)
end

Fix.enteredZone = function(hitPlayer)
	if hitPlayer == localPlayer then
		local vehicle = localPlayer.vehicle
		if vehicle then
			local seat = localPlayer.vehicleSeat
			if seat == 0 then
				show = true
				active = false
				showCursor(true)
				Fix.render = Timer(
					function()
						if show then
							dxDrawOuterBorder(screen.x/2-500/2, screen.y/2-350/2, 500, 170, 2, tocolor(10,10,10,250))
							dxDrawRectangle(screen.x/2-500/2, screen.y/2-350/2, 500, 170, tocolor(0,0,0,255))
							dxDrawRectangle(screen.x/2-500/2, screen.y/2-350/2, 500, 170, tocolor(5,5,5,225))
							dxDrawText('@UNT:Creation',screen.x/2-485/2, screen.y/2-340/2, 650, 150, tocolor(155,155,155,250), 1, font)
							dxDrawText("Pay N Spray'e hoşgeldiniz, aracınız arızalı gözüküyor hemen bakım yaptırmak istermisiniz?",screen.x/2-450/2, screen.y/2-285/2, 650, 150, tocolor(200,200,200,250), 1, font)
							dxDrawText("Hemde bunu sadece 2500₺ ödeyerek yapabilirsiniz!",screen.x/2-450/2, screen.y/2-245/2, 650, 150, tocolor(200,200,200,250), 1, font)
							dxDrawImage(screen.x/2-75/2, screen.y/2-145/2, 75, 75, 'components/logo.png')
							dxDrawText("Arayüzü kapatmak için aşağıdaki logoya tıklatın!",screen.x/2-450/2, screen.y/2-160/2, 650, 150, tocolor(200,200,200,250), 1, font)

							if isMouseInPosition(screen.x/2-75/2, screen.y/2-145/2, 75, 75) and getKeyState("mouse1") then
								Fix.close()
							end

							if isMouseInPosition(screen.x/2+100/2, screen.y/2-240/2, 55, 25) and getKeyState("mouse1") then
								dxDrawRectangle(screen.x/2+100/2, screen.y/2-240/2, 55, 25, tocolor(50,5,5,200))
								dxDrawText('Tamir Et',screen.x/2+113/2, screen.y/2-233/2, 650, 150, tocolor(200,200,200,250), 1, font)
								if not active then
									active = true
									triggerServerEvent('vehicle.fix', localPlayer)
									Fix.timer()
								end
							else
								dxDrawRectangle(screen.x/2+100/2, screen.y/2-240/2, 55, 25, tocolor(70,5,5,200))
								dxDrawText('Tamir Et',screen.x/2+113/2, screen.y/2-233/2, 650, 150, tocolor(200,200,200,250), 1, font)
							end

						else
							Fix.close()
						end
					end,
				7, 0)
			end
		end
	end
end

Fix.timer = function()
	Fix.timerEnd = Timer(
		function()
			active = false
		end,
	5200, 1)
end

Fix.close = function()
	showCursor(false)
	show = false
	killTimer(Fix.render)
end

Fix.constructor()