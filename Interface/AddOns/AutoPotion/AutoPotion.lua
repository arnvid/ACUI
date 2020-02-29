-- AutoPotion by Jooky.
-- Download the latest version at:
-- http://www.curse-gaming.com/mod.php?addid=9
--*****************************************************************************
--Initialize Variables:
--*****************************************************************************
AUTOPOTION_VERSION							= "2.2";
--Config options:
AP_Defaults = {
	AutoPotion_Enabled = 1,
	PVP_Only = 0,
	Disable_For_Duels = 1,
	StoneEnabled = 1,
	CrystalEnabled = 1,
	SoulStoneEnabled = 0,
	HealthEnabled = 1,
	ManaEnabled = 1,
	RejuvEnabled = 1,
	SmartRejuvEnabled = 1,
	BandageEnabled = 0,
	BandageInCombat = 0,
	BandageWhenDoT=0,
	HealthTrigger = 30,
	ManaTrigger = 20,
	ReverseOrder = 0
};
AP_Player_Config = {};
AP_PlayerName="";
AP_ServerName="";
AP_PlayerClass="";
AP_Lang = "EN";
AP_LangList = {"EN","DE","FR"};

--Other settings:
AP_InCombat = 0;
AP_LastAction = 0;
AP_ActionCoolDown = 1;
--AP_DialogIsOpen = 0;
AP_Feigning = 0;
AP_Poison = 0;
AP_Channelling=0;
AP_FirstStop=0;
AP_NonManaClass = 0;
AP_DisableForBuff = 0;
AP_DisableBandageForDebuff = 0;
AP_RecentlyBandaged=0;
AP_Dueling=0;

--*****************************************************************************
--Preliminary functions:
--*****************************************************************************
----------------------------
--OnLoad Function:----------
----------------------------
function AutoPotion_OnLoad()
	--Register Events:
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("PLAYER_AURAS_CHANGED");
	this:RegisterEvent("SPELLCAST_CHANNEL_START");
	this:RegisterEvent("SPELLCAST_STOP");
	this:RegisterEvent("DUEL_FINISHED");
	 -- Add AutoPotion frame to the UIPanelWindows list
	UIPanelWindows["AutoPotion_ConfigDg"] = {area = "center", pushable = 0};
