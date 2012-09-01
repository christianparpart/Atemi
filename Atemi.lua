-- Atemi
-- Copyright (c) 2011 by Christian Parpart <trapni@gentoo.org>
--
-- This addon is inspired and based on Icicle, which I was to improve
-- UI-based configurability and a higher focus on Arena cooldowns.

Atemi = LibStub("AceAddon-3.0"):NewAddon("Atemi", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("Atemi", true)

--[[if not L then
	L = {}
	setmetatable(L, { __index = function(t, k)
		return k
	end})
end]]

-- {{{ some helpers
local function SetContains(set, value)
	for i = 1, #set do
		if set[i] == value then
			return true
		end
	end
	return false
end

local function SetEnable(set, value, enable)
	for i = 1, #set do
		if set[i] == value then
			tremove(set, i)
			break
		end
	end

	if enable then
		tinsert(set, value)
	end
end

-- @fn getSpellDescription(spellID)
-- @desc retrieves the description of a spell by given ID
--
-- @copyright BigWigs AddOn developer
--
local getSpellDescription
do
	local cache = {}
	local scanner = CreateFrame("GameTooltip")
	scanner:SetOwner(WorldFrame, "ANCHOR_NONE")
	local lcache, rcache = {}, {}
	for i = 1, 4 do
		lcache[i], rcache[i] = scanner:CreateFontString(), scanner:CreateFontString()
		lcache[i]:SetFontObject(GameFontNormal); rcache[i]:SetFontObject(GameFontNormal)
		scanner:AddFontStrings(lcache[i], rcache[i])
	end
	function getSpellDescription(spellId)
		if cache[spellId] then return cache[spellId] end
		scanner:ClearLines()
		scanner:SetHyperlink("spell:"..spellId)
		for i = scanner:NumLines(), 1, -1  do
			local desc = lcache[i] and lcache[i]:GetText()
			if desc then
				cache[spellId] = desc
				return desc
			end
		end
	end
end
-- }}}

Atemi.SPELL_COOLDOWN_MAP = { -- {{{
	--------------------------------------------------------------------------
	--Misc
	[28730] = 120,				--"Arcane Torrent",
	[50613] = 120,				--"Arcane Torrent",
	[80483] = 120,				--"Arcane Torrent",
	[25046] = 120,				--"Arcane Torrent",
	[69179] = 120,				--"Arcane Torrent",
	[20572] = 120,				--"Blood Fury",
	[33702] = 120,				--"Blood Fury",
	[33697] = 120,				--"Blood Fury",
	[59543] = 180,				--"Gift of the Naaru",
	[69070] = 120,				--"Rocket Jump",
	[26297] = 180,				--"Berserking",
	[20594] = 120,				--"Stoneform",
	[58984] = 120,				--"Shadowmeld",
	[20589] = 90,				--"Escape Artist",
	[59752] = 120,				--"Every Man for Himself",
	[7744] = 120,				--"Will of the Forsaken",
	[68992] = 120,				--"Darkflight",
	[50613] = 120,				--"Arcane Torrent",
	[11876] = 120,				--"War Stomp",
	[69041] = 120,				--"Rocket Barrage",
	[42292] = 120,				--"PvP Trinket",
	[69070] = 120,				-- Goblin: Rocket Jump

	--------------------------------------------------------------------------
	--Pets(Death Knight)
	[91797] = 60,				--"Monstrous Blow",
	[91837] = 45,				--"Putrid Bulwark",
	[91802] = 30,				--"Shambling Rush",
	[47482] = 30,				--"Leap",
	[91809] = 30,				--"Leap",
	[91800] = 60,				--"Gnaw",
	[47481] = 60,				--"Gnaw",

	--------------------------------------------------------------------------
	--Pets(Hunter)
	[90339] = 60,				--"Harden Carapace",
	[61685] = 25,				--"Charge",
	[50519] = 60,				--"Sonic Blast",
	[35290] = 10,				--"Gore",
	[50245] = 40,				--"Pin",
	[50433] = 10,				--"Ankle Crack",
	[26090] = 30,				--"Pummel",
	[93434] = 90,				--"Horn Toss",
	[57386] = 15,				--"Stampede",
	[50541] = 60, 				--"Clench",
	[26064] = 60, 				--"Shell Shield",
	[35346] = 15, 				--"Time Warp",
	[93433] = 30,				--"Burrow Attack",
	[91644] = 60,				--"Snatch",
	[54644] = 10,				--"Frost Breath",
	[34889] = 30,				--"Fire Breath",
	[50479] = 40,				--"Nether Shock",
	[50518] = 15,				--"Ravage",
	[35387] = 6, 				--"Corrosive Spit",
	[54706] = 40,				--"Vemom Web Spray",
	[4167] = 40,				--"Web",
	[50274] = 12,				--"Spore Cloud",
	[24844] = 30, 				--"Lightning Breath",
	[90355] = 360,				--"Ancient Hysteria",
	[54680] = 8,				--"Monstrous Bite",
	[90314] = 25,				--"Tailspin",
	[50271] = 10, 				--"Tendon Rip",
	[50318] = 60,				--"Serenity Dust",
	[50498] = 6, 				--"Tear Armor",
	[90361] = 40,				--"Spirit Mend",
	[50285] = 40, 				--"Dust Cloud",
	[56626] = 45,				--"Sting",
	[24604] = 45,				--"Furious Howl",
	[90309] = 45,				--"Terrifying Roar",
	[24423] = 10,				--"Demoralizing Screech",
	[93435] = 45,				--"Roar of Courage",
	[58604] = 8,				--"Lava Breath",
	[90327] = 40,				--"Lock Jaw",
	[90337] = 60,				--"Bad Manner",
	[53490] = 180,				--"Bullheaded",
	[23145] = 32,				--"Dive",
	[55709] = 480,				--"Heart of the Phoenix",
	[53426] = 180,				--"Lick Your Wounds",
	[53401] = 45, 				--"Rabid",
	[53476] = 30,				--"Intervene",
	[53480] = 60,				--"Roar of Sacrifice",
	[53478] = 360,				--"Last Stand",
	[53517] = 180,				--"Roar of Recovery",

	--------------------------------------------------------------------------
	--Pets(Warlock)
	[19647] = 24,				--"Spell Lock",
	[7812] = 60,				--"Sacrifice",
	[89766] = 30,				--"Axe Toss"
	[89751] = 45,				--"Felstorm",

	--------------------------------------------------------------------------
	--Pets(Mage)
	[33395] = 25,				--"Freeze", --No way to tell which WE cast this still usefull to some degree.

	--------------------------------------------------------------------------
	--Death Knight
	-- abilities
	[49576] = 25,				--"Death Grip",	
	[46584] = 120,				--"Raise Dead",
	[47528] = 15,				--"Mind Freeze",
	[47476] = 120,				--"Strangulate",
	[43265] = 30,				--"Death and Decay",
	[48792] = 180,				--"Icebound Fortitude",
	[48707] = 45,				--"Anti-Magic Shell",
	[47568] = 300,				--"Empower Rune Weapon",
	[77606] = 60,				--"Dark Simulakrum",

	-- talents
	[51052] = 120,				--"Anti-Magic Zone",
	[49039] = 120,				--"Lichborne",
	[114556] = 180,				--"Purgatory",
	[108194] = 60,				--"Asphyxiate",
	[96268] = 30,				--"Death's Advance",
	[48743] = 120,				--"Death Packt",
	[108201] = 120,				--"Desecrated Ground",
	[108199] = 60,				--"Gorefiend's Grasp",
	[108200] = 60,				--"Remorseless Winter",

	-- specialization
	[49222] = 60,				--"Bone Shield",
	[49028] = 90,				--"Dancing Rune Weapon",
	[51271] = 60,				--"Pillar of Frost",
	[49206] = 180,				--"Summon Gargoyle",
	[49016] = 180,				--"Unholy Frenzy",
	[55233] = 60,				--"Vampiric Blood",

	--------------------------------------------------------------------------
	--Druid
	-- abilities
	[102543] = 180,				-- Incarnation: King of the Jungle
	[102558] = 180,				-- Incarnation: Son of Ursoc
	[339] = 30,					-- Entangling Roots
	[102560] = 180,				-- Incarnation: Chosen of Elune
	[1850] = 180,				-- Dash
	[22812] = 60,				-- Barkskin
	[16689] = 60,				-- Nature's Grasp
	[29116] = 180,				-- Innervate
	[22842] = 90,				-- Frenzied Regeneration
	[106922] = 180,				-- Might of Ursoc
	[740] = 480,				-- Tranquility
	[77761] = 120,				-- Stampeding Roar

	-- talents
	[102280] = 30,				-- Displacer Beast
	[102401] = 15,				-- Wild Charge
	[102351] = 30,				-- Cenarion Ward
	[132158] = 60,				-- Nature's Swiftness
	[108238] = 120,				-- Renewal
	[102359] = 120,				-- Mass Entanglement
	[132469] = 20,				-- Typhoon
	[106737] = 60,				-- Force of Nature
	[106731] = 180,				-- Incarnation
	[99] = 30,					-- Disorienting Roar
	[5211] = 50,				-- Mighty Bash
	[102793] = 60,				-- Ursol's Vortex
	[108288] = 360,				-- Heart of the Wild
	[124974] = 300,				-- Nature's Vigil

	-- specialization
	[102795] = 60,				-- Bear Hug
	[106952] = 180,				-- Berserk
	[112071] = 180,				-- Celestial Alignment
	[102342] = 120,				-- Ironbark
	[88432] = 8,				-- Nature's Cure
	[2782] = 8,					-- Remove Corruption
	[106839] = 15,				-- Skull Bash
	[78675] = 60,				-- Solar Beam
	[48505] = 90,				-- Starfall
	[78674] = 15,				-- Starsurge
	[61336] = 180,				-- Survival Instincts

	--------------------------------------------------------------------------
	--Hunter
	-- abilities
	[781] = 25,					-- Disengage
	[19503] = 30,				-- Scatter Shot
	[1499] = 30,				-- Freezing Trap
	[5384] = 30,				-- Feign Death
	[1543] = 20,				-- Flare
	[13809] = 30,				-- Ice Trap
	[3045] = 180,				-- Rapid Fire
	[23989] = 300,				-- Readiness
	[34600] = 30,				-- Snake Trap
	[53271] = 45,				-- Master's Call
	[19263] = 120,				-- Deterrence
	[51753] = 60,				-- Camouflage
	[121818] = 300,				-- Stampede

	-- talents
	[109248] = 45,				-- Binding Shot
	[34490] = 20,				-- Silencing Shot
	[19386] = 60,				-- Wyvern Sting
	[109304] = 120,				-- Exhilaration
	[120679] = 30,				-- Dire Beast
	[131894] = 120,				-- A Murder of Crows
	[130392] = 20,				-- Blink Strike
	[120679] = 90,				-- Lynx Rush
	[120360] = 30,				-- Barrage
	[109259] = 60,				-- Powershot

	-- specialization
	[19574] = 60,				-- Bestial Wrath
	[19577] = 60,				-- Intimidation

	--------------------------------------------------------------------------
	--Mage
	-- abilities
	[1953] = 15,				-- Blink
	[122] = 25,					-- Frost Nova
	[2139] = 24,				-- Counterspell
	[45438] = 300,				-- Ice Block
	[475] = 8,					-- Remove Curse
	[12051] = 120,				-- Evocation
	[55342] = 180,				-- Mirror Image
	[66] = 300,					-- Invisibility
	[44572] = 30,				-- Deep Freeze
	[120] = 8,                  -- Cone of Cold

	-- talents
	[108839] = 60,				-- Ice Floes
	[12043] = 90,				-- Presence of Mind
	[108843] = 25,				-- Blazing Speed
	[11426] = 25,				-- Ice Barrier
	[115610] = 25,				-- Temporal Shield
	[102051] = 20,				-- Frostjaw
	[113724] = 30,				-- Ring of Frost
	[86949] = 120,				-- Cautarize
	[11958] = 180,				-- Cold Snap
	[110959] = 150,				-- Greater Invisibility
	[112948] = 10,				-- Frost Bomb
	[116011] = 6,				-- Rune of Power

	-- specialization
	[12042] = 90,				-- Arcane Power
	[11129] = 45,				-- Combustion
	[84714] = 60,				-- Frozen Orb
	[12472] = 180,				-- Icy Veins
	[31687] = 60,				-- Summon Water Elemental
	[31661] = 20,				-- Dragon's Breath

	--------------------------------------------------------------------------
	--Paladin
	-- abilities
	[853] = 60,					-- Hammer of Justice
	[642] = 300,				-- Divine Shield
	[4987] = 8,					-- Cleanse
	[498] = 60,					-- Divine Protection
	[96231] = 15,				-- Rebuke
	[1022] = 300,				-- Hand of Protection
	[1044] = 25,				-- Hand of Freedom
	[31821] = 180,				-- Devotion Aura
	[31884] = 180,				-- Avenging Wrath
	[6940] = 120,				-- Hand of Sacrifice
	[115750] = 120,				-- Blinding Light

	-- talents
	[85499] = 45,				-- Speed of Light
	[105593] = 30,				-- First of Justice
	[20066] = 15,				-- Repentance
	[114039] = 30,				-- Hand of Purity
	[105809] = 120,				-- Holy Avenger

	-- specialization
	[31850] = 180, 				-- Ardent Defender
	[31935] = 15,				-- Avenger's Shield
	[54428] = 120,				-- Devine Plea

	--------------------------------------------------------------------------
	--Priest
	-- abilities
	[8122] = 30,				-- Psychic Scream
	[528] = 8,					-- Dispel Magic
	[586] = 30,					-- Fade
	[34433] = 180,				-- Shadowfiend
	[6346] = 180,				-- Fear Ward
	[64901] = 360,				-- Hymn of Hope
	[32375] = 15,				-- Mass Dispell
	[73325] = 90,				-- Leap of Faith
	[108968] = 360,				-- Void Shift

	-- talents
	[605] = 30,					-- Dominate Mind
	[108921] = 45,				-- Psyfiend
	[108920] = 30,				-- Void Tendrils
	[123040] = 60,				-- Mindbender
	[19236] = 120,				-- Desperate Prayer
	[112883] = 30,				-- Spectral Guise
	[10060] = 120,				-- Power Infusion

	-- specialization
	[47585] = 120,				-- Dispersion
	[64843] = 180,				-- Devine Hymn
	[47788] = 180,				-- Guardian Spirit
	[88625] = 30,				-- Holy Word: Chastise
	[89485] = 45,				-- Inner Focus
	[724] = 180,				-- Light Well
	[33206] = 180,				-- Pain Suppression
	[62618] = 180,				-- Power Word: Barrier
	[64044] = 45,				-- Psychic Horror
	[527] = 8,					-- Purify
	[15487] = 45,				-- Silence
	[109964] = 60,				-- Spirit Shell

	--------------------------------------------------------------------------
	--Rogue
	-- abilities
	[2094] = 180,				--"Blind",
	[1766] = 15,				--"Kick",
	[1776] = 10,				--"Gauge",
	[2983] = 60,				--"Sprint",
	[31224] = 120,				--"Cloak of Shadows",
	[5938] = 10,				--"Shiv",
	[1856] = 180,				--"Vanish",
	[5277] = 180,				--"Evasion",
	[408] = 20,					--"Kidney Shot",
	[51722] = 60,				--"Dismantle",
	[114842] = 60,				--"Shadow Walk",
	[114018] = 300,				--"Shroud of Concealment",
	[73981] = 60,				--"Redirect" (talented: w/o cooldown)
	[76577] = 180,				--"Smoke Bomb",
	[121471] = 180,				--"Shadow Blades",

	-- talents
	[14185] = 300,				--"Preparation", (sprint, vanish, cloak, evasion, dismantle)
	[36554] = 24,				--"Shadowstep",
	[74001] = 120,				--"Combat Readiness",
	[31230] = 90,				--"Cheat Death",

	-- specialization
	[79140] = 120,				--"Vendetta",
	[51690] = 120,				--"Killing Spree",
	[51713] = 60, 				--"Shadow Dance",
	[13750] = 180,				--"Adrenaline Rush",
	[14183] = 20,				--"Premeditation",

	--------------------------------------------------------------------------
	--Shaman
	-- abilities
	[57994] = 12,				-- Wind Shear
	[51886] = 8,				-- Cleanse Spirit
	[8056] = 6,					-- Frost Shock
	[8711] = 25,				-- Grounding Totem
	[8143] = 60,				-- Tremor Totem
	[51514] = 45,				-- Hex
	[79206] = 120,				-- Spiritwalker's Grace
	[114049] = 180,				-- Ascendance

	-- talents
	[108271] = 120,				-- Astral Shift
	[51485] = 30,				-- Earthgrab Totem
	[108273] = 60,				-- Windwalk Totem
	[108285] = 180,				-- Call of the Elements
	[16188] = 60,				-- Ancestral Swiftness
	[16166] = 120,				-- Elemental Mastery
	[108281] = 120,				-- Ancestral Guidance

	-- specialization
	[16190] = 180,				-- Mana Tide Totem
	[77130] = 8,				-- Purify Spirit
	[30823] = 60,				-- Shamanistic Rage
	[98008] = 180,				-- Spirit Link Totem
	[58875] = 120,				-- Spirit Walk
	[51490] = 45,				-- Thunderstorm

	--------------------------------------------------------------------------
	--Warlock
	[74434] = 45,				--"Soulburn",
	[30283] = 20,				--"Shadowfury",
	[6789] = 90,				--"Death Coil",
	[17962] = 8,				--"Conflagrate",
	[74434] = 45,				--"Soulburn",
	[6229] = 30,				--"Shadow Ward",
	[5484] = 32,				--"Howl of Terror",
	[54785] = 45,				--"Demon Leap",
	[48020] = 26,				--"Demonic Circle: Teleport",
	[17877] = 15,				--"Shadowburn",
	[71521] = 12,				--"Hand of Gul'dan",
	[91711] = 30,				--"Nether Ward",

	--------------------------------------------------------------------------
	--Warrior
	[12292] = 144, 				--"Death Wish",
	[86346] = 20,				--"Colossus Smash",
	[85730] = 120,				--"Deadly Calm",
	[85388] = 45,				--"Throwdown",
	[100] = 13,					--"Charge",
	[6552] = 10,				--"Pummel",
	[23920] = 20,				--"Spell Reflection",
	[2565] = 30,				--"Shield Block",
	[676] = 60,					--"Disarm",
	[5246] = 120,				--"Intimidation Shout",
	[871] = 120,				--"Shield Wall",	
	[20252] = 20,				--"Intercept",
	[20230] = 300,				--"Retaliation",
	[1719] = 240,				--"Recklessness",
	[3411] = 30,				--"Intervene",
	[64382] = 90,				--"Shattering Throw",
	[6544] = 40,				--"Heroic Leap",
	[12809] = 30,				--"Concussion Blow",
	[12975] = 180,				--"Last Stand",
	[12328] = 60,				--"Sweeping Strikes",
	[85730] = 120,				--"Deadly Calm",
	[60970] = 30,				--"Heroic Fury",
	[46924] = 75,				--"Bladestorm",
	[46968] = 17,				--"Shockwave",
} -- }}}

Atemi.CLASS_COOLDOWN_MAP = { -- {{{
	["Rogue"] = {
		-- abilities
		408, -- Kidney Shot
		1766, -- Kick
		1776, -- Gauge
		1856, -- Vanish
		2094, -- Blind
		2983, -- Sprint
		5277, -- Evasion
		5938, -- Shiv
		31224, -- Cloak of Shadows
		51722, -- Dismantle
		73981, -- Redirect (talented: w/o cooldown)
		76577, -- Smoke Bomb
		114018, -- Shroud of Concealment
		114842, -- Shadow Walk
		121471, -- Shadow Blades

		-- talents
		14185, -- Preparation, (sprint, vanish, cloak, evasion, dismantle)
		31230, -- Cheat Death
		36554, -- Shadowstep
		74001, -- Combat Readiness

		-- specialization
		13750, -- Adrenaline Rush
		14183, -- Premeditation
		51690, -- Killing Spree
		51713, -- Shadow Dance
		79140, -- Vendetta
	},
	["Mage"] = {
		-- Pet: Water Elemental
		33395,  -- Freeze

		-- abilities
		1953, -- Blink
		122, -- Frost Nova
		2139, -- Counterspell
		45438, -- Ice Block
		475, -- Remove Curse
		12051, -- Evocation
		55342, -- Mirror Image
		66, -- Invisibility
		44572, -- Deep Freeze
		120, -- Cone of Cold

		-- talents
		108839, -- Ice Floes
		12043, -- Presence of Mind
		108843, -- Blazing Speed
		11426, -- Ice Barrier
		115610, -- Temporal Shield
		102051, -- Frostjaw
		113724, -- Ring of Frost
		86949, -- Cautarize
		11958, -- Cold Snap
		110959, -- Greater Invisibility
		112948, -- Frost Bomb
		116011, -- Rune of Power

		-- specialization
		12042, -- Arcane Power
		11129, -- Combustion
		84714, -- Frozen Orb
		12472, -- Icy Veins
		31687, -- Summon Water Elemental
		31661, -- Dragon's Breath
	},
	["Priest"] = {
		-- abilities
		8122, -- Psychic Scream
		528, -- Dispel Magic
		586, -- Fade
		34433, -- Shadowfiend
		6346, -- Fear Ward
		64901, -- Hymn of Hope
		32375, -- Mass Dispell
		73325, -- Leap of Faith
		108968, -- Void Shift

		-- talents
		605, -- Dominate Mind
		108921, -- Psyfiend
		108920, -- Void Tendrils
		123040, -- Mindbender
		19236, -- Desperate Prayer
		112883, -- Spectral Guise
		10060, -- Power Infusion

		-- specialization
		47585, -- Dispersion
		64843, -- Devine Hymn
		47788, -- Guardian Spirit
		88625, -- Holy Word: Chastise
		89485, -- Inner Focus
		724, -- Light Well
		33206, -- Pain Suppression
		62618, -- Power Word: Barrier
		64044, -- Psychic Horror
		527, -- Purify
		15487, -- Silence
		109964, -- Spirit Shell
	},
	["Hunter"] = {
		-- abilities
		781, -- Disengage
		19503, -- Scatter Shot
		1499, -- Freezing Trap
		5384, -- Feign Death
		1543, -- Flare
		13809, -- Ice Trap
		3045, -- Rapid Fire
		23989, -- Readiness
		34600, -- Snake Trap
		53271, -- Master's Call
		19263, -- Deterrence
		51753, -- Camouflage
		121818, -- Stampede

		-- talents
		109248, -- Binding Shot
		34490, -- Silencing Shot
		19386, -- Wyvern Sting
		109304, -- Exhilaration
		120679, -- Dire Beast
		131894, -- A Murder of Crows
		130392, -- Blink Strike
		120679, -- Lynx Rush
		120360, -- Barrage
		109259, -- Powershot

		-- specialization
		19574, -- Bestial Wrath
		19577, -- Intimidation
	},
	["Druid"] = {
		-- abilities
		102543, -- Incarnation: King of the Jungle
		102558, -- Incarnation: Son of Ursoc
		339,    -- Entangling Roots
		102560, -- Incarnation: Chosen of Elune
		1850,   -- Dash
		22812,  -- Barkskin
		16689,  -- Nature's Grasp
		29116,  -- Innervate
		22842,  -- Frenzied Regeneration
		106922, -- Might of Ursoc
		740,    -- Tranquility
		77761,  -- Stampeding Roar

		-- talents
		102280, -- Displacer Beast
		102401, -- Wild Charge
		102351, -- Cenarion Ward
		132158, -- Nature's Swiftness
		108238, -- Renewal
		102359, -- Mass Entanglement
		132469, -- Typhoon
		106737, -- Force of Nature
		106731, -- Incarnation
		99,     -- Disorienting Roar
		5211,   -- Mighty Bash
		102793, -- Ursol's Vortex
		108288, -- Heart of the Wild
		124974, -- Nature's Vigil

		-- specialization
		102795, -- Bear Hug
		106952, -- Berserk
		112071, -- Celestial Alignment
		102342, -- Ironbark
		88432,  -- Nature's Cure
		2782,   -- Remove Corruption
		106839, -- Skull Bash
		78675,  -- Solar Beam
		48505,  -- Starfall
		78674,  -- Starsurge
		61336,  -- Survival Instincts
	},
	["Shaman"] = {
		-- abilities
		57994, -- Wind Shear
		51886, -- Cleanse Spirit
		8056, -- Frost Shock
		8711, -- Grounding Totem
		8143, -- Tremor Totem
		51514, -- Hex
		79206, -- Spiritwalker's Grace
		114049, -- Ascendance

		-- talents
		108271, -- Astral Shift
		51485, -- Earthgrab Totem
		108273, -- Windwalk Totem
		108285, -- Call of the Elements
		16188, -- Ancestral Swiftness
		16166, -- Elemental Mastery
		108281, -- Ancestral Guidance

		-- specialization
		16190, -- Mana Tide Totem
		77130, -- Purify Spirit
		30823, -- Shamanistic Rage
		98008, -- Spirit Link Totem
		58875, -- Spirit Walk
		51490, -- Thunderstorm
	},
	["Warlock"] = {
		6789,   -- Death Coil
		5484,   -- Howl of Terror
		48020,  -- Demonic Circle: Teleport
		-- Warlock Pets
		19647,  -- Spell Lock
		7812,   -- Sacrifice
		89766,  -- Axe Toss
		89751,  -- Felstorm
	},
	["Paladin"] = {
		-- abilities
		853, -- Hammer of Justice
		642, -- Divine Shield
		4987, -- Cleanse
		498, -- Divine Protection
		96231, -- Rebuke
		1022, -- Hand of Protection
		1044, -- Hand of Freedom
		31821, -- Devotion Aura
		31884, -- Avenging Wrath
		6940, -- Hand of Sacrifice
		115750, -- Blinding Light

		-- talents
		85499, -- Speed of Light
		105593, -- First of Justice
		20066, -- Repentance
		114039, -- Hand of Purity
		105809, -- Holy Avenger

		-- specialization
		31850, -- Ardent Defender
		31935, -- Avenger's Shield
		54428, -- Devine Plea
	},
	["Warrior"] = {
		86346,  -- Colossus Smash
		85388,  -- Throwdown
		100,    -- Charge
		6552,   -- Pummel
		23920,  -- Spell Reflection
		676,    -- Disarm
		5246,   -- Intimidation Shout
		871,    -- Shield Wall
		20252,  -- Intercept
		3411,   -- Intervene
		64382,  -- Shattering Blow
		12975,  -- Last Stand
		46924,  -- Blade Storm
	},
	["DeathKnight"] = {
		-- abilities
		49576, -- Death Grip
		46584, -- Raise Dead
		47528, -- Mind Freeze
		47476, -- Strangulate
		43265, -- Death and Decay
		48792, -- Icebound Fortitude
		48707, -- Anti-Magic Shell
		47568, -- Empower Rune Weapon
		77606, -- Dark Simulakrum

		-- talents
		51052, -- Anti-Magic Zone
		49039, -- Lichborne
		114556, -- Purgatory
		108194, -- Asphyxiate
		96268, -- Death's Advance
		48743, -- Death Packt
		108201, -- Desecrated Ground
		108199, -- Gorefiend's Grasp
		108200, -- Remorseless Winter

		-- specialization
		49222, -- Bone Shield
		49028, -- Dancing Rune Weapon
		51271, -- Pillar of Frost
		49206, -- Summon Gargoyle
		49016, -- Unholy Frenzy
		55233, -- Vampiric Blood
	},
	["misc"] = {
		58984,  -- Shadowmeld (Nightelf racial)
		59752,  -- Every Man for Himself (Human racial)
		42292,  -- PvP Trinket
		69070,  -- Goblin: Rocket Jump
	},
} -- }}}

-- {{{ Atemi.COOLDOWN_RESET_MAP
-- Maps cooldown-reset spells to their respective set of spells they reset.
Atemi.COOLDOWN_RESET_MAP = {
	[14185] = { -- Rogue: Preparation
		2983,  -- Sprint
		1856,  -- Vanish
		36554, -- Evasion
		51722, -- Dismantle
	},
	[23989] = { -- Hunter: Readiness
		781,     -- Disengage
		19503,   -- Scatter Shot
		1499,    -- Freezing Trap
		5384,    -- Feign Death
		1543,    -- Flare
		13809,   -- Ice Trap
		3045,    -- Rapid Fire
		34600,   -- Snake Trap
		53271,   -- Master's Call (?)
		19263,   -- Deterrence
		51753,   -- Camouflage
		109248,  -- Binding Shot
		34490,   -- Silencing Shot
		19386,   -- Wyvern String
		109304,  -- Exhilaration
		120679,  -- Dire Beast
		131894,  -- A Murder of Crows
		1330392, -- Blink Strike (?)
		120360,  -- Barrage
		109259,  -- Powershot
		19574,   -- Bestial Wrath
		19577,   -- Intimidation
	},
	[11958] = { -- Mage: Cold Snap
		45438, -- Ice Block
		122,   -- Frost Nova
		120,   -- Cone of Cold
	},
	[108285] = { -- Shaman: Call of the Elements
		8711, -- Grounding Totem
		8143, -- Tremor Totem
		51485, -- Earthgrab Totem
		108273, -- Windwalk Totem
		16190, -- Mana Tide Totem
	}
}
-- }}}

Atemi.defaults = { -- {{{
	profile = {
		showGreeter = true,
		xOffset = 0,
		yOffset = 22,
		gapSize = 2,        -- gap in pixel between the cooldown icons
		iconSize = 22,      -- size in pixel of each cooldown icon
		autoScale = true,   -- auto-scale icon sizes to fit nameplate width as max value
		showTooltips = true,-- show spell tooltips when hovering the icon atop their nameplates
		autoAdjustSizes = false, -- automatically adjust icon/font sizes relative to their nameplate width
		fontSize = ceil(22 * 0.75),
		fontPath = "Interface\\AddOns\\Atemi\\FreeUniversal-Regular.ttf",
		textColor = { red = 0.7, green = 1.0, blue = 0.0 },
		announceUsed = {},  -- list of spells to announce on use
		announceReady = {}, -- list of spells to announce on ready again
		announceReadyTime = 5, -- time in seconds to announce before it becomes ready again
		spells = {
			-- Rogue
			2094,   -- Blind
			1766,   -- Kick
			2983,   -- Sprint
			14185,  -- Preparation
			31224,  -- Cloak of Shadows
			1856,   -- Vanish
			36554,  -- Shadowstep
			5277,   -- Evasion
			408,    -- Kidney Shot
			51722,  -- Dismantle
			76577,  -- Smoke Bomb
			51690,  -- Killing Spree
			51713,  -- Shadow Dance
			-- Mage
			2139,   -- Counterspell
			44572,  -- Deep Freeze
			11958,  -- Cold Snap
			45438,  -- Ice Block
			12042,  -- Arcane Power
			12051,  -- Evocation
			120,    -- Cone of Cold
			122,    -- Frost Nova
			11426,  -- Ice Barrier
			12472,  -- Icy Veins
			82731,  -- Flame Orb
			55342,  -- Mirror Image
			66,     -- Invisibility
			1953,   -- Blink
			82676,  -- Ring of Frost
			12043,  -- Presence of Mind
			31661,  -- Dragon's Breath
			-- Mage Pet: Water Elemental
			33395,  -- Freeze
			-- Priest
			8122, -- Psychic Scream
			34433, -- Shadowfiend
			6346, -- Fear Ward
			64901, -- Hymn of Hope
			73325, -- Leap of Faith
			108968, -- Void Shift
			605, -- Dominate Mind
			108921, -- Psyfiend
			108920, -- Void Tendrils
			123040, -- Mindbender
			19236, -- Desperate Prayer
			112883, -- Spectral Guise
			47585, -- Dispersion
			64843, -- Devine Hymn
			47788, -- Guardian Spirit
			88625, -- Holy Word: Chastise
			89485, -- Inner Focus
			33206, -- Pain Suppression
			62618, -- Power Word: Barrier
			64044, -- Psychic Horror
			15487, -- Silence
			-- Hunter
			82726,  -- Fervor
			3045,   -- Rapid Fire
			53271,  -- Master's Call (bound to pet)
			51753,  -- Camouflage
			19263,  -- Deterrence
			19503,  -- Scatter Shot
			23989,  -- Readiness
			34490,  -- Silencing Shot
			1499,   -- Freezing Trap
			13809,  -- Ice Trap
			-- Druid
			22812,  -- Barkskin
			17116,  -- Nature's Swiftness
			33891,  -- Tree of Life
			16979,  -- Feral Charge - Bear
			49376,  -- Feral Charge - Cat
			61336,  -- Survival Instincts
			50334,  -- Berserk
			22570,  -- Maim
			18562,  -- Swiftmend
			5211,   -- Bash
			22842,  -- Frenzied Regeneration
			16689,  -- Nature's Grasp
			740,    -- Tranquility
			80964,  -- Skull Bash
			80965,  -- Skull Bash
			29166,  -- Innervate
			-- Shaman
			57994, -- Wind Shear
			8056, -- Grounding Totem
			8143, -- Tremor Totem
			51514, -- Hex
			79206, -- Spiritwalker's Grace
			16190, -- Mana Tide Totem,
			98008, -- Spirit Link totem
			-- Warlock
			6789,   -- Death Coil
			5484,   -- Howl of Terror
			48020,  -- Demonic Circle: Teleport
			-- Warlock Pets
			19647,  -- Spell Lock
			7812,   -- Sacrifice
			89766,  -- Axe Toss
			89751,  -- Felstorm
			-- Paladin
			1044,   -- Hand of Freedom
			96231,  -- Rebuke
			853,    -- Hammer of Justice
			1022,   -- Hand of Protection
			498,    -- Divine Protection
			6940,   -- Hand of Sacrifice
			31821,  -- Devotion Aura
			115750, -- Blinding Light
			54428,  -- Divine Plea
			20066,  -- Repentance
			-- Warrior
			86346,  -- Colossus Smash
			85388,  -- Throwdown
			100,    -- Charge
			6552,   -- Pummel
			23920,  -- Spell Reflection
			676,    -- Disarm
			5246,   -- Intimidation Shout
			871,    -- Shield Wall
			20252,  -- Intercept
			3411,   -- Intervene
			64382,  -- Shattering Blow
			12975,  -- Last Stand
			46924,  -- Blade Storm
			-- Death Knight
			49039,  -- Lichborne
			47476,  -- Strangulate
			48707,  -- Anti-Magic Shell
			49576,  -- Death Grip
			47528,  -- Mind Freeze
			51271,  -- Pillar of Frost
			51052,  -- Anti-Magic Zone
			49203,  -- Hungering Cold
			48792,  -- Icebound Fortitute
			-- misc
			58984,  -- Shadowmeld (Nightelf racial)
			69070,  -- Goblin: Rocket Jump
		}
	}
} -- }}}

-- {{{ configuration
function Atemi:setupOptions()
	self.options = {
		name = "Atemi",
		type = 'group',
		handler = self,

		args = {
			enable = {
				type = 'toggle',
				name = L['Enable'],
				desc = L['Enables / disables this AddOn'],
				order = 1,
				set = function(info, value) Atemi:SetEnable(value) end,
				get = function(info) return Atemi:IsEnabled() end
			},
			general = {
				type = 'group',
				name = L['General'],
				desc = L['General Settings'],
				order = 2,
				args = {
					greeter = {
						type = 'toggle',
						name = L['Show greeter on load'],
						desc = L['Shows the addon greeting text in the main chat window when loading this addon.'],
						order = 1,
						get = function(info, value) return self.db.profile.showGreeter end,
						set = function(info, value) self.db.profile.showGreeter = value end
					},
					textColor = {
						type = 'color',
						name = L['cooldown text color'],
						desc = L['The color the text should be drawn in'],
						order = 2,
						hasAlpha = false,
						get = 'GetTextColor',
						set = 'SetTextColor',
					},
					showTooltips = {
						type = 'toggle',
						name = L['Show spell tooltips'],
						desc = L['Shows tooltips of their spells when hovering the cooldown icon atop of a nameplate'],
						order = 3,
						get = function()
							return Atemi.db.profile.showTooltips
						end,
						set = function(info, value)
							Atemi.db.profile.showTooltips = value
						end
					},
					autoAdjustSizes = {
						type = 'toggle',
						name = L['Resize icons/fonts'],
						desc = L['Automatically adjust icon/font-sizes relative to their nameplate width (if they would exceed).'],
						order = 3,
						get = function()
							return Atemi.db.profile.autoAdjustSizes
						end,
						set = function(info, value)
							Atemi.db.profile.autoAdjustSizes = value
						end
					},
					gapSize = {
						type = 'range',
						name = L['Icon gap size'],
						desc = L['gap in pixels between the cooldown icons'],
						order = 4,
						min = 0,
						max = 64,
						step = 1,
						get = function()
							return Atemi.db.profile.gapSize
						end,
						set = function(info, value)
							Atemi.db.profile.gapSize = value
						end
					},
					iconSize = {
						type = 'range',
						name = L['Icon size'],
						desc = L['size of the cooldown icons in pixels'],
						order = 5,
						min = 16,
						max = 128,
						step = 1,
						get = function()
							return Atemi.db.profile.iconSize
						end,
						set = function(info, value)
							Atemi.db.profile.iconSize = value
						end
					},
					fontSize = {
						type = 'range',
						name = L['font size'],
						desc = L['size of the cooldown text in pixels inside the cooldown icon'],
						order = 6,
						min = 6,
						max = 128,
						step = 1,
						get = function()
							return Atemi.db.profile.fontSize
						end,
						set = function(info, value)
							Atemi.db.profile.fontSize = value
						end
					},
					xOffset = {
						type = 'range',
						name = L['X-offset'],
						desc = L['icon offset to the X-axis relative to its nameplate parent'],
						order = 7,
						min = -64,
						max = 64,
						step = 1,
						get = function()
							return Atemi.db.profile.xOffset
						end,
						set = function(info, value)
							Atemi.db.profile.xOffset = value
						end
					},
					yOffset = {
						type = 'range',
						name = L['Y-offset'],
						desc = L['icon offset to the Y-axis relative to its nameplate parent'],
						order = 8,
						min = -64,
						max = 64,
						step = 1,
						get = function()
							return Atemi.db.profile.yOffset
						end,
						set = function(info, value)
							Atemi.db.profile.yOffset = value
						end
					}
				}
			},
			cooldowns = {
				name = L['Cooldowns'],
				type = 'group',
				get = '_GetSpellEnabled',
				set = '_SetWantNameplateIcon',
				args = {
					rogue = {
						type = 'group',
						name = L['Rogue'],
						order = 1,
						args = self:GetClassOptions("Rogue")
					},
					mage = {
						type = 'group',
						name = L["Mage"],
						order = 2,
						args = self:GetClassOptions("Mage")
					},
					priest = {
						type = 'group',
						name = L["Priest"],
						order = 3,
						args = self:GetClassOptions("Priest")
					},
					hunter = {
						type = 'group',
						name = L["Hunter"],
						order = 4,
						args = self:GetClassOptions("Hunter")
					},
					druid = {
						type = 'group',
						name = L["Druid"],
						order = 5,
						args = self:GetClassOptions("Druid")
					},
					shaman = {
						type = 'group',
						name = L["Shaman"],
						order = 6,
						args = self:GetClassOptions("Shaman")
					},
					warlock = {
						type = 'group',
						name = L["Warlock"],
						order = 7,
						args = self:GetClassOptions("Warlock")
					},
					deathknight = {
						type = 'group',
						name = L["Death Knight"],
						order = 8,
						args = self:GetClassOptions("DeathKnight")
					},
					warrior = {
						type = 'group',
						name = L["Warrior"],
						order = 9,
						args = self:GetClassOptions("Warrior")
					},
					paladin = {
						type = 'group',
						name = L["Paladin"],
						order = 10,
						args = self:GetClassOptions("Paladin")
					},
					misc = {
						type = 'group',
						name = L["Racials / Miscellaneous"],
						order = 11,
						args = self:GetClassOptions("misc")
					}
				}
			}
		}
	}
end

function Atemi:_GetSpellEnabled(info, spellID)
	return self:WantNameplateIcon(spellID)
end

function Atemi:_SetWantNameplateIcon(info, spellID)
	if self:WantNameplateIcon(spellID) then
		self:SetWantNameplateIcon(spellID, false)
	else
		self:SetWantNameplateIcon(spellID, true)
	end
end

function Atemi:GetTextColor()
	local color = self.db.profile.textColor
	return color.red, color.green, color.blue
end

function Atemi:SetTextColor(info, r, g, b)
	local color = self.db.profile.textColor
	color.red = r
	color.green = g
	color.blue = b
end

function Atemi:GetSpellDescription(spellID)
	local s = getSpellDescription(spellID)
	if s then
		return s
	else
		return "SpellID: " .. tostring(spellID)
	end
end

function Atemi:GetClassOptions(className)
	local list = {}

	if self.CLASS_COOLDOWN_MAP[className] then
		for i = 1, #self.CLASS_COOLDOWN_MAP[className] do
			local spellID = self.CLASS_COOLDOWN_MAP[className][i]
			local spellName, _, spellIcon = GetSpellInfo(spellID)

			if spellName ~= nil then
				local namePrefix = "|Hspell:" .. spellID .. "|h|T" .. tostring(spellIcon) .. ":0|t "
				local namePostfix = "|h"

				list[tostring(spellID)] = {
					type = 'group',
					name = namePrefix .. spellName .. namePostfix,
					desc = spellName,
					order = i,
					inline = true,
					args = {
						desc = {
							type = 'description',
							name = function()
								return self:GetSpellDescription(spellID)
							end,
							order = 0
						},
						iconOnNameplate = {
							type = 'toggle',
							name = L['icon on nameplate'],
							desc = L['shows an icon with the cooldown timer atop the nameplate'],
							icon = spellIcon,
							iconCoords = {0, 1, 0, 1},
							order = 1,
							get = function(info, value) return self:WantNameplateIcon(spellID) end,
							set = function(info, value)
								if self:WantNameplateIcon(spellID) then
									self:SetWantNameplateIcon(spellID, false)
								else
									self:SetWantNameplateIcon(spellID, true)
								end
							end
						},
						--[[
						announceOnUse = {
							type = 'toggle',
							name = 'announce on use',
							desc = 'Announces on the screen, that this spell has just been used by given player',
							order = 2,
							get = function() return self:WantAnnounceUsed(spellID) end,
							set = function(info, value) self:SetWantAnnounceUsed(spellID, value) end
						},
						announceBeforeReady = {
							type = 'toggle',
							name = 'announce on ready',
							desc = 'announces to the screen, that this spell is about to become ready in N seconds for given player',
							order = 3,
							get = function() return self:WantAnnounceReady(spellID) end,
							set = function(info, value) self:SetWantAnnounceReady(spellID, value) end
						}
						]]
					}
				}
			else
				self:Print(className .. ": error loading spell " .. spellID .. " as it seems to not exist (anymore).")
			end
		end
	end

	return list
end

function Atemi:GetSpellListOfClass(className)
	local list = {}

	if self.CLASS_COOLDOWN_MAP[className] then
		for i = 1, #self.CLASS_COOLDOWN_MAP[className] do
			local spellID = self.CLASS_COOLDOWN_MAP[className][i]
			local name = GetSpellInfo(spellID)
			list[spellID] = name
		end
	end

	--table.sort(list, function(a, b) return a < b end)

	return list
end

-- property: announce on use
function Atemi:WantAnnounceUsed(spellID)
	return SetContains(self.db.profile.announceUsed, spellID)
end

function Atemi:SetWantAnnounceUsed(spellID, enabled)
	self:Print("want announce used: " .. spellID .. " " .. tostring(enabled))
	return SetEnable(self.db.profile.announceUsed, spellID, enabled)
end

-- property: announce on ready
function Atemi:WantAnnounceReady(spellID)
	return SetContains(self.db.profile.announceReady, spellID)
end

function Atemi:SetWantAnnounceReady(spellID, enabled)
	return SetEnable(self.db.profile.announceReady, spellID, enabled)
end

-- tests whether or not the player has subscribed to that cooldown spell
function Atemi:WantNameplateIcon(spellID)
	return SetContains(self.db.profile.spells, spellID)
end

function Atemi:SetWantNameplateIcon(spellID, enabled)
	return SetEnable(self.db.profile.spells, spellID, enabled)
end
-- }}}

function Atemi:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("AtemiDB", self.defaults)

	if self.db.profile.showGreeter then
		Atemi:Print("|cffff6600" .. "Atemi Enemy Cooldown Tracker")
		Atemi:Print("|cffffaa42" .. "Copyright (c) 2011 by Christian Parpart <trapni@gentoo.org>")
		Atemi:Print("|cffffaa42" .. L["Use /atemi command to open configuration UI."])
	end

	self:setupOptions()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Atemi", self.options)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Atemi", "Atemi")

	self:RegisterChatCommand("atemi", self.OpenConfig)

	-- work vars
	self.cooldowns = {}
