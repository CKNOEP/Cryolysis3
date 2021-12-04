------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;


------------------------------------------------------------------------------------------------------
-- This file should only contain module setup functions.  This includes, but is not limited to 
-- module loading, registering, and base functions.
------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------
-- Register options with the global modules options table
------------------------------------------------------------------------------------------------------
function Cryolysis3:RegisterOptions(n, t)
	assert(Cryolysis3.options.args.modules[n] == nil)
	Cryolysis3.options.args.modules.args[n] = t
end

------------------------------------------------------------------------------------------------------
-- Register configuration options with the global modules options table
------------------------------------------------------------------------------------------------------
function Cryolysis3:RegisterConfigOptions(n, t)
	Cryolysis3.options.args.modules.args[n] = t
end

------------------------------------------------------------------------------------------------------
-- Remove options from the global modules options table
------------------------------------------------------------------------------------------------------
function Cryolysis3:RemoveConfigOptions(n)
	Cryolysis3.options.args.modules.args[n] = {}
end


-- Setup a core of functions unique to every module.  These will be passed to every NewModule call.
local base = {}


------------------------------------------------------------------------------------------------------
-- Register options with the global modules options table
------------------------------------------------------------------------------------------------------
function base:RegisterOptions(opt)
	Cryolysis3:RegisterOptions(self:GetName(), opt)
end

------------------------------------------------------------------------------------------------------
-- Register configuration options with the global modules options table
------------------------------------------------------------------------------------------------------
function base:RegisterConfigOptions(opt)
	Cryolysis3:RegisterConfigOptions(self:GetName().."options", opt)
end

------------------------------------------------------------------------------------------------------
-- Remove options from the global modules options table
------------------------------------------------------------------------------------------------------
function base:RemoveConfigOptions()
	Cryolysis3:RemoveConfigOptions(self:GetName().."options")
end


-- Pass Cryolysis3.ModuleCore to NewModule calls i.e. NewModule(name, Cryolysis3.ModuleCore ... )
Cryolysis3.ModuleCore = base