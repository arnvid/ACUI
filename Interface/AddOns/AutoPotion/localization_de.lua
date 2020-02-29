function AUTOPOTION_DE()

-- Binding Variables
BINDING_HEADER_AUTOPOTION_HEADER					= "Jooky's AutoPotion";
BINDING_NAME_AUTOPOTION_BINDING						= "Konfigurationsdialog \195\182ffnen";
BINDING_NAME_AUTOPOTION_TOGGLE						= "AutoPotion An und Aus schalten";

--Loaded
AUTOPOTION_LOADED_MESSAGE						= "Jooky's AutoPotion v"..AUTOPOTION_VERSION.." geladen.  Tippe /autopotion oder /ap f\195\188r Einstellungen."

--myAddons strings
--*NEW*
AUTOPOTION_MYADDONS_DESC						= "Automatically uses an item to replenish your health or mana when they drop below a certain percentage."

--Item lists. Strongest item first; Weakest item last:
AUTOPOTION_SMARTREJUV_LIST						= {"G\195\182ttlicher Verj\195\188ngungstrank","G\195\182ttlicher Heiltrank","Extrastarker Verj\195\188ngungstrank","Extrastarker Heiltrank","Starker Verj\195\188ngungstrank","Starker Heiltrank","Verj\195\188ngungstrank","Heiltrank","Verf\195\164rbter Heiltrank","Geringer Verj\195\188ngungstrank","Geringer Heiltrank","Schwacher Verj\195\188ngungstrank","Schwacher Heiltrank"};
AUTOPOTION_REJUV_LIST							= {"G\195\182ttlicher Verj\195\188ngungstrank","Extrastarker Verj\195\188ngungstrank","Starker Verj\195\188ngungstrank","Verj\195\188ngungstrank","Geringer Verj\195\188ngungstrank","Schwacher Verj\195\188ngungstrank"};
AUTOPOTION_HEALING_LIST							= {"G\195\182ttlicher Heiltrank","Extrastarker Heiltrank","Starker Heiltrank","Heiltrank","Verf\195\164rbter Heiltrank","Geringer Heiltrank","Schwacher Heiltrank"};
AUTOPOTION_HEALTHSTONE_LIST						= {"Extrastarker Gesundheitsstein","Starker Gesundheitsstein","Gesundheitsstein","Geringer Gesundheitsstein","Schwacher Gesundheitsstein"};
AUTOPOTION_MANA_LIST							= {"G\195\182ttlicher Manatrank","Extrastarker Manatrank","Starker Manatrank","Manaelixier","Manatrank","Geringer Manatrank","Schwacher Manatrank"};
AUTOPOTION_MANACRYSTAL_LIST						= {"Mana Rubin","Mana Citrin","Mana Jade","Mana Agate","Manakristall"};
AUTOPOTION_BANDAGE_LIST							= {"Schwerer Runenstoffverband","Runenstoffverband","Schwerer Magiergewirkter Verband","Magiergewirkter Verband","Schwerer Seidenverband","Seidenverband","Schwerer Wollverband","Wollverband","Schwerer Leinenverband","Leinenverband"};
--*NEW*
AUTOPOTION_SOULSTONE_LIST						= {"Major Soulstone","Greater Soulstone","Soulstone","Lesser Soulstone","Minor Soulstone"};

--Slash commands:
SLASH_AUTOPOTION1							= "/autopotion";
SLASH_AUTOPOTION2							= "/ap";
AUTOPOTION_ENABLE_COMMAND						= "on";
AUTOPOTION_DISABLE_COMMAND						= "off";
AUTOPOTION_TOGGLE_COMMAND						= "toggle";
AUTOPOTION_DUELS_COMMAND						= "duels ";
AUTOPOTION_REVERSEORDER_COMMAND						= "reverse";
AUTOPOTION_NORMALORDER_COMMAND						= "normal";
AUTOPOTION_HEALTHTRIGGER_COMMAND					= "healthpercent";
AUTOPOTION_MANATRIGGER_COMMAND						= "manapercent";
AUTOPOTION_HEALTHSTONE_COMMAND						= "healthstones ";
AUTOPOTION_MANASTONE_COMMAND						= "manastones ";
--*NEW*
AUTOPOTION_SOULSTONE_COMMAND						= "soulstones ";
AUTOPOTION_REJUV_COMMAND						= "rejuvs ";
AUTOPOTION_SMARTREJUV_COMMAND						= "smartrejuv ";
AUTOPOTION_HEALING_COMMAND						= "healpots ";
AUTOPOTION_MANA_COMMAND							= "manapots ";
AUTOPOTION_BANDAGE_COMMAND						= "bandages ";
AUTOPOTION_COMBATBANDAGE_COMMAND					= "combatbandages ";
AUTOPOTION_DOTBANDAGE_COMMAND						= "dotbandages ";
AUTOPOTION_USEDEFAULTS_COMMAND						= "defaults";
AUTOPOTION_SAVEDEFAULTS_COMMAND						= "savedefaults";