end
--------------------------------------------------
--OnEvent and Supporting Functions:---------
--------------------------------------------------
-- Believe it or not, this function started small.  Now it's filled with special cases
-- for disabling all or part of AutoPotion, depending on the character's class or state
----------------------------
function AutoPotion_OnEvent(event)
	if (event=="VARIABLES_LOADED") then
		-- Add AutoPotion to myAddOns addons list
		if(myAddOnsFrame) then
			myAddOnsList.AutoPotion = {
				name = "AutoPotion",
				description = AUTOPOTION_MYADDONS_DESC,
				version = AUTOPOTION_VERSION,
				category = MYADDONS_CATEGORY_COMBAT,
				frame = "AutoPotion_Main",
				optionsframe = "AutoPotion_ConfigDg"};
		end
		--Load language:
		getglobal("AUTOPOTION_"..AP_Lang)();
		--Create slash commands (as defined in localization.lua):
		SlashCmdList["AUTOPOTION"] = function(msg)
			AutoPotion_SlashCmd(msg);
		end
		--Display "AutoPotion Loaded" message (as defined in localization.lua):
		AP_ChatMessage(AUTOPOTION_LOADED_MESSAGE, 1.0, 1.0, 0.0);
		UIErrorsFrame:AddMessage(AUTOPOTION_LOADED_MESSAGE, 1.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
	end
	-- Get player name and set up default configuration values:
	if (event=="UNIT_NAME_UPDATE") or (event=="PLAYER_ENTERING_WORLD") then
		if (AP_PlayerName ~= "") then
			return;
		end
		-- Get the player's name
		local playerName = UnitName("player");
		-- If the game doesn't return a player's name, then get out and try again later
		if (playerName == nil) or (playerName == UNKNOWNOBJECT) or (playerName == UNKNOWNBEING) then
			AP_PlayerName="";
			return;
		end
		--Set our PlayerName global.
		AP_PlayerName = playerName;
		AP_ServerName = GetCVar("realmName");
		AP_PlayerClass = UnitClass("player");
		--Check if player is a non-mana class, if so then we don't want to go drinking mana potions
		AP_NonManaClass = 0;
		for i=1,table.getn(AUTOPOTION_DISABLE_MANA_CLASSES) do
			local currentClass = string.lower(AP_PlayerClass);
			local thisClass = string.lower(AUTOPOTION_DISABLE_MANA_CLASSES[i]);
			if (currentClass == thisClass) then
				AP_NonManaClass = 1;
				break;
			end
		end
		-- Check if user has saved his own set of defaults
		if not (AP_User_Defaults) then
			AP_User_Defaults = TableCopy(AP_Defaults);
		end
		--If this player name doesn't exist in our database, then add it with default settings
		if not (AP_Player_Config[AP_PlayerName..":"..AP_ServerName]) then
			AP_Player_Config[AP_PlayerName..":"..AP_ServerName] = TableCopy(AP_User_Defaults);
		end
		-- Add defaults for new "In-Combat Bandages" checkbox
		if not (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].BandageInCombat) then
			if not (AP_User_Defaults.BandageInCombat) then
				AP_User_Defaults.BandageInCombat = AP_Defaults.BandageInCombat;
			end
			AP_Player_Config[AP_PlayerName..":"..AP_ServerName].BandageInCombat = AP_User_Defaults.BandageInCombat;
		end
		-- Add defaults for new "DoT Bandages" checkbox
		if not (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].BandageWhenDoT) then
			if not (AP_User_Defaults.BandageWhenDoT) then
				AP_User_Defaults.BandageWhenDoT = AP_Defaults.BandageWhenDoT;
			end
			AP_Player_Config[AP_PlayerName..":"..AP_ServerName].BandageWhenDoT = AP_User_Defaults.BandageWhenDoT;
		end
		-- Add defaults for new "Disable for Duels" checkbox
		if not (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].Disable_For_Duels) then
			if not (AP_User_Defaults.Disable_For_Duels) then
				AP_User_Defaults.Disable_For_Duels = AP_Defaults.Disable_For_Duels;
			end
			AP_Player_Config[AP_PlayerName..":"..AP_ServerName].Disable_For_Duels = AP_User_Defaults.Disable_For_Duels;
		end
		-- Add defaults for new "PvP Only" checkbox (which will exist someday, I hope)
		if not (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].PVP_Only) then
			if not (AP_User_Defaults.PVP_Only) then
				AP_User_Defaults.PVP_Only = AP_Defaults.PVP_Only;
			end
			AP_Player_Config[AP_PlayerName..":"..AP_ServerName].PVP_Only = AP_User_Defaults.PVP_Only;
		end
		-- Add defaults for new "SoulStones" checkbox
		if not (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].SoulStoneEnabled) then
			if not (AP_User_Defaults.SoulStoneEnabled) then
				AP_User_Defaults.SoulStoneEnabled = AP_Defaults.SoulStoneEnabled;
			end
			AP_Player_Config[AP_PlayerName..":"..AP_ServerName].SoulStoneEnabled = AP_User_Defaults.SoulStoneEnabled;
		end
		--Set up list order: Standard(0) or Reversed(1)
		AP_OrderList(AP_Player_Config[AP_PlayerName..":"..AP_ServerName].ReverseOrder);
	end
	--If, by chance, some other event gets passed before UNIT_NAME_UPDATE, then we won't have a name yet
	--This is my super-duper double-check on the player's name, server, and class.
	local playerName = UnitName("player");
	if (playerName == nil) or (playerName ==  UNKNOWNOBJECT) or (playerName == UNKNOWNBEING) or 
	(AP_ServerName == nil) or (AP_ServerName == "") or
	(AP_PlayerClass == nil) or (AP_PlayerClass == "") then
		AP_PlayerName="";
	end
	if (AP_PlayerName=="") then
		AutoPotion_OnEvent("UNIT_NAME_UPDATE");
		return;
	end
	
	-- Is AutoPotion enabled?
	if (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].AutoPotion_Enabled == 0) then
		return;
	end
		
	--Is the player channelling a spell?
	--(For channelled spells, the mana is deducted before the spell
	--has finished casting.  We don't want to cancel channeled spells
	--by drinking a mana potion.)
	if (event=="SPELLCAST_CHANNEL_START") then
		AP_Channelling = 1;
	end
	if (event=="SPELLCAST_STOP") then
		if (AP_Channelling==1) then
			if (AP_FirstStop==0) then
				AP_FirstStop = 1;
			else
				AP_FirstStop = 0;
				AP_Channelling = 0;
			end
		end
	end
	
	--If the player is a hunter, is the player feigning death?
	--(When a player feigns death, he appears to have no health.  We don't want
	--to cancel feigning death by drinking potions or using items, so we 
	--temporarily disable AutoPotion while the player is feigning death.)
	if (string.lower(AP_PlayerClass) == string.lower(AUTOPOTION_HUNTER_CLASS)) then
		AP_Feigning = AutoPotion_CheckFeign();
	end
	if (AP_Feigning == 1) then
		return;
	end
	
	-- Druid shapeshifting passes mana events before Auras Changed.
	if (event=="PLAYER_AURAS_CHANGED") or (AP_ManaIsLow()) then
		-- If the player is a class that can use interruptible buffs (eg rogues with vanish), or can't use items while buffed (eg druids while shapeshifted)
		-- then is the player using such a buff right now?
		local thisClass = string.lower(AP_PlayerClass);
		if (AUTOPOTION_DISABLE_AP_BUFFS[thisClass] ~= nil) then
			AP_DisableForBuff = AutoPotion_CheckForInterruptibleBuffs();
		end
	end
	-- If the player is using an interruptible buff, or a buff that prevents item-usage, then leave
	if (AP_DisableForBuff == 1) then
		return;
	end
	if (event=="PLAYER_AURAS_CHANGED") then
		-- Check if the player is recently bandaged or DoT-debuffed.
		if (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].BandageEnabled == 1) then
			AP_RecentlyBandaged = AutoPotion_CheckForRecentlyBandaged();
			AP_DisableBandageForDebuff = AutoPotion_CheckForDebuffsToDisableBandages();
		end
	end
	
	--Is the player dueling?
	if (UnitName("target") ~= nil)
	and (UnitCanAttack("player", "target"))
	and (UnitIsPlayer("target"))
	and (UnitFactionGroup("target") == UnitFactionGroup("player")) then
			AP_Dueling = 1;
	end
	--Is the player in combat?
	--(We don't want to go drinking potions or using stones when
	--the player isn't in combat, since the player's natural regeneration
	--will take care of his health and mana.)
	if (event == "PLAYER_REGEN_DISABLED") then
		AP_InCombat = 1;
	elseif (event == "PLAYER_REGEN_ENABLED") then
		AP_InCombat = 0;
		AP_Dueling = 0;
	end
	--If the player is dueling, then call the whole thing off
	if (AP_Dueling == 1) and (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].Disable_For_Duels == 1) then
		return;
	end
	--If player isn't in combat then call the whole thing off (unless bandages are enabled):
	if (AP_InCombat == 0) then
		--Special case for bandages:
		if (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].AutoPotion_Enabled == 1) then 
				AP_ApplyBandage();
		end
		return;
	end

	-- If we've made it this far, then all checks passed.  Time to take action!
	AP_DrinkRejuv();
	AP_UseHealthStone();
	AP_DrinkHealing();
	AP_UseCrystal();
	AP_DrinkMana();
	AP_UseSoulStone();
	-- If player has enabled bandages in combat, then apply a bandage
	if (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].BandageInCombat == 1) then
		AP_ApplyBandage();
	end
end

