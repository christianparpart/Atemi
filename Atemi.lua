-- Atemi
-- Copyright (c) 2011 by Christian Parpart <trapni@gentoo.org>
--
-- This addon is inspired and based on Icicle, which I was to improve
-- UI-based configurability and a higher focus on Arena cooldowns.

Atemi = LibStub("AceAddon-3.0"):NewAddon("Atemi", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

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
	[49039] = 120,				--"Lichborne",
	[47476] = 60,				--"Strangulate",
	[48707] = 45,				--"Anti-Magic Shell",
	[49576] = 25,				--"Death Grip",	
	[47528] = 10,				--"Mind Freeze",
	[49222] = 60,				--"Bone Shield",
	[51271] = 60,				--"Pillar of Frost",
	[51052] = 120,				--"Anti-Magic Zone",
	[49203] = 60,				--"Hungering Cold",
	[49028] = 90, 				--"Dancing Rune Weapon",
	[49206] = 180,				--"Summon Gargoyle",
	[43265] = 30,				--"Death and Decay",
	[48792] = 180,				--"Icebound Fortitude",
	[48743] = 120,				--"Death Pact",
	[42650] = 600,				--"Army of the Dead",

	--------------------------------------------------------------------------
	--Druid
	[22812] = 60,				--"Barkskin",
	[17116] = 180,				--"Nature's Swiftness",
	[33891] = 180,				--"Tree of Life",
	[16979] = 14,				--"Feral Charge - Bear",
	[49376] = 28,				--"Feral Charge - Cat",
	[61336] = 180,				--"Survival Instincts",
	[50334] = 180,				--"Berserk",
	[50516] = 17,				--"Typhoon",
	[33831] = 180,				--"Force of Nature",
	[22570] = 10,				--"Maim",
	[18562] = 15,				--"Swiftmend",
	[48505] = 60,				--"Starfall",
	[78675] = 60,				--"Solar Beam",
	[5211] = 50,				--"Bash",
	[22842] = 180,				--"Frenzied Regeneration",
	[16689] = 60, 				--"Nature's Grasp",
	[740] = 480,				--"Tranquility",
	[80964] = 10,				--"Skull Bash",
	[80965] = 10,				--"Skull Bash",
	[78674] = 15,				--"Starsurge",
	[29166] = 180,				--"Innervate",

	--------------------------------------------------------------------------
	--Hunter
	[82726] = 120,				--"Fervor",
	[19386] = 54,				--"Wyvern Sting",
	[3045] = 180,				--"Rapid Fire",
	[53351] = 10,				--"Kill Shot",
	[53271] = 45, 				--"Master's Call",
	[51753] = 60,				--"Camouflage",
	[19263] = 120,				--"Deterrence",
	[19503] = 30,				--"Scatter Shot",
	[23989] = 180,				--"Readiness",
	[34490] = 20,				--"Silencing Shot",
	[19574] = 90,				--"Bestial Wrath",      
	[1499] = 24,				-- Freezing Trap
	[13809] = 24,				-- Ice Trap

	--------------------------------------------------------------------------
	--Mage
	[2139] = 24,				--"Counterspell",
	[44572] = 30,				--"Deep Freeze",
	[11958] = 384,				--"Cold Snap",
	[45438] = 300,				--"Ice Block",			
	[12042] = 106,				--"Arcane Power",		
	[12051] = 240,				--"Evocation", 
	[120] = 8,                  -- Cone of Cold (10 seconds, if untalented)
	[122] = 20,					--"Frost Nova",	
	[11426] = 24,				--"Ice Barrier", 
	[12472] = 144,				--"Icy Veins",
	[82731] = 60,				--"Flame Orb", 
	[55342] = 180,				--"Mirror Image", 
	[66] = 132,					--"Invisibility",
	[1953] = 15,				-- Blink
	[82676] = 120,				--"Ring of Frost",
	[80353] = 300, 				--"Time Warp",
	[11113] = 15, 				--"Blast Wave",
	[12043] = 90,				--"Presence of Mind",
	[11129] = 120,				--"Combustion",
	[31661] = 17,				--"Dragon's Breath",	

	--------------------------------------------------------------------------
	--Paladin
	[1044] = 25,				--"Hand of Freedom",
	[31884] = 120,				--"Avenging Wrath",
	[853] = 50,					--"Hammer of Justice",
	[31935] = 15,				--"Avenger's Shield",
	[96231] = 10,				--"Rebuke",
	[633] = 420,				--"Lay on Hands",
	[1022] = 180,				--"Hand of Protection",
	[498] = 40,					--"Divine Protection",
	[54428] = 120,				--"Divine Plea",
	[642] = 300,				--"Divine Shield",
	[6940] = 96,				--"Hand of Sacrifice",
	[86150] = 120,				--"Guardian of Ancient Kings",
	[31842] = 180,				--"Divine Favor",
	[31821] = 120,				--"Aura Mastery",
	[70940] = 180,				--"Divine Guardian",
	[20066] = 60,				--"Repentance",
	[31850] = 180,				--"Ardent Defender",

	--------------------------------------------------------------------------
	--Priest
	[89485] = 45,				--"Inner Focus",
	[64044] = 90,				--"Psychic Horror",
	[8122] = 23,				--"Psychic Scream",
	[15487] = 45,				--"Silence",
	[47585] = 75,				--"Dispersion",
	[33206] = 180,				--"Pain Suppression",
	[10060] = 120,				--"Power Infusion",
	[88625] = 25,				--"Holy Word: Chastise",
	[586] = 15,					--"Fade",
	[32379] = 10,				--"Shadow Word: Death",
	[6346] = 180,				--"Fear Ward",
	[64901] = 360,				--"Hymn of Hope",
	[64843] = 480,				--"Divine Hymn",
	[73325] = 90,				--"Leap of Faith",
	[19236] = 120	,			--"Desperate Prayer",
	[724] = 180,				--"Lightwell",
	[62618] = 120,				--"Power Word: Barrier",

	--------------------------------------------------------------------------
	--Rogue
	[2094] = 120,				--"Blind",
	[1766] = 10,				--"Kick",
	[2983] = 60,				--"Sprint",
	[14185] = 300,				--"Preparation",
	[31224] = 70,				--"Cloak of Shadows",
	[1856] = 120,				--"Vanish",
	[36554] = 24,				--"Shadowstep",
	[5277] = 180,				--"Evasion",
	[408] = 20,					--"Kidney Shot",
	[51722] = 60,				--"Dismantle",
	[76577] = 180,				--"Smoke Bomb",
	[14177] = 120,				--"Cold Blood",
	[51690] = 120,				--"Killing Spree",
	[51713] = 60, 				--"Shadow Dance",
	[79140] = 120,				--"Vendetta",

	--------------------------------------------------------------------------
	--Shaman
	[98008] = 120,				--"Spirit Link Totem",
	[8177] = 13.5,				--"Grounding Totem",
	[57994] = 5,				--"Wind Shear",
	[32182] = 300,				--"Heroism",
	[2825] = 300,				--"Bloodlust",
	[51533] = 120,				--"Feral Spirit",
	[16190] = 180,				--"Mana Tide Totem",
	[30823] = 60,				--"Shamanistic Rage",
	[51490] = 35,				--"Thunderstorm",
	[2484] = 15,				--"Earthbind Totem",
	[8143] = 60,				--"Tremor Totem", patch 4.0.6
	[5730] = 20,				--"Stoneclaw Totem",
	[51514] = 35,				--"Hex",
	[79206] = 120,				--"Spiritwalker's Grace",
	[16166] = 180,				--"Elemental Mastery",
	[16188] = 120,				--"Nature's Swiftness",

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
	[72] = 12,					--"Shield Bash",
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
	},
	["Mage"] = {
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
		-- Pet: Water Elemental
		33395,  -- Freeze
		-- spells below not allowed and/or used in Arenas
--		80353,  -- Time Warp
--		11113,  -- Blast Wave
--		11129,  -- Combustion
	},
	["Priest"] = {
		89485,     -- Inner Focus
		64044,     -- Psychic Horror
		8122,      -- Psychic Scream
		15487,     -- Silence
		47585,     -- Dispersion
		33206,     -- Pain Suppression
		88625,     -- Holy Word: Chastise
		586,       -- Fade
		64901,     -- Hymn of Hope
		64843,     -- Devine Hymn
		19236,     -- Desperate Prayer
		724,       -- Lightwell
		62618,     -- Power Word: Barrier
	},
	["Hunter"] = {
		82726,  -- Fervor
		3045,   -- Rapid Fire
		19386,  -- Wyvern Sting
		53351,  -- Kill Shot
		53271,  -- Master's Call (bound to pet)
		51753,  -- Camouflage
		19263,  -- Deterrence
		19503,  -- Scatter Shot
		23989,  -- Readiness
		34490,  -- Silencing Shot
		19574,  -- Bestial Wrath
		1499,   -- Freezing Trap
		13809,  -- Ice Trap
	},
	["Druid"] = {
		22812,  -- Barkskin
		17116,  -- Nature's Swiftness
		33891,  -- Tree of Life
		16979,  -- Feral Charge - Bear
		49376,  -- Feral Charge - Cat
		61336,  -- Survival Instincts
		50334,  -- Berserk
		50516,  -- Typhoon
		33831,  -- Force of Nature
		22570,  -- Maim
		18562,  -- Swiftmend
		48505,  -- Starfall
		78675,  -- Solar Beam
		5211,   -- Bash
		22842,  -- Frenzied Regeneration
		16689,  -- Nature's Grasp
		740,    -- Tranquility
		80964,  -- Skull Bash
		80965,  -- Skull Bash
		78674,  -- Starsurge
		29166,  -- Innervate
	},
	["Shaman"] = {
		98008,  --"Spirit Link Totem
		8177,   -- Grounding Totem
		57994,  -- Wind Shear
		51533,  -- Feral Spirit
		16190,  -- Mana Tide Totem
		30823,  -- Shamanistic Rage
		51490,  -- Thunderstorm
		2484,   -- Earthbind Totem,
		8143,   -- Tremor Totem, patch 4.0.6
		5730,   -- Stoneclaw Totem
		51514,  -- Hex
		79206,  -- Spiritwalker's Grace
		16166,  -- Elemental Mastery
		16188,  -- Nature's Swiftness
--		32182,  -- Heroism
--		2825,   -- Bloodlust
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
		1044,   -- Hand of Freedom
		853,    -- Hammer of Justice
		1022,   -- Hand of Protection
		498,    -- Divine Protection
		54428,  -- Divine Plea
		6940,   -- Hand of Sacrifice
		86150,  -- Guardian of Ancient Kings
		31842,  -- Divine Favor
		31821,  -- Aura Mastery
		70940,  -- Divine Guardian
		20066,  -- Repentance
		31850,  -- Ardent Defender
	},
	["Warrior"] = {
		86346,  -- Colossus Smash
		85388,  -- Throwdown
		100,    -- Charge
		6552,   -- Pummel
		72,     -- Shield Bash
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
		49039,  -- Lichborne
		47476,  -- Strangulate
		48707,  -- Anti-Magic Shell
		49576,  -- Death Grip
		47528,  -- Mind Freeze
		49222,  -- Bone Shield
		51271,  -- Pillar of Frost
		51052,  -- Anti-Magic Zone
		49203,  -- Hungering Cold
		48792,  -- Icebound Fortitute
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
		36554, -- Shadowstep
		36554, -- Evasion
		1766,  -- Kick (XXX only with Preparation Glyph)
		51722, -- Dismantle (XXX only with Preparation Glyph)
		76577, -- Smoke Bomb (XXX only with Preparation Glyph)
	},
	[23989] = { -- Hunter: Readiness
		19263, -- Deterrence
		34490, -- Silencing Shot
		19503, -- Scatter Shot
		3045,  -- Rapid Fire
		53351, -- Kill Shot
		1499,  -- Freezing Trap
		13809, -- Ice Trap
	},
	[11958] = { -- Mage: Cold Snap
		44572, -- Deep Freeze
		45438, -- Ice Block
		12472, -- Icy Veins
		82676, -- Ring of Frost
		122,   -- Frost Nova
		11426, -- Ice Barrier
	}
}
-- }}}

