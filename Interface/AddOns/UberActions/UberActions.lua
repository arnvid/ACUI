-- 
-- UberActions
-- 
-- Provides what should be in the main game in regards to action buttons:
--   *) A "Count" for spells that require reagents equal to the reagents in your pack.
--   *) Updating buttons with new spell ranks as you buy the spells
--   *) Allows you to inspect all 120 buttons
--   *) Allows you to lock the action bar, so you don't pull off 
--      icons accidentally. However, you can configure a key 
--      (shift/alt/control) to hold down to force the icon pickup.
--   *) Most important: A programmatic interface to determine what is in each button.
--
-- Programmatic access to ActionButton information:
--   Button information can be accesed by the array UberActions_Actions.
--   Each member of the array is a table with several possible fields:
--     .name     : Will be set on any button with something in it.
--     .texture  : Will be set on any button with something in it.
--     .maintype : Either "RACIAL", "SPELL" or "SKILL"
--     .subtype  : Either "INSTANT", "NEXTMELEE" or "CHANNELED", nil means a normal casting 
--     .reagent  : Will only be set on buttons holding spells requiring reagents
--     .mana     : Will only be set on spells requiring mana
--     .rage     : Will only be set on spells requiring rage
--     .energy   : Will only be set on spells requiring energy
--     .health   : Will only be set on spells requiring health (Life Tap) 
--     .minrange : Minimum range spell is useful at
--     .maxrange : Maximum range spell is useful at
--   i.e.: if (UberActions_Actions[button].maintype == "RACIAL") then DOSomething; end
--   Also, if you have a spell (or item, or skill) name you can determine which, 
--     if any, ActionButton has that spell.
--     ex: if (UberActions_RevMap["Monkey Spanking"]) then
--		button = UberActions_RevMap["Monkey Spanking"];
--		if (IsActionInRange(button)) then
--		...
--
--  Author: Marc aka Saien on Hyjal
--
-- Changes
--  2005.03.26
--    Fixed popup error in getactioncount
--  2005.03.23
--    Labels in "Inspect" for the new various blizzard bars
--    Adds hotkey indicators to new Blizzard bars.
--    Config Option to move Blizzards Second Right Bar to the Left of the screen
--      HOWEVER: Due to FrameStrata issues, these buttons appear above things like your 
--      Character Paperdoll, etc. This isn't what I wanted, but I'm leaving the option 
--      in. There will be no fix for such issues.
--    TOC update to 1300
-- 2005.03.05
--    Updated TOC to 4216
-- 2005.02.20
--     Updated toc to 4211
--     Fixed stuff getting stuck on cursor when upgrading spells.
-- 2005.02.06
--     Renamed from ActionReagents to UberActions, and adding all 
--     the associated new functionality
-- 2005.01.31
--     Fixed bug where reagents were assigned to items that didn't 
--     have a 4th Tooltip text line

UBERACTIONS_VERSION = "2005.03.26" -- Notice the cleverly disguised date.

UIPanelWindows["UberActions_ConfigFrame"] = { area = "left", pushable = 997 };
BINDING_HEADER_UBERACTIONS_SEP = "Uber Actions";
BINDING_NAME_UBERACTIONS_CONFIG = "Configuration Window";

UberActions_Player = nil; -- global
UberActions_Actions = {}; -- global
UberActions_ProgrammaticInfo = nil; -- global
local UberActions_Config_Loaded = nil;
local UberActions_PlayerClass = nil;
local UberActions_oldGetActionCount = nil
local UberActions_RevMap = {};
local UberActions_Reagents = {};
local UberActions_SearchedItems = nil;
local UberActions_oldActionButton_UpdateHotkeys = nil;

UBERACTIONS_LINE_HEIGHT = 180; 

local function UberActions_Overloaded_GetActionCount(actionbutton)
	if (UberActions_Config[UberActions_Player].showreagents and 
		UberActions_Actions[actionbutton] and
		UberActions_Actions[actionbutton].reagent) then
		return UberActions_Reagents[UberActions_Actions[actionbutton].reagent];
	elseif (UberActions_oldGetActionCount) then 
		return UberActions_oldGetActionCount(actionbutton);
	end
