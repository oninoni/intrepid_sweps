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
--           PADD | Server           --
---------------------------------------

util.AddNetworkString("Star_Trek.PADD.UpdatePersonal")
net.Receive("Star_Trek.PADD.UpdatePersonal", function(len, ply)
	local ent = net.ReadEntity()
	if not IsValid(ent) then return end

	local lines = net.ReadTable()
	if not istable(lines) then return end

	if ply:GetActiveWeapon() ~= ent then return end

	local interface = ent.Interface
	if not istable(interface) then return end

	local logWindow = interface.Windows[1]
	if not istable(logWindow) then return end

	local sessionData = table.Copy(logWindow.SessionData)

	sessionData.Entries = {}
	Star_Trek.Logs:AddEntryToSessionInternal(sessionData, ply, "Session started.")
	Star_Trek.Logs:AddEntryToSessionInternal(sessionData, ply, "")

	for _, line in pairs(lines) do
		Star_Trek.Logs:AddEntryToSessionInternal(sessionData, ply, line)
	end

	for _, watcherWindow in pairs(sessionData.Watchers or {}) do
		-- TODO: Check if window still open! If not Remove from list!

		watcherWindow:UpdateContent()
		watcherWindow:Update()
	end

	logWindow:DisableEditing()
	logWindow:SetSessionData(sessionData)
	logWindow:Update()
end)