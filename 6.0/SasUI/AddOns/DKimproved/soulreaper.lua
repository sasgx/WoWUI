--[[
Designed to make a Spell Overlay for Soul Reaper and to make the spell itself glow on the action bar.

credits:	Xruptor for the Spell Overlay 
			grimgaw for the Glow function
]]


if select(2, UnitClass("player")) ~= "DEATHKNIGHT" then
	return
end

local SRPercent
if IsSpellKnown(157342) then
	SRPercent = 45
else
	SRPercent = 35
end

-- NOTE: Would like to flip the image vertically
local SRTex = "TEXTURES\\SPELLACTIVATIONOVERLAYS\\DARK_TRANSFORMATION.BLP"

-- // xanShadowBurn Code Modified to work with Soul Reaper \\ --
 
local f = CreateFrame("frame","SReaper_frame",UIParent)
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)

local isShown = false

local TimerOnUpdate = function(self, time)
	--only do this if we even have the soul reaper spell in our spellbook and we can attack the target
	if UnitName("target") and UnitGUID("target") and UnitCanAttack("player", "target") and IsSpellKnown(130736) then
		self.OnUpdateCounter = (self.OnUpdateCounter or 0) + time
		if self.OnUpdateCounter < 0.05 then return end
		self.OnUpdateCounter = 0
		
		if UnitIsDeadOrGhost("target") then
			isShown = false
			SpellActivationOverlay_HideOverlays(SpellActivationOverlayFrame, 130736)
			f:SetScript("OnUpdate", nil)
			return
		end
		
		local percent = UnitHealth("target") / UnitHealthMax("target") * 100
		if percent <= SRPercent and isShown == false then
			isShown = true --this is to prevent spamming of it while the mob is still under 20
			SpellActivationOverlay_ShowOverlay(SpellActivationOverlayFrame, 130736, SRTex, "BOTTOM", 1, 255, 255, 255, false, false)
		elseif percent <= SRPercent and isShown == true then
			--do nothing
		else
			isShown = false
			SpellActivationOverlay_HideOverlays(SpellActivationOverlayFrame, 130736)
		end
	else
		SpellActivationOverlay_HideOverlays(SpellActivationOverlayFrame, 130736)
		f:SetScript("OnUpdate", nil)
		isShown = false
		return
	end
	
end

function f:PLAYER_LOGIN()

	f:RegisterEvent("PLAYER_TARGET_CHANGED")
	
	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
end

function f:PLAYER_TARGET_CHANGED()
	--only do this if we even have the soul reaper spell in our spellbook and we can attack the target
	if UnitName("target") and UnitGUID("target") and UnitIsEnemy("player", "target") and IsSpellKnown(130736) then
		isShown = false
		f:SetScript("OnUpdate", TimerOnUpdate)
	end
end


if IsLoggedIn() then f:PLAYER_LOGIN() else f:RegisterEvent("PLAYER_LOGIN") end

-- \\ xanShadowBurn Code Modified to work with Soul Reaper // --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- // mortSoulReaper Code Modified slightly \\ --

local mSR = CreateFrame('Frame', 'mortSoulReaper', UIParent)
mSR:RegisterEvent('PLAYER_TARGET_CHANGED')
mSR:SetScript('OnEvent', function(self, event, unit)
	if event == 'UNIT_HEALTH' then
		if unit ~= 'target' then return end
		local health, maxHealth = UnitHealth('target'), UnitHealthMax('target')
		if health > 0 and health / maxHealth <= SRPercent/100 then
			mSR_Glow('Soul Reaper')
		else
			mSR_Dim('Soul Reaper')
		end
	else
		if UnitExists('target') and UnitCanAttack('player', 'target') then
			self:RegisterEvent('UNIT_HEALTH')
			self:GetScript('OnEvent')(self, 'UNIT_HEALTH', 'target')
		else
			mSR_Dim('Soul Reaper')
			self:UnregisterEvent('UNIT_HEALTH')
		end
	end
end)		

function mSR_Glow(spell)
	local bars={'Action','MultiBarBottomLeft','MultiBarBottomRight','MultiBarLeft','MultiBarRight'}
	for bar=1,#bars do
		for button=1,NUM_ACTIONBAR_BUTTONS do
			local buttonName = bars[bar]..'Button'..button
			local mtype, id, _ = GetActionInfo(_G[buttonName].action)
			if mtype == 'macro' then
				local mName, _ = GetMacroSpell(id)
				if mName == spell then
					ActionButton_ShowOverlayGlow(_G[buttonName])
					_G[buttonName].glow = true
				end
			elseif mtype == 'spell' then
				local sName, _ = GetSpellInfo(id)
				if sName == spell then
					ActionButton_ShowOverlayGlow(_G[buttonName])
				end
			end
		end
	end
end

function mSR_Dim(spell)
	local bars={'Action','MultiBarBottomLeft','MultiBarBottomRight','MultiBarLeft','MultiBarRight'}
	for bar=1,#bars do
		for button=1,NUM_ACTIONBAR_BUTTONS do
			local buttonName = bars[bar]..'Button'..button
			local mtype, id, _ = GetActionInfo(_G[buttonName].action)
			if mtype == 'macro' then
				local mName, _ = GetMacroSpell(id)
				if mName == spell then
					ActionButton_HideOverlayGlow(_G[buttonName])
				end
			elseif mtype == 'spell' then
				local sName, _ = GetSpellInfo(id)
				if sName == spell then
					ActionButton_HideOverlayGlow(_G[buttonName])
				end
			end
		end
	end
end

-- \\ mortSoulReaper Code Modified slightly // --



--[[
	SPELL OVERLAYS
	
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\MASTER_MARKSMAN.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\FOCUS_FIRE.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\LOCK_AND_LOAD.BLP"

"TEXTURES\\SPELLACTIVATIONOVERLAYS\\BLOOD_SURGE.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\SWORD_AND_BOARD.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\SUDDEN_DEATH.BLP"

"TEXTURES\\SPELLACTIVATIONOVERLAYS\\MAELSTROM_WEAPON.BLP"

"TEXTURES\\SPELLACTIVATIONOVERLAYS\\FULMINATION.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\IMPACT.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\FROZEN_FINGERS.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\ARCANE_MISSILES.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\HOT_STREAK.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\BRAIN_FREEZE.BLP"

"TEXTURES\\SPELLACTIVATIONOVERLAYS\\SURGE_OF_LIGHT.BLP"

"TEXTURES\\SPELLACTIVATIONOVERLAYS\\MOLTEN_CORE.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\BACKLASH.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\IMP_EMPOWERMENT.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\NIGHTFALL.BLP"

"TEXTURES\\SPELLACTIVATIONOVERLAYS\\NATURES_GRACE.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\GENERICTOP_01.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\ECLIPSE_SUN.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\FURY_OF_STORMRAGE.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\ECLIPSE_MOON.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\SHOOTING_STARS.BLP"

"TEXTURES\\SPELLACTIVATIONOVERLAYS\\DARK_TRANSFORMATION.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\SUDDEN_DOOM.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\RIME.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\KILLING_MACHINE.BLP"

"TEXTURES\\SPELLACTIVATIONOVERLAYS\\GRAND_CRUSADER.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\ART_OF_WAR.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\DAYBREAK.BLP"
"TEXTURES\\SPELLACTIVATIONOVERLAYS\\HAND_OF_LIGHT.BLP"

]]