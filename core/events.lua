------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;


------------------------------------------------------------------------------------------------------
-- Register for events used by every module or the core
------------------------------------------------------------------------------------------------------
function Cryolysis3:RegisterCommonEvents()
	Cryolysis3:RegisterEvent("UNIT_HEALTH");
	Cryolysis3:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	Cryolysis3:RegisterEvent("PLAYER_REGEN_DISABLED");
	Cryolysis3:RegisterEvent("PLAYER_REGEN_ENABLED");
	Cryolysis3:RegisterEvent("LEARNED_SPELL_IN_TAB");
	Cryolysis3:RegisterEvent("CHARACTER_POINTS_CHANGED");
end

------------------------------------------------------------------------------------------------------
-- What happens when our health changes
------------------------------------------------------------------------------------------------------
function Cryolysis3:UNIT_HEALTH(info, unit)
	if unit ~= "player" then
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
	if (Cryolysis3.Private.mountRegion ~= IsFlyableArea()) then
		-- Make sure the texture is correct
		Cryolysis3:UpdateMountButtonTexture();
		
		-- Update our flyable area mount region thingy
		Cryolysis3.Private.mountRegion = IsFlyableArea();
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
-- We learned a new ability/spell
------------------------------------------------------------------------------------------------------
function Cryolysis3:LEARNED_SPELL_IN_TAB()
	-- We learned a new spell
	Cryolysis3:CacheSpells();
end

------------------------------------------------------------------------------------------------------
-- Talents updated (or?)
------------------------------------------------------------------------------------------------------
function Cryolysis3:CHARACTER_POINTS_CHANGED(arg1)
	if (arg1 == -1) then
		-- We learned a talent
		Cryolysis3:CacheSpells();
	end
end