	-- func/funcs.lua
	local addon, ns = ...

	-- Create addon namespace
	ns.SasUI = ns.SasUI or {}
	local SasUI = ns.SasUI
	
	-- Function to check if a frame exists
	local function FrameExists(frameName)
		return _G[frameName] ~= nil
	end

	-- Universal function for texture paths
	function SasUI.Textures(filename)
		if type(filename) ~= "string" then
			print(addon .. ": sgTextures requires a string filename.")
			return
		end
		return "Interface\\AddOns\\" .. addon .. "\\media\\" .. filename
	end
	
	-- Mouseover effect for UI frames or action bars with delayed fade
	function SasUI.Mouseover(frameName, alphaOnEnter, alphaOnLeave, isActionBar)
		-- Validate inputs
		if type(frameName) ~= "string" then
			print(addon .. ": Mouseover requires a string frameName.")
			return
		end
		alphaOnEnter = tonumber(alphaOnEnter) or 1.0
		alphaOnLeave = tonumber(alphaOnLeave) or 0.2
		if alphaOnEnter < 0 or alphaOnEnter > 1 or alphaOnLeave < 0 or alphaOnLeave > 1 then
			print(addon .. ": Alpha values must be between 0 and 1.")
			return
		end
		isActionBar = isActionBar or false -- Default to false if not provided

		-- Check if the frame exists
		if not FrameExists(frameName) then
			C_Timer.After(1, function() SasUI.Mouseover(frameName, alphaOnEnter, alphaOnLeave, isActionBar) end)
			print(addon .. ": Frame " .. frameName .. " not found to add mouseover.")
			return
		end

		-- Get the frame
		local frame = _G[frameName]

		-- Initialize frame
		frame:SetAlpha(alphaOnLeave)
		if isActionBar then
			frame:EnableMouse(true)
		end

		-- Define mouseover behavior
		local function applyMouseoverScripts(target)
			target:HookScript("OnEnter", function(self)
				frame:SetAlpha(alphaOnEnter)
				frame:SetScript("OnUpdate", nil) -- Clear any OnUpdate from OnLeave
			end)
			target:HookScript("OnLeave", function(self)
				frame:SetScript("OnUpdate", function()
					if not frame:IsMouseOver() then
						frame:SetScript("OnUpdate", nil)
						frame:SetAlpha(alphaOnLeave)
					end
				end)
			end)
		end

		-- Apply to the frame itself
		applyMouseoverScripts(frame)

		-- If it's an action bar, apply to buttons (1-12)
		if isActionBar then
			for i = 1, 12 do
				local button = _G[frameName .. "Button" .. i]
				if button then
					applyMouseoverScripts(button)
				end
			end
		end
	end
	
	-- FadeIn/FadeOut based on Combat
	function SasUI.CombatFader(frameName, alphaOnEnter, alphaOnLeave)
		local f = CreateFrame("Frame")
		f:RegisterEvent("PLAYER_REGEN_DISABLED")
		f:RegisterEvent("PLAYER_REGEN_ENABLED")

		local frame = _G[frameName]
		if frame then
			-- Set the frame to be invisible initially
			frame:SetAlpha(alphaOnLeave)
			
			f:SetScript("OnEvent", function(self, event)
				-- Set the frame to be visible when in combat
				if event == "PLAYER_REGEN_DISABLED" then
					frame:SetAlpha(alphaOnEnter)
				-- Set the frame to be invisible when combat ends
				elseif event == "PLAYER_REGEN_ENABLED" then
					frame:SetAlpha(alphaOnLeave)
				end
			end)
		else			-- If the frame is not found, delay the movement until it's created
			C_Timer.After(1, function() SetFrameAlphaByCombatStatus(frameName, alphaOnEnter, alphaOnLeave) end)
			print("Frame " .. frameName .. " not found to change alpha based on combat state.")
		end
	end
	
	-- Define your function to move UI frames
	function SasUI.Move(frameName, point, relativeTo, relativePoint, offsetX, offsetY)
		-- Get the frame using its name
		local frame = _G[frameName]
		if frame then
			-- Move the frame
			frame:ClearAllPoints()
			frame:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY)		
		else
			-- If the frame is not found, delay the movement until it's created
			C_Timer.After(1, function() MoveUIFrames(frameName, point, relativeTo, relativePoint, offsetX, offsetY) end)
			print("Frame " .. frameName .. " not found to move it.")
		end
	end
	
	function SasUI.ResizeBlizzFrames(frameName, scale, addonName)
		local frame = _G[frameName]
		if frame then
			-- Frame exists, apply scaling logic
			if frame.SetScale then
				frame:SetScale(scale)
				--print("Initial scale applied to " .. frameName .. ": " .. scale)
			end

			-- Hook SetSize to detect size changes
			hooksecurefunc(frame, "SetSize", function()
				if frame.SetScale then
					frame:SetScale(scale)
					--print("Frame " .. frameName .. " resized and scaled to " .. scale)
				end
			end)

			-- Hook SetScale to maintain desired scale
			hooksecurefunc(frame, "SetScale", function()
				if frame:GetScale() ~= scale then
					frame:SetScale(scale)
					--print("Frame " .. frameName .. " scale adjusted to " .. scale)
				end
			end)
		else
			-- Frame not found, set up event listener for ADDON_LOADED
			local eventFrame = CreateFrame("Frame")
			eventFrame:RegisterEvent("ADDON_LOADED")
			eventFrame:SetScript("OnEvent", function(self, event, loadedAddon)
				-- Check if the frame exists after any addon loads
				local newFrame = _G[frameName]
				if newFrame then
					if newFrame.SetScale then
						newFrame:SetScale(scale)
						--print("Initial scale applied to " .. frameName .. " after addon " .. loadedAddon .. " loaded: " .. scale)
					end

					-- Hook SetSize
					hooksecurefunc(newFrame, "SetSize", function()
						if newFrame.SetScale then
							newFrame:SetScale(scale)
							--print("Frame " .. frameName .. " resized and scaled to " .. scale)
						end
					end)

					-- Hook SetScale
					hooksecurefunc(newFrame, "SetScale", function()
						if newFrame:GetScale() ~= scale then
							newFrame:SetScale(scale)
							--print("Frame " .. frameName .. " scale adjusted to " .. scale)
						end
					end)

					-- Unregister event to clean up
					self:UnregisterEvent("ADDON_LOADED")
				elseif addonName and loadedAddon == addonName then
					-- If specific addon was provided but frame still not found, warn and clean up
					--print("Frame " .. frameName .. " not found even after addon " .. loadedAddon .. " loaded.")
					self:UnregisterEvent("ADDON_LOADED")
				end
			end)
			--print("Frame " .. frameName .. " not found, waiting for addon to load.")
		end
	end
	
	-----------------------------
	-- Paint Textures
	-----------------------------
	
	-- Set the textures to be class colored
	local ClassColored = true
	
	rRAID_CLASS_COLORS = {
		["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45 },
		["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79 },
		["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0 },
		["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73 },
		["MAGE"] = { r = 0.41, g = 0.8, b = 0.94 },
		["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41 },
		["DRUID"] = { r = 1.0, g = 0.49, b = 0.04 },
		["SHAMAN"] = { r = 0.0, g = 0.44, b = 0.87 },
		["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43 },
		["DEATHKNIGHT"] = { r = 0.77, g = 0.12, b = 0.23 },
		["MONK"] = { r = 0, g = 1.0, b = 0.57 },
		["DEMONHUNTER"] = { r = 0.64, g = 0.19, b = 0.79 },
		["EVOKER"] = { r = 0.2, g = 0.58, b = 0.5 },
	}
			
	local cc = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[select(2, UnitClass("player"))] or rRAID_CLASS_COLORS[select(2, UnitClass("player"))] or  { r=0.5, g=0.5, b=0.5 }
		
	local function PaintTextures()
		local cl = ClassColored == true
		local r1, g1, b1, a1 = 1, 1, 1, 1 -- top color
		local r2, g2, b2, a2 = cl and cc.r or 0.58, cl and cc.g or 0.51, cl and cc.b or 0.79, 1 -- bottom color

		for i,v in pairs({
			
			-- Minimap
			MinimapCompassTexture,
			Minimap.ZoomIn:GetRegions(),
			Minimap.ZoomOut:GetRegions(),

			-- Menus
			FriendsFrame:GetRegions(),
			CharacterFrame:GetRegions(),			

		}) do
			if v:GetObjectType() == "Texture" then
				v:SetVertexColor(1, 1, 1)
				v:SetDesaturated(1)
				v:SetVertexColor(r2, g2, b2)
			end
		end
		
	end
	PaintTextures()
	
	
--[[	
	-- Helper function to apply mouseover fade behavior to any frame
	function SasUI.Mouseover(frameName, alphaOnEnter, alphaOnLeave)
		local frame = _G[frameName]
		-- Ensure the frame exists and is valid
		if not frame or not frame.HookScript then
			print(addon .. ": Mouseover requires a valid frameName.")
			return
		end
		
		-- Validate inputs
		if type(frame) ~= "string" then
			print(addon .. ": Mouseover requires a string frameName.")
			return
		end
		
		-- Set frame alpha on login
		frame:SetAlpha(alphaOnLeave)
		
		-- Function to handle fading when the mouse leaves
		local function WaitForMouseToGoAway(self)
			if not self:IsMouseOver() then
				self:SetScript("OnUpdate", nil)
				self:SetAlpha(alphaOnLeave)
			end
		end

		-- Hook OnEnter to show the frame
		frameName:HookScript("OnEnter", function(self)
			self:SetAlpha(alphaOnEnter)
		end)

		-- Hook OnLeave to start fading
		frameName:HookScript("OnLeave", function(self)
			self:SetScript("OnUpdate", WaitForMouseToGoAway)
		end)
	end

	-- Mouseover effect for UI frames
	function SasUI.Mouseover(frameName, alphaOnEnter, alphaOnLeave)
		-- Validate inputs
		if type(frameName) ~= "string" then
			print(addon .. ": Mouseover requires a string frameName.")
			return
		end
		alphaOnEnter = tonumber(alphaOnEnter) or 1.0
		alphaOnLeave = tonumber(alphaOnLeave) or 0.2
		if alphaOnEnter < 0 or alphaOnEnter > 1 or alphaOnLeave < 0 or alphaOnLeave > 1 the
			print(addon .. ": Alpha values must be between 0 and 1.")
			return
		end

		-- Get the frame
		local frame = _G[frameName]
		if frame then
			frame:SetAlpha(alphaOnLeave)
			frame:SetScript("OnEnter", function(self)
				self:SetAlpha(alphaOnEnter)
			end)
			frame:SetScript("OnLeave", function(self)
				self:SetAlpha(alphaOnLeave)
			end)
		else
			C_Timer.After(1, function() SasUI.Mouseover(frameName, alphaOnEnter, alphaOnLeave) end)
			print(addon .. ": Frame " .. frameName .. " not found to add mouseover.")
		end
	end
]]--

--[[	
	-- Mouseover effect for UI frames with delayed fade
	function SasUI.Mouseover(frameName, alphaOnEnter, alphaOnLeave)
		-- Validate inputs
		if type(frameName) ~= "string" then
			print(addon .. ": Mouseover requires a string frameName.")
			return
		end
		alphaOnEnter = tonumber(alphaOnEnter) or 1.0
		alphaOnLeave = tonumber(alphaOnLeave) or 0.2
		if alphaOnEnter < 0 or alphaOnEnter > 1 or alphaOnLeave < 0 or alphaOnLeave > 1 then
			print(addon .. ": Alpha values must be between 0 and 1.")
			return
		end

		-- Get the frame
		local frame = _G[frameName]
		if frame then
			frame:SetAlpha(alphaOnLeave)
			frame:SetScript("OnEnter", function(self)
				self:SetAlpha(alphaOnEnter)
				self:SetScript("OnUpdate", nil) -- Clear any OnUpdate from OnLeave
			end)
			frame:SetScript("OnLeave", function(self)
				-- Set OnUpdate to check if mouse is still over before fading
				self:SetScript("OnUpdate", function(self)
					if not self:IsMouseOver() then
						self:SetScript("OnUpdate", nil)
						self:SetAlpha(alphaOnLeave)
					end
				end)
			end)
		else
			C_Timer.After(1, function() SasUI.Mouseover(frameName, alphaOnEnter, alphaOnLeave) end)
			print(addon .. ": Frame " .. frameName .. " not found to add mouseover.")
		end
	end
	
	-- FadeIn/FadeOut buttons in a bar
	function SasUI.BarMouseover(barName,alphaOnEnter, alphaOnLeave)
		local bar = _G[barName]
		
		if not bar then
			print("Bar " .. barName .. " not found.")
			return
		end
		
		bar:SetAlpha(alphaOnLeave)

		bar:EnableMouse(true)
		bar:HookScript("OnEnter", function()
			bar:SetAlpha(alphaOnEnter)
		end)
		bar:HookScript("OnLeave", function()
			bar:SetAlpha(alphaOnLeave)
		end)

		for i = 1, 12 do
			local button = _G[barName.."Button"..i]
			if button then
				button:HookScript("OnEnter", function()
					bar:SetAlpha(alphaOnEnter)
				end)
				button:HookScript("OnLeave", function()
					bar:SetAlpha(alphaOnLeave)
				end)
			end
		end
	end
]]--	