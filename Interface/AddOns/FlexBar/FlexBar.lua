FlexBarVersion = 1.38
--[[

Flex Bar 
        Author:         Sean Kennedy (derived from Telo's work)
        Version:        1.38:  05/18/2005

        Last Modified 
		05/18/2005
			1.	Move ACTIONBAR_UPDATE_USABLE out of the code block with ACTIONBAR_UPDATE_COOLDOWN
				so the frame stuttering fix for spells being interrupted doesn't break the cooldown spinner.
			2.	Added a delayed call to FB_ReformGroups() as a temporary workaround to MouseLeaveGroup bug
		05/10/2005
			1.	Added another check to CreateQuickDispatch to not error on non-standard events
			2.	Reverted some xml to try and fix cooldownspinner/count/hud bug
			3.	Added UnitCreatureType<[<unitcode> "creaturetype" ]> conditional - Thanks Stove.
			5.	Shift+Click on EDT in the event editor will create a new copy of that event at the 
				bottom of the list to edit.
			6.	Right Clicking an entry in the scripts menu will auto-matically load it.
			7.	Fixed target lists in EE for UnitDebuff and UnitDebufftype.
			8.	Added ability to escape single quotes inside a string with the \
				IE:  Runmacro Macro='/echo Dhargo\'s Test' will output Dhargo's Test.
				use this for things like 'Hunter\'s Mark' and the like.
				Known Issues that are unresolved:
				MouseLeaveGroup occasionally not working.  I can't reproduce this one.  Please
				turn on Safe load in global options and see if this helps.
				Text Color flickering when out of range - reproduced once, but not long enough to
				track down.
		05/07/2005
			1.	Fixed bug with /flexbar commands not working in runmacro off events.
				If anything ever breaks in runmacro on events - see the beginning of 
				FB_Execute_MultilineMacro
			2.	Fixed issue with Editing events where multi word targets were being munged.
			3.	Increased text length for textboxes in event editor.
			4.	Fixed CheckAllBuffs - it was raising GainBuff before the stored buffs were
				updated with any lost buffs.  It now raises all gain/lose buff/debuff/debufftypes
				at the end.  This may fix other problems reported with these as well.
			5.	Fixed issue with flexactions and hidegrid.
			6.	Excluded "player" from target list for Unitbuff/debuff/debufftype.
			7.	Added Drop Down Items option to Global Options - specifies how long the dropdown
				menus in the Event Editor should be.
			8.	Modified drop down menus to scroll whole pages.
			9.	Modified UnitDebufftype to raise if the number of a specifice debuff type increased or decreased.
			10.	Fixed GainDebufftype/UnitDebufftype to not raise on in-curables.
			11.	Fixed the conditional parser for not and or.
			12.	Made HasBuff/Debuff/Debufftype and UnitBuff/Debuff/Debufftype conditionals case insensitive.
			13.	Added check to PLAYER_ENTERING_WORLD - don't load profile if it's already loaded.
			14.	
		05/05/2005
			1.	Fixed UnitDebufftype to be raised correctly (it was accidentally working for
				debuffs going on, but not for them going off).
			2.	The conditions UnitBuff/UnitDebuff/UnitDebufftype will now be accurate when
				called from any of UnitBuff/UnitDebuff/UnitDebufftype events.
			3.	Fixed isusable, enoughmana, inrange, cooldownmet conditions - they were expecting
				a button ID not button # and the old way was Button # (as it is in the docs).
		05/05/2005
			1.	Changed CheckAllBuffs to only raise one UnitBuff, UnitDebuff, UnitDebufftype event
				no matter how many buffs changed (to take care of occurences like changing targets
				where it could be raise many times)
			2.	Fixed code with advanced buttons not firing from hotkey clicks
			3.	Fixed in= on events.  Was broken by code to reuse existing tables rather than create new ones.
			4.	Fixed Gain/Lose Debufftype and UnitDebuffType checking. 
			5.	CHANGED UnitDebuffTypes Conditional to UnitDebuffType ( for consistency )
			6.	Fixed UnitDebuffType description/example in docs.
			7.	Changed loadprofile timer to PLAYER_ENTERING_WORLD event to try and avoid
				incorrect group bounds set.
			8.	Changed ResetAll to get rid of any old (pre 1.32) profiles saved under the character name
				only - as they were being reloaded.
				
		05/03/2005
			1.	REALLY got the shade problems this time - tested all modes.
			2.	Added a check into CreateQuickDispatch to test for an event that is not in EventGroups
			3.	Fixed docs typo "flexmacro" not "flexbmacro" :/
			4.	Apparently fixed problem with Event Editor macro/script= fields
		05/02/2005
			1. 	Fixed UnitBuff/Debuff/Debufftype, HasBuff/Debuff/Debufftype conditionals.
			2.	Forced a check of buffs at profile loaded to preload buff table
			3.	Fixed error caused by 'ProfileLoaded' with a target
			4.	Fixed syntax in Condtional descriptions for multiple items.
		05/01/2005
			1. 	Fixed another bug stemming from trying to clean up color code.
			2.	Added ReloadUI back in to Resetall and into Restore.
		05/05/2005
			1.	Fixed initialization code for buttns 97-120 on existing profiles
			2.	Fixed color bug in shadetext/2
			3.	Added %player, %party1-%party4, %pet and %target to texture options
		04/05/2005
			1. 	Changed XML a little so that frame-coordinates are no longer stored in 
				the frame-layout.txt cache in WTF\Account\<account name>\<charactar name>
			2.	Changed Scripts save function to break large text blocks into 512 character
				chunks.  Saved variables seem to max out at ~950-970 characters in a string.
			3.	Added FastLoad as an option.  With the frame-layout.txt file gone, the need for
				delayed loading seems to be obviated.
			4.	*may* have fixed the error that leads to misplaced buttons on successive group
				auto-arrange/move commands in configs.
			5.	Added FB_Register()  to add new event handlers that process after any existing 
				handlers.
			6.	Added event "ComboPoints" - target is current number of combo points
			7.	Added conditions ComboPtsEQ<#>, ComboPtsLT<#> anc ComboPtsGT<#> - respectively 
				check to see if current combo points are equal to, less than or greater than the target.
			8.	Added event "UnitAffectingCombat", target is which unit to watch for.  Affecting combat
				seems to be a mix of GainAggro/Start Melee combat.
			9.  	Added conditional "AffectingCombat<unitcode>" - condition to check if a specific unit is 
				currently affecting combat.
			10.	Added test code for PLAYER_LOST_CONTROL and PLAYER_GAINED_CONTROL.  I
				believe that these  will fire when you are CC'd in some way.  Currently the code saves 
				the messages in FBScripts under the names "PLAYER_LOST_CONTROL" and 
				"PLAYER_GAINED_CONTROL".  If someone could please look at these after being
				feared, charmed or stunned and let me know if what, if any, info was recorded there
				I can implement these events.
			11.	Moved FBScripts editor to FlexBar_GUI.xml and FlexBar_GUI.lua.
			12.	Mostly fixed FBScripts editor's scrolling weirdness.
			13.	Moved seperate toggles (FBFastLoad, FBSafeLoad, FBTooltips, FBVerbose) into a table.
			14.	Implemented a simple GUI for toggles.
			15.	Fixed broken Mana/Health conditionals
			16.	Implemented a simple GUI to toggle on and off groups of events
			17.	Implemented GUI for Event Editing
			18.	Cleaned up Timer_Class code to prevent the steady dumping of memory onto the garbage heap.
			19.	Implemented the behnd the scenes code for AutoItems
			20.	Implemented the behind the scenes code for extending buffs/debuffs to party/target/pet
			21.	More stuff than I could keep track of :)
		(switching to reverse cronological order)
		04/03/2005
			1.	Fixed bug resulting from buffs cast before profile was loaded/
				or buff wearing off before profile was loaded.  -- one result is that
				these buffs will not be correct for the condition hasbuff<>
			2.  	Restored the Use button to being able to specify multiple buttons
			3.  	Added FB_CastSpellByName() and /fbcast (as slash command) -
				this addresses the issue with /cast and CastSpellByName() not
				working inside runmacro/runscript.
			4.	Added 2 commands for use with runscript/runmacro:
				SetTexture Button=# Texture=''
				Echo Button=<button numbers> base=#  --
				see help file for details
			5: 	Added Import button to scripts editor - allows you to import configs
				from FlexBar_Config.lua and run/edit/save into the FBScripts table.

				12/26/2004	Complete rewrite to facilitate new features and
					maintainablity
		01/11/2005	Fixed 3 errors:
					1, hotkeys were not getting the right button - fixed
					2, the id map was being set incorrectly for druids and warriors
					3, after group auto-arrange group bounds were off.
					4, fixed ingame help for group auto-arrange
					
					Also added code to stop using implicit buttons and use an explicit button
					in  case this was getting munged somehow.  Still desperately seeking 
					cause of Mac crashes - hampered by lack of a mac :/
		01/12/2005	1. Increased LoadProfile timer.  Was 10 seconds during development,
					dropped to 5 just two days to release -- seems to cause some shifting
					of buttons on load.
					2. Fixed small bug with key-binding text
					3. Fixed bug with setting up event for Use On=
					4. Fixed bug when auto-arranging buttons
					5. Fixed bug where FBEvents.n wasn't initialized - found out due to Cosmos.
					This is not a cosmos bug, but cosmos did something to point out a bug I'd 
					been getting away with.
					6. Made events and targets case insensitive.
					7. Added FlexBar_Config.lua file and LoadConfig command
					8. LoseAura was incorrectly being raised as LostAura.  For consistency, fixed that
					9. 7:00 pm - target is actually case insensitive now
					10. bug with buttons staying fixed to anchor after ungroup fixed.
		01/13/2005	1.  FIXED MAC CRASH
					A huge thank you to Dagar for all his help in tracking this down.
		01/16/2005	1.  Fixed hotkey problem that especially effected warriors
					2.  Added far more bounds checking to parameters with descriptive error messages
					3.  Added IsUsable, NotUsable, ManaAbove##, ManaBelow##, HealthFull, ManaFull
					     Mana events work for rage.  Probably energy too.
		01/25/2005	1.  Load profile timer now is set in Player Entering World event to ensure that settings
					    aren't lost
					2.  Added the reset parameter to shade to allow WoW's default shading on low mana
					     to work again.
					3.  You can now specify '' or even no text at all in /flexbar text to get rid of the text there.
					4.  You can now turn off button tooltips with /flexbar tooltip state='off' and state='on to 
					     turn them back on.
					5.  Some of the group bounds issues after auto-arranging groups should be solved.
					6.  Added leftbuttondown, up and click events when using a hotkey to activate a button
					7.  Fixed positioning on move to mouse and moverel when UI scale is not 1
		01/30/2005	1.  Made 2 changes to try and fix the lost configuration bug:
						A.  Added a 2nd check in Loadprofile for variables being loaded.  If they are not, it restarts the timer
						B.  Added the SafeLoad command, which requires manual loading of profiles
		01/30/2005	1.  Added SaveProfile and LoadProfile to allow backing up and transporting full profiles across characters
					    on the same account.
		02/02/2005	1.  Fixed remap toggle ability.
					2.  Added checks to reduce FPS slowdonw when lots of buttons are visible.
						Default blizzard code reshades visible buttons every update, regardless of 
						whether they actually change state.  With lots of buttons on screen this may
						be computationally expensive.  Added a check to see if the button state had
						actually changed before shading.
					3.  Fixed the bug where I was incorrectly applying scale in the case of UIScale < 1.
						This fix will result in the buttons being smaller at the same scaling if you have
						Use UI Scale checked.
					4.  Added an optional reset='true' to scale
					5.  Fixed Horizontal/Vertical group to take UI scale into account.  If you change
					     UIScale, you will need to re-issue the auto-arrange commands to make them
					     look right.
		02/04/2005	1.  Changed the Profile Auto-load code to take into account new information regarding
					    checking for a valid character name and the UnregisterEvent() bug.  
						A.  The lost config bug should be gone.
						B.  The problems people experienced with the profile never loading
						     due to a conflict with other mods should be gone.
						C.   In  the event that VARIABLES_LOADED doesn't fire due to the above
						      Blizzard bug, a dialog box will show allowing the user to manually load
						      their profile.
		02/06/2005	1.  Completely reworked the data structure holding button state.  Somehow, in
					    in some cases it was getting munged.  This data structure is now independent
					    of the buttons (it used to be attached to the button itself) and is initialized
					    outside of any event code.
					2.  Reworked all the functions derived from Actionbar to take an explicit button
					    argument rather than rely on implicit 'this'.  In rare instances 'this' was becoming
					    nil.
					3.  Added ShiftKeyDown/Up AltKeyDown/Up and ControlKeyDown/Up events.
					4.  Added a notepad like editor window for script writing - scripts are stored
					     in FBScripts.
					5.  Added UnitDied/UnitRessed events
					6.  Added Runscript command
					7.  Finished Raise command
					8.  Implemented first iteration of conditionals.
		03/29/2005	1.  Added RunMacro command
					2.  Added Restore  command
					3.  Changed WoW event handling to allow extension by 3rd parties within flexbar
					
		03/31/2005 	1.  Small bugfix with quickdispatch and no target specified.
		04/01/2005	1.  Fixed bugs in UnitIsHostile/Friendly/Neutral conditions
					2.  Added /wait to macros.  Duration of wait is in tenths of a second. 
					     There is an added .1 second delay in addition to specified delay.
					3.  Added %fbe (last flexbar event) and %fbs (the source that raised
					     the last flexbar event).  Extra variables are extensible.
		04/01/2005	1.   Fixed bug with resetting shade
					2.  Fixed bug with multiple calls to shade on events causing corruption
					     of the color data.
]]

