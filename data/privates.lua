------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;

------------------------------------------------------------------------------------------------------
-- The Privates object
------------------------------------------------------------------------------------------------------
Cryolysis3.Private = {
	-- Single values
	englishFaction		= UnitFactionGroup("player"),
	hasReagents		= false,
	mountRegion		= -1,
	macroName		= "Cryo3",

	-- Arrays
	RegisteredModules	= {},
	classReagents		= {},
	cacheList		= {},
	tooltips		= {},
	mounts			= {
		["normal"]		= {},
		["flying"]		= {}
	},
}
