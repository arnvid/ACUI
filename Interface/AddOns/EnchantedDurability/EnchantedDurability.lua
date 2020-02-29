--Function hooks
local oldQuestTimerFrame_OnShow

EnchantedDurabilitySlots = {};
EnchantedDurabilitySlots[1] = {slot = "Head"};
EnchantedDurabilitySlots[2] = {slot ="Shoulder"};
EnchantedDurabilitySlots[3] = {slot ="Chest"};
EnchantedDurabilitySlots[4] = {slot ="Waist"};
EnchantedDurabilitySlots[5] = {slot ="Legs"};
EnchantedDurabilitySlots[6] = {slot ="Feet"};
EnchantedDurabilitySlots[7] = {slot ="Wrist"};
EnchantedDurabilitySlots[8] = {slot ="Hands"};
EnchantedDurabilitySlots[9] = {slot ="MainHand", showSeparate = 1};
EnchantedDurabilitySlots[10] = {slot ="Shield", showSeparate = 1};
EnchantedDurabilitySlots[11] = {slot ="Ranged", showSeparate = 1};

DurManLocked = 0;

--Responsible for showing tooltip
function EnchantedDurabilityFrameOnEnter()
	
	local slotName = this:GetName();
	local id, hasItem, repairCost;
	local itemName, durability;
	local tmpText;

	local name = UnitName("player")
	
--Substract "EnchantedDurabilityFrame" from name
	slotName = strsub(slotName,25);
--Shield is held in SecondaryHand inventory slot which is same as 2nd weapon 
--but it has difrent texture in durabnility frame
--so if going to show shield tooltip we need to get info from SecondaryHandSlot
	if (slotName == "ShieldSlot") then
		slotName = "SecondaryHandSlot"
--Splited some frames on two coz of positioning problems
	elseif (slotName == "ShoulderSlotLeft" or slotName == "ShoulderSlotRight") then
		slotName =  "ShoulderSlot";
	elseif (slotName == "WristSlotLeft" or slotName == "WristSlotRight") then
		slotName =  "WristSlot";
	elseif (slotName == "HandsSlotLeft" or slotName == "HandsSlotRight") then
		slotName =  "HandsSlot";
	end
--Get inventory slot id based on frame name
	id, _ = GetInventorySlotInfo(slotName);
--Set owner of tooltip (must be set before geting tooltip text... no idea why)
	GameTooltip:SetOwner(this, "ANCHOR_LEFT");
--Get some variables from tooltip
	hasItem, _, repairCost = GameTooltip:SetInventoryItem("player", id);
--If there isn't any item in slot clear tooltip (not that is needed but better to be carefull)
	if ( not hasItem ) then
		GameTooltip:ClearLines()
	else 
--Get name of item which is allways (i hope) stored in TextLeft1
		itemName = GameTooltipTextLeft1:GetText(); 
--Search for durability line
		for i=2, 15, 1 do
			tmpText = getglobal("GameTooltipTextLeft"..i);
			if (tmpText:GetText() and string.find(tmpText:GetText(), "Durability") ~=nil) then
--Remember durability line (only value not text)
				durability = string.sub(tmpText:GetText(), 11, -1);
--If found no need to do for loop anymore
				break;
			end
		end
--Clear tooltip (we will build it up from clean one)	
		GameTooltip:ClearLines();
--Now build it up dependent on user setings
		if (ed_var[name].ShowName == 1) then
			GameTooltip:SetText(itemName, 1, 1, 1);
		end
		if (ed_var[name].ShowShort == 0) then
			GameTooltip:AddDoubleLine("Durability:", durability, 1,1,1, 1,1,1);	
			if ( repairCost  and ed_var[name].ShowRepairPrice == 1 ) then
				GameTooltip:AddLine(REPAIR_COST, 1, 1, 0, 1)
				SetTooltipMoney(GameTooltip, repairCost);
			end
		else	
			GameTooltip:AddLine(durability, 1, 1, 1);
			if ( repairCost  and ed_var[name].ShowRepairPrice == 1 ) then
				SetTooltipMoney(GameTooltip, repairCost);
			end	
		end
		GameTooltip:Show();
	end
end

