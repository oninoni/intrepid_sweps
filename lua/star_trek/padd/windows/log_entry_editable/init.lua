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
--   LCARS Log Entry Edit | Server   --
---------------------------------------

if not istable(WINDOW) then Star_Trek:LoadAllModules() return end
local SELF = WINDOW

function SELF:OnCreate(preventAutoLink, color, hFlip)
	local success = SELF.Base.OnCreate(self, preventAutoLink, color, hFlip)
	if not success then
		return false
	end

	return true
end

function SELF:GetClientData()
	local clientData = SELF.Base.GetClientData(self)

	clientData.Editing = self.Editing

	return clientData
end

function SELF:OnPress(interfaceData, ply, buttonId, callback)
	return SELF.Base.OnPress(self, interfaceData, ply, buttonId, callback)
end

function SELF:EnableEditing()
	self.Title = "Logs (RECORDING)"

	self.Editing = true
end

function SELF:DisableEditing()
	self.Title = "Logs"

	self.Editing = nil
end