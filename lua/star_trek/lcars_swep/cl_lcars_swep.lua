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

hook.Add("Star_Trek.LCARS.Get3D2DMousePos", "Star_Trek.LCARS_SWEP.OverrideGet3D2DMousePos", function(window, pos)
	local interface = window.Interface
	local ent = interface.Ent

	if IsValid(ent) and ent:IsWeapon() and ent.IsLCARS then
		local scale = ent.CustomWorldModelScale
		if ent.IsViewModelRendering then
			scale = ent.CustomViewModelScale
		end

		return pos / scale
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

function Star_Trek.LCARS_SWEP:SetScreenClicker(enabled, showCursor)
	gui.EnableScreenClicker(enabled)

	if IsValid(self.Panel) then
		self.Panel:Remove()
	end
	
	if enabled then
		self.Panel = vgui.Create("DPanel")
		self.Panel:SetSize(ScrW(), ScrH())
		function self.Panel:Paint(ww, hh)
		end
		
		if not showCursor then
			self.Panel:SetCursor("blank")
		end
	end
end

net.Receive("Star_Trek.LCARS_SWEP.EnableScreenClicker", function()
	Star_Trek.LCARS_SWEP:SetScreenClicker(net.ReadBool(), net.ReadBool())
end)

hook.Add("Star_Trek.LCARS.PreventButton", "Star_Trek.LCARS_SWEP.PreventButton", function(interface)
	local ent = interface.Ent

	if IsValid(ent) and ent:IsWeapon() and ent.IsLCARS and not IsValid(Star_Trek.LCARS_SWEP.Panel) then
		return true
	end
end)