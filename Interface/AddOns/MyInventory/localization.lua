-- Version : English - Ramble 
-- Translation : 
--   DE: Iruwen
MYINVENTORY_MYADDON_VERSION = "1.1.4 (1300)";



if (GetLocale() == "deDE") then

-- MYADDONS
MYINVENTORY_MYADDON_NAME = "MyInventory";
MYINVENTORY_MYADDON_DESCRIPTION = "Vereinfachtes, kompakteres Inventar.";
--KEYBINDINGS
BINDING_HEADER_MYINVENTORYHEADER= "MyInventory";
BINDING_NAME_MYINVENTORYICON= "MyInventory Toggle";
BINDING_NAME_MYINVENTORYCONFIG   = "MyInventory Konfigurationsfenster";
-- USAGE
MYINVENTORY_CHAT_COMMAND_USAGE= {
[1] = "Usage: /mi [Befehl]",
[2] = "Befehle:",
[3] = "show - MyInventory Fenster zeigen/verstecken",
[4] = "replace - Taschen ersetzen oder nicht",
[5] = "cols - Anzahl der Spalten (Taschenplaetze pro Zeile)",
[6] = "lock - Fenster Verschieben sperren/entsperren",
[7] = "back - Hintergrund aktivieren/deaktivieren",
[8] = "freeze - Fenster bei Haendlern geoeffnet lassen",
[9] = "count - Freie/belegte Taschenplaetze umschalten",
[10]= "title - Titel zeigen/verstecken",
[11]= "cash - Geld zeigen/verstecken",
[12]= "buttons - Buttons zeigen/verstecken",
[13]= "config - Konfigurationsfenster oeffnen"
--Didn't put these into slash commands yet
--[10] = "highlightitems - Items hervorheben wenn Maus ueber Tasche",
--[11] = "highlightbags - Tasche hervorheben wenn Maus ueber Item",
}
--MESSAGES
MYINVENTORY_MSG_LOADED = "Svartens/Rambles MyInventory AddOn geladen.";
MYINVENTORY_MSG_INIT_s   = "MyInventory: Profil fuer %s initialisiert.";
MYINVENTORY_MSG_CREATE_s = "MyInventory: Erstelle neues Profil fuer %s";
--OPTION TOGGLE MESSAGES
MYINVENTORY_CHAT_PREFIX            = "MyInventory: ";
MYINVENTORY_CHAT_REPLACEBAGSON     = "Ersetze Taschen.";
MYINVENTORY_CHAT_REPLACEBAGSOFF    = "Ersetze Taschen nicht.";
MYINVENTORY_CHAT_GRAPHICSON        = "Hintergrundgrafik aktiviert.";
MYINVENTORY_CHAT_GRAPHICSOFF       = "Hintergrundgrafik deaktiviert.";
MYINVENTORY_CHAT_BACKGROUNDON      = "Hintergrund undurchsichtig.";
MYINVENTORY_CHAT_BACKGROUNDOFF     = "Hintergrund durchsichtig.";
MYINVENTORY_CHAT_HIGHLIGHTBAGSON   = "Hebe Taschen hervor.";
MYINVENTORY_CHAT_HIGHLIGHTBAGSOFF  = "Hebe Taschen nicht hervor.";
MYINVENTORY_CHAT_HIGHLIGHTITEMSON  = "Hebe Items hervor.";
MYINVENTORY_CHAT_HIGHLIGHTITEMSOFF = "Hebe Items nicht hervor.";
MYINVENTORY_CHAT_FREEZEON          = "Inventar bleibt nach Haendlerbesuch offen.";
MYINVENTORY_CHAT_FREEZEOFF         = "Inventar wird nach Haendlerbesuch geschlossen.";
MYINVENTORY_CHAT_COUNTON           = "Zeige belegte Taschenplaetze."
MYINVENTORY_CHAT_COUNTOFF          = "Zeige freie Taschenplaetze."
MYINVENTORY_CHAT_SHOWTITLEON       = "Zeige Titel."
MYINVENTORY_CHAT_SHOWTITLEOFF      = "Verstecke Titel."
MYINVENTORY_CHAT_CASHON            = "Zeige Geld."
MYINVENTORY_CHAT_CASHOFF           = "Verstecke Geld."
MYINVENTORY_CHAT_BUTTONSON         = "Zeige Buttons."
MYINVENTORY_CHAT_BUTTONSOFF        = "Verstecke Buttons."
--MyInventory Title
MYINVENTORY_TITLE     = "Inventory";
MYINVENTORY_TITLE_S   = "%s's Inventory";
MYINVENTORY_TITLE_SS  = "%s of %s's Inventory";
MYINVENTORY_SLOTS_DD  = "%d/%d Slots";
--MyInventory Options frame
MYINVENTORY_CHECKTEXT_REPLACEBAGS    = "Ersetze Standard-Taschen";
MYINVENTORY_CHECKTEXT_GRAPHICS       = "Aktiviere Hintergrundgrafik";
MYINVENTORY_CHECKTEXT_BACKGROUND     = "Undurchsichtiger Hintergrund";
MYINVENTORY_CHECKTEXT_HIGHLIGHTBAGS  = "Hebe Tasche hervor";
MYINVENTORY_CHECKTEXT_HIGHLIGHTITEMS = "Hebe Item hervor";
MYINVENTORY_CHECKTEXT_SHOWTITLE      = "Zeige Titel"
MYINVENTORY_CHECKTEXT_CASH           = "Zeige Geld"
MYINVENTORY_CHECKTEXT_BUTTONS        = "Zeige Buttons"
MYINVENTORY_CHECKTEXT_FREEZE         = "Fenster bleibt geoeffnet"
MYINVENTORY_CHECKTEXT_COUNTUSED      = "Belegte Taschenplaetze"
MYINVENTORY_CHECKTEXT_COUNTFREE      = "Freie Taschenplaetze"
MYINVENTORY_CHECKTEXT_COUNTOFF       = "Aus"

