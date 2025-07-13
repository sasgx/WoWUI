
	-----------------------------
	-- INIT
	-----------------------------

	--get the addon namespace
	local addon, ns = ...
	local gcfg = ns.cfg
	--get some values from the namespace
	local cfg = gcfg.units.castbar

	if not cfg.show then return end
	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "CastBar", UIParent, "SecureHandlerStateTemplate")
	frame:SetSize(36,36)
	frame:SetPoint(cfg.pos.a1, cfg.pos.af, cfg.pos.a2, cfg.pos.x, cfg.pos.y)
	frame:SetScale(cfg.scale)

	--move the buttons into position and reparent them
	CastingBarFrame:SetParent(frame)
	CastingBarFrame:EnableMouse(false)
	CastingBarFrame:ClearAllPoints()
	CastingBarFrame:SetPoint("CENTER")
	CastingBarFrame.ignoreFramePositionManager = true
	
	CastingBarFrame.timer = CastingBarFrame:CreateFontString(nil);
	CastingBarFrame.timer:SetFont(STANDARD_TEXT_FONT,12,"OUTLINE");
	CastingBarFrame.timer:SetPoint("BOTTOM", CastingBarFrame, "TOP", 0, 0);
	CastingBarFrame.update = .1;

	hooksecurefunc("CastingBarFrame_OnUpdate", function(self, elapsed)
			if not self.timer then return end
			if self.update and self.update < elapsed then
					if self.casting then
							self.timer:SetText(format("%2.1f/%1.1f", max(self.maxValue - self.value, 0), self.maxValue))
					elseif self.channeling then
							self.timer:SetText(format("%.1f", max(self.value, 0)))
					else
							self.timer:SetText("")
					end
					self.update = .1
			else
					self.update = self.update - elapsed
			end
	end)