-- Create Lists based on ReverseOrder setting
function AP_OrderList(order)
	--(item lists are defined in localization.lua)
	if (order ==0) then
		AP_SmartRejuvList = AUTOPOTION_SMARTREJUV_LIST;
		AP_RejuvPotions = AUTOPOTION_REJUV_LIST;
		AP_HealthPotions = AUTOPOTION_HEALING_LIST;
		AP_HealthStones = AUTOPOTION_HEALTHSTONE_LIST;
		AP_ManaPotions = AUTOPOTION_MANA_LIST;
		AP_ManaCrystals = AUTOPOTION_MANACRYSTAL_LIST;
		AP_Bandages = AUTOPOTION_BANDAGE_LIST;
		AP_SoulStones = AUTOPOTION_SOULSTONE_LIST;
	else
		AP_SmartRejuvList = AP_Reverse(AUTOPOTION_SMARTREJUV_LIST);
		AP_RejuvPotions = AP_Reverse(AUTOPOTION_REJUV_LIST);
		AP_HealthPotions = AP_Reverse(AUTOPOTION_HEALING_LIST);
		AP_HealthStones = AP_Reverse(AUTOPOTION_HEALTHSTONE_LIST);
		AP_ManaPotions = AP_Reverse(AUTOPOTION_MANA_LIST);
		AP_ManaCrystals = AP_Reverse(AUTOPOTION_MANACRYSTAL_LIST);
		AP_Bandages = AP_Reverse(AUTOPOTION_BANDAGE_LIST);
		AP_SoulStones = AP_Reverse(AUTOPOTION_SOULSTONE_LIST);
	end
end

-- Check to see if player is feigning death
function AutoPotion_CheckFeign()
	for Counter = 1, MIRRORTIMER_NUMTIMERS, 1 do
		local MirrorTimerDialog = getglobal("MirrorTimer" .. Counter);
		if MirrorTimerDialog:IsVisible() then
			if( MirrorTimerDialog.timer == "FEIGNDEATH" ) then
				return 1;
			end
		else
			if (AP_Feigning == 1) then
				AP_LastAction = GetTime();
			end
			return 0;
		end
	end
end

-- Check for interruptible buffs.
function AutoPotion_CheckForInterruptibleBuffs()
	local thisClass = string.lower(AP_PlayerClass);
	-- Is the player using a buff that we don't want to interrupt?			
	for i=1,table.getn(AUTOPOTION_DISABLE_AP_BUFFS[thisClass]) do
		if (AP_PlayerBuffName(AUTOPOTION_DISABLE_AP_BUFFS[thisClass][i])) then
			return 1;
		end
	end
	if (AP_DisableForBuff == 1) then
		AP_LastAction = GetTime();
	end
	return 0;
end

-- Check for various debuffs that should disable bandages
function AutoPotion_CheckForDebuffsToDisableBandages()
	-- Is the player debuffed in a way that should disable bandaging?
	for i=1,table.getn(AUTOPOTION_DISABLE_BANDAGE_DEBUFF_TYPES) do
		if (AP_PlayerDebuffType(AUTOPOTION_DISABLE_BANDAGE_DEBUFF_TYPES[i])) then
			return 1;
		end
	end
	return 0;
end
-- Check for Recently Bandaged
function AutoPotion_CheckForRecentlyBandaged()
	if (AP_PlayerDebuffName(AUTOPOTION_BANDAGE_COOLDOWN_DEBUFF)) then
		return 1;
	end
	return 0;
end
--*****************************************************************************
--Item-use functions:
--*****************************************************************************
----------------------------
--Drink Rejuv---------------
----------------------------
function AP_DrinkRejuv()
	if (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].RejuvEnabled == 0)
	or (AP_Channelling==1) then
		return;
	end
	
	if (AP_HealthIsLow()) and (AP_ManaIsLow()) then
		if (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].SmartRejuvEnabled == 1) then
			AP_UseGeneric(AP_SmartRejuvList,"Potion");
		else
			AP_UseGeneric(AP_RejuvPotions,"Potion");
		end
	end
	return;
end
----------------------------
--Use HealthStone-----------
----------------------------
function AP_UseHealthStone()
	if (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].StoneEnabled == 0) then
		return;
	end
	
	if AP_HealthIsLow() then
		AP_UseGeneric(AP_HealthStones,"Stone");
	end
	return;
end
----------------------------
--Drink Healing-------------
----------------------------
function AP_DrinkHealing()
	if (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].HealthEnabled == 0) then
		return;
	end
	
	if AP_HealthIsLow() then
		AP_UseGeneric(AP_HealthPotions,"Potion");
	end
	return;
end
----------------------------
--Use Mana Crystal----------
----------------------------
function AP_UseCrystal()
	if (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].CrystalEnabled == 0) 
	or (AP_Channelling==1) then
		return;
	end

	if AP_ManaIsLow() then
			AP_UseGeneric(AP_ManaCrystals,"Stone");
	end
	return;
end
----------------------------
--Use SoulStone-----------
----------------------------
function AP_UseSoulStone()
	if (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].SoulStoneEnabled == 0) then
		return;
	end
	
	if AP_HealthIsLow() then
		AP_UseGeneric(AP_SoulStones,"SoulStone");
	end
	return;
end
----------------------------
--Drink Mana----------------
----------------------------
function AP_DrinkMana()
	-- Some classes don't have mana, so if the player is one of those classes, then leave.
	-- If the player is channeling a spell, then leave.
	if (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].ManaEnabled == 0) 
	or (AP_NonManaClass == 1) 
	or (AP_Channelling==1) then
		return;
	end
	
	if AP_ManaIsLow() then
		AP_UseGeneric(AP_ManaPotions,"Potion");
	end
	return;
end
----------------------------
--Apply Bandage-------------
----------------------------
function AP_ApplyBandage()
	if (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].BandageEnabled == 0)
	or ( (AP_DisableBandageForDebuff == 1) and (BandageWhenDoT == 0) )
	or (AP_RecentlyBandaged == 1) then
		return;
	end
	
	if (AP_HealthIsLow()) then
		AP_UseGeneric(AP_Bandages,"Bandage");
	end
	return;
end
----------------------------
--Check health and mana-----
----------------------------
function AP_HealthIsLow()
	--Convert player health to percentage and check if it's less
	--than the defined AP_Player_Config[AP_PlayerName..":"..AP_ServerName].HealthTrigger value:
	if (((UnitHealth("player")/UnitHealthMax("player"))*100)<AP_Player_Config[AP_PlayerName..":"..AP_ServerName].HealthTrigger) then
		return true;
	else
		return false;
	end
