	--get the addon namespace
	local addon, ns = ...

	--get some values from the namespace
	local cfg = ns.cfg.cp_bars

	if not cfg.enable then return end
	
	-- Function to set up pet ring fading behavior
	local function setupPetRingFading()
		if UnitExists("pet") then
			ns.SasUI.Mouseover("ConsolePortBarPetRing", cfg.petRing.fadeIn or 1, cfg.petRing.fadeOut or 0, cfg.petRing.combatFade)
		end
	end	

	-- Register for the ADDON_LOADED event to initialize
	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	f:RegisterEvent("UNIT_PET") -- Register UNIT_PET event for pet summon detection
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(self, event, arg1)
		if C_AddOns.IsAddOnLoaded("ConsolePort_Bar") then
			if event == "ADDON_LOADED" and arg1 == addon then		
				-- Wait for ConsolePortBarCluster buttons to be available
				local function setupFrames()
					-- List of button names
					local buttonNames = {
						"CPB_PADRTRIGGER", "CPB_PADRSHOULDER", "CPB_PAD1", "CPB_PAD2",
						"CPB_PAD3", "CPB_PAD4", "CPB_PADLTRIGGER", "CPB_PADLSHOULDER",
						"CPB_PADDDOWN", "CPB_PADDRIGHT", "CPB_PADDLEFT", "CPB_PADDUP"
					}
					local allButtonsReady = true
					for _, buttonName in ipairs(buttonNames) do
						if not _G[buttonName] then
							allButtonsReady = false
							break
						end
					end
					if allButtonsReady then
						for _, buttonName in ipairs(buttonNames) do
							local button = _G[buttonName]
							-- Create a frame for each button
							local glassFrame = CreateFrame("Frame", nil, button, "BackdropTemplate")
							glassFrame:SetParent(button)
							glassFrame:SetSize(button:GetWidth() + 15, button:GetHeight() + 15) -- Slightly larger than button
							glassFrame:SetPoint("CENTER", button, "CENTER", 0, 0) -- Centered on button
							glassFrame:SetFrameLevel(button:GetFrameLevel() + 5) -- One level above parent

							-- Create texture
							local texture = glassFrame:CreateTexture(nil, "ARTWORK")
							texture:SetAllPoints(glassFrame) -- Fill the frame
							texture:SetTexture(ns.SasUI.Textures("orb_gloss.tga")) -- Apply gloss texture
						end
					else
						-- Retry after a short delay if any button isn't ready
						C_Timer.After(1, setupFrames)
					end
				end
				setupFrames()
			elseif event == "UNIT_PET" and arg1 == "player" then
				-- Handle Warlock pet summon detection
				setupPetRingFading()
			elseif event == "PLAYER_ENTERING_WORLD" then
				-- Handle login, reload, or zoning
				setupPetRingFading()
			end
			-- Unregister event after loading
			self:UnregisterEvent("ADDON_LOADED")
		end
	end)
	
	