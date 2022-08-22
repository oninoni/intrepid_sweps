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
--         Tricorder | Index         --
---------------------------------------

Star_Trek:RequireModules("lcars_swep")

Star_Trek.Tricorder = Star_Trek.Tricorder or {}

if SERVER then
	AddCSLuaFile("sh_config.lua")
	AddCSLuaFile("sh_sounds.lua")

	include("sh_config.lua")
	include("sh_sounds.lua")
	include("sv_tricorder.lua")
end

if CLIENT then
	include("sh_config.lua")
	include("sh_sounds.lua")
end