end
function AP_ManaIsLow()
	--Convert player mana to percentage and check if it's less
	--than the defined AP_Player_Config[AP_PlayerName..":"..AP_ServerName].ManaTrigger value:
	if (((UnitMana("player")/UnitManaMax("player"))*100)<AP_Player_Config[AP_PlayerName..":"..AP_ServerName].ManaTrigger) then
		return true;
	else
		return false;
	end
end
----------------------------
--Generic Use---------------
----------------------------
function AP_UseGeneric(List,Type)
	--Check to see if CoolDownTime has passed:
	if (GetTime() - AP_LastAction > AP_ActionCoolDown) then
		--Loop through list:
		for idx,item in List do
			--Look for the item in the player's inventory.
			--If found, use it, reset the timer, and then stop looking.
			if APUseByName_Execute(item) then 
				if (Type == "Bandage") then
					SpellTargetUnit("player");
				elseif (Type == "SoulStone") then
					SpellTargetUnit("player");
				end
				AP_LastAction = GetTime();
				return true;
			end
		end
	end
	return false;
end

---------------------------------------------------
--SlashCmd Function:-------------------------------
---------------------------------------------------
function AutoPotion_SlashCmd(msg)
	if (msg==nil) then
		msg = "";
	end
	msg = string.lower(msg);
