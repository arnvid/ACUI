-- *******************************************************
-- 
-- ~ ScaleIt ++ MoveIt ++ HideIt ++ OpenIt == SiMiHiOi ~
-- 
-- What is it?
-- 	It allows permanent up or downscaling of the UI without
-- 	having to potch around in the Interface options.  It's
--    also for the scaling, moving and hiding of individual
--    interface elements.
--   
-- Why?
-- 	Simply because Blizzard didn't properly implement it,
-- 	it's nicer to have a slash command and upscaling is
-- 	wholly NOT possible through the Interface options, as
-- 	of now as far as I know, it can only be done via a
-- 	Macro.  I find this unacceptable, this is my solution.
--   
-- How?
-- 	Global scaling: /scaleit scale <value> where <value>
--		is anything from 0.5 to 2.0, I list those as sane
--		(safe) values which I have tested.  I've noticed that
--		this AddOn doesn't play nicely as an 'update', it
--		won't let the user set manual scales and it can spit
--		errors if something else tries to scale or use
--		scaling math, so instead I've set it to only run on
--		UI startup, otherwise it automatically triggers an
--		instance of ReloadUI().  That way it plays nicely
--		with manual scales and any AddOns that might make
--		use of scaling arithmetic.
--
--		Individual scaling: /scaleit <value> <option>, just
--		enter in scaleit for the lowdown.  The rules of global
--		scaling apply here too.  Sane values are 0.5 to 2.0
--		but you can try just about anything.
--
--		Individual moving: /moveit <value> <x or y>, as with
--		scaleit, it's just a matter of using /moveit to see
--		what's available.  This provides a by-pixel granular
--		accurate positioning system for many GUI elements
--		where X is vertical and Y is horizontal.
--
--		Individual hiding: /hideit <value> is a toggle, use
--		just /hideit to see what's available.
--
-- Caveats ...
-- 	Yes, there are some.  For my own reasons I haven't
-- 	placed in any safety checks, I won't patronize you,
-- 	you aren't dumb.  If you were, you wouldn't be
-- 	reading this, eh?  Thusly, you could scale 10.0
-- 	and this would be bad, very bad.  It would cause
-- 	the game to crash every time you load it.  Thusly
-- 	I cite here and for the record that sane values are
-- 	0.5 to 2.0 and those are the only ones you should
-- 	use.  Thems the breaks, literally.
-- 
-- Who?
-- 	Rowne.  I'm just this hard of sight Tauren, yanno?
--		Furthermore, I've received lots of aid.  I used
--		Kortalh's TalentReminder AddOn (which I honestly
--		recommend to anyone who even considers playing
--		World of Warcraft), Iriel and Mondinga who provided
--		me with the correct CVar.  In honesty, they did the
--		most work, one by providing me with the line of
--		code I need, the other by providing a well written
--		and documented AddOn.  All I did was patch the
--		relevant aspects together.
--
--		Fixes credits: Malvasius for the XP bar fix.
--
--		Contributor Credits: Mook for ... lots of things.
--		Look for the 'Added by Mook' section below to
--		see exactly what he's added.  Want your name in
--		here too?  Contribute stuff!  It's easier than
--		ya think and I'd love to see this become more of
--		a widespread community tool than just an average
--		AddOn, wot?
--
--		I borrowed Jooky's 'get player name' code too so
--		he gets contributor credits and major kudos for
--		making the only 'get player name' code I could
--		actually get to work for me.  His code makes so
--		much sense, it's so clean, organized and well
--		commented.  Jooky is a coding God, PRAISE HIM!
-- 
-- *******************************************************

-- Information about the AddOn.
-- First the version number.  P refers to Pass.
SIMIHIOI_VERSION = "2005.02.17.P5";
-- Then our most generous contributors.
-- Who I might add are probably smarter'n I.
SIMIHIOI_CONTRIBUTORS = "Mook";
-- More folks whom I suspect are smarter'n I.
SIMIHIOI_FIXERS = "Malsavius";

-- Setting up the Bindings names.
BINDING_HEADER_OPENIT	= "OpenIt!"
BINDING_NAME_OPENGROUP	= "OpenIt Group"

-- This is yer standard 'has VARIABLES_LOADED ran'
-- type doodad.
SiMiHiOi_HasInitChanges = 0;

-- Okay, we don't have the player's name yet so we
-- set this to 0 by default.
SiMiHiOi_GotName = 0;

-- For those that don't want a per character system
-- we're going to start a One-Size-Fits-All option
-- right here with this variable.  Disabled by
-- default, of course.
SiMiHiOi_OneSizeFitsAll = 0;

-- *******************************************************

function SiMiHiOi_OnLoad()
	-- Register Events
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UNIT_NAME_UPDATE");

	-- Register to Save our variables.
	-- What does this DO?

	-- ScaleIt
	RegisterForSave("ScaleIt");
	RegisterForSave("MoveIt");
	RegisterForSave("HideIt");
	RegisterForSave("OpenIt");
	RegisterForSave("ScaleSetting");
	RegisterForSave("SiMiHiOi_OneSizeFitsAll");

	-- Define Chat Commands
	SLASH_ADVANCE1 = "/smhoadv";
	SlashCmdList["ADVANCE"] = function (message)
		SiMiHiOiAdvanced_SlashCmd(message);
	end

	SLASH_SCALEIT1 = "/scaleit";
	SlashCmdList["SCALEIT"] = function (message)
		ScaleIt_SlashCmd(message);
	end

	SLASH_MOVEIT1 = "/moveit";
	SlashCmdList["MOVEIT"] = function (message)
		MoveIt_SlashCmd(message);
	end

	SLASH_HIDEIT1 = "/hideit";
	SlashCmdList["HIDEIT"] = function (message)
		HideIt_SlashCmd(message);
	end

	SLASH_OPENIT1 = "/openit";
	SlashCmdList["OPENIT"] = function (message)
		OpenIt_SlashCmd(message);
	end

	-- Define Variables ~ If ScaleSetting was not previously defined ...
	if (ScaleSetting == nil) then
		-- Set it for 1.0.
		ScaleSetting = 1.0;
	end
end

-- *******************************************************

function SiMiHiOiAdvanced_SlashCmd(message)
	-- First we make sure our player has a name ...
	-- ... if not, let's get a name!
	if (SiMiHiOi_GotName == 0) then
		SiMiHiOi_OnEvent("PLAYER_ENTERING_WORLD");
	end

	-- There are no extra variables to worry about so just double up.
	command = message;

	-- If /smhoadv "this stuff" then run a toggle on the related variable.
	-- Gods that sounds dull.

	if (command == "hideitalways") then
		if (HideIt[SMHO_Dude].ShouldUpdateContinuously == 1) then
			HideIt[SMHO_Dude].ShouldUpdateContinuously = 0;
			ChatMessage("SiMiHiOi Advanced: The HideItContinuously items are now disabled.");
		else
			HideIt[SMHO_Dude].ShouldUpdateContinuously = 1;
			ChatMessage("SiMiHiOi Advanced: The HideItContinuously items are now enabled.");
		end
	elseif (command == "moveitalways") then
		if (MoveIt[SMHO_Dude].ShouldUpdateContinuously == 1) then
			MoveIt[SMHO_Dude].ShouldUpdateContinuously = 0;
			ChatMessage("SiMiHiOi Advanced: The MoveItContinuously items are now disabled.");
		else
			MoveIt[SMHO_Dude].ShouldUpdateContinuously = 1;
			ChatMessage("SiMiHiOi Advanced: The MoveItContinuously items are now enabled.");
		end
	elseif (command == "onesize") then
		if (SiMiHiOi_OneSizeFitsAll == 1) then
			SiMiHiOi_OneSizeFitsAll = 0;
			SMHO_Dude = nil;
			SiMiHiOi_OnEvent("PLAYER_ENTERING_WORLD");
			ReloadUI();
		else
			SiMiHiOi_OneSizeFitsAll = 1;
			SMHO_Dude = nil;
			SiMiHiOi_OnEvent("PLAYER_ENTERING_WORLD");
			ReloadUI();
		end
	elseif (command == "onesizestatus") then
		if (SiMiHiOi_OneSizeFitsAll == 0) then
			ChatMessage("SiMiHiOi Advanced: 'One Size Fits All' mode now disabled.");
		else
			ChatMessage("SiMiHiOi Advanced: 'One Size Fits All' mode now enabled.");
		end
	else
		-- Display command usage for this AddOn.
		SiMiHiOiAdvanced_Usage();
	end

	if not (command == nil) then
		if (strlen(command) > 0) then
			SiMiHiOi_InitChanges();
		end
	end
end

-- *******************************************************

