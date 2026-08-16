------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;
local module = Cryolysis3:NewModule("MAGE", Cryolysis3.ModuleCore, "AceEvent-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("Cryolysis3");
local evocHandle = nil;
local gemHandle = nil;

local function GetSafeItemCooldown(itemID)
	if not itemID then return 0, 0, 0 end
	if C_Container and C_Container.GetItemCooldown then
		return C_Container.GetItemCooldown(itemID)
	elseif C_Item and C_Item.GetItemCooldown then
		return C_Item.GetItemCooldown(itemID)
	elseif GetItemCooldown then
		return GetItemCooldown(itemID)
	end
	return 0, 0, 0
end

local function SafeSpellName(spellID)
	if Cryolysis3.spellCache and Cryolysis3.spellCache[spellID] and Cryolysis3.spellCache[spellID].name then
		return Cryolysis3.spellCache[spellID].name;
	end
	return GetSpellInfo(spellID) or "";
end

local function SafeSpellIcon(spellID)
	if Cryolysis3.spellCache and Cryolysis3.spellCache[spellID] and Cryolysis3.spellCache[spellID].icon then
		return Cryolysis3.spellCache[spellID].icon;
	end
	return select(3, GetSpellInfo(spellID));
end

------------------------------------------------------------------------------------------------------
-- Function to update the cooldown on Evocation
------------------------------------------------------------------------------------------------------
local function UpdateEvocation()
	local spellName = SafeSpellName(12051);
	if not spellName or spellName == "" then return end

	local start, duration, enabled = GetSpellCooldown(spellName);
		
	if (duration == 0) then
		if (evocHandle ~= nil) then
			Cryolysis3:CancelTimer(evocHandle);
			evocHandle = nil;
		end
		
		if Cryolysis3EvocationButton and Cryolysis3EvocationButton.texture then
			Cryolysis3EvocationButton.texture:SetDesaturated(false);
		end
		
		if Cryolysis3EvocationButtonText then
			Cryolysis3EvocationButtonText:SetText(nil);
		end
		
		if Cryolysis3.Private.tooltips["EvocationButton"] then
			Cryolysis3.Private.tooltips["EvocationButton"][2] = L["Ready"];
		end
	else
		if (evocHandle == nil) then
			evocHandle = Cryolysis3:ScheduleRepeatingTimer(UpdateEvocation, 1);
		end
		
		if Cryolysis3EvocationButton and Cryolysis3EvocationButton.texture then
			Cryolysis3EvocationButton.texture:SetDesaturated(true);
		end
		
		local timeleft = Cryolysis3:TimerData(start, duration);
		
		if (timeleft.minutes > 0) then
			if Cryolysis3.Private.tooltips["EvocationButton"] then
				Cryolysis3.Private.tooltips["EvocationButton"][2] = timeleft.minutes.." "..L["minutes"]..", "..timeleft.seconds.." "..L["seconds"];
			end
			
			if (Cryolysis3.db.char.buttonText["EvocationButton"]) and Cryolysis3EvocationButtonText then
				Cryolysis3EvocationButtonText:SetText(timeleft.minutes..":"..timeleft.seconds);
			elseif Cryolysis3EvocationButtonText then
				Cryolysis3EvocationButtonText:SetText(nil);
			end
		else
			if Cryolysis3.Private.tooltips["EvocationButton"] then
				Cryolysis3.Private.tooltips["EvocationButton"][2] =  timeleft.seconds.." "..L["seconds"];
			end
			
			if (Cryolysis3.db.char.buttonText["EvocationButton"]) and Cryolysis3EvocationButtonText then
				Cryolysis3EvocationButtonText:SetText(timeleft.seconds);
			elseif Cryolysis3EvocationButtonText then
				Cryolysis3EvocationButtonText:SetText(nil);
			end
		end
	end
end

------------------------------------------------------------------------------------------------------
-- Function to update the cooldown on Mana Gem
------------------------------------------------------------------------------------------------------
local function UpdateManaGem()
	if not Cryolysis3.Private.manaGem then return end
	local start, duration, enabled = GetSafeItemCooldown(Cryolysis3.Private.manaGem);
	if not duration or duration == 0 then
		if (gemHandle ~= nil) then
			Cryolysis3:CancelTimer(gemHandle);
			gemHandle = nil;
		end
		
		if Cryolysis3GemButton and Cryolysis3GemButton.texture then
			Cryolysis3GemButton.texture:SetDesaturated(false);
		end
		
		if Cryolysis3GemButtonText then
			Cryolysis3GemButtonText:SetText(nil);
		end
		
		if Cryolysis3.Private.tooltips["GemButton"] then
			Cryolysis3.Private.tooltips["GemButton"][4] = L["Ready"];
		end
	else	
		if (gemHandle == nil) then
			gemHandle = Cryolysis3:ScheduleRepeatingTimer(UpdateManaGem, 1);
		end
		
		if Cryolysis3GemButton and Cryolysis3GemButton.texture then
			Cryolysis3GemButton.texture:SetDesaturated(true);
		end
		
		local timeleft = Cryolysis3:TimerData(start, duration);
		
		if timeleft and timeleft.minutes and timeleft.minutes > 0 then
			if Cryolysis3.Private.tooltips["GemButton"] then
				Cryolysis3.Private.tooltips["GemButton"][4] = timeleft.minutes.." "..L["minutes"]..", "..timeleft.seconds.." "..L["seconds"];
			end
			
			if (Cryolysis3.db.char.buttonText["GemButton"]) and Cryolysis3GemButtonText then
				Cryolysis3GemButtonText:SetText(timeleft.minutes..":"..timeleft.seconds);
			elseif Cryolysis3GemButtonText then
				Cryolysis3GemButtonText:SetText(nil);
			end
		elseif timeleft and timeleft.seconds then
			if Cryolysis3.Private.tooltips["GemButton"] then
				Cryolysis3.Private.tooltips["GemButton"][4] =  timeleft.seconds.." "..L["seconds"];
			end
			
			if (Cryolysis3.db.char.buttonText["GemButton"]) and Cryolysis3GemButtonText then
				Cryolysis3GemButtonText:SetText(timeleft.seconds);
			elseif Cryolysis3GemButtonText then
				Cryolysis3GemButtonText:SetText(nil);
			end
		end
	end
end

------------------------------------------------------------------------------------------------------
-- Function to fetch lookup table to be used in :UpdateItemCount
------------------------------------------------------------------------------------------------------
local function GetLookupTable(name)
	if (name == "water") then
		return {
			[27090]	= 22018,
			[37420]	= 30703,
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
			[33717]	= 22019,
			[28612]	= 22895,
			[10145]	= 8076,
			[10144]	= 8075,
			[6129]	= 1487,
			[990]	= 1114,
			[597]	= 1113,
			[587]	= 5349,
		};
	elseif (name == "gem") then
		return {
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
	if not Cryolysis3.Private.tooltips["Sphere"] then return end
	Cryolysis3.Private.tooltips["Sphere"][2] = L["Conjured Food"]..": "..((Cryolysis3FoodButtonText and Cryolysis3FoodButtonText:GetText()) or 0);
	Cryolysis3.Private.tooltips["Sphere"][3] = L["Conjured Water"]..": "..((Cryolysis3WaterButtonText and Cryolysis3WaterButtonText:GetText()) or 0);
	Cryolysis3.Private.tooltips["Sphere"][4] = (select(1, GetItemInfo(17020)) or "Arcane Powder")..": "..(GetItemCount(17020) or 0);
	Cryolysis3.Private.tooltips["Sphere"][5] = (select(1, GetItemInfo(17056)) or "Light Feather")..": "..(GetItemCount(17056) or 0);
	Cryolysis3.Private.tooltips["Sphere"][6] = (select(1, GetItemInfo(17031)) or "Rune of Teleportation")..": "..(GetItemCount(17031) or 0);
	Cryolysis3.Private.tooltips["Sphere"][7] = (select(1, GetItemInfo(17032)) or "Rune of Portals")..": "..(GetItemCount(17032) or 0);
end

------------------------------------------------------------------------------------------------------
-- Function to generate configuration options
------------------------------------------------------------------------------------------------------
function module:CreateConfigOptions()
	local configOptions = {
		type = "group",
		name = gsub(UnitClass("player"), "^.", function(s) return s:upper() end),
		desc = L["Adjust various options for this module."],
		args = {
			evocationbutton = {
				type = "group",
				name = GetSpellInfo(12051) or "Evocation",
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
							Cryolysis3:UpdateScale("button", "EvocationButton", v);
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
							Cryolysis3.db.char.menuButtonGrowth["BuffButton"] = v;
							Cryolysis3:PositionMenuItems("BuffButton", v);
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
							Cryolysis3:UpdateScale("button", "BuffButton", v);
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
							Cryolysis3.db.char.menuButtonGrowth["PortalButton"] = v;
							Cryolysis3:PositionMenuItems("PortalButton", v);
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
							Cryolysis3:UpdateScale("button", "PortalButton", v);
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
							Cryolysis3:UpdateScale("button", "FoodButton", v);
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
							Cryolysis3:UpdateScale("button", "WaterButton", v);
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
							Cryolysis3:UpdateScale("button", "GemButton", v);
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
	};
		
	return configOptions;
end

------------------------------------------------------------------------------------------------------
-- What happens when the module is initialised
------------------------------------------------------------------------------------------------------
function module:OnInitialize()
	if (select(2, UnitClass("player")) == "MAGE") then
		local i = 1;

		for k, v in pairs(GetLookupTable("water")) do
			Cryolysis3.Private.cacheList[i] = v;
			i = i + 1;
		end

		for k, v in pairs(GetLookupTable("food")) do
			Cryolysis3.Private.cacheList[i] = v;
			i = i + 1;
		end

		for k, v in pairs(GetLookupTable("gem")) do
			Cryolysis3.Private.cacheList[i] = v;
			i = i + 1;
		end
		
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
	Cryolysis3:SetDefaultSkin("Blue");
	
	Cryolysis3.spellList = Cryolysis3.spellList or {};
	
	local defaultMageSpells = {
		12051, 168, 7302, 6117, 30482, 1459, 23028, 604, 1008, 1463, 11426, 543, 6143, 475, 130,
		3562, 11416, 3561, 10059, 3565, 11419, 32271, 32266, 49359, 49360, 33690, 33691, 53140, 53142,
		3567, 11417, 3563, 11418, 3566, 11420, 32272, 32267, 49358, 49361, 35715, 35717,
		27090, 37420, 10140, 10139, 10138, 6127, 5506, 5505, 5504,
		33717, 28612, 10145, 10144, 6129, 990, 597, 587,
		27101, 10054, 10053, 3552, 759, 43987
	};
	for _, spellID in ipairs(defaultMageSpells) do
		table.insert(Cryolysis3.spellList, spellID);
	end

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
	
	module:RegisterConfigOptions(module:CreateConfigOptions());
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
		["Arcane Powder"]		= 17020,
		["Rune of Teleportation"]	= 17031,
		["Rune of Portals"]		= 17032,
	};
	
	if (Cryolysis3:HasSpell(23028) or Cryolysis3:HasSpell(43987)) then
		local itemName = GetItemInfo(reagentList["Arcane Powder"]) or "Arcane Powder";
		if (Cryolysis3.db.char.RestockQuantity[itemName] == nil) then
			Cryolysis3.db.char.RestockQuantity[itemName] = 20;
		end
		Cryolysis3.Private.classReagents["Arcane Powder"] = reagentList["Arcane Powder"];
		Cryolysis3.Private.hasReagents = true;
	end
	
	if (Cryolysis3:HasSpell("Teleport")) then
		local itemName = GetItemInfo(reagentList["Rune of Teleportation"]) or "Rune of Teleportation";
		if (Cryolysis3.db.char.RestockQuantity[itemName] == nil) then
			Cryolysis3.db.char.RestockQuantity[itemName] = 10;
		end
		Cryolysis3.Private.classReagents["Rune of Teleportation"] = reagentList["Rune of Teleportation"];
		Cryolysis3.Private.hasReagents = true;
	end
	
	if (Cryolysis3:HasSpell("Portal")) then
		local itemName = GetItemInfo(reagentList["Rune of Portals"]) or "Rune of Portals";
		if (Cryolysis3.db.char.RestockQuantity[itemName] == nil) then
			Cryolysis3.db.char.RestockQuantity[itemName] = 10;
		end
		Cryolysis3.Private.classReagents["Rune of Portals"] = reagentList["Rune of Portals"];
		Cryolysis3.Private.hasReagents = true;
	end	
end

------------------------------------------------------------------------------------------------------
-- Function for creating all the buttons used by this class
------------------------------------------------------------------------------------------------------
function module:CreateButtons()
	if (Cryolysis3:HasSpell(12051)) then
		Cryolysis3:CreateButton("EvocationButton", UIParent, SafeSpellIcon(12051));
		
		Cryolysis3.Private.tooltips["EvocationButton"] = {};
		table.insert(Cryolysis3.Private.tooltips["EvocationButton"], SafeSpellName(12051));
		
		Cryolysis3.db.char.buttonTypes["EvocationButton"] = "spell";
		Cryolysis3.db.char.buttonFunctions["EvocationButton"] = {};
		Cryolysis3.db.char.buttonFunctions["EvocationButton"]["left"] = 12051;

		Cryolysis3:UpdateButton("EvocationButton", "left");
		UpdateEvocation();
	end
	
	local foodLookupTable = GetLookupTable("food");
	local waterLookupTable = GetLookupTable("water");
	local gemLookupTable = GetLookupTable("gem");
	
	local foodID = Cryolysis3:GetHighestRank(foodLookupTable, "food");
	local waterID = Cryolysis3:GetHighestRank(waterLookupTable, "water");
	local gemID = Cryolysis3:GetHighestRank(gemLookupTable, "gem");

	if (foodID ~= nil) then
		Cryolysis3:CreateButton("FoodButton", UIParent, SafeSpellIcon(foodID));
		Cryolysis3.Private.tooltips["FoodButton"] = {};
		
		local foodName = GetItemInfo(foodLookupTable[foodID]) or SafeSpellName(foodID);
		table.insert(Cryolysis3.Private.tooltips["FoodButton"], SafeSpellName(foodID));
		table.insert(Cryolysis3.Private.tooltips["FoodButton"], string.format(L["%s click to %s: %s"], L["Left"], L["use"], foodName));
		table.insert(Cryolysis3.Private.tooltips["FoodButton"], string.format(L["%s click to %s: %s"], L["Right"], L["cast"], SafeSpellName(foodID)));
		
		Cryolysis3.db.char.buttonFunctions["FoodButton"] = {};
		Cryolysis3.db.char.buttonFunctions["FoodButton"]["left"] = "/use " .. foodName;
		Cryolysis3.db.char.buttonFunctions["FoodButton"]["right"] = "/cast " .. SafeSpellName(foodID);
	
		if (Cryolysis3:HasSpell(43987)) then
			table.insert(Cryolysis3.Private.tooltips["FoodButton"], string.format(L["%s click to %s: %s"], L["Middle"], L["cast"], SafeSpellName(43987)));
			Cryolysis3.db.char.buttonFunctions["FoodButton"]["middle"] = "/cast " .. SafeSpellName(43987);
		end
		
		Cryolysis3:UpdateButton("FoodButton", "left");
		Cryolysis3:UpdateButton("FoodButton", "right");
		Cryolysis3:UpdateButton("FoodButton", "middle");
	end

	-- Блок WaterButton
	if (waterID ~= nil) then
		Cryolysis3:CreateButton("WaterButton", UIParent, SafeSpellIcon(waterID));
		Cryolysis3.Private.tooltips["WaterButton"] = {};
		
		local waterName = GetItemInfo(waterLookupTable[waterID]) or SafeSpellName(waterID);
		table.insert(Cryolysis3.Private.tooltips["WaterButton"], SafeSpellName(waterID));
		table.insert(Cryolysis3.Private.tooltips["WaterButton"], string.format(L["%s click to %s: %s"], L["Left"], L["use"], waterName));
		table.insert(Cryolysis3.Private.tooltips["WaterButton"], string.format(L["%s click to %s: %s"], L["Right"], L["cast"], SafeSpellName(waterID)));
		
		Cryolysis3.db.char.buttonFunctions["WaterButton"] = {};
		Cryolysis3.db.char.buttonFunctions["WaterButton"]["left"] = "/use " .. waterName;
		Cryolysis3.db.char.buttonFunctions["WaterButton"]["right"] = "/cast " .. SafeSpellName(waterID);

		if (Cryolysis3:HasSpell(43987)) then
			table.insert(Cryolysis3.Private.tooltips["WaterButton"], string.format(L["%s click to %s: %s"], L["Middle"], L["cast"], SafeSpellName(43987)));
			Cryolysis3.db.char.buttonFunctions["WaterButton"]["middle"] = "/cast " .. SafeSpellName(43987);
		end
		
		Cryolysis3:UpdateButton("WaterButton", "left");
		Cryolysis3:UpdateButton("WaterButton", "right");
		Cryolysis3:UpdateButton("WaterButton", "middle");
	end

	if (gemID ~= nil) then
		Cryolysis3.Private.manaGem = gemLookupTable[gemID];

		Cryolysis3:CreateButton("GemButton", UIParent, SafeSpellIcon(gemID));
		Cryolysis3.Private.tooltips["GemButton"] = {};
		
		local gemName = GetItemInfo(gemLookupTable[gemID]) or SafeSpellName(gemID);
		table.insert(Cryolysis3.Private.tooltips["GemButton"], SafeSpellName(gemID));
		table.insert(Cryolysis3.Private.tooltips["GemButton"], string.format(L["%s click to %s: %s"], L["Left"], L["use"], gemName));
		table.insert(Cryolysis3.Private.tooltips["GemButton"], string.format(L["%s click to %s: %s"], L["Right"], L["cast"], SafeSpellName(gemID)));
		
		Cryolysis3.db.char.buttonFunctions["GemButton"] = {};
		Cryolysis3.db.char.buttonTypes["GemButton"] = "macrotext";
		Cryolysis3.db.char.buttonFunctions["GemButton"]["left"] = "/use " .. gemName;
		Cryolysis3.db.char.buttonFunctions["GemButton"]["right"] = "/cast " .. SafeSpellName(gemID);
		
		Cryolysis3:UpdateButton("GemButton", "left");
		Cryolysis3:UpdateButton("GemButton", "right");
		Cryolysis3:UpdateButton("GemButton", "middle");
		UpdateManaGem();
	end

	Cryolysis3.Private.tooltips["BuffButton"] = {};
	Cryolysis3.Private.tooltips["PortalButton"] = {};
	
	table.insert(Cryolysis3.Private.tooltips["BuffButton"], L["Buff Menu"]);
	table.insert(Cryolysis3.Private.tooltips["BuffButton"], L["Click to open menu."]);
	table.insert(Cryolysis3.Private.tooltips["PortalButton"], L["Teleport/Portal"]);
	table.insert(Cryolysis3.Private.tooltips["PortalButton"], L["Click to open menu."]);
	
	local tooltip = {};
	local hasBuff = false;
	local hasTelePort = false;

	if (Cryolysis3:HasSpell(168) or Cryolysis3:HasSpell(7302) or Cryolysis3:HasSpell(6117) or Cryolysis3:HasSpell(30482)) then
		local frostIce = 7302;
		if (Cryolysis3:HasSpell(168) and not Cryolysis3:HasSpell(7302)) then
			frostIce = 168;
		end
		tooltip = Cryolysis3:PrepareButton("BuffButton", "Armor", "spell", L["Armor"], frostIce, 6117, 30482);
		Cryolysis3:AddMenuItem("BuffButton", "Armor", SafeSpellIcon(7302) or SafeSpellIcon(168), tooltip);
		hasBuff = true;
	end

	if (Cryolysis3:HasSpell(1459) or Cryolysis3:HasSpell(23028)) then
		tooltip = Cryolysis3:PrepareButton("BuffButton", "Intellect", "spell", L["Intellect"], 1459, 23028);
		Cryolysis3:AddMenuItem("BuffButton", "Intellect", SafeSpellIcon(1459), tooltip);
		hasBuff = true;
	end

	if (Cryolysis3:HasSpell(61024) or Cryolysis3:HasSpell(61316)) then
		tooltip = Cryolysis3:PrepareButton("BuffButton2", "Intellect2", "spell", L["Intellect"], 61024, 61316);
		Cryolysis3:AddMenuItem("BuffButton2", "Intellect2", SafeSpellIcon(61024), tooltip);
		hasBuff = true;
	end

	if (Cryolysis3:HasSpell(604) or Cryolysis3:HasSpell(1008)) then
		tooltip = Cryolysis3:PrepareButton("BuffButton", "Magic", "spell", L["Magic"], 604, 1008);
		Cryolysis3:AddMenuItem("BuffButton", "Magic", SafeSpellIcon(604), tooltip);
		hasBuff = true;
	end

	if (Cryolysis3:HasSpell(1463) or Cryolysis3:HasSpell(11426)) then
		tooltip = Cryolysis3:PrepareButton("BuffButton", "Shields", "spell", L["Damage Shields"], 1463, 11426);
		Cryolysis3:AddMenuItem("BuffButton", "Shields", SafeSpellIcon(1463), tooltip);
		hasBuff = true;
	end

	if (Cryolysis3:HasSpell(543) or Cryolysis3:HasSpell(6143)) then
		tooltip = Cryolysis3:PrepareButton("BuffButton", "Wards", "spell", L["Magical Wards"], 543, 6143);
		Cryolysis3:AddMenuItem("BuffButton", "Wards", SafeSpellIcon(543), tooltip);
		hasBuff = true;
	end

	if (Cryolysis3:HasSpell(475)) then
		tooltip = Cryolysis3:PrepareButton("BuffButton", "Curse", "spell", 475, 475);
		Cryolysis3:AddMenuItem("BuffButton", "Curse", SafeSpellIcon(475), tooltip);
		hasBuff = true;
	end

	if (Cryolysis3:HasSpell(130)) then
		tooltip = Cryolysis3:PrepareButton("BuffButton", "SlowFall", "spell", 130, 130);
		Cryolysis3:AddMenuItem("BuffButton", "SlowFall", SafeSpellIcon(130), tooltip);
		Cryolysis3.db.char.buttonText["BuffButtonSlowFall"] = true;
		hasBuff = true;
	end

	if (Cryolysis3.Private.englishFaction == "Alliance") then
		if (Cryolysis3:HasSpell(3562) or Cryolysis3:HasSpell(11416)) then
			tooltip = Cryolysis3:PrepareButton("PortalButton", "Ironforge", "spell", 3562, 3562, 11416);
			Cryolysis3:AddMenuItem("PortalButton", "Ironforge", SafeSpellIcon(3562), tooltip);
			hasTelePort = true;
		end
		if (Cryolysis3:HasSpell(3561) or Cryolysis3:HasSpell(10059)) then
			tooltip = Cryolysis3:PrepareButton("PortalButton", "Stormwind", "spell", 3561, 3561, 10059);
			Cryolysis3:AddMenuItem("PortalButton", "Stormwind", SafeSpellIcon(3561), tooltip);
			hasTelePort = true;
		end
		if (Cryolysis3:HasSpell(3565) or Cryolysis3:HasSpell(11419)) then
			tooltip = Cryolysis3:PrepareButton("PortalButton", "Darnassus", "spell", 3565, 3565, 11419);
			Cryolysis3:AddMenuItem("PortalButton", "Darnassus", SafeSpellIcon(3565), tooltip);
			hasTelePort = true;
		end
		if (Cryolysis3:HasSpell(32271) or Cryolysis3:HasSpell(32266)) then
			tooltip = Cryolysis3:PrepareButton("PortalButton", "TheExodar", "spell", 32271, 32271, 32266);
			Cryolysis3:AddMenuItem("PortalButton", "TheExodar", SafeSpellIcon(32271), tooltip);
			hasTelePort = true;
		end
		if (Cryolysis3:HasSpell(49359) or Cryolysis3:HasSpell(49360)) then
			tooltip = Cryolysis3:PrepareButton("PortalButton", "Theramore", "spell", 49359, 49359, 49360);
			Cryolysis3:AddMenuItem("PortalButton", "Theramore", SafeSpellIcon(49359), tooltip);
			hasTelePort = true;
		end
		if (Cryolysis3:HasSpell(33690) or Cryolysis3:HasSpell(33691)) then
			tooltip = Cryolysis3:PrepareButton("PortalButton", "ShattrathCity", "spell", 33690, 33690, 33691);
			Cryolysis3:AddMenuItem("PortalButton", "ShattrathCity", SafeSpellIcon(33690), tooltip);
			hasTelePort = true;
		end
		if (Cryolysis3:HasSpell(53140) or Cryolysis3:HasSpell(53142)) then
			tooltip = Cryolysis3:PrepareButton("PortalButton", "Dalaran", "spell", 53140, 53140, 53142);
			Cryolysis3:AddMenuItem("PortalButton", "Dalaran", SafeSpellIcon(53140), tooltip);
			hasTelePort = true;
		end
	else
		if (Cryolysis3:HasSpell(3567) or Cryolysis3:HasSpell(11417)) then
			tooltip = Cryolysis3:PrepareButton("PortalButton", "Orgrimmar", "spell", 3567, 3567, 11417);
			Cryolysis3:AddMenuItem("PortalButton", "Orgrimmar", SafeSpellIcon(3567), tooltip);
			hasTelePort = true;
		end
		if (Cryolysis3:HasSpell(3563) or Cryolysis3:HasSpell(11418)) then
			tooltip = Cryolysis3:PrepareButton("PortalButton", "Undercity", "spell", 3563, 3563, 11418);
			Cryolysis3:AddMenuItem("PortalButton", "Undercity", SafeSpellIcon(3563), tooltip);
			hasTelePort = true;
		end
		if (Cryolysis3:HasSpell(3566) or Cryolysis3:HasSpell(11420)) then
			tooltip = Cryolysis3:PrepareButton("PortalButton", "ThunderBluff", "spell", 3566, 3566, 11420);
			Cryolysis3:AddMenuItem("PortalButton", "ThunderBluff", SafeSpellIcon(3566), tooltip);
			hasTelePort = true;
		end
		if (Cryolysis3:HasSpell(32272) or Cryolysis3:HasSpell(32267)) then
			tooltip = Cryolysis3:PrepareButton("PortalButton", "SilvermoonCity", "spell", 32272, 32272, 32267);
			Cryolysis3:AddMenuItem("PortalButton", "SilvermoonCity", SafeSpellIcon(32272), tooltip);
			hasTelePort = true;
		end
		if (Cryolysis3:HasSpell(49358) or Cryolysis3:HasSpell(49361)) then
			tooltip = Cryolysis3:PrepareButton("PortalButton", "Stonard", "spell", 49358, 49358, 49361);
			Cryolysis3:AddMenuItem("PortalButton", "Stonard", SafeSpellIcon(49358), tooltip);
			hasTelePort = true;
		end
		if (Cryolysis3:HasSpell(35715) or Cryolysis3:HasSpell(35717)) then
			tooltip = Cryolysis3:PrepareButton("PortalButton", "ShattrathCity", "spell", 35715, 35715, 35717);
			Cryolysis3:AddMenuItem("PortalButton", "ShattrathCity", SafeSpellIcon(35715), tooltip);
			hasTelePort = true;
		end
		if (Cryolysis3:HasSpell(53140) or Cryolysis3:HasSpell(53142)) then
			tooltip = Cryolysis3:PrepareButton("PortalButton", "Dalaran", "spell", 53140, 53140, 53142);
			Cryolysis3:AddMenuItem("PortalButton", "Dalaran", SafeSpellIcon(53140), tooltip);
			hasTelePort = true;
		end
	end

	if (hasBuff) then
		Cryolysis3:CreateButton("BuffButton", UIParent, "Interface\\Icons\\INV_Staff_13", "menuButton");
	end

	if (hasTelePort) then
		Cryolysis3:CreateButton("PortalButton", UIParent, "Interface\\Icons\\Spell_Nature_AstralRecalGroup", "menuButton");
	end

	UpdateItemCount();
	UpdateSphereTooltip();
end

------------------------------------------------------------------------------------------------------
-- Register for our needed events
------------------------------------------------------------------------------------------------------
function module:RegisterClassEvents()
	module:RegisterEvent("BAG_UPDATE");
	module:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
	module:RegisterEvent("UNIT_POWER_UPDATE");
end

function module:COMBAT_LOG_EVENT_UNFILTERED()
end

function module:BAG_UPDATE()
	if (Cryolysis3GemButton ~= nil) then
		UpdateManaGem();
		UpdateItemCount();
		UpdateSphereTooltip();
	end
end

function module:UNIT_SPELLCAST_SUCCEEDED(event, unit, castGUID, spellID)
	local spellName = (type(castGUID) == "number" and GetSpellInfo(castGUID)) or (type(spellID) == "number" and GetSpellInfo(spellID)) or castGUID;
	if (spellName == (GetSpellInfo(5405) or "Mana Emerald")) then
		gemHandle = Cryolysis3:ScheduleRepeatingTimer(UpdateManaGem, 1);
	end

	if (spellName == SafeSpellName(12051)) then
		evocHandle = Cryolysis3:ScheduleRepeatingTimer(UpdateEvocation, 1);
	end

	Cryolysis3:UpdateSphere();
end

function module:SPELL_UPDATE_COOLDOWN()
end

function module:UNIT_SPELLCAST_SENT()
end

function module:TRADE_SHOW()
end

function module:TRADE_CLOSED()
end

function module:UNIT_POWER_UPDATE(event, unitId)
	if (unitId == "player") then
		if (tonumber(Cryolysis3.db.char.outerSphere) == 3) then
			Cryolysis3:UpdateSphere("outerSphere");
		end
		if (tonumber(Cryolysis3.db.char.sphereText) == 4 or tonumber(Cryolysis3.db.char.sphereText) == 5) then
			Cryolysis3:UpdateSphere("sphereText");
		end
	end
end