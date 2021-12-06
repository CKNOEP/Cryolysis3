--[[
"	Find a line with ""--"" in front of it, delete the ""--"" and replace """""""""
"	with the string for your language.  Be sure to preserve all spacing!"
]]

------------------------------------------------------------------------------------------------------
-- Setup the locale library
------------------------------------------------------------------------------------------------------
local L = LibStub("AceLocale-3.0"):NewLocale("Cryolysis3", "frFR");
if not L then return end

------------------------------------------------------------------------------------------------------
-- LoD (Load on Demand) error strings
------------------------------------------------------------------------------------------------------
L["Cryolysis 3 cannot load the module:"] = "Cryolysis 3 ne peut pas charger le module :" ;

L["The module is flagged as Disabled in the Blizzard AddOn interface."] = "Le module est signalé comme désactivé dans l'interface du module complémentaire Blizzard." ;
L["The module is missing. Please close the game and install it."] = "Le module est manquant. Veuillez fermer le jeu et l'installer." ;
L["The module is too old. Please close the game and update it."] = "Le module est trop ancien. Veuillez fermer le jeu et le mettre à jour." ;
L["Cryolysis 3 is currently adding items to your game's item cache.  The addon should finish loading and this dialog box should disappear once this is complete."] = "Cryolysis 3 ajoute actuellement des éléments au cache d'éléments de votre jeu. L'addon devrait finir de se charger et cette boîte de dialogue devrait disparaître une fois cette opération terminée." ;

L["Okay"] = "D'accord";


-------------------------------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------- --
-- Common messages-- Messages communs
-------------------------------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------- --
L["Found Mount: "] = "Monture trouvée : ";


-------------------------------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------- --
-- Tooltips-- Infobulles
-------------------------------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------- --
L["Mount"] = "Monture" ;
	-- Mount button locales-- Paramètres régionaux du bouton de Monture"
L["Left click to Hearthstone to "] = "Clic gauche sur Hearthstone pour ";
L["Left click to use "] = "Clic gauche pour utiliser " ;
L["Right click to use "] = "Clic droit pour utiliser " ;
L["You are not in a flyable area and you have no selected ground mount."] = "Vous n'êtes pas dans une zone pilotable et vous n'avez pas de monture au sol sélectionnée." ;
L["You have no usable mounts and no hearthstone."] = "Vous n'avez ni monture utilisable ni pierre de foyer." ;
L["Right click to Hearthstone to "] = "Clic droit sur Hearthstone pour ";
L["Middle click to Hearthstone to "] = "Clic du milieu vers Hearthstone vers ";

L["Custom Button"] = "Bouton personnalisé" ;
	-- Custom button locales-- Paramètres régionaux des boutons personnalisés"
L["No actions assigned to this button."] = "Aucune action affectée à ce bouton." ;
L["You can assign an action to this button using the Cryolysis menu."] = "Vous pouvez affecter une action à ce bouton en utilisant le menu Cryolysis." ;
L["Left"] = "Gauche"; 
L["Right"] = "Droite";  
L["Middle"] = "Millieu"; 
L["cast"] = "sort";  
L["use"] = 	"utiliser item" ;-- Lower case intended (For use in bottom most translation)
L["%s click to %s: %s"] = "%s clic vers %s : %s" ;

-------------------------------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------- --
-- Slash command locales-- Paramètres régionaux de la commande slash
-------------------------------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------- --
L["Show Menu"] = "Afficher le menu" ;
L["Open the configuration menu."] = "Ouvrir le menu de configuration." ;


-------------------------------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------- --
-- Options--Options
-------------------------------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------- --
L["Cryolysis"] = "Cryolysis" ;
L["Cryolysis 3 is an all-purpose sphere AddOn."] = "Cryolysis 3 est un AddOn de sphère tout usage." ;

