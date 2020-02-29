--[[
	myAddOns v1.2
]]


--------------------------------------------------------------------------------------------------
-- Global variables
--------------------------------------------------------------------------------------------------

MYADDONS_NAME = "myAddOns";
MYADDONS_VERSION = "1.2";
MYADDONS_SELECTED_ADDON_INDEX = 0;
MYADDONS_ACTIVE_OPTIONSFRAME = nil;
myAddOnsList = {};
RegisterForSave("myAddOnsList");
myAddOnsSortedList = {};
myAddOnsCategories = {};
myAddOnsCategories[MYADDONS_CATEGORY_BARS] = {expanded = 1, addonsCount = 0};
myAddOnsCategories[MYADDONS_CATEGORY_CHAT] = {expanded = 1, addonsCount = 0};
myAddOnsCategories[MYADDONS_CATEGORY_CLASS] = {expanded = 1, addonsCount = 0};
myAddOnsCategories[MYADDONS_CATEGORY_COMBAT] = {expanded = 1, addonsCount = 0};
myAddOnsCategories[MYADDONS_CATEGORY_COMPILATIONS] = {expanded = 1, addonsCount = 0};
myAddOnsCategories[MYADDONS_CATEGORY_GUILD] = {expanded = 1, addonsCount = 0};
myAddOnsCategories[MYADDONS_CATEGORY_INVENTORY] = {expanded = 1, addonsCount = 0};
myAddOnsCategories[MYADDONS_CATEGORY_MAP] = {expanded = 1, addonsCount = 0};
myAddOnsCategories[MYADDONS_CATEGORY_OTHERS] = {expanded = 1, addonsCount = 0};
myAddOnsCategories[MYADDONS_CATEGORY_PROFESSIONS] = {expanded = 1, addonsCount = 0};
myAddOnsCategories[MYADDONS_CATEGORY_QUESTS] = {expanded = 1, addonsCount = 0};
myAddOnsCategories[MYADDONS_CATEGORY_RAID] = {expanded = 1, addonsCount = 0};


--------------------------------------------------------------------------------------------------
-- Overriden functions
--------------------------------------------------------------------------------------------------

-- Override the standard ShowUIPanel: myAddOnsFrame has to be handled the same way as the other game menu frames
function ShowUIPanel(frame, force)	

	if ( not frame or frame:IsVisible() ) then
		return;
	end

	if ( not CanOpenPanels() and (frame ~= GameMenuFrame and frame ~= UIOptionsFrame and frame ~= SoundOptionsFrame and frame ~= OptionsFrame and frame ~= KeyBindingFrame and frame ~= HelpFrame and frame ~= SuggestFrame and frame ~= myAddOnsFrame) and not myAddOnsFrame_IsOptionsFrame(frame) ) then
		return;
	end

	local info = UIPanelWindows[frame:GetName()];
	if ( not info ) then
		frame:Show();
		return;
	end

	if ( UnitIsDead("player") and (info.area ~= "center") and (info.area ~= "full") and (frame ~= SuggestFrame) ) then
		NotWhileDeadError();
		return;
	end

	-- If we have a full-screen frame open, ignore other non-fullscreen open requests
	if ( GetFullScreenFrame() and (info.area ~= "full") ) then
		if ( force ) then
			SetFullScreenFrame(nil);
		else
			return;
		end
	end

	-- If we have a "center" frame open, only listen to other "center" open requests
	local centerFrame = GetCenterFrame();
	local centerInfo = nil;
	if ( centerFrame ) then
		centerInfo = UIPanelWindows[centerFrame:GetName()];
		if ( centerInfo and (centerInfo.area == "center")  and (info.area ~= "center") ) then
			if ( force ) then
				SetCenterFrame(nil);
			else
				return;
			end
		end
	end

	-- Full-screen frames just replace each other
	if ( info.area == "full" ) then
		CloseAllWindows();
		SetFullScreenFrame(frame);
		return;
	end

	-- Native "center" frames just replace each other, and they take priority over pushed frames
	if ( info.area == "center" ) then
		CloseWindows();
		CloseAllBags();
		SetCenterFrame(frame, 1);
		return;
	end

	-- Doublewide frames take up the left and center spots
	if ( info.area == "doublewide" ) then
		SetDoublewideFrame(frame);
		return;
	end

	-- Close any doublewide frames
	local doublewideFrame = GetDoublewideFrame();
	if ( doublewideFrame ) then
		doublewideFrame:Hide();
	end

	-- Try to put it on the left
	local leftFrame = GetLeftFrame();
	if ( not leftFrame ) then
		SetLeftFrame(frame);
		return;
	end

	-- If there's only one open...
	leftInfo = UIPanelWindows[leftFrame:GetName()];
	if ( not centerFrame ) then
		-- If neither is pushable, replace
		if ( (leftInfo.pushable == 0) and (info.pushable == 0) ) then
			SetLeftFrame(frame);
			return;
		end

		-- Highest priority goes to center
		if ( leftInfo.pushable > info.pushable ) then
			MovePanelToCenter();
			SetLeftFrame(frame);
		else
			SetCenterFrame(frame);
		end
		return;
	end

	-- Center is already taken too...
	if ( info.pushable > centerInfo.pushable ) then
		-- This one is highest priority, so move the center frame back to the left
		MovePanelToLeft();
		SetCenterFrame(frame);
	else
		SetLeftFrame(frame);
	end

