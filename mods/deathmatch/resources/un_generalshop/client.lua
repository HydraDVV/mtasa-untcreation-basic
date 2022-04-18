Shop = Service:new('shop-system')
author = 'github.com/bekiroj'
font = DxFont('components/Roboto.ttf', 9)
screen = Vector2(guiGetScreenSize())
show = false
dxDrawRectangle = dxDrawRectangle
dxDrawImage = dxDrawImage
dxDrawText = dxDrawText
ped = createPed(52, -28.8828125, -186.8203125, 1003.546875)
setElementInterior(ped, 17)
setElementDimension(ped, 11)
setElementRotation(ped, 0, 0, 359.53582763672, "default", true)
setElementData( ped, "talk", 1, false )
setElementData( ped, "name", "Ali Soyyiğit", false )
setElementFrozen(ped, true)

Shop.constructor = function()
	show = true
	active = false
	showCursor(true)

	Shop.render = Timer(
		function()
			if show then
				dxDrawOuterBorder(screen.x/2-500/2, screen.y/2-350/2, 500, 400, 2, tocolor(10,10,10,250))
				dxDrawRectangle(screen.x/2-500/2, screen.y/2-350/2, 500, 400, tocolor(0,0,0,255))
				dxDrawRectangle(screen.x/2-500/2, screen.y/2-350/2, 500, 400, tocolor(5,5,5,225))
				dxDrawRectangle(screen.x/2-450/2, screen.y/2-250/2, 450, 250, tocolor(5,5,5,225))
				dxDrawText('@UNT:Creation',screen.x/2-485/2, screen.y/2-340/2, 650, 150, tocolor(155,155,155,250), 1, font)
				dxDrawText('Markete hoşgeldin, listedeki eşyaları görüyorsun,',screen.x/2-450/2, screen.y/2+270/2, 650, 150, tocolor(200,200,200,250), 1, font)
				dxDrawText('arayüzü kapatmak için lütfen aşağıdaki logoya tıklamayı deneyin!',screen.x/2-450/2, screen.y/2+300/2, 650, 150, tocolor(200,200,200,250), 1, font)
				dxDrawImage(screen.x/2-75/2, screen.y/2+315/2, 75, 75, 'components/logo.png')

				if isMouseInPosition(screen.x/2-75/2, screen.y/2+315/2, 75, 75) and getKeyState("mouse1") then
					Shop.close()
				end

				dxDrawText('- Eşya Adı',screen.x/2-450/2, screen.y/2-285/2, 650, 150, tocolor(200,200,200,250), 1, font)
				dxDrawText('- Fiyat',screen.x/2+125/2, screen.y/2-285/2, 650, 150, tocolor(200,200,200,250), 1, font)

				dxDrawText('- Cep Telefonu',screen.x/2-450/2, screen.y/2-235/2, 650, 150, tocolor(200,200,200,250), 1, font)
				dxDrawText('- 1000₺',screen.x/2+125/2, screen.y/2-235/2, 650, 150, tocolor(200,200,200,250), 1, font)

				if isMouseInPosition(screen.x/2+335/2, screen.y/2-240/2, 50, 25) and getKeyState("mouse1") then
					dxDrawRectangle(screen.x/2+335/2, screen.y/2-240/2, 50, 20, tocolor(5,70,5,200))
					dxDrawText('Satın Al',screen.x/2+345/2, screen.y/2-235/2, 650, 150, tocolor(200,200,200,250), 1, font)
					if not active then
						active = true
						triggerServerEvent('shop.giveItem', localPlayer, 2, 1000)
						Shop.timer()
					end
				else
					dxDrawRectangle(screen.x/2+335/2, screen.y/2-240/2, 50, 20, tocolor(5,100,5,200))
					dxDrawText('Satın Al',screen.x/2+345/2, screen.y/2-235/2, 650, 150, tocolor(200,200,200,250), 1, font)
				end

				dxDrawText('- Kasa',screen.x/2-450/2, screen.y/2-170/2, 650, 150, tocolor(200,200,200,250), 1, font)
				dxDrawText('- 400₺',screen.x/2+125/2, screen.y/2-170/2, 650, 150, tocolor(200,200,200,250), 1, font)

				if isMouseInPosition(screen.x/2+335/2, screen.y/2-180/2, 50, 25) and getKeyState("mouse1") then
					dxDrawRectangle(screen.x/2+335/2, screen.y/2-180/2, 50, 20, tocolor(5,70,5,200))
					dxDrawText('Satın Al',screen.x/2+345/2, screen.y/2-175/2, 650, 150, tocolor(200,200,200,250), 1, font)
					if not active then
						active = true
						triggerServerEvent('shop.giveItem', localPlayer, 400, 60)
						Shop.timer()
					end
				else
					dxDrawRectangle(screen.x/2+335/2, screen.y/2-180/2, 50, 20, tocolor(5,100,5,200))
					dxDrawText('Satın Al',screen.x/2+345/2, screen.y/2-175/2, 650, 150, tocolor(200,200,200,250), 1, font)
				end

				dxDrawText('- Sigara Paketi',screen.x/2-450/2, screen.y/2-105/2, 650, 150, tocolor(200,200,200,250), 1, font)
				dxDrawText('- 75₺',screen.x/2+125/2, screen.y/2-105/2, 650, 150, tocolor(200,200,200,250), 1, font)

				if isMouseInPosition(screen.x/2+335/2, screen.y/2-115/2, 50, 25) and getKeyState("mouse1") then
					dxDrawRectangle(screen.x/2+335/2, screen.y/2-115/2, 50, 20, tocolor(5,70,5,200))
					dxDrawText('Satın Al',screen.x/2+345/2, screen.y/2-110/2, 650, 150, tocolor(200,200,200,250), 1, font)
					if not active then
						active = true
						triggerServerEvent('shop.giveItem', localPlayer, 105, 75)
						Shop.timer()
					end
				else
					dxDrawRectangle(screen.x/2+335/2, screen.y/2-115/2, 50, 20, tocolor(5,100,5,200))
					dxDrawText('Satın Al',screen.x/2+345/2, screen.y/2-110/2, 650, 150, tocolor(200,200,200,250), 1, font)
				end

				dxDrawText('- Sarma Paketi',screen.x/2-450/2, screen.y/2-40/2, 650, 150, tocolor(200,200,200,250), 1, font)
				dxDrawText('- 100₺',screen.x/2+125/2, screen.y/2-40/2, 650, 150, tocolor(200,200,200,250), 1, font)

				if isMouseInPosition(screen.x/2+335/2, screen.y/2-55/2, 50, 25) and getKeyState("mouse1") then
					dxDrawRectangle(screen.x/2+335/2, screen.y/2-55/2, 50, 20, tocolor(5,70,5,200))
					dxDrawText('Satın Al',screen.x/2+345/2, screen.y/2-50/2, 650, 150, tocolor(200,200,200,250), 1, font)
					if not active then
						active = true
						triggerServerEvent('shop.giveItem', localPlayer, 181, 100)
						Shop.timer()
					end
				else
					dxDrawRectangle(screen.x/2+335/2, screen.y/2-55/2, 50, 20, tocolor(5,100,5,200))
					dxDrawText('Satın Al',screen.x/2+345/2, screen.y/2-50/2, 650, 150, tocolor(200,200,200,250), 1, font)
				end

				dxDrawText('- Çakmak',screen.x/2-450/2, screen.y/2+25/2, 650, 150, tocolor(200,200,200,250), 1, font)
				dxDrawText('- 50₺',screen.x/2+125/2, screen.y/2+25/2, 650, 150, tocolor(200,200,200,250), 1, font)

				if isMouseInPosition(screen.x/2+335/2, screen.y/2+15/2, 50, 25) and getKeyState("mouse1") then
					dxDrawRectangle(screen.x/2+335/2, screen.y/2+15/2, 50, 20, tocolor(5,70,5,200))
					dxDrawText('Satın Al',screen.x/2+345/2, screen.y/2+20/2, 650, 150, tocolor(200,200,200,250), 1, font)
					if not active then
						active = true
						triggerServerEvent('shop.giveItem', localPlayer, 107, 50)
						Shop.timer()
					end
				else
					dxDrawRectangle(screen.x/2+335/2, screen.y/2+15/2, 50, 20, tocolor(5,100,5,200))
					dxDrawText('Satın Al',screen.x/2+345/2, screen.y/2+20/2, 650, 150, tocolor(200,200,200,250), 1, font)
				end

				dxDrawText('- Saksı',screen.x/2-450/2, screen.y/2+90/2, 650, 150, tocolor(200,200,200,250), 1, font)
				dxDrawText('- 150₺',screen.x/2+125/2, screen.y/2+90/2, 650, 150, tocolor(200,200,200,250), 1, font)

				if isMouseInPosition(screen.x/2+335/2, screen.y/2+85/2, 50, 25) and getKeyState("mouse1") then
					dxDrawRectangle(screen.x/2+335/2, screen.y/2+85/2, 50, 20, tocolor(5,70,5,200))
					dxDrawText('Satın Al',screen.x/2+345/2, screen.y/2+90/2, 650, 150, tocolor(200,200,200,250), 1, font)
					if not active then
						active = true
						triggerServerEvent('shop.giveItem', localPlayer, 333, 150)
						Shop.timer()
					end
				else
					dxDrawRectangle(screen.x/2+335/2, screen.y/2+85/2, 50, 20, tocolor(5,100,5,200))
					dxDrawText('Satın Al',screen.x/2+345/2, screen.y/2+90/2, 650, 150, tocolor(200,200,200,250), 1, font)
				end

				dxDrawText('- Boombox',screen.x/2-450/2, screen.y/2+155/2, 650, 150, tocolor(200,200,200,250), 1, font)
				dxDrawText('- 500₺',screen.x/2+125/2, screen.y/2+155/2, 650, 150, tocolor(200,200,200,250), 1, font)

				if isMouseInPosition(screen.x/2+335/2, screen.y/2+150/2, 50, 25) and getKeyState("mouse1") then
					dxDrawRectangle(screen.x/2+335/2, screen.y/2+150/2, 50, 20, tocolor(5,70,5,200))
					dxDrawText('Satın Al',screen.x/2+345/2, screen.y/2+155/2, 650, 150, tocolor(200,200,200,250), 1, font)
					if not active then
						active = true
						triggerServerEvent('shop.giveItem', localPlayer, 54, 500)
						Shop.timer()
					end
				else
					dxDrawRectangle(screen.x/2+335/2, screen.y/2+150/2, 50, 20, tocolor(5,100,5,200))
					dxDrawText('Satın Al',screen.x/2+345/2, screen.y/2+155/2, 650, 150, tocolor(200,200,200,250), 1, font)
				end
			else
				Shop.close()
			end
		end,
	7, 0)
end

Shop.timer = function()
	Shop.timerEnd = Timer(
		function()
			active = false
		end,
	2000, 1)
end

Shop.close = function()
	showCursor(false)
	show = false
	killTimer(Shop.render)
end

addEvent("shop.render", true)
addEventHandler("shop.render", getRootElement(), Shop.constructor)