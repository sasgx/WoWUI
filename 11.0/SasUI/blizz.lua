	-- Get the addon namespace
	local addon, ns = ...
	
	if C_AddOns.IsAddOnLoaded("GW2_UI") then return end

	-- Get some values from the namespace
	local cfg = ns.cfg.blizz
	local blizz = ns.SasUI

	if not cfg.enable then return end

	-- Create a frame
	local f = CreateFrame("Frame")

	-- Register the events
	f:RegisterEvent("PLAYER_ENTERING_WORLD")

	-- Set up an event handler
	f:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_ENTERING_WORLD" then
			blizz.ResizeBlizzFrames("PVEFrame", 1.3)
			blizz.ResizeBlizzFrames("ExtraAbilityContainer", 0.65)
			blizz.ResizeBlizzFrames("MerchantFrame", 1.25)
			blizz.ResizeBlizzFrames("EncounterJournal", 1.25)
			blizz.ResizeBlizzFrames("CharacterFrame", 1.25)
			blizz.ResizeBlizzFrames("FriendsFrame", 1.25)
			blizz.ResizeBlizzFrames("AchievementFrame", 1.25)
			blizz.ResizeBlizzFrames("InspectFrame", 1.25)
		end
	end)