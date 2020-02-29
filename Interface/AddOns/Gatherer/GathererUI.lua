--[[
	 
	GUI for Gatherer (by Jet, original idea and most of the base UI code comes from bcui_TrackingMenu)
	Version: 2.0-p5
	Revision: $Id: GathererUI.lua,v 1.3 2005/05/04 17:22:34 islorgris Exp $
	
	* Add a button around the minimap (movable)
	* Quick toggle menu for display on minimap, mainmap, herbs, ore and treasure
	* Configuration Options available when clicking on quickmenu title
	 
	Following features are coupled with changes in the Gatherer.lua file:
	* Specific item selection for gather ressource
	* Possibility to consider rare ore/herb when selecting a specific ressource (ie. selecting tin shows silver too)
	* Ability not to display icon at all when under the minimum icon distance display.
	* multiple items can be selected in ressource filter dropdown menus
	* minimum gather skill selection for items display
 
	Special functions (Zone swapping depends on the correct GatherRegionData table being in Gatherer.lua):
	* Set original zone mapping (ie. FR pre 1.3.0, FR 1.3.1).
	* Set destination zone mapping (FR 1.3.1)
	* Force data conversion between set orginal zone mapping and destination zone mapping (with confirm dialog)
	* Fix item names while swapping zones (depends on correction items mapping in localization.lua, FR & DE only)
	
	Note: conversion to Universal zone mapping should disable map minder feature
	
	To Do:
	* find a way to reduce font size in dropdown menu
	* extend the GathererUI_FixItemName function to allow a conversion utility
	* add sort function for zone selection dropdown menus
	 
	Known Problems: 
	* Quickmenu settings shown the herbs/ore/treasure filters may be incorrect when logging in (to confirm)
	
]]

-- Counter for fixed item count
fixedItemCount = 0;
gathererFixItems = 0;

-- Number of buttons for the menu defined in the XML file.
GathererUI_NUM_BUTTONS = 5;

-- Constants used in determining menu width/height.
GathererUI_BORDER_WIDTH = 15;
GathererUI_BUTTON_HEIGHT = 12;

-- List of toggles to display.
GathererUI_QuickMenu = {
	{name=GATHERER_TEXT_TOGGLE_MINIMAP, option="useMinimap"},
	{name=GATHERER_TEXT_TOGGLE_MAINMAP, option="useMainmap"},
	{name=GATHERER_TEXT_TOGGLE_HERBS, option="herbs"},
	{name=GATHERER_TEXT_TOGGLE_MINERALS, option="mining"},
	{name=GATHERER_TEXT_TOGGLE_TREASURE, option="treasure"},
};


-- ******************************************************************
function GathererUI_OnLoad()
	-- Register for the neccessary events.
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	
	-- Create the slash commands to show/hide the menu.
	SlashCmdList["GathererUI_SHOWMENU"] = GathererUI_ShowMenu;
	SLASH_GathererUI_SHOWMENU1 = "/GathererUI_showmenu";
	SlashCmdList["GathererUI_HIDEMENU"] = GathererUI_HideMenu;
	SLASH_GathererUI_HIDEMENU1 = "/GathererUI_hidemenu";
	
	-- Create the slash commands to show/hide the options window.
	SlashCmdList["GathererUI_SHOWOPTIONS"] = GathererUI_ShowOptions;
	SLASH_GathererUI_SHOWOPTIONS1 = "/GathererUI_showoptions";
	SlashCmdList["GathererUI_HIDEOPTIONS"] = GathererUI_HideOptions;
	SLASH_GathererUI_HIDEOPTIONS1 = "/GathererUI_hideoptions";

end

