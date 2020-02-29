--------------------------------------------------------------------------------------------------
	local util = Utility_Class:New()
-- Config variables - Saved
	FBSavedProfile = {}
	FBToggles = {}
	FBScripts = {};
	FBTextChunks = {};
	FBFirstUse = 0;
	FBBuffs = {}
		FBBuffs["buffs"] = {}
		FBBuffs["debuffs"] = {}
		FBBuffs["itembuffs"] = {}
		FBBuffs["auras"] = {}
		FBBuffs["debufftypes"] = {}
	FBCombatTypes = {}
-------------------------------------------------------------------------------------------------
-- Local variables
-- This is the last known cursor location (so we can see if it entered/left a group bounding box
	FBCursorLoc = {};
	FBCursorLoc.x=0;
	FBCursorLoc.y=0;
-- id - Button map - must be global to be accessed in XML file
--	FBIDToButton = {}
-- Group data - global.  Used to speed up bounds checking
	FBGroupData = {}
-- Constant for number of buttons - must be global
	FBNumButtons = 120;
-- Current button state
	FBState = {}
	local tempindex
	for tempindex = 1,FBNumButtons do
		FBState[tempindex] = {}
	end
-- Command object and /command setup - must be global
	FBcmd = Command_Class:New("FlexBar", "/flexbar")
	FBCastcmd = Command_Class:New("FBCast", "/fbcast")
	FBDoIncmd = Command_Class:New("FBDoIn", "/fbdoin")
	FBUsecmd = Command_Class:New("FBUse", "/fbuse")
	FBEchocmd = Command_Class:New("FBEcho", "/echo")
	FBPrintcmd = Command_Class:New("FBPrint", "/print")
-- Timers
	FBTimers = {}
-- Getting the mouse button pressed in OnClick is flaky - store the last mousebutton down here
	FBLastButtonDown = "";
-- Last hp percents for various units
	FBLastHealth = {}
	FBLastMana = {}
	FBLastRage = {}
	FBLastEnergy = {}
	FBLastBuffs = {}
		FBLastBuffs["buffs"] = {}
		FBLastBuffs["debuffs"] = {}
		FBLastBuffs["itembuffs"] = {}
		FBLastBuffs["debufftypes"] = {}
-- Current events list copied from FBSavedProfile
	FBEvents = {}
	FBEvents.n = 0
-- Current Profile Name and character name
	FBProfileName = ""
	FBCharName = ""
-- State for conditionals
	FBConditionalState = {}
-- Saved Profile for restore
	FBProfileBackup = nil
-- Temporary Config file for scripts editor
	FBTestConfig = nil
--------------------------------------------------------------------------------------------------
-- Var to hold last target reaction, can be local as it's only called in this module
	FBLastTarget = nil
-- var to hold last form for shape/stance/aura/stealth etc changes
	FBLastform = "none"
-- var to hold last pet name for pet existence check.
	FBPetname = nil
-- var to hold group member existence info for  existence check
	FBGroupmates = {}
-- var to hold last key state
	FBKeyStates = {}
-- Hold unit status (dead/alive)
	FBUnitStatus = {}
-- Unit combat status using UnitAffectingCombat()
	FBUnitCombat = {}
-- Var to hold last combo points value
	FBLastComboPts = 0
-- Table for quick event dispatch
	FBEventQuickDispatch = {}
-- Table to hold args for quick event dispatch
	FBEventArgs = nil
-- Current top of scripts in menu
	FBScriptCount = 1
-- Table to hold custom conditions from scripts
	FBCustom = {}
-- Callbacks for Events
	FBEventHandlers = {}
-- Callbacks for extended events
	FBExtHandlers = {}
-- Global conditional functions
-- made global so that users can extend it by runscript on='ProfileLoaded'
	FBConditions = {}
-- Table to hold delayed macro
	FBMacroWait = {}
-- Macro variables callbacks
	FBMacroVariables = {}
-- Last event and source
	FBLastEvent = ""
	FBLastSource = ""
-- Spell Info for FBCastByName
	FBPlayerSpells = {}
	FBPetSPells = {}
	FBPlayerMaxRank = {}
	FBPetMaxRank = {}
-- Slot for picked up texture
	FBPickUpTexture = nil
-- ID to ButtonNum map
	FBIDtoButtonNum = {}
-- Tables to store ready list of inventory
	FBBagContents = {}
	FBInvContents = {}
-- Toggles for event groups
	FBCompleteButtonList = {}
	FBCompleteBindingList = {}
	FBCompleteScaleList = {}
	FBCompleteAlphaList = {}
	FBCompleteIDList = {}
	local index
	for index = 1,FBNumButtons do
		FBCompleteButtonList[index] = index
		if index <= 30 then
			FBCompleteBindingList[index] = index
		end
		if index >4 and index<51 then
			table.insert(FBCompleteScaleList, index)
		end
		if index < 11 then
			table.insert(FBCompleteAlphaList, index)
		end
	end
	for index = 1,120 do
		FBCompleteIDList[index] = index
	end
	FBCompleteTextureList = {"'%backpack'","'%macro##'","'%button##'"}
	FBCompleteTextVarList = {"'%d'","'%b'","'%c'"}
	FBNoTargetsList = {"No Target Needed"}
	FBNoValuesList = {"No Values Available"}	
	FBCompleteReactionList = {"'hostile'","'neutral'","'friendly'"}
	FBComletePartyList = {"'party1'","'party2'","'party3'","'party4'"}
	FBCompletePageList = {1,2,3,4,5,6}
	FBComboPointsList = {0,1,2,3,4,5}
	FBCompleteMissList = {"'dodge'","'miss'","'parry'"}
	FBIfOpsList = {"and","or","not","(",")"}
	FBTrueList = {"'true'"}
	FBColorList = {	"[10 10 10] - Clear",
					"[5 5 5]    - Dim",
					"[10 1 1]   - Dark Red",
					"[1 10 1]   - Dark Green",
					"[1 1 10]   - Dark Blue",
					"[10 10 1]  - Dark Yellow",
					"[10 1 10]  - Dark Magenta",
					"[1 10 10]  - Dark Cyan",
					"[10 5 5]   - Light Red",
					"[5 10 5]   - Light Green",
					"[5 5 10]   - Light Blue",
					"[10 10 5]  - Light Yellow",
					"[10 5 10]  - Light Magenta",
					"[5 10 10]  - Light Cyan"
				}

-- List of units to check events for
	FBGUIUnitList = { "'player'","'party1'","'party2'","'party3'","'party4'","'pet'","'target'" }
	FBGUIUnitBuffList = { "'party1'","'party2'","'party3'","'party4'","'pet'","'target'" }
	FBGUIUnitCombatList = { "'playercombat'","'party1combat'","'party2combat'","'party3combat'","'party4combat'","'petcombat'","'targetcombat'" }
	FBUnitList = { "player","party1","party2","party3","party4","pet","target" }
	FBUnitCombatList = { "playercombat","targetcombat" }
	FBCompletePartyList = { "'party1'", "'party2'", "'party3'", "'party4'" }

-- list of all GUI Panels
	FBGUIPanelsList= {"Script Editor","Event Editor","Global Options","Auto Items","Performance Options"}
-- Item enchantments
	FBItemEnchants = {}
-- Anchor positions
	FBAnchors = {	["TOPLEFT"] = true,["TOPRIGHT"] = true, ["TOP"] = true,
					["BOTTOMLEFT"] = true, ["BOTTOMRIGHT"] = true, ["BOTTOM"] = true,
					["CENTER"] = true, ["LEFT"] = true, ["RIGHT"] = true }
-- List of event toggles in a more accessible form
	FBEventToggles = {}
-- table of functions for text sub
	FBTextSubstitutions = {}
	
	