--/ap on
	if (msg == AUTOPOTION_ENABLE_COMMAND) then
		AUTOPOTION_AP_ENABLED_CHECKBT_UPDATE(1);
		AP_ChatMessage(AUTOPOTION_ENABLEDISABLE_MESSAGE..AUTOPOTION_ENABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
	return;
	end
--/ap off
	if (msg == AUTOPOTION_DISABLE_COMMAND) then
		AUTOPOTION_AP_ENABLED_CHECKBT_UPDATE(0);
		AP_ChatMessage(AUTOPOTION_ENABLEDISABLE_MESSAGE..AUTOPOTION_DISABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
	return;
	end
--/ap toggle
	if (msg == AUTOPOTION_TOGGLE_COMMAND) then
		if (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].AutoPotion_Enabled == 0) then
			AUTOPOTION_AP_ENABLED_CHECKBT_UPDATE(1);
			AP_ChatMessage(AUTOPOTION_ENABLEDISABLE_MESSAGE..AUTOPOTION_ENABLE_MESSAGE, 1.0, 1.0, 0.0);
		elseif (AP_Player_Config[AP_PlayerName..":"..AP_ServerName].AutoPotion_Enabled == 1) then
			AUTOPOTION_AP_ENABLED_CHECKBT_UPDATE(0);
			AP_ChatMessage(AUTOPOTION_ENABLEDISABLE_MESSAGE..AUTOPOTION_DISABLE_MESSAGE, 1.0, 1.0, 0.0);
		end
		AutoPotion_RefreshDialog();
	return;
	end
--/ap duels on/off
	if (msg == AUTOPOTION_DUELS_COMMAND..AUTOPOTION_ENABLE_COMMAND) then
		AUTOPOTION_AP_DISABLEFORDUELS_CHECKBT_UPDATE(1);
		AP_ChatMessage(AUTOPOTION_DUELS_MESSAGE..AUTOPOTION_ENABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	elseif (msg == AUTOPOTION_DUELS_COMMAND..AUTOPOTION_DISABLE_COMMAND) then
		AUTOPOTION_AP_DISABLEFORDUELS_CHECKBT_UPDATE(0);
		AP_ChatMessage(AUTOPOTION_DUELS_MESSAGE..AUTOPOTION_DISABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	end
--/ap reverse
	if (msg == AUTOPOTION_REVERSEORDER_COMMAND) then
		AUTOPOTION_REVERSEORDER_CHECKBT_UPDATE(1);
		AP_ChatMessage(AUTOPOTION_REVERSEORDER_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	end
--/ap normal
	if (msg == AUTOPOTION_NORMALORDER_COMMAND) then
		AUTOPOTION_REVERSEORDER_CHECKBT_UPDATE(0);
		AP_ChatMessage(AUTOPOTION_NORMALORDER_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	end
--/ap healthpercent <number>
	if (string.sub(msg,1,string.len(AUTOPOTION_HEALTHTRIGGER_COMMAND)) == string.lower(AUTOPOTION_HEALTHTRIGGER_COMMAND)) then
		local healthTrigger = string.sub(msg,string.len(AUTOPOTION_HEALTHTRIGGER_COMMAND)+2);
		if (tonumber(healthTrigger)) then
			healthTrigger = tonumber(healthTrigger);
			if (healthTrigger >= 0) and (healthTrigger <= 100) then
				AUTOPOTION_HEALTHTRIGGER_SLIDER_UPDATE(healthTrigger);
				AutoPotion_RefreshDialog();
				return;
			end
		end
		AP_ChatMessage(AUTOPOTION_HEALTHTRIGGER_MESSAGE..AUTOPOTION_BADPERCENT_MESSAGE, 1.0, 0.0, 0.0);
		return;
	end
--/ap manapercent <number>
	if (string.sub(msg,1,string.len(AUTOPOTION_MANATRIGGER_COMMAND)) == string.lower(AUTOPOTION_MANATRIGGER_COMMAND)) then
		local manaTrigger = string.sub(msg,string.len(AUTOPOTION_MANATRIGGER_COMMAND)+2);
		if (tonumber(manaTrigger)) then
			manaTrigger = tonumber(manaTrigger);
			if (manaTrigger >= 0) and (manaTrigger <= 100) then
				AUTOPOTION_MANATRIGGER_SLIDER_UPDATE(manaTrigger);
				AutoPotion_RefreshDialog();
				return;
			end
		end
		AP_ChatMessage(AUTOPOTION_MANATRIGGER_MESSAGE..AUTOPOTION_BADPERCENT_MESSAGE, 1.0, 0.0, 0.0);
		return;
	end
--/ap healthstones on/off
	if (msg == AUTOPOTION_HEALTHSTONE_COMMAND..AUTOPOTION_ENABLE_COMMAND) then
		AUTOPOTION_STONES_ENABLED_CHECKBT_UPDATE(1);
		AP_ChatMessage(AUTOPOTION_HEALTHSTONE_MESSAGE..AUTOPOTION_ENABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	elseif (msg == AUTOPOTION_HEALTHSTONE_COMMAND..AUTOPOTION_DISABLE_COMMAND) then
		AUTOPOTION_STONES_ENABLED_CHECKBT_UPDATE(0);
		AP_ChatMessage(AUTOPOTION_HEALTHSTONE_MESSAGE..AUTOPOTION_DISABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	end
--/ap manastones on/off
	if (msg == AUTOPOTION_MANASTONE_COMMAND..AUTOPOTION_ENABLE_COMMAND) then
		AUTOPOTION_CRYSTALS_ENABLED_CHECKBT_UPDATE(1);
		AP_ChatMessage(AUTOPOTION_MANASTONE_MESSAGE..AUTOPOTION_ENABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	elseif (msg == AUTOPOTION_MANASTONE_COMMAND..AUTOPOTION_DISABLE_COMMAND) then
		AUTOPOTION_CRYSTALS_ENABLED_CHECKBT_UPDATE(0);
		AP_ChatMessage(AUTOPOTION_MANASTONE_MESSAGE..AUTOPOTION_DISABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	end
--/ap soulstones on/off
	if (msg == AUTOPOTION_SOULSTONE_COMMAND..AUTOPOTION_ENABLE_COMMAND) then
		AUTOPOTION_SOULSTONES_ENABLED_CHECKBT_UPDATE(1);
		AP_ChatMessage(AUTOPOTION_SOULSTONE_MESSAGE..AUTOPOTION_ENABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	elseif (msg == AUTOPOTION_SOULSTONE_COMMAND..AUTOPOTION_DISABLE_COMMAND) then
		AUTOPOTION_SOULSTONES_ENABLED_CHECKBT_UPDATE(0);
		AP_ChatMessage(AUTOPOTION_SOULSTONE_MESSAGE..AUTOPOTION_DISABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	end
--/ap rejuvs on/off
	if (msg == AUTOPOTION_REJUV_COMMAND..AUTOPOTION_ENABLE_COMMAND) then
		AUTOPOTION_REJUVENATION_ENABLED_CHECKBT_UPDATE(1);
		AP_ChatMessage(AUTOPOTION_REJUV_MESSAGE..AUTOPOTION_ENABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	elseif (msg == AUTOPOTION_REJUV_COMMAND..AUTOPOTION_DISABLE_COMMAND) then
		AUTOPOTION_REJUVENATION_ENABLED_CHECKBT_UPDATE(0);
		AP_ChatMessage(AUTOPOTION_REJUV_MESSAGE..AUTOPOTION_DISABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	end
--/ap smartrejuv on/off
	if (msg == AUTOPOTION_SMARTREJUV_COMMAND..AUTOPOTION_ENABLE_COMMAND) then
		AUTOPOTION_SMARTREJUV_ENABLED_CHECKBT_UPDATE(1);
		AP_ChatMessage(AUTOPOTION_SMARTREJUV_MESSAGE..AUTOPOTION_ENABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	elseif (msg == AUTOPOTION_SMARTREJUV_COMMAND..AUTOPOTION_DISABLE_COMMAND) then
		AUTOPOTION_SMARTREJUV_ENABLED_CHECKBT_UPDATE(0);
		AP_ChatMessage(AUTOPOTION_SMARTREJUV_MESSAGE..AUTOPOTION_DISABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	end
--/ap healpots on/off
	if (msg == AUTOPOTION_HEALING_COMMAND..AUTOPOTION_ENABLE_COMMAND) then
		AUTOPOTION_HEALTHPOTIONS_ENABLED_CHECKBT_UPDATE(1);
		AP_ChatMessage(AUTOPOTION_HEALING_MESSAGE..AUTOPOTION_ENABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	elseif (msg == AUTOPOTION_HEALING_COMMAND..AUTOPOTION_DISABLE_COMMAND) then
		AUTOPOTION_HEALTHPOTIONS_ENABLED_CHECKBT_UPDATE(0);
		AP_ChatMessage(AUTOPOTION_HEALING_MESSAGE..AUTOPOTION_DISABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	end
--/ap manapots on/off
	if (msg == AUTOPOTION_MANA_COMMAND..AUTOPOTION_ENABLE_COMMAND) then
		AUTOPOTION_MANAPOTIONS_ENABLED_CHECKBT_UPDATE(1);
		AP_ChatMessage(AUTOPOTION_MANA_MESSAGE..AUTOPOTION_ENABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	elseif (msg == AUTOPOTION_MANA_COMMAND..AUTOPOTION_DISABLE_COMMAND) then
		AUTOPOTION_MANAPOTIONS_ENABLED_CHECKBT_UPDATE(0);
		AP_ChatMessage(AUTOPOTION_MANA_MESSAGE..AUTOPOTION_DISABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	end
--/ap bandages on/off
	if (msg == AUTOPOTION_BANDAGE_COMMAND..AUTOPOTION_ENABLE_COMMAND) then
		AUTOPOTION_BANDAGES_ENABLED_CHECKBT_UPDATE(1);
		AP_ChatMessage(AUTOPOTION_BANDAGE_MESSAGE..AUTOPOTION_ENABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	elseif (msg == AUTOPOTION_BANDAGE_COMMAND..AUTOPOTION_DISABLE_COMMAND) then
		AUTOPOTION_BANDAGES_ENABLED_CHECKBT_UPDATE(0);
		AP_ChatMessage(AUTOPOTION_BANDAGE_MESSAGE..AUTOPOTION_DISABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	end
--/ap combatbandages on/off
	if (msg == AUTOPOTION_COMBATBANDAGE_COMMAND..AUTOPOTION_ENABLE_COMMAND) then
		AUTOPOTION_COMBATBANDAGES_ENABLED_CHECKBT_UPDATE(1);
		AP_ChatMessage(AUTOPOTION_COMBATBANDAGE_MESSAGE..AUTOPOTION_ENABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	elseif (msg == AUTOPOTION_COMBATBANDAGE_COMMAND..AUTOPOTION_DISABLE_COMMAND) then
		AUTOPOTION_COMBATBANDAGES_ENABLED_CHECKBT_UPDATE(0);
		AP_ChatMessage(AUTOPOTION_COMBATBANDAGE_MESSAGE..AUTOPOTION_DISABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	end
--/ap dotbandages on/off
	if (msg == AUTOPOTION_DOTBANDAGE_COMMAND..AUTOPOTION_ENABLE_COMMAND) then
		AUTOPOTION_DOTBANDAGES_ENABLED_CHECKBT_UPDATE(1);
		AP_ChatMessage(AUTOPOTION_DOTBANDAGE_MESSAGE..AUTOPOTION_ENABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	elseif (msg == AUTOPOTION_DOTBANDAGE_COMMAND..AUTOPOTION_DISABLE_COMMAND) then
		AUTOPOTION_DOTBANDAGES_ENABLED_CHECKBT_UPDATE(0);
		AP_ChatMessage(AUTOPOTION_DOTBANDAGE_MESSAGE..AUTOPOTION_DISABLE_MESSAGE, 1.0, 1.0, 0.0);
		AutoPotion_RefreshDialog();
		return;
	end
--/ap defaults
	if (msg == AUTOPOTION_USEDEFAULTS_COMMAND) then
		AUTOPOTION_DEFAULTS_BUTTON_UPDATE();
		AP_ChatMessage(AUTOPOTION_USEDEFAULTS_MESSAGE, 1.0, 1.0, 0.0);
		return;
	end
--/ap savedefaults
	if (msg == AUTOPOTION_SAVEDEFAULTS_COMMAND) then
		AUTOPOTION_SAVE_DEFAULTS_BUTTON_UPDATE();
		AP_ChatMessage(AUTOPOTION_SAVEDEFAULTS_MESSAGE, 1.0, 1.0, 0.0);
		return;
	end
--If there's no command, toggle config dialog:
	if (msg == "") then
		if (AutoPotion_ConfigDg:IsVisible() ~= 1) then
			ShowUIPanel(AutoPotion_ConfigDg);
			--AutoPotion_ConfigDg:Show();
			--AP_DialogIsOpen = 1;
			AP_ChatMessage(AUTOPOTION_SLASHUSAGE_MESSAGE, 1.0, 1.0, 0.0);
		else
			HideUIPanel(AutoPotion_ConfigDg);
			--AutoPotion_ConfigDg:Hide();
			--AP_DialogIsOpen = 0;
		end
		return;
	end
--If the message is anything else, display help:
	for i=1,table.getn(AUTOPOTION_HELP_MESSAGE) do
		AP_ChatMessage(AUTOPOTION_HELP_MESSAGE[i], 1.0, 1.0, 0.0);
	end
	return;
end

function AutoPotion_RefreshDialog()
	if (AutoPotion_ConfigDg:IsVisible() == 1) then
		HideUIPanel(AutoPotion_ConfigDg);
		ShowUIPanel(AutoPotion_ConfigDg);
		--AutoPotion_ConfigDg:Hide();
		--AutoPotion_ConfigDg:Show();
	end
end

--*****************************************************************************
--Configuration options:
--UI widgets call "<widgetName>_UPDATE" functions when the user updates them
--UI widgets call "<widgetName>_GETSTATE" function when they are shown
--This functionality is defined in the Script nodes of the 
--widget templates in the autopotion.xml file.
--*****************************************************************************
-----------------------------
--Enable/Disable AutoPotion--
-----------------------------
function AUTOPOTION_AP_ENABLED_CHECKBT_UPDATE(whatValue)
	if (whatValue == 1) then
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].AutoPotion_Enabled = 1;
	else
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].AutoPotion_Enabled = 0;
	end
end
function AUTOPOTION_AP_ENABLED_CHECKBT_GETSTATE()
	return AP_Player_Config[AP_PlayerName..":"..AP_ServerName].AutoPotion_Enabled;
end
-----------------------------
--AutoPotion Language Dropdown--
-----------------------------
function AUTOPOTION_LANGUAGE_MENU_INIT()
	local info = {};
	local selectedIdx = 1;
	for i=1,table.getn(AP_LangList) do
		info.text = AP_LangList[i];
		info.func = AUTOPOTION_LANGUAGE_MENU_ONCLICK;
		if (info.text == AP_Lang) then
			selectedIdx = i;
			info.checked = 1;
		end
		UIDropDownMenu_AddButton(info);
	end
	UIDropDownMenu_SetSelectedID(AUTOPOTION_LANGUAGE_MENU,selectedIdx);	
end
function AUTOPOTION_LANGUAGE_MENU_ONCLICK()
	local selectedIdx = this:GetID();
	UIDropDownMenu_SetSelectedID(AUTOPOTION_LANGUAGE_MENU, selectedIdx);
	AP_Lang = this:GetText();
	getglobal("AUTOPOTION_"..AP_Lang)();
	AutoPotion_RefreshDialog();
end
-------------------------
--Disable for Duels--
-------------------------
function AUTOPOTION_AP_DISABLEFORDUELS_CHECKBT_UPDATE(whatValue)
	if (whatValue==1) then
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].Disable_For_Duels = 1;
	else
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].Disable_For_Duels = 0;
	end
end
function AUTOPOTION_AP_DISABLEFORDUELS_CHECKBT_GETSTATE()
	return AP_Player_Config[AP_PlayerName..":"..AP_ServerName].Disable_For_Duels;
end
-------------------------
--Forward/Reverse Order--
-------------------------
function AUTOPOTION_REVERSEORDER_CHECKBT_UPDATE(whatValue)
	if (whatValue==1) then
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].ReverseOrder = 1;
	else
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].ReverseOrder = 0;
	end
	AP_OrderList(AP_Player_Config[AP_PlayerName..":"..AP_ServerName].ReverseOrder);
end
function AUTOPOTION_REVERSEORDER_CHECKBT_GETSTATE()
	return AP_Player_Config[AP_PlayerName..":"..AP_ServerName].ReverseOrder;
end
----------------------
--Set Health Trigger--
----------------------
function AUTOPOTION_HEALTHTRIGGER_SLIDER_UPDATE(whatValue)
	AP_Player_Config[AP_PlayerName..":"..AP_ServerName].HealthTrigger = whatValue;
end
function AUTOPOTION_HEALTHTRIGGER_SLIDER_GETSTATE()
	return AP_Player_Config[AP_PlayerName..":"..AP_ServerName].HealthTrigger;
end
--------------------
--Set Mana Trigger--
--------------------
function AUTOPOTION_MANATRIGGER_SLIDER_UPDATE(whatValue)
	AP_Player_Config[AP_PlayerName..":"..AP_ServerName].ManaTrigger = whatValue;
end
function AUTOPOTION_MANATRIGGER_SLIDER_GETSTATE()
	return AP_Player_Config[AP_PlayerName..":"..AP_ServerName].ManaTrigger;
end
-------------------------------
--Enable/Disable Healthstones--
-------------------------------
function AUTOPOTION_STONES_ENABLED_CHECKBT_UPDATE(whatValue)
	if (whatValue == 1) then
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].StoneEnabled = 1;
	else
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].StoneEnabled = 0;
	end
end
function AUTOPOTION_STONES_ENABLED_CHECKBT_GETSTATE()
	return AP_Player_Config[AP_PlayerName..":"..AP_ServerName].StoneEnabled;
end
--------------------------------
--Enable/Disable Mana Crystals--
--------------------------------
function AUTOPOTION_CRYSTALS_ENABLED_CHECKBT_UPDATE(whatValue)
	if (whatValue == 1) then
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].CrystalEnabled = 1;
	else
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].CrystalEnabled = 0;
	end
end
function AUTOPOTION_CRYSTALS_ENABLED_CHECKBT_GETSTATE()
	return AP_Player_Config[AP_PlayerName..":"..AP_ServerName].CrystalEnabled;
end
-------------------------------
--Enable/Disable Soulstones--
-------------------------------
function AUTOPOTION_SOULSTONES_ENABLED_CHECKBT_UPDATE(whatValue)
	if (whatValue == 1) then
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].SoulStoneEnabled = 1;
	else
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].SoulStoneEnabled = 0;
	end
end
function AUTOPOTION_SOULSTONES_ENABLED_CHECKBT_GETSTATE()
	return AP_Player_Config[AP_PlayerName..":"..AP_ServerName].SoulStoneEnabled;
end
-----------------------------------
--Enable/Disable Rejuv Triggering--
-----------------------------------
function AUTOPOTION_REJUVENATION_ENABLED_CHECKBT_UPDATE(whatValue)
	if (whatValue==1) then
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].RejuvEnabled = 1;
	else
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].RejuvEnabled = 0;
	end
end
function AUTOPOTION_REJUVENATION_ENABLED_CHECKBT_GETSTATE()
	return AP_Player_Config[AP_PlayerName..":"..AP_ServerName].RejuvEnabled;
end
-------------------------------------
--Enable/Disable Smart Rejuvenation--
-------------------------------------
function AUTOPOTION_SMARTREJUV_ENABLED_CHECKBT_UPDATE(whatValue)
	if (whatValue==1) then
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].SmartRejuvEnabled = 1;
	else
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].SmartRejuvEnabled = 0;
	end
end
function AUTOPOTION_SMARTREJUV_ENABLED_CHECKBT_GETSTATE()
	return AP_Player_Config[AP_PlayerName..":"..AP_ServerName].SmartRejuvEnabled;
end
------------------------------------
--Enable/Disable Healing Potions--
------------------------------------
function AUTOPOTION_HEALTHPOTIONS_ENABLED_CHECKBT_UPDATE(whatValue)
	if (whatValue==1) then
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].HealthEnabled = 1;
	else
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].HealthEnabled = 0;
	end
end
function AUTOPOTION_HEALTHPOTIONS_ENABLED_CHECKBT_GETSTATE()
	return AP_Player_Config[AP_PlayerName..":"..AP_ServerName].HealthEnabled;
end
-------------------------------
--Enable/Disable Mana Potions--
-------------------------------
function AUTOPOTION_MANAPOTIONS_ENABLED_CHECKBT_UPDATE(whatValue)
	if (whatValue==1) then
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].ManaEnabled = 1;
	else
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].ManaEnabled = 0;
	end
end
function AUTOPOTION_MANAPOTIONS_ENABLED_CHECKBT_GETSTATE()
	return AP_Player_Config[AP_PlayerName..":"..AP_ServerName].ManaEnabled;
end
---------------------------
--Enable/Disable Bandages--
---------------------------
function AUTOPOTION_BANDAGES_ENABLED_CHECKBT_UPDATE(whatValue)
	if (whatValue==1) then
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].BandageEnabled = 1;
	else
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].BandageEnabled = 0;
	end
end
function AUTOPOTION_BANDAGES_ENABLED_CHECKBT_GETSTATE()
	return AP_Player_Config[AP_PlayerName..":"..AP_ServerName].BandageEnabled;
end
---------------------------
--Enable/Disable In-Combat Bandages--
---------------------------
function AUTOPOTION_COMBATBANDAGES_ENABLED_CHECKBT_UPDATE(whatValue)
	if (whatValue==1) then
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].BandageInCombat = 1;
	else
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].BandageInCombat = 0;
	end
