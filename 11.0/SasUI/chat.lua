-- rChat: core (Sas_Glass/func/chat.lua)
-- zork, 2016; updated for The War Within (Interface 110002), 2025

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local DefaultSetItemRef = SetItemRef

local cfg = {
  dropshadow = { offset = {1, -2}, color = {0, 0, 0, 0.25} },
  editbox = { font = {"Interface\\AddOns\\SasUI\\media\\font\\FiraSansCondensed-Black.ttf", 13, "THINOUTLINE"} },
  chat = { font = {"Interface\\AddOns\\SasUI\\media\\font\\FiraSansCondensed-Black.ttf", 13, "THINOUTLINE"} },
}

-----------------------------
-- Functions
-----------------------------

-- SkinChat: Customize chat frame appearance and behavior
local function SkinChat(self)
  if not self then return end
  local name = self:GetName()
  -- Chat frame settings
  self:SetFont(unpack(cfg.chat.font))
  self:SetShadowOffset(unpack(cfg.dropshadow.offset))
  self:SetShadowColor(unpack(cfg.dropshadow.color))
  self:SetFading(true)
  self:SetTimeVisible(6)
  -- Hide button frame
  local bf = _G[name.."ButtonFrame"]
  if bf then
    bf:HookScript("OnShow", bf.Hide)
    bf:Hide()
  end
  -- Edit box
  local eb = _G[name.."EditBox"]
  if eb then
    eb:SetAltArrowKeyMode(false)
    _G[name.."EditBoxLeft"]:Hide()
    _G[name.."EditBoxMid"]:Hide()
    _G[name.."EditBoxRight"]:Hide()
    eb:ClearAllPoints()
    if name == "ChatFrame2" then
      eb:SetPoint("TOP", self, "BOTTOM", 0, -12 + (CombatLogQuickButtonFrame_Custom and CombatLogQuickButtonFrame_Custom:GetHeight() or 24))
    else
      eb:SetPoint("TOP", self, "BOTTOM", 0, -12)
    end
    eb:SetPoint("LEFT", self, -5, 0)
    eb:SetPoint("RIGHT", self, 10, 0)
  end
end

-- OpenTemporaryWindow: Skin temporary chat windows
local function OpenTemporaryWindow()
  for _, name in next, CHAT_FRAMES do
    local frame = _G[name]
    if frame and frame.isTemporary then
      SkinChat(frame)
    end
  end
end

-- OnMouseScroll: Custom scroll behavior
local function OnMouseScroll(self, dir)
  if dir > 0 then
    if IsShiftKeyDown() then self:ScrollToTop() else self:ScrollUp() end
  else
    if IsShiftKeyDown() then self:ScrollToBottom() else self:ScrollDown() end
  end
end

-- SetItemRef: Handle alt-click invites and URL copying
function SetItemRef(link, ...)
  local type, value = link:match("(%a+):(.+)")
  if IsAltKeyDown() and type == "player" then
    InviteUnit(value:match("([^:]+)"))
  elseif type == "url" then
    local eb = LAST_ACTIVE_CHAT_EDIT_BOX or _G["ChatFrame1EditBox"]
    if eb then
      eb:SetText(value)
      eb:SetFocus()
      eb:HighlightText()
      if not eb:IsShown() then eb:Show() end
    end
  else
    return DefaultSetItemRef(link, ...)
  end
end

-- AddMessage: Customize channel display and URL links
local function AddMessage(self, text, ...)
  text = text:gsub('|h%[(%d+)%. .-%]|h', '|h%1.|h')
  text = text:gsub('([wWhH][wWtT][wWtT][%.pP]%S+[^%p%s])', '|cffffffff|Hurl:%1|h[%1]|h|r')
  return self.DefaultAddMessage(self, text, ...)
end

-----------------------------
-- Setup
-----------------------------

-- Edit box font
ChatFontNormal:SetFont(unpack(cfg.editbox.font))
ChatFontNormal:SetShadowOffset(unpack(cfg.dropshadow.offset))
ChatFontNormal:SetShadowColor(unpack(cfg.dropshadow.color))

-- Font sizes
CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}

--tabs
CHAT_TAB_HIDE_DELAY = 1
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 1

--channels
CHAT_WHISPER_GET              = "From %s "
CHAT_WHISPER_INFORM_GET       = "To %s "
CHAT_BN_WHISPER_GET           = "From %s "
CHAT_BN_WHISPER_INFORM_GET    = "To %s "
CHAT_YELL_GET                 = "%s "
CHAT_SAY_GET                  = "%s "
CHAT_BATTLEGROUND_GET         = "|Hchannel:Battleground|hBG.|h %s: "
CHAT_BATTLEGROUND_LEADER_GET  = "|Hchannel:Battleground|hBGL.|h %s: "
CHAT_GUILD_GET                = "|Hchannel:Guild|hG.|h %s: "
CHAT_OFFICER_GET              = "|Hchannel:Officer|hGO.|h %s: "
CHAT_PARTY_GET                = "|Hchannel:Party|hP.|h %s: "
CHAT_PARTY_LEADER_GET         = "|Hchannel:Party|hPL.|h %s: "
CHAT_PARTY_GUIDE_GET          = "|Hchannel:Party|hPG.|h %s: "
CHAT_RAID_GET                 = "|Hchannel:Raid|hR.|h %s: "
CHAT_RAID_LEADER_GET          = "|Hchannel:Raid|hRL.|h %s: "
CHAT_RAID_WARNING_GET         = "|Hchannel:RaidWarning|hRW.|h %s: "
CHAT_INSTANCE_CHAT_GET        = "|Hchannel:Battleground|hI.|h %s: "
CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:Battleground|hIL.|h %s: "
--CHAT_MONSTER_PARTY_GET       = CHAT_PARTY_GET
--CHAT_MONSTER_SAY_GET         = CHAT_SAY_GET
--CHAT_MONSTER_WHISPER_GET     = CHAT_WHISPER_GET
--CHAT_MONSTER_YELL_GET        = CHAT_YELL_GET
CHAT_FLAG_AFK = "<AFK> "
CHAT_FLAG_DND = "<DND> "
CHAT_FLAG_GM = "<[GM]> "

-- Guild loot messages
YOU_LOOT_MONEY_GUILD = YOU_LOOT_MONEY
LOOT_MONEY_SPLIT_GUILD = LOOT_MONEY_SPLIT

-- BNToastFrame
if BNToastFrame then
  BNToastFrame:SetClampedToScreen(true)
  BNToastFrame:SetClampRectInsets(-15, 15, 15, -15)
end

-- Hide buttons
for _, btn in pairs({
  "ChatFrameMenuButton",
  "ChatFrameChannelButton",
  "ChatFrameToggleVoiceDeafenButton",
  "ChatFrameToggleVoiceMuteButton",
  "QuickJoinToastButton",
  "FriendsMicroButton"
}) do
  local button = _G[btn]
  if button then
    button:HookScript("OnShow", button.Hide)
    button:Hide()
  end
end

-- Skin chat frames
for i = 1, NUM_CHAT_WINDOWS do
  local chatframe = _G["ChatFrame"..i]
  if chatframe then
    SkinChat(chatframe)
    if i ~= 2 then
      chatframe.DefaultAddMessage = chatframe.AddMessage
      chatframe.AddMessage = AddMessage
    end
  end
end

-- Scroll behavior
FloatingChatFrame_OnMouseScroll = OnMouseScroll

-- Temporary chat windows
hooksecurefunc("FCF_OpenTemporaryWindow", OpenTemporaryWindow)