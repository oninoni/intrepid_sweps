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
--      LCARS Base SWEP | Client     --
---------------------------------------

SWEP.Category = "Star Trek (Utilities)"

SWEP.DrawAmmo = false

function SWEP:GetPosAngle(world)
	local pos, ang, scale = self:GetPos(), self:GetAngles(), 1

	local owner = self:GetOwner()
	if IsValid(owner) then
		if world then
			local m = owner:GetBoneMatrix(owner:LookupBone(self.CustomWorldModelBone))
			pos, ang = LocalToWorld(self.CustomWorldModelOffset, self.CustomWorldModelAngle, m:GetTranslation(), m:GetAngles())

			scale = self.CustomWorldModelScale
		else
			local vm = owner:GetViewModel()
			if IsValid(vm) then
				local m = vm:GetBoneMatrix(vm:LookupBone(self.CustomViewModelBone))
				pos, ang = LocalToWorld(self.CustomViewModelOffset, self.CustomViewModelAngle, m:GetTranslation(), m:GetAngles())
			end

			scale = self.CustomViewModelScale
		end
	end

	return LocalToWorld(self.MenuOffset * scale, self.MenuAngle, pos, ang)
end

function SWEP:DrawViewModelCustom(flags)
	local interface = Star_Trek.LCARS.ActiveInterfaces[self.InterfaceId]
	if istable(interface) then
		if not interface.IVis then
			return
		end

		if hook.Run("Star_Trek.LCARS.PreventRender", interface, true) then
			return
		end

		if not interface.Solid then
			render.OverrideBlend(true, BLEND_SRC_ALPHA, BLEND_ONE, BLENDFUNC_ADD, BLEND_SRC_ALPHA, BLEND_ONE, BLENDFUNC_ADD)
		end

		for _, window in pairs(interface.Windows) do
			Star_Trek.LCARS:DrawWindow(window, interface.AnimPos, not interface.Closing and IsValid(Star_Trek.LCARS_SWEP.Panel))
		end

		render.OverrideBlend(false)

		surface.SetAlphaMultiplier(1)
	end
end