--
-- Here you can define the available colors for message highlight.
-- You have to specifiy RGB values (red, green, blue)
--
-- Schema:
-- <your colorname> = {  r = <0.0 - 1.0> , g = <0.0 - 1.0>, b = <0.0 - 1.0>  },
--
ErrorRedirect_Colors = {
  red    = {  r = 1.0, g = 0.0, b = 0.0  },
  green  = {  r = 0.0, g = 1.0, b = 0.0  },
  blue   = {  r = 0.0, g = 0.0, b = 1.0  },
  yellow = {  r = 1.0, g = 1.0, b = 0.0  },
  white  = {  r = 1.0, g = 1.0, b = 1.0  },
  black  = {  r = 0.0, g = 0.0, b = 0.0  },
  purple = {  r = 1.0, g = 0.0, b = 1.0  },
  gray   = {  r = 0.7, g = 0.7, b = 0.7  },
  orange = {  r = 1.0, g = 0.4, b = 0.2  },
 --add your own colors here


}

--
-- Here you specifiy a color for specific message.
--
-- The color will only applied if the specified message will match the ingame message exactly.
-- It works like FilterFixedStrings.lua, but without distinguish between ERROR/INFO/SYSTEM messages.
--
-- (If the need for partial message matching arise, it could be added.
--  For the moment it is not possible to setup partial matches)
--
-- Schema:
-- [<Name from Globalstrings.lua>] = "<colorname>",
-- Where <colorname> has to be a name from the above color table.
-- Every line has to be terminated by a comma, see below for an example.
--


ErrorRedirect_Filter_FixedColorMessages = {
  -- Example: You want "Out of range" displayed in green, then enter the
  -- following line (without the two leading dashes):
  --[ERR_OUT_OF_RANGE] = "green",


}