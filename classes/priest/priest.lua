------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;
local module = Cryolysis3:NewModule("PRIEST", Cryolysis3.ModuleCore, "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Cryolysis3");


------------------------------------------------------------------------------------------------------
-- Function to generate options
------------------------------------------------------------------------------------------------------
function module:CreateOptions()
	-- The option to shut off this module
	local options = {
	}
	
	return options;
end

------------------------------------------------------------------------------------------------------
-- Function to generate configuration options
------------------------------------------------------------------------------------------------------
function module:CreateConfigOptions()
	-- The various configurations this module produces
	local configOptions = {
		
		type = "group",
		name = gsub(UnitClass("player"), "^.", function(s) return s:upper() end),
		desc = L["Adjust various options for this module."],
		args = {

		}
	}
		
	return configOptions;
end

------------------------------------------------------------------------------------------------------
-- What happens when the module is initialised
------------------------------------------------------------------------------------------------------
function module:OnInitialize()
	-- Register our options with the global array
	--module:RegisterOptions(options);
	if select(2,UnitClass("player")) == "PRIEST" then
		Cryolysis3.Private.cacheList = {17028, 17029}
	end
	
end

------------------------------------------------------------------------------------------------------
-- What happens when the module is enabled
------------------------------------------------------------------------------------------------------
function module:OnEnable()
	-- And we're live!
	-- Set the default skin
	Cryolysis3:SetDefaultSkin("Orange");
	
	-- Create a list of the paladin's spells to be cached
	Cryolysis3.spellList = {};
	
	-- Local table of the LPT sets we will be using
	local t = {
		"ClassSpell.Priest.Discipline",
		"ClassSpell.Priest.Holy",
		"ClassSpell.Priest.Shadow Magic"
	};
	
	-- Create spellList
	Cryolysis3:PopulateSpellList(t);
	
	-- Insert our config options
	module:RegisterConfigOptions(module:CreateConfigOptions())
	
	-- Register our wanted events
	module:RegisterClassEvents();
end

------------------------------------------------------------------------------------------------------
-- What happens when the module is disabled
------------------------------------------------------------------------------------------------------
function module:OnDisable()

end

------------------------------------------------------------------------------------------------------
-- Function for creating a reagent list
------------------------------------------------------------------------------------------------------
function module:CreateReagentList()
	local reagentList = {
		-- Prayer reagents
		["Sacred Candle"]	= 17029,
		["Holy Candle"]		= 17028,
	};
	

	-- Begin checking Prayer of Fortitude
	if (Cryolysis3:HasSpell(25392) or Cryolysis3:HasSpell(21564)) then
		-- Rank 3 and Rank 2 overrides Rank 1
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Sacred Candle"])] == nil) then
			-- Default Sacred Candle restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Sacred Candle"])] = 20;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Sacred Candle"] = reagentList["Sacred Candle"];
		
		-- We're in need of reagents
		Cryolysis3.Private.hasReagents = true;
		
	elseif (Cryolysis3:HasSpell(21562)) then
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Holy Candle"])] == nil) then
			-- Default Holy Candle restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Holy Candle"])] = 20;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Holy Candle"] = reagentList["Holy Candle"];

		-- We're in need of reagents
		Cryolysis3.Private.hasReagents = true;
	end
	
	-- Begin checking Prayer of Shadow Protection
	if (Cryolysis3:HasSpell(27683) or Cryolysis3:HasSpell(39374)) then
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Sacred Candle"])] == nil) then
			-- Default Sacred Candle restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Sacred Candle"])] = 20;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Sacred Candle"] = reagentList["Sacred Candle"];
		
		-- We're in need of reagents
		Cryolysis3.Private.hasReagents = true;
	end
	
	-- Begin checking Prayer of Spirit
	if (Cryolysis3:HasSpell(27681) or Cryolysis3:HasSpell(32999)) then
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Sacred Candle"])] == nil) then
			-- Default Sacred Candle restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Sacred Candle"])] = 20;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Sacred Candle"] = reagentList["Sacred Candle"];
		
		-- We're in need of reagents
		Cryolysis3.Private.hasReagents = true;
	end
end

