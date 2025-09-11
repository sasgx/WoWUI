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
		if event == "MODIFIER_STATE_CHANGED" and (key == "LALT") or (key == "RALT") then
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