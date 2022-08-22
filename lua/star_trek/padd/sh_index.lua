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
--            PADD | Index           --
---------------------------------------

Star_Trek:RequireModules("lcars_swep")

Star_Trek.PADD = Star_Trek.PADD or {}

if SERVER then
	AddCSLuaFile("cl_fonts.lua")
	AddCSLuaFile("cl_padd.lua")

	include("sv_padd.lua")
end

if CLIENT then
	include("cl_fonts.lua")
	include("cl_padd.lua")
end