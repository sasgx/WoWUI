	-- art/target.lua
	local addon, ns = ...

	if C_AddOns.IsAddOnLoaded("GW2_UI") then return end
	if C_AddOns.IsAddOnLoaded("BetterBlizzFrames") then return end
	
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
			
			if cfg.invert then
			
			end
		end
	end)
	
	-- local db = { backdropAlpha = 1.0 }  -- Adjustable alpha for backdrop visibility

	-- -- Function to set the font for the raid frame names and status text
	-- local function setFont(frame)
		-- if frame and not frame:IsForbidden() and frame.SetFont then
			-- frame:SetFont([[Fonts\FRIZQT__.TTF]], 11, "OUTLINE")  -- Set the font to FRIZQT__.TTF, size 11, outline
			-- frame:SetShadowOffset(0, 0)  -- Remove any shadow offsets
		-- end
	-- end
	 
	-- -- Function to set the custom font and color for status text (e.g., Dead, Offline)
	-- local function setStatusTextFont(frame)
		-- if frame and not frame:IsForbidden() and frame.statusText then
			-- setFont(frame.statusText)  -- Apply the custom font
			-- frame.statusText:SetTextColor(0.6, 0, 0)  -- Dark red color for the status text
		-- end
	-- end
	 
	-- -- Apply the font settings to all raid frames when Blizzard_CompactRaidFrames is loaded
	-- if C_AddOns.IsAddOnLoaded("Blizzard_CompactRaidFrames") then
		-- for i = 1, 8 do  -- Loop through all the raid groups
			-- for j = 1, 5 do  -- Loop through each member of the group
				-- setFont(_G["CompactRaidGroup"..i.."Member"..j.."Name"])  -- Set the font for each raid member's name
				-- setStatusTextFont(_G["CompactRaidGroup"..i.."Member"..j])  -- Set the font and color for status text
			-- end
		-- end
	 
		-- for i = 1, 40 do  -- Apply font settings to all individual raid frames (up to 40 units)
			-- setFont(_G["CompactRaidFrame"..i.."Name"])
			-- setStatusTextFont(_G["CompactRaidFrame"..i])  -- Set the font and color for status text
		-- end
	-- end
	 
	-- -- Ensure that the font is applied every time a unit is assigned to a raid frame
	-- hooksecurefunc("CompactUnitFrame_SetUnit", function(frame)
		-- setFont(frame.name)
		-- setStatusTextFont(frame)  -- Apply the status text font and color
	-- end)
	 
	-- -- Hook to update the status text font and color
	-- hooksecurefunc("CompactUnitFrame_UpdateStatusText", function(frame)
		-- setStatusTextFont(frame)  -- Ensure the status text uses the correct font and color
	-- end)
	 
	-- -- Change the color of the name to match the class color of the unit
	-- hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
		-- if frame:IsForbidden() or not frame.unit then return end  -- Ensure the frame is valid and has a unit
	 
		-- local unit = frame.unit
		-- local name = UnitName(unit)  -- Get the unit's name
	 
		-- if UnitIsPlayer(unit) then
			-- local _, class = UnitClass(unit)  -- Get the class of the unit
			-- local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]  -- Get the class color
	 
			-- if color then
				-- frame.name:SetText(format("|c%s%s", color.colorStr, name))  -- Apply class color to the name
			-- else
				-- frame.name:SetText(name)  -- Fallback to default name if no class color is found
			-- end
		-- else
			-- frame.name:SetText(name)  -- For non-player units, set the name without class coloring
		-- end
	 
		-- -- Align the name to the top-left of the frame with a small offset
		-- frame.name:ClearAllPoints()
		-- frame.name:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)  -- Align the name with a 2px offset
	-- end)
	 
	-- -- Set health bar color to black as default for all units
	-- hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
		-- if frame:IsForbidden() or not frame.unit then return end  -- Ensure the frame is valid and has a unit
	 
		-- -- Set health bar color to black (RGB: 0, 0, 0)
		-- frame.healthBar:SetStatusBarColor(0, 0, 0)
	-- end)
	 
	-- -- Hide the role icon from raid frames (tank/healer/dps role icons) safely
	-- hooksecurefunc("CompactUnitFrame_UpdateRoleIcon", function(frame)
		-- if frame:IsForbidden() or not frame.roleIcon then return end  -- Ensure the frame has a role icon
	 
		-- -- Use safe hiding methods for the role icon
		-- frame.roleIcon:SetShown(false)  -- Hide the role icon safely
		-- frame.roleIcon:SetAlpha(0)  -- Set icon's alpha to 0 to make it invisible
		-- frame.roleIcon:SetWidth(0.001)  -- Set the width to nearly 0 to remove its impact on the layout
	-- end)
	 
	-- -- Set the background texture and frame opacity
	-- hooksecurefunc("DefaultCompactUnitFrameSetup", function(frame)
		-- if frame:IsForbidden() or not frame.background then return end  -- Ensure the frame has a background
	 
		-- -- Set the background to a solid texture and apply a medium dark grey color
		-- frame.background:SetTexture("Interface\\Buttons\\WHITE8X8")
		-- frame.background:SetVertexColor(0.4, 0.4, 0.4, 0.8)  -- Set background color to medium dark grey with 80% opacity
	 
		-- -- Adjust background size to match the health bar with a 1-pixel gap
		-- frame.background:ClearAllPoints()
		-- frame.background:SetPoint("TOPLEFT", frame.healthBar, "TOPLEFT", -1, 1)
		-- frame.background:SetPoint("BOTTOMRIGHT", frame.healthBar, "BOTTOMRIGHT", 1, -1)
	 
		-- -- Set frame transparency (slight opacity for the entire frame)
		-- frame:SetAlpha(0.9)
	-- end)
	 
	-- -- Hide the group numbers (Group 1, Group 2, etc.) on raid frames safely
	-- local function hideGroupNumbers()
		-- for i = 1, 8 do  -- Loop through all the group headers
			-- local groupHeader = _G["CompactRaidGroup"..i]
			-- if groupHeader then
				-- if groupHeader.title then
					-- groupHeader.title:SetShown(false)  -- Safely hide the group title text (e.g., "Group 1", "Group 2")
					-- groupHeader.title:SetAlpha(0)  -- Set alpha to 0 to make sure it's not visible
					-- groupHeader.title:SetWidth(0.001)  -- Set width to near 0 to ensure it doesn't affect layout
				-- end
				-- local groupBorder = _G["CompactRaidGroup"..i.."BorderFrame"]
				-- if groupBorder then
					-- groupBorder:SetShown(false)  -- Safely hide the group border
					-- groupBorder:SetAlpha(0)  -- Set alpha to 0 to make sure it's not visible
					-- groupBorder:SetWidth(0.001)  -- Set width to near 0 to ensure it doesn't affect layout
				-- end
			-- end
		-- end
	-- end
	 
	-- -- Register an event frame to handle group changes and zone transitions
	-- local eventFrame = CreateFrame("Frame")
	 
	-- -- Event handler to hide group numbers when group roster or world state changes
	-- eventFrame:SetScript("OnEvent", function(self, event)
		-- if event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
			-- hideGroupNumbers()  -- Ensure group numbers are hidden after a group update or entering a new zone
		-- end
	-- end)
	 
	-- -- Register the necessary events
	-- eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")  -- Triggered when the group roster changes
	-- eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")  -- Triggered when entering a new zone or instance
	 
	-- -- Ensure group numbers are hidden when the addon is loaded
	-- if C_AddOns.IsAddOnLoaded("Blizzard_CompactRaidFrames") then
		-- hideGroupNumbers()  -- Hide group numbers when the addon is loaded
	-- end