-- Utility object
	local util = Utility_Class:New()

-- OnFoo functions

function FlexBar_OnLoad()
	-- Set up slash commands
	FB_Command_AddCommands(FBcmd)
	-- Register for events
	FlexBar:RegisterEvent("VARIABLES_LOADED");
	FlexBar:RegisterEvent("PLAYER_ENTERING_WORLD");
	FlexBar:RegisterEvent("PLAYER_ENTER_COMBAT");
	FlexBar:RegisterEvent("PLAYER_LEAVE_COMBAT");
	FlexBar:RegisterEvent("PLAYER_REGEN_ENABLED");
	FlexBar:RegisterEvent("PLAYER_REGEN_DISABLED");
	FlexBar:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES");
	FlexBar:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES");
	FlexBar:RegisterEvent("UNIT_HEALTH")
	FlexBar:RegisterEvent("UNIT_MANA")
	FlexBar:RegisterEvent("UNIT_RAGE")
	FlexBar:RegisterEvent("UNIT_ENERGY")
	FlexBar:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
	FlexBar:RegisterEvent("SPELLS_CHANGED")
	FlexBar:RegisterEvent("PLAYER_COMBO_POINTS")
	FlexBar:RegisterEvent("PLAYER_GAINED_CONTROL")
	FlexBar:RegisterEvent("PLAYER_LOST_CONTROL")
	FlexBar:RegisterEvent("BAG_UPDATE")
	FlexBar:RegisterEvent("UNIT_INVENTORY_CHANGED")
	FlexBar:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
	FlexBar:RegisterEvent("UNIT_AURA")
	FlexBar:RegisterEvent("UNIT_COMBAT")
