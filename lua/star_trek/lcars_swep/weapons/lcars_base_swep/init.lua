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
--      LCARS Base SWEP | Server     --
---------------------------------------

if not istable(SWEP) then Star_Trek:LoadAllModules() return end

function SWEP:InitializeCustom()
	self.LastReload = CurTime()

	self.ActiveMode = false
	self.ModeCache = {}
end

function SWEP:Deploy()
	if self.DefaultMode then
		timer.Simple(0, function()
			self:ActivateMode(self.DefaultMode)
		end)
	end
end

function SWEP:Reload()
	if not IsFirstTimePredicted() then return end

	local owner = self:GetOwner()

	-- Ignore when SPEED Active (Interact Menu)
	if owner:KeyDown(IN_SPEED) then
		return
	end

	if (self.LastReload + 0.1) < CurTime() then
		local interfaceData = Star_Trek.LCARS.ActiveInterfaces[self]
		if istable(interfaceData) then
			Star_Trek.LCARS_SWEP:ToggleScreenClicker(owner)
		else
			Star_Trek.LCARS:OpenInterface(self:GetOwner(), self, "mode_selection", self.Modes)
		end
	else
		self.HoldTime = (self.HoldTime or 0) + (CurTime() - self.LastReload)

		local interfaceData = Star_Trek.LCARS.ActiveInterfaces[self]
		if self.HoldTime > 1 and istable(interfaceData) then
			self:DeactivateMode()

			self.HoldTime = 0
			self.LastReload = CurTime() + 1

			return
		end
	end

	self.LastReload = CurTime()
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end

	if not self.ActiveMode then
		local interfaceData = Star_Trek.LCARS.ActiveInterfaces[self]
		if not istable(interfaceData) then
			Star_Trek.LCARS:OpenInterface(self:GetOwner(), self, "mode_selection", self.Modes)
		end

		return
	end

	if not isfunction(self.ActiveMode.PrimaryAttack) then return end

	self.ActiveMode:PrimaryAttack(self)
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end

	if not self.ActiveMode then
		local interfaceData = Star_Trek.LCARS.ActiveInterfaces[self]
		if not istable(interfaceData) then
			Star_Trek.LCARS:OpenInterface(self:GetOwner(), self, "mode_selection", self.Modes)
		end

		return
	end

	if not isfunction(self.ActiveMode.SecondaryAttack) then return end

	self.ActiveMode:SecondaryAttack(self)
end

function SWEP:Think()
	if self.ActiveMode and isfunction(self.ActiveMode.Think) then
		self.ActiveMode:Think(self)
	end
end

function SWEP:ActivateMode(modeName)
	self:DeactivateMode(function()
		local mode = {}
		if istable(self.ModeCache[modeName]) then
			mode = self.ModeCache[modeName]
		else
			local modeFunctions = Star_Trek.LCARS_SWEP.Modes[modeName]
			if istable(modeFunctions) then
				setmetatable(mode, {__index = modeFunctions})
				self.ModeCache[modeName] = mode
			else
				return
			end
		end

		local ply = self:GetOwner()
		if not IsValid(ply) then
			return
		end

		mode:Activate(ply, self) -- TODO Process the Return Values

		self.ActiveMode = mode
	end)
end

function SWEP:DeactivateMode(callback)
	if istable(self.ActiveMode) then
		self.ActiveMode:Deactivate(self) -- TODO Process the Return Values
		self.ActiveMode = false
	end

	local interface = self.Interface
	if istable(interface) then
		interface:Close(callback)

		return
	end

	if isfunction(callback) then
		callback()
	end
end