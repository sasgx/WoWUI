	--get the addon namespace
	local addon, ns = ...

	--get some values from the namespace
	local cfg = ns.cfg.player

	if not cfg.enable then return end

	-- Create a frame
	local f = CreateFrame("Frame")
	-- Register the events
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:RegisterEvent("ADDON_LOADED")
	-- Set up an event handler
	f:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_ENTERING_WORLD" then
			if C_AddOns.IsAddOnLoaded("GW2_UI") then 
				ns.SasUI.Mouseover("GW2_PlayerFrame", cfg.fadeIn or 1, cfg.fadeOut or 0.2, cfg.combatFade)
				ns.SasUI.Mouseover("GwDodgeBar", 0, 0)
				ns.SasUI.Mouseover("GwSkyridingBar", 0, 0)
				ns.SasUI.Mouseover("GwPlayerPowerBar", 0, 0, 1)
				ns.SasUI.Mouseover("GwPlayerPowerBarDecay", 0, 0, 1)
				
				ns.SasUI.Move("GW2_PlayerFrame", cfg.move.a1, cfg.move.af, cfg.move.a2, cfg.move.x, cfg.move.y)
			else
				ns.SasUI.Mouseover("PlayerFrame", cfg.fadeIn or 1, cfg.fadeOut or 0.2, cfg.combatFade)
				ns.SasUI.Mouseover("PetFrame", cfg.pet.fadeIn or 0, cfg.pet.fadeOut or 0, cfg.pet.combatFade)
				if cfg.move.enabled then
					ns.SasUI.Move("PlayerFrame", cfg.move.a1, cfg.move.af, cfg.move.a2, cfg.move.x, cfg.move.y)
				end			
			end

		end
		self:UnregisterEvent("ADDON_LOADED")
	end)