--Slash command feedback:
AUTOPOTION_SLASHUSAGE_MESSAGE						= "Tippe '/ap help' fuer eine Liste der AutoPotion slash-commands.";
AUTOPOTION_ENABLE_MESSAGE						= "An";
AUTOPOTION_DISABLE_MESSAGE						= "Aus";
AUTOPOTION_ENABLEDISABLE_MESSAGE					= "AutoPotion: ";
AUTOPOTION_DUELS_MESSAGE						= "Duelle: ";
AUTOPOTION_REVERSEORDER_MESSAGE						= "AutoPotion benutzt den schw\195\164chsten Gegenstand zuerst.";
AUTOPOTION_NORMALORDER_MESSAGE						= "AutoPotion benutzt den st\195\164rksten Gegenstand zuerst.";
AUTOPOTION_HEALTHTRIGGER_MESSAGE					= "Gesundheit Schwellenwert: ";
AUTOPOTION_MANATRIGGER_MESSAGE						= "Mana Schwellenwert: ";
AUTOPOTION_BADPERCENT_MESSAGE						= "Hier wird eine Zahl zwischen 0 und 100 ben\195\182tigt.";
AUTOPOTION_HEALTHSTONE_MESSAGE						= "Gesundheitssteine: ";
AUTOPOTION_MANASTONE_MESSAGE						= "Manakristalle: ";
--*NEW*
AUTOPOTION_SOULSTONE_MESSAGE						= "SoulStones: ";
AUTOPOTION_REJUV_MESSAGE						= "Verj\195\188ngungstr\195\164nke: ";
AUTOPOTION_SMARTREJUV_MESSAGE						= "SchlauVerj\195\188ngen: ";
AUTOPOTION_HEALING_MESSAGE						= "Gesundheitstr\195\164nke: ";
AUTOPOTION_MANA_MESSAGE							= "Manatr\195\164nke: ";
AUTOPOTION_BANDAGE_MESSAGE						= "Bandagen: ";
AUTOPOTION_COMBATBANDAGE_MESSAGE					= "Im Kampf bandagieren: ";
AUTOPOTION_DOTBANDAGE_MESSAGE						= "Bandagieren w\195\164hrend Zeitschaden-Effekten: ";
AUTOPOTION_USEDEFAULTS_MESSAGE						= "Alle Einstellungen auf Default zur\195\188ckgesetzt.";
AUTOPOTION_SAVEDEFAULTS_MESSAGE						= "Aktuelle Einstellungen als Default gespeichert.";
AUTOPOTION_HELP_MESSAGE = {
	"AutoPotion Benutzung:",
	"/ap or /autopotion - oeffnet das Konfigurationsfenster.",
	"/ap <Befehl> oderr /autopotion <Befehl>",
	"Befehle:",
	"help - Zeigt diese Hilfenachricht.",
	"on/off - AutoPotion An/Aus.",
	"toggle - Schaltet AutoPotion An/Aus, je nachdem wie es gerade eingestellt ist.",
	"duels on/off - AutoPotion An/Aus waehrend Duellen.",
	"normal - Normale Reihenfolge.  AutoPotion benutzt den staerksten Gegenstand zuerst.",
	"reverse - Umgekehrte Reihenfolge.  AutoPotion benutzt den schwaechsten Gegenstand zuerst.",
	"healthpercent <number> - Setzt den Gesundheits-Schwellenwert auf eine Prozentzahl.",
	"manapercent <number> - Setzt den Mana-Schwellenwert auf eine Prozentzahl.",
	"healthstones on/off - An/Aus Benutzung von Gesundheitssteinen.",
	"manastones on/off - An/Aus Benutzung von Manakristallen.",
	"soulstones on/off - Enables/Disables use of Soulstones.", --*NEW*
	"rejuvs on/off - An/Aus Benutzung von Verjuengungstraenken.",
	"smartrejuv on/off - An/Aus Schlaue Benutzung von Verjuengungstraenken.",
	"(SmartRejuv trinkt hohe Gesundheitstraenke vor niedrigen Verjuengungstraenken.)",
	"healpots on/off - An/Aus trinken von Heiltraenken.",
	"manapots on/off - An/Aus trinken von Manatraenken.",
	"bandages on/off - An/Aus benutzen von Bandagen.",
	"combatbandages on/off - An/Aus benutzen von Bandagen im Kampf.",
	"dotbandages on/off - An/Aus Bandagieren waehrend Zeitschaden-Effekten.",
	"defaults - Alle Einstellungen auf Default zuruecksetzen.",
	"savedefaults - Aktuelle Einstellungen als Default speichern."
};

