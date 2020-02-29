# Advanced Caster UI v0.2

This is a copy that I managed to find online - the original UI packs
were not kept on any of my systems past 2010. Will try tofind the other
versions like the 0.4, 0.5 and the finaly 0.6 version range.


Introduction:
-------------
This UI compilation is an continuance of RHM's UI pack. I have taken the
liberty to update, replace and add AddOn's from the original pack. This
never version have been tested for 1.4.2 (EU) and for 0.5.0 (EU Test).
The EU Test servers requires some of the AddOn's to be disabled. For
instance the UberQuest is not yet compatible....

Remeber. This UI Compilation is not the easiest one to install but it works
very well if your a spellcaster.



DISCLAIMER:
-----------
No animals where hurt during the testing of this UI Collection. Only my WoW
playing fiance and my IRL friends had to deal with the constant frustrations
that the WoW UI can cause. The author of this collection, or any author of any
AddOn used in this collection can not (!) be held responsible for any hardware
or software problems you may experience while using this package. Any claims
will be forwarded to /dev/null and ignored.


Installing:
-----------
Please take a backup of your Interface and WTF directories before installing.
Then remove your Interface directory and replace it with the one in this file.
The folder format in the zip file should reveal the destination of all the files
in it. Put the files from the WTF directory in the one of your own login name.

** I have included a 3 character based SavedVariables.lua, but you MUST edit
it to reflect your own chars and servers*

1) Select one of the 3 char profiles from the once below and replace 
for instance "Mage" with your char name and Server with the server your
character is on. It should be done in the order these are represented below.

Mage - Server
Druid - Server
Shaman - Server

Mage|Server
Druid|Server
Shaman|Server

Mage:Server
Druid:Server
Shaman:Server

Mage of Server
Druid of Server
Shaman of Server

Mage
Druid
Shaman

2) Save the SavedVariables.lua
3) Rename the Mage/Druid/Shaman dir to your character name. 
4) Test it.

Currently used AddOn's:
-----------------------
 myAddOns
 myReloadUI
 EZoneLevel
 bc_AutoMailSubject
 Reputation
 MapCoords
 LootLink
 Enchantrix
 TooltipPlacer
 EnchantedDurability
 AF_Tooltip
 Auctioneer
 Sea
 ErrorRedirect
 ImprovedErrorFrame
 Goodinspect
 UberQuest
 AutoBar
 AutoPotion
 AvgXP
 BibCore
 BibToolbars
 Chronos
 Clock
 Gypsy_BuffBar
 Gypsy_General
 Gypsy_Shell
 Gypsy_UnitBars
 QuickCash
 QuickLoot
 SiMiHiOi
 UberActions
 BibWindowMods
 EquipCompare
 MyInventory
 MozzFullWorldMap
 FlexBar
 Gatherer
 
 
Know bugs:
----------

* When going to and from Windowed mode the main bar sometimes disappear.
  - An known workaround is to reload the ui after Windowed mode have been
    selected. Do this with /console reloadui
    

Contact me?
-----------

Sure, if there is something you want to ask or give feedback on please do
so. My email address is arnvid <AT> gmail.com.  Alternatively use the
forums or online in wow. I play on the european servers Turalyon (Cerebro/Asys)
and Stormscale (Afterdark).
 

Credits:
--------

The UI compilation in it's current state is maintained by Arnvid Karstad and
some addon's have been modified to better suite this compilation.

I acknowledge that this UI Compilation would most likely not exist without
the original UI pack from RHM. It can be found on the following URL's:

http://www.curse-gaming.com/mod.php?addid=411
http://ui.worldofwar.net/ui.php?id=359


To Be Done:
-----------

* Finish the configuration program that will allow users to create new
  chars directly in the SaveVariables.lua file without editing it.
* Mod more AddOn's to use a similar username variable. My on earth
  must the use " of ", ":", "|" and " - ". 5 Diffrent styles are used
  here and it's a total mess.
 