-- ******************************************************************
function GathererUI_ShowMenu(x, y, anchor)
	if (GathererUI_Popup:IsVisible()) then
		GathererUI_Hide();
		return;
	end

	if (x == nil or y == nil) then
		-- Get the cursor position.  Point is relative to the bottom left corner of the screen.
		x, y = GetCursorPosition();
	end

	if (anchor == nil) then
		anchor = "center";
	end
	
	-- Adjust for the UI scale.
	x = x / UIParent:GetScale();
	y = y / UIParent:GetScale();

	-- Adjust for the height/width/anchor of the menu.
	if (anchor == "topright") then
		x = x - GathererUI_Popup:GetWidth();
		y = y - GathererUI_Popup:GetHeight();
	elseif (anchor == "topleft") then
		y = y - GathererUI_Popup:GetHeight();
	elseif (anchor == "bottomright") then
		x = x - GathererUI_Popup:GetWidth();
	elseif (anchor == "bottomleft") then
		-- do nothing.
	else
		-- anchor is either "center" or not a valid value.
		x = x - GathererUI_Popup:GetWidth() / 2;
		y = y - GathererUI_Popup:GetHeight() / 2;
	end

	-- Clear the current anchor point, and set it to be centered under the mouse.
	GathererUI_Popup:ClearAllPoints();
	GathererUI_Popup:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", x, y);
	GathererUI_Show();
end

-- ******************************************************************
function GathererUI_HideMenu()
	GathererUI_Hide();
end

-- ******************************************************************
function GathererUI_OnEvent()
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		local playerName = UnitName("player");
		if ((playerName) and (playerName ~= UNKNOWNOBJECT)) then Gather_Player = playerName; end;
		GathererUI_InitializeOptions();
		Gatherer_GetSkills();
		GathererUI_InitializeMenu();
		return;
	end
	if ( event == "UNIT_NAME_UPDATE" ) then
		if ((arg1) and (arg1 == "player")) then
			local playerName = UnitName("player");
			if ((playerName) and (playerName ~= UNKNOWNOBJECT)) then
				Gather_Player = playerName;
				Gatherer_GetSkills();
				GathererUI_InitializeMenu();
			end
		end
	end
end

-- ******************************************************************
function GathererUI_InitializeOptions()

	-- flag to determine if we show the menu when the mouse is over the icon.
	if (GatherConfig.ShowOnMouse == nil) then
		GatherConfig.ShowOnMouse = 1;
	end
	
	-- flag to determine if we show the menu when the icon is clicked.
	if (GatherConfig.ShowOnClick == nil) then
		GatherConfig.ShowOnClick = 0;
	end
	
	-- flag to determine if we show the menu when the bound key is pressed.
	if (GatherConfig.ShowOnButton == nil) then
		GatherConfig.ShowOnButton = 0;
	end
	
	-- flag to determine if we hide the menu when the mouse is not over the icon.
	if (GatherConfig.HideOnMouse == nil) then
		GatherConfig.HideOnMouse = 1;
	end
	
	-- flag to determine if we hide the menu when the icon is clicked.
	if (GatherConfig.HideOnClick == nil) then
		GatherConfig.HideOnClick = 0;
	end
	
	-- flag to determine if we hide the menu when the bound key is pressed.
	if (GatherConfig.HideOnButton == nil) then
		GatherConfig.HideOnButton = 0;
	end
	
	-- position of the icon around the border of the minimap.
	if (GatherConfig.Position == nil) then
		GatherConfig.Position = 12;
	end

	if (GatherConfig.rareOre == nil) then
		GatherConfig.rareOre = 0;
	end

	if (GatherConfig.noIconOnMinDist == nil) then
		GatherConfig.noIconOnMinDist = 0;
	end
	
	-- UI related
	GathererUI_CheckShowOnMouse:SetChecked(GatherConfig.ShowOnMouse);
	GathererUI_CheckHideOnMouse:SetChecked(GatherConfig.HideOnMouse);
	GathererUI_CheckShowOnClick:SetChecked(GatherConfig.ShowOnClick);
	GathererUI_CheckHideOnClick:SetChecked(GatherConfig.HideOnClick);
	GathererUI_CheckHideOnButton:SetChecked(GatherConfig.HideOnButton);
	GathererUI_IconFrame:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52 - (80 * cos(GatherConfig.Position)), (80 * sin(GatherConfig.Position)) - 52);
	
	-- Gatherer related
	GathererUI_CheckNoMinIcon:SetChecked(GatherConfig.noIconOnMinDist);
	GathererUI_CheckRareOre:SetChecked(GatherConfig.rareOre);
	GathererUI_CheckMapMinder:SetChecked(GatherConfig.mapMinder);

end

