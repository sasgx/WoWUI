if select(2, UnitClass("player")) ~= "DEATHKNIGHT" then
	return
end

local SRPercent
if IsSpellKnown(157342) then
	SRPercent = 45
else
	SRPercent = 35
end

-- // xanShadowBurn Code Modified to work with Soul Reaper \\ --
 
local f = CreateFrame("frame","SReaper_frame",UIParent)
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)

local soundPlayed = false

local TimerOnUpdate = function(self, time)
	--only do this if we even have the soul reaper spell in our spellbook and we can attack the target
	if UnitName("target") and UnitGUID("target") and UnitCanAttack("player", "target") and IsSpellKnown(130736) then
		self.OnUpdateCounter = (self.OnUpdateCounter or 0) + time
		if self.OnUpdateCounter < 0.05 then return end
		self.OnUpdateCounter = 0
		
		if UnitIsDeadOrGhost("target") then
			soundPlayed = false
			f:SetScript("OnUpdate", nil)
			return
		end
		
		local percent = UnitHealth("target") / UnitHealthMax("target") * 100
		if percent <= SRPercent and soundPlayed == false then
			soundPlayed = true --this is to prevent spamming of it while the mob is still under 20
			local RNG = math.random(2)
				if RNG == 1 then
					PlaySoundFile("Sound\\Creature\\Lichking\\Eh_lichking_chapter1whisper04.ogg", "Dialog")
				elseif RNG == 2 then	
					PlaySoundFile("Sound\\Creature\\Lichking\\Eh_lichking_chapter1whisper05.ogg", "Dialog")
				end
		elseif percent <= SRPercent and soundPlayed == true then
			--do nothing
		else
			soundPlayed = false
		end
	else
		f:SetScript("OnUpdate", nil)
		soundPlayed = false
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
		soundPlayed = false
		f:SetScript("OnUpdate", TimerOnUpdate)
	end
end


if IsLoggedIn() then f:PLAYER_LOGIN() else f:RegisterEvent("PLAYER_LOGIN") end

-- \\ xanShadowBurn Code Modified to work with Soul Reaper // --



--[[
// -- SOUND FILES -- \\

-- Lich King
PlaySoundFile("Sound\\Creature\\LichKing\\EH_LichKing_Irritated1.ogg", "Dialog")		-- Remember who owns your soul, Death Knight!
PlaySoundFile("Sound\\Creature\\LichKing\\EH_LichKing_Greeting5.ogg", "Dialog")			-- Bow.. to your master.
PlaySoundFile("Sound\\Creature\\LichKing\\EH_LichKing_Greeting4.ogg", "Dialog")			-- All life... must end.
PlaySoundFile("Sound\\Creature\\LichKing\\EH_LichKing_Greeting2.ogg", "Dialog")			-- Your will... is not your own.
PlaySoundFile("Sound\\Creature\\Lichking\\Eh_lichking_chapter1whisper01.ogg", "Dialog")	-- No Mercy...
PlaySoundFile("Sound\\Creature\\Lichking\\Eh_lichking_chapter1whisper02.ogg", "Dialog")	-- Kill them all!
PlaySoundFile("Sound\\Creature\\Lichking\\Eh_lichking_chapter1whisper03.ogg", "Dialog")	-- Mercy is for the weak.
PlaySoundFile("Sound\\Creature\\Lichking\\Eh_lichking_chapter1whisper04.ogg", "Dialog")	-- End it.
PlaySoundFile("Sound\\Creature\\Lichking\\Eh_lichking_chapter1whisper05.ogg", "Dialog")	-- Finish it.
PlaySoundFile("Sound\\Creature\\Lichking\\Eh_lichking_chapter1whisper06.ogg", "Dialog")	-- No survivors...
PlaySoundFile("Sound\\Creature\\Lichking\\Eh_lichking_chapter1whisper07.ogg", "Dialog")	-- Kill of be killed.
PlaySoundFile("Sound\\Creature\\Lichking\\Eh_lichking_chapter1whisper08.ogg", "Dialog")	-- Do not hesitate.
PlaySoundFile("Sound\\Creature\\Lichking\\Eh_lichking_chapter1whisper09.ogg", "Dialog")	-- Harness your rage and focus.
PlaySoundFile("Sound\\Creature\\Lichking\\Eh_lichking_chapter1whisper10.ogg", "Dialog")	-- Strike it down.
PlaySoundFile("Sound\\Creature\\Lichking\\Eh_lichking_chapter1whisper11.ogg", "Dialog")	-- Suffering to the conquered. (By the way, a reference to the latin phrase "Vae victus")
PlaySoundFile("Sound\\Creature\\Lichking\\Eh_lichking_chapter1whisper12.ogg", "Dialog")	-- Show it the meaning of terror.
PlaySoundFile("Sound\\Creature\\Lichking\\Eh_lichking_chapter1whisper13.ogg", "Dialog")	-- End its miserable life.
PlaySoundFile("Sound\\Creature\\Lichking\\Eh_lichking_chapter1whisper14.ogg", "Dialog")	-- Give in to the darkness, Death Knight.
PlaySoundFile("Sound\\Creature\\Lichking\\Eh_lichking_chapter1whisper15.ogg", "Dialog")	-- Do you think it would hesitate to kill you? A monster like you?
PlaySoundFile("Sound\\Creature\\Lichking\\Eh_lichking_chapter1whisper16.ogg", "Dialog")	-- Living or dead, you will serve me...

PlaySoundFile("Sound\\Creature\\LichKing\\EH_LichKing_Chapter3Shout03.ogg", "Dialog")		-- This is the end.
]]
