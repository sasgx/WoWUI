	-- art/target.lua
	local addon, ns = ...

	-- Get config from namespace
	local cfg = ns.cfg.party
	
	-- Exit if addon is disabled in config
	if not cfg.enable then return end
	
	-- Create a frame
	local f = CreateFrame("Frame")
	-- Register the events	
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:RegisterEvent("GROUP_JOINED")
	f:RegisterEvent("GROUP_ROSTER_UPDATE")
	-- Set up an event handler	
	f:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_ENTERING_WORLD" or event == "GROUP_JOINED" or event == "GROUP_ROSTER_UPDATE" then
			ns.SasUI.Mouseover("CompactRaidFrameManager",1,0)
			if cfg.move and cfg.move.enabled then
				ns.SasUI.Move("PartyFrame", cfg.move.a1, cfg.move.af, cfg.move.a2, cfg.move.x, cfg.move.y)
			end
		end
	end)