-- ******************************************************************
function GathererUI_InitializeMenu()

	GathererUI_IconFrame.haveAbilities = true;

	GathererUI_IconFrame:Show();

	-- Set the text for the buttons while keeping track of how many
	-- buttons we actually need.
	local count = 0;
	for quickoptionpos, quickoptiondata in GathererUI_QuickMenu do
		quickoptions = quickoptiondata.name;
		gathermap_id = quickoptiondata.option;
		count = count + 1;
		local button = getglobal("GathererUI_PopupButton"..count);
		Gatherer_Value="rien";
		if ( gathermap_id =="useMinimap" ) then
			Gatherer_Value = "off";
			if (GatherConfig.useMinimap) then Gatherer_Value = "on"; end
			button.SpellID = "toggle"
		elseif (  gathermap_id == "useMainmap" ) then
			Gatherer_Value = "off";
			if (GatherConfig.useMainmap) then Gatherer_Value = "on"; end
			button.SpellID = "mainmap toggle";
		else
			Gatherer_Value = Gatherer_GetFilterVal(gathermap_id);
			button.SpellID = gathermap_id.." toggle";

		end

		button:SetText(quickoptions.."["..Gatherer_Value.."]");
		button:Show();
	end
	
	-- Set the width for the menu.
	local width = GathererUI_TitleButton:GetWidth();
	for i = 1, count, 1 do
		local button = getglobal("GathererUI_PopupButton"..i);
		local w = button:GetTextWidth();
		if (w > width) then
			width = w;
		end
	end
	GathererUI_Popup:SetWidth(width + 2 * GathererUI_BORDER_WIDTH);

	-- By default, the width of the button is set to the width of the text
	-- on the button.  Set the width of each button to the width of the
	-- menu so that you can still click on it without being directly
	-- over the text.
	for i = 1, count, 1 do
		local button = getglobal("GathererUI_PopupButton"..i);
		button:SetWidth(width);
	end

	-- Hide the buttons we don't need.
	for i = count + 1, GathererUI_NUM_BUTTONS, 1 do
		local button = getglobal("GathererUI_PopupButton"..i);
		button:Hide();
	end
	
	-- Set the height for the menu.
	GathererUI_Popup:SetHeight(GathererUI_BUTTON_HEIGHT + ((count + 1) * GathererUI_BUTTON_HEIGHT) + (3 * GathererUI_BUTTON_HEIGHT));
end

-- ******************************************************************
function GathererUI_ButtonClick()

	Gatherer_Command(this.SpellID);
	GathererUI_InitializeMenu();	
	
end

-- ******************************************************************
function GathererUI_Show()
	-- Check to see if the aspect menu is shown.  If so, hide it before
	-- showing the tracking menu.
	if (GathererUI_Popup) then
		if (GathererUI_Popup:IsVisible()) then
			GathererUI_Hide();
		end
	end

	GathererUI_Popup:Show();
end

-- ******************************************************************
function GathererUI_Hide()
	GathererUI_Popup:Hide();
end

-- ******************************************************************
function GathererUI_ShowOptions()
	GathererUI_Options:Show();
end

-- ******************************************************************
function GathererUI_HideOptions()
	GathererUI_Options:Hide();
end

-- ******************************************************************
function GathererUI_OnUpdate(dummy)
	-- Check to see if the mouse is still over the menu or the icon.
	
	if (GatherConfig.HideOnMouse == 1 and GathererUI_Popup:IsVisible()) then
		if (not MouseIsOver(GathererUI_Popup) and not MouseIsOver(GathererUI_IconFrame)) then
			-- If not, hide the menu.
			GathererUI_Hide();
		end
	end

end

-- ******************************************************************
function GathererUI_IconFrameOnEnter()
	-- Set the anchor point of the menu so it shows up next to the icon.
	GathererUI_Popup:ClearAllPoints();
	GathererUI_Popup:SetPoint("TOPRIGHT", "GathererUI_IconFrame", "TOPLEFT");

	-- Set the anchor and text for the tooltip.
	--GameTooltip:SetOwner(GathererUI_IconFrame, "ANCHOR_BOTTOMRIGHT");
	--GameTooltip:SetText(GATHERER_TEXT_TOOLTIP);

	-- Show the menu.
	if (GatherConfig.ShowOnMouse == 1) then
		GathererUI_Show();
	end
end

-- ******************************************************************
function GathererUI_IconFrameOnClick()
	if (GathererUI_Popup:IsVisible()) then
		if (GatherConfig.HideOnClick == 1) then
			GathererUI_Hide();
		end
	else
		if (GatherConfig.ShowOnClick == 1) then
			GathererUI_Show();
		end
	end

