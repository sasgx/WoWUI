	
	-----------------------------
	-- INIT
	-----------------------------

	--get the addon namespace
	local addon, ns = ...
	local gcfg = ns.cfg
	--get some values from the namespace
	local cfg = gcfg.units.expbar

	if not cfg.show then return end
	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "ExpBar", UIParent, "SecureHandlerStateTemplate")
	frame:SetSize(512,36)
	frame:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x, cfg.pos.y)
	frame:SetScale(cfg.scale)

	--move the buttons into position and reparent them
	MainMenuExpBar:SetParent(frame)
	MainMenuExpBar:EnableMouse(true)
	MainMenuExpBar:ClearAllPoints()
	MainMenuExpBar:SetPoint("CENTER")
	MainMenuExpBar.ignoreFramePositionManager = true
