	--get the addon namespace
	local addon, ns = ...

	--get some values from the namespace
	local cfg = ns.cfg.player

	if not cfg.enable then return end

	-- Create a frame
	local f = CreateFrame("Frame")
	-- Register the events
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- Set up an event handler
	f:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_ENTERING_WORLD" then
			ns.SasUI.Mouseover("PlayerFrame", cfg.fadeIn or 1, cfg.fadeOut or 0.2, cfg.combatFade)
			ns.SasUI.Mouseover("PetFrame", cfg.pet.fadeIn or 0, cfg.pet.fadeOut or 0, cfg.pet.combatFade)
			if cfg.move.enabled then
				ns.SasUI.Move("PlayerFrame", cfg.move.a1, cfg.move.af, cfg.move.a2, cfg.move.x, cfg.move.y)
			end
		end
	end)