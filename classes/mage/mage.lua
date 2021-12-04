------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;
local module = Cryolysis3:NewModule("MAGE", Cryolysis3.ModuleCore, "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Cryolysis3");
local evocHandle = nil;
local gemHandle = nil;


------------------------------------------------------------------------------------------------------
-- Function to update the cooldown on Evocation
------------------------------------------------------------------------------------------------------
local function UpdateEvocation()
	-- Get cooldown data
	local start, duration, enabled = GetSpellCooldown(Cryolysis3.spellCache[12051].name);
		
	if (duration == 0) then
		-- Spell is not on cooldown
		if (evocHandle ~= nil) then
			-- We had a timer enabled, cancel it
			Cryolysis3:CancelTimer(evocHandle);
			evocHandle = nil;
		end
		
		-- Liven up the button
		Cryolysis3EvocationButton.texture:SetDesaturated(false);
		
		-- Remove text from button
		Cryolysis3EvocationButtonText:SetText(nil);
		
		-- Insert tooltip data saying its ready
		Cryolysis3.Private.tooltips["EvocationButton"][2] = L["Ready"];
	else
		-- Spell is on cooldown
		if (evocHandle == nil) then
			evocHandle = Cryolysis3:ScheduleRepeatingTimer(UpdateEvocation, 1);
		end
		
		-- Gray out the button
		Cryolysis3EvocationButton.texture:SetDesaturated(true);
		
		-- Get timer data
		local timeleft = Cryolysis3:TimerData(start, duration);
		
		if (timeleft.minutes > 0) then
			-- Insert tooltip data with minutes
			Cryolysis3.Private.tooltips["EvocationButton"][2] = timeleft.minutes.." "..L["minutes"]..", "..timeleft.seconds.." "..L["seconds"];
			
			-- If show cooldown is enabled
			if (Cryolysis3.db.char.buttonText["EvocationButton"]) then
				-- Write remaining time on the button
				Cryolysis3EvocationButtonText:SetText(timeleft.minutes..":"..timeleft.seconds);
			else
				--Blank out the text
				Cryolysis3EvocationButtonText:SetText(nil);
			end
		else
			-- Insert tooltip data without minutes
			Cryolysis3.Private.tooltips["EvocationButton"][2] =  timeleft.seconds.." "..L["seconds"];
			
			--If show cooldown is enabled
			if (Cryolysis3.db.char.buttonText["EvocationButton"]) then
				-- Write remaining time on the button			
				Cryolysis3EvocationButtonText:SetText(timeleft.seconds);
			else
				--Blank out the text
				Cryolysis3EvocationButtonText:SetText(nil);
			end
		end
	end
end

------------------------------------------------------------------------------------------------------
-- Function to update the cooldown on Mana Gem
------------------------------------------------------------------------------------------------------
local function UpdateManaGem()
	local start, duration, enabled = GetItemCooldown(Cryolysis3.Private.manaGem)
	if (duration == 0) then
		-- Spell is not on cooldown
		if (gemHandle ~= nil) then
			-- We had a timer enabled, cancel it
			Cryolysis3:CancelTimer(gemHandle);
			gemHandle = nil;
		end
		
		-- Liven up the button
		Cryolysis3GemButton.texture:SetDesaturated(false);
		
		-- Remove text from button
		Cryolysis3GemButtonText:SetText(nil);
		
		-- Insert tooltip data saying its ready
		Cryolysis3.Private.tooltips["GemButton"][4] = L["Ready"];
	else	
		-- Spell is on cooldown
		if (evocHandle == nil) then
			evocHandle = Cryolysis3:ScheduleRepeatingTimer(UpdateManaGem, 1);
		end
		
		-- Gray out the button
		Cryolysis3GemButton.texture:SetDesaturated(true);
		
		-- Get timer data
		local timeleft = Cryolysis3:TimerData(start, duration);
		
		if (timeleft.minutes > 0) then
			-- Insert tooltip data with minutes
			Cryolysis3.Private.tooltips["GemButton"][4] = timeleft.minutes.." "..L["minutes"]..", "..timeleft.seconds.." "..L["seconds"];
			
			-- If show cooldown is enabled
			if (Cryolysis3.db.char.buttonText["GemButton"]) then
				-- Write remaining time on the button
				Cryolysis3GemButtonText:SetText(timeleft.minutes..":"..timeleft.seconds);
			else
				--Blank out the text
				Cryolysis3GemButtonText:SetText(nil);
			end
		else
			-- Insert tooltip data without minutes
			Cryolysis3.Private.tooltips["GemButton"][4] =  timeleft.seconds.." "..L["seconds"];
			
			--If show cooldown is enabled
			if (Cryolysis3.db.char.buttonText["GemButton"]) then
				-- Write remaining time on the button			
				Cryolysis3GemButtonText:SetText(timeleft.seconds);
			else
				--Blank out the text
				Cryolysis3GemButtonText:SetText(nil);
			end
		end
	end
end