-- General Options-- Options générales
L["General Settings"] = "Paramètres généraux" ;
L["Adjust various settings for Cryolysis 3."] = "Ajuster divers paramètres pour Cryolysis 3." ;
L["Lock Sphere and Buttons"] = "Verrouiller la sphère et les boutons" ;
L["Lock the main sphere and buttons so they can't be moved."] = "Verrouillez la sphère principale et les boutons pour qu'ils ne puissent pas être déplacés." ;
L["Constrict Buttons to Sphere"] = "Constriction des boutons à la sphère" ;
L["Lock the buttons in place around the main sphere."] = "Verrouillez les boutons en place autour de la sphère principale." ;
L["Hide Tooltips"] = "Masquer les info-bulles" ;
L["Hide the main sphere and button tooltips."] = "Masquer les infobulles de la sphère principale et des boutons." ;
L["Silent Mode"] = "Mode silencieux" ;
L["Hide the information messages on AddOn/module load/disable."] = "Masquer les messages d'information sur AddOn/module load/disable." ;
L["Sphere Skin"] = "Sphère Skin" ;
L["Choose the skin displayed by the Cryolysis sphere."] = "Choisissez la peau affichée par la sphère Cryolysis." ;
L["Outer Sphere Skin Behavior"] = "Comportement de la peau de la sphère extérieure" ;
L["Choose how fast you want the outer sphere skin to deplete/replenish."] = "Choisissez la vitesse à laquelle vous voulez que la peau de la sphère extérieure s'épuise/se reconstitue." ;
L["Slow"] = "Lent" ;
L["Fast"] = "Rapide" ;

-- Button Options-- Options des boutons
L["Button Settings"] = "Paramètres des boutons" ;
L["Adjust various settings for each button."] = "Ajustez divers paramètres pour chaque bouton." ;
L["Up"] = "Haut" ;
L["Right"] = "Droite" ;
L["Down"] = "Bas" ;
L["Left"] = "Gauche" ;
L["Growth Direction"] = "Direction de croissance" ;
L["Adjust which way this menu grows"] = "Ajuster la façon dont ce menu s'agrandit" ;
L["Show Item Count"] = "Afficher le nombre d'articles" ;
L["Display the item count on this button"] = "Afficher le nombre d'articles sur ce bouton" ;

-- Middle Click functionality-- Fonctionnalité clic du milieu
L["Middle-Click Key"] = "Clic du milieu" ;
L["Adjusts the key used as an alternative to a middle click."] = "Ajuste la touche utilisée comme alternative à un clic du milieu." ;
L["Alt"] = "Alt" ;
L["Shift"] = "Maj" ;
L["Ctrl"] = "Ctrl" ;

	-- Main Sphere sub-options-- Sous-options de la sphère principale"
L["Main Sphere"] = "Sphère principale" ;
L["Adjust various settings for the main sphere."] = "Ajustez divers paramètres pour la sphère principale." ;
L["Show or hide the main sphere."] = "Afficher ou masquer la sphère principale." ;
L["Scale the size of the main sphere."] = "Mettre à l'échelle la taille de la sphère principale." ;

	-- Sphere Text-- Texte de la sphère"
L["Sphere Text"] = "Texte Sphère" ;
L["Adjust what information is displayed on the sphere."] = "Ajustez les informations affichées sur la sphère." ;
L["Nothing"] = "Rien" ;
L["Current Health"] = "Santé actuelle" ;
L["Health %"] = "Vie %" ;
L["Current Mana/Energy/Rage"] = "Mana/Énergie/Rage actuel" ;
L["Mana/Energy/Rage %"] = "Mana/Énergie/Rage %" ;

	-- Outer Sphere-- Sphère extérieure"
L["Outer Sphere"] = "Sphère extérieure" ;
L["Adjust what information is displayed using the outer sphere."] = "Ajustez les informations affichées à l'aide de la sphère extérieure." ;
L["Health"] = "Santé" ;
L["Mana"] = "Mana" ;

	-- Custom Button locales-- Paramètres régionaux du bouton personnalisé"