Atemi.defaults = { -- {{{
	profile = {
		xOffset = 0,
		yOffset = 22,
		gapSize = 2,        -- gap in pixel between the cooldown icons
		iconSize = 22,      -- size in pixel of each cooldown icon
		autoScale = true,   -- auto-scale icon sizes to fit nameplate width as max value
		showTooltips = true,-- show spell tooltips when hovering the icon atop their nameplates
		fontSize = ceil(22 - 22 / 2),
		fontPath = "Interface\\AddOns\\Atemi\\FreeUniversal-Regular.ttf",
		textColor = { red = 0.7, green = 1.0, blue = 0.0 },
		spells = {
			44572, -- Deep Freeze
			82676, -- Ring of Frost
			19503, -- Scatter Shot
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
				name = 'Enable',
				desc = 'Enables / disables this AddOn',
				order = 1,
				set = function(info, value) Atemi:SetEnable(value) end,
				get = function(info) return Atemi:IsEnabled() end
			},
			general = {
				type = 'group',
				name = 'General',
				desc = 'General Settings',
				order = 2,
				args = {
					textColor = {
						type = 'color',
						name = 'cooldown text color',
						desc = 'The color the text should be drawn in',
						order = 1,
						hasAlpha = false,
						get = 'GetTextColor',
						set = 'SetTextColor',
					},
					showTooltips = {
						type = 'toggle',
						name = 'Show spell tooltips',
						desc = 'Shows tooltips of their spells when hovering the cooldown icon atop of a nameplate',
						order = 2,
						get = function()
							return Atemi.db.profile.showTooltips
						end,
						set = function(info, value)
							Atemi.db.profile.showTooltips = value
						end
					},
					gapSize = {
						type = 'range',
						name = 'Icon gap size',
						desc = 'gap in pixels between the cooldown icons',
						order = 3,
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
						name = 'Icon size',
						desc = 'size of the cooldown icons in pixels',
						order = 4,
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
						name = 'font size',
						desc = 'size of the cooldown text in pixels inside the cooldown icon',
						order = 5,
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
						name = 'X-offset',
						desc = 'icon offset to the X-axis relative to its nameplate parent',
						order = 6,
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
						name = 'Y-offset',
						desc = 'icon offset to the Y-axis relative to its nameplate parent',
						order = 7,
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
				type = 'group',
				name = 'Cooldowns',
				desc = 'Cooldowns to watch out for',
				order = 3,
				get = '_GetSpellEnabled',
				set = '_SetSpellEnabled',
				args = {
					rogue = {
						type = 'multiselect',
						name = "Rogoue Spells",
						order = 1,
						values = self:GetSpellListOfClass("Rogue")
					},
					mage = {
						type = 'multiselect',
						name = "Mage Spells",
						order = 2,
						values = self:GetSpellListOfClass("Mage")
					},
					priest = {
						type = 'multiselect',
						name = "Priest Spells",
						order = 3,
						values = self:GetSpellListOfClass("Priest")
					},
					hunter = {
						type = 'multiselect',
						name = "Hunter Spells",
						order = 4,
						values = self:GetSpellListOfClass("Hunter")
					},
					druid = {
						type = 'multiselect',
						name = "Druid Spells",
						order = 5,
						values = self:GetSpellListOfClass("Druid")
					},
					shaman = {
						type = 'multiselect',
						name = "Shaman",
						order = 6,
						values = self:GetSpellListOfClass("Shaman")
					},
					warlock = {
						type = 'multiselect',
						name = "Warlock",
						order = 7,
						values = self:GetSpellListOfClass("Warlock")
					},
					deathknight = {
						type = 'multiselect',
						name = "Death Knight",
						order = 8,
						values = self:GetSpellListOfClass("DeathKnight")
					},
					warrior = {
						type = 'multiselect',
						name = "Warrior",
						order = 9,
						values = self:GetSpellListOfClass("Warrior")
					},
					paladin = {
						type = 'multiselect',
						name = "Paladin",
						order = 10,
						values = self:GetSpellListOfClass("Paladin")
					},
					misc = {
						type = 'multiselect',
						name = "Racials / Miscellaneous",
						order = 11,
						values = self:GetSpellListOfClass("misc")
					}
				}
			}
		},
	}
end

function Atemi:_GetSpellEnabled(info, spellID)
	return self:IsSpellEnabled(spellID)
end

function Atemi:_SetSpellEnabled(info, spellID)
	if self:IsSpellEnabled(spellID) then
		self:SetSpellEnabled(spellID, false)
	else
		self:SetSpellEnabled(spellID, true)
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

function Atemi:SetSpellEnabled(spellID, enabled)
	local spells = self.db.profile.spells
	if enabled then
		tinsert(spells, spellID)
		return true
	else
		for i = 1, #spells do
			if spells[i] == spellID then
				tremove(spells, i)
				return true
			end
		end
		return false
	end
end
-- }}}

function Atemi:OnInitialize()
	Atemi:Print("|cffff6600" .. "Atemi Enemy Cooldown Tracker")
	Atemi:Print("|cffffaa42" .. "Copyright (c) 2011 by Christian Parpart <trapni@gentoo.org>")
	Atemi:Print("|cffffaa42" .. "Use /atemi command to open configuration UI.")

	self.db = LibStub("AceDB-3.0"):New("AtemiDB", self.defaults)

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
	--self:Print("debug:", ...)
end

function Atemi:SetEnable(value)
	if value then
		self:Enable()
	else
		self:Disable()
	end
end

function Atemi:OnEnable()
	self:Debug("Enabling")

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	self.updateTimer = self:ScheduleRepeatingTimer("OnTimerCallback", 1)
end

function Atemi:OnDisable()
	self:Debug("Disabling")

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
		if self:IsSpellEnabled(spellID) then
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
			local duration = self:GetSpellCooldown(spellID)
			local cooldown = AtemiCooldown:new(spellID, timeNow + duration, self.db.profile)
			tinsert(playerCooldowns, cooldown)

			-- install CollectNamePlates handler on demand
			if not self.updateTimer then
				self.updateTimer = self:ScheduleRepeatingTimer("OnTimerCallback", 1)
			end
		else
			self:Debug("Ignore spell: " .. spellName .. " (" .. tostring(spellID) .. ") by " .. srcName .. " (" .. eventType .. ")")
		end
	end
end

-- tests whether or not the player has subscribed to that cooldown spell
function Atemi:IsSpellEnabled(spellID)
	local spells = self.db.profile.spells
	for i = 1, #spells do
		if spells[i] == spellID then
			return true
		end
	end
	return false
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

				-- resize and/or reposition cooldown icons
				local numCooldowns = #playerCooldowns

				if numCooldowns * self.db.profile.iconSize +
						(numCooldowns * 2 - 2) > self.plateWidth then
					self.size = (self.plateWidth - (numCooldowns * 2 - 2)) / numCooldowns
				else
					self.size = self.db.profile.iconSize
				end
				self.db.profile.fontSize = ceil(self.size - self.size / 2)
				--self:Debug("size:" .. self.size .. ", iconSize:" .. self.db.profile.iconSize .. ", fontSize:" .. self.db.profile.fontSize .. ", numCDs:" .. numCooldowns)

				-- reparent (& show) (& relocate) icons, if not yet done so
				for i, cooldown in ipairs(playerCooldowns) do
					-- self:Debug("Draw player cooldown: '" .. cooldown.spellName .. "'" .. " with size " .. self.size)
					cooldown:BindToNameplate(frame)

					cooldown.iconText:SetFont(self.db.profile.fontPath, self.db.profile.fontSize, "OUTLINE")

					if i == 1 then
						cooldown:SetIconCoords("TOPLEFT", frame, self.db.profile.xOffset, self.db.profile.yOffset, self.db.profile.iconSize)
					else
						cooldown:SetIconCoords("TOPLEFT",   playerCooldowns[i - 1].icon, self.db.profile.iconSize + self.db.profile.gapSize, 0, self.db.profile.iconSize)
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
