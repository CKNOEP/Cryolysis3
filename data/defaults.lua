------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;
local L = LibStub("AceLocale-3.0"):GetLocale("Cryolysis3");


------------------------------------------------------------------------------------------------------
-- The defaults array
------------------------------------------------------------------------------------------------------
Cryolysis3.defaults = {
	char = {
		-- Single values
		angle			= 180,			-- The angle of the buttons
		lockSphere		= false,		-- Lock everything in place
		lockButtons		= true,			-- Lock the buttons to the main sphere. (Keep them around the outside of the sphere.)
		RestockConfirm		= true,			-- Ask for confirmation before restocking reagents
		restockOverflow		= true,			-- Buy one extra stack when reagents are sold in stacks and missing < stack size.
		MsgChannel		= "GROUP",		-- What channel to put our messages in by default
		outerSphere		= 3,			-- Functionality of the Outer Sphere. 1 = None, 2 = HP, 3 = Mana/Rage/Energy
		skin			= "Blue",		-- The default skin to use
		quietMode		= false,		-- Hide the information messages on load/disable
		HideTooltips		= false,		-- Hide the tooltips on buttons and main sphere
		middleKey		= "ctrl",		-- The default middle click button
		sphereText		= 2,			-- Text to show on the main sphere
		outerSphere		= 3,			-- Outer Sphere function
		outerSphereSkin		= 2,			-- Outer Sphere Stepping
		sphereAttribute		= 2,			-- Sphere Attribute
		
		-- Arrays
		positions		= {},			-- Positions of the frames and buttons
		scale			= {},			-- Scale of the frames and buttons
		hidden			= {},			-- What frames are supposed to be hidden
		buttons			= {},			-- Table of buttons
		buttonText		= {},			-- Table of true/false values to determine displaying of button text
		menuButtons		= {},			-- Table of menu buttons
		menuButtonGrowth	= {};			-- Table to track which direction each menu should grow
		RestockQuantity		= {},			-- All the reagents we want to restock
		modules			= {			-- The modules enabled by default
			["messages"]		= true,		-- Information messages
			["warnings"]		= true,		-- Warning messages
			["reagents"]		= true,		-- Reagent restocking
		},
		buttonTypes		= {			-- The types of the 3 custom buttons
			["CustomButton1"]	= "spell",
			["CustomButton2"]	= "spell",
			["CustomButton3"]	= "spell",
			["Sphere"]		= "spell"
		},
		buttonFunctions		= {			-- What the 3 buttons do
			["CustomButton1"]	= {
				left			= "",
				right			= "",
				middle			= ""
			},
			["CustomButton2"] = {
				left			= "",
				right			= "",
				middle			= ""
			},
			["CustomButton3"] = {
				left			= "",
				right			= "",
				middle			= ""
			},
			["Sphere"] = {
				left			= "",
				right			= "",
				middle			= ""
			}
		},
		chosenMount		= {
			["normal"]			= nil,
			["flying"]			= nil
		},
		mountBehavior 		= 1,
		leftMountText		= L["Left Click Mount"],
		rightMountText 		= L["Right Click Mount"],
	}
}