end

function Atemi:OpenConfig()
	LibStub("AceConfigDialog-3.0"):Open("Atemi")
end

function Atemi:Debug(...)
--	self:Print("debug:", ...)
end

function Atemi:SetEnable(value)
	if value then
		self:Enable()
	else
		self:Disable()
	end
end

function Atemi:OnEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	self.updateTimer = self:ScheduleRepeatingTimer("OnTimerCallback", 1)
end

function Atemi:OnDisable()
	if self.updateTimer then
		self:CancelTimer(self.updateTimer)
		self.updateTimer = nil
	end

	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	wipe(self.cooldowns)
end

-- function Atemi:COMBAT_LOG_EVENT_UNFILTERED(_, _, eventType, _, srcGUID, srcName, srcFlags, _, dstGUID, dstName, dstFlags, _, spellID, spellName, _, auraType)
function Atemi:COMBAT_LOG_EVENT_UNFILTERED(...)
	-- support WoW 4.1 and 4.2 simultanously
	local eventType, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellID, spellName, auraType
	if tonumber((select(4, GetBuildInfo()))) >= 40200 then
		_, _, eventType, _, srcGUID, srcName, srcFlags, _, dstGUID, dstName, dstFlags, _, spellID, spellName, _, auraType = ...
	else
		_, _, eventType, _, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellID, spellName, _, auraType = ...
	end

	-- skip things like nonames ;-)
	if srcName == nil then
		return
	end

	local isHostile = bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0
	local isSpellCast = eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_MISSED" or eventType == "SPELL_SUMMON"
	local isCooldown = true -- self.SPELL_COOLDOWN_MAP[spellID] ~= nil
	local isCooldownResetSpell = self.COOLDOWN_RESET_MAP[spellID] ~= nil

	--self:Debug("spell(" .. spellName .. ") cooldown:" , (self.SPELL_COOLDOWN_MAP[spellID] ~= nil))

	if isCooldown and isHostile and isSpellCast then
		local timeNow = GetTime()
		local playerName = strmatch(srcName, "[%P]+")

		-- initialize player spell set, if this is the first time we see this player cast
		if not self.cooldowns[playerName] then
			self.cooldowns[playerName] = {}
		end

		if isCooldownResetSpell then
			self:Debug("Received cooldown-reset spell: " .. spellName .. " by " .. srcName .. " (" .. eventType .. ")")
			local playerCooldowns = self.cooldowns[playerName]
			local i = 1
			local c = 0
			while i <= #playerCooldowns do
				local cooldown = playerCooldowns[i]
				if cooldown and self:IsResetableSpell(spellID, cooldown.spellID) then
					self:Debug("- found resetable cooldown: " .. cooldown.spellName)
					cooldown:Hide()
					tremove(playerCooldowns, i)
					c = c + 1
				else
					i = i + 1
				end
			end
			self:Debug("Wiped " .. tostring(c) .. " cooldowns of player " .. playerName)
		end

		-- add/set the timestamp this spell has been cast by this player, if subscribed to this spell
		local duration = self:GetSpellCooldown(spellID)
		if duration then
			self:Debug("Received spell: " .. spellName .. " by " .. srcName .. " (" .. eventType .. ")")

			local playerCooldowns = self.cooldowns[playerName]

			-- remove possibly out-dated cooldown
			local i = 1
			while i <= #playerCooldowns do
				local current = playerCooldowns[i]
				if current ~= nil and current.spellID == spellID then
					-- yes, we found an old one
					self:Debug("remove old " .. current.spellName)
					current:Hide()
					tremove(playerCooldowns, i)
					-- a spell can be only listed once per player, so break out
					break
				else
					i = i + 1
				end
			end

			-- add cooldown to the list of player cooldowns
			local cooldown = AtemiCooldown:new(spellID, timeNow + duration, self.db.profile)
			tinsert(playerCooldowns, cooldown)

			-- install timer handler on demand (to update UI on every .333 seconds)
			if not self.updateTimer then
				self.updateTimer = self:ScheduleRepeatingTimer("OnTimerCallback", 0.333)
			end
		else
			self:Debug("Ignore spell: " .. spellName .. " (" .. tostring(spellID) .. ") by " .. srcName .. " (" .. eventType .. ")")
		end
	end