function ScaleIt_SlashCmd(message)
	-- First we make sure our player has a name ...
	-- ... if not, let's get a name!
	if (SiMiHiOi_GotName == 0) then
		SiMiHiOi_OnEvent("PLAYER_ENTERING_WORLD");
	end

	-- Setup type variables for information message.
	Type = "ScaleIt";
	Type2 = "scaling";
	Type3 = "scaled";

	-- Ensure that the following variables are blank.
	local command = nil;
	local value = nil;
	
	-- Setup indexing ...
	local index = string.find(message, " ");

	if (index) then
		command = string.sub(message, 1, index-1);
		command = string.lower(command);
		value = string.sub(message, index+1);
	else
		command = message;
	end
	
	if not (command == nil or value == nil or value == "unset") then
		if (strlen(command) > 0 and strlen(value) > 4) then
			ChatMessage("ScaleIt: You cannot set a value that has more than three characters.");
			ChatMessage("As an example, 0.8 is fine and 0.85 is okay but 0.852 will achieve naught.");
			return;
		end
	end

	-- If /scaleit "this stuff" then check the value.
	-- If the value isn't blank then manipulate variables.
	-- Gods that sounds dull.

	if (command == "scale") then
		-- If the value is blank...
		if (value == nil) then
			SlashCmdGetInform(Type, Type3, "Global Scale", ScaleSetting);
		else
			ScaleSetting = value;
			SetCVar("uiScale", ScaleSetting);
			SlashCmdSetInform(Type, Type2, "Global Scale", ScaleIt[SMHO_Dude].AIOI);
		end
	elseif (command == "aioi") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "All in One Inventory", "unset");
			ScaleIt[SMHO_Dude].AIOI = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "All in One Inventory", ScaleIt[SMHO_Dude].AIOI);
		else
			ScaleIt[SMHO_Dude].AIOI = value;
			SlashCmdSetInform(Type, Type2, "All in One Inventory", ScaleIt[SMHO_Dude].AIOI);
		end
	elseif (command == "auction") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Auction window", "unset");
			ScaleIt[SMHO_Dude].Auction = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Auction window", ScaleIt[SMHO_Dude].Auction);
		else
			ScaleIt[SMHO_Dude].Auction = value;
			SlashCmdSetInform(Type, Type2, "Auction window", ScaleIt[SMHO_Dude].Auction);
		end
	elseif (command == "avgxp") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "AvgXP", "unset");
			ScaleIt[SMHO_Dude].AvgXP = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "AvgXP", ScaleIt[SMHO_Dude].AvgXP);
		else
			ScaleIt[SMHO_Dude].AvgXP = value;
			SlashCmdSetInform(Type, Type2, "AvgXP", ScaleIt[SMHO_Dude].AvgXP);
		end
	elseif (command == "bags") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Bags", "unset");
			ScaleIt[SMHO_Dude].Bags = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Bags", ScaleIt[SMHO_Dude].Bags);
		else
			ScaleIt[SMHO_Dude].Bags = value;
			SlashCmdSetInform(Type, Type2, "Bags", ScaleIt[SMHO_Dude].Bags);
		end
	elseif (command == "bank") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Bank window", "unset");
			ScaleIt[SMHO_Dude].Bank = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Bank window", ScaleIt[SMHO_Dude].Bank);
		else
			ScaleIt[SMHO_Dude].Bank = value;
			SlashCmdSetInform(Type, Type2, "Bank window", ScaleIt[SMHO_Dude].Bank);
		end
	--[[ Added by Mook Begin ]]
	elseif (command == "bankitems") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Bank Items window", "unset");
			ScaleIt[SMHO_Dude].BankItems = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Bank Items window", ScaleIt[SMHO_Dude].BankItems);
		else
			ScaleIt[SMHO_Dude].BankItems = value;
			SlashCmdSetInform(Type, Type2, "Bank Items window", ScaleIt[SMHO_Dude].BankItems);
		end
	--[[ Added by Mook End ]]
	elseif (command == "buff") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Buffs Frame", "unset");
			ScaleIt[SMHO_Dude].Buffs = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Buffs Frame", ScaleIt[SMHO_Dude].Buffs);
		else
			ScaleIt[SMHO_Dude].Buffs = value;
			SlashCmdSetInform(Type, Type2, "Buffs Frame", ScaleIt[SMHO_Dude].Buffs);
		end
	elseif (command == "bufftime") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "BuffTimers", "unset");
			ScaleIt[SMHO_Dude].BuffTime = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "BuffTimers", ScaleIt[SMHO_Dude].BuffTime);
		else
			ScaleIt[SMHO_Dude].BuffTime = value;
			SlashCmdSetInform(Type, Type2, "BuffTimers", ScaleIt[SMHO_Dude].BuffTime);
		end
	elseif (command == "bsm") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Bag Status Meters", "unset");
			ScaleIt[SMHO_Dude].BSM = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Bag Status Meters", ScaleIt[SMHO_Dude].BSM);
		else
			ScaleIt[SMHO_Dude].BSM = value;
			SlashCmdSetInform(Type, Type2, "Bag Status Meters", ScaleIt[SMHO_Dude].BSM);
		end
	elseif (command == "bsmtext") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Bag Status Meters text", "unset");
			ScaleIt[SMHO_Dude].BSMText = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Bag Status Meters text", ScaleIt[SMHO_Dude].BSMText);
		else
			ScaleIt[SMHO_Dude].BSMText = value;
			SlashCmdSetInform(Type, Type2, "Bag Status Meters text", ScaleIt[SMHO_Dude].BSMText);
		end
	elseif (command == "casting") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Casting Bar", "unset");
			ScaleIt[SMHO_Dude].Casting = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Casting Bar", ScaleIt[SMHO_Dude].Casting);
		else
			ScaleIt[SMHO_Dude].Casting = value;
			SlashCmdSetInform(Type, Type2, "Casting Bar", ScaleIt[SMHO_Dude].Casting);
		end
	elseif (command == "castparty") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "CastParty", "unset");
			ScaleIt[SMHO_Dude].CastParty = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "CastParty", ScaleIt[SMHO_Dude].CastParty);
		else
			ScaleIt[SMHO_Dude].CastParty = value;
			SlashCmdSetInform(Type, Type2, "CastParty", ScaleIt[SMHO_Dude].CastParty);
		end
	elseif (command == "char") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Character window", "unset");
			ScaleIt[SMHO_Dude].Character = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Character window", ScaleIt[SMHO_Dude].Character);
		else
			ScaleIt[SMHO_Dude].Character = value;
			SlashCmdSetInform(Type, Type2, "Character window", ScaleIt[SMHO_Dude].Character);
		end
	elseif (command == "classtrain") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Class Trainer window", "unset");
			ScaleIt[SMHO_Dude].ClassTrain = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Class Trainer window", ScaleIt[SMHO_Dude].ClassTrain);
		else
			ScaleIt[SMHO_Dude].ClassTrain = value;
			SlashCmdSetInform(Type, Type2, "Class Trainer window", ScaleIt[SMHO_Dude].ClassTrain);
		end
	elseif (command == "clock") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Clock", "unset");
			ScaleIt[SMHO_Dude].Clock = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Clock", ScaleIt[SMHO_Dude].Clock);
		else
			ScaleIt[SMHO_Dude].Clock = value;
			SlashCmdSetInform(Type, Type2, "Clock", ScaleIt[SMHO_Dude].Clock);
		end
	elseif (command == "cooldown") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Cooldown HUD", "unset");
			ScaleIt[SMHO_Dude].CoolHUD = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Cooldown HUD", ScaleIt[SMHO_Dude].CoolHUD);
		else
			ScaleIt[SMHO_Dude].CoolHUD = value;
			SlashCmdSetInform(Type, Type2, "Cooldown HUD", ScaleIt[SMHO_Dude].CoolHUD);
		end
	elseif (command == "craft") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Crafting window", "unset");
			ScaleIt[SMHO_Dude].Craft = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Crafting window", ScaleIt[SMHO_Dude].Craft);
		else
			ScaleIt[SMHO_Dude].Craft = value;
			SlashCmdSetInform(Type, Type2, "Crafting window", ScaleIt[SMHO_Dude].Craft);
		end
	elseif (command == "fps") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "FPS text", "unset");
			ScaleIt[SMHO_Dude].FPS = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "FPS text", ScaleIt[SMHO_Dude].FPS);
		else
			ScaleIt[SMHO_Dude].FPS = value;
			SlashCmdSetInform(Type, Type2, "FPS text", ScaleIt[SMHO_Dude].FPS);
		end
	elseif (command == "friends") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Friends window", "unset");
			ScaleIt[SMHO_Dude].Friends = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Friends window", ScaleIt[SMHO_Dude].Friends);
		else
			ScaleIt[SMHO_Dude].Friends = value;
			SlashCmdSetInform(Type, Type2, "Friends window", ScaleIt[SMHO_Dude].Friends);
		end
	elseif (command == "gypsybar") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Gypsy's ActionBar", "unset");
			ScaleIt[SMHO_Dude].Gypsy = nil;
			ScaleIt[SMHO_Dude].MainMenuBar = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Gypsy's ActionBar", ScaleIt[SMHO_Dude].Gypsy);
		else
			ScaleIt[SMHO_Dude].MainMenuBar = value;
			ScaleIt[SMHO_Dude].Gypsy = value;
			SlashCmdSetInform(Type, Type2, "Gypsy's ActionBar", ScaleIt[SMHO_Dude].Gypsy);
		end
	elseif (command == "itembuff") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "ItemBuffs", "unset");
			ScaleIt[SMHO_Dude].ItemBuff = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "ItemBuffs", ScaleIt[SMHO_Dude].ItemBuff);
		else
			ScaleIt[SMHO_Dude].ItemBuff = value;
			SlashCmdSetInform(Type, Type2, "ItemBuffs", ScaleIt[SMHO_Dude].ItemBuff);
		end
	elseif (command == "lfgp") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "LookingForGroup Paste", "unset");
			ScaleIt[SMHO_Dude].LFGP = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "LookingForGroup Paste", ScaleIt[SMHO_Dude].LFGP);
		else
			ScaleIt[SMHO_Dude].LFGP = value;
			SlashCmdSetInform(Type, Type2, "LookingForGroup Paste", ScaleIt[SMHO_Dude].LFGP);
		end
	elseif (command == "lagbar") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Floating LagBar", "unset");
			ScaleIt[SMHO_Dude].LagBar = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Floating LagBar", ScaleIt[SMHO_Dude].LagBar);
		else
			ScaleIt[SMHO_Dude].LagBar = value;
			SlashCmdSetInform(Type, Type2, "Floating LagBar", ScaleIt[SMHO_Dude].LagBar);
		end
	elseif (command == "loccoord") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Location Coordinates", "unset");
			ScaleIt[SMHO_Dude].LocCoord = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Location Coordinates", ScaleIt[SMHO_Dude].LocCoord);
		else
			ScaleIt[SMHO_Dude].LocCoord = value;
			SlashCmdSetInform(Type, Type2, "Location Coordinates", ScaleIt[SMHO_Dude].LocCoord);
		end
	elseif (command == "lfgpmini") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "LookingForGroup Paste Minimized", "unset");
			ScaleIt[SMHO_Dude].LFGPMini = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "LookingForGroup Paste Minimized", ScaleIt[SMHO_Dude].LFGPMini);
		else
			ScaleIt[SMHO_Dude].LFGPMini = value;
			SlashCmdSetInform(Type, Type2, "LookingForGroup Paste Minimized", ScaleIt[SMHO_Dude].LFGPMini);
		end
	elseif (command == "loot") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Loot window", "unset");
			ScaleIt[SMHO_Dude].Loot = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Loot window", ScaleIt[SMHO_Dude].Loot);
		else
			ScaleIt[SMHO_Dude].Loot = value;
			SlashCmdSetInform(Type, Type2, "Loot window", ScaleIt[SMHO_Dude].Loot);
		end
	elseif (command == "lootlink") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "LootLink", "unset");
			ScaleIt[SMHO_Dude].LootLink = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "LootLink", ScaleIt[SMHO_Dude].LootLink);
		else
			ScaleIt[SMHO_Dude].LootLink = value;
			SlashCmdSetInform(Type, Type2, "LootLink", ScaleIt[SMHO_Dude].LootLink);
		end
	elseif (command == "macro") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Macros window", "unset");
			ScaleIt[SMHO_Dude].Macros = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Macros window", ScaleIt[SMHO_Dude].Macros);
		else
			ScaleIt[SMHO_Dude].Macros = value;
			SlashCmdSetInform(Type, Type2, "Macros window", ScaleIt[SMHO_Dude].Macros);
		end
	elseif (command == "mail") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Mail window", "unset");
			ScaleIt[SMHO_Dude].Mail = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Mail window", ScaleIt[SMHO_Dude].Mail);
		else
			ScaleIt[SMHO_Dude].Mail = value;
			SlashCmdSetInform(Type, Type2, "Mail window", ScaleIt[SMHO_Dude].Mail);
		end
	elseif (command == "mainbar") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Main Menu Bar", "unset");
			ScaleIt[SMHO_Dude].MainMenuBar = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Main Menu Bar", ScaleIt[SMHO_Dude].MainMenuBar);
		else
			ScaleIt[SMHO_Dude].Gypsy = nil;
			ScaleIt[SMHO_Dude].MainMenuBar = value;
			SlashCmdSetInform(Type, Type2, "Main Menu Bar", ScaleIt[SMHO_Dude].MainMenuBar);
		end
	elseif (command == "minimap") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Minimap", "unset");
			ScaleIt[SMHO_Dude].Minimap = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Minimap", ScaleIt[SMHO_Dude].Minimap);
		else
			ScaleIt[SMHO_Dude].Minimap = value;
			SlashCmdSetInform(Type, Type2, "Minimap", ScaleIt[SMHO_Dude].Minimap);
		end
	elseif (command == "mobhp") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "MobHealth", "unset");
			ScaleIt[SMHO_Dude].MobHealth = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "MobHealth", ScaleIt[SMHO_Dude].MobHealth);
		else
			ScaleIt[SMHO_Dude].MobHealth = value;
			SlashCmdSetInform(Type, Type2, "MobHealth", ScaleIt[SMHO_Dude].MobHealth);
		end
	elseif (command == "moneydisp") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Money Display", "unset");
			ScaleIt[SMHO_Dude].MoneyDisp = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Money Display", ScaleIt[SMHO_Dude].MoneyDisp);
		else
			ScaleIt[SMHO_Dude].MoneyDisp = value;
			SlashCmdSetInform(Type, Type2, "Money Display", ScaleIt[SMHO_Dude].MoneyDisp);
		end
	elseif (command == "mquest") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Monkey Quest", "unset");
			ScaleIt[SMHO_Dude].MQuest = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Monkey Quest", ScaleIt[SMHO_Dude].MQuest);
		else
			ScaleIt[SMHO_Dude].MQuest = value;
			SlashCmdSetInform(Type, Type2, "Monkey Quest", ScaleIt[SMHO_Dude].MQuest);
		end
	elseif (command == "notepad") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Notepad", "unset");
			ScaleIt[SMHO_Dude].Notepad = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Notepad", ScaleIt[SMHO_Dude].Notepad);
		else
			ScaleIt[SMHO_Dude].Notepad = value;
			SlashCmdSetInform(Type, Type2, "Notepad", ScaleIt[SMHO_Dude].Notepad);
		end
	elseif (command == "party") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Party Frame", "unset");
			ScaleIt[SMHO_Dude].Party = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Party Frame", ScaleIt[SMHO_Dude].Party);
		else
			ScaleIt[SMHO_Dude].Party = value;
			SlashCmdSetInform(Type, Type2, "Party Frame", ScaleIt[SMHO_Dude].Party);
		end
	elseif (command == "pet") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Pet Frame", "unset");
			ScaleIt[SMHO_Dude].Pet = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Pet Frame", ScaleIt[SMHO_Dude].Pet);
		else
			ScaleIt[SMHO_Dude].Pet = value;
			SlashCmdSetInform(Type, Type2, "Pet Frame", ScaleIt[SMHO_Dude].Pet);
		end
	elseif (command == "petbar") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Pet ActionBar", "unset");
			ScaleIt[SMHO_Dude].PetBar = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Pet ActionBar", ScaleIt[SMHO_Dude].PetBar);
		else
			ScaleIt[SMHO_Dude].PetBar = value;
			SlashCmdSetInform(Type, Type2, "Pet ActionBar", ScaleIt[SMHO_Dude].PetBar);
		end
	elseif (command == "player") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Player Frame", "unset");
			ScaleIt[SMHO_Dude].Player = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Player Frame", ScaleIt[SMHO_Dude].Player);
		else
			ScaleIt[SMHO_Dude].Player = value;
			SlashCmdSetInform(Type, Type2, "Player Frame", ScaleIt[SMHO_Dude].Player);
		end
	elseif (command == "popbar") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "PopBar", "unset");
			ScaleIt[SMHO_Dude].PopBar = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "PopBar", ScaleIt[SMHO_Dude].Popbar);
		else
			ScaleIt[SMHO_Dude].PopBar = value;
			SlashCmdSetInform(Type, Type2, "PopBar", ScaleIt[SMHO_Dude].Popbar);
		end
	elseif (command == "ppets") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "PartyPets", "unset");
			ScaleIt[SMHO_Dude].PPets = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "PartyPets", ScaleIt[SMHO_Dude].PPets);
		else
			ScaleIt[SMHO_Dude].PPets = value;
			SlashCmdSetInform(Type, Type2, "PartyPets", ScaleIt[SMHO_Dude].PPets);
		end
	elseif (command == "quest") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Quest and Quest Log windows", "unset");
			ScaleIt[SMHO_Dude].Quest = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Quest and Quest Log windows", ScaleIt[SMHO_Dude].Quest);
		else
			ScaleIt[SMHO_Dude].Quest = value;
			SlashCmdSetInform(Type, Type2, "Quest and Quest Log windows", ScaleIt[SMHO_Dude].Quest);
		end
	elseif (command == "questtimer") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Quest Timer", "unset");
			ScaleIt[SMHO_Dude].Timer = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Quest Timer", ScaleIt[SMHO_Dude].Timer);
		else
			ScaleIt[SMHO_Dude].Timer = value;
			SlashCmdSetInform(Type, Type2, "Quest Timer", ScaleIt[SMHO_Dude].Timer);
		end
	elseif (command == "questtip") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "QuestMinion Tooltip", "unset");
			ScaleIt[SMHO_Dude].QuestTip = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "QuestMinion Tooltip", ScaleIt[SMHO_Dude].QuestTip);
		else
			ScaleIt[SMHO_Dude].QuestTip = value;
			SlashCmdSetInform(Type, Type2, "QuestMinion Tooltip", ScaleIt[SMHO_Dude].QuestTip);
		end
	elseif (command == "raid") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Raid window", "unset");
			ScaleIt[SMHO_Dude].Raid = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Raid window", ScaleIt[SMHO_Dude].Raid);
		else
			ScaleIt[SMHO_Dude].Raid = value;
			SlashCmdSetInform(Type, Type2, "Raid window", ScaleIt[SMHO_Dude].Raid);
		end
	elseif (command == "rlist") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Reagent List", "unset");
			ScaleIt[SMHO_Dude].ReagList = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Reagent List", ScaleIt[SMHO_Dude].ReagList);
		else
			ScaleIt[SMHO_Dude].ReagList = value;
			SlashCmdSetInform(Type, Type2, "Reagent List", ScaleIt[SMHO_Dude].ReagList);
		end
	elseif (command == "roguehelp") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Rogue Helper", "unset");
			ScaleIt[SMHO_Dude].RogueHelp = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Rogue Helper", ScaleIt[SMHO_Dude].RogueHelp);
		else
			ScaleIt[SMHO_Dude].RogueHelp = value;
			SlashCmdSetInform(Type, Type2, "Rogue Helper", ScaleIt[SMHO_Dude].RogueHelp);
		end
	elseif (command == "shapeshift") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Shapeshift/Aura/Stance Bar", "unset");
			ScaleIt[SMHO_Dude].Shapeshift = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Shapeshift/Aura/Stance Bar", ScaleIt[SMHO_Dude].Shapeshift);
		else
			ScaleIt[SMHO_Dude].Shapeshift = value;
			SlashCmdSetInform(Type, Type2, "Shapeshift/Aura/Stance Bar", ScaleIt[SMHO_Dude].Shapeshift);
		end
	elseif (command == "shop") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Merchant window", "unset");
			ScaleIt[SMHO_Dude].Merchant = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Merchant window", ScaleIt[SMHO_Dude].Merchant);
		else
			ScaleIt[SMHO_Dude].Merchant = value;
			SlashCmdSetInform(Type, Type2, "Merchant window", ScaleIt[SMHO_Dude].Merchant);
		end
	elseif (command == "sidebar") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Sidebar (Right)", "unset");
			ScaleIt[SMHO_Dude].SideBar = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Sidebar (Right)", ScaleIt[SMHO_Dude].SideBar);
		else
			ScaleIt[SMHO_Dude].SideBar = value;
			SlashCmdSetInform(Type, Type2, "Sidebar (Right)", ScaleIt[SMHO_Dude].SideBar);
		end
	elseif (command == "sidebar2") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Sidebar (Left)", "unset");
			ScaleIt[SMHO_Dude].SideBar2 = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Sidebar (Left)", ScaleIt[SMHO_Dude].SideBar2);
		else
			ScaleIt[SMHO_Dude].SideBar2 = value;
			SlashCmdSetInform(Type, Type2, "Sidebar (Left)", ScaleIt[SMHO_Dude].SideBar2);
		end
	elseif (command == "spellbook") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "SpellBook", "unset");
			ScaleIt[SMHO_Dude].SpellBook = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "SpellBook", ScaleIt[SMHO_Dude].SpellBook);
		else
			ScaleIt[SMHO_Dude].SpellBook = value;
			SlashCmdSetInform(Type, Type2, "SpellBook", ScaleIt[SMHO_Dude].SpellBook);
		end
	elseif (command == "stable") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Pet Stables window", "unset");
			ScaleIt[SMHO_Dude].Stable = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Pet Stables window", ScaleIt[SMHO_Dude].Stable);
		else
			ScaleIt[SMHO_Dude].Stable = value;
			SlashCmdSetInform(Type, Type2, "Pet Stables window", ScaleIt[SMHO_Dude].Stable);
		end
	elseif (command == "sunder") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "SunderThis", "unset");
			ScaleIt[SMHO_Dude].Sunder = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "SunderThis", ScaleIt[SMHO_Dude].Sunder);
		else
			ScaleIt[SMHO_Dude].Sunder = value;
			SlashCmdSetInform(Type, Type2, "SunderThis", ScaleIt[SMHO_Dude].Sunder);
		end
	elseif (command == "tabbard") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Tabbard window", "unset");
			ScaleIt[SMHO_Dude].Tabbard = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Tabbard window", ScaleIt[SMHO_Dude].Tabbard);
		else
			ScaleIt[SMHO_Dude].Tabbard = value;
			SlashCmdSetInform(Type, Type2, "Tabbard window", ScaleIt[SMHO_Dude].Tabbard);
		end
	elseif (command == "talent") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Talents window", "unset");
			ScaleIt[SMHO_Dude].Talent = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Talents window", ScaleIt[SMHO_Dude].Talent);
		else
			ScaleIt[SMHO_Dude].Talent = value;
			SlashCmdSetInform(Type, Type2, "Talents window", ScaleIt[SMHO_Dude].Talent);
		end
	elseif (command == "talenttrain") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Talent Trainer window", "unset");
			ScaleIt[SMHO_Dude].TalentTrain = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Talent Trainer window", ScaleIt[SMHO_Dude].TalentTrain);
		else
			ScaleIt[SMHO_Dude].TalentTrain = value;
			SlashCmdSetInform(Type, Type2, "Talent Trainer window", ScaleIt[SMHO_Dude].TalentTrain);
		end
	elseif (command == "target") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Target Frame", "unset");
			ScaleIt[SMHO_Dude].Target = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Target Frame", ScaleIt[SMHO_Dude].Target);
		else
			ScaleIt[SMHO_Dude].Target = value;
			SlashCmdSetInform(Type, Type2, "Target Frame", ScaleIt[SMHO_Dude].Target);
		end
	elseif (command == "taxi") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Air Travel window", "unset");
			ScaleIt[SMHO_Dude].Taxi = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Air Travel window", ScaleIt[SMHO_Dude].Taxi);
		else
			ScaleIt[SMHO_Dude].Taxi = value;
			SlashCmdSetInform(Type, Type2, "Air Travel window", ScaleIt[SMHO_Dude].Taxi);
		end
	elseif (command == "tooltip") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Global Tooltip", "unset");
			ScaleIt[SMHO_Dude].Tooltip = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Global Tooltip", ScaleIt[SMHO_Dude].Tooltip);
		else
			ScaleIt[SMHO_Dude].Tooltip = value;
			SlashCmdSetInform(Type, Type2, "Global Tooltip", ScaleIt[SMHO_Dude].Tooltip);
		end
	elseif (command == "totembar") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "TotemBar", "unset");
			ScaleIt[SMHO_Dude].TotemBar = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "TotemBar", ScaleIt[SMHO_Dude].TotemBar);
		else
			ScaleIt[SMHO_Dude].TotemBar = value;
			SlashCmdSetInform(Type, Type2, "TotemBar", ScaleIt[SMHO_Dude].TotemBar);
		end
	elseif (command == "ttimer") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "TotemTimers", "unset");
			ScaleIt[SMHO_Dude].ToTimers = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "TotemTimers", ScaleIt[SMHO_Dude].ToTimers);
		else
			ScaleIt[SMHO_Dude].ToTimers = value;
			SlashCmdSetInform(Type, Type2, "TotemTimers", ScaleIt[SMHO_Dude].ToTimers);
		end
	elseif (command == "trade") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Trade window", "unset");
			ScaleIt[SMHO_Dude].Trade = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Trade window", ScaleIt[SMHO_Dude].Trade);
		else
			ScaleIt[SMHO_Dude].Trade = value;
			SlashCmdSetInform(Type, Type2, "Trade window", ScaleIt[SMHO_Dude].Trade);
		end	
	elseif (command == "wbuttons") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Weapon Buttons", "unset");
			ScaleIt[SMHO_Dude].WeapButt = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Weapon Buttons", ScaleIt[SMHO_Dude].WeapButt);
		else
			ScaleIt[SMHO_Dude].WeapButt = value;
			SlashCmdSetInform(Type, Type2, "Weapon Buttons", ScaleIt[SMHO_Dude].WeapButt);
		end
	elseif (command == "xpbar") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Floating XP Bar", "unset");
			ScaleIt[SMHO_Dude].XPBar = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Floating XP Bar", ScaleIt[SMHO_Dude].XPBar);
		else
			ScaleIt[SMHO_Dude].XPBar = value;
			SlashCmdSetInform(Type, Type2, "Floating XP Bar", ScaleIt[SMHO_Dude].XPBar);
		end
	elseif (command == "xpclock") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "XPClock", "unset");
			ScaleIt[SMHO_Dude].XPClock = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "XPClock", ScaleIt[SMHO_Dude].XPClock);
		else
			ScaleIt[SMHO_Dude].XPClock = value;
			SlashCmdSetInform(Type, Type2, "XPClock", ScaleIt[SMHO_Dude].XPClock);
		end
	elseif (command == "copy") then
		if (value) then
			ScaleIt[SMHO_Dude] = {};
			ScaleIt[SMHO_Dude] = ScaleIt[value];
			ChatMessage("ScaleIt: ScaleIt values POSSIBLY copied.");
		end
	elseif (command == "alliance") then
		if (value == "hoohah") then
			IFartInTheirGeneralDirection();
		else
			ScaleIt_Usage();
		end
	else
		-- Display command usage for this AddOn.
		ScaleIt_Usage();
	end
