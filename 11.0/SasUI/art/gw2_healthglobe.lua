local addonName, addon = ...

-- Helper function for texture paths
local function sgTextures(filename)
    return "Interface\\AddOns\\" .. addonName .. "\\media\\" .. filename
end

-- Create a frame to hold the texture
local f = CreateFrame("Frame", "HealthGlobe_GlassFrame", UIParent, "BackdropTemplate")

-- Register for the ADDON_LOADED event to initialize
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        -- Wait for GW2_PlayerFrame to be available
        local function setupFrame()
            local parentFrame = _G["GW2_PlayerFrame"]
            if parentFrame then
                -- Set GW2_PlayerFrame as the parent
                f:SetParent(parentFrame)
                -- Set frame properties
                f:SetSize(parentFrame:GetWidth()+15, parentFrame:GetHeight()+15) -- Match parent's width and height
                f:SetPoint("CENTER", parentFrame, "CENTER", 0, 0) -- Position relative to GW2_PlayerFrame
				-- Set frame strata to appear in front
                f:SetFrameLevel(parentFrame:GetFrameLevel() + 5) -- One level above parent

                -- Create texture
                local texture = f:CreateTexture(nil, "ARTWORK")
                texture:SetAllPoints(f) -- Make texture fill the frame
                texture:SetTexture(sgTextures("orb_gloss.tga")) -- Path to your .tga file
            else
                -- Retry after a short delay if GW2_PlayerFrame isn't ready
                C_Timer.After(1, setupFrame)
            end
        end
        setupFrame()

        -- Unregister event after loading
        self:UnregisterEvent("ADDON_LOADED")
    end
end)