------------------------------------------------------------------------------------------------------
-- Function to fetch lookup table to be used in :UpdateItemCount
------------------------------------------------------------------------------------------------------
local function GetLookupTable(name)
	
	-- Lookup table for conjure spell id -> item id
	if (name == "water") then
		return {
			-- Normal ranks of Water
			--[42956] = 43523,--Strudel de manne invoqué
			--[42955] = 43518,
			[27090]	= 22018,--Eau des glaciers invoquée
			[37420]	= 30703,--eau-de-source-des-montagnes-invoquée
			[10140]	= 8079,
			[10139]	= 8078,
			[10138]	= 8077,
			[6127]	= 3772,
			[5506]	= 2136,
			[5505]	= 2288,
			[5504]	= 5350,
		};
		
	elseif (name == "food") then
		return {			
			-- Normal ranks of Food
			--[42956] = 43523,
			--[42955] = 43518,
			[33717]	= 22019,
			[28612]	= 22895,
			[10145]	= 8076,
			[10144]	= 8075,
			[6129]	= 1487,
			[990]	= 1114,
			[597]	= 1113,
			[587]	= 5349,
		};
	elseif (name == "gem") then  --This should be changed to show the number of charges available for mana emerald, but we have to wait for Blizz to add the ItemChargeCount function...:(
		return {
			--[42985]	= 33312,
			[27101]	= 22044,
			[10054]	= 8008,
			[10053]	= 8007,
			[3552]	= 5513,
			[759]	= 5514,
		};
	end	
end

------------------------------------------------------------------------------------------------------
-- Update buttons
------------------------------------------------------------------------------------------------------
local function UpdateItemCount()
	Cryolysis3:UpdateItemCount("BuffButtonSlowFall",	{[130] = 17056});
	Cryolysis3:UpdateItemCount("FoodButton",		GetLookupTable("food"));
	Cryolysis3:UpdateItemCount("WaterButton",		GetLookupTable("water"));
	Cryolysis3:UpdateItemCount("GemButton",			GetLookupTable("gem"), false);
end

------------------------------------------------------------------------------------------------------
-- Update sphere
------------------------------------------------------------------------------------------------------
local function UpdateSphereTooltip()
	Cryolysis3.Private.tooltips["Sphere"][2] = L["Conjured Food"]..": "..(Cryolysis3FoodButtonText:GetText() or 0);
	Cryolysis3.Private.tooltips["Sphere"][3] = L["Conjured Water"]..": "..(Cryolysis3WaterButtonText:GetText() or 0);
	Cryolysis3.Private.tooltips["Sphere"][4] = select(1, GetItemInfo(17020))..": "..(GetItemCount(17020) or 0);
	Cryolysis3.Private.tooltips["Sphere"][5] = select(1, GetItemInfo(17056))..": "..(GetItemCount(17056) or 0);
	Cryolysis3.Private.tooltips["Sphere"][6] = select(1, GetItemInfo(17031))..": "..(GetItemCount(17031) or 0);
	Cryolysis3.Private.tooltips["Sphere"][7] = select(1, GetItemInfo(17032))..": "..(GetItemCount(17032) or 0);
end


------------------------------------------------------------------------------------------------------
-- Function to generate options
------------------------------------------------------------------------------------------------------
function module:CreateOptions()
	-- The option to shut off this module
	local options = {
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
		name = gsub(UnitClass("player"), "^.", function(s) return s:upper() end),
		desc = L["Adjust various options for this module."],
		args = {
			evocationbutton = {
				type = "group",
				name = GetSpellInfo(12051),
				desc = L["Adjust various settings for this button."],
				order = 30,
				args = {
					hideevocationbutton = {
						type = "toggle",
						name = L["Hide"],
						desc = L["Show or hide this button."],
						width = "full",
						get = function(info) return Cryolysis3.db.char.hidden["EvocationButton"] end,
						set = function(info, v)
							Cryolysis3.db.char.hidden["EvocationButton"] = v;
							Cryolysis3:UpdateVisibility();
						end,
						order = 10
					},
					showcooldown = {
						type = "toggle",
						name = L["Show Cooldown"],
						desc = L["Display the cooldown timer on this button"],
						get = function(info) return Cryolysis3.db.char.buttonText["EvocationButton"] end,
						set = function(info, v) Cryolysis3.db.char.buttonText["EvocationButton"] = v end,
						width = "full",
						order = 15
					},
					moveevocationbutton = {
						type = "execute",
						name = L["Move Clockwise"],
						desc = L["Move this button one position clockwise."],
						func = function() Cryolysis3:IncrementButton("EvocationButton"); end,
						order = 20
					},
					scaleevocationbutton = {
						type = "range",
						name = L["Scale"],
						desc = L["Scale the size of this button."],
						width = "full",
						get = function(info) return Cryolysis3.db.char.scale.button["EvocationButton"]; end,
						set = function(info, v) 
							Cryolysis3.db.char.scale.button["EvocationButton"] = v;
							Cryolysis3:UpdateScale("button", "EvocationButton", v)
						end,
						min = .5,
						max = 2,
						step = .1,
						isPercent = true,
						order = 70
					}
				}
			},
			buffbutton = {
				type = "group",
				name = L["Buff Menu"],
				desc = L["Adjust various settings for this button."],
				order = 30,
				args = {
					hidebuffbutton = {
						type = "toggle",
						name = L["Hide"],
						desc = L["Show or hide this button."],
						width = "full",
						get = function(info) return Cryolysis3.db.char.hidden["BuffButton"] end,
						set = function(info, v)
							Cryolysis3.db.char.hidden["BuffButton"] = v;
							Cryolysis3:UpdateVisibility();
						end,
						order = 10
					},
					growth = {
						type = "select",
						name = L["Growth Direction"],
						desc = L["Adjust which way this menu grows"],
						get = function(info) return Cryolysis3.db.char.menuButtonGrowth["BuffButton"] end,
						set = function(info, v) 
							Cryolysis3.db.char.menuButtonGrowth["BuffButton"] = v
							Cryolysis3:PositionMenuItems("BuffButton", v)
						end,
						values = {L["Up"], L["Right"], L["Down"], L["Left"]},
						order = 15
					},
					movebuffbutton = {
						type = "execute",
						name = L["Move Clockwise"],
						desc = L["Move this button one position clockwise."],
						func = function() Cryolysis3:IncrementButton("BuffButton"); end,
						order = 20
					},
					scalebuffbutton = {
						type = "range",
						name = L["Scale"],
						desc = L["Scale the size of this button."],
						width = "full",
						get = function(info) return Cryolysis3.db.char.scale.button["BuffButton"]; end,
						set = function(info, v) 
							Cryolysis3.db.char.scale.button["BuffButton"] = v;
							Cryolysis3:UpdateScale("button", "BuffButton", v)
						end,
						min = .5,
						max = 2,
						step = .1,
						isPercent = true,
						order = 70
					}
				}
			},
			portalbutton = {
				type = "group",
				name = L["Teleport/Portal"],
				desc = L["Adjust various settings for this button."],
				order = 30,
				args = {
					hideportalbutton = {
						type = "toggle",
						name = L["Hide"],
						desc = L["Show or hide this button."],
						width = "full",
						get = function(info) return Cryolysis3.db.char.hidden["PortalButton"] end,
						set = function(info, v)
							Cryolysis3.db.char.hidden["PortalButton"] = v;
							Cryolysis3:UpdateVisibility();
						end,
						order = 10
					},
					growth = {
						type = "select",
						name = L["Growth Direction"],
						desc = L["Adjust which way this menu grows"],
						get = function(info) return Cryolysis3.db.char.menuButtonGrowth["PortalButton"] end,
						set = function(info, v) 
							Cryolysis3.db.char.menuButtonGrowth["PortalButton"] = v
							Cryolysis3:PositionMenuItems("PortalButton", v)
						end,
						values = {L["Up"], L["Right"], L["Down"], L["Left"]},
						order = 15
					},
					moveportalbutton = {
						type = "execute",
						name = L["Move Clockwise"],
						desc = L["Move this button one position clockwise."],
						func = function() Cryolysis3:IncrementButton("PortalButton"); end,
						order = 20
					},
					scaleportalbutton = {
						type = "range",
						name = L["Scale"],
						desc = L["Scale the size of this button."],
						width = "full",
						get = function(info) return Cryolysis3.db.char.scale.button["PortalButton"]; end,
						set = function(info, v) 
							Cryolysis3.db.char.scale.button["PortalButton"] = v;
							Cryolysis3:UpdateScale("button", "PortalButton", v)
						end,
						min = .5,
						max = 2,
						step = .1,
						isPercent = true,
						order = 70
					}
				}
			},
			foodbutton = {
				type = "group",
				name = L["Food Button"],
				desc = L["Adjust various settings for this button."],
				order = 30,
				args = {
					hidefoodbutton = {
						type = "toggle",
						name = L["Hide"],
						desc = L["Show or hide this button."],
						width = "full",
						get = function(info) return Cryolysis3.db.char.hidden["FoodButton"] end,
						set = function(info, v)
							Cryolysis3.db.char.hidden["FoodButton"] = v;
							Cryolysis3:UpdateVisibility();
						end,
						order = 10
					},
					itemcount = {
						type = "toggle",
						name = L["Show Item Count"],
						desc = L["Display the item count on this button"],
						get = function(info) return Cryolysis3.db.char.buttonText["FoodButton"] end,
						set = function(info, v) 
							Cryolysis3.db.char.buttonText["FoodButton"] = v;
							Cryolysis3:UpdateItemCount("FoodButton",	GetLookupTable("food"));
						end,
						width = "full",
						order = 15
					},
					movefoodbutton = {
						type = "execute",
						name = L["Move Clockwise"],
						desc = L["Move this button one position clockwise."],
						func = function() Cryolysis3:IncrementButton("FoodButton"); end,
						order = 20
					},
					scalefoodbutton = {
						type = "range",
						name = L["Scale"],
						desc = L["Scale the size of this button."],
						width = "full",
						get = function(info) return Cryolysis3.db.char.scale.button["FoodButton"]; end,
						set = function(info, v) 
							Cryolysis3.db.char.scale.button["FoodButton"] = v;
							Cryolysis3:UpdateScale("button", "FoodButton", v)
						end,
						min = .5,
						max = 2,
						step = .1,
						isPercent = true,
						order = 70
					}
				}
			},
			waterbutton = {
				type = "group",
				name = L["Water Button"],
				desc = L["Adjust various settings for this button."],
				order = 30,
				args = {
					hidewaterbutton = {
						type = "toggle",
						name = L["Hide"],
						desc = L["Show or hide this button."],
						width = "full",
						get = function(info) return Cryolysis3.db.char.hidden["WaterButton"] end,
						set = function(info, v)
							Cryolysis3.db.char.hidden["WaterButton"] = v;
							Cryolysis3:UpdateVisibility();
						end,
						order = 10
					},
					itemcount = {
						type = "toggle",
						name = L["Show Item Count"],
						desc = L["Display the item count on this button"],
						get = function(info) return Cryolysis3.db.char.buttonText["WaterButton"] end,
						set = function(info, v) 
							Cryolysis3.db.char.buttonText["WaterButton"] = v;
							Cryolysis3:UpdateItemCount("WaterButton",	GetLookupTable("water"));
						end,
						width = "full",
						order = 15
					},
					movewaterbutton = {
						type = "execute",
						name = L["Move Clockwise"],
						desc = L["Move this button one position clockwise."],
						func = function() Cryolysis3:IncrementButton("WaterButton"); end,
						order = 20
					},
					scalewaterbutton = {
						type = "range",
						name = L["Scale"],
						desc = L["Scale the size of this button."],
						width = "full",
						get = function(info) return Cryolysis3.db.char.scale.button["WaterButton"]; end,
						set = function(info, v) 
							Cryolysis3.db.char.scale.button["WaterButton"] = v;
							Cryolysis3:UpdateScale("button", "WaterButton", v)
						end,
						min = .5,
						max = 2,
						step = .1,
						isPercent = true,
						order = 70
					}
				}
			},
			gembutton = {
				type = "group",
				name = L["Gem Button"],
				desc = L["Adjust various settings for this button."],
				order = 30,
				args = {
					hidegembutton = {
						type = "toggle",
						name = L["Hide"],
						desc = L["Show or hide this button."],
						width = "full",
						get = function(info) return Cryolysis3.db.char.hidden["GemButton"] end,
						set = function(info, v)
							Cryolysis3.db.char.hidden["GemButton"] = v;
							Cryolysis3:UpdateVisibility();
						end,
						order = 10
					},
					showcooldown = {
						type = "toggle",
						name = L["Show Cooldown"],
						desc = L["Display the cooldown timer on this button"],
						get = function(info) return Cryolysis3.db.char.buttonText["GemButton"] end,
						set = function(info, v) Cryolysis3.db.char.buttonText["GemButton"] = v end,
						width = "full",
						order = 15
					},
					movegembutton = {
						type = "execute",
						name = L["Move Clockwise"],
						desc = L["Move this button one position clockwise."],
						func = function() Cryolysis3:IncrementButton("GemButton"); end,
						order = 20
					},
					scalegembutton = {
						type = "range",
						name = L["Scale"],
						desc = L["Scale the size of this button."],
						width = "full",
						get = function(info) return Cryolysis3.db.char.scale.button["GemButton"]; end,
						set = function(info, v) 
							Cryolysis3.db.char.scale.button["GemButton"] = v;
							Cryolysis3:UpdateScale("button", "GemButton", v)
						end,
						min = .5,
						max = 2,
						step = .1,
						isPercent = true,
						order = 70
					}
				}
			},
		}
	}
		
	return configOptions;
end

------------------------------------------------------------------------------------------------------
-- What happens when the module is initialised
------------------------------------------------------------------------------------------------------
function module:OnInitialize()
	-- Register our options with the global array
	--module:RegisterOptions(options);
	
	if (select(2,UnitClass("player")) == "MAGE") then
		-- Start table counter
		local i = 1;

		for k, v in pairs(GetLookupTable("water")) do
			-- Add Water items to cache
			Cryolysis3.Private.cacheList[i] = v;
			
			-- Increment our table counter
			i = i + 1;
		end

		for k, v in pairs(GetLookupTable("food")) do
			-- Add Food items to cache
			Cryolysis3.Private.cacheList[i] = v;
			
			-- Increment our table counter
			i = i + 1;
		end

		for k, v in pairs(GetLookupTable("gem")) do
			-- Add Gem items to cache
			Cryolysis3.Private.cacheList[i] = v;
			
			-- Increment our table counter
			i = i + 1;
		end
		
		-- Add static items to the cache
		Cryolysis3.Private.cacheList[i] = 17020; i = i + 1; -- Arcane Powder
		Cryolysis3.Private.cacheList[i] = 17031; i = i + 1; -- Rune of Teleportation
		Cryolysis3.Private.cacheList[i] = 17032; i = i + 1; -- Rune of Portals
		Cryolysis3.Private.cacheList[i] = 17056; i = i + 1; -- Light Feather
	end
end

------------------------------------------------------------------------------------------------------
-- What happens when the module is enabled
------------------------------------------------------------------------------------------------------
function module:OnEnable()	
	-- And we're live!
	-- Set the default skin
	Cryolysis3:SetDefaultSkin("Blue");
	
	-- Create a list of the mage's spells to be cached
	Cryolysis3.spellList = {};
	
	-- Local table of the LPT sets we will be using
	local t = {
		"ClassSpell.Mage.Arcane",
		"ClassSpell.Mage.Fire",
		"ClassSpell.Mage.Frost"
	};
	
	-- Create spellList
	Cryolysis3:PopulateSpellList(t);

	-- Add talent spellds
	--table.insert(Cryolysis3.spellList, 44425); -- Arcane Barrage
	table.insert(Cryolysis3.spellList, 11113); -- Blast Wave
	table.insert(Cryolysis3.spellList, 11958); -- Cold Snap
	table.insert(Cryolysis3.spellList, 11129); -- Combustion
	table.insert(Cryolysis3.spellList, 44572); -- Deep Freeze
	table.insert(Cryolysis3.spellList, 31661); -- Dragon's Breath
	table.insert(Cryolysis3.spellList, 54646); -- Focus Magic
	table.insert(Cryolysis3.spellList, 11426); -- Ice Barrier
	table.insert(Cryolysis3.spellList, 12472); -- Icy Veins
	table.insert(Cryolysis3.spellList, 44457); -- Living Bomb
	table.insert(Cryolysis3.spellList, 11366); -- Pyroblast
	table.insert(Cryolysis3.spellList, 31589); -- Slow
	table.insert(Cryolysis3.spellList, 31687); -- Summon Water Elemental
	
	-- Insert our config options
	module:RegisterConfigOptions(module:CreateConfigOptions());
	
	-- Register our wanted events
	module:RegisterClassEvents();
end

------------------------------------------------------------------------------------------------------
-- What happens when the module is disabled
------------------------------------------------------------------------------------------------------
function module:OnDisable()

end

------------------------------------------------------------------------------------------------------
-- Function for creating a reagent list
------------------------------------------------------------------------------------------------------
function module:CreateReagentList()
	local reagentList = {
		-- Arcane Brilliance and Ritual of Refreshment reagents
		["Arcane Powder"]		= 17020,
		
		-- Teleport reagents
		["Rune of Teleportation"]	= 17031,
		
		-- Portal reagents
		["Rune of Portals"]		= 17032,
	}
	
	-- Check for Arcane Brilliance or Ritual of Refreshment
	if (Cryolysis3:HasSpell(23028) or Cryolysis3:HasSpell(43987)) then
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Arcane Powder"])] == nil) then
			-- Default Arcane Powder restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Arcane Powder"])] = 20;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Arcane Powder"] = reagentList["Arcane Powder"];

		-- We're in need of reagents
		Cryolysis3.Private.hasReagents = true;
	end
	
	-- Check for Teleport
	if (Cryolysis3:HasSpell("Teleport")) then
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Rune of Teleportation"])] == nil) then
			-- Default Rune of Teleportation restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Rune of Teleportation"])] = 10;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Rune of Teleportation"] = reagentList["Rune of Teleportation"];

		-- We're in need of reagents
		Cryolysis3.Private.hasReagents = true;
	end
	
	-- Check for Portal	
	if (Cryolysis3:HasSpell("Portal")) then
		if (Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Rune of Portals"])] == nil) then
			-- Default Rune of Portals restock amount
			Cryolysis3.db.char.RestockQuantity[GetItemInfo(reagentList["Rune of Portals"])] = 10;
		end
		
		-- Add this to our list of restockable reagents
		Cryolysis3.Private.classReagents["Rune of Portals"] = reagentList["Rune of Portals"];

		-- We're in need of reagents
		Cryolysis3.Private.hasReagents = true;
	end	
	
end

------------------------------------------------------------------------------------------------------
-- Function for creating all the buttons used by this class
------------------------------------------------------------------------------------------------------
function module:CreateButtons()
	
	print ('creation button')
	if (Cryolysis3:HasSpell(12051)) then
		-- We has an Evocation, create and set up the button for it
		Cryolysis3:CreateButton("EvocationButton", UIParent, Cryolysis3.spellCache[12051].icon);
		
		-- Start tooltip data
		Cryolysis3.Private.tooltips["EvocationButton"] = {};

		-- Start adding tooltip data
		table.insert(Cryolysis3.Private.tooltips["EvocationButton"], Cryolysis3.spellCache[12051].name);
		
		-- Set Evocation button action
		Cryolysis3.db.char.buttonTypes["EvocationButton"] = "spell";
		Cryolysis3.db.char.buttonFunctions["EvocationButton"] = {};
		Cryolysis3.db.char.buttonFunctions["EvocationButton"]["left"] = 12051;

		-- Update all actions
		Cryolysis3:UpdateButton("EvocationButton", "left");

		-- Update Evocation cooldown
		UpdateEvocation();
	end
	
	-- Lookup table for conjure spell id -> item id
	local foodLookupTable = GetLookupTable("food");
	local waterLookupTable = GetLookupTable("water");
	local gemLookupTable = GetLookupTable("gem");
	
	-- Check for highest rank of food
	local foodID = Cryolysis3:GetHighestRank(foodLookupTable);

	-- Check for highest rank of water
	local waterID = Cryolysis3:GetHighestRank(waterLookupTable, "water");

	-- Check for highest rank of gem
	local gemID = Cryolysis3:GetHighestRank(gemLookupTable);

	if (foodID ~= nil) then
		Cryolysis3:CreateButton("FoodButton",	UIParent,	select(3, GetSpellInfo(foodID)));
		Cryolysis3.Private.tooltips["FoodButton"] = {};
		
		local foodName = GetItemInfo(foodLookupTable[foodID]);
		if (foodName == nil) then
			foodName = Cryolysis3.spellCache[foodID].name;
		end
		table.insert(Cryolysis3.Private.tooltips["FoodButton"],	Cryolysis3.spellCache[foodID].name);
		table.insert(Cryolysis3.Private.tooltips["FoodButton"], string.format(L["%s click to %s: %s"], L["Left"],	L["use"],	foodName));
		table.insert(Cryolysis3.Private.tooltips["FoodButton"], string.format(L["%s click to %s: %s"], L["Right"],	L["cast"],	Cryolysis3.spellCache[foodID].name));
		
		-- Set button functions
		Cryolysis3.db.char.buttonFunctions["FoodButton"] = {};
		Cryolysis3.db.char.buttonTypes["FoodButton"] = "macrotext";
		Cryolysis3.db.char.buttonFunctions["FoodButton"].left = "/use "..foodName;
		Cryolysis3.db.char.buttonFunctions["FoodButton"].right = "/cast "..Cryolysis3.spellCache[foodID].name;
	
		if (Cryolysis3:HasSpell(43987)) then
			table.insert(Cryolysis3.Private.tooltips["FoodButton"], string.format(L["%s click to %s: %s"], L["Middle"],	L["cast"],	Cryolysis3.spellCache[43987].name));
			Cryolysis3.db.char.buttonFunctions["FoodButton"].middle = "/cast "..Cryolysis3.spellCache[43987].name;
		end
		
		Cryolysis3:UpdateAllButtonAttributes("FoodButton");
	end

	if (waterID ~= nil) then
		Cryolysis3:CreateButton("WaterButton",	UIParent,	select(3, GetSpellInfo(waterID)));
		Cryolysis3.Private.tooltips["WaterButton"] = {};
		
		local waterName = GetItemInfo(waterLookupTable[waterID]);
		if (waterName == nil) then
			waterName = Cryolysis3.spellCache[waterID].name;
		end
		table.insert(Cryolysis3.Private.tooltips["WaterButton"], Cryolysis3.spellCache[waterID].name);
		table.insert(Cryolysis3.Private.tooltips["WaterButton"], string.format(L["%s click to %s: %s"], L["Left"],	L["use"],	waterName));
		table.insert(Cryolysis3.Private.tooltips["WaterButton"], string.format(L["%s click to %s: %s"], L["Right"],	L["cast"],	Cryolysis3.spellCache[waterID].name));
		
		-- Set button functions
		Cryolysis3.db.char.buttonFunctions["WaterButton"] = {};
		Cryolysis3.db.char.buttonTypes["WaterButton"] = "macrotext";
		Cryolysis3.db.char.buttonFunctions["WaterButton"].left = "/use "..waterName;
		Cryolysis3.db.char.buttonFunctions["WaterButton"].right = "/cast "..Cryolysis3.spellCache[waterID].name;

		if (Cryolysis3:HasSpell(43987)) then
			table.insert(Cryolysis3.Private.tooltips["WaterButton"], string.format(L["%s click to %s: %s"], L["Middle"],	L["cast"],	Cryolysis3.spellCache[43987].name));
			Cryolysis3.db.char.buttonFunctions["WaterButton"].middle = "/cast "..Cryolysis3.spellCache[43987].name;
		end
		
		Cryolysis3:UpdateAllButtonAttributes("WaterButton");
	end

	if (gemID ~= nil) then
		Cryolysis3.Private.manaGem = gemLookupTable[gemID];

		Cryolysis3:CreateButton("GemButton",	UIParent,	select(3, GetSpellInfo(gemID)));
		Cryolysis3.Private.tooltips["GemButton"] = {};
		
		local gemName = GetItemInfo(gemLookupTable[gemID]);
		if (gemName == nil) then
			gemName = Cryolysis3.spellCache[gemID].name;
		end
		table.insert(Cryolysis3.Private.tooltips["GemButton"], Cryolysis3.spellCache[gemID].name);
		table.insert(Cryolysis3.Private.tooltips["GemButton"], string.format(L["%s click to %s: %s"], L["Left"],	L["use"],	gemName));
		table.insert(Cryolysis3.Private.tooltips["GemButton"], string.format(L["%s click to %s: %s"], L["Right"],	L["cast"],	Cryolysis3.spellCache[gemID].name));
		
		-- Set button functions
		Cryolysis3.db.char.buttonFunctions["GemButton"] = {};
		Cryolysis3.db.char.buttonTypes["GemButton"] = "macrotext";
		Cryolysis3.db.char.buttonFunctions["GemButton"].left = "/use "..gemName;
		Cryolysis3.db.char.buttonFunctions["GemButton"].right = "/cast "..Cryolysis3.spellCache[gemID].name;
		
		Cryolysis3:UpdateAllButtonAttributes("GemButton");
		
		-- Update Mana Gem cooldown
		UpdateManaGem();
	end


	-- Start tooltip data
	Cryolysis3.Private.tooltips["BuffButton"] = {};
	Cryolysis3.Private.tooltips["PortalButton"] = {};
	
	-- Start adding tooltip data
	table.insert(Cryolysis3.Private.tooltips["BuffButton"],		L["Buff Menu"]);
	table.insert(Cryolysis3.Private.tooltips["BuffButton"],		L["Click to open menu."]);
	table.insert(Cryolysis3.Private.tooltips["PortalButton"],	L["Teleport/Portal"]);
	table.insert(Cryolysis3.Private.tooltips["PortalButton"],	L["Click to open menu."]);
	
	local tooltip = {};
	local hasBuff = false;
	local hasTelePort = false;

	-- Buff menu buttons
	if (Cryolysis3:HasSpell(168) or Cryolysis3:HasSpell(7302) or Cryolysis3:HasSpell(6117) or Cryolysis3:HasSpell(30482)) then
		-- (Frost/Ice)/Mage/Molten Armor
		local frostIce = 7302;
		if (Cryolysis3:HasSpell(168) and not Cryolysis3:HasSpell(7302)) then
			-- We have Frost Armor but not Ice Armor
			frostIce = 168;
		end
		tooltip = Cryolysis3:PrepareButton("BuffButton", "Armor", "spell", L["Armor"], frostIce, 6117, 30482);
		Cryolysis3:AddMenuItem("BuffButton", "Armor", select(3, GetSpellInfo(7302)), tooltip);

		hasBuff = true;
	end

	-- Intellect buttons
	if (Cryolysis3:HasSpell(1459) or Cryolysis3:HasSpell(23028)) then
		-- Arcane Intellect/Brilliance
		tooltip = Cryolysis3:PrepareButton("BuffButton", "Intellect", "spell", L["Intellect"], 1459, 23028);
		Cryolysis3:AddMenuItem("BuffButton", "Intellect", select(3, GetSpellInfo(1459)), tooltip);
		
		hasBuff = true;
	end

	-- Dalaran Intellect buttons, included in case people like both
	if (Cryolysis3:HasSpell(61024) or Cryolysis3:HasSpell(61316)) then
		-- Arcane Intellect/Brilliance
		tooltip = Cryolysis3:PrepareButton("BuffButton2", "Intellect2", "spell", L["Intellect"], 61024, 61316);
		Cryolysis3:AddMenuItem("BuffButton2", "Intellect2", select(3, GetSpellInfo(61024)), tooltip);
		
		hasBuff = true;
	end

	-- Magic buttons
	if (Cryolysis3:HasSpell(604) or Cryolysis3:HasSpell(1008)) then
		-- Dampen/Amplify Magic
		tooltip = Cryolysis3:PrepareButton("BuffButton", "Magic", "spell", L["Magic"], 604, 1008);
		Cryolysis3:AddMenuItem("BuffButton", "Magic", select(3, GetSpellInfo(604)), tooltip);

		hasBuff = true;
	end

	-- Damage Shields buttons
	if (Cryolysis3:HasSpell(1463) or Cryolysis3:HasSpell(11426)) then
		-- Mana Shield/Ice Barrier
		tooltip = Cryolysis3:PrepareButton("BuffButton", "Shields", "spell", L["Damage Shields"], 1463, 11426);
		Cryolysis3:AddMenuItem("BuffButton", "Shields", select(3, GetSpellInfo(1463)), tooltip);

		hasBuff = true;
	end

	-- Wards buttons
	if (Cryolysis3:HasSpell(543) or Cryolysis3:HasSpell(6143)) then
		-- Fire/Frost Ward
		tooltip = Cryolysis3:PrepareButton("BuffButton", "Wards", "spell", L["Magical Wards"], 543, 6143);
		Cryolysis3:AddMenuItem("BuffButton", "Wards", select(3, GetSpellInfo(543)), tooltip);

		hasBuff = true;
	end

	-- Remove Curse buttons
	if (Cryolysis3:HasSpell(475)) then
		-- Remove Curse
		tooltip = Cryolysis3:PrepareButton("BuffButton", "Curse", "spell", 475, 475);
		Cryolysis3:AddMenuItem("BuffButton", "Curse", select(3, GetSpellInfo(475)), tooltip);

		hasBuff = true;
	end

	-- Slow Fall buttons
	if (Cryolysis3:HasSpell(130)) then
		-- Slow Fall
		tooltip = Cryolysis3:PrepareButton("BuffButton", "SlowFall", "spell", 130, 130);
		Cryolysis3:AddMenuItem("BuffButton", "SlowFall", select(3, GetSpellInfo(130)), tooltip);
		Cryolysis3.db.char.buttonText["BuffButtonSlowFall"] = true;

		hasBuff = true;
	end

	if (Cryolysis3.Private.englishFaction == "Alliance") then
		if (Cryolysis3:HasSpell(3562) or Cryolysis3:HasSpell(11416)) then
			-- Ironforge
			tooltip = Cryolysis3:PrepareButton("PortalButton", "Ironforge", "spell", 3562, 3562, 11416);
			Cryolysis3:AddMenuItem("PortalButton", "Ironforge", select(3, GetSpellInfo(3562)), tooltip);

			hasTelePort = true;
		end
		
		if (Cryolysis3:HasSpell(3561) or Cryolysis3:HasSpell(10059)) then
			-- Stormwind
			tooltip = Cryolysis3:PrepareButton("PortalButton", "Stormwind", "spell", 3561, 3561, 10059);
			Cryolysis3:AddMenuItem("PortalButton", "Stormwind", select(3, GetSpellInfo(3561)), tooltip);

			hasTelePort = true;
		end
		
		if (Cryolysis3:HasSpell(3565) or Cryolysis3:HasSpell(11419)) then
			-- Darnassus
			tooltip = Cryolysis3:PrepareButton("PortalButton", "Darnassus", "spell", 3565, 3565, 11419);
			Cryolysis3:AddMenuItem("PortalButton", "Darnassus", select(3, GetSpellInfo(3565)), tooltip);

			hasTelePort = true;
		end

		if (Cryolysis3:HasSpell(32271) or Cryolysis3:HasSpell(32266)) then
			-- The Exodar
			tooltip = Cryolysis3:PrepareButton("PortalButton", "TheExodar", "spell", 32271, 32271, 32266);
			Cryolysis3:AddMenuItem("PortalButton", "TheExodar", select(3, GetSpellInfo(32271)), tooltip);

			hasTelePort = true;
		end

		if (Cryolysis3:HasSpell(49359) or Cryolysis3:HasSpell(49360)) then
			-- Theramore
			tooltip = Cryolysis3:PrepareButton("PortalButton", "Theramore", "spell", 49359, 49359, 49360);
			Cryolysis3:AddMenuItem("PortalButton", "Theramore", select(3, GetSpellInfo(49359)), tooltip);

			hasTelePort = true;
		end
		
		if (Cryolysis3:HasSpell(33690) or Cryolysis3:HasSpell(33691)) then
			-- Shattrath
			tooltip = Cryolysis3:PrepareButton("PortalButton", "ShattrathCity", "spell", 33690, 33690, 33691);
			Cryolysis3:AddMenuItem("PortalButton", "ShattrathCity", select(3, GetSpellInfo(33690)), tooltip);
			
			hasTelePort = true;
		end
		
		if (Cryolysis3:HasSpell(53140) or Cryolysis3:HasSpell(53142)) then
			-- Dalaran
			tooltip = Cryolysis3:PrepareButton("PortalButton", "Dalaran", "spell", 53140, 53140, 53142);
			Cryolysis3:AddMenuItem("PortalButton", "Dalaran", select(3, GetSpellInfo(53140)), tooltip);
			
			hasTelePort = true;
		end
	else
		-- Hoard
		if (Cryolysis3:HasSpell(3567) or Cryolysis3:HasSpell(11417)) then
			-- Orgrimmar
			tooltip = Cryolysis3:PrepareButton("PortalButton", "Orgrimmar", "spell", 3567, 3567, 11417);
			Cryolysis3:AddMenuItem("PortalButton", "Orgrimmar", select(3, GetSpellInfo(3567)), tooltip);

			hasTelePort = true;
		end
		
		if (Cryolysis3:HasSpell(3563) or Cryolysis3:HasSpell(11418)) then
			-- Undercity
			tooltip = Cryolysis3:PrepareButton("PortalButton", "Undercity", "spell", 3563, 3563, 11418);
			Cryolysis3:AddMenuItem("PortalButton", "Undercity", select(3, GetSpellInfo(3563)), tooltip);

			hasTelePort = true;
		end
		
		if (Cryolysis3:HasSpell(3566) or Cryolysis3:HasSpell(11420)) then
			-- Thunder Bluff
			tooltip = Cryolysis3:PrepareButton("PortalButton", "ThunderBluff", "spell", 3566, 3566, 11420);
			Cryolysis3:AddMenuItem("PortalButton", "ThunderBluff", select(3, GetSpellInfo(3566)), tooltip);

			hasTelePort = true;
		end
		
		if (Cryolysis3:HasSpell(32272) or Cryolysis3:HasSpell(32267)) then
			-- Silvermoon City
			tooltip = Cryolysis3:PrepareButton("PortalButton", "SilvermoonCity", "spell", 32272, 32272, 32267);
			Cryolysis3:AddMenuItem("PortalButton", "SilvermoonCity", select(3, GetSpellInfo(32272)), tooltip);

			hasTelePort = true;
		end
		
		if (Cryolysis3:HasSpell(49358) or Cryolysis3:HasSpell(49361)) then
			-- Stonard
			tooltip = Cryolysis3:PrepareButton("PortalButton", "Stonard", "spell", 49358, 49358, 49361);
			Cryolysis3:AddMenuItem("PortalButton", "Stonard", select(3, GetSpellInfo(49358)), tooltip);

			hasTelePort = true;
		end
		
		if (Cryolysis3:HasSpell(35715) or Cryolysis3:HasSpell(35717)) then
			-- Shattrath
			tooltip = Cryolysis3:PrepareButton("PortalButton", "ShattrathCity", "spell", 35715, 35715, 35717);
			Cryolysis3:AddMenuItem("PortalButton", "ShattrathCity", select(3, GetSpellInfo(35715)), tooltip);

			hasTelePort = true;
		end
		
		if (Cryolysis3:HasSpell(53140) or Cryolysis3:HasSpell(53142)) then
			-- Dalaran
			tooltip = Cryolysis3:PrepareButton("PortalButton", "Dalaran", "spell", 53140, 53140, 53142);
			Cryolysis3:AddMenuItem("PortalButton", "Dalaran", select(3, GetSpellInfo(53140)), tooltip);
			
			hasTelePort = true;
		end
	end

	-- Create our needed buttons
	if (hasBuff) then
		Cryolysis3:CreateButton("BuffButton",	UIParent,	"Interface\\Icons\\INV_Staff_13", "menuButton");
	end

	if (hasTelePort) then
		Cryolysis3:CreateButton("PortalButton", UIParent,	"Interface\\Icons\\Spell_Nature_AstralRecalGroup", "menuButton");
	end

	-- Update Item Count on buttons
	UpdateItemCount();
	
	-- Update Sphere tooltip
	UpdateSphereTooltip();
end

------------------------------------------------------------------------------------------------------
-- Register for our needed events
------------------------------------------------------------------------------------------------------
function module:RegisterClassEvents()
	-- Events relevant to this class
	--module:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	module:RegisterEvent("BAG_UPDATE");
	module:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
	--module:RegisterEvent("SPELL_UPDATE_COOLDOWN");
	--module:RegisterEvent("UNIT_SPELLCAST_SENT");
	--module:RegisterEvent("TRADE_SHOW");
	--module:RegisterEvent("TRADE_CLOSED");
	module:RegisterEvent("UNIT_MANA");
end

------------------------------------------------------------------------------------------------------
-- Our big bad combat log, this will fire more than Rambo's collected movies
------------------------------------------------------------------------------------------------------
function module:COMBAT_LOG_EVENT_UNFILTERED()

end

------------------------------------------------------------------------------------------------------
-- Whenever something changes in our bags
------------------------------------------------------------------------------------------------------
function module:BAG_UPDATE()
	if (Cryolysis3GemButton ~= nil) then
		-- Start checking for Mana Gem cooldown
		UpdateManaGem();
		
		-- Update Item Count on buttons
		UpdateItemCount();
		
		-- Update Sphere tooltip
		UpdateSphereTooltip();
	end
end

------------------------------------------------------------------------------------------------------
-- Casting.... casting.... YUS! Done!
------------------------------------------------------------------------------------------------------
function module:UNIT_SPELLCAST_SUCCEEDED(info, unit, name, rank)
	if (name == GetSpellInfo(5405)) then
		-- Mana Gem cooldown started
		gemHandle = Cryolysis3:ScheduleRepeatingTimer(UpdateManaGem, 1);
	end

	if (Cryolysis3.spellCache[12051] ~= nil) then
		if (name == Cryolysis3.spellCache[12051].name) then
			-- Evocation cooldown started
			evocHandle = Cryolysis3:ScheduleRepeatingTimer(UpdateEvocation, 1);
		end
	end

end

------------------------------------------------------------------------------------------------------
-- Dammit need Combustion off cooldown NOW!
------------------------------------------------------------------------------------------------------
function module:SPELL_UPDATE_COOLDOWN()

end

------------------------------------------------------------------------------------------------------
-- Thar she flies!
------------------------------------------------------------------------------------------------------
function module:UNIT_SPELLCAST_SENT()

end

------------------------------------------------------------------------------------------------------
-- No, I'm not a vending machine. "Watr plx" is also not a valid way of asking.
------------------------------------------------------------------------------------------------------
function module:TRADE_SHOW()

end

------------------------------------------------------------------------------------------------------
-- Get out of ma face!
------------------------------------------------------------------------------------------------------
function module:TRADE_CLOSED()

end

------------------------------------------------------------------------------------------------------
-- We all loves the manas!
------------------------------------------------------------------------------------------------------
function module:UNIT_MANA(event, unitId)
	if (unitId == "player") then
		if (tonumber(Cryolysis3.db.char.outerSphere) == 3) then
			Cryolysis3:UpdateSphere("outerSphere");
		end
		if (tonumber(Cryolysis3.db.char.sphereText) == 4 or tonumber(Cryolysis3.db.char.sphereText) == 5) then
			Cryolysis3:UpdateSphere("sphereText");
		end
	end
end