L["First Custom Button"] = "Premier bouton personnalisé" ;
L["Second Custom Button"] = "Deuxième bouton personnalisé" ;
L["Third Custom Button"] = "Troisième bouton personnalisé" ;
L["Hide"] = "Masquer" ;
L["Show or hide this button."] = "Afficher ou masquer ce bouton." ;
L["Adjust various settings for this button."] = "Ajustez divers paramètres pour ce bouton." ;
L["Scale the size of this button."] = "Mettre à l'échelle la taille de ce bouton." ;
L["Button Type"] = "Type de bouton" ;
L["Choose whether this button casts a spell, uses a macro, or uses an item."] = "Choisissez si ce bouton lance un sort, utilise une macro ou utilise un élément." ;
L["Spell"] = "Epeler" ;
L["Macro"] = "Macro" ;
L["Item"] = "Article" ;
L["Left Click Action"] = "Action clic gauche" ;
L["Right Click Action"] = "Action clic droit" ;
L["Middle Click Action"] = "Action de clic du milieu" ;
L["Type in the name of the action that will be cast when left clicking this button."] = "Tapez le nom de l'action qui sera lancée lors d'un clic gauche sur ce bouton." ;
L["Type in the name of the action that will be cast when right clicking this button."] = "Tapez le nom de l'action qui sera lancée lors d'un clic droit sur ce bouton." ;
L["Type in the name of the action that will be cast when middle clicking this button."] = "Tapez le nom de l'action qui sera lancée en cliquant du milieu sur ce bouton." ;
L["Enter a spell, macro, or item name and PRESS ENTER. Capitalization matters."] = "Entrez un sort, une macro ou un nom d'élément et APPUYEZ SUR ENTRÉE. Les majuscules sont importantes." ;
L["Move Clockwise"] = "Déplacer dans le sens des aiguilles d'une montre" ;
L["Move this button one position clockwise."] = "Déplacer ce bouton d'une position dans le sens des aiguilles d'une montre." ;
L["Scale"] = "Echelle" ;

	-- Mount Button locales-- Paramètres régionaux du bouton de Monture"
L["Mount Button"] = "bouton Monture" ;
L["Button Behavior"] = "Comportement du bouton" ;
L["Manual"] = "Manuel" ;
L["Automatic"] = "Automatique" ;
L["Ground Mount"] = "Monture au sol" ;
L["Flying Mount"] = "Monture volante" ;
L["Left Click Mount"] = "Monture clic gauche" ;
L["Right Click Mount"] = "Monture clic droit" ;
L["Re-scan Mounts"] = "Re-scanner les montures" ;
L["Click this when you've added new mounts to your bags."] = "Cliquez dessus lorsque vous avez ajouté de nouvelles montures à vos sacs." ;

-- Module Options-- Options des modules
L["Modules Options"] = "Options des modules" ;
L["Cryolysis allows you to enable and disable parts of it.  This section gives you the ability to do so."] = "La cryolysis vous permet d'activer et de désactiver certaines parties de celle-ci. Cette section vous donne la possibilité de le faire." ;
L["Module"] = "Module" ;
L["System"] = "Système" ;
L["Loaded"] = "Chargé" ;
L["Unloaded"] = "Déchargé" ;
L["Turn this feature off if you don't use it in order to save memory and CPU power."] = "Désactivez cette fonction si vous ne l'utilisez pas afin d'économiser de la mémoire et de la puissance CPU." ;
L["Adjust various options for this module."] = "Ajuster diverses options pour ce module." ;
L["Ready"] = "Prêt" ;
L["minutes"] =  "minutes";
L["seconds"] =  "secondes";
L["Show Cooldown"] = "Afficher le temps de recharge" ;
L["Display the cooldown timer on this button"] = "Afficher le temps de recharge sur ce bouton" ;

	-- Mage Module Locales-- Paramètres régionaux du module Mage"
