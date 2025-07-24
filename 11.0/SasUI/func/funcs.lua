	local addon, ns = ...

	-- Create addon namespace
	ns.SasUI = ns.SasUI or {}
	local SasUI = ns.SasUI

	-- Variables
	local SpellFlyout = SpellFlyout
	local NUM_ACTIONBAR_BUTTONS = 12
	local registeredFrames = {} -- Table to track all frames with mouseover
	local combatFrames = {} -- Table to track frames with combat fading enabled

	-- Function to check if a frame exists
	local function FrameExists(frameName)
		return _G[frameName] ~= nil
	end

	-- Function to safely check if a frame is valid for mouseover
	local function IsValidFrame(frame)
		return type(frame) == "table" and frame.GetObjectType and frame:IsObjectType("Frame") and frame.IsMouseOver
	end

	-- Function called when fade animation finishes
	local function FaderOnFinished(self)
		self.__owner:SetAlpha(self.finAlpha)
	end

	-- Create fade animation for a frame
	local function CreateFadeAnimation(frame, fadeIn, duration, fromAlpha, toAlpha)
		if not frame.__fader then
			frame.__fader = frame:CreateAnimationGroup()
			frame.__fader.__owner = frame
			frame.__fader.anim = frame.__fader:CreateAnimation("Alpha")
			frame.__fader:HookScript("OnFinished", FaderOnFinished)
		end
		frame.__fader:Stop()
		frame.__fader.anim:SetFromAlpha(fromAlpha)
		frame.__fader.anim:SetToAlpha(toAlpha)
		frame.__fader.anim:SetDuration(duration)
		frame.__fader.anim:SetSmoothing(fadeIn and "IN" or "OUT")
		frame.__fader.finAlpha = toAlpha
		frame.__fader.direction = fadeIn and "in" or "out"
		frame.__fader:Play()
	end

	-- Check if mouse is over frame or its flyout
	local function IsMouseOverFrame(frame)
		if not IsValidFrame(frame) then return false end
		if frame:IsMouseOver() then return true end
		if not SpellFlyout or not SpellFlyout:IsShown() then return false end
		if not IsValidFrame(SpellFlyout) then return false end
		if SpellFlyout.__faderParent == frame and SpellFlyout:IsMouseOver() then return true end
		return false
	end

	-- Frame handler for fading based on combat, mouseover, or Alt key
	local function FrameHandler(frame)
		if not IsValidFrame(frame) or not frame.__faderConfig then return end
		if frame.__faderConfig.isCombatFader and UnitAffectingCombat("player") then
			-- In combat: force fade in
			CreateFadeAnimation(frame, true, frame.__faderConfig.fadeInDuration or 0.3, frame:GetAlpha(), frame.__faderConfig.fadeInAlpha or 1)
		elseif IsAltKeyDown() then
			-- Alt is held: force fade in
			CreateFadeAnimation(frame, true, frame.__faderConfig.fadeInDuration or 0.3, frame:GetAlpha(), frame.__faderConfig.fadeInAlpha or 1)
		elseif IsMouseOverFrame(frame) then
			-- Mouseover: fade in
			CreateFadeAnimation(frame, true, frame.__faderConfig.fadeInDuration or 0.3, frame:GetAlpha(), frame.__faderConfig.fadeInAlpha or 1)
		else
			-- No mouseover, Alt not held, not in combat: fade out
			CreateFadeAnimation(frame, false, frame.__faderConfig.fadeOutDuration or 0.3, frame:GetAlpha(), frame.__faderConfig.fadeOutAlpha or 0.2)
		end
	end

	-- Handler for buttons or flyout frames
	local function OffFrameHandler(self)
		if not self.__faderParent then return end
		FrameHandler(self.__faderParent)
	end

	-- Handle SpellFlyout show event
	local function SpellFlyoutOnShow(self)
		local frame = self:GetParent() and self:GetParent():GetParent() and self:GetParent():GetParent():GetParent()
		if not frame or not frame.__fader then return end
		self.__faderParent = frame
		if not self.__faderHook then
			SpellFlyout:HookScript("OnEnter", OffFrameHandler)
			SpellFlyout:HookScript("OnLeave", OffFrameHandler)
			self.__faderHook = true
		end
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local button = _G["SpellFlyoutButton" .. i]
			if not button then break end
			button.__faderParent = frame
			if not button.__faderHook then
				button:HookScript("OnEnter", OffFrameHandler)
				button:HookScript("OnLeave", OffFrameHandler)
				button.__faderHook = true
			end
		end
	end
	if SpellFlyout then
		SpellFlyout:HookScript("OnShow", SpellFlyoutOnShow)
	end

	-- Main Mouseover function
	function SasUI.Mouseover(frameName, alphaOnEnter, alphaOnLeave, isCombatFader, isActionBar)
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
		isActionBar = isActionBar or false
		isCombatFader = isCombatFader or false

		-- Check if the frame exists
		if not FrameExists(frameName) then
			C_Timer.After(1, function() SasUI.Mouseover(frameName, alphaOnEnter, alphaOnLeave, isCombatFader, isActionBar) end)
			print(addon .. ": Frame " .. frameName .. " not found to add mouseover.")
			return
		end

		-- Get the frame
		local frame = _G[frameName]
		if not IsValidFrame(frame) then
			print(addon .. ": Frame " .. frameName .. " is not a valid frame for mouseover.")
			return
		end

		-- Initialize fader config
		frame.__faderConfig = {
			fadeInAlpha = alphaOnEnter,
			fadeOutAlpha = alphaOnLeave,
			fadeInDuration = 1,
			fadeOutDuration = 1,
			isCombatFader = isCombatFader
		}

		-- Set initial alpha
		frame:SetAlpha(alphaOnLeave)
		if isActionBar then
			frame:EnableMouse(true)
		end

		-- Create fade animation
		CreateFadeAnimation(frame, false, 0, alphaOnLeave, alphaOnLeave)

		-- Apply mouseover scripts to frame
		frame:HookScript("OnEnter", FrameHandler)
		frame:HookScript("OnLeave", FrameHandler)

		-- If action bar, apply to buttons
		if isActionBar then
			for i = 1, NUM_ACTIONBAR_BUTTONS do
				local button = _G[frameName .. "Button" .. i]
				if button and IsValidFrame(button) then
					button.__faderParent = frame
					if not button.__faderHook then
						button:HookScript("OnEnter", OffFrameHandler)
						button:HookScript("OnLeave", OffFrameHandler)
						button.__faderHook = true
					end
				end
			end
		end

		-- Track all registered frames and combat fader frames
		registeredFrames[frameName] = frame
		if isCombatFader then
			combatFrames[frameName] = frame
		end

		-- Initial frame handler call
		FrameHandler(frame)
	end

	-- Update frame states on modifier key or combat change
	local updateFrame = CreateFrame("Frame")
	updateFrame:RegisterEvent("MODIFIER_STATE_CHANGED")
	updateFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	updateFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	updateFrame:SetScript("OnEvent", function(self, event, key, state)
		if event == "MODIFIER_STATE_CHANGED" and (key == "RALT") then
			for frameName, frame in pairs(registeredFrames) do
				if IsValidFrame(frame) and frame.__faderConfig then
					FrameHandler(frame)
				end
			end
		elseif event == "PLAYER_REGEN_DISABLED" or event == "PLAYER_REGEN_ENABLED" then
			for frameName, frame in pairs(combatFrames) do
				if IsValidFrame(frame) and frame.__faderConfig then
					FrameHandler(frame)
				end
			end
		end
	end)

	-- Universal function for texture paths
	function SasUI.Textures(filename)
		if type(filename) ~= "string" then
			print(addon .. ": Textures requires a string filename.")
			return
		end
		return "Interface\\AddOns\\" .. addon .. "\\media\\" .. filename
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
			C_Timer.After(1, function() SasUI.Move(frameName, point, relativeTo, relativePoint, offsetX, offsetY) end)
			print("Frame " .. frameName .. " not found to move it.")
		end
	end

	-- Resize Blizzard frames
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

			-- Hook SetScale to maintain desired scale
			hooksecurefunc(frame, "SetScale", function()
				if frame:GetScale() ~= scale then
					frame:SetScale(scale)
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
					end

					-- Hook SetSize
					hooksecurefunc(newFrame, "SetSize", function()
						if newFrame.SetScale then
							newFrame:SetScale(scale)
						end
					end)

					-- Hook SetScale
					hooksecurefunc(newFrame, "SetScale", function()
						if newFrame:GetScale() ~= scale then
							newFrame:SetScale(scale)
						end
					end)

					-- Unregister event to clean up
					self:UnregisterEvent("ADDON_LOADED")
				elseif addonName and loadedAddon == addonName then
					-- If specific addon was provided but frame still not found, warn and clean up
					self:UnregisterEvent("ADDON_LOADED")
				end
			end)
		end
	end

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
		["MONK"] = { r = 0.0, g = 1.0, b = 0.57 },
		["DEMONHUNTER"] = { r = 0.64, g = 0.19, b = 0.79 },
		["EVOKER"] = { r = 0.2, g = 0.58, b = 0.5 },
	}

	local cc = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[select(2, UnitClass("player"))] or rRAID_CLASS_COLORS[select(2, UnitClass("player"))] or { r=0.5, g=0.5, b=0.5 }

	local function PaintTextures()
		local cl = ClassColored == true
		local r1, g1, b1, a1 = 1, 1, 1, 1 -- top color
		local r2, g2, b2, a2 = cl and cc.r or 0.58, cl and cc.g or 0.51, cl and cc.b or 0.79, 1 -- bottom color

		for i, v in pairs({
			-- Minimap
			MinimapCompassTexture,
			Minimap.ZoomIn:GetRegions(),
			Minimap.ZoomOut:GetRegions(),

			-- Menus
			FriendsFrame:GetRegions(),
			CharacterFrame:GetRegions(),
		}) do
			if v and v:GetObjectType() == "Texture" then
				v:SetVertexColor(1, 1, 1)
				v:SetDesaturated(1)
				v:SetVertexColor(r2, g2, b2)
			end
		end
	end
	PaintTextures()
	
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