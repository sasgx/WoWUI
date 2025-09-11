	local addonName, addon = ...

	if not C_AddOns.IsAddOnLoaded("GW2_UI") then return end

	-- Helper function for texture paths
	local function sgTextures(filename)
		return "Interface\\AddOns\\" .. addonName .. "\\media\\" .. filename
	end

	-- Create a frame to hold the texture
	local f = CreateFrame("Frame", "HealthGlobe_ChainsFrame", UIParent, "BackdropTemplate")