end

local function UberActions_Overloaded_PickupAction(actionbutton, supaSekritOverride)
	if (UberActions_oldPickupAction) then
		if (supaSekritOverride or not UberActions_Config[UberActions_Player].lockactionbar or
			(IsShiftKeyDown() and UberActions_Config[UberActions_Player].lockexceptshift) or
			(IsControlKeyDown() and UberActions_Config[UberActions_Player].lockexceptcontrol) or
			(IsAltKeyDown() and UberActions_Config[UberActions_Player].lockexceptalt)) then
			UberActions_oldPickupAction(actionbutton);
		else
			DEFAULT_CHAT_FRAME:AddMessage("Uber Actions: Disallowing Icon pickup because Lock Action Bar is on.");
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage("Uber Actions: Something is horribly, horribly broken and thats why what you're doing isn't working. I blame Crip!");
	end
end

local function UberActions_HookGetActionCount()
	if (not UberActions_oldGetActionCount) then
		UberActions_oldGetActionCount = GetActionCount;
		GetActionCount = UberActions_Overloaded_GetActionCount;
	end
end

local function UberActions_UnHookGetActionCount()
	if (UberActions_oldGetActionCount) then
		GetActionCount = UberActions_oldGetActionCount;
		UberActions_oldGetActionCount = nil;
	end
end

local function UberActions_HookPickupAction()
	if (not UberActions_oldPickupAction) then
		UberActions_oldPickupAction = PickupAction;
		PickupAction = UberActions_Overloaded_PickupAction;
	end
end

function UberActions_MoveLeftBar(origloc)
	MultiBarLeft:ClearAllPoints();
	if (origloc) then
		MultiBarLeft:SetPoint("TOPRIGHT","MultiBarRight","TOPLEFT",-5,0);
	else
		MultiBarLeft:SetPoint("BOTTOMLEFT","UIParent","BOTTOMLEFT",7,98);
	end
end

local function UberActions_overrideActionButton_UpdateHotkeys(actionButtonType)
	local name = this:GetName();
	local sidx, eidx = string.find(name,"MultiBar");
	if (sidx and not actionButtonType) then
		name = string.sub(name,eidx+1);
		sidx, eidx = string.find (name,"Button");
		local buttonNum = string.upper(string.sub(name,sidx));
		name = string.sub(name,1,sidx-1);
		actionButtonType = "MULTIACTIONBAR";
		if (name == "BottomLeft") then
			actionButtonType = actionButtonType .. "1";
		elseif (name == "BottomRight") then
			actionButtonType = actionButtonType .. "2";
		elseif (name == "Right") then
			actionButtonType = actionButtonType .. "3";
		elseif (name == "Left") then
			actionButtonType = actionButtonType .. "4";
		end
		actionButtonType = actionButtonType .. buttonNum;
		local hotkey = getglobal(this:GetName().."HotKey");
		local keyText = KeyBindingFrame_GetLocalizedName(GetBindingKey(actionButtonType),"KEY_");
		if (keyText) then
			keyText = string.gsub(keyText, "CTRL", "C");
			keyText = string.gsub(keyText, "ALT", "A");
			keyText = string.gsub(keyText, "SHIFT", "S");
			hotkey:Show();
			hotkey:SetText(keyText);
		else
			hotkey:Hide();
		end
	elseif (UberActions_oldActionButton_UpdateHotkeys) then
		UberActions_oldActionButton_UpdateHotkeys(actionButtonType);
	end
end

