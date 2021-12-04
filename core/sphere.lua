------------------------------------------------------------------------------------------------------
-- Local variables
------------------------------------------------------------------------------------------------------
local Cryolysis3 = Cryolysis3;


function Cryolysis3:CalculateRGB(value)
	-- Create a table of default values
	local RGB = {
		red	= 0,
		green	= 0,
		blue	= 0,
		alpha	= 0
	}

	if value >= 0 and value <= .50 then
		RGB.red		= 1;
		RGB.green	= value * 2;
		RGB.alpha	= 1;
	else
		RGB.red		= (1 - value) * 2;
		RGB.green	= 1;
		RGB.alpha	= 1;
	end

	return RGB.red, RGB.green, RGB.blue, RGB.alpha;
end

------------------------------------------------------------------------------------------------------
-- Update attributes for the main sphere (outerSphere, sphereText, sphereAttribute)
------------------------------------------------------------------------------------------------------
function Cryolysis3:UpdateSphere(sphereType)
	if (sphereType == nil or Cryolysis3.db.char[sphereType] == nil) then
		return false;
	end
	
	local sphereFunc = tonumber(Cryolysis3.db.char[sphereType]);
	local skin = Cryolysis3.db.char.skin;
	local ChosenAttrib = 32;
	local divide;

	if (Cryolysis3.db.char.outerSphereSkin == 2) then
		-- Hack the Gibson to revert to Cryo2 skin behavior
		divide = 6.25;
	else
		-- New fancy Cryo3 behavior
		divide = 3.125;
	end

	if (sphereType == "outerSphere") then
		-- Update outer-sphere graphic based on the chosen attribute
		if sphereFunc == 2 then		-- Show Health
			-- Get the player's health % and translate into 1/32 ticks
			ChosenAttrib = floor(((UnitHealth("player") / UnitHealthMax("player")) * 100) / divide);
		
		elseif sphereFunc == 3 then	-- Show Mana/Energy/Rage
			-- Get the player's Mana/Energy/Rage % and translate into 1/32 ticks
			ChosenAttrib = floor(((UnitMana("player") / UnitManaMax("player")) * 100) / divide);
		end

		if (Cryolysis3.db.char.outerSphereSkin == 2) then
			-- We're using Cryo3 behavior
			if (ChosenAttrib == 16) then
				-- 32 is the full shard
				ChosenAttrib = 32;
			end
		end

		-- Set the texture of the main sphere
		Cryolysis3Sphere:SetNormalTexture("Interface\\Addons\\Cryolysis3\\textures\\"..skin.."\\Shard"..ChosenAttrib..".tga")
	
	elseif (sphereType == "sphereText") then
		local sphereText = "";
		local red, green, blue, alpha = 0;

		if (sphereFunc == 1) then
			-- Remove the text from the sphere text
			Cryolysis3SphereText:SetText("");

		elseif (sphereFunc == 2) then
			-- Set health value
			red, green, blue, alpha = Cryolysis3:CalculateRGB(UnitHealth("player") / UnitHealthMax("player"));
			sphereText = UnitHealth("player");

		elseif (sphereFunc == 3) then
			-- Set Health %
			local healthValue = UnitHealth("player") / UnitHealthMax("player");
			
			red, green, blue, alpha = Cryolysis3:CalculateRGB(healthValue);
			sphereText = floor(healthValue * 100).."%";
		
		elseif (sphereFunc == 4) then
			-- Set Mana/Energy/Rage value
			red, green, blue, alpha = Cryolysis3:CalculateRGB(UnitMana("player") / UnitManaMax("player"));
			sphereText = UnitMana("player");
		
		elseif (sphereFunc == 5) then
			-- Set Mana/Energy/Rage %
			local manaValue = UnitMana("player") / UnitManaMax("player");
			
			red, green, blue, alpha = Cryolysis3:CalculateRGB(manaValue);
			sphereText = floor(manaValue * 100).."%";
		end
		
		if (sphereText ~= "") then
			-- Finally set the text color and text
			Cryolysis3SphereText:SetTextColor(red, green, blue, alpha);
			Cryolysis3SphereText:SetText(sphereText);
		end
	
	elseif (sphereType == "sphereAttribute") then
		
	end
end