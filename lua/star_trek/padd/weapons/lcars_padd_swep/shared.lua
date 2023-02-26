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
--        PADD Entity | Shared       --
---------------------------------------

if not istable(SWEP) then Star_Trek:LoadAllModules() return end

SWEP.Base = "lcars_base_swep"

SWEP.PrintName = "PADD - Personal Access Display Device"

SWEP.Author = "Oninoni"
SWEP.Contact = "Discord: Oninoni#8830"
SWEP.Purpose = "Multifunctional device"
SWEP.Instructions = "Press R to activate. Hold R to disable."

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3
SWEP.SlotPos = 42

SWEP.WorldModel = "models/oninoni/star_trek/props/padd.mdl"

SWEP.HoldType = "slam"

SWEP.BoneManip = {
	["ValveBiped.Bip01_R_Clavicle"] = {
		Ang = Angle(-30, 0, 0),
	},
	["ValveBiped.Bip01_Spine"] = {
		Pos = Vector(-3, 0, 0),
	},
	["ValveBiped.cube3"] = {
		Pos = Vector(-100, 0, 0),
	},
}

SWEP.CustomViewModel = "models/oninoni/star_trek/props/padd.mdl"
SWEP.CustomViewModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomViewModelOffset = Vector(2, -10.5, 0)
SWEP.CustomViewModelAngle = Angle(-54, -103, 90)
SWEP.CustomViewModelScale = 2

SWEP.CustomDrawWorldModel = true
SWEP.CustomWorldModelBone = "ValveBiped.Bip01_R_Hand"
SWEP.CustomWorldModelOffset = Vector(4.5, -4, -2)
SWEP.CustomWorldModelAngle = Angle(0, -90, 90)
SWEP.CustomWorldModelScale = 1

SWEP.MenuOffset = Vector(0, -0.9, 0.15)
SWEP.MenuAngle = Angle(0, 180, 0)

SWEP.MenuScale = 90
SWEP.MenuWidth = 450
SWEP.MenuHeight = 565
SWEP.MenuName = "PADD"
SWEP.MenuMouseOffset = Vector(1350, 0, 0)
SWEP.MenuSolid = false

SWEP.Modes = {
	"padd_log",
	"padd_personal_log"
}