local function UberActions_ActionSearch()
	local i;
	local j;
	local txt;
	local startidx;
	local endidx;
	UberActions_Actions = {};
	UberActions_RevMap = {};
	for i = 1, 120, 1 do
		UberActions_Actions[i] = {};
		UberActions_Actions[i].texture = GetActionTexture(i); 
		if (UberActions_Actions[i].texture) then
			for j = 1, 10, 1 do
				getglobal("UberActions_TooltipTextLeft"..j):SetText("");
				getglobal("UberActions_TooltipTextRight"..j):SetText("");
			end
			-- Ok, I should insert the hook for ClearMoney here
			-- But this doesn't get called too frequently and, well live with it.
			UberActions_Tooltip:SetAction(i);
			UberActions_Actions[i].name = UberActions_TooltipTextLeft1:GetText();
			for j = 2, 10, 1 do
				txt = getglobal("UberActions_TooltipTextLeft"..j):GetText();
				if (txt and txt ~= "") then
					if (string.find(txt,"^Reagents: ")) then
						startidx, endidx = string.find(txt,"^Reagents: ");
						txt = string.sub(txt,endidx+1);
						startidx,endidx = string.find(txt,"|cffff2020");
						if (startidx) then
							txt = string.sub (txt,endidx+1);
						end
						startidx,endidx = string.find(txt,"|r");
						if (startidx) then
							txt = string.sub (txt,1,startidx-1);
						end
						UberActions_Actions[i].reagent = txt;
						if (not UberActions_Reagents[txt]) then
							UberActions_Reagents[txt] = 0;
							-- New item, lets force a button update
							UberActions_SearchedItems = nil;
						end
					elseif (string.find(txt,"^[0-9]+ Mana")) then
						UberActions_Actions[i].maintype = "SPELL";
						startidx = string.find(txt," ");
						UberActions_Actions[i].mana = tonumber(string.sub(txt,1,startidx-1));
					elseif (string.find(txt,"^[0-9]+ Energy")) then
						UberActions_Actions[i].maintype = "SPELL";
						startidx = string.find(txt," ");
						UberActions_Actions[i].energy = tonumber(string.sub(txt,1,startidx-1));
					elseif (string.find(txt,"^[0-9]+ Health")) then
						UberActions_Actions[i].maintype = "SPELL";
						startidx = string.find(txt," ");
						UberActions_Actions[i].health = tonumber(string.sub(txt,1,startidx-1));
					elseif (string.find(txt,"^[0-9]+ Rage")) then
						UberActions_Actions[i].maintype = "SPELL";
						startidx = string.find(txt," ");
						UberActions_Actions[i].rage = tonumber(string.sub(txt,1,startidx-1));
					elseif (string.find(txt,"^[0-9.]+ sec cast")) then
						UberActions_Actions[i].maintype = "SPELL";
					elseif (string.find(txt,"^Next melee")) then
						UberActions_Actions[i].subtype = "NEXTMELEE";
					elseif (string.find(txt,"^Instant cast")) then
						UberActions_Actions[i].subtype = "INSTANT";
					elseif (string.find(txt,"^Instant")) then
						UberActions_Actions[i].subtype = "INSTANT";
					elseif (string.find(txt,"^Channeled")) then
						UberActions_Actions[i].maintype = "SPELL";
						UberActions_Actions[i].subtype = "CHANNELED";
					end
				end
				txt = getglobal("UberActions_TooltipTextRight"..j):GetText();
				if (txt and txt ~= "") then
					if (string.find(txt,"^[0-9-]+ yd range")) then
						startidx = string.find(txt," ");
						txt = string.sub(txt,1,startidx-1);
						if (string.find(txt,"-")) then
							startidx = string.find(txt,"-");
							UberActions_Actions[i].minrange = tonumber(string.sub(txt,1,startidx-1));
							UberActions_Actions[i].maxrange = tonumber(string.sub(txt,startidx+1));
						else
							UberActions_Actions[i].minrange = 0;
							UberActions_Actions[i].maxrange = tonumber(txt);
						end
					end
				end
			end
			txt = UberActions_TooltipTextRight1:GetText();
			if (txt and txt ~= "") then
				if (txt == "Apprentice" or txt == "Journeyman" or 
					txt == "Expert" or txt == "Artisan") then
					UberActions_Actions[i].maintype = "SKILL";
				elseif (txt == "Racial") then
					UberActions_Actions[i].maintype = "RACIAL";
				elseif (string.find(txt,"^Rank")) then
					startidx,endidx = string.find(txt," ");
					UberActions_Actions[i].rank = tonumber(string.sub(txt,startidx+1));
				end
			end
		end
		if (UberActions_Actions[i].name) then 
			UberActions_RevMap[UberActions_Actions[i].name] = i;
		end
	end