end


--------------------------------------------------------------------------------------------------
-- Event functions
--------------------------------------------------------------------------------------------------

-- OnLoad event
function myAddOnsFrame_OnLoad()

	-- Register the events that need to be watched
	this:RegisterEvent("VARIABLES_LOADED");
	
	-- Add myAddOnsFrame to the UIPanelWindows list
	UIPanelWindows[this:GetName()] = {area = "center", pushable = 0};
	
	-- Display a message in the ChatFrame indicating a successful load of this addon
	DEFAULT_CHAT_FRAME:AddMessage(MYADDONS_LOADED, 1.0, 1.0, 0.0);
	
	-- Display a popup message indicating a successful load of this addon
	UIErrorsFrame:AddMessage(MYADDONS_LOADED, 1.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);

end

-- OnEvent event
function myAddOnsFrame_OnEvent()

	if (event == "VARIABLES_LOADED") then
		-- Add myAddOns to myAddOns addons list
		myAddOnsList.myAddOns = {name = MYADDONS_NAME, description = MYADDONS_DESCRIPTION, version = MYADDONS_VERSION, category = MYADDONS_CATEGORY_OTHERS, frame = this:GetName()};
	end

end

-- OnClick event
function myAddOnsFrame_OnClick()

	-- Get the ID of the button that was clicked
	local selectedLine = this:GetID();
	local sortedIndex = myAddOnsFrame_GetSortedIndex(selectedLine + FauxScrollFrame_GetOffset(myAddOnsFrameScrollFrame));
	
	-- Check if a category or an addon was clicked
	if (sortedIndex ~= 0) then
		local item = myAddOnsSortedList[sortedIndex];
		if (myAddOnsList[item]) then
			MYADDONS_SELECTED_ADDON_INDEX = sortedIndex;
		else
			if (myAddOnsCategories[item].expanded) then
				myAddOnsCategories[item].expanded = nil;
			else
				myAddOnsCategories[item].expanded = 1;
			end
		end
		-- Update the display
		myAddOnsFrame_Update();
	end

end

-- OnShow event
function myAddOnsFrame_OnShow()

	MYADDONS_ACTIVE_OPTIONSFRAME = nil;
	
	-- Check if the sorted list is already created
	if (table.getn(myAddOnsSortedList) == 0) then
		myAddOnsFrame_UpdateSortedList();
	end
	
	-- Update the display
	myAddOnsFrame_Update();

end

-- OnHide event
function myAddOnsFrame_OnHide()

	-- Check if it's currently showing an options frame
	if (not MYADDONS_ACTIVE_OPTIONSFRAME) then
		ShowUIPanel(GameMenuFrame);
	end

end


--------------------------------------------------------------------------------------------------
-- Update functions
--------------------------------------------------------------------------------------------------

