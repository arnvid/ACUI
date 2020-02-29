--[[
	myReloadUI v1.1
]]


--------------------------------------------------------------------------------------------------
-- Global variables
--------------------------------------------------------------------------------------------------

MYRELOADUI_NAME = "myReloadUI";
MYRELOADUI_VERSION = "1.1";


--------------------------------------------------------------------------------------------------
-- Event functions
--------------------------------------------------------------------------------------------------

-- OnLoad event
function myGameMenuButtonReloadUI_OnLoad()

	-- Register the events that need to be watched
	this:RegisterEvent("VARIABLES_LOADED");
	
	-- Display a message in the ChatFrame indicating a successful load of this addon
	DEFAULT_CHAT_FRAME:AddMessage(MYRELOADUI_LOADED, 1.0, 1.0, 0.0);
	
	-- Display a popup message indicating a successful load of this addon
	UIErrorsFrame:AddMessage(MYRELOADUI_LOADED, 1.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);

end

-- OnEvent event
function myGameMenuButtonReloadUI_OnEvent()

	if (event == "VARIABLES_LOADED") then
		-- Add myReloadUI to myAddOns addons list
		if (myAddOnsFrame) then
			myAddOnsList.myReloadUI = {name = MYRELOADUI_NAME, description = MYRELOADUI_DESCRIPTION, version = MYRELOADUI_VERSION, category = MYADDONS_CATEGORY_OTHERS, frame = this:GetName()};
		end
	end

end