end

-- *******************************************************

function MoveIt_SlashCmd(message)
	-- First we make sure our player has a name ...
	-- ... if not, let's get a name!
	if (SiMiHiOi_GotName == 0) then
		SiMiHiOi_OnEvent("PLAYER_ENTERING_WORLD");
	end

	-- Setup type variables for information message.
	Type = "MoveIt";
	Type2 = "moving";
	Type3 = "moved";

	-- Ensure that the following variables are blank.
	local command = nil;
	local value = nil;
	
	-- Setup indexing ...
	local index = string.find(message, " ");

	if (index) then
		command = string.sub(message, 1, index-1);
		command = string.lower(command);
		value = string.sub(message, index+1);
	else
		command = message;
	end

	-- If /moveit "this stuff" then check the value.
	-- If the value isn't blank then manipulate variables.
	-- Run a redundancy check too to make sure neither
	-- variable is nil and blank.
	-- Gods that sounds dull.

	if not (command == nil or value == nil or value == "unset") then
		if (strlen(command) > 0 and strlen(value) > 8) then
			ChatMessage("MoveIt: Are you just plain goofy or totally, inherantly insane?!  You're with the Alliance, aren't you?");
			return;
		end
	end

	if (command == "buffsx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Buffs Frame (X)", "unset");
			MoveIt[SMHO_Dude].BuffsX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Buffs Frame (X)", MoveIt[SMHO_Dude].BuffsX);
		else
			if (MoveIt[SMHO_Dude].BuffsY == nil) then
				MoveIt[SMHO_Dude].BuffsY = 0;
			end
			MoveIt[SMHO_Dude].BuffsX = value;
			SlashCmdSetInform(Type, Type2, "Buffs Frame (X)", MoveIt[SMHO_Dude].BuffsX);
		end
	elseif (command == "buffsy") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Buffs Frame (Y)", "unset");
			MoveIt[SMHO_Dude].BuffsY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Buffs Frame (Y)", MoveIt[SMHO_Dude].BuffsY);
		else
			if (MoveIt[SMHO_Dude].BuffsX == nil) then
				MoveIt[SMHO_Dude].BuffsX = 0;
			end
			MoveIt[SMHO_Dude].BuffsY = value;
			SlashCmdSetInform(Type, Type2, "Buffs Frame (Y)", MoveIt[SMHO_Dude].BuffsY);
		end
	--[[ Added by Mook Begin ]]
	elseif (command == "bankitemsx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Bank Items (X)", "unset");
			MoveIt[SMHO_Dude].BankItemsX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Bank Items (X)", MoveIt[SMHO_Dude].BankItemsX);
		else
			if (MoveIt[SMHO_Dude].BankItemsY == nil) then
				MoveIt[SMHO_Dude].BankItemsY = 0;
			end
			MoveIt[SMHO_Dude].BankItemsX = value;
			SlashCmdSetInform(Type, Type2, "Bank Items (X)", MoveIt[SMHO_Dude].BankItemsX);
		end
	--[[ Added by Mook End ]]
	elseif (command == "bankitemsy") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Bank Items (Y)", "unset");
			MoveIt[SMHO_Dude].BankItemsY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Bank Items (Y)", MoveIt[SMHO_Dude].BankItemsY);
		else
			if (MoveIt[SMHO_Dude].BankItemsX == nil) then
				MoveIt[SMHO_Dude].BankItemsX = 0;
			end
			MoveIt[SMHO_Dude].BankItemsY = value;
			SlashCmdSetInform(Type, Type2, "Bank Items (Y)", MoveIt[SMHO_Dude].BankItemsY);
		end
	elseif (command == "castingx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Casting Bar (X)", "unset");
			MoveIt[SMHO_Dude].CastingX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Casting Bar (X)", MoveIt[SMHO_Dude].CastingX);
		else
			if (MoveIt[SMHO_Dude].CastingY == nil) then
				MoveIt[SMHO_Dude].CastingY = 0;
			end
			MoveIt[SMHO_Dude].CastingX = value;
			SlashCmdSetInform(Type, Type2, "Casting Bar (X)", MoveIt[SMHO_Dude].CastingX);
		end
	elseif (command == "castingy") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Casting Bar (Y)", "unset");
			MoveIt[SMHO_Dude].CastingY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Casting Bar (Y)", MoveIt[SMHO_Dude].CastingY);
		else
			if (MoveIt[SMHO_Dude].CastingX == nil) then
				MoveIt[SMHO_Dude].CastingX = 0;
			end
			MoveIt[SMHO_Dude].CastingY = value;
			SlashCmdSetInform(Type, Type2, "Casting Bar (Y)", MoveIt[SMHO_Dude].CastingY);
		end
	elseif (command == "charx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Character window (X)", "unset");
			MoveIt[SMHO_Dude].CharacterX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Character window (X)", MoveIt[SMHO_Dude].CharacterX);
		else
			if (MoveIt[SMHO_Dude].CharacterY == nil) then
				MoveIt[SMHO_Dude].CharacterY = 0;
			end
			MoveIt[SMHO_Dude].CharacterX = value;
			SlashCmdSetInform(Type, Type2, "Character window (X)", MoveIt[SMHO_Dude].CharacterX);
		end
	elseif (command == "chary") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Character window (Y)", "unset");
			MoveIt[SMHO_Dude].CharacterY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Character window (Y)", MoveIt[SMHO_Dude].CharacterY);
		else
			if (MoveIt[SMHO_Dude].CharacterX == nil) then
				MoveIt[SMHO_Dude].CharacterX = 0;
			end
			MoveIt[SMHO_Dude].CharacterY = value;
			SlashCmdSetInform(Type, Type2, "Character window (Y)", MoveIt[SMHO_Dude].CharacterY);
		end
	elseif (command == "fpsx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "FPS text (X)", "unset");
			MoveIt[SMHO_Dude].FPSX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "FPS text (X)", MoveIt[SMHO_Dude].FPSX);
		else
			if (MoveIt[SMHO_Dude].FPSY == nil) then
				MoveIt[SMHO_Dude].FPSY = 0;
			end
			MoveIt[SMHO_Dude].FPSX = value;
			SlashCmdSetInform(Type, Type2, "FPS text (X)", MoveIt[SMHO_Dude].FPSX);
		end
	elseif (command == "fpsy") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "FPS text (Y)", "unset");
			MoveIt[SMHO_Dude].FPSY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "FPS text (Y)", MoveIt[SMHO_Dude].FPSY);
		else
			if (MoveIt[SMHO_Dude].FPSX == nil) then
				MoveIt[SMHO_Dude].FPSX = 0;
			end
			MoveIt[SMHO_Dude].FPSY = value;
			SlashCmdSetInform(Type, Type2, "FPS text (Y)", MoveIt[SMHO_Dude].FPSY);
		end
	elseif (command == "friendx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Friends window (X)", "unset");
			MoveIt[SMHO_Dude].FriendsX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Friends window (X)", MoveIt[SMHO_Dude].FriendsX);
		else
			if (MoveIt[SMHO_Dude].FriendsY == nil) then
				MoveIt[SMHO_Dude].FriendsY = 0;
			end
			MoveIt[SMHO_Dude].FriendsX = value;
			SlashCmdSetInform(Type, Type2, "Friends window (X)", MoveIt[SMHO_Dude].FriendsX);
		end
	elseif (command == "friendsy") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Friends window (Y)", "unset");
			MoveIt[SMHO_Dude].FriendsY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Friends window (Y)", MoveIt[SMHO_Dude].FriendsY);
		else
			if (MoveIt[SMHO_Dude].FriendsX == nil) then
				MoveIt[SMHO_Dude].FriendsX = 0;
			end
			MoveIt[SMHO_Dude].FriendsY = value;
			SlashCmdSetInform(Type, Type2, "Friends window (Y)", MoveIt[SMHO_Dude].FriendsY);
		end
	--[[ Added by Mook Begin ]]
	elseif (command == "lootlinkx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Telos LootLink (X)", "unset");
			MoveIt[SMHO_Dude].LootLinkX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Telos LootLink (X)", MoveIt[SMHO_Dude].LootLinkX);
		else
			if (MoveIt[SMHO_Dude].LootLinkY == nil) then
				MoveIt[SMHO_Dude].LootLinkY = 0;
			end
			MoveIt[SMHO_Dude].LootLinkX = value;
			SlashCmdSetInform(Type, Type2, "Telos LootLink (X)", MoveIt[SMHO_Dude].LootLinkX);
		end
	elseif (command == "lootlinky") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Telos LootLink (Y)", "unset");
			MoveIt[SMHO_Dude].LootLinkY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Telos LootLink (Y)", MoveIt[SMHO_Dude].LootLinkY);
		else
			if (MoveIt[SMHO_Dude].LootLinkX == nil) then
				MoveIt[SMHO_Dude].LootLinkX = 0;
			end
			MoveIt[SMHO_Dude].LootLinkY = value;
			SlashCmdSetInform(Type, Type2, "Telos LootLink (Y)", MoveIt[SMHO_Dude].LootLinkY);
		end
	--[[ Added by Mook End ]]
	elseif (command == "mainbarx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Main Menu Bar (X)", "unset");
			MoveIt[SMHO_Dude].MainMenuX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Main Menu Bar (X)", MoveIt[SMHO_Dude].MainMenuX);
		else
			if (MoveIt[SMHO_Dude].MainMenuY == nil) then
				MoveIt[SMHO_Dude].MainMenuY = 0;
			end
			MoveIt[SMHO_Dude].MainMenuX = value;
			SlashCmdSetInform(Type, Type2, "Main Menu Bar (X)", MoveIt[SMHO_Dude].MainMenuX);
		end
	elseif (command == "mainbary") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Main Menu Bar (Y)", "unset");
			MoveIt[SMHO_Dude].MainMenuY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Main Menu Bar (Y)", MoveIt[SMHO_Dude].MainMenuY);
		else
			if (MoveIt[SMHO_Dude].MainMenuX == nil) then
				MoveIt[SMHO_Dude].MainMenuX = 0;
			end
			MoveIt[SMHO_Dude].MainMenuY = value;
			SlashCmdSetInform(Type, Type2, "Main Menu Bar (Y)", MoveIt[SMHO_Dude].MainMenuY);
		end
	elseif (command == "minimapx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Minimap (X)", "unset");
			MoveIt[SMHO_Dude].MinimapX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Minimap (X)", MoveIt[SMHO_Dude].MinimapX);
		else
			if (MoveIt[SMHO_Dude].MinimapY == nil) then
				MoveIt[SMHO_Dude].MinimapY = 0;
			end
			MoveIt[SMHO_Dude].MinimapX = value;
			SlashCmdSetInform(Type, Type2, "Minimap (X)", MoveIt[SMHO_Dude].MinimapX);
		end
	elseif (command == "minimapy") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Minimap (Y)", "unset");
			MoveIt[SMHO_Dude].MinimapY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Minimap (Y)", MoveIt[SMHO_Dude].MinimapY);
		else
			if (MoveIt[SMHO_Dude].MinimapX == nil) then
				MoveIt[SMHO_Dude].MinimapX = 0;
			end
			MoveIt[SMHO_Dude].MinimapY = value;
			SlashCmdSetInform(Type, Type2, "Minimap (Y)", MoveIt[SMHO_Dude].MinimapX);
		end
	elseif (command == "mobhpx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "MobHealth (X)", "unset");
			MoveIt[SMHO_Dude].MobX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "MobHealth (X)", MoveIt[SMHO_Dude].MobX);
		else
			if (MoveIt[SMHO_Dude].MobY == nil) then
				MoveIt[SMHO_Dude].MobY = 0;
			end
			MoveIt[SMHO_Dude].MobX = value;
			SlashCmdSetInform(Type, Type2, "MobHealth (X)", MoveIt[SMHO_Dude].MobX);
		end
	elseif (command == "mobhpy") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "MobHealth (Y)", "unset");
			MoveIt[SMHO_Dude].MobY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "MobHealth (Y)", MoveIt[SMHO_Dude].MobY);
		else
			if (MoveIt[SMHO_Dude].MobX == nil) then
				MoveIt[SMHO_Dude].MobX = 0;
			end
			MoveIt[SMHO_Dude].MobY = value;
			SlashCmdSetInform(Type, Type2, "MobHealth (Y)", MoveIt[SMHO_Dude].MobY);
		end
	elseif (command == "party1x") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Party Member 1 (X)", "unset");
			MoveIt[SMHO_Dude].Party1X = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Party Member 1 (X)", MoveIt[SMHO_Dude].Party1X);
		else
			if (MoveIt[SMHO_Dude].Party1Y == nil) then
				MoveIt[SMHO_Dude].Party1Y = 0;
			end
			MoveIt[SMHO_Dude].Party1X = value;
			SlashCmdSetInform(Type, Type2, "Party Member 1 (X)", MoveIt[SMHO_Dude].Party1X);
		end
	elseif (command == "party1y") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Party Member 1 (Y)", "unset");
			MoveIt[SMHO_Dude].Party1Y = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Party Member 1 (Y)", MoveIt[SMHO_Dude].Party1Y);
		else
			if (MoveIt[SMHO_Dude].Party1X == nil) then
				MoveIt[SMHO_Dude].Party1X = 0;
			end
			MoveIt[SMHO_Dude].Party1Y = value;
			SlashCmdSetInform(Type, Type2, "Party Member 1 (Y)", MoveIt[SMHO_Dude].Party1Y);
		end
	elseif (command == "party2x") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Party Member 2 (X)", "unset");
			MoveIt[SMHO_Dude].Party2X = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Party Member 2 (X)", MoveIt[SMHO_Dude].Party2X);
		else
			if (MoveIt[SMHO_Dude].Party2Y == nil) then
				MoveIt[SMHO_Dude].Party2Y = 0;
			end
			MoveIt[SMHO_Dude].Party2X = value;
			SlashCmdSetInform(Type, Type2, "Party Member 2 (X)", MoveIt[SMHO_Dude].Party2X);
		end
	elseif (command == "party2y") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Party Member 2 (Y)", "unset");
			MoveIt[SMHO_Dude].Party2Y = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Party Member 2 (Y)", MoveIt[SMHO_Dude].Party2Y);
		else
			if (MoveIt[SMHO_Dude].Party2X == nil) then
				MoveIt[SMHO_Dude].Party2X = 0;
			end
			MoveIt[SMHO_Dude].Party2Y = value;
			SlashCmdSetInform(Type, Type2, "Party Member 2 (Y)", MoveIt[SMHO_Dude].Party2Y);
		end
	elseif (command == "party3x") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Party Member 3 (X)", "unset");
			MoveIt[SMHO_Dude].Party3X = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Party Member 3 (X)", MoveIt[SMHO_Dude].Party3X);
		else
			if (MoveIt[SMHO_Dude].Party3Y == nil) then
				MoveIt[SMHO_Dude].Party3Y = 0;
			end
			MoveIt[SMHO_Dude].Party3X = value;
			SlashCmdSetInform(Type, Type2, "Party Member 3 (X)", MoveIt[SMHO_Dude].Party3X);
		end
	elseif (command == "party3y") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Party Member 3 (Y)", "unset");
			MoveIt[SMHO_Dude].Party3Y = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Party Member 3 (Y)", MoveIt[SMHO_Dude].Party4Y);
		else
			if (MoveIt[SMHO_Dude].Party3X == nil) then
				MoveIt[SMHO_Dude].PartyX = 0;
			end
			MoveIt[SMHO_Dude].Party3Y = value;
			SlashCmdSetInform(Type, Type2, "Party Member 3 (Y)", MoveIt[SMHO_Dude].Party4Y);
		end
	elseif (command == "party4x") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Party Member 4 (X)", "unset");
			MoveIt[SMHO_Dude].Party4X = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Party Member 4 (X)", MoveIt[SMHO_Dude].Party4X);
		else
			if (MoveIt[SMHO_Dude].Party4Y == nil) then
				MoveIt[SMHO_Dude].Party4Y = 0;
			end
			MoveIt[SMHO_Dude].Party4X = value;
			SlashCmdSetInform(Type, Type2, "Party Member 4 (X)", MoveIt[SMHO_Dude].Party4X);
		end
	elseif (command == "party4y") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Party Member 4 (Y)", "unset");
			MoveIt[SMHO_Dude].Party4Y = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Party Member 4 (Y)", MoveIt[SMHO_Dude].Party4Y);
		else
			if (MoveIt[SMHO_Dude].Party4X == nil) then
				MoveIt[SMHO_Dude].Party4X = 0;
			end
			MoveIt[SMHO_Dude].Party4Y = value;
			SlashCmdSetInform(Type, Type2, "Party Member 4 (Y)", MoveIt[SMHO_Dude].Party4Y);
		end
	elseif (command == "petx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Pet Frame (X)", "unset");
			MoveIt[SMHO_Dude].PetX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Pet Frame (X)", MoveIt[SMHO_Dude].PetX);
		else
			if (MoveIt[SMHO_Dude].PetY == nil) then
				MoveIt[SMHO_Dude].PetY = 0;
			end
			MoveIt[SMHO_Dude].PetX = value;
			SlashCmdSetInform(Type, Type2, "Pet Frame (X)", MoveIt[SMHO_Dude].PetX);
		end
	elseif (command == "pety") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Pet Frame (Y)", "unset");
			MoveIt[SMHO_Dude].PetY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Pet Frame (Y)", MoveIt[SMHO_Dude].PetY);
		else
			if (MoveIt[SMHO_Dude].PetX == nil) then
				MoveIt[SMHO_Dude].PetX = 0;
			end
			MoveIt[SMHO_Dude].PetY = value;
			SlashCmdSetInform(Type, Type2, "Pet Frame (Y)", MoveIt[SMHO_Dude].PetY);
		end
	elseif (command == "petbarx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Pet ActionBar (X)", "unset");
			MoveIt[SMHO_Dude].PetBarX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Pet ActionBar (X)", MoveIt[SMHO_Dude].PetBarX);
		else
			if (MoveIt[SMHO_Dude].PetBarY == nil) then
				MoveIt[SMHO_Dude].PetBarY = 0;
			end
			MoveIt[SMHO_Dude].PetBarX = value;
			SlashCmdSetInform(Type, Type2, "Pet ActionBar (X)", MoveIt[SMHO_Dude].PetBarX);
		end
	elseif (command == "petbary") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Pet ActionBar (Y)", "unset");
			MoveIt[SMHO_Dude].PetBarY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Pet ActionBar (Y)", MoveIt[SMHO_Dude].PetBarY);
		else
			if (MoveIt[SMHO_Dude].PetBarX == nil) then
				MoveIt[SMHO_Dude].PetBarX = 0;
			end
			MoveIt[SMHO_Dude].PetBarY = value;
			SlashCmdSetInform(Type, Type2, "Pet ActionBar (Y)", MoveIt[SMHO_Dude].PetBarY);
		end
	elseif (command == "playerx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Player Frame (X)", "unset");
			MoveIt[SMHO_Dude].PlayerX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Player Frame (X)", MoveIt[SMHO_Dude].PlayerX);
		else
			if (MoveIt[SMHO_Dude].PlayerY == nil) then
				MoveIt[SMHO_Dude].PlayerY = 0;
			end
			MoveIt[SMHO_Dude].PlayerX = value;
			SlashCmdSetInform(Type, Type2, "Player Frame (X)", MoveIt[SMHO_Dude].PlayerX);
		end
	elseif (command == "playery") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Player Frame (Y)", "unset");
			MoveIt[SMHO_Dude].PlayerY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Player Frame (Y)", MoveIt[SMHO_Dude].PlayerY);
		else
			if (MoveIt[SMHO_Dude].PlayerX == nil) then
				MoveIt[SMHO_Dude].PlayerX = 0;
			end
			MoveIt[SMHO_Dude].PlayerY = value;
			SlashCmdSetInform(Type, Type2, "Player Frame (Y)", MoveIt[SMHO_Dude].PlayerY);
		end
	elseif (command == "questx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Quest window (X)", "unset");
			MoveIt[SMHO_Dude].QuestX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Quest window (X)", MoveIt[SMHO_Dude].QuestX);
		else
			if (MoveIt[SMHO_Dude].QuestY == nil) then
				MoveIt[SMHO_Dude].QuestY = 0;
			end
			MoveIt[SMHO_Dude].QuestX = value;
			SlashCmdSetInform(Type, Type2, "Quest window (X)", MoveIt[SMHO_Dude].QuestX);
		end
	elseif (command == "questy") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Quest window (Y)", "unset");
			MoveIt[SMHO_Dude].QuestY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Quest window (Y)", MoveIt[SMHO_Dude].QuestY);
		else
			if (MoveIt[SMHO_Dude].QuestX == nil) then
				MoveIt[SMHO_Dude].QuestX = 0;
			end
			MoveIt[SMHO_Dude].QuestY = value;
			SlashCmdSetInform(Type, Type2, "Quest window (Y)", MoveIt[SMHO_Dude].QuestY);
		end
	elseif (command == "shapeshiftx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Shapeshift/Aura/Stance Bar (X)", "unset");
			MoveIt[SMHO_Dude].ShapeshiftX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Shapeshift/Aura/Stance Bar (X)", MoveIt[SMHO_Dude].ShapeshiftX);
		else
			if (MoveIt[SMHO_Dude].ShapeshiftY == nil) then
				MoveIt[SMHO_Dude].ShapeshiftY = 0;
			end
			MoveIt[SMHO_Dude].ShapeshiftX = value;
			SlashCmdSetInform(Type, Type2, "Shapeshift/Aura/Stance Bar (X)", MoveIt[SMHO_Dude].ShapeshiftX);
		end
	elseif (command == "shapeshifty") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Shapeshift/Aura/Stance Bar (Y)", "unset");
			MoveIt[SMHO_Dude].ShapeshiftY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Shapeshift/Aura/Stance Bar (Y)", MoveIt[SMHO_Dude].ShapeshiftY);
		else
			if (MoveIt[SMHO_Dude].ShapeshiftX == nil) then
				MoveIt[SMHO_Dude].ShapeshiftX = 0;
			end
			MoveIt[SMHO_Dude].ShapeshiftY = value;
			SlashCmdSetInform(Type, Type2, "Shapeshift/Aura/Stance Bar (Y)", MoveIt[SMHO_Dude].ShapeshiftY);
		end
	elseif (command == "siebarx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "SideBar (X)", "unset");
			MoveIt[SMHO_Dude].SideBarX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "SideBar (X)", MoveIt[SMHO_Dude].SideBarX);
		else
			if (MoveIt[SMHO_Dude].SideBarY == nil) then
				MoveIt[SMHO_Dude].SideBarY = 0;
			end
			MoveIt[SMHO_Dude].SideBarX = value;
			SlashCmdSetInform(Type, Type2, "SideBar (X)", MoveIt[SMHO_Dude].SideBarX);
		end
	elseif (command == "sidebary") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "SideBar (Y)", "unset");
			MoveIt[SMHO_Dude].SideBarY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "SideBar (Y)", MoveIt[SMHO_Dude].SideBarY);
		else
			if (MoveIt[SMHO_Dude].SideBarX == nil) then
				MoveIt[SMHO_Dude].SideBarX = 0;
			end
			MoveIt[SMHO_Dude].ShapeshiftY = value;
			SlashCmdSetInform(Type, Type2, "Shapeshift/Aura/Stance Bar (Y)", MoveIt[SMHO_Dude].ShapeshiftY);
		end
	elseif (command == "spellx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "SpellBook window (X)", "unset");
			MoveIt[SMHO_Dude].SpellX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "SpellBook window (X)", MoveIt[SMHO_Dude].SpellX);
		else
			if (MoveIt[SMHO_Dude].SpellY == nil) then
				MoveIt[SMHO_Dude].SpellY = 0;
			end
			MoveIt[SMHO_Dude].SpellX = value;
			SlashCmdSetInform(Type, Type2, "SpellBook window (X)", MoveIt[SMHO_Dude].SpellX);
		end
	elseif (command == "spelly") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "SpellBook window (Y)", "unset");
			MoveIt[SMHO_Dude].SpellY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "SpellBook window (Y)", MoveIt[SMHO_Dude].SpellY);
		else
			if (MoveIt[SMHO_Dude].SpellX == nil) then
				MoveIt[SMHO_Dude].SpellX = 0;
			end
			MoveIt[SMHO_Dude].SpellY = value;
			SlashCmdSetInform(Type, Type2, "Spell window (Y)", MoveIt[SMHO_Dude].SpellY);
		end
	elseif (command == "talentx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Talent window (X)", "unset");
			MoveIt[SMHO_Dude].TalentX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Talent window (X)", MoveIt[SMHO_Dude].TalentX);
		else
			if (MoveIt[SMHO_Dude].TalentY == nil) then
				MoveIt[SMHO_Dude].TalentY = 0;
			end
			MoveIt[SMHO_Dude].TalentX = value;
			SlashCmdSetInform(Type, Type2, "Talent window (X)", MoveIt[SMHO_Dude].TalentX);
		end
	elseif (command == "talenty") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Talent window (Y)", "unset");
			MoveIt[SMHO_Dude].TalentY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Talent window (Y)", MoveIt[SMHO_Dude].TalentY);
		else
			if (MoveIt[SMHO_Dude].TalentX == nil) then
				MoveIt[SMHO_Dude].TalentX = 0;
			end
			MoveIt[SMHO_Dude].TalentY = value;
			SlashCmdSetInform(Type, Type2, "Talent window (Y)", MoveIt[SMHO_Dude].TalentY);
		end
	elseif (command == "targetx") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Target Frame (X)", "unset");
			MoveIt[SMHO_Dude].TargetX = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Target Frame (X)", MoveIt[SMHO_Dude].TargetX);
		else
			if (MoveIt[SMHO_Dude].TargetY == nil) then
				MoveIt[SMHO_Dude].TargetY = 0;
			end
			MoveIt[SMHO_Dude].TargetX = value;
			SlashCmdSetInform(Type, Type2, "Target Frame (X)", MoveIt[SMHO_Dude].TargetX);
		end
	elseif (command == "targety") then
		if (value == "unset") then
			SlashCmdSetInform(Type, Type2, "Target Frame (Y)", "unset");
			MoveIt[SMHO_Dude].TargetY = nil;
		elseif (value == nil) then
			SlashCmdGetInform(Type, Type3, "Target Frame (Y)", MoveIt[SMHO_Dude].TargetY);
		else
			if (MoveIt[SMHO_Dude].TargetX == nil) then
				MoveIt[SMHO_Dude].TargetX = 0;
			end
			MoveIt[SMHO_Dude].TargetY = value;
			SlashCmdSetInform(Type, Type2, "Target Frame (Y)", MoveIt[SMHO_Dude].TargetY);
		end
	elseif (command == "alliance") then
		if (value == "hoohah") then
			IFartInTheirGeneralDirection();
		else
			MoveIt_Usage();
		end
	else
		-- Display command usage for this AddOn.
		MoveIt_Usage();
	end

	if not (command == nil or value == nil or value == "unset") then
		if (strlen(command) > 0 and strlen(value) > 0) then
			SiMiHiOi_InitChanges();
		end
	end
