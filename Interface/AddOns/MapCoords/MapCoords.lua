-- **************************
-- MapCoords Coded By ReCover
-- Version 0.2
-- Interface 4211
-- ***
-- Changelog:
-- 0.2:
-- - Kickass fix made by Astus so cursor coords is accurate out-of-the-box =)
-- 0.1:
-- - Made the AddOn
-- **************************

local OFFSET_X = 0.0022;
local OFFSET_Y = -0.0262;

function MapCoords_OnUpdate(arg1)
		
	--Get Coords
	local x, y = GetCursorPosition();

	-- Get Scale
	local scale = WorldMapFrame:GetScale();
	x = x / scale;
	y = y / scale;
	
	--Compensate (Values calculated from the player pos without floor)
	local width = WorldMapButton:GetWidth();
	local height = WorldMapButton:GetHeight();
	local centerX, centerY = WorldMapFrame:GetCenter();
	
	local adjustedX = (x - (centerX - (width/2))) / width;
	local adjustedY = (centerY + (height/2) - y) / height;

	-- Factor in the Offset 
	-- Make these whole numbers
	x = (adjustedX + OFFSET_X) * 100;
	y = (adjustedY + OFFSET_Y) * 100;

	--Player Coords
	local px, py = GetPlayerMapPosition("player");
	px = floor(px * 100);
	py = floor(py * 100);
		
	--Print
	MapCoords:SetText("Cursor Coords (X,Y): "..format("%d,%d", x , y).." -- Player Coords (X,Y): "..px..","..py);

end
