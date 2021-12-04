------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local module = Cryolysis3:NewModule("messages", Cryolysis3.ModuleCore)
local L = LibStub("AceLocale-3.0"):GetLocale("Cryolysis3");


------------------------------------------------------------------------------------------------------
-- Function to generate options
------------------------------------------------------------------------------------------------------
function module:CreateOptions()
	-- The option to shut off this module
	local options = {
		type = "toggle",
		name = L["Message"].." "..L["System"],
		desc = L["Turn this feature off if you don't use it in order to save memory and CPU power."],
		width = "full",
		get = function(info) return Cryolysis3.db.char.modules[module:GetName()] end,
		set = function(info, v)
			Cryolysis3.db.char.modules[module:GetName()] = v  
			if v then 
				Cryolysis3:EnableModule(module:GetName())
			else
				Cryolysis3:DisableModule(module:GetName())
			end
		end,
	};

	return options;
end

------------------------------------------------------------------------------------------------------
-- Function to generate configuration options
------------------------------------------------------------------------------------------------------
function module:CreateConfigOptions()
	-- The various configurations this module produces
	local configOptions = {
		
		type = "group",
		name = L["Message"].." "..L["System"],
		desc = L["Adjust various options for this module."],
		args = {
			channel = {
				type = "select",
				name = L["Chat Channel"],
				desc = L["Choose which chat channel messages are displayed in."],
				width = "full",
				get = function(info) return Cryolysis3.db.char.MsgChannel end,
				set = function(info, v) Cryolysis3.db.char.MsgChannel = v end,
				values = {
					["USER"]	= L["User"],
					["SAY"]		= L["Say"],
					["PARTY"]	= L["Party"],
					["RAID"]	= L["Raid"],
					["GROUP"]	= L["Group"],
					["WORLD"]	= L["World"]
				}
			}
		}
	};
	
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
		Cryolysis3:Print(L["Message"].." "..L["System"].." "..L["Loaded"]);
	end
end

------------------------------------------------------------------------------------------------------
-- What happens when the module is disabled
------------------------------------------------------------------------------------------------------
function module:OnDisable()
	-- Get rid of the module options
	module:RemoveConfigOptions();
	
	-- Elvis has left the building
	if (not Cryolysis3.db.char.silentMode) then
		-- Only print this if we're not in silent mode
		Cryolysis3:Print(L["Message"].." "..L["System"].." "..L["Unloaded"]);
	end
end

------------------------------------------------------------------------------------------------------
-- Sends the message to various channels based on the type parameter
------------------------------------------------------------------------------------------------------
function module:AddMessage(msg, chatType)
	if not msg or not chatType then
		return false;
	end

	-- Colorize and parse the message
	msg = module:AddMsgColor(module:ParseMessage(msg));

	if (chatType == "USER") then
		-- Display to self only
		Cryolysis3:Print(msg);
	elseif (chatType == "WORLD") then
		if (GetNumRaidMembers() > 0) then
			-- We're in a raid
			SendChatMessage(msg, "RAID");
		elseif (GetNumPartyMembers() > 0) then
			-- We're only in a group
			SendChatMessage(msg, "PARTY");
		else
			-- We're all alone
			SendChatMessage(msg, "SAY");
		end
	elseif (chatType == "GROUP") then
		if (GetNumRaidMembers() > 0) then
			-- We're in a raid
			SendChatMessage(msg, "RAID");
		elseif (GetNumPartyMembers() > 0) then
			-- We're only in a group
			SendChatMessage(msg, "PARTY");
		end
	elseif (chatType == "PARTY") then
		if (GetNumPartyMembers() > 0) then
			-- We're only in a group
			SendChatMessage(msg, "PARTY");
		end
	elseif (chatType == "RAID") then
		if (GetNumRaidMembers() > 0) then
			-- We're in a raid
			SendChatMessage(msg, "RAID");
		end
	elseif (chatType == "SAY") then
		-- We're all alone
		SendChatMessage(msg, "SAY");
	end
end

------------------------------------------------------------------------------------------------------
-- Allows the user to use color tags <white> and <lightBlue> in the messages.
------------------------------------------------------------------------------------------------------
function module:AddMsgColor(msg)
	
	-- Keep these inside the function so the table isn't sitting in memory when we don't need it
	local colors = {
		["white"]		= "CFFFFFFFF",
		["lightBlue"]		= "CFF99CCFF",
		["brightGreen"]		= "CFF00FF00",
		["lightGreen1"]		= "CFF99FF66",
		["lightGreen2"]		= "CFF66FF66",
		["yellowGreen"]		= "CFFCCFF66",
		["lightYellow"]		= "CFFFFFF66",
		["darkYellow"]		= "CFFFFCC00",
		["lightOrange"]		= "CFFFFCC66",
		["dirtyOrange"]		= "CFFFF9933",
		["darkOrange"]		= "CFFFF6600",
		["redOrange"]		= "CFFFF3300",
		["red"]			= "CFFFF0000",
		["lightRed"]		= "CFFFF5555",
		["lightPurple1"]	= "CFFFFC4FF",
		["lightPurple2"]	= "CFFFF99FF",
		["purple"]		= "CFFFF50FF",
		["darkPurple1"]		= "CFFFF00FF",
		["darkPurple2"]		= "CFFB700B7",
		["close"]		= "r",
		["darkBlue"]		= "C2D59E9FF",
	}
	
	
	for k, v in pairs(colors) do
		-- Go through all tags and replace the text with a colour
		msg = string.gsub(msg, "<"..k..">", "|"..v);
	end
	
	return msg;
end

------------------------------------------------------------------------------------------------------
-- Allows the user to use tags like <target> and <portal> in messages.
------------------------------------------------------------------------------------------------------
function module:ParseMessage(msg, target, portal, mount)
	msg = string.gsub(msg, "<player>", UnitName("player"));
	
	if target then
		msg = string.gsub(msg, "<target>", target);
	end
	
	if portal then
		msg = string.gsub(msg, "<portal>", portal);
	end
	
	if mount then
		msg = string.gsub(msg, "<mount>", mount);
	end
	
	return msg;
end