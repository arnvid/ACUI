-- Function for each events possible targets
--[[
	PROCEDURE FOR ADDING EVENTS:
	1.  Code to detect and raise event.  If polling a number of items, do by iterating a list of available items.
	2.  Choose what event group (FBEventToggles) it belongs to.  If it needs a new group insert the following info:
		under FBEventToggles[<groupname>] 
		["toggle"] 	= default state
		["desc"]		= Description displayed in Performance frame.  Note the first 4 letters are used to
					   sort, but are not displayed
		["timer"]		= If a timer is used to poll, this is its name, otherwise nil
		["highlist"]	= If a list of items are polled, this is the COMPLETE list of possible items to poll
		["lowlist"]		= {} empty table, this is where the list of only those items we are interested in is kept.
	3.  For each event in the event group insert an entry in FBEventGroups of the form:
		FBEventGroups[<event>] = <groupname>  (from above)
	4.  For each event, insert a function in FBGUIEventTargets that returns a list of potential targets for the
	    event.
		FBGUIEventTargets["event"] = function() end

	NOTE: all table keys are lower case.
--]]
	local util = Utility_Class:New()

	FBEventToggleInfo = {
		["buttoncheck"] = {
			["toggle"] 	= "high",
			["desc"]	= "G01 Mouse enter/leave button",
			["timer"]	= nil,
			["highlist"]	= FBCompleteButtonList,
			["lowlist"]	= {}
			},
		["boundcheck"] 	=	{
			["toggle"] 	= "high",
			["desc"]	= "G01 Mouse enter/leave group",
			["timer"]	= "boundcheck",
			["highlist"]	= nil,
			["lowlist"]	= {}
			},
		["meleecheck"]	=	{
			["toggle"] 	= "high",
			["desc"]	= "G02 Enter/Leave Melee",
			["timer"]	= nil,
			["highlist"]	= {},
			["lowlist"]	= {}
			},
		["aggrocheck"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G02 Gain/Lose Aggro",
			["timer"]	= nil,
			["highlist"]	= {},
			["lowlist"]	= {}
			},
		["affectcombat"]	= {
			["toggle"] 	= "high",
			["desc"]	= "G02 Start/End Combat",
			["timer"]	= "affectcombat",
			["highlist"]	= {["player"] = true, ["party1"] = true, ["party2"] = true, ["party3"] = true, ["party4"] = true, ["pet"] = true, ["target"] = true},
			["lowlist"]	= {}
			},
		["manacheck"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G03 Action Mana",
			["timer"]	= "manacheck",
			["highlist"]	= FBCompleteButtonList,
			["lowlist"]	= {}
			},
		["cooldowncheck"] 	= {
			["toggle"] 	= "high",
			["desc"]	= "G03 Action Cooldown",
			["timer"]	= "cooldowncheck",
			["highlist"]	= FBCompleteButtonList,
			["lowlist"]	= {}
			},
		["rangecheck"] 		= {
			["toggle"] 	= "high",
			["desc"]	= "G03 Action In Range",
			["timer"]	= "rangecheck",
			["highlist"]	= FBCompleteButtonList,
			["lowlist"]	= {}
			},
		["usablecheck"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G03 Action Usable",
			["timer"]	= "usablecheck",
			["highlist"]	= FBCompleteButtonList,
			["lowlist"]	= {}
			},
		["targetcheck"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G04 Gain/Lose/Change Target",
			["timer"]	= "targetcheck",
			["highlist"]	= {["hostile"] = true, ["neutral"] = true, ["friendly"] = true},
			["lowlist"]	= {}
			},
		["formcheck"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G05 Gain/Lose Aura",
			["timer"]	= "formcheck",
			["highlist"]	= {},
			["lowlist"]	= {}
			},
		["itembuffs"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G05 Gain/Lose ItemBuff",
			["timer"]	= "itembuffs",
			["highlist"]	= {},
			["lowlist"]	= {}
			},
		["buffcheck"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G05 Gain/Lose Buff",
			["timer"]	= nil,
			["highlist"]	= {},
			["lowlist"]	= {}
			},
		["groupcheck"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G06 Gain/Lose Partymate",
			["timer"]	= "groupcheck",
			["highlist"]	= {["player"] = true, ["party1"] = true, ["party2"] = true, ["party3"] = true, ["party4"] = true},
			["lowlist"]	= {}
			},
		["petcheck"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G06 Gain/Lose Pet",
			["timer"]	= "petcheck",
			["highlist"]	= {},
			["lowlist"]	= {}
			},
		["deathcheck"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G06 Unit Died/Ressed",
			["timer"]	= "deathcheck",
			["highlist"]	= {["player"] = true, ["party1"] = true, ["party2"] = true, ["party3"] = true, ["party4"] = true, ["pet"] = true },
			["lowlist"]	= {}
			},
		["keycheck"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G07 Modifier Key Up/Down",
			["timer"]	= "keycheck",
			["highlist"]	= {["ShiftKey"] = true, ["ControlKey"] = true, ["AltKey"] = true},
			["lowlist"]	= {}
			},
		["bindingkeyevents"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G07 Binding Key Up/Down",
			["timer"]	= nil,
			["highlist"]	= CompleteBindingList,
			["lowlist"]	= {}
			},
		["buttonevents"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G07 Button Up/Down/Click",
			["timer"]	= nil,
			["highlist"]	= FBCompleteButtonList,
			["lowlist"]	= {}
			},
		["missevents"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G99 Player/Target Miss (obsolete)",
			["timer"]	= nil,
			["highlist"]	= {},
			["lowlist"]	= {}
			},
		["combatevents"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G10 Unit Combat",
			["timer"]	= nil,
			["highlist"]	= {["player"] = true, ["party1"] = true, ["party2"] = true, ["party3"] = true, ["party4"] = true, ["pet"] = true, ["target"] = true},
			["lowlist"]	= {}
			},
		["healthevents"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G08 Health Above/Below ##",
			["timer"]	= nil,
			["highlist"]	= {["player"] = true, ["party1"] = true, ["party2"] = true, ["party3"] = true, ["party4"] = true, ["pet"] = true, ["target"] = true},
			["lowlist"]	= {}
			},
		["manaevents"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G08 Mana Above/Below ##",
			["timer"]	= nil,
			["highlist"]	= {["player"] = true, ["party1"] = true, ["party2"] = true, ["party3"] = true, ["party4"] = true, ["pet"] = true, ["target"] = true},
			["lowlist"]	= {}
			},
		["comboevents"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G08 Combo Points",
			["timer"]	= nil,
			["highlist"]	= {},
			["lowlist"]	= {}
			},
		["actionbarpage"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G98 Action Bar Page",
			["timer"]	= nil,
			["highlist"]	= {},
			["lowlist"]	= {}
			},
		["autoitems"]		= {
			["toggle"] 	= "high",
			["desc"]	= "G97 Auto Item events",
			["timer"]	= nil,
			["highlist"]	= {},
			["lowlist"]	= {}
			},
		["none"]		= {
			["toggle"] 	= "high",
			["desc"]	= "XXX",
			["timer"]	= nil,
			["highlist"]	= {},
			["lowlist"]	= {}
			},
			
	}
	
	FBEventGroups = {
		["mouseentergroup"]	=	"boundcheck",
		["mouseleavegroup"]	=	"boundcheck",
		["mouseenterbutton"]	=	"buttoncheck",
		["mouseleavebutton"]	=	"buttoncheck",
		["entercombat"]		=	"meleecheck",
		["leavecombat"]		=	"meleecheck",
		["gainaggro"]		=	"aggrocheck",
		["loseaggro"]		=	"aggrocheck",
		["startcombat"]		=	"affectcombat",
		["endcombat"]		=	"affectcombat",
		["cooldownmet"]		=	"cooldowncheck",
		["cooldownstart"]	=	"cooldowncheck",
		["enoughmana"]		=	"manacheck",
		["notenoughmana"]	=	"manacheck",
		["nowinrange"]		=	"rangecheck",
		["outofrange"]		=	"rangecheck",
		["notusable"]		=	"usablecheck",
		["isusable"]		=	"usablecheck",
		["gainbuff"]		=	"buffcheck",
		["losebuff"]		=	"buffcheck",
		["gaindebuff"]		=	"buffcheck",
		["losedebuff"]		=	"buffcheck",
		["gaindebufftype"]	=	"buffcheck",
		["losedebufftype"]	=	"buffcheck",
		["gainaura"]		=	"formcheck",
		["loseaura"]		=	"formcheck",
		["healthabove10"]	=	"healthevents",
		["healthabove20"]	=	"healthevents",
		["healthabove30"]	=	"healthevents",
		["healthabove40"]	=	"healthevents",
		["healthabove50"]	=	"healthevents",
		["healthabove60"]	=	"healthevents",
		["healthabove70"]	=	"healthevents",
		["healthabove80"]	=	"healthevents",
		["healthabove90"]	=	"healthevents",
		["healthbelow10"]	=	"healthevents",
		["healthbelow20"]	=	"healthevents",
		["healthbelow30"]	=	"healthevents",
		["healthbelow40"]	=	"healthevents",
		["healthbelow50"]	=	"healthevents",
		["healthbelow60"]	=	"healthevents",
		["healthbelow70"]	=	"healthevents",
		["healthbelow80"]	=	"healthevents",
		["healthbelow90"]	=	"healthevents",
		["healthbelow100"]	=	"healthevents",
		["healthfull"]		=	"healthevents",
		["combopoints"]		=	"comboevents",
		["manaabove10"]		=	"manaevents",
		["manaabove20"]		=	"manaevents",
		["manaabove30"]		=	"manaevents",
		["manaabove40"]		=	"manaevents",
		["manaabove50"]		=	"manaevents",
		["manaabove60"]		=	"manaevents",
		["manaabove70"]		=	"manaevents",
		["manaabove80"]		=	"manaevents",
		["manaabove90"]		=	"manaevents",
		["manabelow10"]		=	"manaevents",
		["manabelow20"]		=	"manaevents",
		["manabelow30"]		=	"manaevents",
		["manabelow40"]		=	"manaevents",
		["manabelow50"]		=	"manaevents",
		["manabelow60"]		=	"manaevents",
		["manabelow70"]		=	"manaevents",
		["manabelow80"]		=	"manaevents",
		["manabelow90"]		=	"manaevents",
		["manabelow100"]	=	"manaevents",
		["manafull"] 		=	"manaevents",
		["losttarget"]		=	"targetcheck",
		["gaintarget"]		=	"targetcheck",
		["targetreactionchanged"]	=	"targetcheck",
		["gainpartymate"]	=	"groupcheck",
		["losepartymate"]	=	"groupcheck",
		["gainpet"]			=	"petcheck",
		["losepet"]			=	"petcheck",
		["unitdied"]		=	"deathcheck",
		["unitressed"]		=	"deathcheck",
		["actionbarpage"]	=	"actionbarpage",
		["rightbuttonclick"]=	"buttonevents",
		["leftbuttonclick"]	=	"buttonevents",
		["rightbuttonup"]	=	"buttonevents",
		["leftbuttonup"]	=	"buttonevents",
		["rightbuttondown"]	=	"buttonevents",
		["leftbuttondown"]	=	"buttonevents",
		["bindingkeyup"]	=	"bindingkeyevents",
		["bindingkeydown"]	=	"bindingkeyevents",
		["shiftkeyup"]		=	"keycheck",
		["shiftkeydown"]	=	"keycheck",
		["controlkeyup"]	=	"keycheck",
		["controlkeydown"]	=	"keycheck",
		["altkeyup"]		=	"keycheck",
		["altkeydown"]		=	"keycheck",
		["profileloaded"]	=	"none",
		["targetmiss"]		=	"missevents",
		["playermiss"]		=	"missevents",
		["autoitemout"]		=	"autoitems",
		["autoitemrestored"]=	"autoitems",
		["unitbuff"] 		=	"buffcheck",
		["unitdebuff"]		=	"buffcheck",
		["unitdebufftype"]	=	"buffcheck",
		["playercombat"]	=	"combatevents",
		["targetcombat"]	=	"combatevents",
		["gainitembuff"]	= 	"itembuffs",
		["loseitembuff"]	=	"itembuffs",
		["mainhandcharges"] =	"itembuffs",
		["offhandcharges"]	=	"itembuffs",
	}		
	
	FBGUIEventTargets = {}
	FBGUIEventTargets["mouseentergroup"]	=	
		function()
			local i,v
			local returnvalue = {}
			for i,v in pairs(FBGroupData) do
				table.insert(returnvalue,i)
			end
			return returnvalue
		end
	FBGUIEventTargets["mouseleavegroup"]	=	
		function()
			local i,v
			local returnvalue = {}
			for i,v in pairs(FBGroupData) do
				table.insert(returnvalue,i)
			end
			return returnvalue
		end
	FBGUIEventTargets["mouseenterbutton"]	=	
		function()
			return FBCompleteButtonList
		end
	FBGUIEventTargets["mouseleavebutton"]	=
		function()
			return FBCompleteButtonList
		end
	FBGUIEventTargets["entercombat"]		=	
		function()
			return FBNoTargetsList
		end
	FBGUIEventTargets["leavecombat"]		=	
		function()
			return FBNoTargetsList
		end
	FBGUIEventTargets["gainaggro"]			=	
		function()
			return FBNoTargetsList
		end
	FBGUIEventTargets["loseaggro"]			=	
		function()
			return FBNoTargetsList
		end
	FBGUIEventTargets["startcombat"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["endcombat"]			=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["cooldownmet"]		=	
		function()
			return FBCompleteIDList
		end
	FBGUIEventTargets["cooldownstart"]		=	
		function()
			return FBCompleteIDList
		end
	FBGUIEventTargets["enoughmana"]			=	
		function()
			return FBCompleteIDList
		end
	FBGUIEventTargets["notenoughmana"]		=	
		function()
			return FBCompleteIDList
		end
	FBGUIEventTargets["nowinrange"]			=	
		function()
			return FBCompleteIDList
		end
	FBGUIEventTargets["outofrange"]			=	
		function()
			return FBCompleteIDList
		end
	FBGUIEventTargets["notusable"]			=	
		function()
			return FBCompleteIDList
		end
	FBGUIEventTargets["isusable"]			=	
		function()
			return FBCompleteIDList
		end
	FBGUIEventTargets["gainbuff"]			=	
		function()
			local i,v
			local returnvalue = {}
			for i,v in pairs(FBBuffs["buffs"]) do
				table.insert(returnvalue,i)
			end
			return returnvalue
		end
	FBGUIEventTargets["losebuff"]			=	
		function()
			local i,v
			local returnvalue = {}
			for i,v in pairs(FBBuffs["buffs"]) do
				table.insert(returnvalue,i)
			end
			return returnvalue
		end
	FBGUIEventTargets["gaindebuff"]			=	
		function()
			local i,v
			local returnvalue = {}
			for i,v in pairs(FBBuffs["debuffs"]) do
				table.insert(returnvalue,i)
			end
			return returnvalue
		end
	FBGUIEventTargets["losedebuff"]			=	
		function()
			local i,v
			local returnvalue = {}
			for i,v in pairs(FBBuffs["debuffs"]) do
				table.insert(returnvalue,i)
			end
			return returnvalue
		end
	FBGUIEventTargets["gaindebufftype"]			=	
		function()
			local i,v
			local returnvalue = {}
			for i,v in pairs(FBBuffs["debufftypes"]) do
				table.insert(returnvalue,i)
			end
			return returnvalue
		end
	FBGUIEventTargets["losedebufftype"]			=	
		function()
			local i,v
			local returnvalue = {}
			for i,v in pairs(FBBuffs["debufftypes"]) do
				table.insert(returnvalue,i)
			end
			return returnvalue
		end
	FBGUIEventTargets["gainaura"]			=	
		function()
			local i,v
			local returnvalue = {}
			for i,v in pairs(FBBuffs["auras"]) do
				table.insert(returnvalue,i)
			end
			return returnvalue
		end
	FBGUIEventTargets["loseaura"]			=	
		function()
			local i,v
			local returnvalue = {}
			for i,v in pairs(FBBuffs["auras"]) do
				table.insert(returnvalue,i)
			end
			return returnvalue
		end
	FBGUIEventTargets["healthabove10"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthabove20"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthabove30"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthabove40"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthabove50"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthabove60"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthabove70"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthabove80"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthabove90"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthbelow10"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthbelow20"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthbelow30"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthbelow40"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthbelow50"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthbelow60"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthbelow70"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthbelow80"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthbelow90"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthbelow100"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["healthfull"]			=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["combopoints"]		=	
		function()
			return FBComboPointsList
		end
	FBGUIEventTargets["manaabove10"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manaabove20"]		=
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manaabove30"]		=
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manaabove40"]		=
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manaabove50"]		=
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manaabove60"]		=
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manaabove70"]		=
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manaabove80"]		=
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manaabove90"]		=
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manabelow10"]		=
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manabelow20"]		=
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manabelow30"]		=
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manabelow40"]		=
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manabelow50"]		=
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manabelow60"]		=
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manabelow70"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manabelow80"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manabelow90"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manabelow100"]		=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["manafull"] 			=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["losttarget"]			=	
		function()
			return FBNoTargetsList
		end
	FBGUIEventTargets["gaintarget"]			=	
		function()
			return FBCompleteReactionList
		end
	FBGUIEventTargets["targetreactionchanged"]	=	
		function()
			return FBCompleteReactionList
		end
	FBGUIEventTargets["gainpartymate"]			=	
		function()
			return FBCompletePartyList
		end
	FBGUIEventTargets["losepartymate"]		=	
		function()
			return FBCompletePartyList
		end
	FBGUIEventTargets["gainpet"]			=	
		function()
			return FBNoTargetsList
		end
	FBGUIEventTargets["losepet"]			=	
		function()
			return FBNoTargetsList
		end
	FBGUIEventTargets["unitdied"]			=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["unitressed"]			=	
		function()
			return FBGUIUnitList
		end
	FBGUIEventTargets["actionbarpage"]		=	
		function()
			return FBCompletePageList
		end
	FBGUIEventTargets["rightbuttonclick"]	=	
		function()
			return FBCompleteButtonList
		end
	FBGUIEventTargets["leftbuttonclick"]	=	
		function()
			return FBCompleteButtonList
		end
	FBGUIEventTargets["rightbuttonup"]		=	
		function()
			return FBCompleteButtonList
		end
	FBGUIEventTargets["leftbuttonup"]		=	
		function()
			return FBCompleteButtonList
		end
	FBGUIEventTargets["rightbuttondown"]	=	
		function()
			return FBCompleteButtonList
		end
	FBGUIEventTargets["leftbuttondown"]		=	
		function()
			return FBCompleteButtonList
		end
	FBGUIEventTargets["bindingkeyup"]		=	
		function()
			return FBCompleteBindingList
		end
	FBGUIEventTargets["bindingkeydown"]		=	
		function()
			return FBCompleteBindingList
		end
	FBGUIEventTargets["shiftkeyup"]			=	
		function()
			return FBNoTargetsList
		end
	FBGUIEventTargets["shiftkeydown"]		=	
		function()
			return FBNoTargetsList
		end
	FBGUIEventTargets["controlkeyup"]		=	
		function()
			return FBNoTargetsList
		end
	FBGUIEventTargets["controlkeydown"]		=	
		function()
			return FBNoTargetsList
		end
	FBGUIEventTargets["altkeyup"]			=	
		function()
			return FBNoTargetsList
		end
	FBGUIEventTargets["altkeydown"]			=	
		function()
			return FBNoTargetsList
		end
	FBGUIEventTargets["profileloaded"]		=	
		function()
			return FBNoTargetsList
		end
	FBGUIEventTargets["targetmiss"]			=	
		function()
			return FBCompleteMissList
		end
	FBGUIEventTargets["playermiss"]			=	
		function()
			return FBCompleteMissList
		end
	FBGUIEventTargets["autoitemout"]			=	
		function()
			local i,v
			local returnvalue = {}
			for i,v in pairs(FBSavedProfile[FBProfileName].FlexActions) do
				table.insert(returnvalue,v["name"])
			end
			return returnvalue
		end
	FBGUIEventTargets["autoitemrestored"]			=	
		function()
			local i,v
			local returnvalue = {}
			for i,v in pairs(FBSavedProfile[FBProfileName].FlexActions) do
				table.insert(returnvalue,v["name"])
			end
			return returnvalue
		end
	FBGUIEventTargets["playercombat"]			=	
		function()
			local returnvalue = {}
			local i,v
			for i,v in pairs(FBCombatTypes) do
				table.insert(returnvalue,i)
			end
			return returnvalue
		end
	FBGUIEventTargets["targetcombat"]			=	
		function()
			local returnvalue = {}
			local i,v
			for i,v in pairs(FBCombatTypes) do
				table.insert(returnvalue,i)
			end
			return returnvalue
		end
	FBGUIEventTargets["unitbuff"]			=	
		function()
			return FBGUIUnitBuffList
		end
	FBGUIEventTargets["unitdebuff"]			=	
		function()
			return FBGUIUnitBuffList
		end
	FBGUIEventTargets["unitdebufftype"]			=	
		function()
			return FBGUIUnitBuffList
		end
	FBGUIEventTargets["gainitembuff"]			=	
		function()
			local i,v
			local returnvalue = {}
			for i,v in pairs(FBBuffs["itembuffs"]) do
				table.insert(returnvalue,i)
			end
			return returnvalue
		end
	FBGUIEventTargets["loseitembuff"]			=	
		function()
			local i,v
			local returnvalue = {}
			for i,v in pairs(FBBuffs["itembuffs"]) do
				table.insert(returnvalue,i)
			end
			return returnvalue
		end
	FBGUIEventTargets["mainhandcharges"]			=	
		function()
			return FBNoValuesList
		end
	FBGUIEventTargets["offhandcharges"]			=	
		function()
			return FBNoValuesList
		end
