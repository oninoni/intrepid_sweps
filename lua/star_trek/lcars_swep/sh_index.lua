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
--         LCARS SWEP | Index        --
---------------------------------------

Star_Trek:RequireModules("lcars")

Star_Trek.LCARS_SWEP = Star_Trek.LCARS_SWEP or {}

if SERVER then
	AddCSLuaFile("cl_lcars_swep.lua")

	include("sv_lcars_swep.lua")
end

if CLIENT then
	include("cl_lcars_swep.lua")
end