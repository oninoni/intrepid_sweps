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
--   LCARS Log Entry Edit | Client   --
---------------------------------------

if not istable(WINDOW) then Star_Trek:LoadAllModules() return end
local SELF = WINDOW

function SELF:OnCreate(windowData)
	local success = SELF.Base.OnCreate(self, windowData)
	if not success then
		return false
	end

	self.Editing = nil

	-- Only Editing set for owner.
	local interface = self.Interface
	if istable(interface) then
		local ent = interface.Ent
		if IsValid(ent) then
			local owner = ent:GetOwner()
			if IsValid(owner) and owner == LocalPlayer() then
				self.Editing = windowData.Editing
			end
		end
	end

	if self.Editing then
		Star_Trek.PADD:EnableEditing(self)
	else
		Star_Trek.PADD:DisableEditing()
	end

	return true
end

function SELF:ProcessText(lines)
	SELF.Base.ProcessText(self, lines)

	local totalCharacters = 0
	for i, line in pairs(self.Lines) do
		if i < 8 then continue end

		local charCount = #line.Text

		line.First = totalCharacters
		totalCharacters = totalCharacters + charCount + 1
	end
end

function SELF:OnPress(pos, animPos)
	return SELF.Base.OnPress(self, pos, animPos)
end

function SELF:OnDraw(pos, animPos)
	SELF.Base.OnDraw(self, pos, animPos)

	if not self.Editing then return end

	local caretPos = self.CaretPos + 1
	if isnumber(caretPos) then
		for i, line in pairs(self.Lines) do
			if i < 8 then continue end

			local caretCharPos = caretPos - line.First
			if caretCharPos >= 0 and caretCharPos <= #line.Text then
				surface.SetFont(self.TextFont)

				local subString = string.sub(line.Text, 1, caretCharPos)

				local x = surface.GetTextSize(subString)
				local y = self.Area1Y + self.Offset + i * self.TextHeight
				draw.RoundedBox(0, self.Area1X + x + 4, y - self.TextHeight - 4, 2, self.TextHeight, color_white)
			end
		end
	end
end


function SELF:OnThink()
	SELF.Base.OnThink(self)
end