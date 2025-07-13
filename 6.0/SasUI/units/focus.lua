		
	-----------------------------
	-- INIT
	-----------------------------

	--get the addon namespace
	local addon, ns = ...
	local gcfg = ns.cfg
	--get some values from the namespace
	local cfg = gcfg.units.focus
	
	local function Focus_Update()
		FocusFrame:ClearAllPoints()
		FocusFrame:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x, cfg.pos.y)
		FocusFrame:SetScale(cfg.scale)
		if cfg.combat.show then
			FocusFrame:SetAlpha(cfg.combat.fadeOut)
		else
			FocusFrame:SetAlpha(1)
		end
	end
	local f = CreateFrame("Frame", nil, UIParent)
	f:RegisterEvent("PLAYER_REGEN_ENABLED")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", Focus_Update)
	
	if cfg.combat.show then
		local function FocusIn_Update()
			FocusFrame:SetAlpha(cfg.combat.fadeIn)
		end
		local f = CreateFrame("Frame", nil, UIParent)
		f:RegisterEvent("PLAYER_REGEN_DISABLED")
		f:SetScript("OnEvent", FocusIn_Update)	
	end