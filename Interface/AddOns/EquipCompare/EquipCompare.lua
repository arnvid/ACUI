--
-- EquipCompare by Legorol
-- Version: 2.6.2
--
-- Equipment comparison tooltips, not just at the merchant. If you hover over
-- any item in places like your bag, quest reward page or loot window, you
-- get a comparison tooltip showing the item of that type that you currently
-- have equipped.
--
-- Usage:
-- To get usage information, type /equipcompare help in-game.
--
-- Development Change Notes:
-- 2.6.2:
--  * German localization
--  * Added version ID in various places
--  * Tooltip widens if the "Currently Equipped" label is long
--  * Learnt a lot about how tooltips lay out their contents
--  * Neater way of adding a label, no need for invisible dummy line anymore! This
--    means that AddLine can be called on the tooltip even after AddLabel.
-- 2.6.1:
--  * French localization
--  * Minor hange in localization scheme, only so that bonus type names
--    are more prominently visible to those translating.
--  * Typo in ShowComparisonTooltip : "parent == GameToolTip" should be
--    small t in tip! D'oh!
-- 2.6:
--  * Have a mode in which hold Ctrl to make comparison tooltips show
-- 2.5:
--  * Introduced private comparison tooltip, lots of modifications related to this
--  * Added the Equipped in: slot labels
--  * Some tooltip placement improvements: with leftAlign, get Main Hand on left
--  * Core logic improvements: e.g. CLEAR_TOOLTIP only enables Recheck, but doesn't Hide
--  * ItemRef tooltips stick
--  * Charactersviewer comparisons are shown for PaperDollFrame
-- 2.1.1:
--  * Fixed a bug introduced in 2.1 causing 2nd comparison tooltip not to appear correctly
--    Learned that I need to anchor a tooltip before calling SetInventoryItem, even if later
--    I change its points.
--  * 2H weapons show shield as well now
-- 2.1:
--  * fix potential bug in overriding AH or Merchant tips (HideTip call wasn't actually done)
--  * tooltip now stands for object rather than string
--  * tooltip arrangement improvements
--
-- Development Todo:
--  * If you view an off-hand item, and you have 2H item equipped, show it.
--  * If the current target tooltip doesn't create comparisons, then allow
--    others to do so.
--  * Avoid comparison tooltips when hovering over an item that is actually
--    currently equipped. (E.g. when hovering on HotBar or other places)
--  * Review leftAlign placement policy
--  * Refactoring
--  * Review main/off-hand showing policy
--

--
-- Global variables
--

-- Configuration values
EquipCompare_Enabled = true;
EquipCompare_ControlMode = false;

-- Values for private use
EquipCompare_Recheck = true;
EquipCompare_Protected = false;
EquipCompare_CharactersViewer = false;
EquipCompare_GameTooltip_Owner = nil;
EquipCompare_TargetTooltip = nil;

EquipCompare_ItemTypes = {
	[INVTYPE_WEAPONMAINHAND] = 16, -- Main Hand
	[INVTYPE_2HWEAPON] = 16, -- Two-Hand
	[INVTYPE_WEAPON] = 16, -- One-Hand
	[INVTYPE_WEAPON.."_other"] = 17, -- One-Hand_other
	[INVTYPE_SHIELD] = 17, -- Off Hand
	[INVTYPE_WEAPONOFFHAND] = 17, -- Off Hand
	[INVTYPE_HOLDABLE] = 17, -- Held In Off-hand
	[INVTYPE_HEAD] = 1, -- Head
	[INVTYPE_WAIST] = 6, -- Waist
	[INVTYPE_SHOULDER] = 3, -- Shoulder
	[INVTYPE_LEGS] = 7, -- Legs
	[INVTYPE_CLOAK] = 15, -- Back
	[INVTYPE_FEET] = 8, -- Feet
	[INVTYPE_CHEST] = 5, -- Chest
	[INVTYPE_ROBE] = 5, -- Chest
	[INVTYPE_WRIST] = 9, -- Wrist
	[INVTYPE_HAND] = 10, -- Hands
	[INVTYPE_RANGED] = 18, -- Ranged
	[INVTYPE_BODY] = 4, -- Shirt
	[INVTYPE_TABARD] = 19, -- Tabard
	[INVTYPE_FINGER] = 11, -- Finger
	[INVTYPE_FINGER.."_other"] = 12, -- Finger_other
	[INVTYPE_NECK] = 2, -- Neck
	[INVTYPE_TRINKET] = 13, -- Trinket
	[INVTYPE_TRINKET.."_other"] = 14, -- Trinket_other
	[INVTYPE_WAND] = 18, -- Wand
	[INVTYPE_GUN] = 18, -- Gun
	[INVTYPE_GUNPROJECTILE] = 0, -- Projectile
	[INVTYPE_BOWPROJECTILE] = 0 -- Projectile
};

EquipCompare_SlotIDtoSlotName = {
	[0] = AMMOSLOT,		-- 0
	HEADSLOT,			-- 1
	NECKSLOT,			-- 2
	SHOULDERSLOT,		-- 3
	SHIRTSLOT,			-- 4
	CHESTSLOT,			-- 5
	WAISTSLOT,			-- 6
	LEGSSLOT,			-- 7
	FEETSLOT,			-- 8
	WRISTSLOT,			-- 9
	HANDSSLOT,			-- 10
	FINGER0SLOT,		-- 11
	FINGER1SLOT,		-- 12
	TRINKET0SLOT,		-- 13
	TRINKET1SLOT,		-- 14
	BACKSLOT,			-- 15
	MAINHANDSLOT,		-- 16
	SECONDARYHANDSLOT,	-- 17
	RANGEDSLOT,			-- 18
	TABARDSLOT,			-- 19
};


--
-- XML Event handlers
--

function EquipCompare_OnLoad()
	this:RegisterEvent("CLEAR_TOOLTIP");
	-- Check for Cosmos. If available, register with it.
	if ( Cosmos_RegisterConfiguration ) then
		this:RegisterEvent("VARIABLES_LOADED");
		Cosmos_RegisterConfiguration(
			"COS_EQC",
			"SECTION",
			EQUIPCOMPARE_COSMOS_SECTION,
			EQUIPCOMPARE_COSMOS_SECTION_INFO
		);
		Cosmos_RegisterConfiguration(
			"COS_EQC_SEPARATOR",
			"SEPARATOR",
			EQUIPCOMPARE_COSMOS_HEADER,
			EQUIPCOMPARE_COSMOS_HEADER_INFO
			
		);
		Cosmos_RegisterConfiguration(
			"COS_EQC_ENABLED",
			"CHECKBOX",
			EQUIPCOMPARE_COSMOS_ENABLE,
			EQUIPCOMPARE_COSMOS_ENABLE_INFO,
			EquipCompare_Toggle,
			1
		);
		Cosmos_RegisterConfiguration(
			"COS_EQC_CONTROLMODE",
			"CHECKBOX",
			EQUIPCOMPARE_COSMOS_CONTROLMODE,
			EQUIPCOMPARE_COSMOS_CONTROLMODE_INFO,
			EquipCompare_ToggleControl,
			0
		);
	end
	-- If Cosmos allows chat command registration, do so
	if ( Cosmos_RegisterChatCommand ) then
		local comlist = { "/equipcompare", "/eqc" };
		local desc = EQUIPCOMPARE_COSMOS_SLASH_DESC;
		local id = "EQUIPCOMPARE";
		local func = EquipCompare_SlashCommand
		Cosmos_RegisterChatCommand ( id, comlist, func, desc, CSM_CHAINNONE );
	else
	-- otherwise, just register slash commands manually
		SlashCmdList["EQUIPCOMPARE"] = EquipCompare_SlashCommand;
		SLASH_EQUIPCOMPARE1 = "/equipcompare";
		SLASH_EQUIPCOMPARE2 = "/eqc";
	end
	
	-- Check to see if CharactersViewer is installed, has the right version
	-- and has the required interface. If so, enable support for it.
	if ( CHARACTERSVIEWER_VERSION and CHARACTERSVIEWER_VERSION >= 29 and
		type(CharactersViewer_Tooltip_SetInventoryItem)=="function") then
		EquipCompare_CharactersViewer = true;
	end
	
	-- Override GameTooltip.SetOwner so we can know who the owner is
	local orig_GameTooltip_SetOwner = GameTooltip.SetOwner;
	function GameTooltip.SetOwner(...)
		if (arg.n>1) then
			EquipCompare_GameTooltip_Owner = arg[2];
		end
		return orig_GameTooltip_SetOwner(unpack(arg));
	end
	
	-- Welcome!
	ChatFrame1:AddMessage(EQUIPCOMPARE_GREETING);
end

function EquipCompare_OnEvent(event)
	if ( event == "CLEAR_TOOLTIP" ) then
		if ( not EquipCompare_Protected ) then
			EquipCompare_Recheck = true;
		end
	elseif ( event == "VARIABLES_LOADED" ) then
		-- we have Cosmos, so let's read the state of the AddOn from Cosmos
		EquipCompare_Toggle(COS_EQC_ENABLED_X);
		EquipCompare_Toggle(COS_EQC_CONTROLMODE_X);
	end
end

function EquipCompare_OnUpdate()
	if ( not EquipCompare_Enabled ) then
		return;
	end
	
	if ( EquipCompare_ControlMode and not IsControlKeyDown() ) then
		if (EquipCompare_TargetTooltip) then
			EquipCompare_Recheck = true;
			EquipCompare_TargetTooltip = nil;
			EquipCompare_HideTips();
		end
		return;
	end
	
	-- If we currently have a target that has since become
	-- hidden, hide the comparison tooltips too.
	if ( EquipCompare_TargetTooltip and
	     not EquipCompare_TargetTooltip:IsVisible() ) then
		EquipCompare_Recheck = true;
		EquipCompare_TargetTooltip = nil;
		EquipCompare_HideTips();
	end
	
	if ( not EquipCompare_Recheck ) then
	 	return;
	end
	
	EquipCompare_ShowCompare();
end

--
-- Other functions
--

function EquipCompare_SlashCommand(msg)
	if (not msg or msg == "") then
		-- toggle
		EquipCompare_Toggle(not EquipCompare_Enabled);
	elseif (msg == "on") then
		-- turn on
		EquipCompare_Toggle(true);
	elseif (msg == "off") then
		-- turn off
		EquipCompare_Toggle(false);
	elseif (msg == "control") then
		-- toggle Control Key Mode
		EquipCompare_ToggleControl(not EquipCompare_ControlMode);
	else
		-- usage
		ChatFrame1:AddMessage(EQUIPCOMPARE_USAGE_TEXT);
	end
	-- update Cosmos configuration setting
	if ( Cosmos_RegisterConfiguration ) then
		local newvalue;
		
		-- Enabled check box
		if ( EquipCompare_Enabled ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
		COS_EQC_ENABLED_X=newvalue;
		Cosmos_UpdateValue("COS_EQC_ENABLED", CSM_CHECKONOFF, newvalue);
		Cosmos_SetCVar("COS_EQC_ENABLED_X", newvalue);
		
		-- Control mode check box
		if ( EquipCompare_ControlMode ) then
			newvalue = 1;
		else
			newvalue = 0;
		end
		COS_EQC_ENABLED_X=newvalue;
		Cosmos_UpdateValue("COS_EQC_CONTROLMODE", CSM_CHECKONOFF, newvalue);
		Cosmos_SetCVar("COS_EQC_CONTROLMODE_X", newvalue);
	end
end

function EquipCompare_Toggle(toggle)
	-- workaround, as Cosmos sends a 0 when it wants to turn us off
	if ( toggle == 0 ) then toggle = false; end
	-- turn on
	if ( toggle and not EquipCompare_Enabled ) then
		EquipCompare_Enabled = true;
		EquipCompare_Recheck = true;
	end
	-- turn off
	if ( not toggle and EquipCompare_Enabled ) then
		EquipCompare_Enabled = false;
		EquipCompare_HideTips();
	end
end

function EquipCompare_ToggleControl(toggle)
	-- workaround, as Cosmos sends a 0 when it wants to turn us off
	if ( toggle == 0 ) then toggle = false; end
	-- turn on
	if ( toggle ) then
		EquipCompare_ControlMode = true;
	end
	-- turn off
	if ( not toggle ) then
		EquipCompare_ControlMode = false;
	end
end

function EquipCompare_HideTips()
	ComparisonTooltip1:Hide();
	ComparisonTooltip2:Hide();
end

-- The following function is responsible for hiding a tooltip without
-- triggering a call to whatever the current GameTooltip_OnHide function is,
-- merely performing those steps instead that the default Blizzard UI implementation
-- of GameTooltip_OnHide does.
-- This is necessary because many AddOn authors mistakenly assume that
-- GameTooltip_OnHide gets called *only* when it is the GameTooltip that
-- gets hidden, and override GameTooltip_OnHide accordingly. Unfortunately
-- GameTooltip_OnHide gets called when *any* tooltip gets hidden, so hiding
-- the ComparisonTooltips can have unintended side effects in other AddOns.
-- This function is therefore here only as a workaround.
function EquipCompare_CarefulHideTooltip(tooltip)
	if ( tooltip and tooltip:IsVisible() ) then
		local temp_GameTooltip_OnHide;
		temp_GameTooltip_OnHide = GameTooltip_OnHide;
		GameTooltip_OnHide = function () end
		tooltip:Hide();
		tooltip:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b);
		tooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);
		tooltip.default = nil;
		GameTooltip_OnHide = temp_GameTooltip_OnHide;
	end
