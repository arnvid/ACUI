BibResizerList = {};
BibResizerListSize = 0;

function UpdateBibResizers()
	local PlayerString = UnitName("player");
	if(ResizersDisabled[PlayerString]) then
		for i = 0, BibResizerListSize - 1 do
			BibResizerList[i]:Hide();
		end
	else
		for i = 0, BibResizerListSize - 1 do
			BibResizerList[i]:Show();
		end
	end	
end

function UpdateBibResizersToggle()
	local PlayerString = UnitName("player");
	if(ResizersDisabled and ResizersDisabled[PlayerString]) then
		this:SetNormalTexture("Interface\\AddOns\\BibWindowMods\\ResizersDisabled");
		this:SetPushedTexture("Interface\\AddOns\\BibWindowMods\\ResizersEnabled");
	else
		this:SetNormalTexture("Interface\\AddOns\\BibWindowMods\\ResizersEnabled");
		this:SetPushedTexture("Interface\\AddOns\\BibWindowMods\\ResizersDisabled");
	end
end

function UpdateBibBuffFrameVisibility()
	local PlayerString = UnitName("player");
	if(BibBuffFrameInvisible and BibBuffFrameInvisible[PlayerString]) then
		BuffFrameDragBar:Hide();
		BuffFrameBackground:Hide();
	else
		BuffFrameDragBar:Show();
		BuffFrameBackground:Show();
	end
end

function UpdateBibBuffFrameToggle()
	local PlayerString = UnitName("player");
	if(BibBuffFrameInvisible and BibBuffFrameInvisible[PlayerString]) then
		this:SetNormalTexture("Interface\\AddOns\\BibWindowMods\\BuffFrameInvisible");
		this:SetPushedTexture("Interface\\AddOns\\BibWindowMods\\BuffFrameVisible");
	else
		this:SetNormalTexture("Interface\\AddOns\\BibWindowMods\\BuffFrameVisible");
		this:SetPushedTexture("Interface\\AddOns\\BibWindowMods\\BuffFrameInvisible");
	end
end

function UpdateBibTooltipAnchorsVisibility()
	local PlayerString = UnitName("player");
	if(BibTooltipAnchorsInvisible and BibTooltipAnchorsInvisible[PlayerString]) then
		BibTooltipAnchorFrame:Hide();
	else
		BibTooltipAnchorFrame:Show();
	end
end

function UpdateBibTooltipAnchorsToggle()
	local PlayerString = UnitName("player");
	if(BibTooltipAnchorsInvisible and BibTooltipAnchorsInvisible[PlayerString]) then
		this:SetNormalTexture("Interface\\AddOns\\BibWindowMods\\TooltipAnchorsInvisible");
		this:SetPushedTexture("Interface\\AddOns\\BibWindowMods\\TooltipAnchorsVisible");
	else
		this:SetNormalTexture("Interface\\AddOns\\BibWindowMods\\TooltipAnchorsVisible");
		this:SetPushedTexture("Interface\\AddOns\\BibWindowMods\\TooltipAnchorsInvisible");
	end
end