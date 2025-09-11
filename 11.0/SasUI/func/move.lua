	local addon, ns = ...

	-- Create addon namespace
	ns.SasUI = ns.SasUI or {}
	local SasUI = ns.SasUI
	
	-- Define your function to move UI frames
	function SasUI.Move(frameName, point, relativeTo, relativePoint, offsetX, offsetY)
		-- Get the frame using its name
		local frame = _G[frameName]
		if frame then
			-- Move the frame
			frame:ClearAllPoints()
			frame:SetPoint(point, relativeTo, relativePoint, offsetX, offsetY)
		else
			-- If the frame is not found, delay the movement until it's created
			C_Timer.After(1, function() SasUI.Move(frameName, point, relativeTo, relativePoint, offsetX, offsetY) end)
			print("Frame " .. frameName .. " not found to move it.")
		end
	end