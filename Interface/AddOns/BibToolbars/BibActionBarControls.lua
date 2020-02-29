function UpdateBibGreenButtons()
	local PlayerString = UnitName("player");
	if(GreenButtonsDisabled and GreenButtonsDisabled[PlayerString]) then
		for i = 1, BIB_ACTION_BAR_COUNT do
			getglobal("BibActionBar"..i.."DragButton"):Hide();
		end
		BibShapeshiftActionBarDragButton:Hide();
		BibPetActionBarDragButton:Hide();
		BibMicroBarDragButton:Hide();
		BibMenuDragButton:Hide();
		BibBagButtonsBarDragButton:Hide();
	else
		for i = 1, BIB_ACTION_BAR_COUNT do
			getglobal("BibActionBar"..i.."DragButton"):Show();
		end
		BibShapeshiftActionBarDragButton:Show();
		BibPetActionBarDragButton:Show();
		BibMicroBarDragButton:Show();
		BibMenuDragButton:Show();
		BibBagButtonsBarDragButton:Show();
	end
end

function UpdateBibGreenButtonsToggle()
	local PlayerString = UnitName("player");
	if(GreenButtonsDisabled and GreenButtonsDisabled[PlayerString]) then
		this:SetNormalTexture("Interface\\AddOns\\BibToolbars\\BibGreenButtonsDisabled");
		this:SetPushedTexture("Interface\\AddOns\\BibToolbars\\BibGreenButtonsEnabled");
	else
		this:SetNormalTexture("Interface\\AddOns\\BibToolbars\\BibGreenButtonsEnabled");
		this:SetPushedTexture("Interface\\AddOns\\BibToolbars\\BibGreenButtonsDisabled");
	end
end

function UpdateBibButtonsLockToggle()
	local PlayerString = UnitName("player");
	if(BibActionBarButtonsLocked and BibActionBarButtonsLocked[PlayerString]) then
		this:SetNormalTexture("Interface\\AddOns\\BibToolbars\\BibLocked");
		this:SetPushedTexture("Interface\\AddOns\\BibToolbars\\BibUnlocked");
	else
		this:SetNormalTexture("Interface\\AddOns\\BibToolbars\\BibUnlocked");
		this:SetPushedTexture("Interface\\AddOns\\BibToolbars\\BibLocked");
	end
end

function UpdateBibButtonsGridModeToggle()
	local PlayerString = UnitName("player");
	if(BibButtonsGridMode[PlayerString] == BIB_BUTTON_GRID_SHOW) then
		this:SetNormalTexture("Interface\\AddOns\\BibToolbars\\BibShowGrid");
		this:SetPushedTexture("Interface\\AddOns\\BibToolbars\\BibHideGrid");
	elseif(BibButtonsGridMode[PlayerString] == BIB_BUTTON_GRID_HIDE_AND_CASCADE) then
		this:SetNormalTexture("Interface\\AddOns\\BibToolbars\\BibHideGrid");
		this:SetPushedTexture("Interface\\AddOns\\BibToolbars\\BibHideGridNoCascade");
	else
		this:SetNormalTexture("Interface\\AddOns\\BibToolbars\\BibHideGridNoCascade");
		this:SetPushedTexture("Interface\\AddOns\\BibToolbars\\BibShowGrid");
	end
end

function UpdateBibXPBarVisibility()
	local PlayerString = UnitName("player");
	if(BibXPBarInvisible and BibXPBarInvisible[PlayerString]) then
		BibmodXPFrame:Hide();
	else
		BibmodXPFrame:Show();
	end
end

function UpdateBibXPBarToggle()
	local PlayerString = UnitName("player");
	if(BibXPBarInvisible and BibXPBarInvisible[PlayerString]) then
		this:SetNormalTexture("Interface\\AddOns\\BibToolbars\\BibHideXPBar");
		this:SetPushedTexture("Interface\\AddOns\\BibToolbars\\BibShowXPBar");
	else
		this:SetNormalTexture("Interface\\AddOns\\BibToolbars\\BibShowXPBar");
		this:SetPushedTexture("Interface\\AddOns\\BibToolbars\\BibHideXPBar");
	end
end

function UpdateBibBagBarVisibility()
	local PlayerString = UnitName("player");
	if(BibBagBarInvisible and BibBagBarInvisible[PlayerString]) then
		BibBagButtonsBar:Hide();
	else
		BibBagButtonsBar:Show();
	end
end

function UpdateBibBagBarToggle()
	local PlayerString = UnitName("player");
	if(BibBagBarInvisible and BibBagBarInvisible[PlayerString]) then
		this:SetNormalTexture("Interface\\AddOns\\BibToolbars\\BibBagBarInvisible");
		this:SetPushedTexture("Interface\\AddOns\\BibToolbars\\BibBagBarVisible");
	else
		this:SetNormalTexture("Interface\\AddOns\\BibToolbars\\BibBagBarVisible");
		this:SetPushedTexture("Interface\\AddOns\\BibToolbars\\BibBagBarInvisible");
	end
end

function UpdateBibMicroBarVisibility()
	local PlayerString = UnitName("player");
	if(BibMicroBarInvisible and BibMicroBarInvisible[PlayerString]) then
		MainMenuBarArtFrame:Hide();
	else
		MainMenuBarArtFrame:Show();
	end
end

function UpdateBibMicroBarToggle()
	local PlayerString = UnitName("player");
	if(BibMicroBarInvisible and BibMicroBarInvisible[PlayerString]) then
		this:SetNormalTexture("Interface\\AddOns\\BibToolbars\\BibMicroBarInvisible");
		this:SetPushedTexture("Interface\\AddOns\\BibToolbars\\BibMicroBarVisible");
	else
		this:SetNormalTexture("Interface\\AddOns\\BibToolbars\\BibMicroBarVisible");
		this:SetPushedTexture("Interface\\AddOns\\BibToolbars\\BibMicroBarInvisible");
	end
end
