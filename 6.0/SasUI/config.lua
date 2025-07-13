	--get the addon namespace
	local addon, ns = ...

	--object container
	local cfg = {}
	ns.cfg = cfg
	
	-----------------------------
	-- UnitFrames
	-----------------------------

	cfg.units = {
		player = {
			show = true,
			pos = { a1 = "CENTER", a2 = "CENTER", af = UIParent, x = -262, y = -190},
			scale = 1.15, -- 1.0 = 100%
			combat = {
				show = true,
				fadeIn = 1,
				fadeOut = 0.4,
			},
		},
		target = {
			pos = { a1 = "CENTER", a2 = "CENTER", af = UIParent, x = 262, y = -190},
			scale = 1.15, -- 1.0 = 100% 
			combat = {
				show = false,
				fadeIn = 1,
				fadeOut = 0.2,
			},
		},
		focus = {
			pos = { a1 = "TOPRIGHT", a2 = "TOPRIGHT", af = TargetFrame, x = 175, y = 100},
			scale = 1.15, -- 1.0 = 100% 
			combat = {
				show = true,
				fadeIn = 1,
				fadeOut = 0.2,
			},
		},
		castbar = { --player castbar
			show = true,
			pos = { a1 = "CENTER", a2 = "CENTER", af = UIParent, x = -1, y = -270 },
			scale = 1,
		},
		expbar = { --experience
			show = true,
			pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = UIParent, x = 0, y = -14 },
			scale = 0.82,
		},
		repbar = { --reputation ** position is ignored, no idea why. code for the bar is located in SasUI/Units/repbar.lua and bars.lua **
			show = true,
			pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = UIParent, x = 0, y = 10 },
			scale = 0.82,
		},
	}
	
	-----------------------------
	-- rActionBarStyler
	-----------------------------
	
	--use "/rabs" to see the command list
	cfg.bars = {
		--BAR 1
		bar1 = {
			enable          = true, --enable module
			uselayout2x6    = false,
			scale           = 0.92,
			padding         = 2, --frame padding
			buttons         = {
				size            = 26,
				margin          = 5,
			},
			pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = UIParent, x = -1, y = 222 },
			userplaced      = {
				enable          = true,
			},
			mouseover       = {
				enable          = true,
				fadeIn          = {time = 0.4, alpha = 1},
				fadeOut         = {time = 0.3, alpha = 0.4},
			},
			combat          = { --fade the bar in/out in combat/out of combat
				enable          = true,
				fadeIn          = {time = 0.4, alpha = 1},
				fadeOut         = {time = 0.3, alpha = 0.4},
			},
		},
		--OVERRIDE BAR (vehicle ui)
		overridebar = { --the new vehicle and override bar
			enable          = true, --enable module
			scale           = 0.82,
			padding         = 2, --frame padding
			buttons         = {
				size            = 57,
				margin          = 5,
			},
			pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = UIParent, x = -1, y = 222 },
			userplaced      = {
				enable          = true,
			},
			mouseover       = {
				enable          = false,
				fadeIn          = {time = 0.4, alpha = 1},
				fadeOut         = {time = 0.3, alpha = 0.2},
			},
			combat          = { --fade the bar in/out in combat/out of combat
				enable          = false,
				fadeIn          = {time = 0.4, alpha = 1},
				fadeOut         = {time = 0.3, alpha = 0.2},
			},
		},
		--BAR 2
		bar2 = {
			enable          = true, --enable module
			uselayout2x6    = false,
			scale           = 0.82,
			padding         = 2, --frame padding
			buttons         = {
				size            = 26,
				margin          = 5,
			},
			pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = UIParent, x = -1, y = 284 },
			userplaced      = {
				enable          = true,
			},
			mouseover       = {
				enable          = true,
				fadeIn          = {time = 0.4, alpha = 1},
				fadeOut         = {time = 0.3, alpha = 0},
			},
			combat          = { --fade the bar in/out in combat/out of combat
				enable          = true,
				fadeIn          = {time = 0.4, alpha = 0.6},
				fadeOut         = {time = 0.3, alpha = 0},
			},
		},
		--BAR 3
		bar3 = {
			enable          = true, --enable module
			scale           = 0.82,
			padding         = 2, --frame padding
			buttons         = {
				size            = 26,
				margin          = 5,
			},
			pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = UIParent, x = -1, y = 213 },
			userplaced      = {
				enable          = true,
			},
			mouseover       = {
				enable          = true,
				fadeIn          = {time = 0.4, alpha = 1},
				fadeOut         = {time = 0.3, alpha = 0},
			},
			combat          = { --fade the bar in/out in combat/out of combat
				enable          = true,
				fadeIn          = {time = 0.4, alpha = 0.4},
				fadeOut         = {time = 0.3, alpha = 0},
			},
		},
		--BAR 4
		bar4 = {
			enable          = true, --enable module
			combineBar4AndBar5  = true, --by choosing true both bar 4 and 5 will react to the same hover effect, thus true/false at the same time, settings for bar5 will be ignored
			scale           = 0.82,
			padding         = 10, --frame padding
			buttons         = {
				size            = 26,
				margin          = 5,
			},
			pos             = { a1 = "RIGHT", a2 = "RIGHT", af = UIParent, x = -0, y = 0 },
			userplaced      = {
				enable          = true,
			},
			mouseover       = {
				enable          = true,
				fadeIn          = {time = 0.4, alpha = 1},
				fadeOut         = {time = 0.3, alpha = 0},
			},
			combat          = { --fade the bar in/out in combat/out of combat
				enable          = false,
				fadeIn          = {time = 0.4, alpha = 0.2},
				fadeOut         = {time = 0.3, alpha = 0},
			},
		},
		--BAR 5
		bar5 = {
			enable          = true, --enable module
			scale           = 0.82,
			padding         = 10, --frame padding
			buttons         = {
				size            = 26,
				margin          = 5,
			},
			pos             = { a1 = "RIGHT", a2 = "RIGHT", af = UIParent, x = -36, y = 0 },
			userplaced      = {
				enable          = true,
			},
			mouseover       = {
				enable          = true,
				fadeIn          = {time = 0.4, alpha = 1},
				fadeOut         = {time = 0.3, alpha = 0.2},
			},
			combat          = { --fade the bar in/out in combat/out of combat
				enable          = false,
				fadeIn          = {time = 0.4, alpha = 1},
				fadeOut         = {time = 0.3, alpha = 0.2},
			},
		},
		--PETBAR
		petbar = {
			enable          = true, --enable module
			show            = true, --true/false
			scale           = 0.82,
			padding         = 2, --frame padding
			buttons         = {
				size            = 26,
				margin          = 5,
			},
			pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = UIParent, x = -1, y = 182 },
			userplaced      = {
				enable          = true,
			},
			mouseover       = {
				enable          = true,
				fadeIn          = {time = 0.4, alpha = 1},
				fadeOut         = {time = 0.3, alpha = 0},
			},
			combat          = { --fade the bar in/out in combat/out of combat
				enable          = true,
				fadeIn          = {time = 0.4, alpha = 0.4},
				fadeOut         = {time = 0.3, alpha = 0},
			},
		},
		--STANCE- + POSSESSBAR
		stancebar = {
			enable          = true, --enable module
			show            = true, --true/false
			scale           = 0.82,
			padding         = 2, --frame padding
			buttons         = {
				size            = 26,
				margin          = 5,
			},
			pos             = { a1 = "TOP", a2 = "TOPRIGHT", af = PlayerFrame, x = -20, y = 5 },
			userplaced      = {
				enable          = true,
			},
			mouseover       = {
				enable          = true,
				fadeIn          = {time = 0.4, alpha = 1},
				fadeOut         = {time = 0.3, alpha = 0},
			},
			combat          = { --fade the bar in/out in combat/out of combat
				enable          = false,
				fadeIn          = {time = 0.4, alpha = 1},
				fadeOut         = {time = 0.3, alpha = 0.2},
			},
		},
		--EXTRABAR
		extrabar = {
			enable          = true, --enable module
			scale           = 0.82,
			padding         = 10, --frame padding
			buttons         = {
				size            = 36,
				margin          = 5,
			},
			pos             = { a1 = "CENTER", a2 = "CENTER", af = UIParent, x = -7, y = -302 },
			userplaced      = {
				enable          = true,
			},
			mouseover       = {
				enable          = false,
				fadeIn          = {time = 0.4, alpha = 1},
				fadeOut         = {time = 0.3, alpha = 0.2},
			},
		},
		--VEHICLE EXIT (no vehicleui)
		leave_vehicle = {
			enable          = true, --enable module
			scale           = 0.82,
			padding         = 10, --frame padding
			buttons         = {
				size            = 26,
				margin          = 5,
			},
			pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = UIParent, x = -3, y = 119 },
			userplaced      = {
				enable          = true,
			},
			mouseover       = {
				enable          = false,
				fadeIn          = {time = 0.4, alpha = 1},
				fadeOut         = {time = 0.3, alpha = 0.2},
			},
		},
		--MICROMENU
		micromenu = {
			enable          = true, --enable module
			show            = true, --true/false
			scale           = 0.82,
			padding         = 10, --frame padding
			pos             = { a1 = "TOPLEFT", a2 = "TOPLEFT", af = UIParent, x = 31, y = 25 },
			userplaced      = {
				enable          = true,
			},
			mouseover       = {
				enable          = true,
				fadeIn          = {time = 0.4, alpha = 1},
				fadeOut         = {time = 0.3, alpha = 0},
			},
		},
		--BAGS
		bags = {
			enable          = true, --enable module
			show            = true, --true/false
			scale           = 0.82,
			padding         = 15, --frame padding
			pos             = { a1 = "BOTTOMRIGHT", a2 = "BOTTOMRIGHT", af = UIParent, x = -0, y = 193 },
			userplaced      = {
				enable          = true,
			},
			mouseover       = {
				enable          = true,
				fadeIn          = {time = 0.4, alpha = 1},
				fadeOut         = {time = 0.3, alpha = 0},
			},
		},
	}
	
	-----------------------------
	-- rActionButtonStyler 
	-----------------------------

	cfg.textures = {
		normal            = "Interface\\AddOns\\SasUI\\media\\gloss",
		flash             = "Interface\\AddOns\\SasUI\\media\\flash",
		hover             = "Interface\\AddOns\\SasUI\\media\\hover",
		pushed            = "Interface\\AddOns\\SasUI\\media\\pushed",
		checked           = "Interface\\AddOns\\SasUI\\media\\checked",
		equipped          = "Interface\\AddOns\\SasUI\\media\\gloss_grey",
		buttonback        = "Interface\\AddOns\\SasUI\\media\\button_background",
		buttonbackflat    = "Interface\\AddOns\\SasUI\\media\\button_background_flat",
		outer_shadow      = "Interface\\AddOns\\SasUI\\media\\outer_shadow",
	}

	cfg.background = {
		showbg            = true,  --show an background image?
		showshadow        = true,   --show an outer shadow?
		useflatbackground = false,  --true uses plain flat color instead
		backgroundcolor   = { r = 0.2, g = 0.2, b = 0.2, a = 0.3},
		shadowcolor       = { r = 0, g = 0, b = 0, a = 0.9},
		classcolored      = false,
		inset             = 5,
	}

	cfg.color = {
		normal            = { r = 0.37, g = 0.3, b = 0.3, },
		equipped          = { r = 0.1, g = 0.5, b = 0.1, },
		classcolored      = false,
	}

	cfg.hotkeys = {
		show            = true,
		fontsize        = 12,
		pos1             = { a1 = "TOPRIGHT", x = 0, y = 0 },
		pos2             = { a1 = "TOPLEFT", x = 0, y = 0 }, --important! two points are needed to make the hotkeyname be inside of the button
	}

	cfg.macroname = {
		show            = true,
		fontsize        = 12,
		pos1             = { a1 = "BOTTOMLEFT", x = 0, y = 0 },
		pos2             = { a1 = "BOTTOMRIGHT", x = 0, y = 0 }, --important! two points are needed to make the macroname be inside of the button
	}

	cfg.itemcount = {
		show            = true,
		fontsize        = 12,
		pos1             = { a1 = "BOTTOMRIGHT", x = 0, y = 0 },
	}

	cfg.cooldown = {
		spacing         = 0,
	}

	cfg.font = STANDARD_TEXT_FONT
