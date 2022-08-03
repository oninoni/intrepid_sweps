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
--        PADD Entity | Shared       --
---------------------------------------

SWEP.Base = "lcars_base_swep"

SWEP.PrintName = "PADD - Personal Access Display Device"

SWEP.Author = "Oninoni"
SWEP.Contact = "Discord: Oninoni#8830"
SWEP.Purpose = "Multifunctional device"
SWEP.Instructions = "Press R, to activate. Hold R, to disable."

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3
SWEP.SlotPos = 42

SWEP.WorldModel = "models/oninoni/star_trek/props/padd.mdl"

SWEP.HoldType = "slam"

SWEP.CustomViewModel = "models/oninoni/star_trek/props/padd.mdl"
SWEP.CustomViewModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomViewModelOffset = Vector(4, -10.5, -1)
SWEP.CustomViewModelAngle = Angle(-55, -85, 90)
SWEP.CustomViewModelScale = 2

SWEP.CustomDrawWorldModel = true
SWEP.CustomWorldModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomWorldModelOffset = Vector(4.5, -4, -2)
SWEP.CustomWorldModelAngle = Angle(0, -90, 90)
SWEP.CustomWorldModelScale = 1

SWEP.MenuOffset = Vector(0, -0.9, 0.15)
SWEP.MenuAngle = Angle(0, 180, 0)

SWEP.MenuScale = 110
SWEP.MenuWidth = 550
SWEP.MenuHeight = 690
SWEP.MenuName = "PADD"
SWEP.MenuMouseOffset = Vector(365, 60, 0)
SWEP.MenuSolid = false

SWEP.Modes = {
	"padd_log"
}