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
--   LCARS Log Entry Edit | Client   --
---------------------------------------

if not istable(WINDOW) then Star_Trek:LoadAllModules() return end
local SELF = WINDOW

function SELF:OnCreate(windowData)
	self.TextFont = "LCARSPADDText"
	self.TextHeight = 28

	local success = SELF.Base.OnCreate(self, windowData)
	if not success then
		return false
	end

	if IsValid(self.Panel) then
		self.Panel:Remove()
	end

	self.Editing = nil

	-- Only Editing set for owner.
	local interface = self.Interface
	if istable(interface) then
		local ent = interface.Ent
		if IsValid(ent) then
			local owner = ent:GetOwner()
			if IsValid(owner) and owner == LocalPlayer() then
				self.Editing = windowData.Editing
			end
		end
	end

	if self.Editing then
		Star_Trek.PADD:EnableEditing(self)
	else
		Star_Trek.PADD:DisableEditing()
	end

	return true
end

function SELF:OnPress(pos, animPos)
	return SELF.Base.OnPress(self, pos, animPos)
end

function SELF:OnDraw(pos, animPos)
	SELF.Base.OnDraw(self, pos, animPos)
end


function SELF:OnThink()
	SELF.Base.OnThink(self)
end