-- Update the sorted list
function myAddOnsFrame_UpdateSortedList()

	-- Move the unknow categories into the Others category
	for addon in myAddOnsList do
		if (myAddOnsList[addon].category ~= MYADDONS_CATEGORY_BARS and myAddOnsList[addon].category ~= MYADDONS_CATEGORY_CHAT and myAddOnsList[addon].category ~= MYADDONS_CATEGORY_CLASS
		and myAddOnsList[addon].category ~= MYADDONS_CATEGORY_COMBAT and myAddOnsList[addon].category ~= MYADDONS_CATEGORY_COMPILATIONS and myAddOnsList[addon].category ~= MYADDONS_CATEGORY_GUILD
		and myAddOnsList[addon].category ~= MYADDONS_CATEGORY_INVENTORY and myAddOnsList[addon].category ~= MYADDONS_CATEGORY_MAP and myAddOnsList[addon].category ~= MYADDONS_CATEGORY_OTHERS
		and myAddOnsList[addon].category ~= MYADDONS_CATEGORY_PROFESSIONS and myAddOnsList[addon].category ~= MYADDONS_CATEGORY_QUESTS and myAddOnsList[addon].category ~= MYADDONS_CATEGORY_RAID) then
			myAddOnsList[addon].category = MYADDONS_CATEGORY_OTHERS;
		end
	end
	
	-- Create a temporary sorted categories list
	local categoryIndex = 0;
	local tempCategories = {};
	
	-- Browse the categories list
	for category in myAddOnsCategories do
		categoryIndex = categoryIndex + 1;
		tempCategories[categoryIndex] = category;
	end
	
	-- Sort the temporary categories list
	table.sort(tempCategories);
	
	-- Create/Empty the sorted list
	local sortedIndex = 0;
	myAddOnsSortedList = {};
	
	-- Browse the categories list
	for categoryIndex in tempCategories do
		-- Create a temporary addons table for the current category
		local addonIndex = 0;
		local tempAddOns = {};
		myAddOnsCategories[tempCategories[categoryIndex]].addonsCount = 0;
		-- Browse the addons list
		for addon in myAddOnsList do
			if (myAddOnsList[addon].category == tempCategories[categoryIndex]) then
				addonIndex = addonIndex + 1;
				tempAddOns[addonIndex] = addon;
			end
		end
		-- Check if there is any addon for the current category
		if (table.getn(tempAddOns) > 0) then
			-- Sort the temporary addons list
			table.sort(tempAddOns);
			-- Add the category header
			sortedIndex = sortedIndex + 1;
			myAddOnsSortedList[sortedIndex] = tempCategories[categoryIndex];
			-- Browse the temporary addons list
			for addonIndex in tempAddOns do
				sortedIndex = sortedIndex + 1;
				myAddOnsCategories[tempCategories[categoryIndex]].addonsCount = myAddOnsCategories[tempCategories[categoryIndex]].addonsCount + 1;
				myAddOnsSortedList[sortedIndex] = tempAddOns[addonIndex];
			end
		end
	end

end

-- Place/Remove the highlight
function myAddOnsFrame_UpdateHighlight()

	-- Check if an addon is selected and if it's visible
	if (MYADDONS_SELECTED_ADDON_INDEX ~= 0 and myAddOnsCategories[myAddOnsList[myAddOnsSortedList[MYADDONS_SELECTED_ADDON_INDEX]].category].expanded) then
		local selectedLine = myAddOnsFrame_GetSelectedLine();
		-- Check if the selected addon is currently displayed
		if (selectedLine > 0 and selectedLine <= 24) then
			getglobal("myAddOnsFrameButton"..selectedLine.."Name"):SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
			getglobal("myAddOnsFrameButton"..selectedLine.."Version"):SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
			myAddOnsFrameHighlightFrame:SetPoint("LEFT", "myAddOnsFrameButton"..selectedLine, "LEFT", -6, -1);
			myAddOnsFrameHighlightFrame:Show();
		else
			myAddOnsFrameHighlightFrame:Hide();
		end
	else
		myAddOnsFrameHighlightFrame:Hide();
	end

end

-- Update the description field
function myAddOnsFrame_UpdateDescription()

	-- Check if an addon is selected
	if (MYADDONS_SELECTED_ADDON_INDEX ~= 0) then
		local description = myAddOnsList[myAddOnsSortedList[MYADDONS_SELECTED_ADDON_INDEX]].description;
		if (description and string.len(description) > 46) then
			myAddOnsFrameDescriptionText:SetText(string.sub(description,1,43).."...");
		else
			myAddOnsFrameDescriptionText:SetText(description);
		end
	else
		myAddOnsFrameDescriptionText:SetText("");
	end

