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

MODE.Name = "Basic Tricorder"
MODE.MenuColor = Star_Trek.LCARS.ColorBlue

function MODE:Activate(ent)

end

function MODE:Deactivate(ent, callback)

end

function MODE:HandleScanData(scanData)
	PrintTable(scanData)
end

function MODE:PrimaryAttack(ent)
	local owner = ent:GetOwner()
	if not IsValid(owner) then
		return
	end

	local trace = owner:GetEyeTrace()
	if IsValid(trace.Entity) then
		local success, scanData = Star_Trek.Sensors:ScanEntity(trace.Entity)
		if success then
			self:HandleScanData(scanData)
		end
	end
end

function MODE:SecondaryAttack(ent)
	local success, scanData = Star_Trek.Sensors:ScanEntity(ent)
	if success then
		self:HandleScanData(scanData)
	end
end