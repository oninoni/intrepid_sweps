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
--        PADD Entity | Client       --
---------------------------------------

if not istable(SWEP) then Star_Trek:LoadAllModules() return end

SWEP.Category = "Star Trek (Utilities)"

SWEP.DrawAmmo = false