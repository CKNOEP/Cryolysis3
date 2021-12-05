------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;
local L = LibStub("AceLocale-3.0"):GetLocale("Cryolysis3");


------------------------------------------------------------------------------------------------------
-- Wrapper function to create a button with less parameters
------------------------------------------------------------------------------------------------------
function Cryolysis3:CreateButton(name, parentFrame, texture, buttonType)
	local template;
	if (buttonType == "menuButton") then
		template = "SecureHandlerClickTemplate";
	else
		template = "SecureActionButtonTemplate";
	end
	-- Create the button frame
	local frame = Cryolysis3:CreateFrame(
		"Button", name, parentFrame, template, 34, 34, true,
		texture, 22, 22,
		"Interface\\AddOns\\Cryolysis3\\textures\\nohighlight",
		"Interface\\AddOns\\Cryolysis3\\textures\\highlight",
		false
	);
	
	if (buttonType == "menuButton") then
		-- Do growth positioning
		Cryolysis3:PositionMenuItems(name, Cryolysis3.db.char.menuButtonGrowth[name])
	
		frame:Execute( [[MenuButtons = table.new(self:GetChildren())]] )
		frame:SetAttribute("_onclick", [[
			if menuOpen then
				menuOpen = false
				for i, child in ipairs(MenuButtons) do
				       child:Hide()
				  end
			else
				menuOpen = true;
				for i, child in ipairs(MenuButtons) do
					child:Show()
				end
			end]]
		);
	end
	
	local found = false;
	for k, v in pairs(Cryolysis3.db.char.buttons) do
		if (Cryolysis3.db.char.buttons[k] == name) then
			found = true;
		end
	end

	if (not found) then
		-- Insert the button name in the table of buttons
		table.insert(Cryolysis3.db.char.buttons, name);		
	end
	
	-- Register the button for clicks
	local button = getglobal("Cryolysis3"..name);
	button:RegisterForDrag("LeftButton");
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp");

	if (Cryolysis3.db.char.hidden[name] == true) then
		-- This button is supposed to be hidden
		button:Hide();
	end

	-- Add the Drag Start and Drag Stop scripts (temp disabled)
	Cryolysis3:AddScript(name, "button", "OnDragStart");
	Cryolysis3:AddScript(name, "button", "OnDragStop")

	-- Handle button tooltip
	Cryolysis3:AddScript(name, "button", "OnEnter");
	Cryolysis3:AddScript(name, "button", "OnLeave");
	
	-- Initialize button text if it's nil
	if (Cryolysis3.db.char.buttonText[name] == "") then
		Cryolysis3.db.char.buttonText[name] = nil;
	end
	
end

------------------------------------------------------------------------------------------------------
-- Function to determine menu button position
------------------------------------------------------------------------------------------------------
function Cryolysis3:PositionMenuItems(name, direction)

	-- direction values represent compass values, starting at north and going clockwise
	-- If direction is nil, set it to right.
	if direction == nil then
		direction = 2;
		Cryolysis3.db.char.menuButtonGrowth[name] = 2;
	end

	local button;
	local frame = getglobal("Cryolysis3"..name);
	local x,y, xOffset, yOffset;
	
	if direction == 1 then
		x = 0;
		y = 33;
		xOffset = 0;
		yOffset = 33;
	elseif direction == 2 then
		x = 33;
		y = 0;
		xOffset = 33;
		yOffset = 0;
	elseif direction == 3 then
		x = 0;
		y = -33;
		xOffset = 0;
		yOffset = -33;
	else
		x = -33;
		y = 0;
		xOffset = -33;
		yOffset = 0;
	end

	for i, buttonName in ipairs(Cryolysis3.db.char.menuButtons[name]) do
		button = getglobal("Cryolysis3"..buttonName);
		if (button ~= nil) then
			button:SetParent(frame);
			button:ClearAllPoints();
			button:SetPoint("CENTER", frame, "CENTER", x, y);
			x = x + xOffset;
			y = y + yOffset;
		end
	end

