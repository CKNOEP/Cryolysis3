------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;
local L = LibStub("AceLocale-3.0"):GetLocale("Cryolysis3");


------------------------------------------------------------------------------------------------------
-- Outputs a tooltip either dynamically or based on table data (module button tooltips)
------------------------------------------------------------------------------------------------------
function Cryolysis3:BuildTooltip(name)

	if Cryolysis3.db.char.HideTooltips then
		return
	end

	-- Begin setting tooltip owner
	GameTooltip:SetOwner(getglobal("Cryolysis3"..name), "ANCHOR_LEFT");
	
	if (Cryolysis3.Private.tooltips[name] == true) then
		-- Dynamically generated tooltip
		if (name == "MountButton") then
			local hs = GetItemInfo(6948);
			GameTooltip:SetText(L["Mount"], 1, 1, 1, 1);
			if (Cryolysis3.db.char.mountBehavior == 2) then
				if (Cryolysis3.db.char.chosenMount["normal"] == nil) then
					-- We have no normal mount
					if (Cryolysis3.db.char.chosenMount["flying"] == nil) then
						-- We have no flying mount either
						if hs ~= nil then
							GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Left"], hs, GetBindLocation()));
						else
							GameTooltip:AddLine(L["You have no usable mounts and no hearthstone."]);
						end
					else
						-- We have only flying mount
						if (IsFlyableArea()) then
							GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Left"], L["use"], Cryolysis3.db.char.chosenMount["flying"]));
						else
							GameTooltip:AddLine(L["You are not in a flyable area and you have no selected ground mount."]);
						end
						if hs ~= nil then
							GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Right"], hs, GetBindLocation()));
						end
					end
				else
					-- We have a ground mount
					if (Cryolysis3.db.char.chosenMount["flying"] == nil) then
						-- We have only ground mount
						GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Left"], L["use"], Cryolysis3.db.char.chosenMount["normal"]));
						if hs ~= nil then
							GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Middle"], hs, GetBindLocation()));
						end
					else
						-- We have both ground mount and flying mount
						if (IsFlyableArea()) then
							GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Left"], L["use"], Cryolysis3.db.char.chosenMount["flying"]));
						else
							GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Left"], L["use"], Cryolysis3.db.char.chosenMount["normal"]));
						end
						if hs ~= nil then
							GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Right"], hs, GetBindLocation()));
						end
					end
				end
			else
				if (Cryolysis3.db.char.chosenMount["normal"] ~= nil and Cryolysis3.db.char.chosenMount["flying"] ~= nil) then
					GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Left"], L["use"], Cryolysis3.db.char.chosenMount["normal"]));
					GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Right"], L["use"], Cryolysis3.db.char.chosenMount["flying"]));
					if hs ~= nil then
						GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Middle"], hs, GetBindLocation()));
					end

				elseif (Cryolysis3.db.char.chosenMount["normal"] ~= nil and Cryolysis3.db.char.chosenMount["flying"] == nil) then
					GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Left"], L["use"], Cryolysis3.db.char.chosenMount["normal"]));
					if hs ~= nil then
						GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Right"], hs, GetBindLocation()));
					end

				elseif (Cryolysis3.db.char.chosenMount["normal"] == nil and Cryolysis3.db.char.chosenMount["flying"] ~= nil) then
					if hs ~= nil then
						GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Left"], hs, GetBindLocation()));
					end
					GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Right"], L["use"], Cryolysis3.db.char.chosenMount["flying"]));
				else
					if hs ~= nil then
						GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Left"], hs, GetBindLocation()));
					else
						GameTooltip:AddLine(L["You have no usable mounts and no hearthstone."]);
					end
				end
			end
			
		elseif (name == "CustomButton1" or name == "CustomButton2" or name == "CustomButton3") then
			local hasFunc = false;
			local buttonType = false;
			
			-- Correct terminology
			if (Cryolysis3.db.char.buttonTypes[name] == "spell") then
				buttonType = L["cast"];
			else
				buttonType = L["use"];
			end
			
			-- Begin the tooltip
			GameTooltip:SetText(L["Custom Button"], 1, 1, 1, 1);
			
			if (Cryolysis3.db.char.buttonFunctions[name].left ~= "") then
				hasFunc = true;
				GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Left"], buttonType, Cryolysis3.db.char.buttonFunctions[name].left));
			end
			
			if (Cryolysis3.db.char.buttonFunctions[name].right ~= "") then
				hasFunc = true;
				GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Right"], buttonType, Cryolysis3.db.char.buttonFunctions[name].right));
			end
			
			if (Cryolysis3.db.char.buttonFunctions[name].middle ~= "") then
				hasFunc = true;
				GameTooltip:AddLine(string.format(L["%s click to %s: %s"], L["Middle"], buttonType, Cryolysis3.db.char.buttonFunctions[name].middle));
			end
			
			if (not hasFunc) then
				GameTooltip:AddLine(L["No actions assigned to this button."]);
				GameTooltip:AddLine(L["You can assign an action to this button using the Cryolysis menu."]);
			end
		end
	else
		-- Dynamic tooltip

		if (Cryolysis3.Private.tooltips[name] == nil) then
			-- Make sure we're not dealing with a NYI tooltip
			Cryolysis3.Private.tooltips[name] = {};
		end

		-- Loop through all tooltip lines
		for i = 1, #(Cryolysis3.Private.tooltips[name]), 1 do
			if (i == 1) then
				-- Begin the tooltip
				GameTooltip:SetText(Cryolysis3.Private.tooltips[name][i], 1, 1, 1, 1);
			else
				-- Normal tooltip line
				GameTooltip:AddLine(Cryolysis3.Private.tooltips[name][i]);
			end
		end
	end
	
	-- Finally show the tooltip
	GameTooltip:Show();
end
