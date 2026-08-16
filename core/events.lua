------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;


------------------------------------------------------------------------------------------------------
-- Register for events used by every module or the core
------------------------------------------------------------------------------------------------------
function Cryolysis3:RegisterCommonEvents()
	self:RegisterEvent("UNIT_HEALTH");
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	self:RegisterEvent("PLAYER_REGEN_DISABLED");
	self:RegisterEvent("PLAYER_REGEN_ENABLED");
	self:RegisterEvent("SPELLS_CHANGED");
	self:RegisterEvent("CHARACTER_POINTS_CHANGED");
end

------------------------------------------------------------------------------------------------------
-- What happens when our health changes
------------------------------------------------------------------------------------------------------
function Cryolysis3:UNIT_HEALTH(event, unit)
	-- Normalize unit checking for AceEvent-3.0 and native payload
	local targetUnit = unit or event
	if targetUnit ~= "player" then
		return false;
	end
	
	if (tonumber(Cryolysis3.db.char.sphereText) == 2 or tonumber(Cryolysis3.db.char.sphereText) == 3) then
		-- Health changed
		Cryolysis3:UpdateSphere("sphereText");
	end

	if (tonumber(Cryolysis3.db.char.outerSphere) == 2) then
		-- We're tracking health on the outer sphere
		Cryolysis3:UpdateSphere("outerSphere");
	end
end

------------------------------------------------------------------------------------------------------
-- Event that fires when we enter an area that swaps channels
------------------------------------------------------------------------------------------------------
function Cryolysis3:ZONE_CHANGED_NEW_AREA()
	local isFlyable = (IsFlyableArea and IsFlyableArea()) or false
	if (Cryolysis3.Private.mountRegion ~= isFlyable) then
		-- Make sure the texture is correct
		Cryolysis3:UpdateMountButtonTexture();
		
		-- Update our flyable area mount region thingy
		Cryolysis3.Private.mountRegion = isFlyable;
	end
end

------------------------------------------------------------------------------------------------------
-- Event that fires when we enter combat
------------------------------------------------------------------------------------------------------
function Cryolysis3:PLAYER_REGEN_DISABLED()

end

------------------------------------------------------------------------------------------------------
-- Event that fires when we leave combat
------------------------------------------------------------------------------------------------------
function Cryolysis3:PLAYER_REGEN_ENABLED()

end

------------------------------------------------------------------------------------------------------
-- We learned a new ability/spell / spells changed
------------------------------------------------------------------------------------------------------
function Cryolysis3:SPELLS_CHANGED()
	-- We learned a new spell or spellbook changed
	Cryolysis3:CacheSpells();
end

------------------------------------------------------------------------------------------------------
-- Talents updated (or?)
------------------------------------------------------------------------------------------------------
function Cryolysis3:CHARACTER_POINTS_CHANGED(event, arg1)
	local points = (type(event) == "number" and event) or arg1
	if (points == -1) or (points == nil) then
		-- We learned a talent
		Cryolysis3:CacheSpells();
	end
end