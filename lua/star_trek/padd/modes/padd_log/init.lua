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
--         Logs Mode | Server        --
---------------------------------------

MODE.BaseMode = "base"

MODE.Name = "Logs"
MODE.MenuColor = Star_Trek.LCARS.ColorBlue

function MODE:Activate(ply, ent)
	Star_Trek.LCARS:OpenInterface(ply, ent, "padd_log", self.LogData)
end

function MODE:Deactivate(ent)
	local padInterface = ent.Interface
	if istable(padInterface) then
		self.LogData = padInterface:GetSessionData()
	end
end

function MODE:PrimaryAttack(ent)
	local padInterface = ent.Interface
	if not istable(padInterface) then return end

	local logWindow = padInterface.Windows[1]
	if not istable(logWindow) then return end

	local ply = ent:GetOwner()
	if not IsValid(ply) then return end

	local eyeTrace = ply:GetEyeTrace()
	local targetEnt = eyeTrace.Entity
	if not IsValid(targetEnt) then
		local closestDistance = math.huge
		local closest

		local hitPos = eyeTrace.HitPos
		for _, foundEnt in pairs(ents.FindInSphere(hitPos, 50)) do
			local distance = foundEnt:GetPos():Distance(hitPos)
			if distance < closestDistance then
				closestDistance = distance
				closest = foundEnt
			end
		end

		if not IsValid(closest) then
			return
		end

		targetEnt = closest
	end

	local targetInterface = targetEnt.Interface
	if not istable(targetInterface) then return end

	if targetInterface.Class == "wallpanel" then
		local sessionData = logWindow.SessionData

		local wallPanelLogWindow = targetInterface.Windows[2]
		if not istable(wallPanelLogWindow) then return end

		wallPanelLogWindow:SetSessionData(sessionData)
		wallPanelLogWindow:Update()

		return
	end

	if padInterface.Locked then return end

	local sessionData
	if targetInterface.Class == "eng_logs" then
		local engLogsLogWindow = targetInterface.Windows[4]
		if not istable(engLogsLogWindow) then return end

		sessionData = engLogsLogWindow.SessionData
	else
		sessionData = Star_Trek.Logs:GetSession(targetEnt)
	end

	if not sessionData then return end

	logWindow:SetSessionData(sessionData)
	logWindow:Update()
end

function MODE:SecondaryAttack(ent)
	local padInterface = ent.Interface
	if not istable(padInterface) then return end

	local logWindow = padInterface.Windows[1]
	if not istable(logWindow) then return end

	local locked = not padInterface.Locked

	if locked then
		logWindow.Title = "Logs (LOCKED)"
	else
		logWindow.Title = "Logs"
	end

	padInterface.Locked = locked
	logWindow:Update()
end