end

local function UberActions_ItemSearch()
	local bag; 
	local slot; 
	local idx; 
	local itemName = nil; 
	local size; 
	local searchItemType = nil;
	local count = 0;
	local texture = 0;

	for searchItemType in UberActions_Reagents do
		UberActions_Reagents[searchItemType] = 0;
	end
	for bag = 0, 4, 1 do
		if (bag == 0) then
			size = 16;
		else
			size = GetContainerNumSlots(bag);
		end
		if (size and size > 0) then
			for slot = 1, size, 1 do
				itemType = nil; itemIdx = nil; itemName=nil;
				itemName = GetContainerItemLink(bag,slot);
				if (itemName) then
					local idx = string.find(itemName,"[[]");
					itemName = string.sub (itemName,idx+1);
					idx = string.find(itemName,"]");
					itemName = string.sub (itemName,1,idx-1);
				end
				if (itemName) then
					for searchItemType in UberActions_Reagents do
						if (itemName == searchItemType) then
							texture, count = GetContainerItemInfo(bag,slot);
							UberActions_Reagents[itemName] = UberActions_Reagents[itemName] + count;
						end
					end
				end
			end
		end
	end
	if (not UberActions_SearchedItems) then
	 	local i;
	 	for i = 1, 12, 1 do
	 		local button = getglobal ("ActionButton"..i);
			this = button; -- Oooh that's bad mojo. 
	 		ActionButton_UpdateCount();
		end
		UberActions_SearchedItems = 1;
	end
end

local function UberActions_PlaceSpell(spellId, actionButton)
	PickupSpell (spellId, BOOKTYPE_SPELL);
	PlaceAction(actionButton);
	if (CursorHasItem() or CursorHasSpell()) then
		PickupSpell(1,"spell"); -- Doing this twice is a safe way to clear cursor
		if (CursorHasItem() or CursorHasSpell()) then
			PickupSpell(1,"spell");
		end
	end
end

local function UberActions_SpellSearch()
	local spelllist = {};
	local id;
	local spellname;
	local subSpellName;
	local secondSpellName;
	local secondSubSpellName;
	for id = 1, 120, 1 do
		if (UberActions_Actions[id] and UberActions_Actions[id].name and UberActions_Actions[id].maintype and UberActions_Actions[id].maintype == "SPELL") then
			spelllist[UberActions_Actions[id].name] = id;
		end
	end
	id = 1;
	spellName, subSpellName = GetSpellName(id,BOOKTYPE_SPELL);
	while (spellName) do
		if (spellName) then
			secondSpellName, secondSubSpellName = GetSpellName(id+1,BOOKTYPE_SPELL);
			while (spellName == secondSpellName) do
				id = id + 1;
				secondSpellName, secondSubSpellName = GetSpellName(id+1,BOOKTYPE_SPELL);
			end
			spellName, subSpellName = GetSpellName(id,BOOKTYPE_SPELL);
			if (spelllist[spellName] and subSpellName and string.find(subSpellName,"Rank")) then
				local bookrank = tonumber(string.sub(subSpellName,6));
				if (bookrank > UberActions_Actions[spelllist[spellName]].rank) then
					DEFAULT_CHAT_FRAME:AddMessage("Uber Actions: Upgrading button #"..spelllist[spellName].." with higher rank spell.");
					UberActions_PlaceSpell(id, spelllist[spellName]);
				end
			end
		end
		id = id + 1;
		spellName, subSpellName = GetSpellName(id,BOOKTYPE_SPELL);
	end
end