end

-- Enable/Disable the buttons
function myAddOnsFrame_UpdateButtons()

	-- Check if an addon is selected
	if (MYADDONS_SELECTED_ADDON_INDEX ~= 0) then
		myAddOnsFrameRemoveButton:Enable();
		-- Check if the addon has an options window
		if (getglobal(myAddOnsList[myAddOnsSortedList[MYADDONS_SELECTED_ADDON_INDEX]].optionsframe)) then
			myAddOnsFrameOptionsButton:Enable();
		else
			myAddOnsFrameOptionsButton:Disable();
		end
	else
		myAddOnsFrameRemoveButton:Disable();
		myAddOnsFrameOptionsButton:Disable();
	end

end

-- Update the display
function myAddOnsFrame_Update()

	-- Get the number of visible items
	local numVisibleItems = myAddOnsFrame_GetNumVisibleItems();

	-- Browse the lines
	for line = 1, 24, 1 do
		local sortedIndex = myAddOnsFrame_GetSortedIndex(line + FauxScrollFrame_GetOffset(myAddOnsFrameScrollFrame));
		-- Check if there is an item to display on the line
		if (sortedIndex ~= 0) then
			local item = myAddOnsSortedList[sortedIndex];
			local color, name;
			-- Check if the item is an addon
			if (myAddOnsList[item]) then
				if (getglobal(myAddOnsList[item].frame)) then
					color = NORMAL_FONT_COLOR;
					name = "  "..myAddOnsList[item].name;
				else
					color = GRAY_FONT_COLOR;
					name = "  "..myAddOnsList[item].name.." - Not loaded";
				end
				-- Set the addon's name
				getglobal("myAddOnsFrameButton"..line.."Name"):SetTextColor(color.r, color.g, color.b);
				getglobal("myAddOnsFrameButton"..line.."Name"):SetText(name);
				-- Set the addon's version
				getglobal("myAddOnsFrameButton"..line.."Version"):SetTextColor(color.r, color.g, color.b);
				getglobal("myAddOnsFrameButton"..line.."Version"):SetText(myAddOnsList[item].version);
				-- Hide the toggle button
				getglobal("myAddOnsFrameButton"..line):SetNormalTexture("");
				getglobal("myAddOnsFrameButton"..line.."Highlight"):SetTexture("");
			else
				color = HIGHLIGHT_FONT_COLOR;
				-- Set the category name
				getglobal("myAddOnsFrameButton"..line.."Name"):SetTextColor(color.r, color.g, color.b);
				getglobal("myAddOnsFrameButton"..line.."Name"):SetText(item);
				-- Empty the version
				getglobal("myAddOnsFrameButton"..line.."Version"):SetText("");
				-- Show the toggle button
				if (myAddOnsCategories[item].expanded) then
					getglobal("myAddOnsFrameButton"..line):SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up");
				else
					getglobal("myAddOnsFrameButton"..line):SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up");
				end
				getglobal("myAddOnsFrameButton"..line.."Highlight"):SetTexture("Interface\\Buttons\\UI-PlusButton-Hilight");
			end
			-- Save the line's color
			getglobal("myAddOnsFrameButton"..line).r = color.r;
			getglobal("myAddOnsFrameButton"..line).g = color.g;
			getglobal("myAddOnsFrameButton"..line).b = color.b;
			getglobal("myAddOnsFrameButton"..line):Show();
		else
			getglobal("myAddOnsFrameButton"..line):Hide();
		end
	end
	
	-- Place/Remove the highlight
	myAddOnsFrame_UpdateHighlight();
	
	-- Update the description field
	myAddOnsFrame_UpdateDescription();
	
	-- Enable/Disable the buttons
	myAddOnsFrame_UpdateButtons();
	
	-- Scroll frame stuff
	FauxScrollFrame_Update(myAddOnsFrameScrollFrame, numVisibleItems, 24, 16);

end


--------------------------------------------------------------------------------------------------
-- Other functions
--------------------------------------------------------------------------------------------------

