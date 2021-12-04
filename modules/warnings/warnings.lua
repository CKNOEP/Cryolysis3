------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local module = Cryolysis3:NewModule("warnings", Cryolysis3.ModuleCore, "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Cryolysis3");


------------------------------------------------------------------------------------------------------
-- Function to generate options
------------------------------------------------------------------------------------------------------
function module:CreateOptions()
	-- The option to shut off this module
	local options = {

		type = "toggle",
		name = L["Warning"].." "..L["System"],
		desc = L["Turn this feature off if you don't use it in order to save memory and CPU power."],
		width = "full",
		get = function(info) return Cryolysis3.db.char.modules[module:GetName()] end,
		set = function(info, v)
			Cryolysis3.db.char.modules[module:GetName()] = v;
			if v then 
				Cryolysis3:EnableModule(module:GetName());
			else 
				Cryolysis3:DisableModule(module:GetName());
			end
		end,
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
		name = L["Warning"].." "..L["System"],
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
	module:RegisterOptions(module:CreateOptions());
end

------------------------------------------------------------------------------------------------------
-- What happens when the module is enabled
------------------------------------------------------------------------------------------------------
function module:OnEnable()
	-- Insert our config options
	module:RegisterConfigOptions(module:CreateConfigOptions())
	
	-- And we're live!
	if (not Cryolysis3.db.char.silentMode) then
		-- Only print this if we're not in silent mode
		Cryolysis3:Print(L["Warning"].." "..L["System"].." "..L["Loaded"]);
	end
end

------------------------------------------------------------------------------------------------------
-- What happens when the module is disabled
------------------------------------------------------------------------------------------------------
function module:OnDisable()
	-- Get rid of the module options
	module:RemoveConfigOptions()
	
	-- Elvis has left the building
	if (not Cryolysis3.db.char.silentMode) then
		-- Only print this if we're not in silent mode
		Cryolysis3:Print(L["Warning"].." "..L["System"].." "..L["Unloaded"]);
	end
end