------------------------------------------------------------------------------------------------------
-- Function for creating all the buttons used by this class
------------------------------------------------------------------------------------------------------
function module:CreateButtons()

	if (Cryolysis3:HasSpell(34433)) then
		-- We has an Evocation, create and set up the button for it
		Cryolysis3:CreateButton("ShadowfiendButton", UIParent, Cryolysis3.spellCache[34433].icon);
		
		-- Start tooltip data
		Cryolysis3.Private.tooltips["ShadowfiendButton"] = {};

		-- Start adding tooltip data
		table.insert(Cryolysis3.Private.tooltips["ShadowfiendButton"], Cryolysis3.spellCache[34433].name);
		
		-- Set Evocation button action
		Cryolysis3.db.char.buttonTypes["ShadowfiendButton"] = "spell";
		Cryolysis3.db.char.buttonFunctions["ShadowfiendButton"] = {};
		Cryolysis3.db.char.buttonFunctions["ShadowfiendButton"]["left"] = 34433;

		-- Update all actions
		Cryolysis3:UpdateButton("ShadowfiendButton", "left");

		-- Update cooldown
		--UpdateShadowfiend();
	end
	
	if (Cryolysis3:HasSpell(34433)) then
		-- We has a Resurrection, create and set up the button for it
		Cryolysis3:CreateButton("ResurrectionButton", UIParent, Cryolysis3.spellCache[2006].icon);
		
		-- Start tooltip data
		Cryolysis3.Private.tooltips["ResurrectionButton"] = {};

		-- Start adding tooltip data
		table.insert(Cryolysis3.Private.tooltips["ResurrectionButton"], Cryolysis3.spellCache[2006].name);
		
		-- Set Evocation button action
		Cryolysis3.db.char.buttonTypes["ResurrectionButton"] = "spell";
		Cryolysis3.db.char.buttonFunctions["ResurrectionButton"] = {};
		Cryolysis3.db.char.buttonFunctions["ResurrectionButton"]["left"] = 2006;

		-- Update all actions
		Cryolysis3:UpdateButton("ResurrectionButton", "left");

	end

	Cryolysis3.Private.tooltips["BuffButton"] = {};

	-- Start adding tooltip data
	table.insert(Cryolysis3.Private.tooltips["BuffButton"],		L["Buff Menu"]);
	table.insert(Cryolysis3.Private.tooltips["BuffButton"],		L["Click to open menu."]);
	
	local hasBuff = false
	local tooltip = {};
	
	-- Fortitude Button
	if (Cryolysis3:HasSpell(1243) or Cryolysis3:HasSpell(21562)) then
		-- Power Word:/Prayer of Fortitude
		tooltip = Cryolysis3:PrepareButton("BuffButton", "fortitude", "spell", L["Fortitude"], 1243, 21562);
		Cryolysis3:AddMenuItem("BuffButton", "fortitude", select(3, GetSpellInfo(1243)), tooltip);

		hasBuff = true;
	end
	
	-- Spirit Button
	if (Cryolysis3:HasSpell(14752) or Cryolysis3:HasSpell(27681)) then
		-- Divine/Prayer of Spirit
		tooltip = Cryolysis3:PrepareButton("BuffButton", "spirit", "spell", L["Spirit"], 14752, 27681);
		Cryolysis3:AddMenuItem("BuffButton", "spirit", select(3, GetSpellInfo(14752)), tooltip);

		hasBuff = true;
	end
	
	-- Shadow Protection Button
	if (Cryolysis3:HasSpell(976) or Cryolysis3:HasSpell(27683)) then
		-- Shadow Protection/Prayer of Shadow Protection
		tooltip = Cryolysis3:PrepareButton("BuffButton", "shadowprot", "spell", L["Protection"], 976, 27683);
		Cryolysis3:AddMenuItem("BuffButton", "shadowprot", select(3, GetSpellInfo(976)), tooltip);

		hasBuff = true;
	end
	
	-- Inner Fire Button
	if (Cryolysis3:HasSpell(588)) then
		-- Inner Fire
		tooltip = Cryolysis3:PrepareButton("BuffButton", "innerfire", "spell", 588, 588);
		Cryolysis3:AddMenuItem("BuffButton", "innerfire", select(3, GetSpellInfo(588)), tooltip);

		hasBuff = true;
	end
	
	-- Fear Ward Button
	if (Cryolysis3:HasSpell(6346)) then
		-- Fear Ward
		tooltip = Cryolysis3:PrepareButton("BuffButton", "fearward", "spell", 6346, 6346);
		Cryolysis3:AddMenuItem("BuffButton", "fearward", select(3, GetSpellInfo(6346)), tooltip);

		hasBuff = true;
	end
	
	-- Levitate Button
	if (Cryolysis3:HasSpell(1706)) then
		-- Levitate
		tooltip = Cryolysis3:PrepareButton("BuffButton", "levitate", "spell", 1706, 1706);
		Cryolysis3:AddMenuItem("BuffButton", "levitate", select(3, GetSpellInfo(1706)), tooltip);

		hasBuff = true;
	end
	
	if (hasBuff) then
		-- We have a buff, create and set up the buff menu button
		Cryolysis3:CreateButton("BuffButton", UIParent, "Interface\\Icons\\Spell_Holy_PrayerOfFortitude", "menuButton")
	end
	
	
	
end

------------------------------------------------------------------------------------------------------
-- Register for our needed events
------------------------------------------------------------------------------------------------------
function module:RegisterClassEvents()
	-- Events relevant to this class
	module:RegisterEvent("UNIT_MANA");
end

------------------------------------------------------------------------------------------------------
-- We all loves the manas!
------------------------------------------------------------------------------------------------------
function module:UNIT_MANA(event, unitId)
	if (tonumber(Cryolysis3.db.char.outerSphere) == 3 and unitId == "player") then
		Cryolysis3:UpdateSphere("outerSphere");
	end
end