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
--    Copyright © 2022 Jan Ziegler   --
---------------------------------------
---------------------------------------

---------------------------------------
--      LCARS Tricorder | Server     --
---------------------------------------

if not istable(WINDOW) then Star_Trek:LoadAllModules() return end
local SELF = WINDOW

function SELF:OnCreate(color, hFlip)
	local success = SELF.Base.OnCreate(self, color, "Tricorder", "TRI", hFlip, {})
	if not success then
		return false
	end

	return true
end

function SELF:GetClientData()
	local clientData = SELF.Base.GetClientData(self)

	clientData.LastScan = self.LastScan

	return clientData
end

function SELF:EnableScanning()
	self.LastScan = CurTime()
end

function SELF:DisableScanning()
	self.LastScan = nil
end

function SELF:OnPress(interfaceData, ply, buttonId, callback)
	return SELF.Base.OnPress(self, interfaceData, ply, buttonId, callback)
end
