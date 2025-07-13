	
	-----------------------------
	-- // CONFIG \\
	-----------------------------
	-- Set the textures to be class colored
	local ClassColored = false
	
	-----------------------------
	-- // CONFIG END \\
	-----------------------------
		
	local cc = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[select(2, UnitClass("player"))] or rRAID_CLASS_COLORS[select(2, UnitClass("player"))] or  { r=0.5, g=0.5, b=0.5 }
		
	local function PaintTextures()
		local cl = ClassColored == true
		local r1, g1, b1, a1 = 1, 1, 1, 1 -- top color
        local r2, g2, b2, a2 = cl and cc.r or .4, cl and cc.g or .4, cl and cc.b or .4, 1 -- default color 
		--local r2, g2, b2, a2 = cl and cc.r or 0.70, cl and cc.g or 0.57, cl and cc.b or 0.43, 1 -- Brown

		for i,v in pairs({
			-- Action bars
			MainMenuMaxLevelBar0,
			MainMenuMaxLevelBar1,
			MainMenuMaxLevelBar2,
			MainMenuMaxLevelBar3,
			MainMenuBarTexture0,
			MainMenuBarTexture1,
			MainMenuBarTexture2,
			MainMenuBarTexture3,
			MainMenuXPBarTextureRightCap,
			MainMenuXPBarTextureMid,
			MainMenuXPBarTextureLeftCap,
			ActionBarUpButton:GetRegions(),
			ActionBarDownButton:GetRegions(),
			--BonusActionBarFrame:GetRegions(),
			--select(2, BonusActionBarFrame:GetRegions()),
			--VehicleMenuBarArtFrame:GetRegions(),
			--OverrideActionBar:GetRegions(),
		
			-- Unit frames
			PlayerFrameTexture,
			TargetFrameTextureFrameTexture,
			FocusFrameTextureFrameTexture,
			TargetFrameToTTextureFrameTexture,
			FocusFrameToTTextureFrameTexture,
			PetFrameTexture,
			PartyMemberFrame1Texture,
			PartyMemberFrame2Texture,
			PartyMemberFrame3Texture,
			PartyMemberFrame4Texture,
			Boss1TargetFrameTextureFrame:GetRegions(),
			Boss2TargetFrameTextureFrame:GetRegions(),
			Boss3TargetFrameTextureFrame:GetRegions(),
			Boss4TargetFrameTextureFrame:GetRegions(),
			
			-- Minimap
			--MinimapBackdrop,
			MinimapBorder,
			MiniMapMailBorder,
			MiniMapTrackingButtonBorder,
			MinimapBorderTop,
			MinimapZoneTextButton,
			MiniMapWorldMapButton,
			MiniMapWorldMapButton,
			MiniMapWorldIcon,
			MinimapZoomIn:GetRegions(),
			MinimapZoomOut:GetRegions(),
			TimeManagerClockButton:GetRegions(),
			MiniMapWorldMapButton:GetRegions(),
			select(6, GameTimeFrame:GetRegions()),
			MiniMapLFGFrameBorder,
			--MiniMapBattlefieldFrameBorder,
			
			-- Menus
			FriendsFrame:GetRegions(),
			CharacterFrame:GetRegions(),

			
			-- Exp bubble dividers
			MainMenuXPBarDiv1,
			MainMenuXPBarDiv2,
			MainMenuXPBarDiv3,
			MainMenuXPBarDiv4,
			MainMenuXPBarDiv5,
			MainMenuXPBarDiv6,
			MainMenuXPBarDiv7,
			MainMenuXPBarDiv8,
			MainMenuXPBarDiv9,
			MainMenuXPBarDiv10,
			MainMenuXPBarDiv11,
			MainMenuXPBarDiv12,
			MainMenuXPBarDiv13,
			MainMenuXPBarDiv14,
			MainMenuXPBarDiv15,
			MainMenuXPBarDiv16,
			MainMenuXPBarDiv17,
			MainMenuXPBarDiv18,
			MainMenuXPBarDiv19,
			
			-- Chat frame buttons
			select(2, FriendsMicroButton:GetRegions()),
			ChatFrameMenuButton:GetRegions(),
			ChatFrame1ButtonFrameUpButton:GetRegions(),
			ChatFrame1ButtonFrameDownButton:GetRegions(),
			select(2, ChatFrame1ButtonFrameBottomButton:GetRegions()),
			ChatFrame2ButtonFrameUpButton:GetRegions(),
			ChatFrame2ButtonFrameDownButton:GetRegions(),
			select(2, ChatFrame2ButtonFrameBottomButton:GetRegions()),
			select(2, ChatFrame3ButtonFrameBottomButton:GetRegions()),
			ChatFrame3ButtonFrameUpButton:GetRegions(),
			ChatFrame3ButtonFrameDownButton:GetRegions(),
			select(2, ChatFrame3ButtonFrameBottomButton:GetRegions()),
			ChatFrame3ButtonFrameMinimizeButton:GetRegions(),				
			select(2, ChatFrame4ButtonFrameBottomButton:GetRegions()),
			ChatFrame4ButtonFrameUpButton:GetRegions(),
			ChatFrame4ButtonFrameDownButton:GetRegions(),
			select(2, ChatFrame4ButtonFrameBottomButton:GetRegions()),
			ChatFrame4ButtonFrameMinimizeButton:GetRegions(),
			
			-- Chat edit box
			select(6, ChatFrame1EditBox:GetRegions()),
			select(7, ChatFrame1EditBox:GetRegions()),
			select(8, ChatFrame1EditBox:GetRegions()),
			select(5, ChatFrame1EditBox:GetRegions()),
			
			MainMenuBarLeftEndCap,
			MainMenuBarRightEndCap,
						
		}) do
			if v:GetObjectType() == "Texture" then
				v:SetVertexColor(1, 1, 1)
				v:SetDesaturated(1)
				v:SetVertexColor(r2, g2, b2)
			end
		end
		
		-- Desaturation fix for elite target texture (thanks SDPhantom!)
		hooksecurefunc("TargetFrame_CheckClassification", function(self)
			self.borderTexture:SetDesaturated(1)
		end)
		-- Game tooltip
		TOOLTIP_DEFAULT_COLOR = { r = r1 * .6, g = g1 * .6, b = b1 * .6 }
		TOOLTIP_DEFAULT_BACKGROUND_COLOR = { r = r2 * .1, g = g2 * .1, b = b2 * .1}	
	end
	PaintTextures()
