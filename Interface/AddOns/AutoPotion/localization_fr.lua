function AUTOPOTION_FR()

-- Binding Variables
BINDING_HEADER_AUTOPOTION_HEADER				    = "AutoPotion de Jooky";
BINDING_NAME_AUTOPOTION_BINDING					    = "Ouvrir la fen\195\170tre de configuration";
BINDING_NAME_AUTOPOTION_TOGGLE					    = "Toggle AutoPotion On ou Off";

--Loaded
AUTOPOTION_LOADED_MESSAGE						    = "AutoPotion de Jooky v"..AUTOPOTION_VERSION.." charg\195\169.\nTaper /autopotion ou /ap\npour la configuration."

--myAddons strings
--*NEW*
AUTOPOTION_MYADDONS_DESC						= "Automatically uses an item to replenish your health or mana when they drop below a certain percentage."

--Item lists. Strongest item first; Weakest item last:
AUTOPOTION_SMARTREJUV_LIST						    = {"Potion de r\195\169g\195\169n\195\169ration majeure","Potion de r\195\169g\195\169n\195\169ration sup\195\169rieure","Potion de soins majeure","Potion de r\195\169g\195\169n\195\169ration excellente","Potion de soins sup\195\169rieurs","Potion de r\195\169g\195\169n\195\169ration","Potion de soins excellente","Potion de r\195\169g\195\169n\195\169ration inferieure","Potion de soins","Potion de r\195\169g\195\169n\195\169ration mineure","Potion de soins inf\195\169rieure ","Potion de soins d\195\169color\195\169e","Potion de soins mineure"};
AUTOPOTION_REJUV_LIST							    = {"Potion de r\195\169g\195\169n\195\169ration majeure","Potion de r\195\169g\195\169n\195\169ration sup\195\169rieure","Potion de r\195\169g\195\169n\195\169ration excellente","Potion de r\195\169g\195\169n\195\169ration","Potion de r\195\169g\195\169n\195\169ration inf\195\169","Potion de r\195\169g\195\169n\195\169ration mineure"};
AUTOPOTION_HEALING_LIST							    = {"Potion de soins majeure","Potion de soins sup\195\169rieurs","Potion de soins excellente","Potion de soins","Potion de soins inf\195\169rieure","Potion de soins d\195\169color\195\169e","Potion de soins mineure"};
AUTOPOTION_HEALTHSTONE_LIST						    = {"Pierre de soins majeure","Pierre de soins excellente","Pierre de soins","Pierre de soins inf\195\169rieure","Pierre de soins mineure"};
AUTOPOTION_MANA_LIST							    = {"Potion de mana majeure","Potion de mana sup\195\169rieure","Potion de mana excellente","Potion de mana","Potion de mana inf\195\169rieure","Potion de mana mineure"};
AUTOPOTION_MANACRYSTAL_LIST						    = {"Rubis de mana","Citrine de mana","Jade de mana","Agate de mana"};
AUTOPOTION_BANDAGE_LIST							    = {"Bandage en \195\169toffe runique","Bandage en tissu de mage \195\169pais","Bandage en tissu de mage","Bandage en soie \195\169paisse","Bandage en soie","Bandage en laine \195\169paisse","Bandage en laine","Bandage en lin \195\169pais","Bandage en lin"};
--*NEW*
AUTOPOTION_SOULSTONE_LIST						= {"Major Soulstone","Greater Soulstone","Soulstone","Lesser Soulstone","Minor Soulstone"};