MYINVENTORY_CHECKTIP_REPLACEBAGS     = "MyInventory ersetzt die Standard-Taschen wenn aktiviert.";
MYINVENTORY_CHECKTIP_GRAPHICS        = "Aktiviert Hintergrundgrafik im Blizzard-Stil.";
MYINVENTORY_CHECKTIP_BACKGROUND      = "Laesst den Hintergund undurchsichtig erscheinen wenn aktiviert.";
MYINVENTORY_CHECKTIP_HIGHLIGHTBAGS   = "Hebt die Tasche hervor in der sich ein Item befindet wenn man mit der Maus darauf zeigt.";
MYINVENTORY_CHECKTIP_HIGHLIGHTITEMS  = "Hebt die Items hervor die sich in einer Tasche befinden wenn man mit der Maus darauf zeigt.";
MYINVENTORY_CHECKTIP_SHOWTITLE       = "Zeigt den Fenstertitel an wenn aktiviert."
MYINVENTORY_CHECKTIP_CASH            = "Zeigt das Bargeld an wenn aktiviert."
MYINVENTORY_CHECKTIP_BUTTONS         = "Zeigt die Buttons an wenn aktiviert."
MYINVENTORY_CHECKTIP_FREEZE          = "Fenster bleibt bei Verlassen des Haendlers, der Bank oder des Auktionshauses geoeffnet."
MYINVENTORY_CHECKTIP_COUNTUSED       = "Zeigt die Zahl der belegten Taschenplaetze an."
MYINVENTORY_CHECKTIP_COUNTFREE       = "Zeigt die Zahl der freien Taschenplaetze an."
MYINVENTORY_CHECKTIP_COUNTOFF        = "Versteckt die Zahl der freien/belegten Taschenplaetze."
else
-- MYADDONS
MYINVENTORY_MYADDON_NAME = "MyInventory";
MYINVENTORY_MYADDON_DESCRIPTION = "A simple, compact all in one inventory window.";
--KEYBINDINGS
BINDING_HEADER_MYINVENTORYHEADER	= "My Inventory";
BINDING_NAME_MYINVENTORYICON		= "My Inventory Toggle";
BINDING_NAME_MYINVENTORYCONFIG   = "My Inventory Config Window";
-- USAGE
MYINVENTORY_CHAT_COMMAND_USAGE		= {
	[1] = "Usage: /mi [show/|replace/|cols/|lock/|graphics/|back/|config]",
	[2] = "Commands:",
	[3] = "show    - toggles the MyInventory window",
	[4] = "replace - if it should replace the bags or not",
	[5] = "cols   - how many columns there should be in each row.",
	[6] = "lock - lock/unlock the window for dragging and auto closing.",
	[7] = "graphics - Toggle Blizzard style art",
	[8] = "back - Toggle background visibility",
	[9] = "freeze - keep window open at vendors",
	[10]= "count - display count of free slots or used slots",
	[11]= "title - hide/show the title",
	[12]= "cash - hide/show the money dipslay",
	[13]= "buttons - hide/show the buttons",
	[14]= "resetpos - reset position to lower right corner of the screen",
	[15]= "aioi - toggles AIOI style bag layout",
	[16]= "config - Open control panel"
	--Didn't put these into slash commands yet
--	[10] = "highlightitems - Highlight items when you mouse over a bag icon",
--	[11] = "highlightbags - Highlight bag when you mouse over an item", 
}
--MESSAGES
MYINVENTORY_MSG_LOADED = "Svarten and Ramble's MyInventory AddOn loaded.";
MYINVENTORY_MSG_INIT_s   = "MyInventory: Profile for %s initialized.";
MYINVENTORY_MSG_CREATE_s = "MyInventory: Creating new Profile for %s";
--OPTION TOGGLE MESSAGES
MYINVENTORY_CHAT_PREFIX            = "My Inventory: ";
MYINVENTORY_CHAT_REPLACEBAGSON     = "Replacing bags.";
MYINVENTORY_CHAT_REPLACEBAGSOFF    = "Not replacing bags.";
MYINVENTORY_CHAT_GRAPHICSON        = "Background art enabled.";
MYINVENTORY_CHAT_GRAPHICSOFF       = "Background art disabled.";
MYINVENTORY_CHAT_BACKGROUNDON      = "Background is now opaque.";
MYINVENTORY_CHAT_BACKGROUNDOFF     = "Background is now transparent.";
MYINVENTORY_CHAT_HIGHLIGHTBAGSON   = "Highlighting bags.";
MYINVENTORY_CHAT_HIGHLIGHTBAGSOFF  = "Not highlighting bags.";
MYINVENTORY_CHAT_HIGHLIGHTITEMSON  = "Highlighting items.";
MYINVENTORY_CHAT_HIGHLIGHTITEMSOFF = "Not highlighting items.";
MYINVENTORY_CHAT_FREEZEON          = "Staying open when leaving vendor";
MYINVENTORY_CHAT_FREEZEOFF         = "Closing when leaving vendor";
MYINVENTORY_CHAT_COUNTON           = "Counting taken slots."
MYINVENTORY_CHAT_COUNTOFF          = "Counting free slots."
MYINVENTORY_CHAT_SHOWTITLEON       = "Title shown"
MYINVENTORY_CHAT_SHOWTITLEOFF      = "Title hidden"
MYINVENTORY_CHAT_CASHON            = "Cash Shown"
MYINVENTORY_CHAT_CASHOFF           = "Cash Hidden"
MYINVENTORY_CHAT_BUTTONSON         = "Buttons Shown"
MYINVENTORY_CHAT_BUTTONSOFF        = "Buttons Hidden"
--MyInventory Title
MYINVENTORY_TITLE     = "Inventory";
MYINVENTORY_TITLE_S   = "%s's Inventory";
MYINVENTORY_TITLE_SS  = "%s of %s's Inventory";
MYINVENTORY_SLOTS_DD  = "%d/%d Slots";
--MyInventory Options frame
MYINVENTORY_CHECKTEXT_REPLACEBAGS    = "Replace default bags";
MYINVENTORY_CHECKTEXT_GRAPHICS       = "Blizzard style artwork";
MYINVENTORY_CHECKTEXT_BACKGROUND     = "Opaque Background";
MYINVENTORY_CHECKTEXT_HIGHLIGHTBAGS  = "Highlight item's bag";
MYINVENTORY_CHECKTEXT_HIGHLIGHTITEMS = "Highlight bag's item";
MYINVENTORY_CHECKTEXT_SHOWTITLE      = "Show Title"
MYINVENTORY_CHECKTEXT_CASH           = "Show Cash"
MYINVENTORY_CHECKTEXT_BUTTONS        = "Show Buttons"
MYINVENTORY_CHECKTEXT_FREEZE         = "Keep Window Open"
MYINVENTORY_CHECKTEXT_COUNTUSED      = "Used Slots"
MYINVENTORY_CHECKTEXT_COUNTFREE      = "Free Slots"
MYINVENTORY_CHECKTEXT_COUNTOFF       = "Off"