end

-- *******************************************************

function HideIt_SlashCmd(message)
	-- First we make sure our player has a name ...
	-- ... if not, let's get a name!
	if (SiMiHiOi_GotName == 0) then
		SiMiHiOi_OnEvent("PLAYER_ENTERING_WORLD");
	end

	-- There are no extra variables to worry about so just double up.
	command = message;

	-- If /hideit "this stuff" then run a toggle on the related variable.
	-- Gods that sounds dull.

	if (command == "bqueue") then
		if (HideIt[SMHO_Dude].BQueue == 1) then
			HideIt[SMHO_Dude].BQueue = 0;
			ChatMessage("HideIt: Blessing Queue element now shown.");
		else
			HideIt[SMHO_Dude].BQueue = 1;
			ChatMessage("HideIt: Blessing Queue element now hidden.");
		end
	elseif (command == "bqueueunset") then
		HideIt[SMHO_Dude].BQueue = nil;
		ChatMessage("HideIt: Blessing Queue variable removed.");
	elseif (command == "glock") then
		if (HideIt[SMHO_Dude].GLock == 1) then
			HideIt[SMHO_Dude].GLock = 0;
			ChatMessage("HideIt: Gypsy LockButton element now shown.");
		else
			HideIt[SMHO_Dude].GLock = 1;
			ChatMessage("HideIt: Gypsy LockButton element now hidden.");
		end
	elseif (command == "cptoggle") then
		if (HideIt[SMHO_Dude].CPToggle == 1) then
			HideIt[SMHO_Dude].CPToggle = nil;
			ChatMessage("HideIt: CastParty toggle-system disabled.");
		else
			HideIt[SMHO_Dude].CPToggle = 1;
			ChatMessage("HideIt: CastParty toggle-system enabled.");
		end
	elseif (command == "cptogglehelp") then
		CPToggle_Usage();
	elseif (command == "shapeshiftunset") then
		HideIt[SMHO_Dude].Shapeshift = nil;
		ChatMessage("HideIt: Shapeshift/Aura/Stance Bar variable removed.");
	elseif (command == "glockunset") then
		HideIt[SMHO_Dude].GLock = nil;
		ChatMessage("HideIt: Gypsy LockButton variable removed.");
	elseif (command == "mainbar") then
		if (HideIt[SMHO_Dude].MainMenuBar == 1) then
			HideIt[SMHO_Dude].MainMenuBar = 0;
			ChatMessage("HideIt: Main Menu Bar element now shown.");
		else
			HideIt[SMHO_Dude].MainMenuBar = 1;
			ChatMessage("HideIt: Main Menu Bar element now hidden.");
		end
	elseif (command == "mainbarunset") then
		HideIt[SMHO_Dude].MainMenuBar = nil;
		ChatMessage("HideIt: Main Menu Bar variable removed.");
	elseif (command == "party") then
		if (HideIt[SMHO_Dude].Party == 1) then
			HideIt[SMHO_Dude].Party = 0;
			ChatMessage("HideIt: Party element now shown.");
		else
			HideIt[SMHO_Dude].Party = 1;
			ChatMessage("HideIt: Party element now hidden.");
		end
	elseif (command == "partyunset") then
		HideIt[SMHO_Dude].Party = nil;
		ChatMessage("HideIt: Party variable removed.");
	elseif (command == "pet") then
		if (HideIt[SMHO_Dude].Pet == 1) then
			HideIt[SMHO_Dude].Pet = 0;
			ChatMessage("HideIt: Pet Frame element now shown.");
		else
			HideIt[SMHO_Dude].Pet = 1;
			ChatMessage("HideIt: Pet Frame element now hidden.");
		end
	elseif (command == "petunset") then
		HideIt[SMHO_Dude].Pet = nil;
		ChatMessage("HideIt: Pet variable removed.");
	elseif (command == "petbar") then
		if (HideIt[SMHO_Dude].PetBar == 1) then
			HideIt[SMHO_Dude].PetBar = 0;
			ChatMessage("HideIt: Pet ActionBar element now shown.");
		else
			HideIt[SMHO_Dude].PetBar = 1;
			ChatMessage("HideIt: Pet ActionBar element now hidden.");
		end
	elseif (command == "petbarunset") then
		HideIt[SMHO_Dude].PetBar = nil;
		ChatMessage("HideIt: Pet ActionBar variable removed.");
	elseif (command == "player") then
		if (HideIt[SMHO_Dude].Player == 1) then
			HideIt[SMHO_Dude].Player = 0;
			ChatMessage("HideIt: Player Frame element now shown.");
		else
			HideIt[SMHO_Dude].Player = 1;
			ChatMessage("HideIt: Player Frame element now hidden.");
		end
	elseif (command == "playerunset") then
		HideIt[SMHO_Dude].Player = nil;
		ChatMessage("HideIt: Player Frame variable removed.");
	elseif (command == "shapeshift") then
		if (HideIt[SMHO_Dude].Shapeshift == 1) then
			HideIt[SMHO_Dude].Shapeshift = 0;
			ChatMessage("HideIt: Shapeshift/Aura/Stance Bar element now shown.");
		else
			HideIt[SMHO_Dude].Shapeshift = 1;
			ChatMessage("HideIt: Shapeshift/Aura/Stance Bar element now hidden.");
		end
	elseif (command == "shapeshiftunset") then
		HideIt[SMHO_Dude].Shapeshift = nil;
		ChatMessage("HideIt: Shapeshift/Aura/Stance Bar variable removed.");
	elseif (command == "target") then
		if (HideIt[SMHO_Dude].Target == 1) then
			HideIt[SMHO_Dude].Target = 0;
			ChatMessage("HideIt: Target Frame element now shown.");
		else
			HideIt[SMHO_Dude].Shapeshift = 1;
			ChatMessage("HideIt: Target Frame element now hidden.");
		end
	elseif (command == "target") then
		HideIt[SMHO_Dude].Target = nil;
		ChatMessage("HideIt: Target Frame variable removed.");
	elseif (command == "alliancehoohah") then
		IFartInTheirGeneralDirection();
	else
		-- Display command usage for this AddOn.
		HideIt_Usage();
	end

	if not (command == nil) then
		if (strlen(command) > 0) then
			SiMiHiOi_InitChanges();
		end
	end
