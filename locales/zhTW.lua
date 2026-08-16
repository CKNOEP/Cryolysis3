--[[
	Find a line with "--" in front of it, delete the "--" and replace "true"
	with the string for your language.  Be sure to preserve all spacing!
]]

------------------------------------------------------------------------------------------------------
-- Setup the locale library
------------------------------------------------------------------------------------------------------
local L = LibStub("AceLocale-3.0"):NewLocale("Cryolysis3", "zhTW")
if not L then return end

L["Left Click for Config"] = "左鍵點擊打開配置";
L["Shift+Drag to Move"] = "Shift+拖動以移動";