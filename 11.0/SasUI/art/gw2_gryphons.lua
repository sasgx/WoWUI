	local addonName, addon = ...
	
	if not C_AddOns.IsAddOnLoaded("GW2_UI") then return end

	-- Helper function for texture paths
	local function sgTextures(filename)
		return "Interface\\AddOns\\" .. addonName .. "\\media\\" .. filename
	end

	-- Function to set up the demon frame
	local function setupDemonFrame(parentFrame)
		local f = _G["SasGlass_HealthFrame"] or CreateFrame("Frame", "SasGlass_HealthFrame")
		f:SetParent(parentFrame)
		-- Set frame properties: double width, 1.5x height, positioned right with offset
		f:SetSize(parentFrame:GetWidth() * 2, parentFrame:GetHeight() * 1.5)
		f:SetPoint("RIGHT", parentFrame, "RIGHT", 55, 20)
		-- Set frame level 6 above parent
		f:SetFrameLevel(parentFrame:GetFrameLevel() + 6)

		-- Create texture
		local texture = f:CreateTexture(nil, "ARTWORK")
		texture:SetAllPoints(f) -- Fill the frame with the texture
		texture:SetTexture(sgTextures("d3_demon2.tga")) -- Use demon texture
		texture:SetTexCoord(1, 0, 0, 1) -- Flip both horizontally and vertically to face the orb
	end

	-- Function to set up the angel frame
	local function setupAngelFrame(parentFrame)
		local f = _G["SasGlass_HealthFrame"] or CreateFrame("Frame", "SasGlass_HealthFrame")
		f:SetParent(parentFrame)
		-- Set frame properties: different size and position for angel
		f:SetSize(parentFrame:GetWidth(), parentFrame:GetHeight())
		f:SetPoint("LEFT", parentFrame, "LEFT", 55, 0)
		-- Set frame level 6 above parent
		f:SetFrameLevel(parentFrame:GetFrameLevel() + 6)

		-- Create texture
		local texture = f:CreateTexture(nil, "ARTWORK")
		texture:SetAllPoints(f) -- Fill the frame with the texture
		texture:SetTexture(sgTextures("d3_angel3.tga")) -- Use angel texture
		texture:SetTexCoord(0, 1, 0, 1) -- Default coordinates
	end

	-- Function to destroy the existing frame
	local function destroyFrame()
		local frame = _G["SasGlass_HealthFrame"]
		if frame then
			frame:Hide()
			frame:UnregisterAllEvents()
			frame:SetParent(nil)
			frame:ClearAllPoints()
			-- Removed frame:Release() as it's not a valid method
		end
	end

	-- Register for the ADDON_LOADED event to initialize
	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", function(self, event, arg1)
		if event == "ADDON_LOADED" and arg1 == addonName then
			-- Saved variable for selected style
			addon.selectedStyle = addon.selectedStyle or "demon" -- Default to demon

			-- Wait for GW2_PlayerFrame to be available
			local function setupFrame()
				local parentFrame = _G["GW2_PlayerFrame"]
				if parentFrame then
					-- Destroy existing frame if any
					destroyFrame()
					-- Set up frame based on selected style
					if addon.selectedStyle == "demon" then
						setupDemonFrame(parentFrame)
					elseif addon.selectedStyle == "angel" then
						setupAngelFrame(parentFrame)
					end
				else
					-- Retry after a short delay if GW2_PlayerFrame isn't ready
					C_Timer.After(1, setupFrame)
				end
			end
			setupFrame()

			-- Slash command to change style
			SLASH_SGSTYLE1 = "/sgstyle"
			SlashCmdList["SGSTYLE"] = function(msg)
				msg = msg:lower()
				if msg == "demon" or msg == "angel" then
					addon.selectedStyle = msg
					destroyFrame() -- Remove old frame
					local parentFrame = _G["GW2_PlayerFrame"]
					if parentFrame then
						if addon.selectedStyle == "demon" then
							setupDemonFrame(parentFrame)
						elseif addon.selectedStyle == "angel" then
							setupAngelFrame(parentFrame)
						end
						print("Style set to: " .. addon.selectedStyle)
					else
						print("Error: GW2_PlayerFrame not found")
					end
				else
					print("Usage: /sgstyle [demon|angel]")
				end
			end

			-- Unregister event after loading
			self:UnregisterEvent("ADDON_LOADED")
		end
	end)