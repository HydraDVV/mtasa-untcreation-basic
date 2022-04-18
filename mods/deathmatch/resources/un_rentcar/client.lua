Rent = Service:new('carrent-system')
author = 'github.com/bekiroj'
font = DxFont('components/Roboto.ttf', 9)
screen = Vector2(guiGetScreenSize())
show = false
dxDrawRectangle = dxDrawRectangle
dxDrawImage = dxDrawImage
dxDrawText = dxDrawText
region = ColShape.Sphere(439.5439453125, -1549.572265625, 28.059703826904, 3)
pickup = Pickup(439.5439453125, -1549.572265625, 28.059703826904, 3, 1239)
pickup:setData('informationicon:information', '#7f8fa6/kirala\n#ffffff Araç Kiralama Noktası')

Rent.constructor = function()
	if localPlayer:isWithinColShape(region) then
		show = true
		active = false
		showCursor(true)

		Rent.render = Timer(
			function()
				if show then
					dxDrawOuterBorder(screen.x/2-500/2, screen.y/2-350/2, 500, 400, 2, tocolor(10,10,10,250))
					dxDrawRectangle(screen.x/2-500/2, screen.y/2-350/2, 500, 400, tocolor(0,0,0,255))
					dxDrawRectangle(screen.x/2-500/2, screen.y/2-350/2, 500, 400, tocolor(5,5,5,225))
					dxDrawRectangle(screen.x/2-450/2, screen.y/2-250/2, 450, 250, tocolor(5,5,5,225))
					dxDrawText('@UNT:Creation',screen.x/2-485/2, screen.y/2-340/2, 650, 150, tocolor(155,155,155,250), 1, font)
					dxDrawText('Araç kiralamaya hoşgeldin, listedeki araçları görüyorsun,',screen.x/2-450/2, screen.y/2+270/2, 650, 150, tocolor(200,200,200,250), 1, font)
					dxDrawText('arayüzü kapatmak için lütfen aşağıdaki logoya tıklamayı deneyin!',screen.x/2-450/2, screen.y/2+300/2, 650, 150, tocolor(200,200,200,250), 1, font)
					dxDrawImage(screen.x/2-75/2, screen.y/2+315/2, 75, 75, 'components/logo.png')

					if isMouseInPosition(screen.x/2-75/2, screen.y/2+315/2, 75, 75) and getKeyState("mouse1") then
						Rent.close()
					end

					dxDrawText('- Marka',screen.x/2-450/2, screen.y/2-285/2, 650, 150, tocolor(200,200,200,250), 1, font)
					dxDrawText('- Fiyat',screen.x/2+125/2, screen.y/2-285/2, 650, 150, tocolor(200,200,200,250), 1, font)

					dxDrawText('- Peugeot Partner',screen.x/2-450/2, screen.y/2-235/2, 650, 150, tocolor(200,200,200,250), 1, font)
					dxDrawText('- 1130₺',screen.x/2+125/2, screen.y/2-235/2, 650, 150, tocolor(200,200,200,250), 1, font)

					if isMouseInPosition(screen.x/2+335/2, screen.y/2-240/2, 50, 25) and getKeyState("mouse1") then
						dxDrawRectangle(screen.x/2+335/2, screen.y/2-240/2, 50, 20, tocolor(5,70,5,200))
						dxDrawText('Kirala',screen.x/2+355/2, screen.y/2-235/2, 650, 150, tocolor(200,200,200,250), 1, font)
						if not active then
							active = true
							triggerServerEvent('car.rent', localPlayer, 540, 1130)
							Rent.timer()
						end
					else
						dxDrawRectangle(screen.x/2+335/2, screen.y/2-240/2, 50, 20, tocolor(5,100,5,200))
						dxDrawText('Kirala',screen.x/2+355/2, screen.y/2-235/2, 650, 150, tocolor(200,200,200,250), 1, font)
					end

					dxDrawText('- Opel Corsa',screen.x/2-450/2, screen.y/2-170/2, 650, 150, tocolor(200,200,200,250), 1, font)
					dxDrawText('- 1450₺',screen.x/2+125/2, screen.y/2-170/2, 650, 150, tocolor(200,200,200,250), 1, font)

					if isMouseInPosition(screen.x/2+335/2, screen.y/2-180/2, 50, 25) and getKeyState("mouse1") then
						dxDrawRectangle(screen.x/2+335/2, screen.y/2-180/2, 50, 20, tocolor(5,70,5,200))
						dxDrawText('Kirala',screen.x/2+355/2, screen.y/2-175/2, 650, 150, tocolor(200,200,200,250), 1, font)
						if not active then
							active = true
							triggerServerEvent('car.rent', localPlayer, 439, 1450)
							Rent.timer()
						end
					else
						dxDrawRectangle(screen.x/2+335/2, screen.y/2-180/2, 50, 20, tocolor(5,100,5,200))
						dxDrawText('Kirala',screen.x/2+355/2, screen.y/2-175/2, 650, 150, tocolor(200,200,200,250), 1, font)
					end

					dxDrawText('- Toyota Corolla',screen.x/2-450/2, screen.y/2-105/2, 650, 150, tocolor(200,200,200,250), 1, font)
					dxDrawText('- 970₺',screen.x/2+125/2, screen.y/2-105/2, 650, 150, tocolor(200,200,200,250), 1, font)

					if isMouseInPosition(screen.x/2+335/2, screen.y/2-115/2, 50, 25) and getKeyState("mouse1") then
						dxDrawRectangle(screen.x/2+335/2, screen.y/2-115/2, 50, 20, tocolor(5,70,5,200))
						dxDrawText('Kirala',screen.x/2+355/2, screen.y/2-110/2, 650, 150, tocolor(200,200,200,250), 1, font)
						if not active then
							active = true
							triggerServerEvent('car.rent', localPlayer, 492, 970)
							Rent.timer()
						end
					else
						dxDrawRectangle(screen.x/2+335/2, screen.y/2-115/2, 50, 20, tocolor(5,100,5,200))
						dxDrawText('Kirala',screen.x/2+355/2, screen.y/2-110/2, 650, 150, tocolor(200,200,200,250), 1, font)
					end
				else
					Rent.close()
				end
			end,
		7, 0)
	end
end

Rent.timer = function()
	Rent.timerEnd = Timer(
		function()
			active = false
		end,
	2000, 1)
end

Rent.close = function()
	showCursor(false)
	show = false
	killTimer(Rent.render)
end

addCommandHandler('kirala', Rent.constructor)