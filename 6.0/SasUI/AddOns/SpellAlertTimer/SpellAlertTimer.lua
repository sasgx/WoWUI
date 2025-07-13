local barLength = 128
local barWidth = 4
local barColorR 
local barColorG 
local barColorB 

local leftTimerFrame = CreateFrame("StatusBar", "LeftTimerFrame", SpellActivationOverlayFrame)
local rightTimerFrame = CreateFrame("StatusBar", "RightTimerFrame", SpellActivationOverlayFrame)
local topTimerFrame = CreateFrame("StatusBar", "TopTimerFrame", SpellActivationOverlayFrame)

local leftGcdWarning = leftTimerFrame:CreateTexture("LeftGcdWarning","BACKGROUND")
local rightGcdWarning = rightTimerFrame:CreateTexture("RightGcdWarning","BACKGROUND")
local topGcdWarning = topTimerFrame:CreateTexture("TopGcdWarning","BACKGROUND")

leftTimerFrame:RegisterEvent("PLAYER_LOGIN")
leftTimerFrame:SetScript("OnEvent", function()
	local class = select(2,UnitClass("player"))

-- todo: costom color for every spell
	if class == "WARRIOR" then
	--[[	--good for sword and board
		barColorR = 1
		barColorG = .2
		barColorB = .1
--]]
--good for ultimatum
--[[
		barColorR = 1
		barColorG = .9
		barColorB = .8
		--]]
		--good for bloodsurge
		barColorR = 1
		barColorG = .4
		barColorB = .1

	elseif class == "MAGE" then
		barColorR = .4
		barColorG = .7
		barColorB = 1
	elseif class == "ROGUE" then
		barColorR = 1
		barColorG = .5
		barColorB = .1
	elseif class == "DRUID" then
		--good for shooting stars - balance - top
		barColorR = .7	
		barColorG = .5
		barColorB = 1

--[[    --good for omen of clarity/clearcasting - restoration - sides
		barColorR = .7	
		barColorG = 1
		barColorB = .1
--]]
	elseif class == "HUNTER" then
		barColorR = .7
		barColorG = .8
		barColorB = .2
	elseif class == "SHAMAN" then
		barColorR = .3
		barColorG = .4
		barColorB = 1
	elseif class == "PRIEST" then
		barColorR = 1
		barColorG = 1
		barColorB = .8
	elseif class == "WARLOCK" then
		barColorR = .4
		barColorG = .1
		barColorB = 1
	elseif class == "PALADIN" then
		barColorR = 1
		barColorG = .8
		barColorB = .1
	elseif class == "DEATHKNIGHT" then
		barColorR = .1
		barColorG = 1
		barColorB = 1
	elseif class == "MONK" then
		barColorR = .1
		barColorG = .9
		barColorB = .4

	end
	leftTimerFrame:SetStatusBarColor(barColorR,barColorG,barColorB)
	rightTimerFrame:SetStatusBarColor(barColorR,barColorG,barColorB)
	topTimerFrame:SetStatusBarColor(barColorR,barColorG,barColorB)
end)


leftTimerFrame:SetOrientation("VERTICAL")
leftTimerFrame:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
leftTimerFrame:SetRotatesTexture(true)
leftTimerFrame:SetPoint("RIGHT",SpellActivationOverlayFrame,"LEFT")
leftTimerFrame:SetSize(barWidth,barLength)
leftTimerFrame:Hide()

leftGcdWarning:SetSize(barWidth*2,8)
leftGcdWarning:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
leftGcdWarning:SetRotation(math.pi/2)
leftGcdWarning:SetVertexColor(.9,0,0)
leftGcdWarning:SetPoint("BOTTOM")


rightTimerFrame:SetOrientation("VERTICAL")
rightTimerFrame:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
rightTimerFrame:SetRotatesTexture(true)
rightTimerFrame:SetPoint("LEFT",SpellActivationOverlayFrame,"RIGHT")
rightTimerFrame:SetSize(barWidth,barLength)
rightTimerFrame:Hide()

rightGcdWarning:SetSize(barWidth*2,8)
rightGcdWarning:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
rightGcdWarning:SetRotation(math.pi/2)
rightGcdWarning:SetVertexColor(.9,0,0)
rightGcdWarning:SetPoint("BOTTOM")


