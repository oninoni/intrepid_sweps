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
--        LCARS SWEP | Client        --
---------------------------------------

hook.Add("Star_Trek.LCARS.OverridePosAng", "Star_Trek.LCARS_SWEP.OverrideSWEPViewmodel", function(ent, pos, ang)
	if IsValid(ent) and ent:IsWeapon() and ent.IsLCARS then
		local world = not ent.IsViewModelRendering
		return ent:GetPosAngle(world)
	end
end)

hook.Add("Star_Trek.LCARS.OverrideWindowPosAngScale", "Star_Trek.LCARS_SWEP.OverrideSWEPViewmodel", function(window)
	local interface = window.Interface
	local ent = interface.Ent

	if IsValid(ent) and ent:IsWeapon() and ent.IsLCARS then
		local pos, ang = Star_Trek.LCARS:GetInterfacePosAngle(ent, interface.IPos, interface.IAng)
		local wPos, wAng, wScale = window.WPos, window.WAng, window.WScale

		local scale = ent.CustomWorldModelScale
		if ent.IsViewModelRendering then
			scale = ent.CustomViewModelScale
		end

		wPos = wPos * scale
		wScale = wScale / scale

		local wPosG, wAngG = LocalToWorld(wPos, wAng, pos, ang)
		return wPosG, wAngG, wScale
	end
end)

hook.Add("Star_Trek.LCARS.GetMouseOffset", "Star_Trek.LCARS_SWEP.OverrideMouseOffset", function(window)
	local interface = window.Interface
	local ent = interface.Ent

	if IsValid(ent) and ent:IsWeapon() and ent.IsLCARS and isvector(ent.MenuMouseOffset) then
		return ent.MenuMouseOffset.x, ent.MenuMouseOffset.y
	end
end)

hook.Add("Star_Trek.LCARS.MouseActive", Star_Trek.LCARS_SWEP.OverrideMouseActive, function(window)
	local interface = window.Interface
	local ent = interface.Ent

	if IsValid(ent) and ent:IsWeapon() and ent.IsLCARS then
		if IsValid(Star_Trek.LCARS.Panel) then
			return true
		else
			return false
		end
	end
end)

hook.Add("Star_Trek.LCARS.PreventRender", "Star_Trek.LCARS_SWEP.PreventRender", function(interface, ignoreViewModel)
	local ent = interface.Ent
	if IsValid(ent) and ent:IsWeapon() and ent.IsLCARS then
		local owner = ent:GetOwner()
		if IsValid(owner) then
			if owner:GetActiveWeapon() ~= ent then
				return true
			end

			if not ignoreViewModel and ent.IsViewModelRendering then
				return true
			end
		end
	end
end)

hook.Add("Star_Trek.LCARS.PreventButton", "Star_Trek.LCARS_SWEP.PreventButton", function(interface)
	local ent = interface.Ent

	if IsValid(ent) and ent:IsWeapon() and ent.IsLCARS and not IsValid(Star_Trek.LCARS.Panel) then
		return true
	end
end)

hook.Add("HUDPaint", "Star_Trek.LCARS_SWEP.HUDPaint", function()
	local w = ScrW()

	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and wep.IsLCARS then
		draw.DrawText(wep.Instructions, "LCARSBig", w / 2, 20, color_white, TEXT_ALIGN_CENTER)
	end
end)