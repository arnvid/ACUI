--
-- In this file the filter for fixed strings (strings that never change) are setup.
-- They have to match exactly the game message. If a exact match occurs, the message is filtered out.
--
-- Best is to use only names (which refers fixed strings) from GlobalStrings.lua,
-- so that localization is done automatically.
--
-- See file FilterPartialString.lua for more flexible match system.
--

--
-- The length of these filterlists IS NOT relevant for performance. Lookup is done fast.
--

--
-- Filter for event UI_ERROR_MESSAGE (The red center messages)
--
ErrorRedirect_Filter_FixedErrorMessages = {
  REDIRECT_TO_FRAME = ChatFrame2, -- if option "Enable, redirect to combat log" is selected

  -- Add here your filter strings which are displayed by other addons
  -- Every line has to be terminated by a comma
  -- eg:
  -- ["Flexbar settings loading"] = true,

  -- Add here your filter strings for ERROR Message (these are the red ones)
  -- Every line has to be terminated by a comma
  -- schema: [<Name from Globalstrings.lua>] = true,
  [ERR_ABILITY_COOLDOWN] = true,         -- "Ability is not ready yet."
  [ERR_ATTACK_CHARMED] = true,           -- "Can't attack while charmed."
  [ERR_ATTACK_DEAD] = true,              -- "Can't attack while dead."
  [ERR_ATTACK_FLEEING] = true,           -- "Can't attack while fleeing."
  [ERR_ATTACK_PACIFIED] = true,          -- "Can't attack while pacified."
  [ERR_ATTACK_STUNNED] = true,           -- "Can't attack while stunned."
  [ERR_AUTOFOLLOW_TOO_FAR] = true,       -- "Target is too far away."
  [ERR_BADATTACKFACING] = true,          -- "You are facing the wrong way!"; -- Melee combat error
  [ERR_BADATTACKPOS] = true,             -- "You are too far away!"; -- Melee combat error
  [ERR_CANTATTACK_NOTSTANDING]= true,    -- "You have to be standing to attack anything!"
  [ERR_GENERIC_NO_TARGET] = true,        -- "You have no target."
  [ERR_INV_FULL] = true,                 -- "Inventory is full."
  [ERR_LOOT_BAD_FACING] = true,          -- "You must be facing the corpse to loot it."
  [ERR_LOOT_DIDNT_KILL] = true,          -- "You don't have permission to loot that corpse."
  [ERR_LOOT_GONE] = true,                -- "Already looted"
  [ERR_LOOT_LOCKED] = true,              -- "Someone is already looting that corpse."
  [ERR_LOOT_NOTSTANDING] = true,         -- "You need to be standing up to loot something!"
  [ERR_LOOT_NO_UI] = true,               -- "You can't loot right now."
  [ERR_LOOT_STUNNED] = true,             -- "You can't loot anything while stunned!"
  [ERR_LOOT_TOO_FAR] = true,             -- "You are too far away to loot that corpse."
  [ERR_LOOT_WHILE_INVULNERABLE] = true,  -- "Cannot loot while invulnerable."
  [ERR_NO_ATTACK_TARGET] = true,         -- "There is nothing to attack."
  [ERR_NOT_ENOUGH_MONEY] = true,         -- "You don't have enough money."
  [ERR_OUT_OF_ENERGY] = true,            -- "Not enough energy."
  [ERR_OUT_OF_FOCUS] = true,             -- "Not enough focus."
  [ERR_OUT_OF_HEALTH] = true,            -- "Not enough health."
  [ERR_OUT_OF_MANA] = true,              -- "Not enough mana."
  [ERR_OUT_OF_RAGE] = true,              -- "Not enough rage."
  [ERR_OUT_OF_RANGE] = true,             -- "Out of range."
  [ERR_SPELL_COOLDOWN] = true,           -- "Spell is not ready yet."
  [SPELL_FAILED_BAD_TARGETS] = true,     -- "Bad target."
  [SPELL_FAILED_SPELL_IN_PROGRESS] = true, -- "Another action is in progress"
  [SPELL_FAILED_NO_COMBO_POINTS] = true, -- "That ability requires combo points"
  [SPELL_FAILED_ONLY_STEALTHED] = true,  -- "You must be in stealth mode"
  [SPELL_FAILED_OUT_OF_RANGE] = true,    -- "Out of range"
  [SPELL_FAILED_TARGETS_DEAD] = true,    -- "Your target is dead"
  [SPELL_FAILED_TOO_CLOSE] = true,       -- "Target to close."
  [SPELL_FAILED_UNIT_NOT_INFRONT] = true,-- "Target needs to be in front of you"
  [SPELL_FAILED_STUNNED] = true,         -- "Can't do that while stunned"

  -- Add here your filter strings for INFO Messages (these are the yellow ones)
  -- Every line has to be terminated by a comma
  -- schema: [<Name from Globalstrings.lua>] = true,
  [ERR_EXHAUSTION_WELLRESTED] = true, -- "You feel well reseted."
  [ERR_FISH_ESCAPED] = true,          -- "Your fish got away!"
  [ERR_FISH_NOT_HOOKED] = true,       -- "No fish are hooked."

}