end

-- ******************************************************************

function GathererUIDropDownTheme_Initialize()
	local index, value;
	info = {};
	local gathererThemeList = { "shaded", "iconic", "original" }
	
	for index, value in gathererThemeList do
		info.text = value;
		info.checked = nil;
		info.func = GathererUIDropDownTheme_OnClick;
		UIDropDownMenu_AddButton(info);
		if (GatherConfig.iconSet == info.text) then
			UIDropDownMenu_SetText(info.text, GathererUI_DropDownTheme);
		end
	end
end

function GathererUIDropDownHerbs_Initialize()
	local index, value;
	info = {};

	local varMenuVal1, varMenuVal2;
	value = Gatherer_GetFilterVal("herbs");
	if ( value == "on" ) then
		varMenuVal1 = "auto";
		varMenuVal2 = "off";
	elseif ( value == "off" ) then
		varMenuVal1 = "auto";
		varMenuVal2 = "on";
	else
		varMenuVal1 = "on";
		varMenuVal2 = "off";
	end
	UIDropDownMenu_SetText(value, GathererUI_DropDownHerbs);


	local gathererFilters = { 
				  varMenuVal1, varMenuVal2,  
				  HERB_PEACEBLOOM, HERB_SILVERLEAF, HERB_EARTHROOT, HERB_SWIFTTHISTLE, HERB_MAGEROYAL, HERB_BRIARTHORN, 
				  HERB_STRANGLEKELP, HERB_BRUISEWEED, HERB_WILDSTEELBLOOM, HERB_GRAVEMOSS, HERB_KINGSBLOOD, 
				  HERB_LIFEROOT, HERB_FADELEAF, HERB_KHADGARSWHISKER, HERB_FIREBLOOM, HERB_GOLDTHORN, 
				  HERB_WILDVINE, HERB_PURPLELOTUS, HERB_BLINDWEED, HERB_SUNGRASS, HERB_GHOSTMUSHROOM, HERB_GOLDENSANSAM, 
				  HERB_GROMSBLOOD, HERB_WINTERSBITE, HERB_ARTHASTEAR, HERB_BLACKLOTUS, HERB_DREAMFOIL, 
				  HERB_ICECAP, HERB_MOUNTAINSILVERSAGE, HERB_PLAGUEBLOOM, 
				};

	for index, value in gathererFilters do
		info.text = value;
		info.value = value;
		info.checked = nil;
		info.func = GathererUIDropDownFilterHerbs_OnClick;

		if ( index > 2 and GatherConfig ) then
			info.keepShownOnClick = 1;
			if ( GatherConfig.users[Gather_Player] and
				GatherConfig.users[Gather_Player].interested and
				GatherConfig.users[Gather_Player].interested["Herb"] and
				GatherConfig.users[Gather_Player].interested["Herb"][value] == true ) then
				info.checked = 1;
			end
			info.textR = 1;
			info.textG = 1;
			info.textB = 1;
		else
			info.textR = 1;
			info.textG = 1;
			info.textB = 255;
			info.checked = nil;
		end

		UIDropDownMenu_AddButton(info);
	end
end

function GathererUIDropDownOre_Initialize()
	local index, value;
	info = {};

	local varMenuVal1, varMenuVal2;
	value = Gatherer_GetFilterVal("mining");
	if ( value == "on" ) then
		varMenuVal1 = "auto";
		varMenuVal2 = "off";
	elseif ( value == "off" ) then
		varMenuVal1 = "auto";
		varMenuVal2 = "on";
	else
		varMenuVal1 = "on";
		varMenuVal2 = "off";
	end
	UIDropDownMenu_SetText(value, GathererUI_DropDownOre);

	local gathererFilters = { 
				  varMenuVal1, varMenuVal2,  
				  ORE_COPPER, 
				  ORE_TIN, ORE_SILVER, 
				  ORE_IRON, ORE_GOLD, 
				  ORE_MITHRIL, ORE_TRUESILVER, 
				  ORE_THORIUM,
				}

	for index, value in gathererFilters do
		info.text = value;
		info.value = value;
		info.checked = nil;
		info.func = GathererUIDropDownFilterOre_OnClick;

		if ( index > 2 and GatherConfig ) then
			info.keepShownOnClick = 1;
			if ( GatherConfig.users[Gather_Player] and
				GatherConfig.users[Gather_Player].interested and
				GatherConfig.users[Gather_Player].interested["Ore"] and
				GatherConfig.users[Gather_Player].interested["Ore"][value] == true ) then
				info.checked = 1;
			end
			info.textR = 1;
			info.textG = 1;
			info.textB = 1;
		else
			info.textR = 1;
			info.textG = 1;
			info.textB = 255;
			info.checked = nil;
		end

		UIDropDownMenu_AddButton(info);
	end
