--
-- Error Redirect
--
-- by Bastian Pflieger <wb@illogical.de>
--
-- Credits: Idea by Bunny, compiling default filter lists
--
-- Last update: 22.02.05
--
-- supports "myAddOns": http://www.curse-gaming.com/mod.php?addid=358
--


function ErrorRedirect_OnLoad()
  ErrorRedirect_IsEnabled = true;
  ErrorRedirect_ShowInCombatLog = true;
  ErrorRedirect_HighlightMessages = true;
  ErrorRedirect_SuppressModErrors = false;

  ErrorRedirect_Org_AddMessage = UIErrorsFrame.AddMessage;
  UIErrorsFrame.AddMessage = ErrorRedirect_AddMessage;

  ErrorRedirect_Org_Message = ScriptErrors.Show;
  ScriptErrors.Show = ErrorRedirect_Message;

  SlashCmdList["ERROR_REDIRECT"] = function(msg)
    ShowUIPanel(ErrorRedirectOptionsFrame);
  end
  SLASH_ERROR_REDIRECT1 = "/config_redirect";

  this:RegisterEvent("VARIABLES_LOADED");
end


function ErrorRedirect_Message(objData)
  if ErrorRedirect_SuppressModErrors and string.find(ScriptErrors_Message:GetText(), "]:[0-9]+:") then
    ChatFrame2:AddMessage(ScriptErrors_Message:GetText(), 1.0, 0.0, 0.0);
  else
    ErrorRedirect_Org_Message(objData);
  end
end


function ErrorRedirect_GetIndividualColors(msg, r, g, b)
  if ErrorRedirect_HighlightMessages and ErrorRedirect_Filter_FixedColorMessages[msg] then
    ChatFrame1:AddMessage("Color Match: " .. msg);
    r = ErrorRedirect_Colors[ErrorRedirect_Filter_FixedColorMessages[msg]].r;
    g = ErrorRedirect_Colors[ErrorRedirect_Filter_FixedColorMessages[msg]].g;
    b = ErrorRedirect_Colors[ErrorRedirect_Filter_FixedColorMessages[msg]].b;
  end
  return r, g, b;
end

function ErrorRedirect_AddColoredMessage(msg, r, g, b, frame)
  if ErrorRedirect_ShowInCombatLog then
    r, g, b = ErrorRedirect_GetIndividualColors(msg, r, g, b);
    frame:AddMessage(msg, r, g, b, 1.0);
  end
end

function ErrorRedirect_MatchesFixedString(msg)
  return ErrorRedirect_Filter_FixedErrorMessages[msg];
end

function ErrorRedirect_MatchesPartialString(msg)
  local bMatch = false;
  local filter = ErrorRedirect_Filter_PartialErrorMessages;
  local i, filterLength = 1, table.getn(filter)

  while not bMatch and i <= filterLength do
    bMatch = filter[i] ~= "" and string.find(msg, filter[i]);
    i = i + 1;
  end

  return bMatch;
end

function ErrorRedirect_AddMessage(objData, msg, r, g, b, a, holdTime)
  if ErrorRedirect_IsEnabled and ErrorRedirect_MatchesFixedString(msg) then
    ErrorRedirect_AddColoredMessage(msg, r, g, b, ErrorRedirect_Filter_FixedErrorMessages["REDIRECT_TO_FRAME"]);
  elseif ErrorRedirect_IsEnabled and ErrorRedirect_MatchesPartialString(msg) then
    ErrorRedirect_AddColoredMessage(msg, r, g, b, ErrorRedirect_Filter_PartialErrorMessages["REDIRECT_TO_FRAME"]);
  else
    r, g, b = ErrorRedirect_GetIndividualColors(msg, r, g, b);
    ErrorRedirect_Org_AddMessage(objData, msg, r, g, b, a, holdTime);
  end
end

function ErrorRedirect_OnEvent(event)
  ErrorRedirect_RegisterMyAddons();
end

function ErrorRedirect_RegisterMyAddons()
  local VERSION = "4284b";

  if myAddOnsList and GetLocale() == "deDE" then
    myAddOnsList.ErrorRedirect = { name = "Umleitung Fehlernachricht",
                                   description = "Leitet rote Fehlermeldungen ins Kampflog um",
                                   version = VERSION,
                                   frame = "ErrorRedirectFrame",
                                   optionsframe = "ErrorRedirectOptionsFrame" };
  elseif myAddOnsList then
    myAddOnsList.ErrorRedirect = { name = "Error Redirect",
                                   description = "Redirect common error msgs to combat log",
                                   version = VERSION,
                                   frame = "ErrorRedirectFrame",
                                   optionsframe = "ErrorRedirectOptionsFrame" };
  end
end