--[[	
	-----------------------------
	-- rBuffFrameStyler cannot add the styler has mising icons
	-----------------------------
	
	--adjust the oneletter abbrev?
	cfg.adjustOneletterAbbrev = true

	--scale of the consolidated tooltip
	cfg.consolidatedTooltipScale = 1.2

	--combine buff and debuff frame - should buffs and debuffs be displayed in one single frame?
	--if you disable this it is intended that you unlock the buff and debuffs and move them apart!
	cfg.combineBuffsAndDebuffs = true

	--buff frame settings
	cfg.buffFrame = {
		pos             = { a1 = "TOPRIGHT", af = "Minimap", a2 = "TOPLEFT", x = -35, y = 0 },
		gap             = 10, --gap between buff and debuff rows
		userplaced      = true, --want to place the bar somewhere else?
		rowSpacing      = 10,
		colSpacing      = 7,
		buttonsPerRow   = 10,
		button = {
		size              = 28,
		},
		icon = {
			padding           = -2,
		},
		border = {
			texture           = "Interface\\AddOns\SasUI\\media\\gloss",
			color             = { r = 0.4, g = 0.35, b = 0.35, },
			classcolored      = true,
		},
		background = {
			show              = true,   --show backdrop
			edgeFile          = "Interface\\AddOns\SasUI\\media\\outer_shadow",
			color             = { r = 0, g = 0, b = 0, a = 0.9},
			classcolored      = true,
			inset             = 6,
			padding           = 4,
		},
		duration = {
			font              = STANDARD_TEXT_FONT,
			size              = 11,
			pos               = { a1 = "BOTTOM", x = 0, y = 0 },
		},
		count = {
			font              = STANDARD_TEXT_FONT,
			size              = 11,
			pos               = { a1 = "TOPRIGHT", x = 0, y = 0 },
		},
	}

	--debuff frame settings
	cfg.debuffFrame = {
		pos             = { a1 = "TOPRIGHT", af = "rBFS_BuffDragFrame", a2 = "BOTTOMRIGHT", x = 0, y = -10 },
		userplaced      = true, --want to place the bar somewhere else?
		rowSpacing      = 10,
		colSpacing      = 7,
		buttonsPerRow   = 6,
		button = {
		size              = 40,
		},
		icon = {
			padding           = -2,
		},
		border = {
			texture           = "Interface\\AddOns\SasUI\\media\\gloss",
		},
		background = {
			show              = true,   --show backdrop
			edgeFile          = "Interface\\AddOns\SasUI\\media\\outer_shadow",
			color             = { r = 0, g = 0, b = 0, a = 0.9},
			classcolored      = false,
			inset             = 6,
			padding           = 4,
		},
		duration = {
			font              = STANDARD_TEXT_FONT,
			size              = 13,
			pos               = { a1 = "BOTTOM", x = 0, y = 0 },
		},
		count = {
			font              = STANDARD_TEXT_FONT,
			size              = 12,
			pos               = { a1 = "TOPRIGHT", x = 0, y = 0 },
		},
	}
--]]	
	-----------------------------
	-- rChat
	-----------------------------
	
	cfg.hideChatTabBackgrounds  = true
	cfg.selectedTabColor        = {1,0.75,0}
	cfg.selectedTabAlpha        = 1
	cfg.notSelectedTabColor     = {0.5,0.5,0.5}
	cfg.notSelectedTabAlpha     = 0.3
	
	-----------------------------
	-- rInfostrings
	-----------------------------
	
	cfg.frame = {
		scale           = 0.95,
		pos             = { a1 = "TOP", af = Minimap, a2 = "BOTTOM", x = 0, y = -15 },
		userplaced      = true, --want to place the bar somewhere else?
	}

	cfg.showXpRep     = false --show xp or reputation as string
	cfg.showMail      = false --show mail as text
	
	-----------------------------
	-- rMinimap
	-----------------------------
	
	--Garrison Button
	GarrisonLandingPageMinimapButton:ClearAllPoints()
	GarrisonLandingPageMinimapButton:SetPoint("BOTTOMLEFT", 75, 45)
	GarrisonLandingPageMinimapButton:SetScale(0.65)
	
	cfg.mapcluster = {
		pos             = { a1 = "TOPRIGHT", af = UIParent, a2 = "TOPRIGHT", x = 0, y = 0 },
		userplaced      = true, --want to place the bar somewhere else?
		scale           = 0.82,
	}

	cfg.map = {
		pos             = { a1 = "TOP", x = 10, y = -20 }, --set the position of the minimap inside the minimap cluster
	}

	cfg.clock = { --the clock
		pos             = { a1 = "BOTTOM", af = Minimap, a2 = "BOTTOM", x = 0, y = 0 },
		font            = { size = 12, family = STANDARD_TEXT_FONT, outline = "THINOUTLINE", }
	}

	cfg.calendar = { --calendar button
		size            = 16,
		pos             = { a1 = "CENTER", af = Minimap, a2 = "CENTER", x = 52, y = 52 },
		font            = { size = 12, family = STANDARD_TEXT_FONT, outline = "THINOUTLINE", }
	}

	cfg.mail = {
		size            = 16,
		pos             = { a1 = "CENTER", af = Minimap, a2 = "CENTER", x = 75, y = 0 },
	}

	cfg.tracking = {
		size            = 16,
		pos             = { a1 = "CENTER", af = Minimap, a2 = "CENTER", x = 68, y = 28 },
	}

	cfg.queue = { --queue button
		size            = 16,
		pos             = { a1 = "CENTER", af = Minimap, a2 = "CENTER", x = -52, y = -52 },
	}
	
	-----------------------------
	-- xCT
	-----------------------------
	
	ns.config={
	---------------------------------------------------------------------------------
	-- use ["option"] = true/false, to set options.
	-- options
		-- blizz damage options.
		["blizzheadnumbers"] = true,	-- use blizzard damage/healing output (above mob/player head)
		["damagestyle"] = true,		-- change default damage/healing font above mobs/player heads. you need to restart WoW to see changes! has no effect if blizzheadnumbers = false
		-- xCT outgoing damage/healing options
		["damage"] = true,		-- show outgoing damage in it's own frame
		["healing"] = true,		-- show outgoing healing in it's own frame
		["showhots"] = true,		-- show periodic healing effects in xCT healing frame.
		["damagecolor"] = true,		-- display damage numbers depending on school of magic, see http://www.wowwiki.com/API_COMBAT_LOG_EVENT
		["critprefix"] = "|cffFF0000*|r",	-- symbol that will be added before amount, if you deal critical strike/heal. leave "" for empty. default is red *
		["critpostfix"] = "|cffFF0000*|r",	-- postfix symbol, "" for empty.
		["icons"] = true,		-- show outgoing damage icons
		["iconsize"] = 22,		-- icon size of spells in outgoing damage frame, also has effect on dmg font size if it's set to "auto"
		["petdamage"] = true,		-- show your pet damage.
		["dotdamage"] = true,		-- show damage from your dots. someone asked an option to disable lol.
		["treshold"] = 1,		-- minimum damage to show in outgoing damage frame
		["healtreshold"] = 1,		-- minimum healing to show in incoming/outgoing healing messages.

		-- appearence
		["font"] = "Interface\\AddOns\\SasUI\\media\\fonts\\HOOGE.TTF",	-- "Fonts\\ARIALN.ttf" is default WoW font.
		["fontsize"] = 12,
		["fontstyle"] = "OUTLINE",	-- valid options are "OUTLINE", "MONOCHROME", "THICKOUTLINE", "OUTLINE,MONOCHROME", "THICKOUTLINE,MONOCHROME"
		["damagefont"] = "Interface\\AddOns\\SasUI\\media\\fonts\\HOOGE.TTF",	 -- "Fonts\\FRIZQT__.ttf" is default WoW damage font
		["damagefontsize"] = "auto",	-- size of xCT damage font. use "auto" to set it automatically depending on icon size, or use own value, 16 for example. if it's set to number value icons will change size.
		["timevisible"] = 3, 		-- time (seconds) a single message will be visible. 3 is a good value.
		["scrollable"] = false,		-- allows you to scroll frame lines with mousewheel.
		["maxlines"] = 64,		-- max lines to keep in scrollable mode. more lines=more memory. nom nom nom.

		-- justify messages in frames, valid values are "RIGHT" "LEFT" "CENTER"
		["justify_1"] = "LEFT",		-- incoming damage justify
		["justify_2"] = "RIGHT",	-- incoming healing justify
		["justify_3"] = "CENTER",	-- various messages justify (mana, rage, auras, etc)
		["justify_4"] = "RIGHT",	-- outgoing damage/healing justify

		-- class modules and goodies
		["stopvespam"] = false,		-- automaticly turns off healing spam for priests in shadowform. HIDE THOSE GREEN NUMBERS PLX!
		["dkrunes"] = true,		-- show deatchknight rune recharge
		["mergeaoespam"] = true,	-- merges multiple aoe spam into single message, can be useful for dots too.
		["mergeaoespamtime"] = 3,	-- time in seconds aoe spell will be merged into single message. minimum is 1.
		["killingblow"] = true,		-- tells you about your killingblows (works only with ["damage"] = true,)
		["dispel"] = true,		-- tells you about your dispels (works only with ["damage"] = true,)
		["interrupt"] = true,		-- tells you about your interrupts (works only with ["damage"] = true,)
	}

	
--[[
	castbar = {
		show = true,
		hideDefault = true, --if you hide the oUF_Diablo castbar, should the Blizzard castbar be shown?
		latency = true,
		texture = "Interface\\AddOns\\SasUI\\media\\statusbar256_2",
		scale = 1/0.82, --divide 1 by current unit scale if you want to prevent scaling of the castbar based on unit scale
		color = {
			bar = { r = 1, g = 0.7, b = 0, a = 1, },
			bg = { r = 0.1, g = 0.1, b = 0.1, a = 0.7, },
		},
		pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = UIParent, x = 0, y = 180.5 },
	},
--]]