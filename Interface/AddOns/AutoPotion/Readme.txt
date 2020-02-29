Jooky's Auto Potion v2.2
When health or mana drop below a defined threshold,
AutoPotion will do one of the following:
     Drink a Rejuvenation Potion
     Use a Healthstone
     Drink a Healing Potion
     Use a Manastone
     Drink a Mana Potion
     Use a Bandage

Usage:
In your keybindings, bind a key to open/close the AutoPotion config dialog, or type "/ap" to open and close the dialog.
Slash-commands are available for all settings.  Type "/ap help" for details.

Version history:

----------v2.2 - 2005.03.19 -----------------------------------------
* Interface number updated to 1300
* Css8 has put in a ton of work to add SoulStones to AutoPotion.  Huge thanks to Css8 for the new feature!  Localizers may wish to review the new strings.
* Added slash-command for soulstones.
* Added support for Scheid's fabulous myAddons addon, which everyone should download immediately from http://www.curse-gaming.com/mod.php?addid=358.

----------v2.1.2 - 2005.03.07 ---------------------------------------
* Fixed bug that caused AutoPotion to drink a healing potion when the player un-feigns.

----------v2.1.1 - 2005.02.24 ---------------------------------------
* Updates made to German and French localizations.  Thanks Yeshe and Norn!
* No code changes.  English version is unchanged.

----------v2.1 - 2005.02.23 -----------------------------------------
* Removed Cooldown sliders from Config Dialog.  They are no longer necessary.
* Added Slash-Commands for all functions.  Type "/ap help" for details.
* Added Checkbox to allow bandaging even if you're debuffed by a DoT (specifically, poison).  Bandages must be enabled for this option to appear.
* Added Checkbox to disable AutoPotion while the player is dueling.
* Added a language menu.  It is no longer necessary to move localization files to use AutoPotion in your language.  The first time you login with the new version, AutoPotion will be in English.  Just choose your language from the menu and you won't need to change it again.
* German localization updated by Yeshe.
* French localization updated by Norn.
* Optimized a great deal of the code.

----------v2.03 - 2005.02.21 ----------------------------------------
* Re-fixed the re-broken Feign Death bug.  Two steps forward, one step back.

----------v2.02 - 2005.02.19 ----------------------------------------
* Nil errors eradicated.  The end?
* Druid should hopefully no longer attempt to use items at all when shapeshifted
* Feign death checks are now only performed for Hunter classes, instead of all classes.

----------v2.01 - 2005.02.17 ----------------------------------------
* Added UNKNOWNBEING to player name checks.  If this doesn't kill the nil errors, I don't know what will.

----------v2.0 - 2005.02.16 ----------------------------
NOTE: Localizers may want to review the localizations.lua file for new strings.
* I firmly believe that I have now fixed all nil string errors.  Any nil errors you receive from now on are simply figments of your imagination. :P
* Fixed a bug that caused AutoPotion to drink high-level healing potions in the wrong order.
* Druid shapeshift forms should now disable AutoPotion until you un-shapeshift. (ATTN: Localizers look here.)
* Updated .toc for interface version 4211.

----------v1.9.4.1 - 2005.02.15 ------------------------
NOTE: Localizers may want to review the localizations.lua file for new strings.
* Should no longer apply bandages if the player is poisoned.
* Reworked buff and debuff searching to make adding things like this easier in the future
* Fixed a nil error that would occur for some players when zoning in or out of an instance

----------v1.9.4 - 2005.02.15 --------------------------
NOTE: Localizers may want to review the localizations.lua file for new strings.
* Added "Allow bandages during combat" option.  Bandages must be enabled for this option to appear.
* Added option for user to set his/her own defaults.  Click "Save Defaults" to save the current settings as the default settings.
* Added French localization!  Thank you, Norn! (Some strings are not translated.  This is because I made a few changes AFTER Norn submitted the localization.  This is my fault.)
* Made player name checks compatible with all languages
* Attempted to disable AutoPotion if player has Vanished.  This is untested.  Please tell me if this doesn't work.
* Disabled mana drinking for Rogues (This will probably only work for English versions until localizations are updated).

----------v1.9.3 - 2005.02.11 --------------------------
* Settings are now saved per server, in addition to per character.
* Warriors will no longer auto-drink mana potions, even if mana drinking is enabled.

----------v1.9.2 - 2005.02.08 --------------------------
* Fixed a bug where settings may not have been saved for certain players, or AutoPotion wouldn't work for certain players.

----------v1.9.1 - 2005.02.07 --------------------------
* German localization updated.  Thanks again, Yeshe!

----------v1.9 - 2005.02.04 ----------------------------
* Settings are now saved on a per-user basis (long overdue)
* Added keybinding and slash-command to toggle AutoPotion-Enabled.
-->/ap toggle

1.8.1---------------------------------------------------
     --Added German Localization.  Thank you, Yeshe!