end

function Atemi:IsResetableSpell(resetSpellID, testSpellID)
	local spells = self.COOLDOWN_RESET_MAP[resetSpellID]
	if spells then
		for i = 1, #spells do
			if spells[i] == testSpellID then
				return true
			end
		end
	end
	return false
end

function Atemi:GetSpellCooldown(spellID)
	local result = self.SPELL_COOLDOWN_MAP[spellID]
	if result then
		return result
	else
		return 0
	end
end

function Atemi:OnTimerCallback(elapsed)
	self:PurgeExpiredCooldowns()

	local numChildren = WorldFrame:GetNumChildren()
	for i = 1, numChildren do
		local frame = select(i, WorldFrame:GetChildren())
		local frameName = frame:GetName()
		local isNamePlate = frameName and frameName:find("NamePlate")

		if isNamePlate and frame:IsVisible() then
			local _, _, _, playerName = frame:GetRegions()
			playerName = playerName:GetText()
			--self:Debug("frameName:", frameName, "playerName:", playerName)

			local playerCooldowns = self.cooldowns[playerName]
			if playerCooldowns ~= nil then
				if not self.plateWidth then
					-- we cache this value
					self.plateWidth = frame:GetWidth()
				end

				-- collect cooldowns we want icons for
				iconsWanted = {}
				for i, cooldown in ipairs(playerCooldowns) do
					if self:WantNameplateIcon(cooldown.spellID) then
						tinsert(iconsWanted, cooldown)
					end
				end

				-- resize and/or reposition cooldown icons
				local numCooldowns = #iconsWanted
				local iconSize, fontSize

				if self.db.profile.autoAdjustSizes and
					numCooldowns * self.db.profile.iconSize + (numCooldowns * 2 - 2) > self.plateWidth
				then
					iconSize = (self.plateWidth - (numCooldowns * 2 - 2)) / numCooldowns
					fontSize = ceil(iconSize * .5) -- FIXME we could do better (honor the user's pref relative to the resizing)

					self:Debug("fontSize: " .. fontSize .. "/" .. self.db.profile.fontSize .. ", " ..
							   "iconSize: " .. iconSize .. "/" .. self.db.profile.iconSize .. ", " ..
							   "numCools: " .. numCooldowns)
				else
					iconSize = self.db.profile.iconSize
					fontSize = self.db.profile.fontSize
				end

				-- reparent (& show) (& relocate) icons, if not yet done so
				for i, cooldown in ipairs(iconsWanted) do
					-- self:Debug("Draw player cooldown: '" .. cooldown.spellName .. "'" .. " with size " .. self.size)
					cooldown:BindToNameplate(frame)

					cooldown.iconText:SetFont(self.db.profile.fontPath, fontSize, "OUTLINE")

					if i == 1 then
						cooldown:SetIconCoords("BOTTOMLEFT", frame, self.db.profile.xOffset, self.db.profile.yOffset, iconSize)
					else
						cooldown:SetIconCoords("BOTTOMLEFT", playerCooldowns[i - 1].icon, iconSize + self.db.profile.gapSize, 0, iconSize)
					end
				end

				-- install icon-hide handler
				frame:SetScript("OnHide", function()
					self:Debug("Nameplate.OnHide(" .. playerName .. ")")
					local playerCooldowns = self.cooldowns[playerName]
					if playerCooldowns then
						for _, cooldown in ipairs(playerCooldowns) do
							self:Debug("hide cd " .. cooldown.spellName)
							cooldown:Hide()
						end
					end
					frame:SetScript("OnHide", nil)
				end)
			end
		end
	end
end

function Atemi:PurgeExpiredCooldowns()
	local timeNow = GetTime()

	for playerName, playerCooldowns in pairs(self.cooldowns) do
		local i = 1
		while i <= #playerCooldowns do
			local cooldown = playerCooldowns[i]
			if cooldown:IsExpiredBy(timeNow) then
				self:Debug(cooldown.spellName .. ": expired")
				cooldown:Hide()
				tremove(playerCooldowns, i)
			else
				i = i + 1
			end
		end
	end
end
