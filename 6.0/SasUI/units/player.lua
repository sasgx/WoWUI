	
	-----------------------------
	-- INIT
	-----------------------------

	--get the addon namespace
	local addon, ns = ...
	local gcfg = ns.cfg
	--get some values from the namespace
	local cfg = gcfg.units.player
	
	local function Player_Update()
		PlayerFrame:ClearAllPoints()
		PlayerFrame:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x, cfg.pos.y)
		PlayerFrame:SetScale(cfg.scale)
		if cfg.combat.show then
			PlayerFrame:SetAlpha(cfg.combat.fadeOut)
		else
			PlayerFrame:SetAlpha(1)
		end
		PlayerFrame:SetUserPlaced(true) -- Entering Vehicle no longer moves the frame 
	end
	local f = CreateFrame("Frame", nil, UIParent)
	f:RegisterEvent("PLAYER_REGEN_ENABLED")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", Player_Update)
	
	if cfg.combat.show then
		local function PlayerIn_Update()
			PlayerFrame:SetAlpha(cfg.combat.fadeIn)
		end
		local f = CreateFrame("Frame", nil, UIParent)
		f:RegisterEvent("PLAYER_REGEN_DISABLED")
		f:SetScript("OnEvent", PlayerIn_Update)	
	end