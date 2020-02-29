--[[

See the ReadMe.html file for more information.

]]

-- Global variables to keep track of things.
bcAMS_LastRecipient = nil;
bcAMS_LastItemName = nil;

-- ******************************************************************
-- Override the SendMailFrame_Reset function to capture and reset the
-- last recipient sent to.

BCAMS_SAVE_SendMailFrame_Reset = SendMailFrame_Reset;
SendMailFrame_Reset = function()
	if (string.len(SendMailNameEditBox:GetText()) > 0) then
		bcAMS_LastRecipient = SendMailNameEditBox:GetText();
	end

	BCAMS_SAVE_SendMailFrame_Reset();

	if (bcAMS_LastRecipient ~= nil and string.len(bcAMS_LastRecipient) > 0) then
		SendMailNameEditBox:SetText(bcAMS_LastRecipient);
		SendMailNameEditBox:HighlightText();
	end
end

-- ******************************************************************
function bcWrite(msg)
	if (msg and DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage(msg);
	end
end

-- ******************************************************************
function bcAMS_OnLoad()
	-- Register for the needed events.
	this:RegisterEvent("MAIL_SEND_INFO_UPDATE");

	-- Let the user know the mod loaded.
	if ( DEFAULT_CHAT_FRAME ) then 
		bcWrite("BC Auto Mail Subject loaded");
	end
end

-- ******************************************************************
function bcAMS_OnEvent()
	if (event == "MAIL_SEND_INFO_UPDATE") then
		-- Get the info about the item in the attachement box.
		local itemName, itemTexture, stackCount, quality = GetSendMailItem();

		-- Get the current subject line of the message.
		local subject = SendMailSubjectEditBox:GetText();

		-- If there's an item attached...
		if (itemName) then
			-- Append the item count if there's more than one.
			if (stackCount > 1) then
				itemName = itemName.." x "..stackCount;
			end
			
			-- Check to see if the subject line is empty or if we've previously set it.
			if (string.len(subject) == 0 or subject == bcAMS_LastItemName) then
				-- Set the subject of the message to the item's name and count.
				SendMailSubjectEditBox:SetText(itemName);
				
				-- Save the item name for future comparisons.
				bcAMS_LastItemName = itemName;
			end
		else
			-- There's no item attached.  If there was, clear the subject line.
			if (subject == bcAMS_LastItemName) then
				SendMailSubjectEditBox:SetText("");
			end
		end
	end
end
