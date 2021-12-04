------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;
local module = Cryolysis3:NewModule("reagents", Cryolysis3.ModuleCore, "AceEvent-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("Cryolysis3");


------------------------------------------------------------------------------------------------------
-- Function to generate options
------------------------------------------------------------------------------------------------------
function module:CreateOptions()
	-- The option to shut off this module
	local options = {
		type = "toggle",
		name = L["Reagent Restocking"].." "..L["System"],
		desc = L["Turn this feature off if you don't use it in order to save memory and CPU power."],
		width = "full",
		get = function(info) return Cryolysis3.db.char.modules[module:GetName()] end,
		set = function(info, v)
			Cryolysis3.db.char.modules[module:GetName()] = v;
			if (v) then 
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
		name = L["Reagent Restocking"].." "..L["System"],
		desc = L["Adjust various options for this module."],
		args = {
			popup = {
				type = "toggle",
				name = L["Confirm Restocking"],
				desc = L["Pop-up a confirmation box."],
				get = function(info) return Cryolysis3.db.char.RestockConfirm end,
				set = function(info, v) Cryolysis3.db.char.RestockConfirm = v end,
				order = 1,
			},
			overflow = {
				type = "toggle",
				name = L["Restocking Overflow"],
				desc = L["If enabled, one extra stack of reagents will be bought in order to bring you above the restock amount. Only works for reagents that are bought from vendor in stacks."],
				get = function(info) return Cryolysis3.db.char.restockOverflow end,
				set = function(info, v) Cryolysis3.db.char.restockOverflow = v end,
				order = 1,
			}
		}
	}
	
	if (Cryolysis3.Private.classReagents == nil) then
		-- Dunno why this would be nil, but meh
		Cryolysis3.Private.classReagents = {};
	end

	for k, i in pairs(Cryolysis3.Private.classReagents) do
		reagentamount = {
			type = "range",
			name = GetItemInfo(i),
			desc = L["Adjust the amount of "]..GetItemInfo(i)..L[" to restock to."],
			width = "full",
			get = function(info) return Cryolysis3.db.char.RestockQuantity[GetItemInfo(i)] end,
			set = function(info, v) Cryolysis3.db.char.RestockQuantity[GetItemInfo(i)] = v end,
			min = 0,
			max = 200,
			step = 1,
		}
		configOptions.args[gsub(k, " ", "")] = reagentamount  --remove the spaces!
	end
	
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
	-- Create an instance of this table to fill it with reagents
	local configOptions = module:CreateConfigOptions();
	
	-- Insert our config options
	module:RegisterConfigOptions(configOptions);
	
	if (Cryolysis3.Private.hasReagents) then
		-- Register restock events only if we have a reagentlist greater than 0
		module:RegisterEvent("MERCHANT_SHOW");
		module:RegisterEvent("MERCHANT_CLOSED");
	end
	
	-- Setup for the reagent restocking dialog
	StaticPopupDialogs["RESTOCK_REAGENTS"] = {
		text = L["Restock all reagents?"],
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function() module:MERCHANT_SHOW(true); end,
		timeout = 0,
		whileDead = 0,
		hideOnEscape = 1
	}
	
	-- And we're live!
	if (not Cryolysis3.db.char.silentMode) then
		-- Only print this if we're not in silent mode
		Cryolysis3:Print(L["Reagent Restocking"].." "..L["System"].." "..L["Loaded"]);
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
		Cryolysis3:Print(L["Reagent Restocking"].." "..L["System"].." "..L["Unloaded"]);
	end
end

------------------------------------------------------------------------------------------------------
-- Function for restocking reagents when visiting vendor.
-- ReagentIndex is the number returned by the for loop.
-- Quantity is the stack size of the vendor item.
------------------------------------------------------------------------------------------------------
function module:BuyReagent(ReagentIndex, quantity)
	local name	= select(1, GetMerchantItemInfo(ReagentIndex));
	local count	= GetItemCount(name);
	local stackSize = select(8, GetItemInfo(name));
	local lacking	= 0;
	
	if (count < Cryolysis3.db.char.RestockQuantity[name]) then
		-- Figure out how many we need
		lacking = Cryolysis3.db.char.RestockQuantity[name] - count;
	end

	if (quantity == 1) then
		-- Standard reagent bought one by one
		while (lacking > stackSize) do
			-- Buy as many full possible stacks as we need
			BuyMerchantItem(ReagentIndex, stackSize);
			lacking = lacking - stackSize;
		end
		BuyMerchantItem(ReagentIndex, lacking);
	else
		-- Quantity was above 1, we need to hack the Gibson here
		while (lacking > quantity) do
			-- Buying them in singles because I'm lazy and couldn't get the division working prop :p
			BuyMerchantItem(ReagentIndex, 1);
			lacking = lacking - quantity;
		end

		if (Cryolysis3.db.char.restockOverflow) then
			-- Buy that one extra stack
			BuyMerchantItem(ReagentIndex, 1);
		end
	end
end

------------------------------------------------------------------------------------------------------
-- Visiting a vendor
------------------------------------------------------------------------------------------------------
function module:MERCHANT_SHOW(hasConfirmed)
	local IsReagentVendor	= false;
	local ReagentsMissing	= false;
	local tmpReagents	= {};
	local shoppingList	= {};
	
	for k, v in pairs(Cryolysis3.Private.classReagents) do
		-- Store the "real" name of the reagents in a table
		tmpReagents[GetItemInfo(v)] = true;
		
		if (GetItemCount(GetItemInfo(v)) < Cryolysis3.db.char.RestockQuantity[GetItemInfo(v)]) then
			-- Our owned items is less than the expected number
			ReagentsMissing = true;
			shoppingList[GetItemInfo(v)] = true;
		end
	end
	
	if (ReagentsMissing) then
		-- We are missing reagents, check if we have the module enabled
		if (Cryolysis3.db.char.modules["reagents"]) then
			-- Scan if this is a reagent vendor
			for i = 1, GetMerchantNumItems(), 1 do
			local name, _, _, quantity = GetMerchantItemInfo(i);
				if (tmpReagents[name] ~= nil and shoppingList[name] ~= nil) then
					-- This is a reagent vendor
					IsReagentVendor = true;
					
					if (not Cryolysis3.db.char.RestockConfirm or hasConfirmed == true) then
						-- We're not confirming, so buy item now
						module:BuyReagent(i, quantity);
					else
						-- We're confirming before restock, just exit the loops
						break;
					end
				end
			end
		end
	end
	
	if (IsReagentVendor and Cryolysis3.db.char.modules["reagents"] and ReagentsMissing) then
		if (Cryolysis3.db.char.RestockConfirm) then
			StaticPopup_Show("RESTOCK_REAGENTS");
		end
	end
end

------------------------------------------------------------------------------------------------------
-- Left the vendor
------------------------------------------------------------------------------------------------------
function module:MERCHANT_CLOSED()
	StaticPopup_Hide("RESTOCK_REAGENTS");
end