--UI labels and tooltips:
AUTOPOTION_UI_VERSION_LABEL						= "Version "..AUTOPOTION_VERSION;
AUTOPOTION_AP_ENABLED_CHECKBT_LABEL					= "AutoPotion Ein";
AUTOPOTION_AP_ENABLED_CHECKBT_TOOLTIP					= "Ein-/Ausschalten von AutoPotion";
AUTOPOTION_REVERSEORDER_CHECKBT_LABEL					= "Umgekehrte Reihenfolge";
AUTOPOTION_REVERSEORDER_CHECKBT_TOOLTIP					= "Wenn eingeschaltet benutzt Autoption\ndas schw\195\164chste Item zuerst.";
AUTOPOTION_AP_DISABLEFORDUELS_CHECKBT_LABEL				= "Aus bei Duell";
AUTOPOTION_AP_DISABLEFORDUELS_CHECKBT_TOOLTIP				= "Autoption w\195\164hrend Duellen\nvorr\195\188bergehend ausschalten.";

AUTOPOTION_HEALTHTRIGGER_SLIDER_LABEL					= "Gesundheitsgrenzwert";
AUTOPOTION_HEALTHTRIGGER_SLIDER_TOOLTIP					= "Wenn die Gesundheit diesen Wert erreicht\nversucht Autopotion Dich zu heilen.";
AUTOPOTION_MANATRIGGER_SLIDER_LABEL					= "Mana Grenzwert";
AUTOPOTION_MANATRIGGER_SLIDER_TOOLTIP					= "Wenn das Mana diesen Wert erreicht\nversucht Autopotion Dich aufzuladen.";
AUTOPOTION_STONES_ENABLED_CHECKBT_LABEL					= "Heilsteine Ein";
AUTOPOTION_STONES_ENABLED_CHECKBT_TOOLTIP				= "Heilsteine Ein/Aus";
AUTOPOTION_CRYSTALS_ENABLED_CHECKBT_LABEL				= "Manasteine Ein";
AUTOPOTION_CRYSTALS_ENABLED_CHECKBT_TOOLTIP				= "Manasteine Ein/Aus";
--*NEW*
AUTOPOTION_SOULSTONES_ENABLED_CHECKBT_LABEL				= "Enable Soulstones";
AUTOPOTION_SOULSTONES_ENABLED_CHECKBT_TOOLTIP				= "Enable/Disable Soulstones";