end

function GathererUIDropDownTreasure_Initialize()
	local index, value;
	info = {};

	local varMenuVal1, varMenuVal2;
	value = Gatherer_GetFilterVal("treasure");
	if ( value == "on" ) then
		varMenuVal1 = "auto";
		varMenuVal2 = "off";
	elseif ( value == "off" ) then
		varMenuVal1 = "auto";
		varMenuVal2 = "on";
	else
		varMenuVal1 = "on";
		varMenuVal2 = "off";
	end
	UIDropDownMenu_SetText(value, GathererUI_DropDownTreasure);


	local gathererFilters = { 
				  varMenuVal1, varMenuVal2,  
				  TREASURE_BOX, TREASURE_CHEST, TREASURE_CRATE, 
				  TREASURE_BARREL, TREASURE_CASK,
				  TREASURE_CLAM,
				}

	for index, value in gathererFilters do
		info.text = value;
		info.checked = nil;
		info.func = GathererUIDropDownFilterTreasure_OnClick;

		if ( index > 2 and GatherConfig ) then
			info.keepShownOnClick = 1;
			if ( GatherConfig.users[Gather_Player] and
				GatherConfig.users[Gather_Player].interested and
				GatherConfig.users[Gather_Player].interested["Treasure"] and
				GatherConfig.users[Gather_Player].interested["Treasure"][value] == true ) then
				info.checked = 1;
			end
			info.textR = 1;
			info.textG = 1;
			info.textB = 1;
		else
			info.textR = 1;
			info.textG = 1;
			info.textB = 255;
			info.checked = nil;
		end

		UIDropDownMenu_AddButton(info);
	end	
end

-- ******************************************************************

function GathererUIDropDownTheme_OnClick()
	local cmd;

	UIDropDownMenu_SetSelectedID(GathererUI_DropDownTheme, this:GetID());
	cmd = UIDropDownMenu_GetText(GathererUI_DropDownTheme);
	
	Gatherer_Command("theme "..cmd);
end

function GathererUIDropDownFilterHerbs_OnClick()

	if ( this:GetID() < 3 ) then
		cmd = UIDropDownMenu_SetText(this.value, GathererUI_DropDownHerbs);

		Gatherer_Command("herbs "..this.value);
		GathererUI_InitializeMenu();	
	else
		if ( not GatherConfig.users[Gather_Player].interested ) then
			GatherConfig.users[Gather_Player].interested = {}; 
		end
		if ( not GatherConfig.users[Gather_Player].interested["Herb"] ) then
			GatherConfig.users[Gather_Player].interested["Herb"] = {};
		end

		if ( this.checked ) then
			GatherConfig.users[Gather_Player].interested["Herb"][this.value] = nil;
		else
			GatherConfig.users[Gather_Player].interested["Herb"][this.value] = true;
		end
	end
end

function GathererUIDropDownFilterOre_OnClick()

	if ( this:GetID() < 3 ) then
		UIDropDownMenu_SetText(this.value, GathererUI_DropDownOre);

		Gatherer_Command("mining "..this.value);
		GathererUI_InitializeMenu();
	else
		if ( not GatherConfig.users[Gather_Player].interested ) then 
			GatherConfig.users[Gather_Player].interested = {}; 
		end
		if ( not GatherConfig.users[Gather_Player].interested["Ore"] ) then
			GatherConfig.users[Gather_Player].interested["Ore"] = {};
		end
		

		if ( this.checked ) then
			GatherConfig.users[Gather_Player].interested["Ore"][this.value] = nil;
		else
			GatherConfig.users[Gather_Player].interested["Ore"][this.value] = true;
		end		
	end
end