local function UberActions_ConfigInit()
	if (not UberActions_Config) then 
		UberActions_Config = {};
	end
	if (not UberActions_Config[UberActions_Player]) then
		UberActions_Config[UberActions_Player] = {};
	end

	UberActions_ActionSearch();
	if (UberActions_Config[UberActions_Player].showreagents) then
		UberActions_HookGetActionCount();
		UberActions_ItemSearch();
	end
	if (UberActions_Config[UberActions_Player].updatespells) then
		UberActions_SpellSearch();
	end
	if (UberActions_Config[UberActions_Player].lockactionbar) then
		UberActions_HookPickupAction();
	end
	if (UberActions_Config[UberActions_Player].moveleftbar) then
		UberActions_MoveLeftBar();
	end
end

function UberActions_OnLoad()
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UNIT_INVENTORY_CHANGED");
	this:RegisterEvent("BAG_UPDATE");
	this:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
	this:RegisterEvent("ACTIONBAR_PAGE_CHANGED");
	this:RegisterEvent("SPELLS_CHANGED");

	DEFAULT_CHAT_FRAME:AddMessage("UberActions ("..UBERACTIONS_VERSION..") loaded.");

	UberActions_oldActionButton_UpdateHotkeys = ActionButton_UpdateHotkeys;
	ActionButton_UpdateHotkeys = UberActions_overrideActionButton_UpdateHotkeys;
end

function UberActions_OnEvent()
	if (event == "UNIT_NAME_UPDATE" and arg1 == "player") then
		local playerName = UnitName("player");
		if (playerName ~= UKNOWNBEING and playerName ~= "Unknown Entity") then
			UberActions_PlayerClass = UnitClass("player");
			UberActions_Player = playerName;
			if (UberActions_Player and UberActions_Config_Loaded) then
				UberActions_ConfigInit();
			end
		end
	elseif (event == "VARIABLES_LOADED") then
		UberActions_Config_Loaded = 1;
		if (UberActions_Player) then
			UberActions_ConfigInit();
		end
	elseif (event == "UNIT_INVENTORY_CHANGED" or event == "BAG_UPDATE") then
		if (UberActions_Player and UberActions_Config and UberActions_Config[UberActions_Player] and UberActions_Config[UberActions_Player].showreagents) then
			UberActions_ItemSearch();
		end
	elseif (event == "ACTIONBAR_SLOT_CHANGED" or event == "ACTIONBAR_PAGE_CHANGED") then
		if (UberActions_Player and UberActions_Config_Loaded) then
			UberActions_ActionSearch();
		end
		if (UberActions_ConfigFrame:IsVisible() and UberActions_ConfigFrame.selectedTab == 1) then
			UberActions_SetupIcons(UberActions_ButtonSet1,1);
			UberActions_SetupIcons(UberActions_ButtonSet2,2);
			UberActions_SetupIcons(UberActions_ButtonSet3,3);
		end
	elseif (event == "SPELLS_CHANGED") then
		if (UberActions_Player and UberActions_Config and UberActions_Config[UberActions_Player] and UberActions_Config[UberActions_Player].updatespells) then
			UberActions_SpellSearch();
		end
	end
end

function UberActions_Config_OnLoad()
	PanelTemplates_SetNumTabs(this, 2);
	this.selectedTab = 1;
	PanelTemplates_UpdateTabs(this);
end

function UberActions_ConfigEdit()
	if (UberActions_ConfigFrame:IsVisible()) then
		HideUIPanel(UberActions_ConfigFrame);
		if (UberActions_Config[UberActions_Player].showreagents) then
			UberActions_HookGetActionCount();
			UberActions_ItemSearch();
		end
		if (UberActions_Config[UberActions_Player].lockactionbar) then
			UberActions_HookPickupAction();
		end
	else
		UberActions_ConfigFrame_Title:SetText ("Uber Actions ("..UBERACTIONS_VERSION..")");
		ShowUIPanel(UberActions_ConfigFrame);
		UberActions_Tab_OnClick();
	end
end

