	--get the addon namespace
	local addon, ns = ...

	--object container
	local cfg = {}
	ns.cfg = cfg
	
	-- ConsolePort Bars
	cfg.cp_bars = {
		enable = true,
		petRing = {
			fadeIn = 1,
			fadeOut = 0,
			combatFade = true,
		},
	}
	-- Blizzard Bars
	cfg.bars = {
		enable = true,
		hide = {
			BagsBar = true,
		},		
		mouseover = {
			-- BagsBar = {
				-- fadeIn = 1,
				-- fadeOut = 0,
			-- },
			xpacButton = {
				fadeIn = 1,
				fadeOut = 0,
			},
			bar1 = {
				fadeIn = 1,
				fadeOut = 0,
			},
			bar2 = {
				fadeIn = 1,
				fadeOut = 0,
			},
			bar3 = {
				fadeIn = 1,
				fadeOut = 0,
			},
			bar4 = {
				fadeIn = 1,
				fadeOut = 0,
			},
			bar5 = {
				fadeIn = 0,
				fadeOut = 0,
			},
			bar6 = {
				fadeIn = 1,
				fadeOut = 0,
			},
			bar7 = {
				fadeIn = 1,
				fadeOut = 0,
			},
			bar8 = {
				fadeIn = 1,
				fadeOut = 0,
			},
			petBar = {
				fadeIn = 0,
				fadeOut = 0,			
			},
		}
	}
	
	-- Blizzard PlayerFrame
	cfg.player = {
		enable = true,
		fadeIn = 1,
		fadeOut = 0,
		combatFade = false,
		move = {
			enabled = false,
			af = UIParent,
			a1 = "BOTTOM",
			a2 = "BOTTOM",
			x = -220,
			y = 180,		
		},
		pet = {
			fadeIn = 0,
			fadeOut = 0,
			combatFade = false,
		},
	}
	
	-- Blizzard TargetFrame
	cfg.target = {
		enable = true,
		fadeIn = 1,
		fadeOut = 0,
		combatFade = false,
		move = {
			enabled = false,
			af = "PlayerFrame",
			a1 = "LEFT",
			a2 = "RIGHT",
			x = 350,
			y = 0,		
		},
	}
	
	-- Blizzard PartyFrame
	cfg.party = {
		enable = true,
		move = {
			enabled = false,
			af = UIParent,
			a1 = "BOTTOM",
			a2 = "BOTTOM",
			x = 0,
			y = 200,
		},
		invert = false,
	}
	
	-- Blizzard Frames ( Character Menu )
	cfg.blizz = {
		enable = true,
	}