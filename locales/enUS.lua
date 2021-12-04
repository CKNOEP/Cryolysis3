--[[
	English locale needs no translation, durr!
]]

------------------------------------------------------------------------------------------------------
-- Setup the locale library
------------------------------------------------------------------------------------------------------
local L = LibStub("AceLocale-3.0"):NewLocale("Cryolysis3", "enUS", true);


------------------------------------------------------------------------------------------------------
-- LoD (Load on Demand) error strings
------------------------------------------------------------------------------------------------------
L["Cryolysis 3 cannot load the module:"] = true;

L["The module is flagged as Disabled in the Blizzard AddOn interface."] = true;
L["The module is missing. Please close the game and install it."] = true;
L["The module is too old. Please close the game and update it."] = true;
L["Cryolysis 3 is currently adding items to your game's item cache.  The addon should finish loading and this dialog box should disappear once this is complete."] = true;

L["Okay"] = true;


------------------------------------------------------------------------------------------------------
-- Common messages
------------------------------------------------------------------------------------------------------
L["Found Mount: "] = true;


------------------------------------------------------------------------------------------------------
-- Tooltips
------------------------------------------------------------------------------------------------------
L["Mount"] = true;
	-- Mount button locales
	L["Left click to Hearthstone to "] = true;
	L["Left click to use "] = true;
	L["Right click to use "] = true;
	L["You are not in a flyable area and you have no selected ground mount."] = true;
	L["You have no usable mounts and no hearthstone."] = true;
	L["Right click to Hearthstone to "] = true;
	L["Middle click to Hearthstone to "] = true;

L["Custom Button"] = true;
	-- Custom button locales
	L["No actions assigned to this button."] = true;
	L["You can assign an action to this button using the Cryolysis menu."] = true;
	L["Left"] = true;	-- For use in bottom most translation
	L["Right"] = true;	-- For use in bottom most translation
	L["Middle"] = true;	-- For use in bottom most translation
	L["cast"] = true;	-- Lower case intended (For use in bottom most translation)
	L["use"] = true;	-- Lower case intended (For use in bottom most translation)
	L["%s click to %s: %s"] = true;

------------------------------------------------------------------------------------------------------
-- Slash command locales
------------------------------------------------------------------------------------------------------
L["Show Menu"] = true;
L["Open the configuration menu."] = true;


------------------------------------------------------------------------------------------------------
-- Options
------------------------------------------------------------------------------------------------------
L["Cryolysis"] = true;
L["Cryolysis 3 is an all-purpose sphere AddOn."] = true;

-- General Options
L["General Settings"] = true;
L["Adjust various settings for Cryolysis 3."] = true;
L["Lock Sphere and Buttons"] = true;
L["Lock the main sphere and buttons so they can't be moved."] = true;
L["Constrict Buttons to Sphere"] = true;
L["Lock the buttons in place around the main sphere."] = true;
L["Hide Tooltips"] = true;
L["Hide the main sphere and button tooltips."] = true;
L["Silent Mode"] = true;
L["Hide the information messages on AddOn/module load/disable."] = true;
L["Sphere Skin"] = true;
L["Choose the skin displayed by the Cryolysis sphere."] = true;
L["Outer Sphere Skin Behavior"] = true;
L["Choose how fast you want the outer sphere skin to deplete/replenish."] = true;
L["Slow"] = true;
L["Fast"] = true;

-- Button Options
L["Button Settings"] = true;
L["Adjust various settings for each button."] = true;
L["Up"] = true;
L["Right"] = true;
L["Down"] = true;
L["Left"] = true;
L["Growth Direction"] = true;
L["Adjust which way this menu grows"] = true;
L["Show Item Count"] = true;
L["Display the item count on this button"] = true;

