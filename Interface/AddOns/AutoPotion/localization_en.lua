function AUTOPOTION_EN()

-- Binding Variables
BINDING_HEADER_AUTOPOTION_HEADER					= "Jooky's AutoPotion";
BINDING_NAME_AUTOPOTION_BINDING						= "Open Configuration Dialog";
BINDING_NAME_AUTOPOTION_TOGGLE						= "Toggle AutoPotion On or Off";

--Loaded
AUTOPOTION_LOADED_MESSAGE						= "Jooky's AutoPotion v"..AUTOPOTION_VERSION.." loaded.  Type /autopotion or /ap for settings."

--myAddons strings
AUTOPOTION_MYADDONS_DESC						= "Automatically uses an item to replenish your health or mana when they drop below a certain percentage."

--Item lists. Strongest item first; Weakest item last:
AUTOPOTION_SMARTREJUV_LIST						= {"Major Rejuvenation Potion","Superior Rejuvenation Potion","Major Healing Potion","Greater Rejuvenation Potion","Superior Healing Potion","Rejuvenation Potion","Greater Healing Potion","Lesser Rejuvenation Potion","Healing Potion","Minor Rejuvenation Potion","Lesser Healing Potion","Discolored Healing Potion","Minor Healing Potion"};
AUTOPOTION_REJUV_LIST							= {"Major Rejuvenation Potion","Superior Rejuvenation Potion","Greater Rejuvenation Potion","Rejuvenation Potion","Lesser Rejuvenation Potion","Minor Rejuvenation Potion"};
AUTOPOTION_HEALING_LIST							= {"Major Healing Potion","Superior Healing Potion","Greater Healing Potion","Healing Potion","Lesser Healing Potion","Discolored Healing Potion","Minor Healing Potion"};
AUTOPOTION_HEALTHSTONE_LIST						= {"Major Healthstone","Greater Healthstone","Healthstone","Lesser Healthstone","Minor Healthstone"};
AUTOPOTION_MANA_LIST							= {"Major Mana Potion","Superior Mana Potion","Greater Mana Potion","Mana Potion","Lesser Mana Potion","Minor Mana Potion"};
AUTOPOTION_MANACRYSTAL_LIST						= {"Mana Ruby","Mana Citrine","Mana Jade","Mana Agate"};
AUTOPOTION_BANDAGE_LIST							= {"Runecloth Bandage","Heavy Mageweave Bandage","Mageweave Bandage","Heavy Silk Bandage","Silk Bandage","Heavy Wool Bandage","Wool Bandage","Heavy Linen Bandage","Linen Bandage"};
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
AUTOPOTION_SLASHUSAGE_MESSAGE						= "Type '/ap help' for a list of AutoPotion slash-commands.";
AUTOPOTION_ENABLE_MESSAGE						= "enabled";
AUTOPOTION_DISABLE_MESSAGE						= "disabled";
AUTOPOTION_ENABLEDISABLE_MESSAGE					= "AutoPotion: ";
AUTOPOTION_DUELS_MESSAGE						= "Duels: ";
AUTOPOTION_REVERSEORDER_MESSAGE						= "AutoPotion will use weakest items first.";
AUTOPOTION_NORMALORDER_MESSAGE						= "AutoPotion will use strongest items first.";
AUTOPOTION_HEALTHTRIGGER_MESSAGE					= "Health Trigger: ";
AUTOPOTION_MANATRIGGER_MESSAGE						= "Mana Trigger: ";
AUTOPOTION_BADPERCENT_MESSAGE						= "This requires a number between 0 and 100."
AUTOPOTION_HEALTHSTONE_MESSAGE						= "HealthStones: ";
AUTOPOTION_MANASTONE_MESSAGE						= "ManaStones: ";
AUTOPOTION_SOULSTONE_MESSAGE						= "SoulStones: ";
AUTOPOTION_REJUV_MESSAGE						= "Rejuv Potions: ";
AUTOPOTION_SMARTREJUV_MESSAGE						= "SmartRejuv: ";
AUTOPOTION_HEALING_MESSAGE						= "Healing Potions: ";
AUTOPOTION_MANA_MESSAGE							= "Mana Potions: ";
AUTOPOTION_BANDAGE_MESSAGE						= "Bandages: ";
AUTOPOTION_COMBATBANDAGE_MESSAGE					= "Bandages during combat: ";
AUTOPOTION_DOTBANDAGE_MESSAGE						= "Bandages when DoT-debuffed: ";
AUTOPOTION_USEDEFAULTS_MESSAGE						= "All settings reset to defaults.";
AUTOPOTION_SAVEDEFAULTS_MESSAGE						= "Default settings saved.";
AUTOPOTION_HELP_MESSAGE = {
	"AutoPotion Usage:",
	"/ap or /autopotion - Opens the configuration window.",
	"/ap <command> or /autopotion <command>",
	"Commands:",
	"help - Displays this help message.",
	"on/off - Enables/Disables AutoPotion.",
	"toggle - Enables/Disables AutoPotion, depending on its current state.",
	"duels on/off - Enables/Disables AutoPotion during duels.",
	"normal - Uses normal item ordering.  AutoPotion will use strongest items first.",
	"reverse - Uses reverse item ordering.  AutoPotion will use weakest items first.",
	"healthpercent <number> - Sets the health trigger to the given percent.",
	"manapercent <number> - Sets the mana trigger to the given percent.",
	"healthstones on/off - Enables/Disables use of Healthstones.",
	"manastones on/off - Enables/Disables use of Manastones.",
	"soulstones on/off - Enables/Disables use of Soulstones.",
	"rejuvs on/off - Enables/Disables drinking of Rejuvenation Potions.",
	"smartrejuv on/off - Enables/Disables smart rejuvenation drinking.",
	"(SmartRejuv will drink high-level Healing Potions before drinking low-level Rejuvs.)",
	"healpots on/off - Enables/Disables drinking of Healing Potions.",
	"manapots on/off - Enables/Disables drinking of Mana Potions.",
	"bandages on/off - Enables/Disables use of bandages.",
	"combatbandages on/off - Enables/Disables use of bandages when in combat.",
	"dotbandages on/off - Enables/Disables use of bandages when DoT-debuffed.",
	"defaults - Resets all settings to defaults.",
	"savedefaults - Saves current settings as defaults."
};

