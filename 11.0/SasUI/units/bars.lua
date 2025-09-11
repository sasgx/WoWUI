	--get the addon namespace
	local addon, ns = ...

	--get some values from the namespace
	local cfg = ns.cfg.bars

	if not cfg.enable then return end

	-- Create a frame
	local f = CreateFrame("Frame")
	-- Register the events
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- Set up an event handler
	f:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_ENTERING_WORLD" then
			ns.SasUI.Mouseover("MainMenuBar", cfg.mouseover.bar1.fadeIn or 1, cfg.mouseover.bar1.fadeOut or 0, false, true)
			ns.SasUI.Mouseover("MultiBarBottomLeft", cfg.mouseover.bar2.fadeIn or 1, cfg.mouseover.bar2.fadeOut or 0, false, true)
			ns.SasUI.Mouseover("MultiBarBottomRight", cfg.mouseover.bar3.fadeIn or 1, cfg.mouseover.bar3.fadeOut or 0, false, true)
			ns.SasUI.Mouseover("MultiBarRight", cfg.mouseover.bar4.fadeIn or 1, cfg.mouseover.bar4.fadeOut or 0, false, true)
			ns.SasUI.Mouseover("MultiBarLeft", cfg.mouseover.bar5.fadeIn or 1, cfg.mouseover.bar5.fadeOut or 0, false, true)
			ns.SasUI.Mouseover("MultiBar5", cfg.mouseover.bar6.fadeIn or 1, cfg.mouseover.bar6.fadeOut or 0, false, true)
			ns.SasUI.Mouseover("MultiBar6", cfg.mouseover.bar7.fadeIn or 1, cfg.mouseover.bar7.fadeOut or 0, false, true)
			ns.SasUI.Mouseover("MultiBar7", cfg.mouseover.bar8.fadeIn or 1, cfg.mouseover.bar8.fadeOut or 0, false, true)
			ns.SasUI.Mouseover("PetActionBar", cfg.mouseover.petBar.fadeIn or 1, cfg.mouseover.petBar.fadeOut or 0, false, true)
			
			if cfg.hide.BagsBar then BagsBar:SetAlpha(0) BagsBar:SetScale(0.001) else BagsBar:SetAlpha(1) BagsBar:SetScale(1) end

			ns.SasUI.Mouseover("ExpansionLandingPageMinimapButton", cfg.mouseover.xpacButton.fadeIn or 1, cfg.mouseover.xpacButton.fadeOut or 0.2)			
		end
	end)