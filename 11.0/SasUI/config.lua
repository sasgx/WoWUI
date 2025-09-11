	--get the addon namespace
	local addon, ns = ...

	--object container
	local cfg = {}
	ns.cfg = cfg
	
	-- art\cp_bars.lua
	cfg.cp_bars = {
		enable = false,
	}
	
	-- units\bars.lua
	cfg.bars = {
		enable = true,
		hide = {
			BagsBar = true,
		},		
		mouseover = {
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
	
	-- units\player.lua
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
		resource = {
			enabled = false,
			combatFade = true,
			move = {
				enabled = false,
				af = "TargetFrame",
				a1 = "BOTTOM",
				a2 = "BOTTOM",
				x = 0,
				y = 0,
			},
		},
	}
	
	-- units\target.lua
	cfg.target = {
		enable = false,
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
	
	-- units\party.lua
	cfg.party = {
		enable = false,
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
	
	-- blizz.lua
	cfg.blizz = {
		enable = true,
	}
	
	-- PaintUI.lua
	cfg.paint = {
		enable = true,
		ClassColored = true,
	},