function GathererUIDropDownFilterTreasure_OnClick()

	if ( this:GetID() < 3 ) then
		UIDropDownMenu_SetText(this.value, GathererUI_DropDownTreasure);

		Gatherer_Command("treasure "..this.value);
		GathererUI_InitializeMenu();	
	else
		if ( not GatherConfig.users[Gather_Player].interested ) then 
			GatherConfig.users[Gather_Player].interested = {}; 
		end
		if ( not GatherConfig.users[Gather_Player].interested["Treasure"] ) then
			GatherConfig.users[Gather_Player].interested["Treasure"] = {};
		end


		if ( this.checked ) then
			GatherConfig.users[Gather_Player].interested["Treasure"][this.value] = nil;
		else
			GatherConfig.users[Gather_Player].interested["Treasure"][this.value] = true;
		end		
	end
end

function GathererUI_OnEnterPressed_HerbSkillEditBox()
	if ( GathererUI_HerbSkillEditBox:GetNumber() > 300 ) then
		GathererUI_HerbSkillEditBox:SetNumber(300);
	end
	if ( GathererUI_HerbSkillEditBox:GetNumber() < 0 ) then
		GathererUI_HerbSkillEditBox:SetNumber(0);
	end
	
	GatherConfig.users[Gather_Player].minSetHerbSkill = GathererUI_HerbSkillEditBox:GetNumber();
end

function GathererUI_OnEnterPressed_OreSkillEditBox()
	if ( GathererUI_OreSkillEditBox:GetNumber() > 300 ) then
		GathererUI_OreSkillEditBox:SetNumber(300);
	end
	if ( GathererUI_OreSkillEditBox:GetNumber() < 0 ) then
		GathererUI_OreSkillEditBox:SetNumber(0);
	end
	GatherConfig.users[Gather_Player].minSetOreSkill = GathererUI_OreSkillEditBox:GetNumber();
end
-- *******************************************************************
-- Zone Rematch Section: Handle with care


function GathererUI_ZoneRematch(sourceZoneMapping, destZoneMapping)
	local zone_swap=0;
	local new_idx_z;
	NewGatherItems = {}
	fixedItemCount = 0;

	Gatherer_ChatPrint(GATHERER_TEXT_APPLY_REMATCH.." "..sourceZoneMapping.." -> "..destZoneMapping);

	for idx_c, rec_continent in GatherItems do
		if (idx_c ~= 0) then NewGatherItems[idx_c]= {}; end
		for idx_z, rec_zone in rec_continent do
			if ( idx_c ~= 0 and idx_z ~= 0) then
				new_idx_z= GathererUI_ZoneMatchTable[sourceZoneMapping][destZoneMapping][idx_c][idx_z];
				if ( idx_z ~= new_idx_z ) then zone_swap = zone_swap + 1; end;

				NewGatherItems[idx_c][new_idx_z] = {};
				for myItems, rec_gatheritem in rec_zone do
					local fixedItemName;
					if (gathererFixItems == 1) then 
						fixedItemName = GathererUI_FixItemName(myItems); 
					else
						fixedItemName= myItems;
					end
					NewGatherItems[idx_c][new_idx_z][fixedItemName] = {};
					for idx_item, myGather in rec_gatheritem do
						NewGatherItems[idx_c][new_idx_z][fixedItemName][idx_item] = {};
						NewGatherItems[idx_c][new_idx_z][fixedItemName][idx_item].x = myGather.x;
						NewGatherItems[idx_c][new_idx_z][fixedItemName][idx_item].y = myGather.y;
						NewGatherItems[idx_c][new_idx_z][fixedItemName][idx_item].gtype = myGather.gtype;
						if (gathererFixItems == 1) then 
							NewGatherItems[idx_c][new_idx_z][fixedItemName][idx_item].icon = GathererUI_FixItemName(myGather.icon);
						else
							NewGatherItems[idx_c][new_idx_z][fixedItemName][idx_item].icon = myGather.icon;
						end
						NewGatherItems[idx_c][new_idx_z][fixedItemName][idx_item].count = myGather.count;
					end
				end
			end
		end
	end
	Gatherer_ChatPrint("Zone swapping completed ("..zone_swap.." done, "..fixedItemCount.." items fixed).")
end