end

-- *******************************************************

function OpenIt_SlashCmd(message)
	-- First we make sure our player has a name ...
	-- ... if not, let's get a name!
	if (SiMiHiOi_GotName == 0) then
		SiMiHiOi_OnEvent("PLAYER_ENTERING_WORLD");
	end

	-- There are no extra variables to worry about so just double up.
	command = message;

	-- If /openit "this stuff" then run a toggle on the related variable.
	-- Gods that sounds dull.

	if (command == "bags") then
		if (OpenIt[SMHO_Dude].Bags == 1) then
			OpenIt[SMHO_Dude].Bags = 0;
			ChatMessage("OpenIt: The Bags will not be opened.");
		else
			OpenIt[SMHO_Dude].Bags = 1;
			ChatMessage("OpenIt: The Bags will be opened.");
		end
	--[[ Added by Mook Begin ]]
	elseif (command == "bankitems") then
		if (OpenIt[SMHO_Dude].BankItems == 1) then
			OpenIt[SMHO_Dude].BankItems = 0;
			ChatMessage("OpenIt: The Bank Items will not be opened.");
		else
			OpenIt[SMHO_Dude].BankItems = 1;
			ChatMessage("OpenIt: The Bank Items will be opened.");
		end
	--[[ Added by Mook End ]]
	elseif (command == "char") then
		if (OpenIt[SMHO_Dude].Character == 1) then
			OpenIt[SMHO_Dude].Character = 0;
			ChatMessage("OpenIt: The Character window will not be opened.");
		else
			OpenIt[SMHO_Dude].Character = 1;
			ChatMessage("OpenIt: The Character window will be opened.");
		end
	elseif (command == "friends") then
		if (OpenIt[SMHO_Dude].Friends == 1) then
			OpenIt[SMHO_Dude].Friends = 0;
			ChatMessage("OpenIt: The Friends window will not be opened.");
		else
			OpenIt[SMHO_Dude].Friends = 1;
			ChatMessage("OpenIt: The Friends window will be opened.");
		end
	--[[ Added by Mook Begin ]]
	elseif (command == "lootlink") then
		if (OpenIt[SMHO_Dude].LootLink == 1) then
			OpenIt[SMHO_Dude].LootLink = 0;
			ChatMessage("OpenIt: LootLink will not be opened.");
		else
			OpenIt[SMHO_Dude].LootLink = 1;
			ChatMessage("OpenIt: LootLink will be opened.");
		end
	--[[ Added by Mook End ]]
	elseif (command == "quest") then
		if (OpenIt[SMHO_Dude].Quest == 1) then
			OpenIt[SMHO_Dude].Quest = 0;
			ChatMessage("OpenIt: The Quest Log window will not be opened.");
		else
			OpenIt[SMHO_Dude].Quest = 1;
			ChatMessage("OpenIt: The Quest Log window will be opened.");
		end
	elseif (command == "spellbook") then
		if (OpenIt[SMHO_Dude].SpellBook == 1) then
			OpenIt[SMHO_Dude].SpellBook = 0;
			ChatMessage("OpenIt: The SpellBook window will not be opened.");
		else
			OpenIt[SMHO_Dude].SpellBook = 1;
			ChatMessage("OpenIt: The SpellBook window will be opened.");
		end
	elseif (command == "talent") then
		if (OpenIt[SMHO_Dude].Talent == 1) then
			OpenIt[SMHO_Dude].Talent = 0;
			ChatMessage("OpenIt: The Talent window will not be opened.");
		else
			OpenIt[SMHO_Dude].Talent = 1;
			ChatMessage("OpenIt: The Talent window will be opened.");
		end
	elseif (command == "toggle") then
		OpenIt[SMHO_Dude].DoZeCoolJunk();
	elseif (command == "alliancehoohah") then
		IFartInTheirGeneralDirection();
	else
		-- Display command usage for this AddOn.
		OpenIt_Usage();
	end
end

-- *******************************************************

function SiMiHiOiAdvanced_Usage()
	-- Helpfully yet gratuitously relay /smhoadv related information.
	ChatMessage("Usage: /smhoadv <option>");
	ChatMessage("Warning: These might impact your SiMiHiOi experience either positively or negatively, so you use at your own risk, 'kay?");
	ChatMessage("/smhoadv moveitalways ~ Toggles the MoveItContinuously items; off may yield better performance but it may stop certain items from being moved correctly.");
	ChatMessage("/smhoadv onesize ~ Toggles the One Size Fits All (no per-character settings) mode on or off, it's off by default.");
end

-- *******************************************************

function MoveIt_Usage()
	-- Helpfully yet gratuitously relay /moveit related information.
	ChatMessage("Usage: /moveit <option> <x or y>");
	ChatMessage("Clear: /moveit <option> unset");
	--[[ Added by Mook Begin ]]
	ChatMessage("/moveit bankitemsx <x> ~ Moves the Bank Items X-axis.");
	ChatMessage("/moveit bankitemsy <y> ~ Moves the Bank Items Y-axis.");
	--[[ Added by Mook End ]]
	ChatMessage("/moveit buffsx <x> ~ Moves the Buffs X-axis.");
	ChatMessage("/moveit buffsy <y> ~ Moves the Buffs Y-axis.");
	ChatMessage("/moveit castingx <x> ~ Moves the Casting Bar X-axis.");
	ChatMessage("/moveit castingy <y> ~ Moves the Casting Bar Y-axis.");
	ChatMessage("/moviet characterx <x> ~ Moves the Character window X-axis.");
	ChatMessage("/moveit charactery <y> ~ Moves the Character window Y-axis.");
	ChatMessage("/moveit fpsx <x> ~ Moves the FPS Frame X-axis.");
	ChatMessage("/moveit fpsy <y> ~ Moves the FPS Frame Y-axis.")
	ChatMessage("/moveit friendsx <x> ~ Moves the Friends window X-axis.");
	ChatMessage("/moveit friendsy <y> ~ Moves the Friends window Y-axis.");
	--[[ Added by Mook Begin ]]
	ChatMessage("/moveit lootlinkx <x> ~ Moves the LootLink X-axis.");
	ChatMessage("/moveit lootlinky <y> ~ Moves the LootLink Y-axis.");
	--[[ Added by Mook End ]]
	ChatMessage("/moveit mainbarx <x> ~ Moves the Main Menu Bar X-axis.");
	ChatMessage("/moveit mainbary <y> ~ Moves the Main Menu Bar Y-axis.");
	ChatMessage("/moveit minimapx <x> ~ Moves the Minimap X-axis.");
	ChatMessage("/moveit minimapy <y> ~ Moves the Minimap Y-axis.");
	ChatMessage("/moveit mobhpx <x> ~ Moves Telo's MobHealth X-axis.");
	ChatMessage("/moveit mobhpy <y> ~ Moves Telo's MobHealth Y-axis.");
	ChatMessage("/moveit party1x <x> ~ Moves Party Member 1's X-Axis.");
	ChatMessage("/moveit party1y <x> ~ Moves Party Member 1's Y-Axis.");
	ChatMessage("/moveit party2x <x> ~ Moves Party Member 2's X-Axis.");
	ChatMessage("/moveit party2y <x> ~ Moves Party Member 2's Y-Axis.");
	ChatMessage("/moveit party3x <x> ~ Moves Party Member 3's X-Axis.");
	ChatMessage("/moveit party3y <x> ~ Moves Party Member 3's Y-Axis.");
	ChatMessage("/moveit party4x <x> ~ Moves Party Member 4's X-Axis.");
	ChatMessage("/moveit party4y <x> ~ Moves Party Member 4's Y-Axis.");
	ChatMessage("/moveit petx <x> ~ Moves the Pet Frame X-axis.");
	ChatMessage("/moveit pety <y> ~ Moves the Pet Frame Y-axis.");
	ChatMessage("/moveit petbarx <x> ~ Moves the Pet ActionBar X-axis.");
	ChatMessage("/moveit petbary <y> ~ Moves the Pet ActionBar Y-axis.");
	ChatMessage("/moveit playerx <x> ~ Moves the Player Frame X-axis.");
	ChatMessage("/moveit playery <y> ~ Moves the Player Frame Y-axis.");
	ChatMessage("/moveit questx <x> ~ Moves the Quest Log window X-axis.");
	ChatMessage("/moveit questy <y> ~ Moves the Quest Log window Y-axis.");
	ChatMessage("/moveit shapeshiftx <x> ~ Moves the Shapeshift/Stance/Aura Bar X-axis.");
	ChatMessage("/moveit shapeshifty <y> ~ Moves the Shapeshift/Stance/Aura Bar Y-axis.");
	ChatMessage("/moveit sidebarx <x> ~ Moves Telo's SideBar X-axis.");
	ChatMessage("/moveit sidebary <y> ~ Moves Telo's SideBar Y-axis.");
	ChatMessage("/moveit spellx <x> ~ Moves the SpellBook window X-axis.");
	ChatMessage("/moveit spelly <y> ~ Moves the SpellBook window Y-axis.");
	ChatMessage("/moveit talentx <x> ~ Moves the Talent window X-axis.");
	ChatMessage("/moveit talenty <y> ~ Moves the Talent window Y-axis.");
	ChatMessage("/moveit targetx <x> ~ Moves the Target Frame X-axis.");
	ChatMessage("/moveit targety <y> ~ Moves the Target Frame Y-axis.");
	ChatMessage("/moveit alliance hoohah ~ You'd have to try it and see.");
end

-- *******************************************************

function HideIt_Usage()
	-- Helpfully yet gratuitously relay /hideit related information.
	ChatMessage("Usage: /hideit <toggle>");
	ChatMessage("/hideit bqueue ~ Toggles UnknownEntity's Blessing Queue.");
	ChatMessage("/hideit bqueueunset ~ Removes the setting for UnknownEntity's Blessing Queue.");
	ChatMessage("/hideit glock ~ Toggles Mondinga's Gypsy LockButton.");
	ChatMessage("/hideit glockunset ~ Removes the setting for Mondinga's Gypsy LockButton.");
	ChatMessage("/hideit mainbar ~ Toggles the Main Menu Bar.");
	ChatMessage("/hideit mainbarunset ~ Removes the setting for Main Menu Bar.");
	ChatMessage("/hideit party ~ Toggles the Party Frame.");
	ChatMessage("/hideit partyunset ~ Removes the setting for Party Frame.");
	ChatMessage("/hideit pet ~ Toggles the Pet Frame.");
	ChatMessage("/hideit petunset ~ Removes the setting for Pet Frame.");
	ChatMessage("/hideit petbar ~ Toggles the Pet ActionBar.");
	ChatMessage("/hideit petbarunset ~ Removes the setting for Pet ActionBar.");
	ChatMessage("/hideit player ~ Toggles the Player Frame.");
	ChatMessage("/hideit playerunset ~ Removes the setting for Player Frame.");
	ChatMessage("/hideit shapeshift ~ Toggles the Shapeshift/Stance/Aura Bar.");
	ChatMessage("/hideit shapeshiftunset ~ Removes the setting for Shapeshift/Stance/Aura Bar.");
	ChatMessage("/hideit target ~ Toggles the Target Frame.");
	ChatMessage("/hideit target ~ Removes the setting for Target Frame.");
	ChatMessage("/hideit alliancehoohah ~ You'd have to try it and see.");
	ChatMessage("/hideit cptoggle ~ Hide and show things relevant to CastParty.");
	ChatMessage("Notes: Type /hideit cptogglehelp for more info.");
