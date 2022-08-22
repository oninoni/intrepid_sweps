---------------------------------------
---------------------------------------
--         Star Trek Modules         --
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

local SELF = INTERFACE
SELF.BaseInterface = "base"

SELF.LogType = "Tricorder Scan"
SELF.LogMobile = true

function SELF:Open(ent)
	local success, window = Star_Trek.LCARS:CreateWindow(
		"tricorder",
		Vector(),
		Angle(),
		ent.MenuScale,
		ent.MenuWidth,
		ent.MenuHeight,
		function(windowData, interfaceData, buttonId)

		end,
		Color(255, 255, 255)
	)

	if not success then
		return false, window
	end

	return true, {window}
end