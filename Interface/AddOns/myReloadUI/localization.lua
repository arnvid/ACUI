--[[
	myReloadUI v1.1
]]


--------------------------------------------------------------------------------------------------
-- Localized messages and options
--------------------------------------------------------------------------------------------------

MYRELOADUI_DESCRIPTION = "A ReloadUI button added to the Main Menu";
MYRELOADUI_LOADED = "myReloadUI AddOn loaded";

-- Check the client language
if (GetLocale() == "frFR") then
	MYRELOADUI_DESCRIPTION = "Un bouton ReloadUI ajouté au Menu Principal";
	MYRELOADUI_LOADED = "AddOn myReloadUI chargé";
elseif (GetLocale() == "deDE") then
	MYRELOADUI_DESCRIPTION = "Ein zum Optionsmenu hinzugefügter ReloadUI Knopf";
	MYRELOADUI_LOADED = "myReloadUI AddOn geladen";
end
