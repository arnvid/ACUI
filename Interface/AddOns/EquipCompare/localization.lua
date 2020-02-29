--
-- EquipCompare localization information
--
-- Contents:
-- * Localized versions of item names that are not available by default from Blizzard
-- * Usage information
-- * Cosmos labels and information
-- * Miscellaneous labels
--
-- Supported languages:
-- English, French, German (partial)
--

-- Version ID
EQUIPCOMPARE_VERSIONID = "2.6.2";

-- "Bonus" inventory types - these must be matched to the text in-game if you are translating
EQUIPCOMPARE_INVTYPE_WAND = "Wand";
EQUIPCOMPARE_INVTYPE_GUN = "Gun";
EQUIPCOMPARE_INVTYPE_GUNPROJECTILE = "Projectile";
EQUIPCOMPARE_INVTYPE_BOWPROJECTILE = "Projectile";

-- Usage text
EQUIPCOMPARE_USAGE_TEXT = "EquipCompare "..EQUIPCOMPARE_VERSIONID.." Usage:\n"..
						  "Hover over items to compare them easily with ones you have equipped.\n"..
						  "Slash Commands:\n"..
						  "/eqc          - toggle EquipCompare on/off\n"..
						  "/eqc [on|off] - turn EquipCompare on|off\n"..
						  "/eqc control  - toggle *experimental* Control key mode on/off\n"..
						  "/eqc help     - this text\n"..
						  "(You can use /equipcompare instead of /eqc)";

-- Cosmos configuration texts
EQUIPCOMPARE_COSMOS_SECTION = "EquipCompare";
EQUIPCOMPARE_COSMOS_SECTION_INFO = "Options for Equipment Comparison tooltips.";
EQUIPCOMPARE_COSMOS_HEADER = "EquipCompare "..EQUIPCOMPARE_VERSIONID;
EQUIPCOMPARE_COSMOS_HEADER_INFO = "Options for Equipment Comparison tooltips.";
EQUIPCOMPARE_COSMOS_ENABLE = "Enable Equipment Comparison tooltips";
EQUIPCOMPARE_COSMOS_ENABLE_INFO = "By enabling this option you get extra tooltips when hovering "..
								  "over items, showing the statistics of the corresponding "..
								  "currently equipped item.";
EQUIPCOMPARE_COSMOS_CONTROLMODE = "Enable *experimental* Control key mode";
EQUIPCOMPARE_COSMOS_CONTROLMODE_INFO = "*Experimental* By enabling this option you get the extra "..
									    "tooltips only whilst holding the Control key down.";
EQUIPCOMPARE_COSMOS_SLASH_DESC = "Allows you to turn EquipCompare on and off. Type /equipcompare help for usage."

-- Misc labels
EQUIPCOMPARE_EQUIPPED_LABEL = "Currently Equipped";
EQUIPCOMPARE_GREETING = "EquipCompare "..EQUIPCOMPARE_VERSIONID.." Loaded. Enjoy.";

--
-- French
--
if (GetLocale() == "frFR") then
	-- "Bonus" inventory types
	EQUIPCOMPARE_INVTYPE_WAND = "Baguette";
	EQUIPCOMPARE_INVTYPE_GUN = "Arme \195\160 feu";
	EQUIPCOMPARE_INVTYPE_GUNPROJECTILE = "Projectile";
	EQUIPCOMPARE_INVTYPE_BOWPROJECTILE = "Projectile";

	-- Usage text
	EQUIPCOMPARE_USAGE_TEXT = "Utilisation d'EquipCompare  "..EQUIPCOMPARE_VERSIONID..":\n"..
		"Passez la souris sur les objets pour les comparer facilement avec ceux actuellement \195\169quip\195\169s.\n"..
		"Lignes de commande :\n"..
		"/eqc - (D\195\169s)Activer EquipCompare\n"..
		"/eqc [on|off] - Activer|D\195\169sactiver EquipCompare\n"..
		"/eqc control - (D\195\169s)Activer le mode *experimental* Touche Contr\195\180le\n"..
		"/eqc help - Ce texte\n"..
		"(Vous pouvez utiliser /equipcompare \195\160 la place de /eqc)";

	-- Cosmos configuration texts
	EQUIPCOMPARE_COSMOS_SECTION = "EquipCompare";
	EQUIPCOMPARE_COSMOS_SECTION_INFO = "Options des tooltips de Comparaison d'\195\137quipement";
	EQUIPCOMPARE_COSMOS_HEADER = "EquipCompare "..EQUIPCOMPARE_VERSIONID;
	EQUIPCOMPARE_COSMOS_HEADER_INFO = "Options des tooltips de Comparaison d'\195\137quipement";
	EQUIPCOMPARE_COSMOS_ENABLE = "Active les tooltips de Comparaison d'\195\137quipement";
	EQUIPCOMPARE_COSMOS_ENABLE_INFO = "En activant cette option, lorsque vous passez la souris sur un objet, "..
		"un tooltip suppl\195\169mentaire affiche les statistiques de l'objet de m\195\170me type "..
		"actuellement \195\169quip\195\169.";
	EQUIPCOMPARE_COSMOS_CONTROLMODE = "Activer le mode *experimental* Touche Contr\195\180le";
	EQUIPCOMPARE_COSMOS_CONTROLMODE_INFO = "*Experimental* En activant cette option, le tooltip suppl\195\169mentaire "..
		"ne s'affiche que lorsque vous pressez la touche Contr\195\180le.";
	EQUIPCOMPARE_COSMOS_SLASH_DESC = "Permet de (d\195\169s)activer EquipCompare. Tapez /equipcompare help pour plus d'infos.";

	-- Misc labels
	EQUIPCOMPARE_EQUIPPED_LABEL = "Actuellement \195\169quip\195\169";

