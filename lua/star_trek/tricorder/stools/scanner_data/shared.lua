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

local nameTextEntry, dataTextEntry, holomatterComboBox

if CLIENT then
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" },
		{ name = "reload" }
	}

	language.Add("tool.scanner_data.name", "Scanner Data-Tool")
	language.Add("tool.scanner_data.desc", "Allows setting custom text and custom name onto an entity for retrieval using a tricorder.")
	language.Add("tool.scanner_data.left", "Set Data (Hold alt to target self)")
	language.Add("tool.scanner_data.right", "Copy Data (Hold alt to target self)")
	language.Add("tool.scanner_data.reload", "Delete Data (Hold alt to target self)")

	net.Receive("Scanner_Data.GetData", function(len)
		local overrideName = net.ReadString()
		local data = net.ReadString()
		local holomatter = net.ReadUInt(2)

		local ply = LocalPlayer()
		if not IsValid(ply) then return end

		local tool = ply:GetTool("scanner_data")
		if not istable(tool) then return end

		nameTextEntry:SetText(overrideName or "")
		dataTextEntry:SetText(data or "")
		holomatterComboBox:ChooseOptionID(holomatter or 1)
	end)

	net.Receive("Scanner_Data.SetData", function(len)
		local ent = net.ReadEntity()

		local ply = LocalPlayer()
		if not IsValid(ply) then return end

		local tool = ply:GetTool("scanner_data")
		if not istable(tool) then return end

		local overrideName = nameTextEntry:GetText()
		local data = dataTextEntry:GetText()
		local holomatter = holomatterComboBox:GetSelectedID()

		if ent:IsPlayer() then
			if holomatter == 3 then
				notification.AddLegacy( "A player cannot be a hologram", NOTIFY_ERROR, 3 )
				surface.PlaySound( "buttons/button10.wav" )
			elseif holomatter == 2 then
				notification.AddLegacy( "A player cannot be replicated", NOTIFY_ERROR, 3 )
				surface.PlaySound( "buttons/button10.wav" )
			end
		end

		if (ent:IsNPC() or ent:IsNextBot()) and holomatter == 2 then
			notification.AddLegacy( "An NPC cannot be replicated", NOTIFY_ERROR, 3 )
			surface.PlaySound( "buttons/button10.wav" )
		end

		net.Start("Scanner_Data.SetData")
			net.WriteEntity(ent)
			net.WriteString(overrideName)
			net.WriteString(data)
			net.WriteUInt(holomatter, 2)
		net.SendToServer()
	end)
end

if SERVER then
	util.AddNetworkString("Scanner_Data.GetData")
	util.AddNetworkString("Scanner_Data.SetData")
	net.Receive("Scanner_Data.SetData", function(len, ply)
		local ent = net.ReadEntity()
		local overrideName = net.ReadString()
		local data = net.ReadString()
		local holomatter = net.ReadUInt(2)

		if overrideName == "" then
			ent.OverrideName = nil
		else
			ent.OverrideName = overrideName
		end
		if data == "" then
			ent.ScannerData = nil
		else
			ent.ScannerData = data
		end

		if holomatter == 1 or ent:IsPlayer() then
			ent.HoloMatter = nil
			ent.Replicated = nil
		elseif holomatter == 2 and not ent:IsNPC() and not ent:IsNextBot() then
			ent.Replicated = true
			ent.HoloMatter = nil
		elseif holomatter == 3 then
			ent.Replicated = nil
			ent.HoloMatter = true
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

	local owner = self:GetOwner()
	if not IsValid(owner) then return true end

	local ent = tr.Entity
	if owner:KeyDown(IN_WALK) then
		ent = owner
	end

	if not IsValid(ent) then return true end

	net.Start("Scanner_Data.SetData")
		net.WriteEntity(ent)
	net.Send(owner)

	return true
end

-- Copy Data
function TOOL:RightClick(tr)
	if (CLIENT) then return true end

	local owner = self:GetOwner()
	if not IsValid(owner) then return true end

	local ent = tr.Entity
	if owner:KeyDown(IN_WALK) then
		ent = owner
	end

	if not IsValid(ent) then return true end

	local matterId = 1
	if ent.Replicated then
		matterId = 2
	elseif ent.HoloMatter then
		matterId = 3
	end

	net.Start("Scanner_Data.GetData")
		net.WriteString(ent.OverrideName or "")
		net.WriteString(ent.ScannerData or "")
		net.WriteUInt(matterId, 2)
	net.Send(owner)

	return true
end

-- Remove Data
function TOOL:Reload(tr)
	if (CLIENT) then return true end

	local owner = self:GetOwner()
	if not IsValid(owner) then return true end

	local ent = tr.Entity
	if owner:KeyDown(IN_WALK) then
		ent = owner
	end

	if not IsValid(ent) then return true end

	ent.OverrideName = nil
	ent.ScannerData = nil
	ent.Replicated = nil
	ent.HoloMatter = nil

	return true
end

function TOOL:BuildCPanel()
	if SERVER then return end

	self:AddControl("Header", {
		Text = "#tool.scanner_data.name",
		Description = "#tool.scanner_data.desc"
	})

	nameTextEntry = vgui.Create("DTextEntry")
	nameTextEntry:SetPlaceholderText("Enter new name (Leave empty for default name)")

	dataTextEntry = vgui.Create("DTextEntry")
	dataTextEntry:SetMultiline(true)
	dataTextEntry:SetPlaceholderText("Enter custom data.")
	dataTextEntry:SetSize(100, 100)

	holomatterComboBox = vgui.Create("DComboBox")
	holomatterComboBox:AddChoice("Normal Matter")
	holomatterComboBox:AddChoice("Replicated")
	holomatterComboBox:AddChoice("Holomatter")
	holomatterComboBox:ChooseOptionID(1)

	self:AddItem(nameTextEntry)
	self:AddItem(dataTextEntry)
	self:AddItem(holomatterComboBox)
end