end

function FlexBar_OnEvent(event)
-- Dispatch to standard event handlers
	local dispatch = FBEventHandlers[event]
	if dispatch then
		dispatch(event)
	end
-- Dispatch to extended event handlers
	local handlers = FBExtHandlers[string.upper(event)]
	if handlers then
		local index, dispatch
		for index, dispatch in pairs(handlers) do
			dispatch(event)
		end
	end
end

function Flexbar_OnUpdate(elapsed)
-- Update any timers we have running.
	local name, timer
	for name, timer in pairs(FBTimers) do
		timer:Update(elapsed)
	end
end

function FlexBarButtonDown(buttonnum)
-- Modified Blizzard code (removed bonus action check)
-- appears to simply change the look of the button to reflect that 
-- it is pushed.

-- originally coded to use the button ID - but why when this is only called from bindings?
	local button = getglobal("FlexBarButton".. buttonnum);
	if ( button:GetButtonState() == "NORMAL" ) then
		button:SetButtonState("PUSHED");
	end
end

function FlexBarButtonUp(buttonnum)
-- Modified Blizzard code (removed bonus action check)
-- besides the appearance change, not sure what they are doing here.
-- same as above
	local button = getglobal("FlexBarButton".. buttonnum);
	if ( button:GetButtonState() == "PUSHED" ) then
		button:SetButtonState("NORMAL");
		FBLastButtonDown = "LeftButton"
		FlexBarButton_OnClick(button, true, "LeftButton")
		if ( IsCurrentAction(FlexBarButton_GetID(button)) ) then
			button:SetChecked(1);
		else
			button:SetChecked(0);
		end
	end
end

function FlexBarButton_OnLoad(button)
-- Blizzard code:  Called as each button is loaded.
	button.showgrid = 1;
	button.flashing = 0;
	button.flashtime = 0;
	FlexBarButton_Update(button);
-- Went nuts trying to figure out why I couldn't get clicks and drags
-- in my handle frames - I didn't do this 
	button:RegisterForDrag("LeftButton", "RightButton");
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	button:RegisterEvent("VARIABLES_LOADED");
	button:RegisterEvent("ACTIONBAR_SHOWGRID");
	button:RegisterEvent("ACTIONBAR_HIDEGRID");
	button:RegisterEvent("ACTIONBAR_PAGE_CHANGED");
	button:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
	button:RegisterEvent("ACTIONBAR_UPDATE_STATE");
	button:RegisterEvent("ACTIONBAR_UPDATE_USABLE");
	button:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
	button:RegisterEvent("UPDATE_INVENTORY_ALERTS");
	button:RegisterEvent("PLAYER_AURAS_CHANGED");
	button:RegisterEvent("PLAYER_TARGET_CHANGED");
	button:RegisterEvent("UNIT_AURASTATE");
	button:RegisterEvent("UNIT_INVENTORY_CHANGED");
	button:RegisterEvent("CRAFT_SHOW");
	button:RegisterEvent("CRAFT_CLOSE");
	button:RegisterEvent("TRADE_SKILL_SHOW");
	button:RegisterEvent("TRADE_SKILL_CLOSE");
	button:RegisterEvent("UNIT_HEALTH");
	button:RegisterEvent("UNIT_MANA");
	button:RegisterEvent("UNIT_RAGE");
	button:RegisterEvent("UNIT_FOCUS");
	button:RegisterEvent("UNIT_ENERGY");
	button:RegisterEvent("PLAYER_ENTER_COMBAT");
	button:RegisterEvent("PLAYER_LEAVE_COMBAT");
	button:RegisterEvent("PLAYER_COMBO_POINTS");
	button:RegisterEvent("UPDATE_BINDINGS");
	button:RegisterEvent("START_AUTOREPEAT_SPELL");
	button:RegisterEvent("STOP_AUTOREPEAT_SPELL");
	button:RegisterEvent("PLAYER_ENTERING_WORLD");
	FlexBarButton_UpdateHotkeys(button);
end

function FlexBarButton_UpdateHotkeys(button)
-- This sets the hotkey text.  Originally borrowed from Telo's SideBar,
-- optionally puts binding or id in depending on user selection.
	local name = button:GetName();
	local hotkey = getglobal(name.."HotKey");
	local text2 = getglobal(name.."Text2");
	local s, e, id = string.find(name, "^FlexBarButton(%d+)$");
	local action = "FLEXACTIONBUTTON"..id;
	local text = KeyBindingFrame_GetLocalizedName(GetBindingKey(action), "KEY_");
	
	text = string.gsub(text, "CTRL--", "C-");
	text = string.gsub(text, "ALT--", "A-");
	text = string.gsub(text, "SHIFT--", "S-");
	text = string.gsub(text, "Num Pad", "NP");
	text = string.gsub(text, "Backspace", "Bksp");
	text = string.gsub(text, "Spacebar", "Space");
	text = string.gsub(text, "Page", "Pg");
	text = string.gsub(text, "Down", "Dn");
	text = string.gsub(text, "Arrow", "");
	text = string.gsub(text, "Insert", "Ins");
	text = string.gsub(text, "Delete", "Del");

	local buttonnum=FB_GetButtonNum(button)
	if FBState[buttonnum]["hotkeytext"] == nil then FBState[buttonnum]["hotkeytext"] = "" end
	-- going to add %s for slots free for bags here later
	if FBState[buttonnum]["hotkeytext"] == "%b" then
		hotkey:SetText(text);
	elseif FBState[buttonnum]["hotkeytext"] == "%c" then
		hotkey:SetText("**")
	elseif FBState[buttonnum]["hotkeytext"] == "%d" then
		hotkey:SetText(buttonnum)
	else
		FB_TextSub(buttonnum)
	end

	if FBState[buttonnum]["text2"] == nil then FBState[buttonnum]["text2"] = "" end
	-- going to add %s for slots free for bags here later
	if FBState[buttonnum]["text2"] == "%b" then
		text2:SetText(text);
	elseif FBState[buttonnum]["text2"] == "%c" then
		text2:SetText("**")
	elseif FBState[buttonnum]["text2"] == "%d" then
		text2:SetText(buttonnum)
	else
		FB_TextSub(buttonnum)
	end
