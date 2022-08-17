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

MODE.Name = "Object Scanner"
MODE.MenuColor = Star_Trek.LCARS.ColorBlue

function MODE:Activate(ply, ent)
	Star_Trek.LCARS:OpenInterface(ply, ent, "tricorder_basic", {})
end

function MODE:Deactivate(ent)
	return
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

	local trace = owner:GetEyeTrace()

	local target = trace.Entity
	local distance = trace.HitPos:Distance(trace.StartPos)
	if not IsValid(target) or distance > Star_Trek.Tricorder.ScanRange then
		if lastScan then
			Star_Trek.Logs:AddEntry(ent, owner, "Object Lost!", Star_Trek.LCARS.ColorRed)
			Star_Trek.Logs:AddEntry(ent, owner, "Scan Disrupted!", Star_Trek.LCARS.ColorRed)
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

					Star_Trek.Logs:AddEntry(ent, owner, "Scan Complete!")
					Star_Trek.Logs:AddEntry(ent, owner, "")
					Star_Trek.Logs:AddEntry(ent, owner, "Scan Data:", Star_Trek.LCARS.ColorOrange)
					Star_Trek.Logs:AddEntry(ent, owner, "")

					local success, scanData = Star_Trek.Sensors:ScanEntity(target)
					if not success then
						Star_Trek.Logs:AddEntry(ent, owner, "Scan Corrupted!", Star_Trek.LCARS.ColorRed, TEXT_ALIGN_RIGHT)
						Star_Trek.Logs:AddEntry(ent, owner, scanData, Star_Trek.LCARS.ColorRed, TEXT_ALIGN_RIGHT)

						return
					end

					Star_Trek.Tricorder:AnalyseScanData(ent, owner, scanData)

					self.Scanned = true
				end
			else
				Star_Trek.Logs:AddEntry(ent, owner, "Object Changed!", Star_Trek.LCARS.ColorRed)
				Star_Trek.Logs:AddEntry(ent, owner, "Scan Disrupted!", Star_Trek.LCARS.ColorRed)
				self:DisableScanning(window)
			end
		else
			Star_Trek.Logs:AddEntry(ent, owner, "")
			Star_Trek.Logs:AddEntry(ent, owner, "Scanning Object...")
			self:EnableScanning(window, target)
		end
	else
		if lastScan then
			if not self.Scanned then
				Star_Trek.Logs:AddEntry(ent, owner, "Scan Aborted!", Star_Trek.LCARS.ColorRed)
			end

			self:DisableScanning(window)
		end
	end
end