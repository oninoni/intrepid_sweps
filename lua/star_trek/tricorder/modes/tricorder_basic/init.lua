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
--     Tricorder - Basic | Server    --
---------------------------------------

MODE.BaseMode = "base"

MODE.Name = "Basic Scanner"
MODE.MenuColor = Star_Trek.LCARS.ColorBlue

function MODE:Activate(ply, ent)
	Star_Trek.LCARS:OpenInterface(ply, ent, "tricorder_basic", {})
end

function MODE:Deactivate(ent)
	return
end

function MODE:ScanEntity(ent)
	if not IsValid(ent) then
		return
	end

	local success, scanData = Star_Trek.Sensors:ScanEntity(ent)
	if success then
		PrintTable(scanData)
	end
end

function MODE:PrimaryAttack(ent)
end

function MODE:SecondaryAttack(ent)
end

function MODE:EnableScanning(window, target)
	self.TargetLock = target
	self.Scanned = nil

	window:EnableScanning()
	window:Update()
end

function MODE:DisableScanning(window)
	self.Scanned = nil
	self.TargetLock = nil

	window:DisableScanning()
	window:Update()
end

local SCAN_TIME = Star_Trek.Tricorder.ScanTime

function MODE:Think(ent)
	local interface = ent.Interface
	if not istable(interface) then
		return
	end

	local window = interface.Windows[1]
	local lastScan = window.LastScan

	local owner = ent:GetOwner()
	if not IsValid(owner) then
		return
	end

	local target = owner:GetEyeTrace().Entity
	if not IsValid(target) then
		if lastScan then
			self:DisableScanning(window)
		end

		return
	end

	if owner:KeyDown(IN_ATTACK) then
		if lastScan then
			if IsValid(self.TargetLock) and self.TargetLock == target then
				local diff = CurTime() - lastScan
				if diff > SCAN_TIME then
					if self.Scanned then return end

					print(target)

					self.Scanned = true
				end
			else
				self:DisableScanning(window)
			end
		else
			self:EnableScanning(window, target)
		end
	else
		if lastScan then
			self:DisableScanning(window)
		end
	end
end