end

------------------------------------------------------------------------------------------------------
-- Wrapper function to create a menu item button with less parameters
------------------------------------------------------------------------------------------------------
function Cryolysis3:CreateMenuItemButton(name, parentFrame, texture, menuType)
	-- Create the button frame
	Cryolysis3:CreateFrame(
		"Button", name, parentFrame, "SecureActionButtonTemplate", 40, 40, true,
		texture, 26, 26,
		"Interface\\AddOns\\Cryolysis3\\textures\\nohighlight",
		"Interface\\AddOns\\Cryolysis3\\textures\\highlight",
		true
	);
	

	if (Cryolysis3.db.char.menuButtons == nil) then
		Cryolysis3.db.char.menuButtons = {};
	end

	if (Cryolysis3.db.char.menuButtons[menuType] == nil) then
		Cryolysis3.db.char.menuButtons[menuType] = {};
	end

	local found = false;
	for k, v in pairs(Cryolysis3.db.char.menuButtons[menuType]) do
		if (Cryolysis3.db.char.menuButtons[menuType][k] == name) then
			found = true;
		end
	end

	if (not found) then
		-- Insert the button name in the table of buttons
		table.insert(Cryolysis3.db.char.menuButtons[menuType], name);
	end
	
	-- Register the button for clicks
	local button = getglobal("Cryolysis3"..name);
	button:RegisterForDrag("LeftButton");
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp");

	if (Cryolysis3.db.char.hidden[name] == true) then
		-- This button is supposed to be hidden
		button:Hide();
	end

	-- Add the Drag Start and Drag Stop scripts (temp disabled)
	Cryolysis3:AddScript(name, "button", "OnDragStart");
	Cryolysis3:AddScript(name, "button", "OnDragStop")

	-- Handle button tooltip
	Cryolysis3:AddScript(name, "button", "OnEnter");
	Cryolysis3:AddScript(name, "button", "OnLeave");
	
	-- Try this :p
	button:ClearAllPoints();
	button:SetPoint("CENTER", parentFrame, "CENTER", 33, 0);
end

------------------------------------------------------------------------------------------------------
-- Create the three custom buttons if we have them enabled
------------------------------------------------------------------------------------------------------
function Cryolysis3:CreateCustomButtons()
	for i = 1, 3, 1 do
		Cryolysis3:CreateButton("CustomButton"..i, UIParent);
		
		-- Set this tooltip to be dynamically generated
		Cryolysis3.Private.tooltips["CustomButton"..i] = true;

		if (Cryolysis3.db.char.scale.button == nil) then
			-- Set the scale array for buttons
			Cryolysis3.db.char.scale.button = {};
		end
		
		if (Cryolysis3.db.char.scale.button["CustomButton"..i] == nil) then
			-- Set the scale of the newly created button if not set
			Cryolysis3.db.char.scale.button["CustomButton"..i] = 1;
		end
		
		-- Set the scale of the newly created button
		--local f = getglobal("Cryolysis3CustomButton"..i);
		--f:SetScale(Cryolysis3.db.char.scale.button["CustomButton"..i]);
				
		-- Update all button attributes
		Cryolysis3:UpdateAllButtonAttributes("CustomButton"..i);
	end
end

