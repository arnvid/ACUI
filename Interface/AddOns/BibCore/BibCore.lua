
function EventIsPlayerNameLoaded(event)
	if (event == "UNIT_NAME_UPDATE") then
		if(this.got_unit_name_update or UnitName("player") == "Unknown Entity") then
			return false;
		end
		this.got_unit_name_update = true;
		return true;
	end
	return false;
end

function AddBibControlButton(button)
	if(BibMenu.button_offset == nil) then
		BibMenu.button_offset = 0;
	end
	button:SetWidth(32);
	button:SetHeight(32);
	button:SetPoint("TOPLEFT", "BibMenuBar", "TOPLEFT", BibMenu.button_offset, 0);
	BibMenu.button_offset = BibMenu.button_offset + 32;
	BibMenu:SetWidth(BibMenu.button_offset+16);
end

function UpdateBibMenuFoldState()
	local PlayerString = UnitName("player");
	if(BibMenuFolded[PlayerString]) then
		BibMenuBar:Hide();
		BibMenu:SetWidth(16);
		BibMenuToggle:SetNormalTexture("Interface\\AddOns\\BibCore\\UnfoldBibMenu");
	else
		BibMenuBar:Show();
		BibMenu:SetWidth(BibMenu.button_offset+16);
		BibMenuToggle:SetNormalTexture("Interface\\AddOns\\BibCore\\FoldBibMenu");
	end
end