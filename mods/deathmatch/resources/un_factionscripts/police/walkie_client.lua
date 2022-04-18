function playRadioSound()
	local telsiz = playSound("components/walkie.mp3",false)
	setSoundVolume(telsiz, 0.9)
end
addEvent("walkie.sound",true)
addEventHandler("walkie.sound",getRootElement(),playRadioSound)

function playPanic()
	local panic = playSound("components/panic.mp3",false)
	setSoundVolume(panic, 0.9)
end
addEvent("panic.sound",true)
addEventHandler("panic.sound",getRootElement(),playPanic)