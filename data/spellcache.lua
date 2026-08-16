------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;


------------------------------------------------------------------------------------------------------
-- The spell cache object
------------------------------------------------------------------------------------------------------
Cryolysis3.spellCache = {

};


------------------------------------------------------------------------------------------------------
-- Function for grabbing all three sets from LPT
------------------------------------------------------------------------------------------------------
function Cryolysis3:PopulateSpellList(tbl)
	if not tbl then return end
	
	local LPT = LibStub and LibStub("LibPeriodicTable-3.1", true)
	if not LPT or not LPT.GetSetTable then
		return
	end

	for x, y in pairs(tbl) do
		local success, setTable = pcall(function() return LPT:GetSetTable(y) end)
		if success and type(setTable) == "table" then
			for k, v in pairs(setTable) do
				if (tonumber(k) ~= nil) then
					Cryolysis3.spellList = Cryolysis3.spellList or {}
					table.insert(Cryolysis3.spellList, -(tonumber(k)))
				end
			end
		end
	end
end

------------------------------------------------------------------------------------------------------
-- Function for caching all the user's learned skills/spells
------------------------------------------------------------------------------------------------------
function Cryolysis3:CacheSpells()
	-- Temporary table to store spellbook spells
	local temp = {};

	if (Cryolysis3.spellList == nil) then
		return false;
	end

	-- Loop through entire spellbook
	local spellBookType = BOOKTYPE_SPELL or "spell"
	local i = 1;
	while (true) do
		local spellName, spellSubName, spellID
		if GetSpellBookItemName then
			spellName, spellSubName, spellID = GetSpellBookItemName(i, spellBookType)
		end
		
		if not spellName then
			break
		end
		
		temp[spellName] = spellName;
		if spellSubName and spellSubName ~= "" then
			temp[spellName..spellSubName] = spellName..spellSubName;
		end
		
		i = i + 1;
	end
	
	for i = 1, #(Cryolysis3.spellList), 1 do
		local spellIdToCheck = Cryolysis3.spellList[i]
		if spellIdToCheck then
			local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(spellIdToCheck);
			
			if (name ~= nil) then
				if (temp[name] ~= nil) then
					Cryolysis3.spellCache[spellIdToCheck] = {
						["name"] = name,
						["rank"] = rank,
						["icon"] = icon,
						["cost"] = 0,
						["isFunnel"] = false,
						["powerType"] = 0,
						["castTime"] = castTime,
						["minRange"] = minRange,
						["maxRange"] = maxRange
					}
				end
			end
		end
	end
	
	temp = nil;
	Cryolysis3.spellList = nil;
	collectgarbage("collect");
end

------------------------------------------------------------------------------------------------------
-- Function to check if we have a selected spell in our spellbook
--	If spellID is a string, it checks if we have a spell that matches this type of spell
------------------------------------------------------------------------------------------------------
function Cryolysis3:HasSpell(spellID)

	if (type(spellID) == "string") then
		-- List of spellIDs to check for
		local ID = {};

		if (spellID == "Teleport") then
			if (Cryolysis3.Private.englishFaction == "Alliance") then
				ID = {
					3562,	-- Ironforge
					3561,	-- Stormwind
					3565,	-- Darnassus
					32271,	-- The Exodar
					33690,	-- Shattrath City
					53140,	-- Dalaran
				};
				
			else
				ID = {
					3567,	-- Orgrimmar
					3563,	-- Undercity
					3566,	-- Thunder Bluff
					32272,	-- Silvermoon City
					35715,	-- Shattrath City
					53140,	-- Dalaran
				};
				
			end

		elseif (spellID == "Portal") then
			if (Cryolysis3.Private.englishFaction == "Alliance") then
				ID = {
					11416,	-- Ironforge
					10059,	-- Stormwind
					11419,	-- Darnassus
					32266,	-- The Exodar
					33691,	-- Shattrath City
					53142,	-- Dalaran
				};
				
			else
				ID = {
					11417,	-- Orgrimmar
					11418,	-- Undercity
					11420,	-- Thunder Bluff
					32267,	-- Silvermoon City
					35717,	-- Shattrath City
					53142,	-- Dalaran
				};
				
			end

		elseif (spellID == "Blessing") then
			ID = {
				19740, -- Blessing of Might
				19742, -- Blessing of Wisdom
				20217, -- Blessing of Kings
				20911  -- Blessing of Sanctuary
			};

		elseif (spellID == "Greater Blessing") then
			ID = {
				25782, -- Greater Blessing of Might
				25894, -- Greater Blessing of Wisdom
				25898, -- Greater Blessing of Kings
				25899  -- Greater Blessing of Sanctuary
			};
		end
		
		-- Check if we have the spells in our ID table
		for i = 1, #(ID), 1 do
			if (Cryolysis3:HasSpell(ID[i])) then
				return true;
			end
		end
		
		return false;
	else
		if (Cryolysis3.spellCache[spellID] == nil) then
			-- This spell was not in our cache, ergo we don't have it
			return false;
		else
			-- It was, we has it
			return true;
		end
	end
end