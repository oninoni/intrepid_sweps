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
--     Tricorder Entity | Shared     --
---------------------------------------

SWEP.Base = "lcars_base_swep"

SWEP.PrintName = "TR-590 Tricorder X"

SWEP.Author = "Oninoni"
SWEP.Contact = "Discord: Oninoni#8830"
SWEP.Purpose = "Multifunctional device"
SWEP.Instructions = "Press R, to activate. Hold R, to disable."

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3
SWEP.SlotPos = 42

SWEP.WorldModel = "models/ef2weapons/tricorder_stx/tricorder.mdl"

SWEP.CustomViewModel = "models/ef2weapons/tricorder_stx/tricorder.mdl"
SWEP.CustomViewModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomViewModelOffset = Vector(3, -9, -1)
SWEP.CustomViewModelAngle = Angle(0, 180, -35)
SWEP.CustomViewModelScale = 2

SWEP.CustomDrawWorldModel = true
SWEP.CustomWorldModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomWorldModelOffset = Vector(4, -3, -2)
SWEP.CustomWorldModelAngle = Angle(0, 180, -90)
SWEP.CustomWorldModelScale = 1

SWEP.MenuOffset = Vector(1, 0.2, 0)
SWEP.MenuAngle = Angle(90, 0, 0)

SWEP.MenuScale = 100
SWEP.MenuWidth = 400
SWEP.MenuHeight = 650
SWEP.MenuName = "PADD"
SWEP.MenuMouseOffset = Vector(450, 150, 0)
SWEP.MenuSolid = true

SWEP.Modes = {
	"tricorder_basic"
}