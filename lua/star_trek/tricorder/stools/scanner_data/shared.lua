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
--    Server | Scanner Data STool    --
---------------------------------------

if not istable(TOOL) then Star_Trek:LoadAllModules() return end

TOOL.Category = "ST:RP"
TOOL.Name = "Scanner Data-Tool"
TOOL.ConfigName = ""

local textEntry

if CLIENT then
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" },
		{ name = "reload" }
	}

	language.Add("tool.scanner_data.name", "Scanner Data-Tool")
	language.Add("tool.scanner_data.desc", "Allows setting custom text and custom name onto an entity for retrieval using a tricorder.")
	language.Add("tool.scanner_data.left", "Set Data")
	language.Add("tool.scanner_data.right", "Copy Data")
	language.Add("tool.scanner_data.reload", "Delete Data")

	net.Receive("Scanner_Data.GetData", function(len)
		local data = net.ReadString()

		local ply = LocalPlayer()
		if not IsValid(ply) then return end

		local tool = ply:GetTool("scanner_data")
		if not istable(tool) then return end

		textEntry:SetText(data)
	end)

	net.Receive("Scanner_Data.SetData", function(len)
		local ent = net.ReadEntity()

		local ply = LocalPlayer()
		if not IsValid(ply) then return end

		local tool = ply:GetTool("scanner_data")
		if not istable(tool) then return end

		local data = ""
		if ChangeScanDataCheckBox:GetChecked() then
			data = textEntry:GetText()
		end

		local overrideName = ""
		if OverrideNameCheckBox:GetChecked() then
			overrideName = OverrideNameText:GetText()
		end

		local holomatter = OverrideHolomatterComboBox:GetSelectedID()

		net.Start("Scanner_Data.SetData")
			net.WriteEntity(ent)
			net.WriteString(data)
			net.WriteString(overrideName)
			net.WriteInt(holomatter, 3)
		net.SendToServer()
	end)
end

if SERVER then
	util.AddNetworkString("Scanner_Data.GetData")

	util.AddNetworkString("Scanner_Data.SetData")
	net.Receive("Scanner_Data.SetData", function(len, ply)
		local ent = net.ReadEntity()
		local data = net.ReadString()
		local overrideName = net.ReadString()
		local holomatter = net.ReadInt(3)

		if data ~= "" then ent.ScannerData = data end
		ent.OverrideName = overrideName

		if holomatter == 1 or ent:IsPlayer() then -- Unchange
			return
		elseif holomatter == 2 then
			ent.HoloMatter = true
		elseif holomatter == 3 then
			ent.HoloMatter = false
		end
	end)

	-- Read Custom Data from entity.
	hook.Add("Star_Trek.Sensors.ScanEntity", "Scanner_Data.Check", function(ent, scanData)
		if isstring(ent.ScannerData) then
			scanData.ScannerData = ent.ScannerData
		end
	end)

	-- Output the Custom Data from on a tricorder.
	hook.Add("Star_Trek.Tricorder.AnalyseScanData", "Scanner_Data.Output", function(ent, owner, scanData)
		if isstring(scanData.ScannerData) then
			local split = string.Split(scanData.ScannerData, "\n")
			for _, line in pairs(split) do
				Star_Trek.Logs:AddEntry(ent, owner, line)
			end
		end
	end)
end

-- Set Data
function TOOL:LeftClick(tr)
	if (CLIENT) then return true end

	local ent = tr.Entity
	if not IsValid(ent) then return true end

	local owner = self:GetOwner()
	if not IsValid(owner) then return true end

	net.Start("Scanner_Data.SetData")
		net.WriteEntity(ent)
	net.Send(owner)

	return true
end

-- Copy Data
function TOOL:RightClick(tr)
	if (CLIENT) then return true end

	local ent = tr.Entity
	if not IsValid(ent) then return true end

	local owner = self:GetOwner()
	if not IsValid(owner) then return true end

	local data = ent.ScannerData

	net.Start("Scanner_Data.GetData")
		net.WriteString(data)
	net.Send(owner)

	return true
end

-- Remove Data
function TOOL:Reload(tr)
	if (CLIENT) then return true end

	local ent = tr.Entity
	if not IsValid(ent) then return true end

	ent.ScannerData = nil

	return true
end

function TOOL:BuildCPanel()
	if SERVER then return end

	self:AddControl("Header", {
		Text = "#tool.scanner_data.name",
		Description = "#tool.scanner_data.desc"
	})

	OverrideNameText = vgui.Create("DTextEntry")
	OverrideNameText:SetPlaceholderText("Enter new name (leave empty for default name)")

	OverrideNameCheckBox = vgui.Create("DCheckBoxLabel")
	OverrideNameCheckBox:SetText("Override entity's name")
	OverrideNameCheckBox:SizeToContents()
	OverrideNameCheckBox:SetTextColor(Color(0, 0, 0))
	OverrideNameCheckBox:SetChecked(true)
	function OverrideNameCheckBox:OnChange(val)
		OverrideNameText:SetEnabled(val)
	end

	textEntry = vgui.Create("DTextEntry")
	textEntry:SetMultiline(true)
	textEntry:SetPlaceholderText("Enter custom data")
	textEntry:SetSize(100, 100)

	ChangeScanDataCheckBox = vgui.Create("DCheckBoxLabel")
	ChangeScanDataCheckBox:SetText("Set custom scan data")
	ChangeScanDataCheckBox:SizeToContents()
	ChangeScanDataCheckBox:SetTextColor(Color(0, 0, 0))
	ChangeScanDataCheckBox:SetChecked(true)
	function ChangeScanDataCheckBox:OnChange(val)
		textEntry:SetEnabled(val)
	end

	OverrideHolomatterLabel = vgui.Create("DLabel")
	OverrideHolomatterLabel:SetText("Holomatter:")
	OverrideHolomatterLabel:SetTextColor(Color(0, 0, 0))

	OverrideHolomatterComboBox = vgui.Create("DComboBox")
	OverrideHolomatterComboBox:AddChoice("Unchange")
	OverrideHolomatterComboBox:AddChoice("Make Holomatter")
	OverrideHolomatterComboBox:AddChoice("Make Normal Matter")
	OverrideHolomatterComboBox:ChooseOptionID(1)

	self:AddItem(OverrideNameCheckBox)
	self:AddItem(OverrideNameText)
	self:AddItem(ChangeScanDataCheckBox)
	self:AddItem(textEntry)
	self:AddItem(OverrideHolomatterLabel)
	self:AddItem(OverrideHolomatterComboBox)
end