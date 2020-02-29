
--[[
	Quick Cash

	By Juna

	Adds a little strip of a window which is a functioning cash display.

	Thanks to sarf for the Rogue Helper code which was very informative and useful.	
	Some utility type code is directly from RogueHelper (hope thats ok).
	Also thanks to Trentin for MonkeyQuest which I had a gander at.

	- V1.1
   ]]

-- VARIABLES

QuickCash_Visible = 1;
QuickCash_Alpha = 200;
QuickCash_BorderAlpha = 200;

function QuickCash_initialize()
	SlashCmdList["QUICKCASH"] = QuickCash_command;
	SLASH_QUICKCASH1 = "/quickcash";
	SLASH_QUICKCASH2 = "/qc";
	DEFAULT_CHAT_FRAME:AddMessage( "QuickCash Loaded!" );

end

function QuickCash_Extract_NextParameter(msg)
	local params = msg;
	local command = params;
	local index = strfind(command, " ");
	if ( index ) then
		command = strsub(command, 1, index-1);
		params = strsub(params, index+1);
	else
		params = "";
	end
	return command, params;
end

function QuickCash_command(msg)
-- this function handles our chat command

	if ( ( not msg) or ( strlen(msg) <= 0 ) ) then
		DEFAULT_CHAT_FRAME:AddMessage( "QuickCash commands: /quickcash or /qc" );
		DEFAULT_CHAT_FRAME:AddMessage( "/quickcash show, /quickcash hide, /qc alpha <number>, /qc borderalpha <number>" );
		return;
	end

	local command, params = QuickCash_Extract_NextParameter(msg);

	if (command == "hide") then
		QuickCashFrame:Hide();
		QuickCash_Visible = 0;
		return;
	end 

	if (command == "show") then
		QuickCashFrame:Show();
		QuickCash_Visible = 1;
		return;	
	end

	if (command == "refresh") then
		QuickCashFrame:Hide();
		QuickCashFrame:Show();
		return;	
	end

	if (command == "alpha") then
		if ( params ) then
			QuickCash_SetAlpha(params);
			QuickCash_Alpha = params;
			return;
		end
	end

	if (command == "borderalpha") then
		if ( params ) then
			QuickCash_SetBorderAlpha(params);
			QuickCash_BorderAlpha = params;
			return;
		end
	end

	DEFAULT_CHAT_FRAME:AddMessage( "QuickCash commands: /quickcash or /qc" );
	DEFAULT_CHAT_FRAME:AddMessage( "/quickcash show, /quickcash hide, /qc alpha <number>, /qc borderalpha <number>" );

end 


function QuickCash_Window_GetDragFrame()
	return QuickCashFrame;
end

function QuickCash_Window_OnDragStop()
	
	local dragFrame = QuickCash_Window_GetDragFrame();
	if ( dragFrame ) then
		dragFrame:StopMovingOrSizing();
		dragFrame.isMoving = false;
	end
end

function QuickCash_Window_OnDragStart()

	local dragFrame = QuickCash_Window_GetDragFrame();
	if ( dragFrame ) then
		dragFrame:StartMoving();
		dragFrame.isMoving = true;
	end
end

function QuickCash_Window_OnLoad()

	this:RegisterForDrag("LeftButton");
	this:RegisterForClicks("RightButtonUp");
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	QuickCashFrame:Show();

	QuickCash_Visible = 1;
	QuickCash_SetAlpha(200);
	QuickCash_SetBorderAlpha(200);
	RegisterForSave("QuickCash_Visible");
	RegisterForSave("QuickCash_Alpha");
	RegisterForSave("QuickCash_BorderAlpha");
	
end

function QuickCash_WindowMoney_OnLoad()


end

function QuickCash_WindowMoney_initialize()
	MoneyFrame_SetType("PLAYER");
	MoneyFrame_UpdateMoney();		

end

function QuickCash_Window_OnEvent(event)
	if (event == "VARIABLES_LOADED") then
		QuickCash_SetAlpha(QuickCash_Alpha);
		QuickCash_SetBorderAlpha(QuickCash_BorderAlpha);

		if (QuickCash_Visible == 1) then
			QuickCashFrame:Show();
		else
			QuickCashFrame:Hide();
		end
	end
	if (event == "PLAYER_ENTERING_WORLD") then
		if (QuickCash_Visible == 1) then
			QuickCashFrame:Hide();
			QuickCashFrame:Show();
		end

	end

end

-- Set the opacity of the background
function QuickCash_SetAlpha(alpha)
	QuickCashFrame:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, alpha);
end

-- Set the opacity of the border
function QuickCash_SetBorderAlpha(alpha)
	QuickCashFrame:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b, alpha);
end