end

function FlexBarButton_Update(button)
-- put checks in to update only evey .25 seconds
	local buttonnum=FB_GetButtonNum(button)
-- Blizzard code
	-- Determine whether or not the button should be flashing or not since the button may have missed the enter combat event
	local buttonID = FlexBarButton_GetID(button);
	if ( IsAttackAction(buttonID) and IsCurrentAction(buttonID) ) then
		IN_ATTACK_MODE = 1;
	else
		IN_ATTACK_MODE = nil;
	end
	IN_AUTOREPEAT_MODE = IsAutoRepeatAction(buttonID);
	
	local icon = getglobal(button:GetName().."Icon");
	local buttonCooldown = getglobal(button:GetName().."Cooldown");
	local texture = GetActionTexture(FlexBarButton_GetID(button));
	if ( texture ) then
		icon:SetTexture(texture);
		icon:Show();
		button.rangeTimer = TOOLTIP_UPDATE_TIME;
		button:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2");
	else
		if	FBProfileLoaded and FBSavedProfile[FBProfileName].FlexActions[buttonID] and
			FBSavedProfile[FBProfileName].FlexActions[buttonID]["texture"] then
			local fbtext = string.lower(FBSavedProfile[FBProfileName].FlexActions[buttonID]["texture"])
			if 	fbtext == "%player" or fbtext == "%party1" or
				fbtext == "%party2" or fbtext == "%party3" or
				fbtext == "%party4" or fbtext == "%target" or fbtext == "%pet" then
				
				SetPortraitTexture(icon,string.sub(fbtext,2))
				icon:SetVertexColor(1,1,1)
				icon:SetAlpha(1)
			else
				icon:SetTexture(FBSavedProfile[FBProfileName].FlexActions[buttonID]["texture"])
			end
			button:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2");
			icon:Show()
		else
			icon:Hide();
			buttonCooldown:Hide();
			button.rangeTimer = nil;
			if not  (FBProfileLoaded and FBSavedProfile[FBProfileName].FlexActions[buttonID] and
					FBSavedProfile[FBProfileName].FlexActions[buttonID]["texture"]) then
				button:SetNormalTexture("Interface\\Buttons\\UI-Quickslot");
			end
			if not FBState[FB_GetButtonNum(button)]["hotkeycolor"] then getglobal(button:GetName().."HotKey"):SetVertexColor(0.6, 0.6, 0.6); end
		end
	end
	FlexBarButton_UpdateCount(button);
	if ( HasAction(FlexBarButton_GetID(button)) ) then
		button:Show();
		-- somewhere right before here, this gets reset to whatever 
		-- has focus -- so put it back.  I don't know if this causes problems
		-- but it is certainly the first place to look.  This only happens with
		-- remapping an empty button with showgrid=0 to a non-empty button.
		FlexBarButton_UpdateUsable(button);
		FlexBarButton_UpdateCooldown(button);
	elseif ( button.showgrid == 0 ) then
		if not FBState[FB_GetButtonNum(button)]["texture"] then
			button:Hide();
		end
	else
		getglobal(button:GetName().."Cooldown"):Hide();
	end

	if ( IN_ATTACK_MODE or IN_AUTOREPEAT_MODE ) then
		FlexBarButton_StartFlash(button);
	else
		FlexBarButton_StopFlash(button);
	end

	if ( GameTooltip:IsOwned(button) ) then
		FlexBarButton_SetTooltip(button);
	else
		button.updateTooltip = nil;
	end

	-- Update Macro Text
	local macroName = getglobal(button:GetName().."Name");
	macroName:SetText(GetActionText(FlexBarButton_GetID(button)))
end

function FlexBarButton_ShowGrid(button)
-- Blizzard code;  Show button even if it doesn't have an action associated with it.
	button.showgrid = button.showgrid+1;
	getglobal(button:GetName().."NormalTexture"):SetVertexColor(1.0, 1.0, 1.0);
	button:Show();
	local _,frame = FB_GetWidgets(FB_GetButtonNum(button))
	frame:EnableDrawLayer()
end

function FlexBarButton_HideGrid(button)	
-- Blizzard code: Hide button if it doesn't have an action associated with it
	button.showgrid = button.showgrid-1;
	if 	( button.showgrid == 0 ) and not (HasAction(FlexBarButton_GetID(button)))  then
		button:Hide();
		local _,frame = FB_GetWidgets(FB_GetButtonNum(button))
		frame:DisableDrawLayer()
	end
end

function FlexBarButton_UpdateState(button)
-- Blizzard code: Purpose unknown at button time
	if ( IsCurrentAction(FlexBarButton_GetID(button)) or IsAutoRepeatAction(FlexBarButton_GetID(button)) ) then
		button:SetChecked(1);
	else
		button:SetChecked(0);
	end
end

function FlexBarButton_UpdateUsable(button)
local buttonnum=FB_GetButtonNum(button)
-- Blizzard code:
	local icon = getglobal(button:GetName().."Icon");
	local normalTexture = getglobal(button:GetName().."NormalTexture");
-- Mana check available here - also has potential
	local isUsable, notEnoughMana = IsUsableAction(FlexBarButton_GetID(button));
-- Hotkey is the text displayed in the upper right corner.
	local count = getglobal(button:GetName().."HotKey");
	local text2 = getglobal(button:GetName().."Text2");
	local text = count:GetText();
-- Here's the test for action in range - for further enhancements that let the player know button better
	local inRange = IsActionInRange(FlexBarButton_GetID(button));
	local buttonID = FlexBarButton_GetID(button)
	if not FBState[buttonnum]["hotkeycolor"] then
		if( inRange == 0 ) then
			count:SetVertexColor(1.0, 0.1, 0.1);
		else
			count:SetVertexColor(0.6, 0.6, 0.6);
		end
	end
	-- Default blizz code resets the vertex color every pass through, regardless of whether the state
	-- changed.  This may be a cause of FPS reduction when people have lots of buttons visible.  Added checks
	-- so coloring will only occur on an actual change of state.
	if ( isUsable ) then
