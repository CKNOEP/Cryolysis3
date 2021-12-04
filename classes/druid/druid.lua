------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;
local module = Cryolysis3:NewModule("DRUID", Cryolysis3.ModuleCore, "AceEvent-3.0")
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
	
	if select(2,UnitClass("player")) == "DRUID" then
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
		"ClassSpell.Druid.Balance",
		"ClassSpell.Druid.Feral Combat",
		"ClassSpell.Druid.Restoration"
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
		-- Gift of the Wild reagents
		["Wild Quillvine"]	= 22148,	-- Rank 3
		["Wild Thornroot"]	= 17026,	-- Rank 2
		["Wild Berries"]	= 17021,	-- Rank 1
		
		-- Rebirth reagents
		["Flintweed Seed"]	= 22147,	-- Rank 6
		["Ironwood Seed"]	= 17038,	-- Rank 5
		["Hornbeam Seed"]	= 17037,	-- Rank 4
		["Ashwood Seed"]	= 17036,	-- Rank 3
		["Stranglethorn Seed"]	= 17035,	-- Rank 2
		["Maple Seed"]		= 17034,	-- Rank 1
	}

	-- Begin checking Rebirth
	if (Cryolysis3:HasSpell(26991)) then
		-- Rank 6 overrides Rank 5
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Flintweed Seed"])] == nil) then
			-- Default Wild Thornroot restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Flintweed Seed"])] = 20;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Flintweed Seed"] = reagentList["Flintweed Seed"];
		
		-- We're in need of reagents
		Cryolysis3.Private.hasReagents = true;
		
	elseif (Cryolysis3:HasSpell(21850)) then
		-- Rank 5 overrides Rank 4
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Ironwood Seed"])] == nil) then
			-- Default Ironwood Seed restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Ironwood Seed"])] = 20;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Ironwood Seed"] = reagentList["Ironwood Seed"];
		
		-- We're in need of reagents
		Cryolysis3.Private.hasReagents = true;
		
	elseif (Cryolysis3:HasSpell(21850)) then
		-- Rank 4 overrides Rank 3
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Hornbeam Seed"])] == nil) then
			-- Default Hornbeam Seed restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Hornbeam Seed"])] = 20;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Hornbeam Seed"] = reagentList["Hornbeam Seed"];
		
		-- We're in need of reagents
		Cryolysis3.Private.hasReagents = true;
		
	elseif (Cryolysis3:HasSpell(21850)) then
		-- Rank 3 overrides Rank 2
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Ashwood Seed"])] == nil) then
			-- Default Ashwood Seed restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Ashwood Seed"])] = 20;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Ashwood Seed"] = reagentList["Ashwood Seed"];
		
		-- We're in need of reagents
		Cryolysis3.Private.hasReagents = true;
		
	elseif (Cryolysis3:HasSpell(21850)) then
		-- Rank 2 overrides Rank 1
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Stranglethorn Seed"])] == nil) then
			-- Default Stranglethorn Seed restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Stranglethorn Seed"])] = 20;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Stranglethorn Seed"] = reagentList["Stranglethorn Seed"];
		
		-- We're in need of reagents
		Cryolysis3.Private.hasReagents = true;
		
	elseif (Cryolysis3:HasSpell(21850)) then
		-- Rank 1, we're newbs
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Maple Seed"])] == nil) then
			-- Default Maple Seed restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Maple Seed"])] = 20;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Maple Seed"] = reagentList["Maple Seed"];
		
		-- We're in need of reagents
		Cryolysis3.Private.hasReagents = true;
	end	
	
	
	-- Begin checking Gift of the Wild
	if (Cryolysis3:HasSpell(26991)) then
		-- Rank 3 overrides Rank 2
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Wild Quillvine"])] == nil) then
			-- Default Wild Quillvine restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Wild Quillvine"])] = 20;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Wild Quillvine"] = reagentList["Wild Quillvine"];
		
		-- We're in need of reagents
		Cryolysis3.Private.hasReagents = true;
		
	elseif (Cryolysis3:HasSpell(21850)) then
		-- Rank 2 overrides Rank 1
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Wild Thornroot"])] == nil) then
			-- Default Wild Thornroot restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Wild Thornroot"])] = 20;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Wild Thornroot"] = reagentList["Wild Thornroot"];
		
		-- We're in need of reagents
		Cryolysis3.Private.hasReagents = true;
		
	elseif (Cryolysis3:HasSpell(21849)) then
		-- Rank 1, we're newbs
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Wild Berries"])] == nil) then
			-- Default Wild Berries restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Wild Berries"])] = 20;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Wild Berries"] = reagentList["Wild Berries"];
		
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
end