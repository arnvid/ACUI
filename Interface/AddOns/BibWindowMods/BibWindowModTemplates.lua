BIB_MIN_SCALE = .4;
BIB_MAX_SCALE = 2.5;

function ScaleFrame(frame, absXanchor, absYanchor, scale)
	local oldscale = frame:GetScale();
	local absLeft = frame:GetLeft() * oldscale;
	local absTop = frame:GetTop() * oldscale;
	local absHorDistance = absLeft - absXanchor;
	local absVerDistance = absYanchor - absTop;

	frame:SetScale(scale);
	frame:ClearAllPoints();
	frame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", (absXanchor / scale) + (absHorDistance / oldscale), (absYanchor / scale) - (absVerDistance / oldscale));
end


CloseOnEscUIPanels = {CharacterFrame, SpellBookFrame, TalentFrame, QuestLogFrame, FriendsFrame,
                      MailFrame, OpenMailFrame, TradeSkillFrame, MerchantFrame, ClassTrainerFrame,
                      GossipFrame, MacroFrame, AuctionFrame, BankFrame, LootFrame, TaxiFrame,
                      QuestFrame, ItemTextFrame, WorldMapFrame};

function ShowUIPanel(panel)	
	if(panel ~= nil) then
		if (panel:GetName() == "GameMenuFrame") then
			for key, val in CloseOnEscUIPanels do
				if (val ~= nil and val:IsVisible()) then
					val:Hide();
				end
			end
		end
		panel:Show();
	end
end

function HideUIPanel(panel)
	if(panel ~= nil) then
		if (panel:GetName() == "GameMenuFrame" and UIOptionsFrame:IsVisible()) then
			UIOptionsFrame:Hide();
			return;
		end
		panel:Hide();
	end
end
