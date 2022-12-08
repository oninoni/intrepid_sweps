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
--           PADD | Client           --
---------------------------------------

function Star_Trek.PADD:EnableEditing(window)
	if IsValid(self.Panel) then
		self.Panel:Remove()
	end

	local interface = window.Interface
	if not istable(interface) then return end
	self.Entity = interface.Ent

	local inputLines = table.Copy(window.Lines)

	local headerLines = {}
	local previousTextTable = {}
	for i, line in pairs(inputLines) do
		if i > 8 then
			table.insert(previousTextTable, line.Text)
		else
			table.insert(headerLines, line)
		end
	end

	PrintTable(previousTextTable)

	self.Panel = vgui.Create("DTextEntry")
	self.Panel:SetSize(ScrW(), ScrH())
	self.Panel:SetCursor("blank")
	function self.Panel:Paint(ww, hh)
	end

	local previousText = table.concat(previousTextTable, "\n")
	self.Panel:SetValue(previousText)

	local caretPos = math.min(#previousText, self.LastCaretPos or 0)
	self.Panel:SetCaretPos(caretPos)
	window.CaretPos = caretPos

	self.Panel:SetMultiline(true)
	self.Panel:SetUpdateOnType(true)

	function self.Panel:OnValueChange(value)
		local lines = table.Copy(headerLines)
		for _, line in pairs(string.Split(value, "\n")) do
			table.insert(lines, {
				Text = line
			})
		end

		Star_Trek.PADD.LastCaretPos = self:GetCaretPos()
		window:ProcessText(lines)
		window.CaretPos = Star_Trek.PADD.LastCaretPos
	end

	function self.Panel:Think()
		local currentCaretPos = self:GetCaretPos()
		if Star_Trek.PADD.LastCaretPos ~= currentCaretPos then
			Star_Trek.PADD.LastCaretPos = currentCaretPos

			local lines = table.Copy(window.Lines)
			window:ProcessText(lines)
			window.CaretPos = Star_Trek.PADD.LastCaretPos
		end
	end

	self.Panel:MakePopup()
	self.Panel:SetMouseInputEnabled(false)
end

function Star_Trek.PADD:DisableEditing()
	if IsValid(self.Panel) then
		local lines = string.Split(self.Panel:GetValue(), "\n")

		net.Start("Star_Trek.PADD.UpdatePersonal")
			net.WriteEntity(self.Entity)
			net.WriteTable(lines)
		net.SendToServer()

		self.Panel:Remove()
	end
end