------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;
local module = Cryolysis3:NewModule("SHAMAN", Cryolysis3.ModuleCore, "AceEvent-3.0")
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
	
	if select(2,UnitClass("player")) == "SHAMAN" then
		Cryolysis3.Private.cacheList = {}
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
		"ClassSpell.Shaman.Elemental Combat",
		"ClassSpell.Shaman.Enhancement",
		"ClassSpell.Shaman.Restoration"
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
		-- Reincarnation reagents
		["Ankh"]		= 17030,
	};
	
	if (Cryolysis3:HasSpell(20608)) then
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Ankh"])] == nil) then
			-- Default Ankh restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Ankh"])] = 10;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Ankh"] = reagentList["Ankh"];

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