-- Telo added this code - If the button has hotkey text it colors like normal on in/out of range
-- w/o hotkey text it colors the entire button.  
-- added toggle to force this behavior
		if ( (not text or text == "" or FBToggles["forceshading"]) and inRange == 0 ) then
			if FBState[buttonnum]["coloring"] ~= "usable_out_of_range" then
				icon:SetVertexColor(1.0, 0.1, 0.1);
				normalTexture:SetVertexColor(1.0, 0.1, 0.1);
				FBState[buttonnum]["coloring"] = "usable_out_of_range"
			end
		else
			if FBState[buttonnum]["coloring"] ~= "usable_in_range" then
				icon:SetVertexColor(1.0, 1.0, 1.0);
				normalTexture:SetVertexColor(1.0, 1.0, 1.0);
				FBState[buttonnum]["coloring"] = "usable_in_range"
			end
		end
	elseif ( notEnoughMana ) then
		if FBState[buttonnum]["coloring"] ~= "not_enough_mana" then
			icon:SetVertexColor(0.5, 0.5, 1.0);
			normalTexture:SetVertexColor(0.5, 0.5, 1.0);
			FBState[buttonnum]["coloring"] = "not_enough_mana"
		end
	else
		if FBState[buttonnum]["coloring"] ~= "not_usable" then
			icon:SetVertexColor(0.4, 0.4, 0.4);
			normalTexture:SetVertexColor(1.0, 1.0, 1.0);
			FBState[buttonnum]["coloring"] = "not_usable"
		end
	end
	if FBProfileLoaded and FBSavedProfile[FBProfileName].FlexActions[buttonID] and FBSavedProfile[FBProfileName].FlexActions[buttonID]["texture"] then
		icon:SetVertexColor(1.0, 1.0, 1.0);
		normalTexture:SetVertexColor(1.0, 1.0, 1.0);
	end

	if FBState[buttonnum]["icon"] then
		local bcolors = FBState[buttonnum]["icon"]
		icon:SetVertexColor(bcolors[1], bcolors[2], bcolors[3])
	end
	
-- Digital cooldown - set the hotkey text to '%c' to get a digital cooldown
	if FBState[buttonnum]["hotkeytext"] then
		if FBState[buttonnum]["hotkeytext"] == "%c" then
			local start, duration, enable = GetActionCooldown(button:GetID());
			if start > 0 then
				count:SetText(format("%d",duration-(GetTime()-start)))
				count:SetVertexColor(1.0, 1.0, .5)
			else
				count:SetText("**")
				count:SetVertexColor(.5, 1.0, .5)
			end
		end
	end
-- Digital cooldown - set the hotkey text to '%c' to get a digital cooldown
	if FBState[buttonnum]["text2"] then
		if FBState[buttonnum]["text2"] == "%c" then
			local start, duration, enable = GetActionCooldown(button:GetID());
			if start > 0 then
				text2:SetText(format("%d",duration-(GetTime()-start)))
				text2:SetVertexColor(1.0, 1.0, .5)
			else
				text2:SetText("**")
				text2:SetVertexColor(.5, 1.0, .5)
			end
		end
	end
end

function FlexBarButton_UpdateCount(button)
-- Blizzard code - purpose unknown at this time
	local text = getglobal(button:GetName().."Count");
	local count = GetActionCount(FlexBarButton_GetID(button));
	if ( count > 1 ) then
		text:SetText(count);
	else
		text:SetText("");
	end
end

function FlexBarButton_UpdateCooldown(button)
local buttonnum=FB_GetButtonNum(button)
-- Blizzard code - looks like it updates the little cooldown spinner.
	local cooldown = getglobal(button:GetName().."Cooldown");
	local hotkey = getglobal(button:GetName().."HotKey");
	local start, duration, enable = GetActionCooldown(FlexBarButton_GetID(button));
	-- if digital cooldowns are enabled, disable spinner - it obscures the display.
	if FBState[buttonnum]["hotkeytext"] ~= "%c" and FBState[buttonnum]["text2"] ~= "%c" then
		CooldownFrame_SetTimer(cooldown, start, duration, enable);
	end
end

function FlexBarButton_OnEvent(event, button)
-- Event code for individual buttons 
	if( event == "VARIABLES_LOADED" ) then
	end

