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

TOOL.Category = "ST:RP"
TOOL.Name = "Scanner Data-Tool"
TOOL.ConfigName = ""

local textEntry

if CLIENT then
	language.Add("tool.scanner_data.name", "Scanner Data-Tool")
	language.Add("tool.scanner_data.desc", "Allows setting custom text onto an entity for retrieval using a tricorder.")
	language.Add("tool.scanner_data.0", "Left-Click: Set Data, Right Click: Copy Data, R: Delete Data")

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

		local data = textEntry:GetText()

		net.Start("Scanner_Data.SetData")
			net.WriteEntity(ent)
			net.WriteString(data)
		net.SendToServer()
	end)
end

if SERVER then
	util.AddNetworkString("Scanner_Data.GetData")

	util.AddNetworkString("Scanner_Data.SetData")
	net.Receive("Scanner_Data.SetData", function(len, ply)
		local ent = net.ReadEntity()
		local data = net.ReadString()

		ent.ScannerData = data
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
			Star_Trek.Logs:AddEntry(ent, owner, scanData.ScannerData)
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

	textEntry = vgui.Create("DTextEntry")
	textEntry:SetMultiline(true)
	textEntry:SetSize(100, 100)

	self:AddItem(textEntry)
end