end

-- This function is called on every OnUpdate. This is the only way to detect if a
-- game tooltip has been displayed, without overriding FrameXML files.
-- So that this function doesn't hog resources, the EquipCompare_Recheck flag is
-- set to false, until the game tooltip changes.
function EquipCompare_ShowCompare()
	--
	-- Local functions
	--
	
	-- Add a label at the top of the tooltip saying "Currently Equipped"
	local function AddLabel(tooltip, slot)
		local tLabel, tLabel1;
		
		if (not tooltip or not tooltip:IsVisible()) then
			return;
		end
		
		tLabel = getglobal(tooltip:GetName().."TextLeft0");
		tLabel:SetText(EQUIPCOMPARE_EQUIPPED_LABEL);
		tLabel:SetTextColor(0.5, 0.5, 0.5);
		tLabel:Show();
		
		tLabel1 = getglobal(tooltip:GetName().."TextLeft1");
		if ( tLabel:IsVisible() and tLabel1:IsVisible() ) then
			if ( tLabel:GetWidth() > tLabel1:GetWidth() ) then
				tLabel1:SetWidth(tLabel:GetWidth());
				tooltip:Show();
			end
		end
	end
	
	-- Display a comparison tooltip and set its contents to currently equipped item
	-- occupying slotid
	local function ShowComparisonTooltip(parent, slotid)
		local leftAlign, donePlacing;
		local left, right, i;
		
		-- Set contents of tooltip.
		
		-- Note: you can't set a tooltip's contents before specifying at least
		-- one point. Hence anchor it to whatever, even if you later change
		-- its placement.
		ComparisonTooltip1:SetOwner(parent, "ANCHOR_LEFT");
		if ( EquipCompare_CharactersViewer ) then
			CharactersViewer_Tooltip_SetInventoryItem(ComparisonTooltip1, slotid);
		else
			ComparisonTooltip1:SetInventoryItem("player", slotid);
		end
		AddLabel(ComparisonTooltip1, slotid);
		
		if ( not ComparisonTooltip1:IsVisible() ) then
			return;
		end;
		
		-- Set placement of tooltip
		
		leftAlign = false;
		if ( parent == GameTooltip and EquipCompare_GameTooltip_Owner and
			 string.find(EquipCompare_GameTooltip_Owner:GetName(),"ContainerFrame") ) then
			leftAlign = true;
		end
		
		donePlacing = true;
		repeat
			ComparisonTooltip1:ClearAllPoints();
			if (leftAlign) then
				ComparisonTooltip1:SetPoint("TOPRIGHT", parent:GetName(), "TOPLEFT", 0, -10);
			else
				ComparisonTooltip1:SetPoint("TOPLEFT", parent:GetName(), "TOPRIGHT", 0, -10);
			end
			
			local left = ComparisonTooltip1:GetLeft();
			local right = ComparisonTooltip1:GetRight();
			
			if ( left and right ) then
				left, right = left - (right-left), right + (right-left);
			end
			
			-- If the comparison tooltip would be off the screen, place it on other 
			-- side instead. Only perform this check once to avoid endless loop.
			if ( donePlacing ) then
				if ( left and left<0 ) then
					leftAlign = false;
					donePlacing = false;
				elseif ( right and right>UIParent:GetRight() ) then
					leftAlign = true;
					donePlacing = false;
				end
			else
				donePlacing = true;
			end
		until donePlacing;
		
		return leftAlign;
	end
	
	--
	-- Main code of EquipCompare_ShowCompare starts here
	--
	
	local OverrideTooltips = nil;
	local tooltip, ttext, itype, slotid, other, leftAlign;
	local i,cvplayer;
	
	-- Check which Tooltip we are intersted in, in order of priority
	if ( ItemRefTooltip and ItemRefTooltip:IsVisible() ) then
		tooltip = ItemRefTooltip;
	elseif ( LootLinkTooltip and LootLinkTooltip:IsVisible() ) then
		tooltip = LootLinkTooltip;
	elseif ( GameTooltip and GameTooltip:IsVisible() ) then
		tooltip = GameTooltip;
	else
		-- None of our potential targets are visible
		return;
	end
	EquipCompare_TargetTooltip = tooltip;
	
	-- Start processing
	
	EquipCompare_Recheck = false;
	EquipCompare_HideTips();
	
	-- In some cases it is desirable to override the comparison tooltips already
	-- provided by e.g. Merchant and Auction House. Check for that here.
	
	if ( EquipCompare_CharactersViewer ) then
		local cvplayer = CharactersViewerGetBSIIndex();
		if ( UnitName("player") ~= cvplayer ) then
			OverrideTooltips = true;
		end
		if ( CharactersViewer_Frame:IsVisible() and
			MouseIsOver(CharactersViewer_Frame) and tooltip == GameTooltip ) then
			return;
		end
	end
	
	-- Special checks when we are attaching to GameTooltip.
	-- Some frames provide equipment comparison tooltips already, so we don't need to,
	-- which we detect via ShoppingTooltip1 already being visible. Also, we don't need
	-- comparison tooltips when over e.g. PaperDollFrame. This is all true unless there
	-- is some special-case reason to override the tooltips.
	if ( tooltip == GameTooltip ) then
		if ( not OverrideTooltips ) then
			if ( ( PaperDollFrame:IsVisible() and MouseIsOver(PaperDollFrame) ) or
				 ShoppingTooltip1:IsVisible() ) then
				return;
			end
		else
			EquipCompare_CarefulHideTooltip(ShoppingTooltip1);
			EquipCompare_CarefulHideTooltip(ShoppingTooltip2);
		end
	end
	
	-- Infer the type of the item from one of the 2nd to 5th line of its tooltip description
	-- Match this type against the appropriate slot
	slotid = nil;
	i = 2;
	repeat
		ttext = getglobal(tooltip:GetName().."TextLeft"..i);
		if ( ttext and ttext:IsVisible() ) then
			itype = ttext:GetText();
			if ( itype ) then
				slotid = EquipCompare_ItemTypes[itype];
			end
		end
		i = i + 1;
	until (slotid or i > 5)
	
	if ( slotid ) then
		-- Whilst we are in the process of displaying additional tooltips, we don't
		-- want to reset the EquipCompare_Recheck flag. This protection is necessary
		-- because calling SetOwner or SetxxxItem on any tooltip causes a
		-- CLEAR_TOOLTIP event.
	    EquipCompare_Protected = true;
		
		-- In case money line is visible on GameTooltip, must protect it by overriding
		-- GameTooltip_ClearMoney. This is because calling SetOwner or SetxxxItem on
		-- any tooltip causes money line of GameTooltip to be cleared.
		local oldFunction = GameTooltip_ClearMoney;
		GameTooltip_ClearMoney = function() end;
		
		-- Display a comparison tooltip and set its contents to currently equipped item
		leftAlign = ShowComparisonTooltip(tooltip, slotid);
		
		other = false;
		-- If this is an item that can go into multiple slots, display additional
		-- tooltips as appropriate
		if ( itype == INVTYPE_FINGER ) then
			other = EquipCompare_ItemTypes[INVTYPE_FINGER.."_other"];
		end
		if ( itype == INVTYPE_TRINKET ) then
			other = EquipCompare_ItemTypes[INVTYPE_TRINKET.."_other"];
		end
		if ( itype == INVTYPE_WEAPON ) then
			other = EquipCompare_ItemTypes[INVTYPE_WEAPON.."_other"];
		end
		
		if ( itype == INVTYPE_2HWEAPON ) then
			other = EquipCompare_ItemTypes[INVTYPE_SHIELD];
		end
		
		if ( other ) then
			if ( ComparisonTooltip1:IsVisible() ) then
				-- First set the contents of the 2nd tooltip.
				-- Note that we must use either at least an anchor or SetPoint
				-- to be able to set the contents.
				ComparisonTooltip2:SetOwner(ComparisonTooltip1, "ANCHOR_LEFT");
				if ( EquipCompare_CharactersViewer ) then
					CharactersViewer_Tooltip_SetInventoryItem(ComparisonTooltip2, other);
				else
					ComparisonTooltip2:SetInventoryItem("player", other);
				end
				AddLabel(ComparisonTooltip2, other);
				
				if ( ComparisonTooltip2:IsVisible() ) then
					-- Now place it in its rightful place
					ComparisonTooltip2:ClearAllPoints();
					if ( leftAlign ) then
						ComparisonTooltip1:ClearAllPoints();
						ComparisonTooltip2:SetPoint("TOPRIGHT", tooltip:GetName(), "TOPLEFT", 0, -10);
						ComparisonTooltip1:SetPoint("TOPRIGHT", "ComparisonTooltip2", "TOPLEFT", 0, 0);
					else
						ComparisonTooltip2:SetPoint("TOPLEFT", "ComparisonTooltip1", "TOPRIGHT", 0, 0);
					end
				end
			else
				ShowComparisonTooltip(tooltip, other);
			end
		end
		
		-- Restore GameTooltip_ClearMoney overriding.
		GameTooltip_ClearMoney = oldFunction;
		
		EquipCompare_Protected = false;
	end
end