-- Blizzard code, unmodified to the best of my knowledge from here on down.
	if ( event == "ACTIONBAR_SLOT_CHANGED" ) then
		if ( arg1 == -1 or arg1 == FlexBarButton_GetID(button) ) then
			FlexBarButton_Update(button);
		end
		return;
	end
	if ( event == "PLAYER_AURAS_CHANGED") then
		FlexBarButton_Update(button);
		FlexBarButton_UpdateState(button);
		return;
	end
	if ( event == "ACTIONBAR_SHOWGRID" ) then
		FlexBarButton_ShowGrid(button);
		return;
	end
	if ( event == "ACTIONBAR_HIDEGRID" ) then
		FlexBarButton_HideGrid(button);
		return;
	end
	if ( event == "UPDATE_BINDINGS" ) then
		FlexBarButton_UpdateHotkeys(button);
	end

	-- All event handlers below this line MUST only be valid when the button is visible
	if ( not button:IsVisible() ) then
		return;
	end

	if ( event == "PLAYER_TARGET_CHANGED" ) then
		FlexBarButton_UpdateUsable(button);
		return;
	end
	if ( event == "UNIT_AURASTATE" ) then
		if ( arg1 == "player" or arg1 == "target" ) then
			FlexBarButton_UpdateUsable(button);
		end
		return;
	end
	if ( event == "UNIT_INVENTORY_CHANGED" ) then
		if ( arg1 == "player" ) then
			FlexBarButton_Update(button);
		end
		return;
	end
	if ( event == "ACTIONBAR_UPDATE_STATE" ) then
		FlexBarButton_UpdateState(button);
		return;
	end
	if ( event == "ACTIONBAR_UPDATE_USABLE" ) then
		-- put checks in to update only evey .25 seconds
		local buttonnum=FB_GetButtonNum(button)
		if FBState[buttonnum]["lastupdate"] and GetTime() - FBState[buttonnum]["lastupdate"] < .25 then return end
		FlexBarButton_UpdateUsable(button);
		FlexBarButton_UpdateCooldown(button);
		FBState[buttonnum]["lastupdate"] = GetTime()
		return;
	end
	if ( event == "UPDATE_INVENTORY_ALERTS" or event == "ACTIONBAR_UPDATE_COOLDOWN" ) then
		FlexBarButton_UpdateUsable(button);
		FlexBarButton_UpdateCooldown(button);
		return;
	end
	if ( event == "CRAFT_SHOW" or event == "CRAFT_CLOSE" or event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE" ) then
		FlexBarButton_UpdateState(button);
		return;
	end
	if ( arg1 == "player" and (event == "UNIT_HEALTH" or event == "UNIT_MANA" or event == "UNIT_RAGE" or event == "UNIT_FOCUS" or event == "UNIT_ENERGY") ) then
		FlexBarButton_UpdateUsable(button);
		return;
	end
	if ( event == "PLAYER_ENTER_COMBAT" ) then
		IN_ATTACK_MODE = 1;
		if ( IsAttackAction(FlexBarButton_GetID(button)) ) then
			FlexBarButton_StartFlash(button);
		end
		return;
	end
	if ( event == "PLAYER_LEAVE_COMBAT" ) then
		IN_ATTACK_MODE = 0;
		if ( IsAttackAction(FlexBarButton_GetID(button)) ) then
			FlexBarButton_StopFlash(button);
		end
		return;
	end
	if ( event == "PLAYER_COMBO_POINTS" ) then
		FlexBarButton_UpdateUsable(button);
		return;
	end
	if ( event == "START_AUTOREPEAT_SPELL" ) then
		IN_AUTOREPEAT_MODE = 1;
		if ( IsAutoRepeatAction(FlexBarButton_GetID(button)) ) then
			FlexBarButton_StartFlash(button);
		end
		return;
	end
	if ( event == "STOP_AUTOREPEAT_SPELL" ) then
		IN_AUTOREPEAT_MODE = nil;
		if ( FlexBarButton_IsFlashing(button) and not IsAttackAction(FlexBarButton_GetID(button)) ) then
			FlexBarButton_StopFlash(button);
		end
		return;
	end
end

function FlexBarButton_SetTooltip(button)
-- Blizzard code
-- appears to reset the manually set this from my routines.
	GameTooltip_SetDefaultAnchor(GameTooltip, button)	
--	GameTooltip:SetOwner(this);
	if ( GameTooltip:SetAction(FlexBarButton_GetID(button)) ) then
		button.updateTooltip = TOOLTIP_UPDATE_TIME;
	else
		button.updateTooltip = nil;
	end
end


function FlexBarButton_OnUpdate(elapsed, button)
-- Blizzard code
	if ( FlexBarButton_IsFlashing(button) ) then
		button.flashtime = button.flashtime - elapsed;
		if ( button.flashtime <= 0 ) then
			local overtime = -button.flashtime;
			if ( overtime >= ATTACK_BUTTON_FLASH_TIME ) then
				overtime = 0;
			end
			button.flashtime = ATTACK_BUTTON_FLASH_TIME - overtime;

			local flashTexture = getglobal(button:GetName().."Flash");
			if ( flashTexture:IsVisible() ) then
				flashTexture:Hide();
			else
				flashTexture:Show();
			end
		end
	end
	-- Handle range indicator
	if ( button.rangeTimer ) then
		if ( button.rangeTimer < 0 ) then
			FlexBarButton_UpdateUsable(button);
			button.rangeTimer = TOOLTIP_UPDATE_TIME;
		else
			button.rangeTimer = button.rangeTimer - elapsed;
		end
	end

	if ( not button.updateTooltip ) then
		return;
	end

	button.updateTooltip = button.updateTooltip - elapsed;
	if ( button.updateTooltip > 0 ) then
		return;
	end

	if ( GameTooltip:IsOwned(button) ) then
		FlexBarButton_SetTooltip(button);
	else
		button.updateTooltip = nil;
	end
end

function FlexBarButton_GetID(button)
	return (button:GetID())
end

function FlexBarButton_StartFlash(button)
-- Blizzard code
	button.flashing = 1;
	button.flashtime = 0;
	FlexBarButton_UpdateState(button);
end

function FlexBarButton_StopFlash(button)
-- Blizzard code
	button.flashing = 0;
	getglobal(button:GetName().."Flash"):Hide();
	FlexBarButton_UpdateState(button);
end

function FlexBarButton_IsFlashing(button)
-- Blizzard code
	if ( button.flashing == 1 ) then
		return 1;
	else
		return nil;
	end
end

function FlexBarButton_OnClick(button, frombinding, mousebutton)
	if ( IsShiftKeyDown() ) and ( not frombinding ) then
		if not FBSavedProfile[FBProfileName].FlexActions[button:GetID()] then
			PickupAction(FlexBarButton_GetID(button));
		else
			local u = Utility_Class:New()
			if FBSavedProfile[FBProfileName].FlexActions[button:GetID()]["action"] == "autoitem" then
				u:Echo("Error:  Cannot drag an Auto Item off - disable auto item to remove")
			end
		end
	else
		if not FBState[FB_GetButtonNum(button)]["disabled"] then
			if (FBState[FB_GetButtonNum(button)]["advanced"] and mousebutton == "LeftButton") or
				not FBState[FB_GetButtonNum(button)]["advanced"] then
				local id = FlexBarButton_GetID(button);
				if 	not FBSavedProfile[FBProfileName].FlexActions[button:GetID()] or 
					FBSavedProfile[FBProfileName].FlexActions[button:GetID()]["action"] == "autoitem" then
					MacroFrame_EditMacro();
					UseAction(id, 1);
				else
					if FBSavedProfile[FBProfileName].FlexActions[button:GetID()]["action"] == "macro" then
						local name = FBSavedProfile[FBProfileName].FlexActions[button:GetID()]["name"]
						local macro = FBSavedProfile[FBProfileName].FlexActions[button:GetID()]["macro"]
						if type(macro) == "table" then
							local index,command, longmacro
							longmacro = "\n"
							for index,command in ipairs(macro) do
								longmacro=longmacro..command.."\n"
							end
							FB_Execute_MultilineMacro(longmacro,"InLineMacro"..GetTime())
						elseif FBScripts[macro] then
							FB_Execute_MultilineMacro(FBScripts[macro],name)
						else
							FB_Execute_Command(macro)
						end
					elseif FBSavedProfile[FBProfileName].FlexActions[button:GetID()]["action"] == "script" then
						if FBScripts[FBSavedProfile[FBProfileName].FlexActions[button:GetID()]["script"]] then
							RunScript(FBScripts[FBSavedProfile[FBProfileName].FlexActions[button:GetID()]["script"]])
						else
							RunScript(FBSavedProfile[FBProfileName].FlexActions[button:GetID()]["script"])
						end
					end
				end
			end
		end
		if FBEventToggles["buttonevents"] ~= "off" then
			local lastbutton = FBLastButtonDown
			if frombinding then lastbutton="LeftButton" end
			FB_RaiseEvent(lastbutton.."Click", FB_GetButtonNum(button))
			if FBState[FB_GetButtonNum(button)]["echo"] then
				FB_RaiseEvent(lastbutton.."Click",FBState[FB_GetButtonNum(button)]["echo"])
			end
		end
	end
	FlexBarButton_UpdateState(button);
end

function FlexBar_LoadDefaults()
	util:Echo("Flex Bar - first use")
end

------------------------- Bindings ---------------------------------------
BINDING_HEADER_FLEXBAR_SCRIPTS = "FlexBar GUI Panels";
BINDING_NAME_FLEXBAR_MAINMENU = "Open Flex Main Menu";
BINDING_NAME_FLEXBAR_AUTOITEM = "Open Auto Items";
BINDING_NAME_FLEXBAR_SCRIPTS = "Open Script Editor";
BINDING_NAME_FLEXBAR_PERFORMANCE = "Open Performance Panel";
BINDING_NAME_FLEXBAR_OPTIONS = "Open Options Panel";
BINDING_NAME_FLEXBAR_EVENTED = "Open Event Editor";
BINDING_HEADER_FLEXBAR = "FlexBar Buttons";
BINDING_NAME_FLEXACTIONBUTTON1 = "FlexBar Button 1";
BINDING_NAME_FLEXACTIONBUTTON2 = "FlexBar Button 2";
BINDING_NAME_FLEXACTIONBUTTON3 = "FlexBar Button 3";
BINDING_NAME_FLEXACTIONBUTTON4 = "FlexBar Button 4";
BINDING_NAME_FLEXACTIONBUTTON5 = "FlexBar Button 5";
BINDING_NAME_FLEXACTIONBUTTON6 = "FlexBar Button 6";
BINDING_NAME_FLEXACTIONBUTTON7 = "FlexBar Button 7";
BINDING_NAME_FLEXACTIONBUTTON8 = "FlexBar Button 8";
BINDING_NAME_FLEXACTIONBUTTON9 = "FlexBar Button 9";
BINDING_NAME_FLEXACTIONBUTTON10 = "FlexBar Button 10";
BINDING_NAME_FLEXACTIONBUTTON11 = "FlexBar Button 11";
BINDING_NAME_FLEXACTIONBUTTON12 = "FlexBar Button 12";
BINDING_NAME_FLEXACTIONBUTTON13 = "FlexBar Button 13";
BINDING_NAME_FLEXACTIONBUTTON14 = "FlexBar Button 14";
BINDING_NAME_FLEXACTIONBUTTON15 = "FlexBar Button 15";
BINDING_NAME_FLEXACTIONBUTTON16 = "FlexBar Button 16";
BINDING_NAME_FLEXACTIONBUTTON17 = "FlexBar Button 17";
BINDING_NAME_FLEXACTIONBUTTON18 = "FlexBar Button 18";
BINDING_NAME_FLEXACTIONBUTTON19 = "FlexBar Button 19";
BINDING_NAME_FLEXACTIONBUTTON20 = "FlexBar Button 20";
BINDING_NAME_FLEXACTIONBUTTON21 = "FlexBar Button 21";
BINDING_NAME_FLEXACTIONBUTTON22 = "FlexBar Button 22";
BINDING_NAME_FLEXACTIONBUTTON23 = "FlexBar Button 23";
BINDING_NAME_FLEXACTIONBUTTON24 = "FlexBar Button 24";
BINDING_NAME_FLEXACTIONBUTTON25 = "FlexBar Button 25";
BINDING_NAME_FLEXACTIONBUTTON26 = "FlexBar Button 26";
BINDING_NAME_FLEXACTIONBUTTON27 = "FlexBar Button 27";
BINDING_NAME_FLEXACTIONBUTTON28 = "FlexBar Button 28";
BINDING_NAME_FLEXACTIONBUTTON29 = "FlexBar Button 29";
BINDING_NAME_FLEXACTIONBUTTON30 = "FlexBar Button 30";
BINDING_NAME_FLEXACTIONBUTTON31 = "FlexBar Button 31";
BINDING_NAME_FLEXACTIONBUTTON32 = "FlexBar Button 32";
BINDING_NAME_FLEXACTIONBUTTON33 = "FlexBar Button 33";
BINDING_NAME_FLEXACTIONBUTTON34 = "FlexBar Button 34";
BINDING_NAME_FLEXACTIONBUTTON35 = "FlexBar Button 35";
BINDING_NAME_FLEXACTIONBUTTON36 = "FlexBar Button 36";
BINDING_NAME_FLEXACTIONBUTTON37 = "FlexBar Button 37";
BINDING_NAME_FLEXACTIONBUTTON38 = "FlexBar Button 38";
BINDING_NAME_FLEXACTIONBUTTON39 = "FlexBar Button 39";
BINDING_NAME_FLEXACTIONBUTTON40 = "FlexBar Button 40";
BINDING_NAME_FLEXACTIONBUTTON41 = "FlexBar Button 41";
BINDING_NAME_FLEXACTIONBUTTON42 = "FlexBar Button 42";
BINDING_NAME_FLEXACTIONBUTTON43 = "FlexBar Button 43";
BINDING_NAME_FLEXACTIONBUTTON44 = "FlexBar Button 44";
BINDING_NAME_FLEXACTIONBUTTON45 = "FlexBar Button 45";
BINDING_NAME_FLEXACTIONBUTTON46 = "FlexBar Button 46";
BINDING_NAME_FLEXACTIONBUTTON47 = "FlexBar Button 47";
BINDING_NAME_FLEXACTIONBUTTON48 = "FlexBar Button 48";
BINDING_NAME_FLEXACTIONBUTTON49 = "FlexBar Button 49";
BINDING_NAME_FLEXACTIONBUTTON50 = "FlexBar Button 50";
BINDING_NAME_FLEXACTIONBUTTON51 = "FlexBar Button 51";
BINDING_NAME_FLEXACTIONBUTTON52 = "FlexBar Button 52";
BINDING_NAME_FLEXACTIONBUTTON53 = "FlexBar Button 53";
BINDING_NAME_FLEXACTIONBUTTON54 = "FlexBar Button 54";
BINDING_NAME_FLEXACTIONBUTTON55 = "FlexBar Button 55";
BINDING_NAME_FLEXACTIONBUTTON56 = "FlexBar Button 56";
BINDING_NAME_FLEXACTIONBUTTON57 = "FlexBar Button 57";
BINDING_NAME_FLEXACTIONBUTTON58 = "FlexBar Button 58";
BINDING_NAME_FLEXACTIONBUTTON59 = "FlexBar Button 59";
BINDING_NAME_FLEXACTIONBUTTON60 = "FlexBar Button 60";
BINDING_NAME_FLEXACTIONBUTTON61 = "FlexBar Button 61";
BINDING_NAME_FLEXACTIONBUTTON62 = "FlexBar Button 62";
BINDING_NAME_FLEXACTIONBUTTON63 = "FlexBar Button 63";
BINDING_NAME_FLEXACTIONBUTTON64 = "FlexBar Button 64";
BINDING_NAME_FLEXACTIONBUTTON65 = "FlexBar Button 65";
BINDING_NAME_FLEXACTIONBUTTON66 = "FlexBar Button 66";
BINDING_NAME_FLEXACTIONBUTTON67 = "FlexBar Button 67";
BINDING_NAME_FLEXACTIONBUTTON68 = "FlexBar Button 68";
BINDING_NAME_FLEXACTIONBUTTON69 = "FlexBar Button 69";
BINDING_NAME_FLEXACTIONBUTTON70 = "FlexBar Button 70";
BINDING_NAME_FLEXACTIONBUTTON71 = "FlexBar Button 71";
BINDING_NAME_FLEXACTIONBUTTON72 = "FlexBar Button 72";
BINDING_NAME_FLEXACTIONBUTTON73 = "FlexBar Button 73";
BINDING_NAME_FLEXACTIONBUTTON74 = "FlexBar Button 74";
BINDING_NAME_FLEXACTIONBUTTON75 = "FlexBar Button 75";
BINDING_NAME_FLEXACTIONBUTTON76 = "FlexBar Button 76";
BINDING_NAME_FLEXACTIONBUTTON77 = "FlexBar Button 77";
BINDING_NAME_FLEXACTIONBUTTON78 = "FlexBar Button 78";
BINDING_NAME_FLEXACTIONBUTTON79 = "FlexBar Button 79";
BINDING_NAME_FLEXACTIONBUTTON80 = "FlexBar Button 80";
BINDING_NAME_FLEXACTIONBUTTON81 = "FlexBar Button 81";
BINDING_NAME_FLEXACTIONBUTTON82 = "FlexBar Button 82";
BINDING_NAME_FLEXACTIONBUTTON83 = "FlexBar Button 83";
BINDING_NAME_FLEXACTIONBUTTON84 = "FlexBar Button 84";
BINDING_NAME_FLEXACTIONBUTTON85 = "FlexBar Button 85";
BINDING_NAME_FLEXACTIONBUTTON86 = "FlexBar Button 86";
BINDING_NAME_FLEXACTIONBUTTON87 = "FlexBar Button 87";
BINDING_NAME_FLEXACTIONBUTTON88 = "FlexBar Button 88";
BINDING_NAME_FLEXACTIONBUTTON89 = "FlexBar Button 89";
BINDING_NAME_FLEXACTIONBUTTON90 = "FlexBar Button 90";
BINDING_NAME_FLEXACTIONBUTTON91 = "FlexBar Button 91";
BINDING_NAME_FLEXACTIONBUTTON92 = "FlexBar Button 92";
BINDING_NAME_FLEXACTIONBUTTON93 = "FlexBar Button 93";
BINDING_NAME_FLEXACTIONBUTTON94 = "FlexBar Button 94";
BINDING_NAME_FLEXACTIONBUTTON95 = "FlexBar Button 95";
BINDING_NAME_FLEXACTIONBUTTON96 = "FlexBar Button 96";
BINDING_HEADER_FLEXBAR_EVENTS = "FlexBar Events";
BINDING_NAME_FLEXACTIONBUTTON97 = "FlexBar Button 97";
BINDING_NAME_FLEXACTIONBUTTON98 = "FlexBar Button 98";
BINDING_NAME_FLEXACTIONBUTTON99 = "FlexBar Button 99";
BINDING_NAME_FLEXACTIONBUTTON100 = "FlexBar Button 100";
BINDING_NAME_FLEXACTIONBUTTON101 = "FlexBar Button 101";
BINDING_NAME_FLEXACTIONBUTTON102 = "FlexBar Button 102";
BINDING_NAME_FLEXACTIONBUTTON103 = "FlexBar Button 103";
BINDING_NAME_FLEXACTIONBUTTON104 = "FlexBar Button 104";
BINDING_NAME_FLEXACTIONBUTTON105 = "FlexBar Button 105";
BINDING_NAME_FLEXACTIONBUTTON106 = "FlexBar Button 106";
BINDING_NAME_FLEXACTIONBUTTON107 = "FlexBar Button 107";
BINDING_NAME_FLEXACTIONBUTTON108 = "FlexBar Button 108";
BINDING_NAME_FLEXACTIONBUTTON109 = "FlexBar Button 109";
BINDING_NAME_FLEXACTIONBUTTON110 = "FlexBar Button 110";
BINDING_NAME_FLEXACTIONBUTTON111 = "FlexBar Button 111";
BINDING_NAME_FLEXACTIONBUTTON112 = "FlexBar Button 112";
BINDING_NAME_FLEXACTIONBUTTON113 = "FlexBar Button 113";
BINDING_NAME_FLEXACTIONBUTTON114 = "FlexBar Button 114";
BINDING_NAME_FLEXACTIONBUTTON115 = "FlexBar Button 115";
BINDING_NAME_FLEXACTIONBUTTON116 = "FlexBar Button 116";
BINDING_NAME_FLEXACTIONBUTTON117 = "FlexBar Button 117";
BINDING_NAME_FLEXACTIONBUTTON118 = "FlexBar Button 118";
BINDING_NAME_FLEXACTIONBUTTON119 = "FlexBar Button 119";
BINDING_NAME_FLEXACTIONBUTTON120 = "FlexBar Button 120";
BINDING_NAME_FLEXBAREVENT1 = "FlexBar Event 1";
BINDING_NAME_FLEXBAREVENT2 = "FlexBar Event 2";
BINDING_NAME_FLEXBAREVENT3 = "FlexBar Event 3";
BINDING_NAME_FLEXBAREVENT4 = "FlexBar Event 4";
BINDING_NAME_FLEXBAREVENT5 = "FlexBar Event 5";
BINDING_NAME_FLEXBAREVENT6 = "FlexBar Event 6";
BINDING_NAME_FLEXBAREVENT7 = "FlexBar Event 7";
BINDING_NAME_FLEXBAREVENT8 = "FlexBar Event 8";
BINDING_NAME_FLEXBAREVENT9 = "FlexBar Event 9";
BINDING_NAME_FLEXBAREVENT10 = "FlexBar Event 10";
BINDING_NAME_FLEXBAREVENT11 = "FlexBar Event 11";
BINDING_NAME_FLEXBAREVENT12 = "FlexBar Event 12";
BINDING_NAME_FLEXBAREVENT13 = "FlexBar Event 13";
BINDING_NAME_FLEXBAREVENT14 = "FlexBar Event 14";
BINDING_NAME_FLEXBAREVENT15 = "FlexBar Event 15";
BINDING_NAME_FLEXBAREVENT16 = "FlexBar Event 16";
BINDING_NAME_FLEXBAREVENT17 = "FlexBar Event 17";
BINDING_NAME_FLEXBAREVENT18 = "FlexBar Event 18";
BINDING_NAME_FLEXBAREVENT19 = "FlexBar Event 19";
BINDING_NAME_FLEXBAREVENT20 = "FlexBar Event 20";
BINDING_NAME_FLEXBAREVENT21 = "FlexBar Event 21";
BINDING_NAME_FLEXBAREVENT22 = "FlexBar Event 22";
BINDING_NAME_FLEXBAREVENT23 = "FlexBar Event 23";
BINDING_NAME_FLEXBAREVENT24 = "FlexBar Event 24";
BINDING_NAME_FLEXBAREVENT25 = "FlexBar Event 25";
BINDING_NAME_FLEXBAREVENT26 = "FlexBar Event 26";
BINDING_NAME_FLEXBAREVENT27 = "FlexBar Event 27";
BINDING_NAME_FLEXBAREVENT28 = "FlexBar Event 28";
BINDING_NAME_FLEXBAREVENT29 = "FlexBar Event 29";
BINDING_NAME_FLEXBAREVENT30 = "FlexBar Event 30";