--Slash commands:
SLASH_AUTOPOTION1								    = "/autopotion";
SLASH_AUTOPOTION2								    = "/ap";
AUTOPOTION_ENABLE_COMMAND						    = "on";
AUTOPOTION_DISABLE_COMMAND						    = "off";
AUTOPOTION_TOGGLE_COMMAND						    = "toggle";
AUTOPOTION_DUELS_COMMAND						    = "duels ";
AUTOPOTION_REVERSEORDER_COMMAND					    = "reverse";
AUTOPOTION_NORMALORDER_COMMAND					    = "normal";
AUTOPOTION_HEALTHTRIGGER_COMMAND				    = "healthpercent";
AUTOPOTION_MANATRIGGER_COMMAND					    = "manapercent";
AUTOPOTION_HEALTHSTONE_COMMAND					    = "healthstones ";
AUTOPOTION_MANASTONE_COMMAND					    = "manastones ";
--*NEW*
AUTOPOTION_SOULSTONE_COMMAND						= "soulstones ";
AUTOPOTION_REJUV_COMMAND						    = "rejuvs ";
AUTOPOTION_SMARTREJUV_COMMAND					    = "smartrejuv ";
AUTOPOTION_HEALING_COMMAND						    = "healpots ";
AUTOPOTION_MANA_COMMAND							    = "manapots ";
AUTOPOTION_BANDAGE_COMMAND						    = "bandages ";
AUTOPOTION_COMBATBANDAGE_COMMAND				    = "combatbandages ";
AUTOPOTION_DOTBANDAGE_COMMAND					    = "dotbandages ";
AUTOPOTION_USEDEFAULTS_COMMAND					    = "defaults";
AUTOPOTION_SAVEDEFAULTS_COMMAND					    = "savedefaults";

--Slash command feedback:
AUTOPOTION_SLASHUSAGE_MESSAGE					    = "Taper '/ap help' pour la liste des commandes d'AutoPotion.";
AUTOPOTION_ENABLE_MESSAGE						    = "activ\195\169";
AUTOPOTION_DISABLE_MESSAGE						    = "d\195\169sactiv\195\169";
AUTOPOTION_ENABLEDISABLE_MESSAGE				    = "AutoPotion: ";
AUTOPOTION_DUELS_MESSAGE						    = "Duels: ";
AUTOPOTION_REVERSEORDER_MESSAGE					    = "AutoPotion utilisera vos objets les plus faibles en premier.";
AUTOPOTION_NORMALORDER_MESSAGE					    = "AutoPotion utilisera vos objets les plus forts en premier.";
AUTOPOTION_HEALTHTRIGGER_MESSAGE				    = "Seuil de vie: ";
AUTOPOTION_MANATRIGGER_MESSAGE					    = "Seuil de mana: ";
AUTOPOTION_BADPERCENT_MESSAGE					    = "Entrer un nombre compris entre 0 et 100."
AUTOPOTION_HEALTHSTONE_MESSAGE					    = "Pierres de soins: ";
AUTOPOTION_MANASTONE_MESSAGE					    = "Pierres de mana: ";
--*NEW*
AUTOPOTION_SOULSTONE_MESSAGE						= "SoulStones: ";
AUTOPOTION_REJUV_MESSAGE						    = "Potions de r\195\169g\195\169n\195\169ration: ";
AUTOPOTION_SMARTREJUV_MESSAGE					    = "R\195\169g\195\169n\195\169ration intelligente: ";
AUTOPOTION_HEALING_MESSAGE						    = "Potions de soins: ";
AUTOPOTION_MANA_MESSAGE							    = "Potions de mana: ";
AUTOPOTION_BANDAGE_MESSAGE						    = "Bandages: ";
AUTOPOTION_COMBATBANDAGE_MESSAGE				    = "Utilisation en combat: ";
AUTOPOTION_DOTBANDAGE_MESSAGE					    = "Utilisation pendant les DoTs: ";
AUTOPOTION_USEDEFAULTS_MESSAGE					    = "Param\195\168tres par d\195\169faut.";
AUTOPOTION_SAVEDEFAULTS_MESSAGE					    = "Sauve les param\195\168tres actuels\nen param\195\168tres par d\195\169faut.";
AUTOPOTION_HELP_MESSAGE = {
	"Utilisation d'AutoPotion:",
	"/ap ou /autopotion - Ouvre la fen\195\170tre de configuration.",
	"/ap <commande> ou /autopotion <commande>",
	"Commandes:",
	"help - Affiche ce message d'aide.",
	"on/off - Active/D\195\169sactive AutoPotion.",
	"toggle - Active/D\195\169sactive AutoPotion, selon son \195\169tat actuel.",
	"duels on/off - Active/D\195\169sactive AutoPotion lors des Duels.",
	"normal - Ordre normal. AutoPotion utilisera vos objets les plus forts en premier.",
	"reverse - Ordre inverse. AutoPotion utilisera vos objets les plus faibles en premier.",
	"healthpercent <nombre> - Fixe le seuil de vie au pourcentage entr\195\169.",
	"manapercent <number> - Fixe le seuil de mana au pourcentage entr\195\169.",
	"healthstones on/off - Active/D\195\169sactive les pierres de soins.",
	"manastones on/off - Active/D\195\169sactive les pierres de mana.",
	"soulstones on/off - Enables/Disables use of Soulstones.", --*NEW*
	"rejuvs on/off - Active/D\195\169sactive les potions de r\195\169g\195\169n\195\169ration.",
	"smartrejuv on/off - Active/D\195\169sactive la r\195\169g\195\169n\195\169ration intelligente.",
	"(AutoPotion utilisera d'abord les potions de soins puissantes plut\195\180t que les potions de r\195\169g\195\169n\195\169rations faibles.)",
	"healpots on/off - Active/D\195\169sactive les potions de soins.",
	"manapots on/off - Active/D\195\169sactive les potions de mana.",
	"bandages on/off - Active/D\195\169sactive les bandages.",
	"combatbandages on/off - Active/D\195\169sactive l'utilisation des bandages pendant les combats.",
	"dotbandages on/off - Active/D\195\169sactive l'utilisation des bandages pendant les DoTs.",
	"defaults - Param\195\168tres par d\195\169faut.",
	"savedefaults - Sauve les param\195\168tres actuels en param\195\168tres par d\195\169faut."
};