end
function AUTOPOTION_COMBATBANDAGES_ENABLED_CHECKBT_GETSTATE()
	return AP_Player_Config[AP_PlayerName..":"..AP_ServerName].BandageInCombat;
end
---------------------------
--Enable/Disable DoT Bandages--
---------------------------
function AUTOPOTION_DOTBANDAGES_ENABLED_CHECKBT_UPDATE(whatValue)
	if (whatValue==1) then
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].BandageWhenDoT = 1;
	else
		AP_Player_Config[AP_PlayerName..":"..AP_ServerName].BandageWhenDoT = 0;
	end
end
function AUTOPOTION_DOTBANDAGES_ENABLED_CHECKBT_GETSTATE()
	return AP_Player_Config[AP_PlayerName..":"..AP_ServerName].BandageWhenDoT;
end
-----------------------------------------------------
--Reset all configuration options to default values--
-----------------------------------------------------
function AUTOPOTION_DEFAULTS_BUTTON_UPDATE()
	AP_Player_Config[AP_PlayerName..":"..AP_ServerName] = TableCopy(AP_User_Defaults);
	AutoPotion_RefreshDialog();
end
-----------------------------------------------------
--Save user-modified default values--
-----------------------------------------------------
function AUTOPOTION_SAVE_DEFAULTS_BUTTON_UPDATE()
	AP_User_Defaults = TableCopy(AP_Player_Config[AP_PlayerName..":"..AP_ServerName]);