function UberActions_Tab_OnClick(override)
	local oldTab = UberActions_ConfigFrame.selectedTab;
	local newTab;
	if (override) then
		newTab = override;
	else
		if (this and this:GetID()) then
			newTab = this:GetID();
			PanelTemplates_Tab_OnClick(UberActions_ConfigFrame);
		else
			newTab = oldTab;
		end
	end
	if (newTab ~= 1) then
		UberActions_Config_Tab1:Hide();
	end
	if (newTab ~= 2) then
		UberActions_Config_Tab2:Hide();
	end
	if (newTab == 1) then
		FauxScrollFrame_Update(UberActions_Config_Tab1_Scroll, 10, 3, UBERACTIONS_LINE_HEIGHT, nil, nil, nil);
		UberActions_Config_Tab1:Show();
		UberActions_Config_Tab1_ShowExtra:SetChecked(UberActions_ProgrammaticInfo);
		UberActions_SetupIcons(UberActions_ButtonSet1,1);
		UberActions_SetupIcons(UberActions_ButtonSet2,2);
		UberActions_SetupIcons(UberActions_ButtonSet3,3);
	elseif (newTab == 2) then
		UberActions_Config_Tab2_ShowReagents:SetChecked(UberActions_Config[UberActions_Player].showreagents);
		UberActions_Config_Tab2_UpdateSpells:SetChecked(UberActions_Config[UberActions_Player].updatespells);
		UberActions_Config_Tab2_LockActionBar:SetChecked(UberActions_Config[UberActions_Player].lockactionbar);
		UberActions_Config_Tab2_LockExceptShift:SetChecked(UberActions_Config[UberActions_Player].lockexceptshift);
		UberActions_Config_Tab2_LockExceptControl:SetChecked(UberActions_Config[UberActions_Player].lockexceptcontrol);
		UberActions_Config_Tab2_LockExceptAlt:SetChecked(UberActions_Config[UberActions_Player].lockexceptalt);
		if (UberActions_Config[UberActions_Player].lockactionbar) then
			UberActions_Config_Tab2_LockExceptShift:Enable();
			UberActions_Config_Tab2_LockExceptControl:Enable();
			UberActions_Config_Tab2_LockExceptAlt:Enable();
		else
			UberActions_Config_Tab2_LockExceptShift:Disable();
			UberActions_Config_Tab2_LockExceptControl:Disable();
			UberActions_Config_Tab2_LockExceptAlt:Disable();
		end
		if (UnitClass("player") == "Rogue" or UnitClass("player") == "Warrior") then
			UberActions_Config[UberActions_Player].updatespells = nil;
			UberActions_Config_Tab2_UpdateSpells:Disable();
			UberActions_Config_Tab2_UpdateSpellsText:SetText("Update Spells (Disabled for "..UnitClass("player")..")");
		end
		UberActions_Config_Tab2:Show();
	end
end

