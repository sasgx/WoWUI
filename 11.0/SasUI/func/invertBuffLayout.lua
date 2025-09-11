	local addon, ns = ...

	-- Create addon namespace
	ns.SasUI = ns.SasUI or {}
	local SasUI = ns.SasUI
	
	-- Hide Blizzard buff frame by default until arrow is clicked
	local function HideBuffFrameByDefault()
		local maxRetries = 5
		local retryCount = 0

		local function CollapseBuffFrame()
			if BuffFrame and BuffFrame.CollapseAndExpandButton and BuffFrame.AuraContainer then
				if not BuffFrame.isCollapsed then
					-- Simulate a secure click to collapse the buff frame using Blizzard's logic
					BuffFrame.CollapseAndExpandButton:Click()
					-- Check if collapse worked after a short delay
					C_Timer.After(0.5, function()
						if BuffFrame and not BuffFrame.isCollapsed and retryCount < maxRetries then
							retryCount = retryCount + 1
							CollapseBuffFrame()
						end
					end)
				end
				-- Hook the CollapseAndExpandButton's OnClick to debug toggle behavior
				if not BuffFrame.CollapseAndExpandButton.__sasUIHooked then
					hooksecurefunc(BuffFrame.CollapseAndExpandButton, "OnClick", function(self)
						print("BuffFrame arrow clicked, isCollapsed:", BuffFrame.isCollapsed, "AuraContainer visible:", BuffFrame.AuraContainer:IsVisible())
					end)
					BuffFrame.CollapseAndExpandButton.__sasUIHooked = true
				end
			elseif retryCount < maxRetries then
				-- Retry after a delay if BuffFrame or its components aren't ready
				retryCount = retryCount + 1
				C_Timer.After(2, CollapseBuffFrame)
			end
		end

		-- Run on initial load with a delay to ensure UI is ready
		C_Timer.After(0.2, CollapseBuffFrame)

		-- Create a frame to handle UI loading events
		local buffFrameHandler = CreateFrame("Frame")
		buffFrameHandler:RegisterEvent("PLAYER_LOGIN")
		buffFrameHandler:RegisterEvent("ADDON_LOADED")
		buffFrameHandler:SetScript("OnEvent", function(self, event, arg1)
			if event == "PLAYER_LOGIN" or (event == "ADDON_LOADED" and arg1 == "Blizzard_UI") then
				retryCount = 0 -- Reset retry count for event-driven attempts
				C_Timer.After(0.2, CollapseBuffFrame)
				-- Unregister ADDON_LOADED after Blizzard_UI loads to reduce overhead
				if event == "ADDON_LOADED" and arg1 == "Blizzard_UI" then
					self:UnregisterEvent("ADDON_LOADED")
				end
			end
		end)
	end
	HideBuffFrameByDefault()