end
-----------------------------------------------------
--Close AutoPotion dialog--
-----------------------------------------------------
function AUTOPOTION_CLOSE_BUTTON_UPDATE()
	AutoPotion_SlashCmd();
end


--*****************************************************************************
--Secondary functions for displaying feedback, processing lists,
--recursing through player buffs and inventory, etc.
--*****************************************************************************
-------------------------------
--AP_ChatMessage Function:-----
-------------------------------
--Code swiped from Rauen's PetAttack
-------------------------------
function AP_ChatMessage(message,r,g,b)
	ChatFrame1:AddMessage(message,r,g,b);
end
--------------------------------
--UseByName_Execute Function:---
--------------------------------
--Iterate through bag slots to find the named item.
--If it exists, use it.
--Code swiped (and slightly modified) from Int's UseByName
-------------------------------
function APUseByName_Execute(msg)
  local item = string.lower(msg);
  for i=0, NUM_BAG_FRAMES do
    for j=1, GetContainerNumSlots(i) do
    	if (string.lower(APUseByName_GetItemName(i,j)) == item) then
				if (GetContainerItemCooldown(i,j) == 0) then
					UseContainerItem(i,j);
					return true;
				end
			end
    end
  end
  return false;
end
------------------------------------
--UseByName_GetItemName Function:---
------------------------------------
--Used by UseByName_Execute to get the link text of the item
--in the current bag,slot
--Then return the link text if it exists
--Code swiped from Int's UseByName
------------------------------------
function APUseByName_GetItemName(bag, slot)
  local linktext = nil;
  
  if (bag == -1) then
  	linktext = GetInventoryItemLink("player", slot);
  else
  	linktext = GetContainerItemLink(bag, slot);
  end

  if linktext then
    local _,_,name = string.find(linktext, "^.*%[(.*)%].*$");
    return name;
  else
    return "";
  end
