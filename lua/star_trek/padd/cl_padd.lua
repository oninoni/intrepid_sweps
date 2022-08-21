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
	local previousText = {}
	for i, line in pairs(inputLines) do
		if i > 8 then
			table.insert(previousText, line.Text)
		else
			table.insert(headerLines, line)
		end
	end

	self.Panel = vgui.Create("DTextEntry")
	self.Panel:SetSize(ScrW(), ScrH())
	self.Panel:SetCursor("blank")
	function self.Panel:Paint(ww, hh)
	end

	self.Panel:SetValue(table.concat(previousText, "\n"))
	self.Panel.LastCaretPos = self.Panel:GetCaretPos()

	self.Panel:SetMultiline(true)
	self.Panel:SetUpdateOnType(true)

	function self.Panel:OnValueChange(value)
		local lines = table.Copy(headerLines)
		for _, line in pairs(string.Split(value, "\n")) do
			table.insert(lines, {
				Text = line
			})
		end

		self.LastCaretPos = self:GetCaretPos()
		window:ProcessText(lines)
		window.CaretPos = self.LastCaretPos
	end

	function self.Panel:Think()
		local caretPos = self:GetCaretPos()
		if self.LastCaretPos ~= caretPos then
			self.LastCaretPos = caretPos

			local lines = table.Copy(window.Lines)
			window:ProcessText(lines)
			window.CaretPos = self.LastCaretPos
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