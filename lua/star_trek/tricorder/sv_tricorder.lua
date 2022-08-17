---------------------------------------
---------------------------------------
--        Star Trek Utilities        --
--                                   --
--            Created by             --
--       Jan 'Oninoni' Ziegler       --
--                                   --
-- This software can be used freely, --
--    but only distributed by me.    --
--                                   --
--    Copyright © 2021 Jan Ziegler   --
---------------------------------------
---------------------------------------

---------------------------------------
--         Tricorder | Server        --
---------------------------------------

function Star_Trek.Tricorder:AnalyseScanData(ent, owner, scanData)
	Star_Trek.Logs:AddEntry(ent, owner, scanData.Name, Star_Trek.LCARS.ColorLightBlue, TEXT_ALIGN_LEFT)

	if scanData.Alive then
		Star_Trek.Logs:AddEntry(ent, owner, "Life-Signs Detected!", Star_Trek.LCARS.ColorOrange, TEXT_ALIGN_RIGHT)
	end

	if scanData.IsWeapon then
		Star_Trek.Logs:AddEntry(ent, owner, "Weapons System Detected!", Star_Trek.LCARS.ColorRed, TEXT_ALIGN_RIGHT)
	end

	if isnumber(scanData.Health) then
		if scanData.Alive then
			Star_Trek.Logs:AddEntry(ent, owner, "Life-Sign Intensity:", nil, TEXT_ALIGN_LEFT)
		else
			Star_Trek.Logs:AddEntry(ent, owner, "Structural Integrity:", nil, TEXT_ALIGN_LEFT)
		end

		local color
		if scanData.Health < 0.5 then
			color = Star_Trek.LCARS.ColorOrange
		elseif scanData.Health < 0.25 then
			color = Star_Trek.LCARS.ColorRed
		end
		Star_Trek.Logs:AddEntry(ent, owner, math.Round(scanData.Health * 100, 0) .. "%", color, TEXT_ALIGN_RIGHT)
	end

	if isnumber(scanData.Armor) then
		Star_Trek.Logs:AddEntry(ent, owner, "Armor Integrity:", nil, TEXT_ALIGN_LEFT)

		local color
		if scanData.Armor < 0.5 then
			color = Star_Trek.LCARS.ColorOrange
		elseif scanData.Armor < 0.25 then
			color = Star_Trek.LCARS.ColorRed
		end
		Star_Trek.Logs:AddEntry(ent, owner, math.Round(scanData.Armor * 100, 0) .. "%", color, TEXT_ALIGN_RIGHT)
	end

	if isnumber(scanData.Mass) then
		Star_Trek.Logs:AddEntry(ent, owner, "Mass:", nil, TEXT_ALIGN_LEFT)

		Star_Trek.Logs:AddEntry(ent, owner, math.Round(scanData.Mass, 2) .. "kg", color, TEXT_ALIGN_RIGHT)
	end

	if scanData.Frozen then
		Star_Trek.Logs:AddEntry(ent, owner, "Rigidly Attached", nil, TEXT_ALIGN_LEFT)
	end

	hook.Run("Star_Trek.Tricorder.AnalyseScanData", ent, owner, scanData)
end