end
------------------------------------
--TableCopy Function:---------------
------------------------------------
--Ripped directly from Mairelon's---
--Utility Classes-------------------
------------------------------------
function TableCopy(table1)
	local table2 = {};
	local index, value
		for index, value in pairs(table1) do
		local text = index .. " "
			if type(value) == "table" then
				table2[index] = TableCopy(value)
			else
				table2[index] = value
			end
		end
		return table2;
end
------------------------------------
--Buff Info Functions:---------------
------------------------------------
--Stolen from BuffStatus, reworked a little (very little)
--Returns true and the buff type if buff name is found
--otherwise returns false
--buffName should be a string: e.g. "vanish"
function AP_PlayerBuffName(buffName)
	buffName = string.lower(buffName)
	local i=1;
	while UnitBuff("player",i) do
		AutoPotion_Tooltip:SetUnitBuff( "player", i );
		local thisBuffName = AutoPotion_TooltipTextLeft1:GetText();
		if (thisBuffName == nil) then
			thisBuffName = "";
		end
		thisBuffName = string.lower(thisBuffName);
		if (string.find(thisBuffName,buffName)) then
			return true, AutoPotion_TooltipTextRight1:GetText();
		end
		i=i+1;
	end
	return false;
end
--Stolen from BuffStatus, reworked a little (very little)
--Returns true and the buff name if buff type is found
--otherwise returns false
--buffType should be a string: e.g. "poison", "magic"
function AP_PlayerBuffType(buffType)
	buffType = string.lower(buffType);
	local i = 1;
	while UnitBuff( "player", i ) do
		AutoPotion_Tooltip:SetUnitBuff( "player", i );
		local thisBuffType = AutoPotion_TooltipTextRight1:GetText();
		if (thisBuffType == nil) then
			thisBuffType = "";
		end
		thisBuffType = string.lower(thisBuffType);
		if thisBuffType == buffType then
			return true, AutoPotion_TooltipTextLeft1:GetText();
		end
		i = i + 1;
	end
	return false;
end
--Stolen from BuffStatus, reworked a little (very little)
--Returns true and the debuff type if debuff name is found
--otherwise returns false
--debuffName should be a string: e.g. "vanish"
function AP_PlayerDebuffName(debuffName)
	debuffName = string.lower(debuffName)
	local i=1;
	while UnitDebuff("player",i) do
		AutoPotion_Tooltip:SetUnitDebuff( "player", i );
		local thisDebuffName =AutoPotion_TooltipTextLeft1:GetText();
		if (thisDebuffName == nil) then
			thisDebuffName = "";
		end
		thisDebuffName = string.lower(thisDebuffName);
		if (string.find(thisDebuffName,debuffName)) then
			return true, AutoPotion_TooltipTextRight1:GetText();
		end
		i=i+1;
	end
	return false;
end
--Stolen from BuffStatus, reworked a little (very little)
--Returns true and the debuff name if debuff type is found
--otherwise returns false
--debuffType should be a string: e.g. "poison", "magic"
function AP_PlayerDebuffType(debuffType)
	debuffType = string.lower(debuffType);
	local i = 1;
	while UnitDebuff( "player", i ) do
		AutoPotion_Tooltip:SetUnitDebuff( "player", i );
		local thisDebuffType = AutoPotion_TooltipTextRight1:GetText();
		if (thisDebuffType == nil) then
			thisDebuffType = "";
		end
		thisDebuffType = string.lower(thisDebuffType);
		if thisDebuffType == debuffType then
			return true, AutoPotion_TooltipTextLeft1:GetText();
		end
		i = i + 1;
	end
	return false;
end
------------------------------------------
-- Reverse a list and return the result --
------------------------------------------
function AP_Reverse(l)
  local m = {}
  for i = table.getn(l), 1, -1 do table.insert(m, l[i]) end
  return m
end