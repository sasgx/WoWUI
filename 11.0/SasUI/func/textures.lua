	local addon, ns = ...

	-- Create addon namespace
	ns.SasUI = ns.SasUI or {}
	local SasUI = ns.SasUI

	-- Universal function for texture paths
	function SasUI.Textures(filename)
		if type(filename) ~= "string" then
			print(addon .. ": Textures requires a string filename.")
			return
		end
		return "Interface\\AddOns\\" .. addon .. "\\media\\" .. filename
	end