end

-- *******************************************************

function CPToggle_Usage()
	ChatMessage("This provides functionality to do the following:");
	ChatMessage("If the character is not a Rogue or a Fighter then the Player and Party Frames will be hidden and the CastParty frame will be shown.");
	ChatMessage("Opposedly, if the character is a Rogue or a Fighter, CastParty will be hidden and the Player and Party Frames will be shown.");
	ChatMessage("Warning: This requires the CastParty AddOn to function.");
	ChatMessage("As an additional bonus, this works with the two XP bar AddOns out there.");
	ChatMessage("PlayerFrameXPBar will be used if CastParty is hidden but XPBar will be used if it's not.");
	ChatMessage("Both of these are in the FouR compilation.");
	ChatMessage("http://mastaile.mine.nu/FouR.zip");
end

-- *******************************************************

function OpenIt_Usage()
	-- Helpfully yet gratuitously relay /openit related information.
	ChatMessage("Usage: /openit <toggle>");
	ChatMessage("/openit bags ~ Toggles whether the Bags open.");
	--[[ Added by Mook Begin ]]
	ChatMessage("/openit bankitems ~ Toggles whether the Bank Items window open.");
	--[[ Added by Mook End ]]
	ChatMessage("/openit char ~ Toggles whether the Character window opens.");
	ChatMessage("/openit friends ~ Toggles whether the Friends window opens.");
	--[[ Added by Mook Begin ]]
	ChatMessage("/openit lootlink ~ Toggles whether the LootLink window opens.");
	--[[ Added by Mook End ]]
	ChatMessage("/openit quest ~ Toggles whether the Quest Log window opens.");
	ChatMessage("/openit spellbook ~ Toggles whether the SpellBook window opens.");
	ChatMessage("/openit talent ~ Toggles whether the Talent window opens.");
	ChatMessage("/openit alliancehoohah ~ You'd have to try it and see.");
end

-- *******************************************************

function ScaleIt_Usage()
	-- Helpfully yet gratuitously relay /scaleit related information.
	ChatMessage("Usage: /scaleit <option> <value>");
	ChatMessage("Clear: /scaleit <option> unset");
	ChatMessage("/scaleit scale <value> ~ full UI rescale where sane values are 0.5 to 2.0.");
	ChatMessage("/scaleit aioi <value> ~ Scales All in One Inventory.");
	ChatMessage("/scaleit auction <value> ~ Scales the Auction House window.");
	ChatMessage("/scaleit avgxp <value> ~ Scales Jinx's AvgXP.");
	ChatMessage("/scaleit bags <value> ~ Scales the Bags.");
	ChatMessage("/scaleit bank <value> ~ Scales the Bank window.");
	--[[ Added by Mook Begin ]]
	ChatMessage("/scaleit bankitems <value> ~ Scales the Bank Items window.");
	--[[ Added by Mook End ]]
	ChatMessage("/scaleit bsm <value> ~ Scales Madorin's Bag Status Meters.");
	ChatMessage("/scaleit bsmtext <value> ~ Scales Madorin's Bag Status Meters text.");
	ChatMessage("/scaleit buff <value> ~ Scales the Buffs.");
	ChatMessage("/scaleit bufftime <value> ~ Scales Telo's BuffTimers.");
	ChatMessage("/scaleit casting <value> ~ Scales the Casting Bar.");
	ChatMessage("/scaleit castparty <value> ~ Scales Danboo's CastParty.");
	ChatMessage("/scaleit char <value> ~ Scales the Character window.");
	ChatMessage("/scaleit classtrain <value> ~ Scales the ClassTrainer window.");
	ChatMessage("/scaleit clock <value> ~ Scales Telo's Clock.");
	ChatMessage("/scaleit cooldown <value> ~ Scales Saien's CooldownHUD");
	ChatMessage("/scaleit craft <value> ~ Scales the Crafting window.");
	ChatMessage("/scaleit friends <value> ~ Scales the Friends window.");
	ChatMessage("/scaleit gypsybar <value> ~ Scales Mondinga's GypsyMod-Hotbar.");
	ChatMessage("/scaleit itembuff <value> ~ Scales Telo's ItemBuffs.");
	ChatMessage("/scaleit lagbar <value> ~ Scales Svarten's LagBar.");
	ChatMessage("/scaliet loccoord <value> ~ Scales Zavier's Location Coordinates.");
	ChatMessage("/scaleit lfgp <value> ~ Scales Sole's LookingForGroup Paste window (full).");
	ChatMessage("/scaleit lfgpmini <value> ~ Scales Sole's LookingForGroup Paste window (minimized).");
	ChatMessage("/scaleit loot <value> ~ Scales the Loot window.");
	ChatMessage("/scaleit lootlink <value> ~ Scales Telo's LootLink.");
	ChatMessage("/scaleit macro <value> ~ Scales the Macros window.");
	ChatMessage("/scaleit mail <value> ~ Scales the Mail window.");
	ChatMessage("/scaleit mainbar <value> ~ Scales the Main Menu Bar.");
	ChatMessage("/scaleit minimap <value> ~ Scales the Minimap.");
	ChatMessage("/scaleit mobhp <value> ~ Scales Telo's MobHealth.");
	ChatMessage("/scaleit moneydisp <value> ~ Scales Madorin's Money Display.");
	ChatMessage("/scaleit mquest <value> ~ Scales Trentin's Monkey Quest.");
	ChatMessage("/scaleit notepad <value> ~ Scales Vladimir's Notepad.");
	ChatMessage("/scaleit party <value> ~ Scales the Party Frame.");
	ChatMessage("/scaleit pet <value> ~ Scales the Pet Frame.");
	ChatMessage("/scaleit petbar <value> ~ Scales the Pet ActionBar.");
	ChatMessage("/scaleit player <value> ~ Scales the Player Frame.");
	ChatMessage("/scaleit popbar <value> ~ Scales Cosmos' PopBar.");
	ChatMessage("/scaleit ppets <value> ~ Scales Dreyruugr's PartyPets.");
	ChatMessage("/scaleit quest <value> ~ Scales the Quest and Quest Log windows.");
	ChatMessage("/scaleit questtimer <value> ~ Scales the Quest Timer window.");	
	ChatMessage("/scaleit questtip <value> ~ Scales the QuestMinion Tooltip.");
	ChatMessage("/scaleit raid <value> ~ Scales the Raid window.");
	ChatMessage("/scaleit rlist <value> ~ Scales the Reagent List window.");
	ChatMessage("/scaleit roguehelp <value> ~ Scales Sarf's RogueHelper");
	ChatMessage("/scaleit shapeshift <value> ~ Scales the Shapeshift/Stance/Aura Bar.");
	ChatMessage("/scaleit shop <value> ~ Scales the Merchant window.");
	ChatMessage("/scaleit sidebar <value> ~ Scales Telo's Sidebar and/or Cosmos Right Sidebar.");
	ChatMessage("/scaleit sidebar2 <value> ~ Scales Cosmos' Left Sidebar.");
	ChatMessage("/scaleit skill <value> ~ Scales the Skills window");
	ChatMessage("/scaleit spellbook <value> ~ Scales the SpellBook window.");
	ChatMessage("/scaleit stable <value> ~ Scales the Pet Stables window.");
	ChatMessage("/scaleit sunder <value> ~ Scales Miron's SunderThis.");
	ChatMessage("/scaleit tabbard <value> ~ Scales the Tabbard window.");
	ChatMessage("/scaleit talent <value> ~ Scales the Talent window.");
	ChatMessage("/scaleit talenttrain <value> ~ Scales the Talent Trainer window.");
	ChatMessage("/scaleit target <value> ~ Scales the Target Frame.");
	ChatMessage("/scaleit taxi <value> ~ Scales the Air Travel window.");
	ChatMessage("/scaleit tooltip <value> ~ Scales the tooltip, globally.");
	ChatMessage("/scaleit totembar <value> ~ Scales Saien's TotemBar.");
	ChatMessage("/scaleit ttimers <value> ~ Scales Micah's TotemTimers.");
	ChatMessage("/scaleit trade <value> ~ Scales the Trade window.");
	ChatMessage("/scaleit wbuttons <value> ~ Scales Sarf's Weapon Buttons.");
	ChatMessage("/scaleit xpbar <value> ~ Scales Malvasius's Floating XP Bar.");
	ChatMessage("/scaleit alliance hoohah ~ You'd have to try it and see.");
end

-- *******************************************************

function IFartInTheirGeneralDirection()
--	This is not the function you're looking for.
-- Move along, move along ...

	local race = UnitRace("player");
	ChatMessage("Remember kids, the Alliance are the bad guys!");
	ChatMessage("1) Never trust a man in shining armour who offers you candy, you don't know where it's been ...");
	ChatMessage("2) Don't accept a ride on his Horse if he offers you one without at least defining 'ride' first.");
	ChatMessage("3) If he claims to wish to 'save' you from anything, ensure he means save and not enslave.");
	ChatMessage("...");
	if (race == "Human" or race == "Gnome" or race == "Night-Elf" or race == "Dwarf") then
		AllianceGoofs = {
			"Crunchy on the outsoide, soft on the insoide ... oi loikes Armadillos!  Hur hur hur.",
			"I say, chaps!  Who's up for a round of Gnome-Golf?  I'll just go and round up the Gnomes ...",
			"I have a Ferret in my armour and it feels so good.  So very, very good.",
			"What's this?  Oh Pumpkin, sweet Pumpkin.  Ach!  My mind... my body... I'm rotting!  I think ...",
			"Yes, I mount my ride and ride my mount daily.  What's it to you?  Well?!"
		};
		message = AllianceGoofs[math.random(table.getn(AllianceGoofs))];
		SendChatMessage(message, SAY);
	else
		ChatMessage("You just know some ninny's going to 'invade' the Crossroads over this, don't you?");
	end
end

-- *******************************************************

function SiMiHiOi_OnEvent(event)
	-- Yell stuff at the user.
	-- Hi!  I'm an ADDON.  I'm active.  Look at me! I'm shiny!

	if (event == "VARIABLES_LOADED") then
		ChatMessage("AddOn 'SiMiHiOi " .. SIMIHIOI_VERSION .. "' [Author: Rowne] [Contributors: " .. SIMIHIOI_CONTRIBUTORS .. "] [Fixers: " .. SIMIHIOI_FIXERS .."] Initialized.");
		SiMiHiOi_VarsLoaded = 1;
	-- The following is all about getting names.  Later on
	-- we'll check our GotName often and if it's 0, we'll
	-- come back here until we've got that damn name.
	elseif (event == "UNIT_NAME_UPDATE" or event == "PLAYER_ENTERING_WORLD") then
		if (SiMiHiOi_GotName == 1) then
			return;
		end
		if (SiMiHiOi_OneSizeFitsAll == 1) then
			SMHO_Dude = "TheMuffinMan";
		else
			SMHO_Dude = UnitName("player");
		end
		if (SMHO_Dude == nil) or (SMHO_Dude == "Unknown Entity") or (SMHO_Dude == UNKNOWNBEING) then
			SiMiHiOi_GotName = 0;
			return;
		else
			SiMiHiOi_GotName = 1;
			SiMiHiOi_SetupVars(SMHO_Dude);
			return;
		end
	end
end

function SiMiHiOi_SetupVars(arg)
	if (ScaleIt == nil) then
		ScaleIt = {};
	end
	if (ScaleIt[arg] == nil) then
		ScaleIt[arg] = {};
	end
	if (MoveIt == nil) then
		MoveIt = {};
	end
	if (MoveIt[arg] == nil) then
		MoveIt[arg] = {};
	end
	if (HideIt == nil) then
		HideIt = {};
	end
	if (HideIt[arg] == nil) then
		HideIt[arg] = {};
	end
	if (OpenIt == nil) then
		OpenIt = {};
	end
	if (OpenIt[arg] == nil) then
		OpenIt[arg] = {};
	end
end

-- *******************************************************