--UI labels and tooltips:
AUTOPOTION_UI_VERSION_LABEL						    = "Version "..AUTOPOTION_VERSION;
AUTOPOTION_AP_ENABLED_CHECKBT_LABEL				    = "AutoPotion activ\195\169";
AUTOPOTION_AP_ENABLED_CHECKBT_TOOLTIP			    = "Active/D\195\169sactive AutoPotion";
AUTOPOTION_REVERSEORDER_CHECKBT_LABEL			    = "Ordre inverse";
AUTOPOTION_REVERSEORDER_CHECKBT_TOOLTIP			    = "AutoPotion utilisera d'abord\nvotre objet le plus faible.";
AUTOPOTION_AP_DISABLEFORDUELS_CHECKBT_LABEL		    = "D\195\169sactiv\195\169 lors des Duels";
AUTOPOTION_AP_DISABLEFORDUELS_CHECKBT_TOOLTIP	    = "D\195\169sactive temporairement AutoPotion\nlorsque vous \195\170tes en Duel.";

AUTOPOTION_HEALTHTRIGGER_SLIDER_LABEL			    = "Seuil de vie";
AUTOPOTION_HEALTHTRIGGER_SLIDER_TOOLTIP			    = "Quand votre vie atteindra ce niveau,\nAutoPotion essaiera de vous soigner.";
AUTOPOTION_MANATRIGGER_SLIDER_LABEL				    = "Seuil de mana";
AUTOPOTION_MANATRIGGER_SLIDER_TOOLTIP			    = "Quand votre mana atteindra ce niveau,\nAutoPotion essaiera de vous recharger.";
AUTOPOTION_STONES_ENABLED_CHECKBT_LABEL			    = "Pierres de soins";
AUTOPOTION_STONES_ENABLED_CHECKBT_TOOLTIP		    = "Active/D\195\169sactive les pierres de soins";
AUTOPOTION_CRYSTALS_ENABLED_CHECKBT_LABEL		    = "Pierres de mana";
AUTOPOTION_CRYSTALS_ENABLED_CHECKBT_TOOLTIP		    = "Active/D\195\169sactive les pierres de mana";
--*NEW*
AUTOPOTION_SOULSTONES_ENABLED_CHECKBT_LABEL				= "Enable Soulstones";
AUTOPOTION_SOULSTONES_ENABLED_CHECKBT_TOOLTIP				= "Enable/Disable Soulstones";