------------------------------------------------------------------------------------------------------
-- Moves the button up the array by 1 spot
-- button = a string
------------------------------------------------------------------------------------------------------
function Cryolysis3:IncrementButton(button)
	local buttonswap;
	local buttonIndex;

	for i = 1, #(Cryolysis3.db.char.buttons), 1 do
		if (Cryolysis3.db.char.buttons[i] == button) then
			-- This is the button we want to update
			buttonIndex = i;
			break;
		end
	end

	if (buttonIndex == nil) then
		-- Dunno how the hell this would happen, but meh
		buttonIndex = #(Cryolysis3.db.char.buttons);
	end
	
	if (buttonIndex < #(Cryolysis3.db.char.buttons)) then
		-- Swap with button right before this one
		buttonswap = Cryolysis3.db.char.buttons[buttonIndex + 1]
		Cryolysis3.db.char.buttons[buttonIndex + 1] = Cryolysis3.db.char.buttons[buttonIndex];
		Cryolysis3.db.char.buttons[buttonIndex] = buttonswap;

	elseif (buttonIndex == #(Cryolysis3.db.char.buttons)) then
		-- Swap with first button
		buttonswap = Cryolysis3.db.char.buttons[1];
		Cryolysis3.db.char.buttons[1] = Cryolysis3.db.char.buttons[buttonIndex];
		Cryolysis3.db.char.buttons[buttonIndex] = buttonswap;
	end
	
	-- Finally, update our positions
	Cryolysis3:UpdateAllButtonPositions();
end

------------------------------------------------------------------------------------------------------
-- Wrapper function to create a button with less parameters
------------------------------------------------------------------------------------------------------
function Cryolysis3:UpdateAllButtonPositions()
	-- Begin nil checks
	if Cryolysis3.db.char.scale.frame == nil then
		-- Set the scale array for frames
		Cryolysis3.db.char.scale.frame = {};
	end
	
	if Cryolysis3.db.char.scale.button == nil then
		-- Set the scale array for buttons
		Cryolysis3.db.char.scale.button = {};
	end
	
	if Cryolysis3.db.char.scale.frame["Sphere"] == nil then
		-- Set the scale of the sphere
		Cryolysis3.db.char.scale.frame["Sphere"] = 1;
	end
	
	-- Set the scale locals
	local sphereScale = Cryolysis3.db.char.scale.frame["Sphere"];
	local indexScale = -18;
	local NBRScale = 1.1 --(1 + (sphereScale - .85))
	
	--[[
		Here be dragons.
	
 	if sphereScale <= Cryolysis3.db.char.buttonScale then
 		NBRScale = 1.1
 	end
	]]
	
	Cryolysis3:UpdateScale("frame", "Sphere", sphereScale)
	
	for k, v in pairs(Cryolysis3.db.char.buttons) do
		local f = getglobal("Cryolysis3"..v);
		if (f ~= nil) then
		
			-- Set the scale of the buttons if not saved
			if Cryolysis3.db.char.scale.button[v] == nil then
				-- Set the scale of the sphere
				Cryolysis3.db.char.scale.button[v] = 1;
			end
			
			Cryolysis3:UpdateScale("button", v, Cryolysis3.db.char.scale.button[v])
		
			if (Cryolysis3.db.char.lockButtons) then
				f:ClearAllPoints();
				f:SetPoint(
					"CENTER", "Cryolysis3Sphere", "CENTER", 
					((40 * NBRScale) * cos(Cryolysis3.db.char.angle - indexScale)),
					((40 * NBRScale) * sin(Cryolysis3.db.char.angle - indexScale))
				);
			end
			
			indexScale = indexScale + 36;
		end
	end
end

------------------------------------------------------------------------------------------------------
-- Wrapper function to make updating button attributes easier
--	button		string referring to the button name without it's prefix
------------------------------------------------------------------------------------------------------
function Cryolysis3:UpdateAllButtonAttributes(button)
	-- Update all the attributes for this button
	Cryolysis3:UpdateButton(button, "left");
	Cryolysis3:UpdateButton(button, "right");
	Cryolysis3:UpdateButton(button, "middle");
end

------------------------------------------------------------------------------------------------------
-- Wrapper function to make updating button attributes easier
--	button		string referring to the button name without it's prefix
--	click		"left" or "right" or "middle"
--	clearAttributes	Whether or not we are updating middle click button
------------------------------------------------------------------------------------------------------
function Cryolysis3:UpdateButton(button, click)
	if (InCombatLockdown()) then  -- You can't set button attributes in-combat
		return false;
	end
	
	-- Get the action name based on parameters
	local actionType	= Cryolysis3.db.char.buttonTypes[button];
	
	if (click == "middle") then
		-- Clear out the 3 attributes if we're changing middle click
		Cryolysis3:SetAttribute(button, "alt",		click, actionType, "");
		Cryolysis3:SetAttribute(button, "shift",	click, actionType, "");
		Cryolysis3:SetAttribute(button, "ctrl",		click, actionType, "");
	end

	if ( Cryolysis3.db.char.buttonFunctions[button] == nil) then
		return false;
	end

	if (Cryolysis3.db.char.buttonFunctions[button][click] == nil) then
		return false;
	end
	
	-- Set the true middle click key to the true action
	Cryolysis3:SetAttribute(button, Cryolysis3.db.char.middleKey, click, actionType, Cryolysis3.db.char.buttonFunctions[button][click]);
end

------------------------------------------------------------------------------------------------------
-- Wrapper function to make setting button attributes easier
--	button		string referring to the button name without it's prefix
--	modifier	"none" or "all" or "shift" or "ctrl" or "alt"
--	click		"left" or "right" or "middle"
--	actionType	"spell" or "item" or "macro" or "macrotext"
--	action		what this button is supposed to execute on click
------------------------------------------------------------------------------------------------------
function Cryolysis3:SetAttribute(button, modifier, click, actionType, action)
	if (InCombatLockdown()) then  -- You can't set button attributes in-combat
		return false;
	end
	--print (button, modifier, click, actionType, action)
	-- Get the button and set the attribute, return with an error if it doesn't exist
	local b = _G["Cryolysis3"..button];
	local t = _G["Cryolysis3"..button.."Icon"];
	
	if (b == nil) then
		Cryolysis3:Print("Button in :SetAttribute("..button..") could not be found.");
		return false;
	end
	
	-- Handle translation of the click from English to WoW API
	if (click == "left") then
		click = "1";
		
	elseif (click == "right") then
		click = "2";
		
	elseif (click == "middle") then
		click = "3";
		
	else
		Cryolysis3:Print("Invalid click passed to :SetAttribute().");
		return false;
	end
	
	-- Handle translation of the modifier from English to WoW API
	if (modifier == "all") then
		modifier = "*";
		
	elseif (modifier == "none") then
		modifier = "";
		
	else
		modifier = modifier.."-";
	end
	
	if (actionType == nil) then
		actionType = "item";
	end

	if (actionType == "macrotext") then
		-- Because macrotext wants to be macro type
		b:SetAttribute("*type*", "macro");
	else
		-- Set the global type
		b:SetAttribute("*type*", actionType);
	end


	
	if (action == nil or action == "") then
		if (button ~= "Sphere") then
			if (tonumber(click) == 1) then
				-- Blank texture
				t:SetTexture(nil);
			end
		end
		
		-- Set the attribute for regular click
		b:SetAttribute(actionType..click, action);
		b:SetAttribute(modifier..actionType.."*", action);
	else
		-- Define the name of the action we're performing and the texture to be used
		local actionName	= action;
		local texture		= nil;
		
		if (actionType == "spell") then
			actionName, _, texture = GetSpellInfo(action);			
			
		elseif (actionType == "item") then
			actionName, _, _, _, _, _, _, _, _, texture = GetItemInfo(action);
			
		elseif (actionType == "macro") then
			ID = GetMacroIndexByName(action);
			if (ID > 0) then
				-- Grab the texture and set the name
				texture = select(2, GetMacroInfo(ID));
				actionName = action;
			else
				Cryolysis3:Print(L["Invalid name, please check your spelling and try again!"]);
			end
		end
		
		if (actionName == nil) then
			return false;
		end
		
		if (button ~= "Sphere") then
			if (tonumber(click) == 1) then
				-- Left click dictates texture
				t:SetTexture(texture);
			end
		end
		
		-- Set our attributes
		b:SetAttribute(actionType..click, actionName);
		b:SetAttribute(modifier..actionType.."*", actionName);
	end
end

------------------------------------------------------------------------------------------------------
-- Wrapper function to update middle key functionality of all buttons
------------------------------------------------------------------------------------------------------
function Cryolysis3:ChangeMiddleKey()
	-- Goes through all buttons we have available and sets their middle attribute
	for k, v in pairs(Cryolysis3.db.char.buttons) do
		Cryolysis3:UpdateButton(v, "middle", true);
	end
end

------------------------------------------------------------------------------------------------------
-- Builds tooltip and button functions
------------------------------------------------------------------------------------------------------
function Cryolysis3:PrepareButton(menuType, name, buttonType, title, left, right, middle)
	local tooltip = {};
	local action;

	if (type(title) == "number") then
		title = Cryolysis3.spellCache[title].name
	end
	table.insert(tooltip, title);

	-- Set button functions
	Cryolysis3.db.char.buttonFunctions[menuType..name] = {};
	Cryolysis3.db.char.buttonTypes[menuType..name] = buttonType;

	if (buttonType == "spell") then
		-- We're casting a spell
		action = L["cast"];

		if (Cryolysis3:HasSpell(left)) then
			Cryolysis3.db.char.buttonFunctions[menuType..name].left = left;
			
			if (type(left) == "number") then
				left = Cryolysis3.spellCache[left].name;
			end
			table.insert(tooltip, string.format(L["%s click to %s: %s"], L["Left"],	action, left));
		end
		
		if (Cryolysis3:HasSpell(right)) then
			Cryolysis3.db.char.buttonFunctions[menuType..name].right = right;
			
			if (type(right) == "number") then
				right = Cryolysis3.spellCache[right].name;
			end
			table.insert(tooltip, string.format(L["%s click to %s: %s"], L["Right"], action, right));
		end
		
		if (Cryolysis3:HasSpell(middle)) then
			Cryolysis3.db.char.buttonFunctions[menuType..name].middle = middle;
			
			if (type(middle) == "number") then
				middle = Cryolysis3.spellCache[middle].name;
			end
			table.insert(tooltip, string.format(L["%s click to %s: %s"], L["Middle"], action, middle));
		end
	else
		-- We're using an item
		action = L["use"];

		-- Code for checking if item exists in inventory goes here
	end
	

	return tooltip;
end

------------------------------------------------------------------------------------------------------
-- Wrapper function to update middle key functionality of all buttons
------------------------------------------------------------------------------------------------------
function Cryolysis3:AddMenuItem(menuType, name, icon, tooltip)
	-- Create the button
	Cryolysis3:CreateMenuItemButton(menuType..name, UIParent, icon, menuType);

	if (tooltip == nil) then
		return false;
	end
	
	-- Add the tooltip for this button
	Cryolysis3.Private.tooltips[menuType..name] = {};
	
	for i = 1, #(tooltip), 1 do
		-- Add the tooltip to the array
		table.insert(Cryolysis3.Private.tooltips[menuType..name],	tooltip[i]);

		if (i == 2) then
			-- Add left click functionality
			Cryolysis3:UpdateButton(menuType..name, "left");
		elseif (i == 3) then
			-- Add right click functionality
			Cryolysis3:UpdateButton(menuType..name, "right");
		elseif (i == 4) then
			-- Add middle click functionality
			Cryolysis3:UpdateButton(menuType..name, "middle");
		end
	end
end

------------------------------------------------------------------------------------------------------
-- Function to update the scale of a button or frame
------------------------------------------------------------------------------------------------------
function Cryolysis3:UpdateScale(frameType, name, value)

	Cryolysis3:SaveAnchorPosition(frameType, name);
	local f = getglobal("Cryolysis3"..name)
	f:SetScale(value)
	Cryolysis3:LoadAnchorPosition(frameType, name);

end