function SiMiHiOi_OnUpdate()
	-- First we make sure our player has a name ...
	-- ... if not, let's get a name!
	if (SiMiHiOi_GotName == 0) then
		SiMiHiOi_OnEvent("PLAYER_ENTERING_WORLD");
		return;
	end

	-- Next we ensure one function runs but once, on
	-- load or reload.  As if we don't do this, thine
	-- FPS will corrode.  Or something.

	if (SiMiHiOi_HasInitChanges == 0 and SiMiHiOi_VarsLoaded) then
		SiMiHiOi_InitChanges();
		SiMiHiOi_HasInitChanges = 1;
	end

	-- The rest can run as often as they like, free
	-- These two values are controlled by the /smhoadv
	-- slash-command.
	if (MoveIt[SMHO_Dude].ShouldUpdateContinuously == nil) then
		MoveIt[SMHO_Dude].ShouldUpdateContinuously = 0;
	end

	if (HideIt[SMHO_Dude].ShouldUpdateContinuously == nil) then
		HideIt[SMHO_Dude].ShouldUpdateContinuously = 0;
	end

	-- and merry to set themsleves endlessly.
	-- First we check our variables, make sure
	-- they're not blank.  For if we scale withoout
	-- them, one's UI is sank.  Once this is certain
	-- without shadow of doubt, we call forth the
	-- frame and reshape it about.
	--
	-- ...
	--
	-- Now the voices in mine head are yelling,
	-- against the endless rhyming they're rebelling.
	-- But I suspect you're gouging out your eyes
	-- about now too.  Ahwell, nutbunnies and such.

	if (ScaleIt[SMHO_Dude].Gypsy ~= nil) then
		Gypsy_HotBarCapsule:SetScale(ScaleIt[SMHO_Dude].Gypsy);
		MainMenuBar:SetScale(ScaleIt[SMHO_Dude].Gypsy);
		Gypsy_ActionBar:SetScale(ScaleIt[SMHO_Dude].Gypsy);
	end

	if (ScaleIt[SMHO_Dude].SideBar ~= nil) then
		SideBar:SetScale(ScaleIt[SMHO_Dude].SideBar);
	end
	
	if (ScaleIt[SMHO_Dude].SideBar2 ~= nil) then
		SideBar2:SetScale(ScaleIt[SMHO_Dude].SideBar2);
	end

	if (ScaleIt[SMHO_Dude].Gypsy == nil and ScaleIt[SMHO_Dude].MainMenuBar ~= nil) then
		MainMenuBar:SetScale(ScaleIt[SMHO_Dude].MainMenuBar);
	end

	if (ScaleIt[SMHO_Dude].Player ~= nil) then
		PlayerFrame:SetScale(ScaleIt[SMHO_Dude].Player);
	end

	if (ScaleIt[SMHO_Dude].Target ~= nil) then	
		TargetFrame:SetScale(ScaleIt[SMHO_Dude].Target);
	end
	
	if (ScaleIt[SMHO_Dude].PetBar ~= nil) then	
		PetActionBarFrame:SetScale(ScaleIt[SMHO_Dude].PetBar);
	end

	if (ScaleIt[SMHO_Dude].Shapeshift ~= nil) then
		ShapeshiftBarFrame:SetScale(ScaleIt[SMHO_Dude].Shapeshift);
	end

	if (ScaleIt[SMHO_Dude].Minimap ~= nil) then	
		MinimapCluster:SetScale(ScaleIt[SMHO_Dude].Minimap);
	end

	if (ScaleIt[SMHO_Dude].Buffs ~= nil) then	
		BuffFrame:SetScale(ScaleIt[SMHO_Dude].Buffs);
	end

	if (ScaleIt[SMHO_Dude].BuffTime ~= nil) then	
		BuffTimersFrame:SetScale(ScaleIt[SMHO_Dude].BuffTime);
	end

	if (ScaleIt[SMHO_Dude].QuestTip ~= nil) then	
		QuestTooltip:SetScale(ScaleIt[SMHO_Dude].QuestTip);
	end

	if (ScaleIt[SMHO_Dude].Bank ~= nil) then	
		BankFrame:SetScale(ScaleIt[SMHO_Dude].Bank);
	end
	--[[ Added by Mook Begin ]]
	if (ScaleIt[SMHO_Dude].BankItems ~= nil) then	
		BankItems_Frame:SetScale(ScaleIt[SMHO_Dude].BankItems);
	end
	--[[ Added by Mook End ]]
	if (ScaleIt[SMHO_Dude].Casting ~= nil) then	
		CastingBarFrame:SetScale(ScaleIt[SMHO_Dude].Casting);
		CastingBarFlash:SetScale(ScaleIt[SMHO_Dude].Casting);
		CastingBarFrameStatusBar:SetScale(ScaleIt[SMHO_Dude].Casting);
	end

	if (ScaleIt[SMHO_Dude].Character ~= nil) then	
		CharacterFrame:SetScale(ScaleIt[SMHO_Dude].Character);
	end

	if (ScaleIt[SMHO_Dude].ClassTrain ~= nil) then	
		ClassTrainerFrame:SetScale(ScaleIt[SMHO_Dude].ClassTrain);
	end

	if (ScaleIt[SMHO_Dude].AIOI ~= nil) then	
		AllInOneInventoryFrame:SetScale(ScaleIt[SMHO_Dude].AIOI);
	end

	if (ScaleIt[SMHO_Dude].Bags ~= nil) then	
		ContainerFrame1:SetScale(ScaleIt[SMHO_Dude].Bags);
		ContainerFrame2:SetScale(ScaleIt[SMHO_Dude].Bags);
		ContainerFrame3:SetScale(ScaleIt[SMHO_Dude].Bags);
		ContainerFrame4:SetScale(ScaleIt[SMHO_Dude].Bags);
		ContainerFrame5:SetScale(ScaleIt[SMHO_Dude].Bags);
		ContainerFrame6:SetScale(ScaleIt[SMHO_Dude].Bags);
	end

	if (ScaleIt[SMHO_Dude].Craft ~= nil) then	
		CraftFrame:SetScale(ScaleIt[SMHO_Dude].Craft);
	end

	if (ScaleIt[SMHO_Dude].Loot ~= nil) then	
		LootFrame:SetScale(ScaleIt[SMHO_Dude].Loot);
	end

	if (ScaleIt[SMHO_Dude].Macros ~= nil) then	
		MacroFrame:SetScale(ScaleIt[SMHO_Dude].Macros);
	end

	if (ScaleIt[SMHO_Dude].Mail ~= nil) then	
		MailFrame:SetScale(ScaleIt[SMHO_Dude].Mail);
	end

	if (ScaleIt[SMHO_Dude].Merchant ~= nil) then
		MerchantFrame:SetScale(ScaleIt[SMHO_Dude].Merchant);
	end

	if (ScaleIt[SMHO_Dude].Party ~= nil) then
		PartyMemberFrame1:SetScale(ScaleIt[SMHO_Dude].Party);
		PartyMemberFrame2:SetScale(ScaleIt[SMHO_Dude].Party);
		PartyMemberFrame3:SetScale(ScaleIt[SMHO_Dude].Party);
		PartyMemberFrame4:SetScale(ScaleIt[SMHO_Dude].Party);
	end

	if (ScaleIt[SMHO_Dude].Pet ~= nil) then
		PetFrame:SetScale(ScaleIt[SMHO_Dude].Pet);
	end

	if (ScaleIt[SMHO_Dude].PPets ~= nil) then
		PartyPetsFrame:SetScale(ScaleIt[SMHO_Dude].PPets);
	end

	if (ScaleIt[SMHO_Dude].Stable ~= nil) then
		PetStable:SetScale(ScaleIt[SMHO_Dude].Stable);
	end

	if (ScaleIt[SMHO_Dude].Quest ~= nil) then	
		QuestFrame:SetScale(ScaleIt[SMHO_Dude].Quest);
		QuestLogFrame:SetScale(ScaleIt[SMHO_Dude].Quest);
	end

	if (ScaleIt[SMHO_Dude].Timer ~= nil) then	
		QuestTimerFrame:SetScale(ScaleIt[SMHO_Dude].Timer);
	end

	if (ScaleIt[SMHO_Dude].Raid ~= nil) then	
		RaidFrame:SetScale(ScaleIt[SMHO_Dude].Raid);
	end

	if (ScaleIt[SMHO_Dude].Skill ~= nil) then	
		SkillFrame:SetScale(ScaleIt[SMHO_Dude].Skill);
	end

	if (ScaleIt[SMHO_Dude].SpellBook ~= nil) then	
		SpellBookFrame:SetScale(ScaleIt[SMHO_Dude].SpellBook);
	end

	if (ScaleIt[SMHO_Dude].Tabbard ~= nil) then	
		TabbardFrame:SetScale(ScaleIt[SMHO_Dude].Tabbard);
	end

	if (ScaleIt[SMHO_Dude].Talent ~= nil) then	
		TalentFrame:SetScale(ScaleIt[SMHO_Dude].Talent);
	end

	if (ScaleIt[SMHO_Dude].TalentTrain ~= nil) then	
		TalentTrainerFrame:SetScale(ScaleIt[SMHO_Dude].TalentTrain);
	end

	if (ScaleIt[SMHO_Dude].Trade ~= nil) then	
		TradeFrame:SetScale(ScaleIt[SMHO_Dude].Trade);
	end

	if (ScaleIt[SMHO_Dude].CastParty ~= nil) then	
		CastPartyMainFrame:SetScale(ScaleIt[SMHO_Dude].CastParty);
	end

	if (ScaleIt[SMHO_Dude].TotemBar ~= nil) then	
		TotemBar:SetScale(ScaleIt[SMHO_Dude].TotemBar);
	end
	
	if (ScaleIt[SMHO_Dude].ToTimers ~= nil) then	
		TotemTimerFrame:SetScale(ScaleIt[SMHO_Dude].ToTimers);
	end

	if (ScaleIt[SMHO_Dude].Tooltip ~= nil) then	
		GameTooltip:SetScale(ScaleIt[SMHO_Dude].Tooltip);
	end

	if (ScaleIt[SMHO_Dude].Taxi ~= nil) then	
		TaxiFrame:SetScale(ScaleIt[SMHO_Dude].Taxi);
	end

	if (ScaleIt[SMHO_Dude].ReagList ~= nil) then
		ReagentListFrame:SetScale(ScaleIt[SMHO_Dude].ReagList);
	end

	if (ScaleIt[SMHO_Dude].CoolHUD ~= nil) then
		CooldownHud:SetScale(ScaleIt[SMHO_Dude].CoolHUD);
	end

	if (ScaleIt[SMHO_Dude].LootLink ~= nil) then
		LootLinkFrame:SetScale(ScaleIt[SMHO_Dude].LootLink);
	end
	
	if (ScaleIt[SMHO_Dude].Notepad ~= nil) then
		NotepadFrame:SetScale(ScaleIt[SMHO_Dude].Notepad);
	end
	
	if (ScaleIt[SMHO_Dude].RogueHelp ~= nil) then
		RogueHelperFrame:SetScale(ScaleIt[SMHO_Dude].RogueHelp);
	end
	
	if (ScaleIt[SMHO_Dude].ItemBuff ~= nil) then
		ItemBuffFrame:SetScale(ScaleIt[SMHO_Dude].ItemBuff);
	end

	if (ScaleIt[SMHO_Dude].BSM ~= nil) then
		getglobal(BSM_FRAME):SetScale(ScaleIt[SMHO_Dude].BSM);
	end

	if (ScaleIt[SMHO_Dude].BSMText ~= nil) then
		getglobal(BSM_BARS_LABELS):SetScale(ScaleIt[SMHO_Dude].BSMText);
	end

	if (ScaleIt[SMHO_Dude].XPBar ~= nil) then
		PS_XPBar:SetScale(ScaleIt[SMHO_Dude].XPBar);
		PlayerStatusFrame:SetScale(ScaleIt[SMHO_Dude].XPBar); 
	end

	if (ScaleIt[SMHO_Dude].XPClock ~= nil) then
		XPClock:SetScale(ScaleIt[SMHO_Dude].XPClock);
	end

	if (ScaleIt[SMHO_Dude].PopBar ~= nil) then
		PopBar:SetScale(ScaleIt[SMHO_Dude].PopBar);
	end

	if (ScaleIt[SMHO_Dude].MoneyDisp ~= nil) then
		getglobal("MoneyDisplayFrame"):SetScale(ScaleIt[SMHO_Dude].MoneyDisp);
	end

	if (ScaleIt[SMHO_Dude].MQuest ~= nil) then
		MonkeyQuestFrame:SetScale(ScaleIt[SMHO_Dude].MQuest);
	end

	if (ScaleIt[SMHO_Dude].Sunder ~= nil) then
		SunderThis:SetScale(ScaleIt[SMHO_Dude].Sunder);
	end

	if (ScaleIt[SMHO_Dude].MobHealth ~= nil) then
		MobHealthFrame:SetScale(ScaleIt[SMHO_Dude].MobHealth);
	end

	if (ScaleIt[SMHO_Dude].Clock ~= nil) then
		ClockFrame:SetScale(ScaleIt[SMHO_Dude].Clock);
	end

	if (ScaleIt[SMHO_Dude].Auction ~= nil) then
		AuctionFrame:SetScale(ScaleIt[SMHO_Dude].Auction);
	end

	if (ScaleIt[SMHO_Dude].AvgXP ~= nil) then
		AvgXP:SetScale(ScaleIt[SMHO_Dude].AvgXP);
	end

	if (ScaleIt[SMHO_Dude].LFGP ~= nil) then
		LFG_Paste_Frame:SetScale(ScaleIt[SMHO_Dude].LFGP);
	end

	if (ScaleIt[SMHO_Dude].LFGPMini ~= nil) then
		LFG_Paste_MiniFrame:SetScale(ScaleIt[SMHO_Dude].LFGPMini);
	end

	if (ScaleIt[SMHO_Dude].WeapButt ~= nil) then
		WeaponButtonsFrame:SetScale(ScaleIt[SMHO_Dude].WeapButt);
	end

	if (ScaleIt[SMHO_Dude].Friends ~= nil) then
		FriendsFrame:SetScale(ScaleIt[SMHO_Dude].Friends);
	end

	if (ScaleIt[SMHO_Dude].FPS ~= nil) then
		FramerateLabel:SetScale(ScaleIt[SMHO_Dude].FPS);
	end

	if (ScaleIt[SMHO_Dude].LagBar ~= nil) then
		LD_Frame:SetScale(ScaleIt[SMHO_Dude].LagBar);
	end

	if (ScaleIt[SMHO_Dude].LocCoord ~= nil) then
		LocFrame:SetScale(ScaleIt[SMHO_Dude].LocCoord);
	end

	if (MoveIt[SMHO_Dude].ShouldUpdateContinuously == 1) then
		if (MoveIt[SMHO_Dude].CastingX ~= nil and MoveIt[SMHO_Dude].CastingY ~= nil) then
			CastingBarFrame:ClearAllPoints();
			CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", MoveIt[SMHO_Dude].CastingY, MoveIt[SMHO_Dude].CastingX -9);
			CastingBarFlash:ClearAllPoints();
			CastingBarFlash:SetPoint("BOTTOM", "UIParent", "BOTTOM", MoveIt[SMHO_Dude].CastingY, MoveIt[SMHO_Dude].CastingX -22);
			CastingBarFrameStatusBar:ClearAllPoints();
			CastingBarFrameStatusBar:SetPoint("BOTTOM", "UIParent", "BOTTOM", MoveIt[SMHO_Dude].CastingY, MoveIt[SMHO_Dude].CastingX +3);
			CastingBarText:ClearAllPoints();
			CastingBarText:SetPoint("BOTTOM", "UIParent", "BOTTOM", MoveIt[SMHO_Dude].CastingY, MoveIt[SMHO_Dude].CastingX +3);
		end

		if (MoveIt[SMHO_Dude].PetBarX ~= nil and MoveIt[SMHO_Dude].PetBarY ~= nil) then
			PetActionBarFrame:ClearAllPoints();
			PetActionBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", MoveIt[SMHO_Dude].PetBarY, MoveIt[SMHO_Dude].PetBarX);
		end
	
		if (MoveIt[SMHO_Dude].ShapeshiftX ~= nil and MoveIt[SMHO_Dude].ShapeshiftY ~= nil) then
			ShapeshiftBarFrame:ClearAllPoints();
			ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", MoveIt[SMHO_Dude].ShapeshiftY, MoveIt[SMHO_Dude].ShapeshiftX);
		end

		if (MoveIt[SMHO_Dude].BuffsX ~= nil and MoveIt[SMHO_Dude].BuffsY ~= nil) then
			BuffFrame:ClearAllPoints();
			BuffFrame:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", MoveIt[SMHO_Dude].BuffsY, MoveIt[SMHO_Dude].BuffsX);
		end

		if (MoveIt[SMHO_Dude].CharacterX ~= nil and MoveIt[SMHO_Dude].CharacterY ~= nil) then
			CharacterFrame:ClearAllPoints();
			CharacterFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", MoveIt[SMHO_Dude].CharacterY, MoveIt[SMHO_Dude].CharacterX);
		end
	end
	
	if (HideIt[SMHO_Dude].ShouldUpdateContinuously == 1) then
	-- A frame followed by hide(); will always do that.
	-- A frame followed by show(); will do just that too.

		if (HideIt[SMHO_Dude].MainMenuBar == 1) then
			MainMenuBar:Hide();
			if (HideIt[SMHO_Dude].PetBar ~= 1) then
				PetActionBarFrame:Show();
			end
		else
			MainMenuBar:Show();
		end
	
		if (HideIt[SMHO_Dude].PetBar == nil) then
			-- Do nothing.
		elseif (HideIt[SMHO_Dude].PetBar == 1 or not UnitExists("pet")) then
			PetActionBarFrame:Hide();
		elseif (HideIt[SMHO_Dude].PetBar ~= 1 or UnitExists("pet")) then
			PetActionBarFrame:Show();
		end
	
		if (HideIt[SMHO_Dude].Shapeshift == nil) then
			-- Do nothing.
		elseif (HideIt[SMHO_Dude].Shapeshift == 1) then
			ShapeshiftBarFrame:Hide();
		else
			ShapeshiftBarFrame:Show();
		end

		if (HideIt[SMHO_Dude].Target == nil) then
			-- Do nothing.
		elseif (HideIt[SMHO_Dude].Target == 1) then
			TargetFrame:Hide();
		else
			TargetFrame:Show();
		end
	end
end

-- *******************************************************