topTimerFrame:SetPoint("BOTTOM",SpellActivationOverlayFrame,"TOP")
topTimerFrame:SetSize(barLength,barWidth)
topTimerFrame:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
topTimerFrame:Hide()


topGcdWarning:SetSize(8,barWidth*2)
topGcdWarning:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
topGcdWarning:SetVertexColor(.9,0,0)
topGcdWarning:SetPoint("LEFT")


topTimerFrame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW")
topTimerFrame:SetScript("OnEvent", function(self, event, ...)
	local overlayPosition = (select(3,...)) -- "Top", "Left + Right (Flipped)" , "Left" , "Right (Flipped)"

												--[[
												druid:restoration:Clearcasting: "Left + Right (Flipped)" triggered by spell "Omen of Clarity"
												warlock:demonology:Molten Core: "Left" at first stack, spellID = 122355 "Right (Flipped)" at 2 stacks, spellID = 126090 3+ does not trigger event
												]]
--[[debugging code
	print(" ")
	print("event = ",event)
	print("event arguments = " , ...)
	print("spell info = " , GetSpellInfo((...)))
	print("overlayPosition = " , overlayPosition)
--]]
	
	local spellID = (...)
	if spellID == 93426 then	--Dark Transformation
		spellID = 49572		--Shadow Infusion
	end
								--[[
									122355 Molten Core (1 stack)
									126090 Molten Core (2 stacks)
								]]


	local spellName = GetSpellInfo(spellID)
	local spellDuration = (select(6, UnitBuff("player",spellName) ))
		--[[debugging code
		print("UnitBuff = " , UnitBuff("player",spellName))
		--]]

	if spellDuration and spellID ~= 126090 then 					--Molten Core 2 stacks
		--[[ debugging code
		print("spellName = " .. spellName,  "spellDuration = " , spellDuration)
		--]]

		if overlayPosition == "Top" then
			
			startTimer(topTimerFrame, topGcdWarning, spellName, spellDuration)
		elseif overlayPosition == "Left + Right (Flipped)" then
	
			startTimer(leftTimerFrame, leftGcdWarning, spellName, spellDuration)
			startTimer(rightTimerFrame, rightGcdWarning, spellName, spellDuration)
		elseif overlayPosition == "Left" then

			startTimer(leftTimerFrame, leftGcdWarning, spellName, spellDuration)
		elseif overlayPosition == "Right (Flipped)" then

			startTimer(rightTimerFrame, rightGcdWarning, spellName, spellDuration)
		end
	end
end)


function startTimer(timerFrame, gcdWarning, spellName, spellDuration)
	--[[timerFrame:SetMinMaxValues(0, spellDuration )
	if timerFrame == topTimerFrame then
		gcdWarning:SetWidth(barLength*1.5/spellDuration)
	else
		gcdWarning:SetHeight(barLength*1.5/spellDuration)
	end]]

	timerFrame:Show()
	timerFrame:SetScript("OnUpdate",function()
		if UnitBuff("player", spellName) == nil then
			timerFrame:Hide()
			timerFrame:SetMinMaxValues(0, 0)
			timerFrame:SetScript("OnUpdate",function() end)
		else
			local spellExpiration = (select(7, UnitBuff("player",spellName) ))
			local timeRemaining = spellExpiration -GetTime()
			local timerLength = select(2,timerFrame:GetMinMaxValues())
			timerFrame:SetValue(timeRemaining)
			if timeRemaining <= 6 and timerLength ~= 6 then
				timerFrame:SetMinMaxValues(0, 6)
				if timerFrame == topTimerFrame then
					timerFrame:SetHeight(barWidth*2)
					gcdWarning:SetSize(barLength/4,barWidth*4)
				else
					timerFrame:SetWidth(barWidth*2)
					gcdWarning:SetSize(barWidth*4,barLength/4)
				end
			elseif timeRemaining >= 6 and timerLength ~= spellDuration then
				timerFrame:SetMinMaxValues(0, spellDuration )
				if timerFrame == topTimerFrame then
					timerFrame:SetHeight(barWidth)
					gcdWarning:SetSize(barLength*1.5/spellDuration, barWidth*2)
				else
					timerFrame:SetWidth(barWidth)
					gcdWarning:SetSize(barWidth*2, barLength*1.5/spellDuration)
				end
			end
		end
	end)
end
--[[
function setBarColors(barR, barG, barB, colorR, colorG, colorB)
	barR = colorR
	barG = colorG
	barB = colorB
end
--]]