L["Buff Menu"] = "Menu Buff" ;
L["Teleport/Portal"] = "Téléportation/Portail" ;
L["Click to open menu."] = "Cliquez pour ouvrir le menu." ;
L["Armor"] = "Armure" ;
L["Intellect"] = "Intelligence" ;
L["Magic"] = "Magie" ;
L["Damage Shields"] = "Boucliers de dégâts" ;
L["Magical Wards"] = "Protections magiques" ;
L["Food Button"] = "Bouton Nourriture" ;
L["Water Button"] = "Bouton Eau" ;
L["Gem Button"] = "Bouton Gemme" ;

-- Main Sphere: Mage locales-- Sphère principale : Mage locales"
L["Conjured Food"] = "Nourriture conjurée" ;
L["Conjured Water"] = "Eau conjurée" ;

	-- Priest Module Locales-- Paramètres régionaux du module de prêtre"
L["Fortitude"] = "Fortesse" ;
L["Spirit"] = "Esprit" ;
L["Protection"] = "Protection" ;


	-- Message Module Options-- Options du module de messages"
L["Message"] = "Message" ;
L["Chat Channel"] = "Canal de discussion" ;
L["Choose which chat channel messages are displayed in."] = "Choisissez dans quel canal de discussion les messages sont affichés." ;
L["User"] = "Utilisateur" ;
L["Say"] = "Dire" ;
L["Party"] = "Fête" ;
L["Raid"] = "Raid" ;
L["Group"] = "Groupe" ;
L["World"] = "Monde" ;


	-- Warning Module Options-- Options du module d'avertissement"
L["Warning"] = "Avertissement" ;


	-- Reagent Restocking Module Options-- Options du module de réapprovisionnement en réactifs"
L["Reagent Restocking"] = "Réapprovisionnement en réactifs" ;
L["Restock all reagents?"] = "Réapprovisionner tous les réactifs ?" ;
L["Yes"] = "Oui" ;
L["No"] = "Non" ;
L["Confirm Restocking"] = "Confirmer le réapprovisionnement" ;
L["Pop-up a confirmation box."] = "Afficher une boîte de confirmation." ;
L["Restocking Overflow"] = "Débordement de réapprovisionnement" ;
L["If enabled, one extra stack of reagents will be bought in order to bring you above the restock amount. Only works for reagents that are bought from vendor in stacks."] = "Si activé, une pile supplémentaire de réactifs sera achetée afin de vous amener au-dessus du montant de réapprovisionnement. Ne fonctionne que pour les réactifs achetés au vendeur en piles." ;
L["Adjust the amount of "] = "Ajuster la quantité de " ;
L[" to restock to."] = " pour réapprovisionner." ;

-- Profile Options-- Options de profil
L["Profile Options"] = "Options de profil" ;
L["Cryolysis' saved variables are organized so you can have shared options across all your characters, while having different sets of custom buttons for each.  These options sections allow you to change the saved variable configurations so you can set up per-character options, or even share custom button setups between characters"] = "Les variables enregistrées dans Cryolysis3 sont organisées afin que vous puissiez avoir des options partagées entre tous vos personnages, tout en ayant différents ensembles de boutons personnalisés pour chacun. Ces sections d'options vous permettent de modifier les configurations de variables enregistrées afin que vous puissiez définir des options par personnage , ou même partager des configurations de boutons personnalisées entre les personnages" ;
L["Options profile"] = "Options profil" ;
L["Saved profile for Cryolysis 3 options"] = "Profil enregistré pour les options Cryolysis 3" ;


-------------------------------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------- --
-- Error messages-- Messages d'erreur
-------------------------------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------- --
L["Invalid name, please check your spelling and try again!"] = "Nom invalide, veuillez vérifier votre orthographe et réessayer!" ;