function EnchantedDurabilityFrameOnLeave()
--hide tooltip
	GameTooltip:Hide();
--Clear it
	GameTooltip:ClearLines();
end

--Responsible for moving whole durability frame via small box above right shoulder 
--(right mouse button locks it in place until next right mouse click)
function DurabilityMoverOnMouseDown(arg1)
	if ( arg1 == "LeftButton" and DurManLocked ~= 1 ) then
		 this:StartMoving();
		 EnchantedDurabilityBackdrop:Show();
	elseif (arg1 == "RightButton") then
		if (DurManLocked == 0) then
			DurManLocked = 1;
			DurabilityMoverTexture:SetVertexColor("1.0","0.0","0.0");
		else
			DurManLocked = 0;
			DurabilityMoverTexture:SetVertexColor("0.0","0.0","0.0");
		end
	end
end

--Show all tootlip Frames (when durability frame is visible)
local function EnchantedDurabilityFrameShow(FrameName)

	FrameName = strsub(FrameName, 20);
--Check if it is "double frame" if yes show both left and right part
	if (FrameName == "Shoulder" or FrameName == "Wrist" or FrameName == "Hands") then
		getglobal(EN_DUR_FRAME..FrameName.."SlotLeft"):Show();
		getglobal(EN_DUR_FRAME..FrameName.."SlotRight"):Show();
	else		
		getglobal(EN_DUR_FRAME..FrameName.."Slot"):Show();
	end	
end

