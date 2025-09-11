	local addon, ns = ...

	-- Create addon namespace
	ns.SasUI = ns.SasUI or {}
	local SasUI = ns.SasUI
	
	function SasUI.ResizeBlizzFrames(frameName, scale, addonName)
		local frame = _G[frameName]
		if frame then
			-- Frame exists, apply scaling logic
			if frame.SetScale then
				frame:SetScale(scale)
			end

			-- Hook SetSize to detect size changes
			hooksecurefunc(frame, "SetSize", function()
				if frame.SetScale then
					frame:SetScale(scale)
				end
			end)

			-- Hook SetScale to maintain desired scale with recursion guard
			local isSettingScale = false
			hooksecurefunc(frame, "SetScale", function()
				if isSettingScale then return end -- Prevent recursion
				if frame:GetScale() ~= scale then
					isSettingScale = true
					frame:SetScale(scale)
					isSettingScale = false
				end
			end)
		else
			-- Frame not found, set up event listener for ADDON_LOADED
			local eventFrame = CreateFrame("Frame")
			eventFrame:RegisterEvent("ADDON_LOADED")
			eventFrame:SetScript("OnEvent", function(self, event, loadedAddon)
				local newFrame = _G[frameName]
				if newFrame then
					if newFrame.SetScale then
						newFrame:SetScale(scale)
					end

					-- Hook SetSize
					hooksecurefunc(newFrame, "SetSize", function()
						if newFrame.SetScale then
							newFrame:SetScale(scale)
						end
					end)

					-- Hook SetScale with recursion guard
					local isSettingScale = false
					hooksecurefunc(newFrame, "SetScale", function()
						if isSettingScale then return end
						if newFrame:GetScale() ~= scale then
							isSettingScale = true
							newFrame:SetScale(scale)
							isSettingScale = false
						end
					end)

					-- Unregister event to clean up
					self:UnregisterEvent("ADDON_LOADED")
				elseif addonName and loadedAddon == addonName then
					self:UnregisterEvent("ADDON_LOADED")
				end
			end)
		end
	end