function UberActions_SetupIcons(frame, num)
	frame.offset = num;
	local bar = num + FauxScrollFrame_GetOffset(UberActions_Config_Tab1_Scroll);
	local actionnum = ((bar-1)*12)+1;
	local i;
	local button;
	if (bar > 0 and bar < 7) then
		if (bar == 3) then
			getglobal(frame:GetName().."_Title1"):SetText ("Blizzards Right Bar");
		elseif (bar == 4) then
			getglobal(frame:GetName().."_Title1"):SetText ("Blizzards Second Right Bar");
		elseif (bar == 5) then
			getglobal(frame:GetName().."_Title1"):SetText ("Blizzards Bottom Right Bar");
		elseif (bar == 6) then
			getglobal(frame:GetName().."_Title1"):SetText ("Blizzards Bottom Left Bar");
		else
			getglobal(frame:GetName().."_Title1"):SetText ("");
		end
		getglobal(frame:GetName().."_Title2"):SetText ("Standard Bar #"..bar);
	elseif (bar == 7) then
		getglobal(frame:GetName().."_Title1"):SetText ("Warrior Battle Stance,");
		getglobal(frame:GetName().."_Title2"):SetText ("Druid Cat Form, Rogue Stealth");
	elseif (bar == 8) then
		getglobal(frame:GetName().."_Title1"):SetText ("");
		getglobal(frame:GetName().."_Title2"):SetText ("Warrior Defensive Stance");
	elseif (bar == 9) then
		getglobal(frame:GetName().."_Title1"):SetText ("");
		getglobal(frame:GetName().."_Title2"):SetText ("Warrior Berserker Stance, Druid Bear Form");
	elseif (bar == 10) then
		getglobal(frame:GetName().."_Title1"):SetText ("");
		getglobal(frame:GetName().."_Title2"):SetText ("Unassigned");
	end
	for i = 1, 12, 1 do
		button = getglobal(frame:GetName().."_Button"..i);
		button.texture = GetActionTexture(actionnum);
		button.actionnum = actionnum;
		if (button.texture and button.texture ~= "") then
			getglobal(frame:GetName().."_Button"..i.."Icon"):SetTexture(button.texture);
			button.action = 1;
		else
			getglobal(frame:GetName().."_Button"..i.."Icon"):SetTexture("");
			button.action = nil;
		end
		getglobal(frame:GetName().."_Button"..i.."HotKey"):SetText(actionnum);
		actionnum = actionnum + 1;
	end
end

function UberActions_Button_SetTooltip()
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	if (this.action) then
		GameTooltip:SetAction(this.actionnum);
		this.updateTooltip = TOOLTIP_UPDATE_TIME;
		if (UberActions_ProgrammaticInfo) then
			UberActions_Tooltip:SetOwner(GameTooltip,"ANCHOR_BOTTOMRIGHT");
			UberActions_Tooltip:SetPoint("TOPLEFT","GameTooltip","TOPRIGHT",0,0);
			local txt = "NAME: "..UberActions_Actions[this.actionnum].name;
			if (UberActions_Actions[this.actionnum].maintype) then
				txt = txt.."\nTYPE: "..UberActions_Actions[this.actionnum].maintype;
				if (UberActions_Actions[this.actionnum].subtype) then
					txt = txt.."\nSUBTYPE: "..UberActions_Actions[this.actionnum].subtype;
				end
			end
			if (UberActions_Actions[this.actionnum].rank) then
				txt = txt.."\nRANK: "..UberActions_Actions[this.actionnum].rank;
			end
			if (UberActions_Actions[this.actionnum].mana) then
				txt = txt.."\nMANA: "..UberActions_Actions[this.actionnum].mana;
			end
			if (UberActions_Actions[this.actionnum].rage) then
				txt = txt.."\nRAGE: "..UberActions_Actions[this.actionnum].rage;
			end
			if (UberActions_Actions[this.actionnum].energy) then
				txt = txt.."\nENERGY: "..UberActions_Actions[this.actionnum].energy;
			end
			if (UberActions_Actions[this.actionnum].health) then
				txt = txt.."\nHEALTH: "..UberActions_Actions[this.actionnum].health;
			end
			if (UberActions_Actions[this.actionnum].reagent) then
				txt = txt.."\nREAGENT: "..UberActions_Actions[this.actionnum].reagent;
			end
			if (UberActions_Actions[this.actionnum].minrange) then
				txt = txt.."\nMINRANGE: "..UberActions_Actions[this.actionnum].minrange;
			end
			if (UberActions_Actions[this.actionnum].maxrange) then
				txt = txt.."\nMAXRANGE: "..UberActions_Actions[this.actionnum].maxrange;
			end
			UberActions_Tooltip:SetText(txt);
			UberActions_Tooltip:Show();
		end
	end
end

function UberActions_Scroll_Update()
	FauxScrollFrame_Update(UberActions_Config_Tab1_Scroll, 10, 3, UBERACTIONS_LINE_HEIGHT, nil, nil, nil);
	UberActions_SetupIcons(UberActions_ButtonSet1,1);
	UberActions_SetupIcons(UberActions_ButtonSet2,2);
	UberActions_SetupIcons(UberActions_ButtonSet3,3);
end

