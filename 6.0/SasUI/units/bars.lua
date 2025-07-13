    -- disable the automatic frame position
	do
		for _, frame in pairs({
			'MultiBarLeft',
			'MultiBarRight',
			'MultiBarBottomRight',

			'StanceBarFrame',
			'PossessBarFrame',

			'MULTICASTACTIONBAR_YPOS',
			'MultiCastActionBarFrame',

			'PETACTIONBAR_YPOS',
		}) do
			UIPARENT_MANAGED_FRAME_POSITIONS[frame] = nil
		end
	end
	
	-- hide unwanted objects
	for i = 2, 3 do
		for _, object in pairs({
			_G['ActionBarUpButton'],
			_G['ActionBarDownButton'],

			_G['MainMenuBarBackpackButton'],
			_G['KeyRingButton'],

			_G['CharacterBag0Slot'],
			_G['CharacterBag1Slot'],
			_G['CharacterBag2Slot'],
			_G['CharacterBag3Slot'],

			_G['MainMenuBarTexture'..i],
			_G['MainMenuMaxLevelBar'..i],
			_G['MainMenuXPBarTexture'..i],

			_G['ReputationWatchBarTexture'..i],
			_G['ReputationXPBarTexture'..i],

			_G['MainMenuBarPageNumber'],

			_G['SlidingActionBarTexture0'],
			_G['SlidingActionBarTexture1'],

			_G['StanceBarLeft'],
			_G['StanceBarMiddle'],
			_G['StanceBarRight'],

			_G['PossessBackground1'],
			_G['PossessBackground2'],
		}) do 
			if (object:IsObjectType('Frame') or object:IsObjectType('Button')) then
				object:UnregisterAllEvents()
				object:SetScript('OnEnter', nil)
				object:SetScript('OnLeave', nil)
				object:SetScript('OnClick', nil)
			end

			hooksecurefunc(object, 'Show', function(self)
				self:Hide()
			end)

			object:Hide()
		end
	end
	
	-- reduce the size of some main menu bar objects
	for _, object in pairs({
		_G['MainMenuBar'],
		_G['MainMenuExpBar'],
		_G['MainMenuBarMaxLevelBar'],
	}) do
		object:SetWidth(410)
	end
	
	for _, object in pairs({
		_G['ReputationWatchBar'],
		_G['ReputationWatchStatusBar'],
	}) do
		object:SetWidth(512) -- Setting the repbar the same width as the expbar causes left over textures
	end
	
    -- remove divider
	for i = 1, 19, 2 do
		for _, object in pairs({
			_G['MainMenuXPBarDiv'..i],
		}) do
			hooksecurefunc(object, 'Show', function(self)
				self:Hide()
			end)

			object:Hide()
		end
	end

	hooksecurefunc(_G['MainMenuXPBarDiv2'], 'Show', function(self)
		local divWidth = MainMenuExpBar:GetWidth() / 10
		local xpos = divWidth - 4.5

		for i = 2, 19, 2 do
			local texture = _G['MainMenuXPBarDiv'..i]
			local xalign = floor(xpos)
			texture:SetPoint('LEFT', xalign, 1)
			xpos = xpos + divWidth
		end
	end)

	_G['MainMenuXPBarDiv2']:Show()
