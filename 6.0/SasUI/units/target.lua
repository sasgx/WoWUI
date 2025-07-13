	
	-----------------------------
	-- INIT
	-----------------------------

	--get the addon namespace
	local addon, ns = ...
	local gcfg = ns.cfg
	--get some values from the namespace
	local cfg = gcfg.units.target
	
	local function Target_Update()
		TargetFrame:ClearAllPoints()
		TargetFrame:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x, cfg.pos.y)
		TargetFrame:SetScale(cfg.scale)
		if cfg.combat.show then
			TargetFrame:SetAlpha(cfg.combat.fadeOut)
		else
			TargetFrame:SetAlpha(1)
		end
		TargetFrame:SetUserPlaced(true) -- Entering Vehicle no longer moves the frame 
	end
	local f = CreateFrame("Frame", nil, UIParent)
	f:RegisterEvent("PLAYER_REGEN_ENABLED")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", Target_Update)
	
	if cfg.combat.show then
		local function TargetIn_Update()
			TargetFrame:SetAlpha(cfg.combat.fadeIn)
		end
		local f = CreateFrame("Frame", nil, UIParent)
		f:RegisterEvent("PLAYER_REGEN_DISABLED")
		f:SetScript("OnEvent", TargetIn_Update)	
	end