------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;
local L = LibStub("AceLocale-3.0"):GetLocale("Cryolysis3");


------------------------------------------------------------------------------------------------------
-- Function to find all mounts in our inventory
------------------------------------------------------------------------------------------------------
function Cryolysis3:DetectMounts()
	local name, link, mountID;
	local mounts = {};
	
	for id = 1, GetNumCompanions("MOUNT") do
		mountID = select(3, GetCompanionInfo("MOUNT", id))
		name = GetSpellInfo(mountID);
		link = GetSpellLink(mountID);
		
		if (not Cryolysis3.db.char.silentMode) then
			-- Only print this if we're not in silent mode
			Cryolysis3:Print(L["Found Mount: "]..link);
		end
		
		if (Cryolysis3.db.char.chosenMount["normal"] == nil) then
			-- Default to this mount chosen
			Cryolysis3.db.char.chosenMount["normal"] = name;
		end
		
		if (Cryolysis3.db.char.chosenMount["flying"] == nil) then
			-- Default to this mount chosen
			Cryolysis3.db.char.chosenMount["normal"] = name;
		end
		
		-- Add it to our array of found mounts
		mounts[name] = name;
	end
	
	-- Finally add the found mounts array to the private variable
	Cryolysis3.Private.mounts = mounts;
	mounts = nil;
end	

------------------------------------------------------------------------------------------------------
-- Function to find what mounts we carry/can summon
------------------------------------------------------------------------------------------------------
function Cryolysis3:FindMounts(hasLoaded)
	if (Cryolysis3.db.char.buttonFunctions.MountButton == nil) then
		-- Make sure this is a table
		Cryolysis3.db.char.buttonFunctions.MountButton = {};
	end
	
	if (hasLoaded == nil) then
		-- Create the mount button
		Cryolysis3:CreateButton("MountButton", UIParent);
		Cryolysis3.db.char.buttonTypes["MountButton"] = "macrotext";

		-- Set this tooltip to be dynamically generated
		Cryolysis3.Private.tooltips["MountButton"] = true;
	end

	-- Detect normal and flying mounts
	Cryolysis3:DetectMounts();
	
	-- Shorthand variables
	local chosenNormal = Cryolysis3.db.char.chosenMount["normal"];
	local chosenFlying = Cryolysis3.db.char.chosenMount["flying"];
	
	if (Cryolysis3.Private.mounts[chosenNormal] == nil) then
		-- Our chosen normal no longer exists in bags
		Cryolysis3.db.char.chosenMount["normal"] = nil;
	end
	
	if (Cryolysis3.Private.mounts[chosenFlying] == nil) then
		-- Our chosen flying no longer exists in bags
		Cryolysis3.db.char.chosenMount["flying"] = nil;
	end
	
	-- Update the mount button macro
	Cryolysis3:UpdateMountButtonMacro();

	-- Update the mount attributes
	Cryolysis3:UpdateAllButtonAttributes("MountButton");
	
	-- We have to do it this way to support doing this when we change zones
	Cryolysis3:UpdateMountButtonTexture();
end

------------------------------------------------------------------------------------------------------
-- Function to find what mounts we carry/can summon
------------------------------------------------------------------------------------------------------
function Cryolysis3:UpdateMountButtonMacro()

	local macro = "";
	local hs = GetItemInfo(6948);

	if (Cryolysis3.db.char.mountBehavior == 2) then
		if (Cryolysis3.db.char.chosenMount["normal"] == nil) then
			-- We have no normal mount
			if (Cryolysis3.db.char.chosenMount["flying"] == nil) then
				-- We have neither ground mount nor flying, just set this to use HS
				if hs ~= nil then
					macro = macro.."/cast "..hs;
				end
			else
				-- We have no ground, but we do have a flying mount
				macro = macro.."/cast [flyable] "..Cryolysis3.db.char.chosenMount["flying"];
				if hs ~= nil then
					macro = marco.."; "..hs;
				end
			end
		else
			if (Cryolysis3.db.char.chosenMount["flying"] == nil) then
				-- We have only ground mount
				macro = macro.."/cast "..Cryolysis3.db.char.chosenMount["normal"];
			else
				-- We have both ground and flying
				macro = macro.."/cast [flyable] "..Cryolysis3.db.char.chosenMount["flying"].."; "..Cryolysis3.db.char.chosenMount["normal"];
			end
		end
		
	else
		
		if (Cryolysis3.db.char.chosenMount["normal"] ~= nil and Cryolysis3.db.char.chosenMount["flying"] ~= nil) then
			-- We have both mounts
			macro = macro.."/cast [button:1] "..Cryolysis3.db.char.chosenMount["normal"].."; "..Cryolysis3.db.char.chosenMount["flying"];
		elseif (Cryolysis3.db.char.chosenMount["normal"] == nil and Cryolysis3.db.char.chosenMount["flying"] ~= nil) then
			-- We have no left mount set, but we do have a right mount set
			macro = macro.."/cast [button:2] "..Cryolysis3.db.char.chosenMount["flying"];
			if hs ~= nil then
				macro = macro.."; "..hs;
			end
		elseif (Cryolysis3.db.char.chosenMount["normal"] ~= nil and Cryolysis3.db.char.chosenMount["flying"] == nil) then
			-- We have no right mount set, but we do have a left mount set
			macro = macro.."/cast [button:1] "..Cryolysis3.db.char.chosenMount["normal"];
			if hs ~= nil then
				macro = macro.."; "..hs;
			end
		else
			-- We have no mount, just use the hearthstone (or something went terribly wrong)
			if hs ~= nil then
				macro = macro.."/cast "..hs;
			end
		end
		
	end
	
	local MacroParameters = {
		"Cryo3",
		1,
		string.format("#showtooltip\n%s", macro)
	};

	if (GetMacroIndexByName(Cryolysis3.Private.macroName) ~= 0) then
		EditMacro(Cryolysis3.Private.macroName, unpack(MacroParameters));
	elseif ((GetNumMacros()) < 36) then
		CreateMacro(unpack(MacroParameters));
	else
		Cryolysis3:Print("Too many macros exist, Cryolysis cannot create its macro");
		return false;
	end

	-- Now finally set left button to this macro
	Cryolysis3.db.char.buttonFunctions["MountButton"].left = macro;
	if (Cryolysis3.db.char.mountBehavior == 1) then
		Cryolysis3.db.char.buttonFunctions["MountButton"].right = macro;
	else
		if hs ~= nil then
			Cryolysis3.db.char.buttonFunctions["MountButton"].right = "/cast "..hs;
		end
	end

	-- Set the default right button to the Hearthstone
	if hs ~= nil then
		Cryolysis3.db.char.buttonFunctions["MountButton"].middle = "/cast "..hs;
	end
	
	-- Now update all attributes
	Cryolysis3:UpdateAllButtonAttributes("MountButton");

	-- We have to do it this way to support doing this when we change zones
	Cryolysis3:UpdateMountButtonTexture();
end

------------------------------------------------------------------------------------------------------
-- Update the texture on the mount button
------------------------------------------------------------------------------------------------------
function Cryolysis3:UpdateMountButtonTexture()
	-- Get the texture and the icon object
	local texture = select(2, GetMacroInfo(GetMacroIndexByName(Cryolysis3.Private.macroName)));
	local t = getglobal("Cryolysis3MountButtonIcon");
	
	if (t ~= nil and texture ~= nil) then
		-- Set the texture
		t:SetTexture(texture);
	end
end