function OpenIt_DoZeCoolJunk()
	-- First we make sure our player has a name ...
	-- ... if not, let's get a name!
	if (SiMiHiOi_GotName == 0) then
		SiMiHiOi_OnEvent("PLAYER_ENTERING_WORLD");
		return;
	end

	-- Are our variables blank?  If so ...
	-- none of that!  Bad variables!
	-- Grab a number, good variables.

	if (OpenIt[SMHO_Dude].Bags == nil) then
		OpenIt[SMHO_Dude].Bags = 1;
	end

	--[[ Added by Mook Begin ]]
	if (OpenIt[SMHO_Dude].BankItems == nil) then
		OpenIt[SMHO_Dude].BankItems = 1;
	end
	--[[ Added by Mook End ]]

	if (OpenIt[SMHO_Dude].Character == nil) then
		OpenIt[SMHO_Dude].Character = 1;
	end

	if (OpenIt[SMHO_Dude].Friends == nil) then
		OpenIt[SMHO_Dude].Friends = 1;
	end

	if (OpenIt[SMHO_Dude].Quest == nil) then
		OpenIt[SMHO_Dude].Quest = 1;
	end

	--[[ Added by Mook Begin ]]
	if (OpenIt[SMHO_Dude].LootLink == nil) then
		OpenIt[SMHO_Dude].LootLink = 1;
	end
	--[[ Added by Mook End ]]

	if (OpenIt[SMHO_Dude].SpellBook == nil) then
		OpenIt[SMHO_Dude].SpellBook = 1;
	end

	if (OpenIt[SMHO_Dude].Talent == nil) then
		OpenIt[SMHO_Dude].Talent = 1;
	end

	-- Okay, first we check our variables ...
	-- then we check if it's visible and after that ...
	-- we do the toggle dance.  Get jiggy with it!

	if (OpenIt[SMHO_Dude].Bags == 1) then
		if (AllInOneInventory_ReplaceBags == 1) then
			if (AllInOneInventoryFrame:IsVisible()) then
				AllInOneInventoryFrame:Hide();
			else
				AllInOneInventoryFrame:Show();
			end
		else
			if (ContainerFrame1:IsVisible()) then
				ContainerFrame1:Hide();
				ContainerFrame2:Hide();
				ContainerFrame3:Hide();
				ContainerFrame4:Hide();
				ContainerFrame5:Hide();
				ContainerFrame6:Hide();
			else
				ContainerFrame1:Show();
				ContainerFrame2:Show();
				ContainerFrame3:Show();
				ContainerFrame4:Show();
				ContainerFrame5:Show();
				ContainerFrame6:Show();
			end
		end
	end

	--[[ Added by Mook Begin ]]
	if (OpenIt[SMHO_Dude].BankItems == 1) then
		if (BankItems_Frame:IsVisible()) then
			BankItems_Frame:Hide();
		else
			BankItems_Frame:Show();
		end
	end
	--[[ Added by Mook End ]]

	if (OpenIt[SMHO_Dude].Character == 1) then
		if (CharacterFrame:IsVisible()) then
			CharacterFrame:Hide();
		else
			CharacterFrame:Show();
		end
	end

	if (OpenIt[SMHO_Dude].Friends == 1) then
		if (FriendsFrame:IsVisible()) then
			FriendsFrame:Hide();
		else
			FriendsFrame:Show();
		end
	end

	if (OpenIt[SMHO_Dude].Quest == 1) then
		if (QuestLogFrame:IsVisible()) then
			QuestLogFrame:Hide();
		else
			QuestLogFrame:Show();
		end
	end

	--[[ Added by Mook Begin ]]
	if (OpenIt[SMHO_Dude].LootLink == 1) then
		if (LootLinkFrame:IsVisible()) then
			LootLinkFrame:Hide();
		else
			LootLinkFrame:Show();
		end
	end
	--[[ Added by Mook End ]]

	if (OpenIt[SMHO_Dude].SpellBook == 1) then
		if (SpellBookFrame:IsVisible()) then
			SpellBookFrame:Hide();
		else
			SpellBookFrame:Show();
		end
	end
	
	if (OpenIt[SMHO_Dude].Talent == 1) then
		if (TalentFrame:IsVisible()) then
			TalentFrame:Hide();
		else
			TalentFrame:Show();
		end
	end

	-- Okay, so we open our stuff and all is cool.
	-- Yet they reset and things turn uncool.
	-- This is because Rowne forgot a function-call,
	-- what a fool.
	SiMiHiOi_InitChanges();
end

-- *******************************************************

function SiMiHiOi_InitChanges()
	-- First we make sure our player has a name ...
	-- ... if not, let's get a name!
	if (SiMiHiOi_GotName == 0) then
		SiMiHiOi_OnEvent("PLAYER_ENTERING_WORLD");
		return;
	end

	--	ClearAllPoints: Resets the pixel positioning values to nil.
	-- SetPoint: Sets those values up again.
	-- It's bad to have this happening all the time, so it's in its own function.
	-- Which is called not so often.

	if (MoveIt[SMHO_Dude].BuffsX ~= nil and MoveIt[SMHO_Dude].BuffsY ~= nil) then
		BuffFrame:ClearAllPoints();
		BuffFrame:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", MoveIt[SMHO_Dude].BuffsY, MoveIt[SMHO_Dude].BuffsX);
	end

	if (MoveIt[SMHO_Dude].CastingX ~= nil and MoveIt[SMHO_Dude].CastingY ~= nil) then
		CastingBarFrame:ClearAllPoints();
		CastingBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", MoveIt[SMHO_Dude].CastingY, MoveIt[SMHO_Dude].CastingX -9);
		CastingBarFlash:ClearAllPoints();
		CastingBarFlash:SetPoint("BOTTOM", "UIParent", "BOTTOM", MoveIt[SMHO_Dude].CastingY, MoveIt[SMHO_Dude].CastingX -22);
		CastingBarFrameStatusBar:ClearAllPoints();
		CastingBarFrameStatusBar:SetPoint("BOTTOM", "UIParent", "BOTTOM", MoveIt[SMHO_Dude].CastingY, MoveIt[SMHO_Dude].CastingX +3);
		CastingBarText:ClearAllPoints();
		CastingBarText:SetPoint("BOTTOM", "UIParent", "BOTTOM", MoveIt[SMHO_Dude].CastingY, MoveIt[SMHO_Dude].CastingX +7);
	end

	if (MoveIt[SMHO_Dude].MainMenuX ~= nil and MoveIt[SMHO_Dude].MainMenuY ~= nil) then
		MainMenuBar:ClearAllPoints();
		MainMenuBar:SetPoint("BOTTOM", "UIParent", "BOTTOM", MoveIt[SMHO_Dude].MainMenuY, MoveIt[SMHO_Dude].MainMenuX);
	end

	if (MoveIt[SMHO_Dude].MinimapX ~= nil and MoveIt[SMHO_Dude].MinimapY ~= nil) then
		MinimapCluster:ClearAllPoints();
		MinimapCluster:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", MoveIt[SMHO_Dude].MinimapY, MoveIt[SMHO_Dude].MinimapX);
	end

	if (MoveIt[SMHO_Dude].MobX ~= nil and MoveIt[SMHO_Dude].MobY ~= nil) then
		MobHealthFrame:ClearAllPoints();
		MobHealthFrame:SetPoint("TOP", "UIParent", "TOP", MoveIt[SMHO_Dude].MobY, MoveIt[SMHO_Dude].MobX);
	end

	if (MoveIt[SMHO_Dude].Party1X ~= nil and MoveIt[SMHO_Dude].Party1Y ~= nil) then
		PartyMemberFrame1:ClearAllPoints();
		PartyMemberFrame1:SetPoint("LEFT", "UIParent", "LEFT", MoveIt[SMHO_Dude].Party1Y, MoveIt[SMHO_Dude].Party1X);
	end

	if (MoveIt[SMHO_Dude].Party2X ~= nil and MoveIt[SMHO_Dude].Party2Y ~= nil) then
		PartyMemberFrame2:ClearAllPoints();
		PartyMemberFrame2:SetPoint("LEFT", "UIParent", "LEFT", MoveIt[SMHO_Dude].Party2Y, MoveIt[SMHO_Dude].Party2X);
	end

	if (MoveIt[SMHO_Dude].Party3X ~= nil and MoveIt[SMHO_Dude].Party3Y ~= nil) then
		PartyMemberFrame3:ClearAllPoints();
		PartyMemberFrame3:SetPoint("LEFT", "UIParent", "LEFT", MoveIt[SMHO_Dude].Party3Y, MoveIt[SMHO_Dude].Party3X);
	end

	if (MoveIt[SMHO_Dude].Party4X ~= nil and MoveIt[SMHO_Dude].Party4Y ~= nil) then
		PartyMemberFrame4:ClearAllPoints();
		PartyMemberFrame4:SetPoint("LEFT", "UIParent", "LEFT", MoveIt[SMHO_Dude].Party4Y, MoveIt[SMHO_Dude].Party4X);
	end

	if (MoveIt[SMHO_Dude].PetX ~= nil and MoveIt[SMHO_Dude].PetY ~= nil) then
		PetFrame:ClearAllPoints();
		PetFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", MoveIt[SMHO_Dude].PetY, MoveIt[SMHO_Dude].PetX);
	end

	if (MoveIt[SMHO_Dude].PetBarX ~= nil and MoveIt[SMHO_Dude].PetBarY ~= nil) then
		PetActionBarFrame:ClearAllPoints();
		PetActionBarFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", MoveIt[SMHO_Dude].PetBarY, MoveIt[SMHO_Dude].PetBarX);
	end

	if (MoveIt[SMHO_Dude].PlayerX ~= nil and MoveIt[SMHO_Dude].PlayerY ~= nil) then
		PlayerFrame:ClearAllPoints();
		PlayerFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", MoveIt[SMHO_Dude].PlayerY, MoveIt[SMHO_Dude].PlayerX);
	end

	if (MoveIt[SMHO_Dude].ShapeshiftX ~= nil and MoveIt[SMHO_Dude].ShapeshiftY ~= nil) then
		ShapeshiftBarFrame:ClearAllPoints();
		ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", MoveIt[SMHO_Dude].ShapeshiftY, MoveIt[SMHO_Dude].ShapeshiftX);
	end

	if (MoveIt[SMHO_Dude].TargetX ~= nil and MoveIt[SMHO_Dude].TargetY ~= nil) then
		TargetFrame:ClearAllPoints();
		TargetFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", MoveIt[SMHO_Dude].TargetY, MoveIt[SMHO_Dude].TargetX);
	end

	--[[ Added by Mook Begin ]]
	if (MoveIt[SMHO_Dude].BankItemsX ~= nil and MoveIt[SMHO_Dude].BankItemsY ~= nil) then
		BankItems_Frame:ClearAllPoints();
		BankItems_Frame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", MoveIt[SMHO_Dude].BankItemsY, MoveIt[SMHO_Dude].BankItemsX);
	end
	--[[ Added by Mook End ]]

	if (MoveIt[SMHO_Dude].CharacterX ~= nil and MoveIt[SMHO_Dude].CharacterY ~= nil) then
		CharacterFrame:ClearAllPoints();
		CharacterFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", MoveIt[SMHO_Dude].CharacterY, MoveIt[SMHO_Dude].CharacterX);
	end

	if (MoveIt[SMHO_Dude].FriendsX ~= nil and MoveIt[SMHO_Dude].FriendsY ~= nil) then
		FriendsFrame:ClearAllPoints();
		FriendsFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", MoveIt[SMHO_Dude].FriendsY, MoveIt[SMHO_Dude].FriendsX);
	end

	if (MoveIt[SMHO_Dude].FPSX ~= nil and MoveIt[SMHO_Dude].FPSY ~= nil) then
		FramerateLabel:ClearAllPoints();
		FramerateLabel:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", MoveIt[SMHO_Dude].FPSY, MoveIt[SMHO_Dude].FPSX);
	end

	--[[ Added by Mook Begin ]]
	if (MoveIt[SMHO_Dude].LootLinkX ~= nil and MoveIt[SMHO_Dude].LootLinkY ~= nil) then
		LootLinkFrame:ClearAllPoints();
		LootLinkFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", MoveIt[SMHO_Dude].LootLinkY, MoveIt[SMHO_Dude].LootLinkX);
	end
	--[[ Added by Mook End ]]

	if (MoveIt[SMHO_Dude].QuestX ~= nil and MoveIt[SMHO_Dude].QuestY ~= nil) then
		QuestLogFrame:ClearAllPoints();
		QuestLogFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", MoveIt[SMHO_Dude].QuestY, MoveIt[SMHO_Dude].QuestX);
	end

	if (MoveIt[SMHO_Dude].SpellX ~= nil and MoveIt[SMHO_Dude].SpellY ~= nil) then
		SpellBookFrame:ClearAllPoints();
		SpellBookFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", MoveIt[SMHO_Dude].SpellY, MoveIt[SMHO_Dude].SpellX);
	end

	if (MoveIt[SMHO_Dude].TalentX ~= nil and MoveIt[SMHO_Dude].TalentY ~= nil) then
		TalentFrame:ClearAllPoints();
		TalentFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", MoveIt[SMHO_Dude].TalentY, MoveIt[SMHO_Dude].TalentX);
	end

	if (HideIt[SMHO_Dude].MainMenuBar == 1) then
		MainMenuBar:Hide();
		if (HideIt[SMHO_Dude].PetBar ~= 1) then
			PetActionBarFrame:Show();
		end
	else
		MainMenuBar:Show();
	end

	-- A frame followed by hide(); will always do that.
	-- A frame followed by show(); will do just that too.

	if (HideIt[SMHO_Dude].Party == nil) then
		-- Do nothing.
	elseif (HideIt[SMHO_Dude].Party == 1) then
		HidePartyFrame();
	else
		ShowPartyFrame();
	end

	if (HideIt[SMHO_Dude].Pet == nil) then
		-- Do nothing.
	elseif (HideIt[SMHO_Dude].Pet == 1) then
		PetFrame:Hide();
	else
		PetFrame:Show();
	end

	if (HideIt[SMHO_Dude].PetBar == nil) then
		-- Do nothing.
	elseif (HideIt[SMHO_Dude].PetBar == 1 or not UnitExists("pet")) then
		PetActionBarFrame:Hide();
	elseif (HideIt[SMHO_Dude].PetBar ~= 1 or UnitExists("pet")) then
		PetActionBarFrame:Show();
	end

	if (HideIt[SMHO_Dude].Player == nil) then
		-- Do nothing.
	elseif (HideIt[SMHO_Dude].Player == 1) then
		PlayerFrame:Hide();
	else
		PlayerFrame:Show();
	end

	if (HideIt[SMHO_Dude].Shapeshift == nil) then
		-- Do nothing.
	elseif (HideIt[SMHO_Dude].Shapeshift == 1) then
		ShapeshiftBarFrame:Hide();
	else
		ShapeshiftBarFrame:Show();
	end

	if (HideIt[SMHO_Dude].Target == nil) then
		-- Do nothing.
	elseif (HideIt[SMHO_Dude].Target == 1) then
		TargetFrame:Hide();
	else
		TargetFrame:Show();
	end

	if (HideIt[SMHO_Dude].BQueue == nil) then
		-- Do nothing.
	elseif (HideIt[SMHO_Dude].BQueue == 1) then
		Blessing_Queue:Hide();
	else
		Blessing_Queue:Show();
	end

	if (HideIt[SMHO_Dude].GLock == nil) then
		-- Do nothing.
	elseif (HideIt[SMHO_Dude].GLock == 1) then
		Gypsy_LockButton:Hide();
	else
		Gypsy_LockButton:Show();
	end

	if (HideIt[SMHO_Dude].CPToggle == nil) then
		-- Do nothing.
	elseif (HideIt[SMHO_Dude].GLock == 1) then
		if (UnitClass('player') == "Rogue" or UnitClass('player') == "Warrior") then
			CastPartyMainFrame:Hide();
			if (PS_XPBar:IsVisible()) then
				PS_XPBar:Hide();
				PlayerStatusFrame:Hide();
			end
		else
			HidePartyFrame();
			PlayerFrame:Hide();
		end
	end
end

-- *******************************************************

function SlashCmdGetInform(type, type3, cmd, value)
	-- Prints the specified message to the chat window.
	-- With the inclusion of the two variables above.
	
	-- First check if value is nil.
	if (value == nil) then
		DEFAULT_CHAT_FRAME:AddMessage(type .. ": " .. cmd .. " is not set to be " .. type3 .. ".");
	else
		DEFAULT_CHAT_FRAME:AddMessage(type .. ": " .. cmd .. " is set to be " .. type3 .. " to '" .. value .. "'.");
	end
end

-- *******************************************************

function SlashCmdSetInform(type, type2, cmd, value)
	-- Prints the specified message to the chat window.
	-- With the inclusion of the two variables above.
	DEFAULT_CHAT_FRAME:AddMessage(type .. ": " .. cmd .. " " .. type2 .. " to '" .. value .. "'.");
end

-- *******************************************************

function ChatMessage(message)
	-- Prints the specified message to the chat window.
	DEFAULT_CHAT_FRAME:AddMessage(message);
end

-- *******************************************************

--[[ End of File ]]