------------------------------------------------------------------------------------------------------
-- Test button - simple button pour déboguer les clics
------------------------------------------------------------------------------------------------------

function Cryolysis3:CreateTestButton()
	-- Créer un bouton simple avec SecureUnitButtonTemplate (comme Necrosis!)
	local testBtn = CreateFrame("Button", "Cryolysis3TestButton", UIParent, "SecureUnitButtonTemplate");

	-- Configurer la taille et la position
	testBtn:SetWidth(34);
	testBtn:SetHeight(34);
	testBtn:SetPoint("CENTER", 0, 200);
	testBtn:SetFrameStrata("MEDIUM");

	-- Créer une texture pour l'icône
	local texture = testBtn:CreateTexture("Cryolysis3TestButtonIcon", "BACKGROUND");
	texture:SetWidth(22);
	texture:SetHeight(22);
	texture:SetPoint("CENTER", testBtn, "CENTER");

	-- Obtenir l'icône du sort Évocation
	local evocationName, _, evocationIcon = GetSpellInfo(12051);
	-- Retirer le rang du nom
	if evocationName then
		evocationName = evocationName:match("^(.-)%(") or evocationName;
	end
	texture:SetTexture(evocationIcon);

	-- Créer du texte
	local fontstring = testBtn:CreateFontString("Cryolysis3TestButtonText", "OVERLAY", "GameFontNormal");
	fontstring:SetPoint("CENTER", testBtn, "CENTER");
	fontstring:SetText("TEST");

	-- Enregistrer pour les clics
	testBtn:RegisterForClicks("AnyUp");

	-- Configurer les attributs pour utiliser une MACRO qui lance le sort
	-- Les boutons sécurisés exécutent automatiquement les macros
	testBtn:SetAttribute("type1", "macro");
	testBtn:SetAttribute("macrotext1", "/cast " .. evocationName);

	testBtn:SetAttribute("type2", "macro");
	testBtn:SetAttribute("macrotext2", "/cast " .. evocationName);

	testBtn:SetAttribute("type3", "macro");
	testBtn:SetAttribute("macrotext3", "/cast " .. evocationName);

	-- Afficher le bouton
	testBtn:Show();

	Cryolysis3:Print("TEST BUTTON CREATED! Using macro: /cast "..tostring(evocationName));
end

-- Créer le bouton au chargement
Cryolysis3:CreateTestButton();
