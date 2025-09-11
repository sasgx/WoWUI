	--get the addon namespace
	local addon, ns = ...

	--get some values from the namespace
	local cfg = ns.cfg.paint
	
	if not cfg.enable then end
	
	-- Set the textures to be class colored
	local ClassColored = cfg.ClassColored

	rRAID_CLASS_COLORS = {
		["DEATHKNIGHT"] = { r = 0.77, g = 0.12, b = 0.23 },
		["DEMONHUNTER"] = { r = 0.64, g = 0.19, b = 0.79 },
		["DRUID"] = { r = 1.0, g = 0.49, b = 0.04 },
		["EVOKER"] = { r = 0.2, g = 0.58, b = 0.5 },
		["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45 },
		["MAGE"] = { r = 0.41, g = 0.8, b = 0.94 },
		["MONK"] = { r = 0.0, g = 1.0, b = 0.57 },
		["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73 },
		["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0 },
		["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41 },
		["SHAMAN"] = { r = 0.0, g = 0.44, b = 0.87 },
		["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79 },
		["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43 },		
	}

	local cc = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[select(2, UnitClass("player"))] or rRAID_CLASS_COLORS[select(2, UnitClass("player"))] or { r=0.5, g=0.5, b=0.5 }

	local function PaintTextures()
		local cl = ClassColored == true
		local r1, g1, b1, a1 = 1, 1, 1, 1 -- top color
		local r2, g2, b2, a2 = cl and cc.r or 0.58, cl and cc.g or 0.51, cl and cc.b or 0.79, 1 -- bottom color

		for i, v in pairs({
			-- Minimap
			MinimapCompassTexture,
			Minimap.ZoomIn:GetRegions(),
			Minimap.ZoomOut:GetRegions(),

			-- Menus
			FriendsFrame:GetRegions(),
			CharacterFrame:GetRegions(),
		}) 
		do
			if v and v:GetObjectType() == "Texture" then
				v:SetVertexColor(1, 1, 1)
				v:SetDesaturated(1)
				v:SetVertexColor(r2, g2, b2)
			end
		end
	end
	PaintTextures()