--UI labels and tooltips:
AUTOPOTION_UI_VERSION_LABEL						= "Version "..AUTOPOTION_VERSION;
AUTOPOTION_AP_ENABLED_CHECKBT_LABEL					= "AutoPotion Enabled";
AUTOPOTION_AP_ENABLED_CHECKBT_TOOLTIP					= "Enable/Disable AutoPotion";
AUTOPOTION_REVERSEORDER_CHECKBT_LABEL					= "Reverse Order";
AUTOPOTION_REVERSEORDER_CHECKBT_TOOLTIP					= "If enabled, then AutoPotion will use\nyour weakest items first.";
AUTOPOTION_AP_DISABLEFORDUELS_CHECKBT_LABEL				= "Disable for Duels";
AUTOPOTION_AP_DISABLEFORDUELS_CHECKBT_TOOLTIP				= "This will temporarily disable AutoPotion\nwhile you are dueling.";

AUTOPOTION_HEALTHTRIGGER_SLIDER_LABEL					= "Health Threshold";
AUTOPOTION_HEALTHTRIGGER_SLIDER_TOOLTIP					= "When your health reaches this level,\nAutoPotion will attempt to heal you.";
AUTOPOTION_MANATRIGGER_SLIDER_LABEL					= "Mana Threshold";
AUTOPOTION_MANATRIGGER_SLIDER_TOOLTIP					= "When your mana reaches this level,\nAutoPotion will attempt to recharge\nyou.";
AUTOPOTION_STONES_ENABLED_CHECKBT_LABEL					= "Enable Healthstones";
AUTOPOTION_STONES_ENABLED_CHECKBT_TOOLTIP				= "Enable/Disable Healthstones";
AUTOPOTION_CRYSTALS_ENABLED_CHECKBT_LABEL				= "Enable Manastones";
AUTOPOTION_CRYSTALS_ENABLED_CHECKBT_TOOLTIP				= "Enable/Disable Manastones";
AUTOPOTION_SOULSTONES_ENABLED_CHECKBT_LABEL				= "Enable Soulstones";
AUTOPOTION_SOULSTONES_ENABLED_CHECKBT_TOOLTIP				= "Enable/Disable Soulstones";

