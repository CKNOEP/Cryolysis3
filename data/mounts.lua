------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;
local L = LibStub("AceLocale-3.0"):GetLocale("Cryolysis3");




local list_mount = {
--slow Ground
    29221, 8632, 28481, 29743, 29744, 8629, 29222, 5656, 2411, 5665, 15277, 5655,
    28927, 29220, 8631, 2414, 33224, 1132, 13331, 8588, 5864, 12327, 5668, 8591,
    13333, 13332, 5872, 15290, 33976, 8592, 12325, 12326, 8595, 5873, 8563,
    13322, 13321, 13325, 37827, 13324, 13323,

--Fast Ground
    35906, 34129, 19029, 29471, 29472, 19030, 13086, 29468, 29466, 29467, 29469,
    29470, 35513, 33225, 29465, 19902, 18766, 29223, 29745, 18242, 29746, 13335,
    28936, 18902, 29224, 18767, 29747, 37012, 18246, 18790, 18776, 18778, 18797,
    12303, 18789, 18793, 19872, 18798, 13334, 18777, 18791, 29103, 37828, 18245,
    18796, 12302, 18785, 18795, 37719, 29228, 18788, 18248, 18773, 18794, 29229,
    38576, 31830, 13317, 18241, 18772, 18787, 12353, 8586, 31829, 37598, 12330,
    18768, 28915, 18786, 31835, 18247, 29227, 18243, 18244, 12351, 12351, 28482,
    13329, 33977, 12354, 13327, 31832, 13326, 29104, 15293, 15292, 23193, 31831,
    31836, 13328, 18774, 29102, 29105, 29230, 29231, 31833, 31834, 32768, 30480,
    33809, 37011,

--Slow Flying
    34060, 25470, 25472, 25471, 25474, 25475, 25476, 35225,

--Fast Flying
    32458, 34061, 33999, 30609, 34092, 32858, 37676, 32857, 25473, 35226, 32319,
    25533, 32317, 32859, 32860, 25477, 25529, 32316, 32314, 32861, 25527, 32862,
    25531, 32318, 25528, 25532, 37011
}

------------------------------------------------------------------------------------------------------
-- Function to find all mounts in our inventory
------------------------------------------------------------------------------------------------------
function Cryolysis3:DetectMounts()
	local name, link, mountID;
	local mounts = {};



    -- check for mounts in bags	
	 for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, GetContainerNumSlots(bag) do
            item = GetContainerItemID(bag, slot)
            if item ~= nil then
                itype = select(3, GetItemInfoInstant(item))
                itypeID = select(6, GetItemInfoInstant(item))
				isubtypeID = select(7, GetItemInfoInstant(item))
				
				if (itypeID == 15 and isubtypeID == 5)  then
                    name = select(1, GetItemInfo(item))
                    link = select(2, GetItemInfo(item))  
						if (not Cryolysis3.db.char.silentMode) then
							-- Only print this if we're not in silent mode
							Cryolysis3:Print(L["Found Mount: "]..link);
						end
	
						if (Cryolysis3.db.char.chosenMount["normal"] == nil) then
							-- Default to this mount chosen
							Cryolysis3.db.char.chosenMount["normal"] = item;
						end
						
						if (Cryolysis3.db.char.chosenMount["flying"] == nil) then
							-- Default to this mount chosen
							Cryolysis3.db.char.chosenMount["normal"] = item;
						end
						
						-- Add it to our array of found mounts
						mounts[name] = name;			
								
				
				
				end
            end
			
         end
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
		string.format("#showtooltip "..hs.."\n%s", macro)
	};

	if (GetMacroIndexByName(Cryolysis3.Private.macroName) ~= 0) then
		EditMacro(GetMacroIndexByName(Cryolysis3.Private.macroName),Cryolysis3.Private.macroName,134414,macro);
	elseif ((GetNumMacros()) < 36) then
		CreateMacro("Cryo3",134414,macro);
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
