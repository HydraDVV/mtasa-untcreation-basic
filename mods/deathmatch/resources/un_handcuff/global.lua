controls = { "fire", "next_weapon", "previous_weapon","jump","action","aim_weapon","vehicle_fire", "vehicle_secondary_fire","vehicle_left", "vehicle_right", "steer_forward", "steer_back", "accelerate", "brake_reverse", "sprint"}

function kelepcele(target, durum)
	if target and durum then
		if durum == "ver" then
			setPedWeaponSlot(target, 0)
			setElementData(target, "kelepce", true)
			bindKey(target, "fire","both", engelle)
			bindKey(target, "jump","both", engelle)
			bindKey(target, "sprint","both", engelle)
			bindKey(target, "crouch","both", engelle)
			for i, v in ipairs(controls) do
				toggleControl(target, v, false)
			end	
		end
		if durum == "al" then
			setPedAnimation(target)
			for i, v in ipairs(controls) do
				toggleControl(target, v, true)
			end	
			setElementData(target, "kelepce", nil)
		end
		if durum == "ipver" then
			setPedWeaponSlot(target, 0)
			setElementData(target, "ipbagli", true)
			bindKey(target, "fire","both", engelle)
			bindKey(target, "jump","both", engelle)
			bindKey(target, "sprint","both", engelle)
			bindKey(target, "crouch","both", engelle)
			for i, v in ipairs(controls) do
				toggleControl(target, v, false)
			end	
		end
		if durum == "ipal" then
			setPedAnimation(target)
			for i, v in ipairs(controls) do
				toggleControl(target, v, true)
			end	
			setElementData(target, "ipbagli", nil)
		end
	end
end
addEvent("kelepcele",true)
addEventHandler("kelepcele",root,kelepcele)