-- Middle Click functionality
L["Middle-Click Key"] = true;
L["Adjusts the key used as an alternative to a middle click."] = true;
L["Alt"] = true;
L["Shift"] = true;
L["Ctrl"] = true;

	-- Main Sphere sub-options
	L["Main Sphere"] = true;
	L["Adjust various settings for the main sphere."] = true;
	L["Show or hide the main sphere."] = true;
	L["Scale the size of the main sphere."] = true;
	
	-- Sphere Text
	L["Sphere Text"] = true;
	L["Adjust what information is displayed on the sphere."] = true;
	L["Nothing"] = true;
	L["Current Health"] = true;
	L["Health %"] = true;
	L["Current Mana/Energy/Rage"] = true;
	L["Mana/Energy/Rage %"] = true;
	
	-- Outer Sphere
	L["Outer Sphere"] = true;
	L["Adjust what information is displayed using the outer sphere."] = true;
	L["Health"] = true;
	L["Mana"] = true;

	-- Custom Button locales
	L["First Custom Button"] = true;
	L["Second Custom Button"] = true;
	L["Third Custom Button"] = true;
	L["Hide"] = true;
	L["Show or hide this button."] = true;
	L["Adjust various settings for this button."] = true;
	L["Scale the size of this button."] = true;
	L["Button Type"] = true;
	L["Choose whether this button casts a spell, uses a macro, or uses an item."] = true;
	L["Spell"] = true;
	L["Macro"] = true;
	L["Item"] = true;
	L["Left Click Action"] = true;
	L["Right Click Action"] = true;
	L["Middle Click Action"] = true;
	L["Type in the name of the action that will be cast when left clicking this button."] = true;
	L["Type in the name of the action that will be cast when right clicking this button."] = true;
	L["Type in the name of the action that will be cast when middle clicking this button."] = true;
	L["Enter a spell, macro, or item name and PRESS ENTER. Capitalization matters."] = true;
	L["Move Clockwise"] = true;
	L["Move this button one position clockwise."] = true;
	L["Scale"] = true;

	-- Mount Button locales
	L["Mount Button"] = true;
	L["Button Behavior"] = true;
	L["Manual"] = true;
	L["Automatic"] = true;
	L["Ground Mount"] = true;
	L["Flying Mount"] = true;
	L["Left Click Mount"] = true;
	L["Right Click Mount"] = true;
	L["Re-scan Mounts"] = true;
	L["Click this when you've added new mounts to your bags."] = true;

-- Module Options
L["Modules Options"] = true;
L["Cryolysis allows you to enable and disable parts of it.  This section gives you the ability to do so."] = true;
L["Module"] = true;
L["System"] = true;
L["Loaded"] = true;
L["Unloaded"] = true;
L["Turn this feature off if you don't use it in order to save memory and CPU power."] = true;
L["Adjust various options for this module."] = true;
L["Ready"] = true;
L["minutes"] = true; -- Mind the capitalisation!
L["seconds"] = true; -- Mind the capitalisation!
L["Show Cooldown"] = true;
L["Display the cooldown timer on this button"] = true;

	-- Mage Module Locales
	L["Buff Menu"] = true;
	L["Teleport/Portal"] = true;
	L["Click to open menu."] = true;
	L["Armor"] = true;
	L["Intellect"] = true;
	L["Magic"] = true;
	L["Damage Shields"] = true;
	L["Magical Wards"] = true;
	L["Food Button"] = true;
	L["Water Button"] = true;
	L["Gem Button"] = true;
	
	-- Main Sphere: Mage locales
	L["Conjured Food"] = true;
	L["Conjured Water"] = true;
	
	
	-- Priest Module Locales
	L["Fortitude"] = true;
	L["Spirit"] = true;
	L["Protection"] = true;
	

	-- Message Module Options
	L["Message"] = true;
	L["Chat Channel"] = true;
	L["Choose which chat channel messages are displayed in."] = true;
	L["User"] = true;
	L["Say"] = true;
	L["Party"] = true;
	L["Raid"] = true;
	L["Group"] = true;
	L["World"] = true;


	-- Warning Module Options
	L["Warning"] = true;


	-- Reagent Restocking Module Options
	L["Reagent Restocking"] = true;
	L["Restock all reagents?"] = true;
	L["Yes"] = true;
	L["No"] = true;
	L["Confirm Restocking"] = true;
	L["Pop-up a confirmation box."] = true;
	L["Restocking Overflow"] = true;
	L["If enabled, one extra stack of reagents will be bought in order to bring you above the restock amount. Only works for reagents that are bought from vendor in stacks."] = true;
	L["Adjust the amount of "] = true;
	L[" to restock to."] = true;

-- Profile Options
L["Profile Options"] = true;
L["Cryolysis' saved variables are organized so you can have shared options across all your characters, while having different sets of custom buttons for each.  These options sections allow you to change the saved variable configurations so you can set up per-character options, or even share custom button setups between characters"] = true;
L["Options profile"] = true;
L["Saved profile for Cryolysis 3 options"] = true;


------------------------------------------------------------------------------------------------------
-- Error messages
------------------------------------------------------------------------------------------------------
L["Invalid name, please check your spelling and try again!"] = true;