1.8-----------------------------------------------------
     --Re-fixed the Channeled Spell bug. (I accidentally un-fixed this when
       I merged my code with Ygrane's in version 1.7)
     --Moved all strings into localization.lua file, in case anyone feels like
       doing a translation.
     --Standardized my templating system for UI elements, so new widgets
       should be much easier to add in the future
     --Reorganized and recommented the code, as well as cleaned it up a bit
     --Note: I have found (but not yet fixed) a bug that happens if you have
       an item in your inventory that is too high-level for your character
       to use.  For example, if you've got a high-level mana potion in your
       bag, but your character isn't high-enough level to use it, AutoPotion
       will find and attempt to use that potion.  When it does, it resets
       the potion timer even though the game didn't allow you to drink the
       potion.  This will prevent AutoPotion from attempting to drink another
       potion until AutoPotion's internal potion cooldown time expires.  The
       best way to avoid this bug is to just not carry any AutoPotion-usable 
       items that are too high-level for you to use.

1.7-----------------------------------------------------
     --Major code optimizations by Ygrane
     --Option to reverse item lists (to use weakest item first) by Ygrane
     --Reverse List Order checkbox added to UI (I did that!)

1.6.3---------------------------------------------------
     --AutoPotion will no longer try to replenish mana if the player is
       channelling a spell (this includes the use of Rejuvs, Manastones, and
       mana potions).

1.6.2---------------------------------------------------
     --Fixed the Feign Death bug.  You should now be able to feign death safely
       without drinking a potion.

1.6.1---------------------------------------------------
     --Fixed the close button on the dialog so the enable/disable slash command
       should work without reopening the dialog.
     --Tweaked chat display a little to make it more reliable (I hope)
     --Made a small change to (hopefully) make variable-saving more reliable

1.6---------------------------------------------------
     --Added slash-command for disabling/enabling AP, so that people can do so
       in macros (This is a workaround for the fact that AP breaks Feign Death;
       now you can write a macro for Feign Death that will disable AP first.)
       The commands work as follows:
       /autopotion on -- enables autopotion
       /autopotion off -- disables autopotion
     --Bandages are now disabled by default, due to Blizzard's "fix" to the way
       bandages work.
     --Fixed a bug that would drink a lower-level potion if its name contained
       the name of a higher-level potion.  (For example, the name "Lesser Healing
       Potion" contains the name "Healing Potion", so sometimes I would drink a
       Lesser Healing Potion when I really should've been drinking a regular
       Healing Potion.)  Now I look for exact string matches rather than substrings.
     --Used Dhargo/Mairelon's TableCopy function for resetting to defaults
     --Major code cleanup:
       Various actions placed into functions and executed one-by-one.
       Completely removed Combat-Only/Always switch.
       I no longer check when event was passed for determining what action to fire,
          since it doesn't really matter.  This means that I now check health and
          mana more often.  Overall, this should be somewhat more reliable.

1.5---------------------------------------------------
     --Now with GUI!
     --Added key-binding for opening the config dialog
     --General code clean-up
     --Removed Combat-Only/Always switch.  AutoPotion now functions only in
       combat (except for bandages, which will kick in after combat is
       finished.)  The code for switching modes still remains, however, in case 
       enough people want that functionality.

1.4.3 - 2004.12.23------------------------------------
     --Moved UI stuff into functions to prepare for graphical UI

1.4.2 - 2004.12.22------------------------------------
     --Updated version number for 1.2.1 patch

1.4.1-------------------------------------------------
     --Fixed a horrible bug that rendered potion-drinking useless due to
       misplaced return statements.

1.4---------------------------------------------------
     --Implemented bandages for non-combat use only.  Always and Combat-Only
       Modes don't apply for bandages.  If bandages are enabled, they will be
       used when you need them, as long as you are not in combat.
     --Merged Healthstone and Mana Crystal cooldowns into one timer

1.3---------------------------------------------------
     --Reimplemented Healthstones and Mana Crystals on separate timers.
     --Added "Smart Rejuvenation" setting which will drink a healing potion
       instead of a rejuv, when appropriate.
     --Added code for Bandages and a Bandage Cooldown.  Now I just need a list
       of appropriate bandages.

1.2---------------------------------------------------
     --Removed Healthstones and Mana Crystals.  I will reimplement those at a
       later date with their own separate timers.
     --Combat-Only should now work for both ranged and melee combat
     --Combat-Only mode is now the default mode
     --Cooldown timers for potions have been merged into a single timer
     --Added an action cooldown of 1 second.  Anytime AutoPotion drinks a
       potion, uses a healthstone, applies bandages, etc, it will wait 1 second 
       before trying to perform another action.  This is to allow time for the
       various items to do their work before trying again.  This should
       hopefully cut down on the "I can't use that yet" messages. Later, when I 
       implement Healthstones, Mana Crystals, and Bandages, this should keep you
       from, for example, using a bandage and then immediately drinking a
       potion.
     --Added Rejuv drinking.

1.1---------------------------------------------------
     --Added Rejuv list (for later... not handled yet)
     --Added cooldown timer
     --Added Combat-Only and Always modes

1.01---------------------------------------------------
     --Added healthstones and gems to the potion lists

1.0----------------------------------------------------
     --Initial release
-------------------------------------------------------

Very small portions of this were actually written by me, Jooky.
The rest was borrowed, cribbed, plagiarized, stolen
from (and now written by) the following artistes:

Credits:
     -- Ygrane: For optimizing my code and adding an option to reverse item order.
     -- Telo: for the UIErrorsFrame "My kickass addon is loaded" message and
        your super-keen Clock, LootLink, and Sidebar addons.
     -- Saien: for the potion lists and your swank AutoBar addon.
     -- Rauen: for the slash-command UI, time-saving ChatMessage function, and
        your awesome PetAttack and PetDefend addons.
     -- Int: for the UseByName functions.
     -- Leisha: for the updated potion lists with Healthstones and Gems included
        and the idea for Rejuvs and a timer (to be added later).
     -- Alex Brazie: for the cooldown timer
     -- Dhargo/Mairelon: for a combat-only mode based on aggro and for the
        TableCopy function, which I stole without remorse or compunction