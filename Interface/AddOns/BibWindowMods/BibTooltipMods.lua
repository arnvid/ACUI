function UpdateBibTooltipAnchors()
	local PlayerString = UnitName("player");
	if(lastSelectedAnchor) then
		lastSelectedAnchor:SetNormalTexture("Interface\\AddOns\\BibWindowMods\\TooltipAnchor");
	end	
	local selectedAnchor = getglobal("BibTooltipAnchor"..BibTooltipAnchor[PlayerString]);
	selectedAnchor:SetNormalTexture("Interface\\AddOns\\BibWindowMods\\ActiveTooltipAnchor");
	lastSelectedAnchor = selectedAnchor;
end


function GameTooltip_SetDefaultAnchor(tooltip, parent)
	local PlayerString = UnitName("player");
	tooltip:SetOwner(parent, "ANCHOR_NONE");
	tooltip:SetPoint(BibTooltipAnchor[PlayerString], "BibTooltipAnchor"..BibTooltipAnchor[PlayerString]);	
end