--Hide all tootlip Frames (when durability frame isn't visible)
local function EnchantedDurabilityFrameHide(FrameName)
	
	FrameName = strsub(FrameName, 20);
	if (FrameName == "Shoulder" or FrameName == "Wrist" or FrameName == "Hands") then	
		getglobal(EN_DUR_FRAME..FrameName.."SlotLeft"):Hide();
		getglobal(EN_DUR_FRAME..FrameName.."SlotRight"):Hide();
	else	
		getglobal(EN_DUR_FRAME..FrameName.."Slot"):Hide();
	end
end

--Orginal blizz function
function EnchantedDurabilityFrame_OnUpdate(elapsed)
	if ( EnchantedDurability.enchantTimer ) then
		EnchantedDurability.enchantTimer = EnchantedDurability.enchantTimer - elapsed;
		if ( EnchantedDurability.enchantTimer < 0 ) then
			EnchantedDurability.enchantTimer = nil;
			UpdateInventoryAlertStatus();
		end
	end
end

--Based on orginal blizz function
function EnchantedDurabilityFrame_SetAlerts()

	EnchantedDurability.enchantTimer = nil;

	local texture, color, showDurability;
	local showMover = 0;

	for index, value in EnchantedDurabilitySlots do
		
		texture = getglobal(EN_DUR..value.slot);
		
		if ( value.slot == "Shield" ) then
			if ( OffhandHasWeapon() ) then
				EnchantedDurabilityShield:Hide();
				texture = EnchantedDurabilitySecondaryHand;
			else
				EnchantedDurabilitySecondaryHand:Hide();
				texture = EnchantedDurabilityShield;
			end
		end

		local alertStatus = GetInventoryAlertStatus(index);
		color = INVENTORY_ALERT_COLORS[alertStatus];
		
		if ( color ) then
			texture:SetVertexColor(color.r, color.g, color.b, 1.0);	
			if ( value.showSeparate ) then			
				texture:Show();	
				showMover = 1;
			else
				showDurability = 1;
				showMover = 1;
			end
--Show proper tooltip mouseover frame
			EnchantedDurabilityFrameShow(texture:GetName());
		else
			texture:SetVertexColor(1.0, 1.0, 1.0, 0.5);
			if ( value.showSeparate ) then
				texture:Hide();		
			end
--Or hide it
			EnchantedDurabilityFrameHide(texture:GetName());
		end
	end

	for index, value in EnchantedDurabilitySlots do
		if ( not value.showSeparate ) then
			if ( showDurability ) then
				getglobal(EN_DUR..value.slot):Show();
			else
				getglobal(EN_DUR..value.slot):Hide();
			end
		end
	end
--Show small box that allows you to move Durability Frame
	if (showMover == 1) then
		DurabilityMover:Show();
	else
		DurabilityMover:Hide();
	end
	
end

--Event handling
function EnchantedDurabilityOnEvent()

	if ( event == "UNIT_NAME_UPDATE" ) then
		if ( arg1 == "player" and UnitName("player") ~= "Unknown Entity" ) then
			this:UnregisterEvent("UNIT_NAME_UPDATE");
			EnchantedDurabilityMan_Init()
		end
	else
		EnchantedDurabilityFrame_SetAlerts();
	end

end

--For orginal blizz function hooks
function EnchantedDurabilityOverride()
--Hook QuestTimer function which would bring back ald Durabiliti frame
	oldQuestTimerFrame_OnShow = QuestTimerFrame_OnShow;
	QuestTimerFrame_OnShow = newQuestTimerFrame_OnShow;
end

--This function moves orginal durability frame out of screen and hides it
function EnchantedDurabilityMoveOld()
	DurabilityFrame:ClearAllPoints();
	DurabilityFrame:SetPoint("RIGHT", "PlayerFrame", "LEFT", -100 ,0);
	DurabilityFrame:Hide();
end

function EnchantedDurabilityMan_Init()
	
	local name = UnitName("player"); 

	if (ed_var ~= nil) then
-- Check if this char have settings for Enchanted Durabilityr
		if (ed_var[name] == nil) then
			ed_var[name] = {};
			ed_var[name].ShowName = 1;
			ed_var[name].ShowShort = 0;
			ed_var[name].ShowRepairPrice = 1;
		end
-- If settings dont exist create variable with this char entry
	else
		ed_var = {};
		ed_var[name] = {};
		ed_var[name].ShowName = 1;
		ed_var[name].ShowShort = 0;
		ed_var[name].ShowRepairPrice = 1;
	end
--Usual addon loaded text
	ChatPrint(EN_DUR_HELLO1);
	ChatPrint(EN_DUR_HELLO2);
--Init slash commands and other stuff
	EnchantedDurabilityOverride();
	EnchantedDurabilityMoveOld();
	EnchantedDurabilityAddCommands ();
end

--Adds shalsh command for AddOn settings
function EnchantedDurabilityAddCommands ()
	SlashCmdList["ENCHDURCOMMAND"] = EnchantedDurabilityCommand;
	SLASH_ENCHDURCOMMAND1 = "/ed";
end

--Enchanted durability slash command handling
function EnchantedDurabilityCommand (text)
	
	local name = UnitName("player"); 

	if (string.lower(text) == "reset") then
		RestartEnchantedDurability();
	elseif (string.lower(text) == "short") then
		ed_var[name].ShowShort = 1;
	elseif (string.lower(text) == "long") then
		ed_var[name].ShowShort = 0;
	elseif (string.lower(text) == "name") then
		ed_var[name].ShowName = 1;
	elseif (string.lower(text) == "no name") then
		ed_var[name].ShowName = 0;
	elseif (string.lower(text) == "no price") then
		ed_var[name].ShowRepairPrice = 0;
	elseif (string.lower(text) == "price") then
		ed_var[name].ShowRepairPrice = 1;
	elseif (string.lower(text) == "reset") then
		RestartEnchantedDurability();
	elseif (string.lower(text) == "help") then
		ChatPrint(EN_DUR_HELP1);
		ChatPrint(EN_DUR_HELP2);
		ChatPrint(EN_DUR_HELP3);
		ChatPrint(EN_DUR_HELP4);
	else
		ChatPrint(EN_DUR_UNKNOWN);
	end
end

--Chat Output
function ChatPrint(msg)
	if( DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage(msg);
	end
end

--Restarts all setings to default
function RestartEnchantedDurability()
	
	local name = UnitName("player"); 

	ed_var[name].ShowName = 1;
	ed_var[name].ShowShort = 0;
	ed_var[name].ShowRepairPrice = 1;

	EnchantedDurabilityMoveOld();

end

--Prevent quest timer frame from moving orginal durability back on old spot
function newQuestTimerFrame_OnShow()
--Doing old one coz of compatibility reasons (if they add something to it in future)
	oldQuestTimerFrame_OnShow();
--Sending old Durability back to hell ;p
	EnchantedDurabilityMoveOld();
end