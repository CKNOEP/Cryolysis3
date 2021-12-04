------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;
--local L = LibStub("AceLocale-3.0"):GetLocale("Cryolysis3");


------------------------------------------------------------------------------------------------------
-- Create a frame based on inputted variables
------------------------------------------------------------------------------------------------------
function Cryolysis3:CreateFrame(...) -- See Cryolysis3.lua for a demo :)
	-- Localise arguments
	local frameType, name, parentFrame, inheritsFrame, width, height, movable, texturePath, textureWidth, textureHeight, normalTexturePath, highlightTexturePath, hide = ...;
	
	-- Create the frame name with the Cryolysis3 prefix
	local frameName = "Cryolysis3"..name;
	
	-- Create the frame
	local frame = CreateFrame(frameType, frameName, parentFrame, inheritsFrame);
	
	-- Set frame options
	frame:SetFrameStrata("MEDIUM");
	frame:SetWidth(width);
	frame:SetHeight(height);
	
	if texturePath ~= nil then
		frame.texture = frame:CreateTexture(nil, "BACKGROUND");
		frame.texture:SetTexture(texturePath);
		frame.texture:SetWidth(textureWidth);
		frame.texture:SetHeight(textureHeight);
		frame.texture:SetPoint("CENTER");
	end
	
	frame:SetMovable(movable);
	frame:SetClampedToScreen(true);
	frame:SetNormalTexture(normalTexturePath);
	if highlightTexturePath ~= nil then
		-- Only set highlight texture if it's not nil
		frame:SetHighlightTexture(highlightTexturePath, "BLEND");
	end
	frame:ClearAllPoints();
	frame:SetPoint("CENTER", 0, 0)

	if (hide == true) then
		-- Hide the frame if it's supposed to be hidden
		frame:Hide();
	end
	
	local frameType = "";
	if name == "Sphere" then
		-- We're altering the main sphere
		frameType = "frame";
	else
		-- We're altering a button
		frameType = "button";
		
		-- Create the icon of the frame
		local texture = frame:CreateTexture(frameName.."Icon", "BACKGROUND");
		texture:SetWidth(22);
		texture:SetHeight(22);
		texture:SetPoint("CENTER", frame, "CENTER")
	end

	-- Create the font string of the frame
	local fontstring = frame:CreateFontString(frameName.."Text", frame, "GameFontNormal");
	fontstring:SetPoint("CENTER", frame, "CENTER");
	fontstring:Show();

	if (parentFrame == UIParent) then
		-- Load this frame's position
		Cryolysis3:LoadAnchorPosition(frameType, name);
		
		-- Save this frame's position
		--Cryolysis3:SaveAnchorPosition(frameType, name);
	end

	return frame;
end


------------------------------------------------------------------------------------------------------
-- Add a script to a frame
------------------------------------------------------------------------------------------------------
function Cryolysis3:AddScript(name, frameType, scriptName)
	-- Get the item we are using
	local item = getglobal("Cryolysis3"..name);
	
	if not item then
		return false;
	end

	-- Set the script function
	if scriptName == "OnDragStart" then
		item:SetScript(scriptName, function(self)
			if self:GetParent() == UIParent then
				if (not Cryolysis3.db.char.lockSphere) then
					if frameType == "button" then
						if not Cryolysis3.db.char.lockButtons then
							self:StartMoving(); 
						end				
					else
						self:StartMoving(); 
					end
				end
			end
		end)
	elseif scriptName == "OnDragStop" then
		item:SetScript(scriptName, function(self) 
			self:StopMovingOrSizing(); 
			Cryolysis3:UpdateAllButtonPositions()
			--Cryolysis3:SaveAnchorPosition(frameType, name);
		end)
	elseif scriptName == "OnEnter" then
		item:SetScript(scriptName, function(self) 
			Cryolysis3:BuildTooltip(name); 
		end)
	elseif scriptName == "OnLeave" then
		item:SetScript(scriptName, function(self) 
			GameTooltip:Hide();
		end)
	elseif scriptName == "OnClick" then
		if (frameType == "menuButton") then
			item:SetScript("_"..scriptName, function(self)
				Cryolysis3:OpenCloseMenu(name);
			end)
		end
	end

end