	-- Get the addon namespace
	local addon, ns = ...

	-- Get some values from the namespace
	local cfg = ns.cfg.blizz

	if not cfg.enable then return end

	-- Create a frame
	local f = CreateFrame("Frame")

	-- Register the events
	f:RegisterEvent("PLAYER_ENTERING_WORLD")

	-- Set up an event handler
	f:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_ENTERING_WORLD" then
			ns.SasUI.ResizeBlizzFrames("PVEFrame", 1.3)
			ns.SasUI.ResizeBlizzFrames("ExtraAbilityContainer", 0.5)
			ns.SasUI.ResizeBlizzFrames("MerchantFrame", 1.25)
			ns.SasUI.ResizeBlizzFrames("EncounterJournal", 1.25)
			ns.SasUI.ResizeBlizzFrames("CharacterFrame", 1.25)
			ns.SasUI.ResizeBlizzFrames("FriendsFrame", 1.25)
			ns.SasUI.ResizeBlizzFrames("AchievementFrame", 1.25)
		end
	end)