AUTOPOTION_REJUVENATION_ENABLED_CHECKBT_LABEL	    = "Potions de r\195\169g\195\169n\195\169ration";
AUTOPOTION_REJUVENATION_ENABLED_CHECKBT_TOOLTIP	    = "Active/D\195\169sactive les potions de r\195\169g\195\169n\195\169ration.\nAutoPotion essaiera d'utiliser une potion de\nr\195\169g\195\169n\195\169ration quand votre vie et votre mana\nseront faibles.";
AUTOPOTION_SMARTREJUV_ENABLED_CHECKBT_LABEL		    = "R\195\169g\195\169n\195\169ration intelligente";
AUTOPOTION_SMARTREJUV_ENABLED_CHECKBT_TOOLTIP	    = "Active/D\195\169sactive la r\195\169g\195\169n\195\169ration intelligente.\nAutoPotion utilisera d'abord les potions de\nsoins puissantes plut\195\180t que les potions de\n r\195\169g\195\169n\195\169rations faibles.";
AUTOPOTION_HEALTHPOTIONS_ENABLED_CHECKBT_LABEL	    = "Potions de soins";
AUTOPOTION_HEALTHPOTIONS_ENABLED_CHECKBT_TOOLTIP    = "Active/D\195\169sactive les potions de soins";
AUTOPOTION_MANAPOTIONS_ENABLED_CHECKBT_LABEL	    = "Potions de mana";
AUTOPOTION_MANAPOTIONS_ENABLED_CHECKBT_TOOLTIP	    = "Active/D\195\169sactive les potions de mana";

AUTOPOTION_BANDAGES_ENABLED_CHECKBT_LABEL		    = "Bandages";
AUTOPOTION_BANDAGES_ENABLED_CHECKBT_TOOLTIP			= "Active/D\195\169sactive les bandages.\nCeux-ci ne sont utilis\195\169s efficacement\nqu'en dehors d'un combat.";
AUTOPOTION_COMBATBANDAGES_ENABLED_CHECKBT_LABEL		= "Utilisation en combat";
AUTOPOTION_COMBATBANDAGES_ENABLED_CHECKBT_TOOLTIP	= "Force l'utilisation des bandages\npendant les combats.";
AUTOPOTION_DOTBANDAGES_ENABLED_CHECKBT_LABEL		= "Utilisation pendant les DoTs";
AUTOPOTION_DOTBANDAGES_ENABLED_CHECKBT_TOOLTIP		= "Permet l'utilisation des bandages\nlorsque vous \195\170tes affect\195\169 par un\nDamage-Over-Time,comme le\npoison par exemple.";

AUTOPOTION_DEFAULTS_BUTTON_LABEL					= "D\195\169faut";
AUTOPOTION_DEFAULTS_BUTTON_TOOLTIP					= "Param\195\168tres par d\195\169faut.";
AUTOPOTION_SAVE_DEFAULTS_BUTTON_LABEL				= "Sauver";
AUTOPOTION_SAVE_DEFAULTS_BUTTON_TOOLTIP				= "Sauve les param\195\168tres actuels\nen param\195\168tres par d\195\169faut.";
AUTOPOTION_CLOSE_BUTTON_LABEL						= "Quitter";
AUTOPOTION_CLOSE_BUTTON_TOOLTIP					    = "Sauve les param\195\168tres et ferme\nla fen\195\170tre de configuration.";

--Classes and Buffs/Debuffs:
AUTOPOTION_DRUID_CLASS							    = "druide";
AUTOPOTION_HUNTER_CLASS							    = "chasseur";
AUTOPOTION_MAGE_CLASS							    = "mage";
AUTOPOTION_PALADIN_CLASS						    = "paladin";
AUTOPOTION_PRIEST_CLASS							    = "pr\195\170tre";
AUTOPOTION_ROGUE_CLASS							    = "voleur";
AUTOPOTION_SHAMAN_CLASS							    = "chaman";
AUTOPOTION_WARLOCK_CLASS						    = "d\195\169moniste";
AUTOPOTION_WARRIOR_CLASS						    = "guerrier";
AUTOPOTION_DISABLE_MANA_CLASSES					    = {AUTOPOTION_WARRIOR_CLASS,AUTOPOTION_ROGUE_CLASS};
AUTOPOTION_DISABLE_AP_BUFFS						    = {[AUTOPOTION_ROGUE_CLASS]={"disparition"},[AUTOPOTION_DRUID_CLASS]={"Forme d'ours","Forme de f\195\169lin","Forme aquatique","Forme de transport","Forme d'ours sinistre"}};
AUTOPOTION_DISABLE_BANDAGE_DEBUFF_TYPES				= {"poison"};
AUTOPOTION_BANDAGE_COOLDOWN_DEBUFF					= "Bandage utilis\195\169 r\195\169cemment";

end