MYINVENTORY_CHECKTIP_REPLACEBAGS     = "When checked, MyInventory takes overas the default bag";
MYINVENTORY_CHECKTIP_GRAPHICS        = "Enables Blizzard style background artwork";
MYINVENTORY_CHECKTIP_BACKGROUND      = "Turn the background on or off";
MYINVENTORY_CHECKTIP_HIGHLIGHTBAGS   = "When you mouse over an item in MyInventory it will highlight the bag that that item is in.";
MYINVENTORY_CHECKTIP_HIGHLIGHTITEMS  = "When you mouse over a bag in MyInventory it will highlight all the items that are in that bag";
MYINVENTORY_CHECKTIP_SHOWTITLE       = "Show/Hide the title and player name"
MYINVENTORY_CHECKTIP_CASH            = "Show/Hide Money display"
MYINVENTORY_CHECKTIP_BUTTONS         = "Show/Hide Close, Lock and Hide Bags Buttons"
MYINVENTORY_CHECKTIP_FREEZE          = "When leaving a vendor, Bank, or AH, keep the MI window open"
MYINVENTORY_CHECKTIP_COUNTUSED       = "Show Used slots"
MYINVENTORY_CHECKTIP_COUNTFREE       = "Show Free Slots"
MYINVENTORY_CHECKTIP_COUNTOFF        = "Hides the Slots"
end
-- UNTRANSLATED:
MYINVENTORY_CHAT_AIOISTYLEON    = "All-In-One-Inventory style item ordering.";
MYINVENTORY_CAHT_AIOISTYLEOFF   = "My Inventory style item ordering.";
