	-- rTooltip: core
	-- zork, 2018 (updated for WoW 11.1.7 by Grok, 2025)

	-----------------------------
	-- Variables
	-----------------------------

	local A, L = ...

	local unpack, type = unpack, type
	local RAID_CLASS_COLORS, FACTION_BAR_COLORS, ICON_LIST = RAID_CLASS_COLORS, FACTION_BAR_COLORS, ICON_LIST
	local GameTooltip, GameTooltipStatusBar = GameTooltip, GameTooltip.StatusBar
	local classColorHex, factionColorHex = {}, {}

	-----------------------------
	-- Config
	-----------------------------

	local cfg = {}
	cfg.textColor = {0.4, 0.4, 0.4}
	cfg.bossColor = {1, 0, 0}
	cfg.eliteColor = {1, 0, 0.5}
	cfg.rareeliteColor = {1, 0.5, 0}
	cfg.rareColor = {1, 0.5, 0}
	cfg.levelColor = {0.8, 0.8, 0.5}
	cfg.deadColor = {0.5, 0.5, 0.5}
	cfg.targetColor = {1, 0.5, 0.5}
	cfg.guildColor = {1, 0, 1}
	cfg.afkColor = {0, 1, 1}
	cfg.scale = 0.95
	cfg.fontFamily = "Interface\\AddOns\\SasUI\\media\\font\\FiraSansCondensed-Black.ttf"
	-- cfg.fontFamily = GameFontNormal:GetFont() or "Fonts\\FRIZQT__.TTF" -- Fallback font
	cfg.backdrop = {
		bgFile = "Interface\\Buttons\\WHITE8x8",
		bgColor = {0.08, 0.08, 0.1, 0.92},
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		borderColor = {0.1, 0.1, 0.1, 0.6},
		itemBorderColorAlpha = 0.9,
		tile = false,
		tileEdge = false,
		tileSize = 16,
		edgeSize = 16,
		insets = {left = 3, right = 3, top = 3, bottom = 3}
	}

	-- Position can be a point table or an anchor string
	cfg.pos = "ANCHOR_NONE" --"ANCHOR_CURSOR"

	-----------------------------
	-- Functions
	-----------------------------

	local function GetHexColor(color)
		if color.r then
			return ("%.2x%.2x%.2x"):format(color.r * 255, color.g * 255, color.b * 255)
		else
			local r, g, b, a = unpack(color)
			return ("%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)
		end
	end

	local function GetTarget(unit)
		if UnitIsUnit(unit, "player") then
			return ("|cffff0000%s|r"):format("<YOU>")
		elseif UnitIsPlayer(unit) then
			local _, class = UnitClass(unit)
			return ("|cff%s%s|r"):format(classColorHex[class] or "ffffff", UnitName(unit) or "Unknown")
		elseif UnitReaction(unit, "player") then
			return ("|cff%s%s|r"):format(factionColorHex[UnitReaction(unit, "player")] or "ffffff", UnitName(unit) or "Unknown")
		else
			return ("|cffffffff%s|r"):format(UnitName(unit) or "Unknown")
		end
	end

	local function ApplyBackdropStyle(self)
		if self.IsEmbedded then return end
		if self.TopOverlay then self.TopOverlay:Hide() end
		if self.BottomOverlay then self.BottomOverlay:Hide() end
		-- Check current backdrop to avoid redundant updates
		local currentBackdrop = self:GetBackdrop()
		if not currentBackdrop or currentBackdrop.bgFile ~= cfg.backdrop.bgFile or currentBackdrop.edgeFile ~= cfg.backdrop.edgeFile then
			self:SetBackdrop(cfg.backdrop)
		end
		self:SetBackdropColor(unpack(cfg.backdrop.bgColor))
		local itemLink
		if TooltipUtil and TooltipUtil.GetDisplayedItem then
			itemLink = TooltipUtil.GetDisplayedItem(self)
		elseif self.GetItem then
			local _, link = self:GetItem()
			itemLink = link
		end
		if itemLink then
			local _, _, itemRarity = GetItemInfo(itemLink)
			local r, g, b = 1, 1, 1
			if itemRarity then r, g, b = GetItemQualityColor(itemRarity) end
			self:SetBackdropBorderColor(r, g, b, cfg.backdrop.itemBorderColorAlpha)
		else
			self:SetBackdropBorderColor(unpack(cfg.backdrop.borderColor))
		end
		--print("Applied backdrop to tooltip:", self:GetName() or "Unknown")
	end

	local function OnTooltipSetUnit(self)
		local unitName, unit = self:GetUnit()
		if not unit then return end

		-- Apply backdrop style
		ApplyBackdropStyle(self)

		-- Color tooltip text lines dynamically
		for i = 2, self:NumLines() do
			local line = _G["GameTooltipTextLeft" .. i]
			if line then
				line:SetTextColor(unpack(cfg.textColor))
			end
		end

		if not UnitIsPlayer(unit) then
			-- Unit is not a player
			local reaction = UnitReaction(unit, "player")
			if reaction then
				local color = FACTION_BAR_COLORS[reaction]
				if color then
					cfg.barColor = color
					GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
					_G["GameTooltipTextLeft1"]:SetTextColor(color.r, color.g, color.b)
				end
			end

			-- Color text by classification
			local unitClassification = UnitClassification(unit)
			local levelLine
			for i = 2, self:NumLines() do
				local line = _G["GameTooltipTextLeft" .. i]
				local text = line and line:GetText() or ""
				if text:match("%a%s%d") then
					levelLine = line
					break
				elseif i == 2 and text and text ~= "" then
					line:SetTextColor(unpack(cfg.guildColor)) -- NPC description
				end
			end

			if levelLine then
				local l = UnitLevel(unit)
				local color = GetCreatureDifficultyColor(l > 0 and l or 999) or cfg.levelColor
				levelLine:SetTextColor(color.r, color.g, color.b)
				--print("Colored level line for unit:", unitName, "Level:", l, "Color:", color.r, color.g, color.b)
			end

			if unitClassification == "worldboss" or UnitLevel(unit) == -1 then
				self:AppendText(" |cffff0000{B}|r")
				_G["GameTooltipTextLeft2"]:SetTextColor(unpack(cfg.bossColor))
			elseif unitClassification == "rare" then
				self:AppendText(" |cffff9900{R}|r")
			elseif unitClassification == "rareelite" then
				self:AppendText(" |cffff0000{R+}|r")
			elseif unitClassification == "elite" then
				self:AppendText(" |cffff6666{E}|r")
			end
		else
			-- Unit is a player
			local _, unitClass = UnitClass(unit)
			local color = RAID_CLASS_COLORS[unitClass] or {r = 1, g = 1, b = 1}
			cfg.barColor = color
			GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
			_G["GameTooltipTextLeft1"]:SetTextColor(color.r, color.g, color.b)

			local unitGuild = GetGuildInfo(unit)
			if unitGuild then
				_G["GameTooltipTextLeft2"]:SetText("<" .. unitGuild .. ">")
				_G["GameTooltipTextLeft2"]:SetTextColor(unpack(cfg.guildColor))
			end

			local levelLine = unitGuild and _G["GameTooltipTextLeft3"] or _G["GameTooltipTextLeft2"]
			local l = UnitLevel(unit)
			local color = GetCreatureDifficultyColor(l > 0 and l or 999) or cfg.levelColor
			levelLine:SetTextColor(color.r, color.g, color.b)
			--print("Colored level line for player:", unitName, "Level:", l, "Color:", color.r, color.g, color.b)

			if UnitIsAFK(unit) then
				self:AppendText((" |cff%s<AFK>|r"):format(cfg.afkColorHex))
			end
		end

		-- Dead check
		if UnitIsDeadOrGhost(unit) then
			_G["GameTooltipTextLeft1"]:SetTextColor(unpack(cfg.deadColor))
		end

		-- Target line
		if UnitExists(unit .. "target") then
			GameTooltip:AddDoubleLine(("|cff%s%s|r"):format(cfg.targetColorHex, "Target"), GetTarget(unit .. "target") or "Unknown")
		end
	end

	local function TooltipAddSpellID(self, spellid)
		if not spellid then return end
		self:AddDoubleLine("|cff0099ffSpellID|r", spellid)
		self:Show()
		--print("Added SpellID", spellid, "to tooltip:", self:GetName() or "Unknown", "SpellID:", spellid)
	end

	local function SetStatusBarColor(self, r, g, b)
		if not cfg.barColor then return end
		if r == cfg.barColor.r and g == cfg.barColor.g and b == cfg.barColor.b then return end
		self:SetStatusBarColor(cfg.barColor.r, cfg.barColor.g, cfg.barColor.b)
	end

	local function SetDefaultAnchor(self, parent)
		if not cfg.pos then return end
		if type(cfg.pos) == "string" then
			self:SetOwner(parent, cfg.pos)
		else
			self:SetOwner(parent, "ANCHOR_NONE")
			self:ClearAllPoints()
			self:SetPoint(unpack(cfg.pos))
		end
	end

	-----------------------------
	-- Init
	-----------------------------

	-- Ensure BackdropTemplateMixin for GameTooltip
	if not GameTooltip.SetBackdrop then
		Mixin(GameTooltip, BackdropTemplateMixin)
		GameTooltip:OnBackdropLoaded()
	end

	-- Hex class colors
	for class, color in next, RAID_CLASS_COLORS do
		classColorHex[class] = GetHexColor(color)
	end

	-- Hex reaction colors
	for i = 1, 8 do
		factionColorHex[i] = GetHexColor(FACTION_BAR_COLORS[i] or {r = 1, g = 1, b = 1})
	end

	cfg.targetColorHex = GetHexColor(cfg.targetColor)
	cfg.afkColorHex = GetHexColor(cfg.afkColor)

	-- Font setup
	if GameTooltipHeaderText then
		--print("Setting font for GameTooltipHeaderText:", cfg.fontFamily)
		GameTooltipHeaderText:SetFont(cfg.fontFamily, 14, "")
		GameTooltipHeaderText:SetShadowOffset(1, -2)
		GameTooltipHeaderText:SetShadowColor(0, 0, 0, 0.75)
	end
	if GameTooltipText then
		--print("Setting font for GameTooltipText:", cfg.fontFamily)
		GameTooltipText:SetFont(cfg.fontFamily, 12, "")
		GameTooltipText:SetShadowOffset(1, -2)
		GameTooltipText:SetShadowColor(0, 0, 0, 0.75)
	end
	if Tooltip_Small then
		--print("Setting font for Tooltip_Small:", cfg.fontFamily)
		Tooltip_Small:SetFont(cfg.fontFamily, 11, "")
		Tooltip_Small:SetShadowOffset(1, -2)
		Tooltip_Small:SetShadowColor(0, 0, 0, 0.75)
	end

	-- GameTooltip status bar
	GameTooltipStatusBar:ClearAllPoints()
	GameTooltipStatusBar:SetPoint("LEFT", 5, 0)
	GameTooltipStatusBar:SetPoint("RIGHT", -5, 0)
	GameTooltipStatusBar:SetPoint("TOP", 0, -2.5)
	GameTooltipStatusBar:SetHeight(4)
	GameTooltipStatusBar.bg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND", nil, -8)
	GameTooltipStatusBar.bg:SetAllPoints()
	GameTooltipStatusBar.bg:SetColorTexture(1, 1, 1)
	GameTooltipStatusBar.bg:SetVertexColor(0, 0, 0, 0.5)

	-- Hooks
	hooksecurefunc(GameTooltipStatusBar, "SetStatusBarColor", SetStatusBarColor)
	if cfg.pos then hooksecurefunc("GameTooltip_SetDefaultAnchor", SetDefaultAnchor) end
	GameTooltip:HookScript("OnTooltipCleared", ApplyBackdropStyle)

	-- Use TooltipDataProcessor for unit tooltips
	if TooltipDataProcessor then
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip, data)
			if tooltip == GameTooltip then
				OnTooltipSetUnit(tooltip)
			end
		end)
	else
		-- Fallback for older API
		GameTooltip:HookScript("OnShow", function(self)
			if self:GetUnit() then
				OnTooltipSetUnit(self)
			end
		end)
	end

	-- Use TooltipDataProcessor for spell tooltips
	if TooltipDataProcessor then
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, function(tooltip, data)
			if tooltip == GameTooltip then
				local spellID = data.id
				TooltipAddSpellID(tooltip, spellID)
			end
		end)
	else
		-- Fallback for older API
		GameTooltip:HookScript("OnShow", function(self)
			local _, spellID = self:GetSpell()
			if spellID then
				TooltipAddSpellID(self, spellID)
			end
		end)
	end

	-- Tooltips
	local tooltips = {
		GameTooltip, ShoppingTooltip1, ShoppingTooltip2, ItemRefTooltip,
		ItemRefShoppingTooltip1, ItemRefShoppingTooltip2, WorldMapTooltip,
		WorldMapCompareTooltip1, WorldMapCompareTooltip2, SmallTextTooltip
	}
	for _, tooltip in ipairs(tooltips) do
		if tooltip then
			-- Ensure BackdropTemplateMixin
			if not tooltip.SetBackdrop then
				Mixin(tooltip, BackdropTemplateMixin)
				tooltip:OnBackdropLoaded()
			end
			tooltip:SetScale(cfg.scale)
			if tooltip:HasScript("OnTooltipCleared") then
				tooltip:HookScript("OnTooltipCleared", ApplyBackdropStyle)
			end
		end
	end

	-- Menus
	local menus = {
		DropDownList1MenuBackdrop,
		DropDownList2MenuBackdrop,
	}
	for _, menu in ipairs(menus) do
		if menu then
			-- Ensure BackdropTemplateMixin
			if not menu.SetBackdrop then
				Mixin(menu, BackdropTemplateMixin)
				menu:OnBackdropLoaded()
			end
			menu:SetScale(cfg.scale)
		end
	end

	-- Spell ID functions for buffs and debuffs
	hooksecurefunc(GameTooltip, "SetUnitBuff", function(self, ...)
		local spellID = select(10, UnitBuff(...))
		TooltipAddSpellID(self, spellID)
	end)

	hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self, ...)
		local spellID = select(10, UnitDebuff(...))
		TooltipAddSpellID(self, spellID)
	end)

	hooksecurefunc("SetItemRef", function(link)
		local linkType, value = link:match("(%a+):(.+)")
		if linkType == "spell" then
			TooltipAddSpellID(ItemRefTooltip, value:match("([^:]+)"))
		end
	end)