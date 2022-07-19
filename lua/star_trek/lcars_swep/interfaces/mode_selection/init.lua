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
--   LCARS Tricorder Modes | Server  --
---------------------------------------

local SELF = INTERFACE
SELF.BaseInterface = "base"

SELF.LogType = false

function SELF:Open(ent, modes)
	local buttons = {}

	for _, modeName in pairs(modes) do
		local modeData = Star_Trek.LCARS_SWEP.Modes[modeName]
		if istable(modeData) then
			local button = {
				Name = modeData.Name,
				Color = modeData.MenuColor,
				Data = modeName,
			}

			table.insert(buttons, button)
		end
	end

	local buttonCount = table.Count(buttons)
	table.insert(buttons, {
		Name = "Close",
	})

	local success, window = Star_Trek.LCARS:CreateWindow(
		"button_list",
		Vector(),
		Angle(),
		ent.MenuScale,
		ent.MenuWidth,
		ent.MenuHeight,
		function(windowData, interfaceData, ply, buttonId)
			interfaceData:Close(function()
				if buttonId < buttonCount + 1 then
					local buttonData = windowData.Buttons[buttonId]
					ent:ActivateMode(buttonData.Data)
				end
			end)
		end,
		buttons,
		(ent.MenuName or "LCARS") .. " Modes",
		"MODES"
	)
	if not success then
		return false, window
	end

	return true, {window}
end