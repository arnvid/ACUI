--[[
	myAddOns v1.2
]]


--------------------------------------------------------------------------------------------------
-- Localized messages and options
--------------------------------------------------------------------------------------------------

MYADDONS_DESCRIPTION = "An AddOns menu added to the Main Menu";
MYADDONS_LOADED = "myAddOns AddOn loaded";
MYADDONS_LABEL_NAME = "Name";
MYADDONS_BUTTON_REMOVE = "Remove";
MYADDONS_BUTTON_OPTIONS = "Options";
MYADDONS_CATEGORY_BARS = "Bars";
MYADDONS_CATEGORY_CHAT = "Chat";
MYADDONS_CATEGORY_CLASS = "Class";
MYADDONS_CATEGORY_COMBAT = "Combat";
MYADDONS_CATEGORY_COMPILATIONS = "Compilations";
MYADDONS_CATEGORY_GUILD = "Guild";
MYADDONS_CATEGORY_INVENTORY = "Inventory";
MYADDONS_CATEGORY_MAP = "Map";
MYADDONS_CATEGORY_OTHERS = "Others";
MYADDONS_CATEGORY_PROFESSIONS = "Professions";
MYADDONS_CATEGORY_QUESTS = "Quests";
MYADDONS_CATEGORY_RAID = "Raid";

-- Check the client language
if (GetLocale() == "frFR") then
	MYADDONS_DESCRIPTION = "Un menu AddOns ajouté au Menu Principal";
	MYADDONS_LOADED = "AddOn myAddOns chargé";
	MYADDONS_LABEL_NAME = "Nom";
	MYADDONS_BUTTON_REMOVE = "Retirer";
	MYADDONS_BUTTON_OPTIONS = "Options";
	MYADDONS_CATEGORY_BARS = "Barres";
	MYADDONS_CATEGORY_CHAT = "Chat";
	MYADDONS_CATEGORY_CLASS = "Classe";
	MYADDONS_CATEGORY_COMBAT = "Combat";
	MYADDONS_CATEGORY_COMPILATIONS = "Compilations";
	MYADDONS_CATEGORY_GUILD = "Guilde";
	MYADDONS_CATEGORY_INVENTORY = "Inventaire";
	MYADDONS_CATEGORY_MAP = "Carte";
	MYADDONS_CATEGORY_OTHERS = "Autres";
	MYADDONS_CATEGORY_PROFESSIONS = "Professions";
	MYADDONS_CATEGORY_QUESTS = "Quêtes";
	MYADDONS_CATEGORY_RAID = "Raid";
elseif (GetLocale() == "deDE") then
	MYADDONS_DESCRIPTION = "Ein zum Optionsmenu hinzugefügtes AddOnsmenü";
	MYADDONS_LOADED = "myAddOns AddOn geladen";
	MYADDONS_LABEL_NAME = "Name";
	MYADDONS_BUTTON_REMOVE = "Entfernen";
	MYADDONS_BUTTON_OPTIONS = "Optionen";
	MYADDONS_CATEGORY_BARS = "Leiste";
	MYADDONS_CATEGORY_CHAT = "Chat";
	MYADDONS_CATEGORY_CLASS = "Klass";
	MYADDONS_CATEGORY_COMBAT = "Kampf";
	MYADDONS_CATEGORY_COMPILATIONS = "Kompilations";
	MYADDONS_CATEGORY_GUILD = "Gilde";
	MYADDONS_CATEGORY_INVENTORY = "Inventar";
	MYADDONS_CATEGORY_MAP = "Karte";
	MYADDONS_CATEGORY_OTHERS = "Andere";
	MYADDONS_CATEGORY_PROFESSIONS = "Berufe";
	MYADDONS_CATEGORY_QUESTS = "Quests";
	MYADDONS_CATEGORY_RAID = "Schlachtzug";
end