AUTOPOTION_REJUVENATION_ENABLED_CHECKBT_LABEL				= "Verj\195\188ngungstr\195\164nke Ein";
AUTOPOTION_REJUVENATION_ENABLED_CHECKBT_TOOLTIP				= "Ein/Aus von Verj\195\188ngungstr\195\164nken\nWenn eingeschaltet versucht Autopotion\neinen Verj\195\188ngungstrak zu trinken wenn sowohl\nGesundheit oder Magiekraft niedrig sind.";
AUTOPOTION_SMARTREJUV_ENABLED_CHECKBT_LABEL				= "Schlaues Verj\195\188ngen Ein";
AUTOPOTION_SMARTREJUV_ENABLED_CHECKBT_TOOLTIP				= "Ein/Aus schlaues Verj\195\188ngen\nWenn eingeschaltet wird Autopotion\nzuerst hohe Heiltr\195\164nke vor\nniedrigeren Verj\195\188ngungstr\195\164nken nehmen.";
AUTOPOTION_HEALTHPOTIONS_ENABLED_CHECKBT_LABEL				= "Heiltr\195\164nke Ein";
AUTOPOTION_HEALTHPOTIONS_ENABLED_CHECKBT_TOOLTIP			= "Ein/Aus von Heiltr\195\164nken";
AUTOPOTION_MANAPOTIONS_ENABLED_CHECKBT_LABEL				= "Manatr\195\164nke Ein";
AUTOPOTION_MANAPOTIONS_ENABLED_CHECKBT_TOOLTIP				= "Ein/Aus von Manatr\195\164nken";

AUTOPOTION_BANDAGES_ENABLED_CHECKBT_LABEL				= "Bandagen einschalten";
AUTOPOTION_BANDAGES_ENABLED_CHECKBT_TOOLTIP				= "Ein/Aus von Bandagen\nBandagen werden nur verwendet wenn\nDu nicht im Kampf bist.";
AUTOPOTION_COMBATBANDAGES_ENABLED_CHECKBT_LABEL				= "Im Kampf zulassen";
AUTOPOTION_COMBATBANDAGES_ENABLED_CHECKBT_TOOLTIP			= "An/Aus von Bandagen\nw\195\164hrend des Kampfes.";
AUTOPOTION_DOTBANDAGES_ENABLED_CHECKBT_LABEL				= "An w\195\164hrend DoT";
AUTOPOTION_DOTBANDAGES_ENABLED_CHECKBT_TOOLTIP				= "Bandagieren auch w\195\164hren\nZeitschaden-Debuffs (DoT)\nwie z.B. Gift.";

AUTOPOTION_DEFAULTS_BUTTON_LABEL					= "Defaults";
AUTOPOTION_DEFAULTS_BUTTON_TOOLTIP					= "Setzt alle Einstellungen auf Voreinstellung zur\195\188ck.";
AUTOPOTION_SAVE_DEFAULTS_BUTTON_LABEL					= "Def. speichern";
AUTOPOTION_SAVE_DEFAULTS_BUTTON_TOOLTIP					= "Aktuelle Einstellungen\nals Standard speichern.";
AUTOPOTION_CLOSE_BUTTON_LABEL						= "Schliessen";
AUTOPOTION_CLOSE_BUTTON_TOOLTIP						= "Einstellungen speichern und dies Fenster schliessen.";

--Classes and Buffs/Debuffs:
AUTOPOTION_DRUID_CLASS							= "druide";
AUTOPOTION_HUNTER_CLASS							= "j\195\164ger";
AUTOPOTION_MAGE_CLASS							= "magier";
AUTOPOTION_PALADIN_CLASS						= "paladin";
AUTOPOTION_PRIEST_CLASS							= "priester";
AUTOPOTION_ROGUE_CLASS							= "schurke";
AUTOPOTION_SHAMAN_CLASS							= "schamane";
AUTOPOTION_WARLOCK_CLASS						= "hexenmeister";
AUTOPOTION_WARRIOR_CLASS						= "krieger";
AUTOPOTION_DISABLE_MANA_CLASSES						= {AUTOPOTION_WARRIOR_CLASS,AUTOPOTION_ROGUE_CLASS};
AUTOPOTION_DISABLE_AP_BUFFS						= {[AUTOPOTION_ROGUE_CLASS]={"entschwinden"},[AUTOPOTION_DRUID_CLASS]={"b\195\164rengestalt","katzengestalt","wassergestalt","reisegestalt","terrorb\195\164rengestalt"}};
AUTOPOTION_DISABLE_BANDAGE_DEBUFF_TYPES					= {"gift"};
AUTOPOTION_BANDAGE_COOLDOWN_DEBUFF					= "K\195\188rzlich bandagiert";

end