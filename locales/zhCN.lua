--[[
	Find a line with "--" in front of it, delete the "--" and replace "true"
	with the string for your language.  Be sure to preserve all spacing!
]]

------------------------------------------------------------------------------------------------------
-- Setup the locale library
------------------------------------------------------------------------------------------------------
local L = LibStub("AceLocale-3.0"):NewLocale("Cryolysis3", "zhCN")
if not L then return end