------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;
local module = Cryolysis3:NewModule("PALADIN", Cryolysis3.ModuleCore, "AceEvent-3.0")
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
	
	if select(2,UnitClass("player")) == "PALADIN" then
		Cryolysis3.Private.cacheList = {21177, 17033}
	end
	
end

------------------------------------------------------------------------------------------------------
-- What happens when the module is enabled
------------------------------------------------------------------------------------------------------
function module:OnEnable()
	-- And we're live!
	
	-- Create a list of the paladin's spells to be cached
	Cryolysis3.spellList = {};
	
	-- Local table of the LPT sets we will be using
	local t = {
		"ClassSpell.Paladin.Holy",
		"ClassSpell.Paladin.Protection",
		"ClassSpell.Paladin.Retribution"
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
		-- Greater Blessing reagents
		["Symbol of Kings"]		= 21177,
		
		-- Divine Intervention reagents
		["Symbol of Divinity"]		= 17033,
	}
	
	-- Check for Greater Blessings
	if (Cryolysis3:HasSpell("Greater Blessing")) then
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Symbol of Kings"])] == nil) then
			-- Default Symbol of Kings restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Symbol of Kings"])] = 100;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Symbol of Kings"] = reagentList["Symbol of Kings"];

		-- We're in need of reagents
		Cryolysis3.Private.hasReagents = true;
	end
	
	-- Check for Divine Intervention
	if (Cryolysis3:HasSpell(19752)) then
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Symbol of Divinity"])] == nil) then
			-- Default Symbol of Divinity restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Symbol of Divinity"])] = 5;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Symbol of Divinity"] = reagentList["Symbol of Divinity"];

		-- We're in need of reagents
		Cryolysis3.Private.hasReagents = true;
	end
end

------------------------------------------------------------------------------------------------------
-- Function for creating all the buttons used by this class
------------------------------------------------------------------------------------------------------
function module:CreateButtons()

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