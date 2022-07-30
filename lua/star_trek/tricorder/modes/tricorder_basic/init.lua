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
	local owner = ent:GetOwner()
	if not IsValid(owner) then
		return
	end

	local trace = owner:GetEyeTrace()
	self:ScanEntity(trace.Entity)
end

function MODE:SecondaryAttack(ent)
	self:ScanEntity(ent)
end