function GathererUI_FixItemName(itemName)
	local newItemName = itemName;
	
	if ( GetLocale() == "frFR" ) then
	-- add name correction
		newItemName = string.gsub(itemName , "’", '\'');
		newItemName = string.gsub(itemName , "vrai argent", ORE_TRUESILVER);
		newItemName = string.gsub(itemName , "argent v\195\169ritable", ORE_TRUESILVER);
		if ( itemName ~= newItemName ) then
			fixedItemCount = fixedItemCount + 1;
		end
	end
	if ( GetLocale() == "deDE" ) then
		newItemName = string.gsub(itemName , "dreamfoil", HERB_DREAMFOIL);
		if ( itemName ~= newItemName ) then
			fixedItemCount = fixedItemCount + 1;
		end
	end

	return newItemName;
end

-- *******************************************************************
-- Zone Match UI functions
function GathererUI_ShowRematchDialog()
	if ( GathererUI_ZoneRematchDialog:IsVisible() ) then
		GathererUI_ZoneRematchDialog:Hide()
		GathererUI_DestinationZoneDropDown:Hide();
	else
		GathererUI_ZoneRematchDialog:Show()
	end

end

-- *******************************************************************
-- DropDown Menu functions
function GathererUIDropDownSourceZone_Initialize()
	local index;
	info = {};

	for index in GathererUI_ZoneMatchTable do
		info.text = index;
		info.checked = nil;
		info.func = GathererUIDropDownFilterSourceZone_OnClick;
		UIDropDownMenu_AddButton(info);
		if ( GatherConfig.DataBuild and GatherConfig.DataBuild == info.text ) then
			UIDropDownMenu_SetText(info.text, GathererUI_SourceZoneDropDown);
		end
	end	

end

function GathererUIDropDownDestionationZone_Initialize()
	local index, cmd;
	info = {};

	cmd = UIDropDownMenu_GetText(GathererUI_SourceZoneDropDown);
	if ( cmd ~= nil and cmd ~= "" ) then
		for index in GathererUI_ZoneMatchTable[cmd] do
			info.text = index;
			info.checked = nil;
			info.func = GathererUIDropDownFilterDestinationZone_OnClick;
			UIDropDownMenu_AddButton(info);
		end
	end
end

-- *******************************************************************
-- OnClick in DropDown Menu functions
function GathererUIDropDownFilterSourceZone_OnClick()
	UIDropDownMenu_SetSelectedID(GathererUI_SourceZoneDropDown, this:GetID());

	GathererUI_DestinationZoneDropDown:Show();
end

function GathererUIDropDownFilterDestinationZone_OnClick()
	UIDropDownMenu_SetSelectedID(GathererUI_DestinationZoneDropDown, this:GetID());
end

-- *******************************************************************
-- Apply Button
function GathererUI_ShowRematchDialogApply()
	local source, dest;
	source = UIDropDownMenu_GetText(GathererUI_SourceZoneDropDown);
	dest = UIDropDownMenu_GetText(GathererUI_DestinationZoneDropDown);

	if( source and dest ) then
		-- hide Option dialog (since the position of the confirmation dialog can cause miss-click on stuff in there)
		GathererUI_HideOptions()
		-- add extra confirmation dialog
		StaticPopup_Show("CONFIRM_REMATCH");

		
	elseif ( not source ) then
		Gatherer_ChatPrint(GATHERER_TEXT_SRCZONE_MISSING);
	else
		Gatherer_ChatPrint(GATHERER_TEXT_DESTZONE_MISSING);
	end
end


StaticPopupDialogs["CONFIRM_REMATCH"] = {
	text = TEXT(GATHERER_TEXT_CONFIRM_REMATCH),
	button1 = TEXT(ACCEPT),
	button2 = TEXT(DECLINE),
	OnAccept = function()
		ConfirmZoneRematch();
	end,
	timeout = 60,
	showAlert = 1,
};

function ConfirmZoneRematch()
	local source, dest;
	source = UIDropDownMenu_GetText(GathererUI_SourceZoneDropDown);
	dest = UIDropDownMenu_GetText(GathererUI_DestinationZoneDropDown);

		-- Swap tables and Recompute notes
		GathererUI_ZoneRematch(source, dest);
		GatherItems = NewGatherItems;
		RecalcNotes();
		GatherConfig.DataBuild = dest;

		GathererUI_ShowRematchDialog();

end