--
-- German
--
elseif (GetLocale() == "deDE") then
	EQUIPCOMPARE_INVTYPE_WAND = "Zauberstab";
	EQUIPCOMPARE_INVTYPE_GUN = "Schusswaffe";
	EQUIPCOMPARE_INVTYPE_GUNPROJECTILE = "Projektil Kugel";
	EQUIPCOMPARE_INVTYPE_BOWPROJECTILE = "Projektil Pfeil";

	-- Usage text
	EQUIPCOMPARE_USAGE_TEXT = "EquipCompare  "..EQUIPCOMPARE_VERSIONID.." Verwendung:\n"..
		"Gehe mit dem Mauszeiger über Items, um diese mit anderen zu vergleichen.\n"..
		"Slash Befehle:\n"..
		"/eqc - Umschalten EquipCompare on/off\n"..
		"/eqc [on|off] - EquipCompare on|off\n"..
		"/eqc control - Umschalten des Kontroltasten-Modus (experimentell) on/off\n"..
		"/eqc help - dieser Text\n"..
		"(Aufrufbar mit /equipcompare oder /eqc)";

	-- Cosmos configuration texts
	EQUIPCOMPARE_COSMOS_SECTION = "EquipCompare";
	EQUIPCOMPARE_COSMOS_SECTION_INFO = "Optionen f\195\188r die EquipCompare-Tooltips.";
	EQUIPCOMPARE_COSMOS_HEADER = "EquipCompare "..EQUIPCOMPARE_VERSIONID;
	EQUIPCOMPARE_COSMOS_HEADER_INFO = "Optionen f\195\188r die EquipCompare-Tooltips.";
	EQUIPCOMPARE_COSMOS_ENABLE = "EquipCompare-Tooltips einschalten";
	EQUIPCOMPARE_COSMOS_ENABLE_INFO = "Wenn dies eingeschlatet wird, bekommt man extra Tooltips, wenn man dabei mit der Maus"..
		"\195\188ber die Items geht, mit den Eigenschaften der entsprechenden "..
		"derzeitig angelegten Items.";
	EQUIPCOMPARE_COSMOS_CONTROLMODE = "Einschalten des Kontroltasten-Modus (experimentell)";
	EQUIPCOMPARE_COSMOS_CONTROLMODE_INFO = "*Experimentell* wird dies eingeschaltet werden die extra"..
		"Tooltips nur angezeigt, wenn die STRG-Taste gehalten wird.";
	EQUIPCOMPARE_COSMOS_SLASH_DESC = "Erlaubt dir EquipCompare ein- und auszuschalten . Chataufruf /equipcompare f\195\188r Hilfe funktion."

	-- Misc labels
	EQUIPCOMPARE_EQUIPPED_LABEL = "Derzeitig angelegt";

end

--
-- Post-localization processing
--
if (not INVTYPE_WAND) then INVTYPE_WAND = EQUIPCOMPARE_INVTYPE_WAND end;
if (not INVTYPE_GUN) then INVTYPE_GUN = EQUIPCOMPARE_INVTYPE_GUN end;
if (not INVTYPE_GUNPROJECTILE) then INVTYPE_GUNPROJECTILE = EQUIPCOMPARE_INVTYPE_GUNPROJECTILE end;
if (not INVTYPE_BOWPROJECTILE) then INVTYPE_BOWPROJECTILE = EQUIPCOMPARE_INVTYPE_BOWPROJECTILE end;
