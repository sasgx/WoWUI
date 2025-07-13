	-- art/target.lua
	local addon, ns = ...

	-- Get config from namespace
	local cfg = ns.cfg.target

	-- Exit if addon is disabled in config
	if not cfg.enable then return end

	-- Create a frame
	local f = CreateFrame("Frame")

	-- Function to apply mouseover effect based on target state
	local function ApplyMouseover()
		local fadeIn = cfg.fadeIn or 1
		local fadeOut = UnitIsDeadOrGhost("target") and 1 or (cfg.fadeOut or 0.2)
		ns.SasUI.Mouseover("TargetFrame", fadeIn, fadeOut)
	end
	
	local function MoveTarget()
		ns.SasUI.Move("TargetFrame", cfg.move.a1, cfg.move.af, cfg.move.a2, cfg.move.x, cfg.move.y) 
	end
	
	-- Register events
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:RegisterEvent("PLAYER_TARGET_CHANGED")
	f:RegisterEvent("UNIT_HEALTH")

	-- Set up event handler
	f:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_ENTERING_WORLD" then
			if cfg.move and cfg.move.enabled then
				MoveTarget()
			end
			ApplyMouseover()
		elseif event == "PLAYER_TARGET_CHANGED" then
			ApplyMouseover()
		elseif event == "UNIT_HEALTH" and select(1, ...) == "target" then
			ApplyMouseover()
		end
	end)