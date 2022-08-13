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
--    Copyright © 2022 Jan Ziegler   --
---------------------------------------
---------------------------------------

---------------------------------------
--   LCARS Scanner Element | Client  --
---------------------------------------

if not istable(ELEMENT) then Star_Trek:LoadAllModules() return end
local SELF = ELEMENT

SELF.BaseElement = "button"

SELF.Variants = 0

function SELF:Initialize(steps)
	SELF.Base.Initialize(self)

	self.Variants = steps
end

-- Draw a given Variant of the element.
--
-- @param Number x
-- @param Number y
-- @param Number i
function SELF:DrawElement(i, x, y)
	local width = self.ElementWidth
	local height = self.ElementHeight

	for j = 1, i do
		local w = width / self.Variants
		local bX = x + (j - 1) * w

		local color = Star_Trek.LCARS.ColorLightBlue
		if i == self.Variants then
			color = Star_Trek.LCARS.ColorOrange
		end

		self:DrawButtonGraphic(bX, y, w - 2, height, color, color_black, j ~= 1, true)
	end
end

-- Returns the current variant of the button.
--
-- @return Number variant
function SELF:GetVariant()
	return self.Progress or 1
end