-- Check if frame is an options frame for myAddOns list
function myAddOnsFrame_IsOptionsFrame(frame)

	-- Browse the options frames in the addons List
	for addon in myAddOnsList do
		if (getglobal(myAddOnsList[addon].optionsframe) == frame) then
			return true;
		end
	end
	
	return false;

end

-- Get the number of visible items in the sorted list
function myAddOnsFrame_GetNumVisibleItems()

	local numVisibleItems = 0;

	-- Browse the sorted list
	for sortedIndex in myAddOnsSortedList do
		-- Check if the current index is a category
		if (myAddOnsCategories[myAddOnsSortedList[sortedIndex]]) then
			-- Check if the category header is visible
			if (myAddOnsCategories[myAddOnsSortedList[sortedIndex]].addonsCount > 0) then
				numVisibleItems = numVisibleItems + 1;
			end
			-- Check if the category header is expanded
			if (myAddOnsCategories[myAddOnsSortedList[sortedIndex]].expanded) then
				numVisibleItems = numVisibleItems + myAddOnsCategories[myAddOnsSortedList[sortedIndex]].addonsCount;
			end
		end
	end
	
	return numVisibleItems;

end

-- Get the index in the sorted list of the selected line
function myAddOnsFrame_GetSortedIndex(selectedLine)

	local line = 0;
	
	-- Browse the sorted list
	for sortedIndex in myAddOnsSortedList do
		-- Check if the current index is a category
		if (myAddOnsCategories[myAddOnsSortedList[sortedIndex]]) then
			-- Check if the category header is visible
			if (myAddOnsCategories[myAddOnsSortedList[sortedIndex]].addonsCount > 0) then
				line = line + 1;
			end
		end
		-- Check if the current index is an addon
		if (myAddOnsList[myAddOnsSortedList[sortedIndex]]) then
			-- Check if the addon is visible
			if (myAddOnsCategories[myAddOnsList[myAddOnsSortedList[sortedIndex]].category].expanded) then
				line = line + 1;
			end
		end
		-- Check if it has reached the selected line
		if (line == selectedLine) then
			return sortedIndex;
		end
	end
	
	return 0;

end

-- Get the line of the selected addon
function myAddOnsFrame_GetSelectedLine()

	local selectedLine = -FauxScrollFrame_GetOffset(myAddOnsFrameScrollFrame);
	
	for sortedIndex = 1, MYADDONS_SELECTED_ADDON_INDEX, 1 do
		-- Check if the current index is a category
		if (myAddOnsCategories[myAddOnsSortedList[sortedIndex]]) then
			-- Check if the category header is visible
			if (myAddOnsCategories[myAddOnsSortedList[sortedIndex]].addonsCount > 0) then
				selectedLine = selectedLine + 1;
			end
		end
		-- Check if the current index is an addon
		if (myAddOnsList[myAddOnsSortedList[sortedIndex]]) then
			-- Check if the addon is visible
			if (myAddOnsCategories[myAddOnsList[myAddOnsSortedList[sortedIndex]].category].expanded) then
				selectedLine = selectedLine + 1;
			end
		end
	end
	
	return selectedLine;

end

-- Remove selected addon from the list
function myAddOnsFrame_Remove()

	-- Remove the selected addon from the addons list and from the sorted list
	myAddOnsList[myAddOnsSortedList[MYADDONS_SELECTED_ADDON_INDEX]] = nil;
	myAddOnsFrame_UpdateSortedList();
	
	-- Empty the selection
	MYADDONS_SELECTED_ADDON_INDEX = 0;
	
	-- Update the display
	myAddOnsFrame_Update();

end

-- Show selected addon's options frame
function myAddOnsFrame_ShowOptions()

	-- Save the options frame name to remember that it was opened via myAddOnsFrame
	MYADDONS_ACTIVE_OPTIONSFRAME = getglobal(myAddOnsList[myAddOnsSortedList[MYADDONS_SELECTED_ADDON_INDEX]].optionsframe);
	
	-- Show the options frame
	ShowUIPanel(getglobal(myAddOnsList[myAddOnsSortedList[MYADDONS_SELECTED_ADDON_INDEX]].optionsframe), true);

end
