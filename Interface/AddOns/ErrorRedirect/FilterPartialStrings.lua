--
-- In this file the filter for variable strings are setup.
-- They have to match partial the game message.
-- If a partial match occurs, the message is filtered out.
--
-- Here you can setup only partial string matches. For example: to match
-- any error message which contains the word "failed", you simply add that
-- string "failed" to one of the filters.
--
-- The length of the filterlist IS relevant for performance as each string
-- has to be compared against the game message.
--
-- Note to advanced users: You can use any string matching pattern that lua allows.
-- Giving just a plain partial string is the most basic pattern.
-- But that should do the job in most (any) cases.
--

--
-- Localization has to be done manually for this lists.
--


-- ============================================================================
-- English (default) (if you use english client all you strings should go here)
--                   (if you don't use english client scroll down)
--

--
-- Filter for event UI_ERROR_MESSAGE (The red center messages)
--
ErrorRedirect_Filter_PartialErrorMessages = {
  REDIRECT_TO_FRAME = ChatFrame2, -- if option "Enable, redirect to combat log" is selected

  -- Add here your filter strings for ERROR Message (these are the red ones)
  -- Every line has to be terminated by a comma
  -- use the following scheme (without the first two dashes):
  -- "cast failed", -- just an example line
  -- "range", -- just an example line

  -- Add here your filter strings for INFO Messages (these are the yellow ones)
  -- Every line has to be terminated by a comma

}



-- ================================================================
-- German (if you use german client all you strings should go here)
--
if GetLocale() == "deDE" then
  --
  -- Filter for event UI_ERROR_MESSAGE (The red center messages)
  --
  ErrorRedirect_Filter_PartialErrorMessages = {
    REDIRECT_TO_FRAME = ChatFrame2, -- if option "Enable, redirect to combat log" is selected

    -- Add here your filter strings for ERROR Message (these are the red ones)
    -- Every line has to be terminated by a comma
    -- use the following scheme (without the two dashes):
    -- "irgendwas",

  }

end



-- ================================================================
-- French (if you use french client all you strings should go here)
--
if GetLocale() == "frFR" then
  --
  -- Filter for event UI_ERROR_MESSAGE (The red center messages)
  --
  ErrorRedirect_Filter_PartialErrorMessages = {
    REDIRECT_TO_FRAME = ChatFrame2, -- delete this line or comment out if you dont want any redirect at all

    -- Add here your filter strings for ERROR Message (these are the red ones)
    -- Every line has to be terminated by a comma
    -- use the following scheme (without the two dashes):
    -- "french word",
    -- "french word2",
  }
end