AUTOPOTION_REJUVENATION_ENABLED_CHECKBT_LABEL				= "Enable Rejuv Potions";
AUTOPOTION_REJUVENATION_ENABLED_CHECKBT_TOOLTIP				= "Enable/Disable Rejuvenation Potions\nIf enabled, then AutoPotion will attempt\nto drink a rejuvenation potion when both\nyour health and mana are low.";
AUTOPOTION_SMARTREJUV_ENABLED_CHECKBT_LABEL				= "Enable Smart Rejuv";
AUTOPOTION_SMARTREJUV_ENABLED_CHECKBT_TOOLTIP				= "Enable/Disable Smart Rejuvenation\nIf enabled, AutoPotion will prioritize\nhigh-level Healing Potions over\nlow-level Rejuvenation Potions.";
AUTOPOTION_HEALTHPOTIONS_ENABLED_CHECKBT_LABEL				= "Enable Health Potions";
AUTOPOTION_HEALTHPOTIONS_ENABLED_CHECKBT_TOOLTIP			= "Enable/Disable Healing Potions";
AUTOPOTION_MANAPOTIONS_ENABLED_CHECKBT_LABEL				= "Enable Mana Potions";
AUTOPOTION_MANAPOTIONS_ENABLED_CHECKBT_TOOLTIP				= "Enable/Disable Mana Potions";

AUTOPOTION_BANDAGES_ENABLED_CHECKBT_LABEL				= "Enable Bandages";
AUTOPOTION_BANDAGES_ENABLED_CHECKBT_TOOLTIP				= "Enable/Disable Bandages\nNote that bandages are only applied\nif you are not in combat.";
AUTOPOTION_COMBATBANDAGES_ENABLED_CHECKBT_LABEL				= "Allow in Combat";
AUTOPOTION_COMBATBANDAGES_ENABLED_CHECKBT_TOOLTIP			= "Enable/Disable use of bandages\nwhile in combat.";
AUTOPOTION_DOTBANDAGES_ENABLED_CHECKBT_LABEL				= "Allow During DoT's";
AUTOPOTION_DOTBANDAGES_ENABLED_CHECKBT_TOOLTIP				= "Allows bandaging even if\nyou are debuffed by a\nDamage-Over-Time spell,\nlike poison for example.";

AUTOPOTION_DEFAULTS_BUTTON_LABEL					= "Use Defaults";
AUTOPOTION_DEFAULTS_BUTTON_TOOLTIP					= "Reset settings to default values.";
AUTOPOTION_SAVE_DEFAULTS_BUTTON_LABEL					= "Save Defaults";
AUTOPOTION_SAVE_DEFAULTS_BUTTON_TOOLTIP					= "Saves current settings\nas the default settings.";
AUTOPOTION_CLOSE_BUTTON_LABEL						= "Close";
AUTOPOTION_CLOSE_BUTTON_TOOLTIP						= "Save settings and close this dialog.";

--Classes and Buffs/Debuffs:
AUTOPOTION_DRUID_CLASS							= "druid";
AUTOPOTION_HUNTER_CLASS							= "hunter";
AUTOPOTION_MAGE_CLASS							= "mage";
AUTOPOTION_PALADIN_CLASS						= "paladin";
AUTOPOTION_PRIEST_CLASS							= "priest";
AUTOPOTION_ROGUE_CLASS							= "rogue";
AUTOPOTION_SHAMAN_CLASS							= "shaman";
AUTOPOTION_WARLOCK_CLASS						= "warlock";
AUTOPOTION_WARRIOR_CLASS						= "warrior";
AUTOPOTION_DISABLE_MANA_CLASSES						= {AUTOPOTION_WARRIOR_CLASS,AUTOPOTION_ROGUE_CLASS};
AUTOPOTION_DISABLE_AP_BUFFS						= {[AUTOPOTION_ROGUE_CLASS]={"vanish"},[AUTOPOTION_DRUID_CLASS]={"Bear Form","Cat Form","Aquatic Form","Travel Form","Dire Bear Form"}};
AUTOPOTION_DISABLE_BANDAGE_DEBUFF_TYPES					= {"poison"};
AUTOPOTION_BANDAGE_COOLDOWN_DEBUFF					= "Recently Bandaged";

end