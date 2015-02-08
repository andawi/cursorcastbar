
--
--	CursorCastbar by humfras
--	All rights reserved
--

CursorCastbar = LibStub("AceAddon-3.0"):NewAddon("CursorCastbar")

local _
local playerClass, playerGUID, targetGUID, mouseoverGUID
CursorCastbarGC = 0
local hasmouseover = false
local spelllistcreated = false
local activemirrorbar = "UNKNOWN"
local BarUpdateInProgress, DotIndicatorUpdateInProgress, BarIndicatorUpdateInProgress, ModelUpdateInProgress = false, false, false, false

local optionsvisible, optionsstrata = false, "FULLSCREEN_DIALOG"

local CursorCastbarGCSpellIDs = {
	["DEATHKNIGHT"] = 47541,
	["DRUID"] = 5176,
	["HUNTER"] = 56641,
	["MAGE"] = 133,
	["MONK"] = 100780,
	["PALADIN"] = 20154,
	["PRIEST"] = 585,
	["ROGUE"] = 1752,
	["SHAMAN"] = 403,
	["WARLOCK"] = 686,
	["WARRIOR"] = 34428,
}

local foodlocal, foodicon, iseating
local drinktable = {
	[26475] = true,
	[43183] = true,
	[118358] = true,
	[10250] = true,
	[130340] = true,
	[104262] = true,
	[92800] = true,
	[104270] = true,
	[130338] = true,
	[29007] = true,
	[430] = true,
	[431] = true,
	[432] = true,
	[1133] = true,
	[1137] = true,
	[57073] = true,
	[74431] = true,
	[43154] = true,
	[30024] = true,
	[24355] = true,
	[130341] = true,
	[92797] = true,
	[46755] = true,
	[130337] = true,
	[87958] = true,
	[130336] = true,
	[130335] = true,
	[34291] = true,
	[118359] = true,
	[80166] = true,
	[72623] = true,
	[43182] = true,
	[113703] = true,
	[105590] = true,
	[64356] = true,
	[26261] = true,
	[22734] = true,
	[25696] = true,
	[105232] = true,
	[105230] = true,
	[87959] = true,
	[43706] = true,
	[105221] = true,
	[105209] = true,
	[27089] = true,
	[1135] = true,
	[104269] = true,
	[94468] = true,
	[14823] = true,
	[43155] = true,
	[26402] = true,
	[130339] = true,
	[80167] = true,
	[92736] = true,
	[92803] = true,
	[114731] = true,
	[66041] = true,
	[52911] = true,
	[26473] = true,
	[61830] = true,
}
local foodtable = {
	[61829] = true,
	[6410] = true,
	[22731] = true,
	[40768] = true,
	[28616] = true,
	[27094] = true,
	[87544] = true,
	[35270] = true,
	[33262] = true,
	[18229] = true,
	[18233] = true,
	[26401] = true,
	[87577] = true,
	[25660] = true,
	[40745] = true,
	[25700] = true,
	[7737] = true,
	[87594] = true,
	[35271] = true,
	[33255] = true,
	[33773] = true,
	[80168] = true,
	[87595] = true,
	[66478] = true,
	[46898] = true,
	[24800] = true,
	[46683] = true,
	[80169] = true,
	[87580] = true,
	[104235] = true,
	[33264] = true,
	[18230] = true,
	[18234] = true,
	[65418] = true,
	[87597] = true,
	[108029] = true,
	[1127] = true,
	[87693] = true,
	[29008] = true,
	[57649] = true,
	[26474] = true,
	[1129] = true,
	[64056] = true,
	[104922] = true,
	[108030] = true,
	[71071] = true,
	[1131] = true,
	[5004] = true,
	[5005] = true,
	[5006] = true,
	[5007] = true,
	[46581] = true,
	[87567] = true,
	[87599] = true,
	[117705] = true,
	[87918] = true,
	[53283] = true,
	[130328] = true,
	[126535] = true,
	[87568] = true,
	[87584] = true,
	[71073] = true,
	[33258] = true,
	[33266] = true,
	[18231] = true,
	[24869] = true,
	[126536] = true,
	[61874] = true,
	[43777] = true,
	[44813] = true,
	[87601] = true,
	[108033] = true,
	[71074] = true,
	[45618] = true,
	[58886] = true,
	[130330] = true,
	[25702] = true,
	[126537] = true,
	[87570] = true,
	[87586] = true,
	[87602] = true,
	[43180] = true,
	[130745] = true,
	[26260] = true,
	[29073] = true,
	[65421] = true,
	[126538] = true,
	[87571] = true,
	[87587] = true,
	[24005] = true,
	[92735] = true,
	[2639] = true,
	[130743] = true,
	[130334] = true,
	[130333] = true,
	[40543] = true,
	[130329] = true,
	[130332] = true,
	[130327] = true,
	[126539] = true,
	[126540] = true,
	[25888] = true,
	[87572] = true,
	[87588] = true,
	[87604] = true,
	[87566] = true,
	[87636] = true,
	[108034] = true,
	[65419] = true,
	[33260] = true,
	[433] = true,
	[18232] = true,
	[25886] = true,
	[65422] = true,
	[435] = true,
	[43763] = true,
	[105231] = true,
	[104935] = true,
	[87573] = true,
	[104934] = true,
	[33725] = true,
	[45548] = true,
	[87637] = true,
	[130748] = true,
	[41030] = true,
	[87757] = true,
	[33269] = true,
	[10256] = true,
	[25695] = true,
	[48720] = true,
	[10257] = true,
	[26472] = true,
	[434] = true,
	[65420] = true,
	[32112] = true,
	[71068] = true,
	[87351] = true,
	[42311] = true,
	[105233] = true,
	[64355] = true,
	[33253] = true,
	[46812] = true,
	[24707] = true,
}
local refreshtable = {
	[57362] = 45548,
	[57366] = 45548,
	[57370] = 45548,
	[44166] = 33725,
	[58648] = 45548,
	[125103] = 104934,
	[92726] = 80169,
	[104291] = 104235,
	[124238] = 124238,
	[124246] = 104934,
	[130366] = 130327,
	[92798] = 1129,
	[57331] = 45548,
	[57335] = 45548,
	[57085] = 45548,
	[57343] = 45548,
	[104284] = 104934,
	[57355] = 45548,
	[57359] = 45548,
	[124247] = 104934,
	[130359] = 130327,
	[58645] = 43180,
	[61828] = 61829,
	[125073] = 104934,
	[104261] = 104235,
	[125105] = 104934,
	[57292] = 45548,
	[124240] = 104235,
	[124248] = 104934,
	[128701] = 104935,
	[130360] = 130328,
	[130368] = 130329,
	[95197] = 80168,
	[57328] = 45548,
	[125074] = 104235,
	[57344] = 45548,
	[57098] = 45548,
	[104294] = 104235,
	[58503] = 45548,
	[57364] = 45548,
	[57372] = 45548,
	[130369] = 130330,
	[104285] = 104935,
	[92801] = 1131,
	[57138] = 45548,
	[92804] = 27094,
	[130365] = 130334,
	[104263] = 104235,
	[130367] = 130328,
	[57285] = 45548,
	[104287] = 104934,
	[92738] = 92735,
	[124242] = 104235,
	[124250] = 104934,
	[58067] = 45548,
	[130362] = 130330,
	[130370] = 130332,
	[57070] = 45548,
	[124245] = 104934,
	[130361] = 130329,
	[125116] = 104935,
	[57333] = 45548,
	[125114] = 104935,
	[57341] = 45548,
	[125107] = 104934,
	[104288] = 104935,
	[57357] = 45548,
	[124243] = 104235,
	[124249] = 104934,
	[64354] = 64355,
	[130363] = 130332,
	[130371] = 130333,
	[124241] = 104235,
	[124239] = 104235,
	[104296] = 104935,
	[104295] = 104934,
	[104293] = 104935,
	[57287] = 45548,
	[57289] = 45548,
	[57354] = 45548,
	[125109] = 104934,
	[104289] = 104935,
	[57106] = 45548,
	[124244] = 104235,
	[57110] = 45548,
	[104286] = 104235,
	[130364] = 130333,
	[130372] = 130334,
	[62351] = 45548,
	[59227] = 43180,
	[57326] = 45548,
	[57101] = 45548,
	[104266] = 104235,
	[104292] = 104934,
	[57096] = 45548,
	[104290] = 104934,
	[57324] = 45548,
}

local function GetSquarePoint(angle, lengthX, lengthY, clockwise)
	if not lengthY and lengthX then lengthY = lengthX end
	local angle = tonumber(angle)
	local lengthX = tonumber(lengthX)
	local lengthY = tonumber(lengthY)
	
	while angle > 360 do
		angle = angle - 360
	end
	
	if not clockwise then
		angle = 360 - angle
	end
	
	local x, y, per = 0, 0, 0
	local modx, mody = 1, 1
	
	if angle == 270 then
		x = -lengthX/2
		y = lengthY/2
	elseif angle == 180 then
		x = lengthX/2
		y = lengthY/2
	elseif angle == 90 then
		x = lengthX/2
		y = -lengthY/2
	elseif angle == 0 or angle == 360 then
		x = -lengthX/2
		y = -lengthY/2
	elseif angle > 270 then
		angle = angle - 270
		per = 100/90*angle
		if per == 50 then
			x = -lengthX/2
			y = 0
		else
			x = -lengthX/2
			y = 0 + lengthY/2 - lengthY*per/100
		end
	elseif angle > 180 then
		angle = angle - 180
		per = 100/90*angle
		if per == 50 then
			x = 0
			y = lengthY/2
		else
			x = 0 + lengthX/2 - lengthX*per/100
			y = lengthY/2
		end
	elseif angle > 90 then
		angle = angle - 90
		per = 100/90*angle
		if per == 50 then
			x = lengthX/2
			y = 0
		else
			x = lengthX/2
			y = 0 - lengthY/2 + lengthY*per/100
		end
	else
		per = 100/90*angle
		if per == 50 then
			x = 0
			y = -lengthY/2
		else
			x = 0 - lengthX/2 + lengthX*per/100
			y = -lengthY/2
		end
	end
	
	return x, y
	
end

local function GetCircularPoint(angle, radius, clockwise)
	
	local angle = tonumber(angle)
	local radius = tonumber(radius)
	
	while angle > 360 do
		angle = angle - 360
	end
	
	if clockwise then
		angle = 360 - angle
	end
	
	local x, y
	
	if angle == 270 then
		x = -radius
		y = 0
	elseif angle == 180 then
		x = 0
		y = -radius
	elseif angle == 90 then
		x = radius
		y = 0
	elseif angle == 0 or angle == 360 then
		x = 0
		y = radius
	elseif angle > 270 then
		x = -(radius * cos(angle-270))
		y = radius * sin(angle-270)
	elseif angle > 180 then
		x = -(radius * sin(angle-180))
		y = -(radius * cos(angle-180))
	elseif angle > 90 then
		x = radius * cos(angle-90)
		y = -(radius * sin(angle-90))
	else
		x = radius * sin(angle)
		y = radius * cos(angle)
	end
	
	return x,y
	
end

local function round(num, idp)
	return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

local function shortenvalue(val, idp)
	if val >= 1E6 then
		val = round(val/1E6,idp or 1).."m"
	elseif val >= 1E3 then
		val = round(val/1E3,idp or 1).."k"
	elseif val < 10 then
		val = round(val,idp or 1)
	elseif val <= 100 then
		val = round(val,idp or 0)
	end
	
	return val
end

local frames = {
	[1] = {
		Name = "Player",
		levelbonus = 1,
		options = {
			Castbar = true,
			Latency = true,
			DurationText = true,
			SpellText = true,
			SpellIcon = true,
		},
	},
	[2] = {
		Name = "GCD",
		text = "GlobalCooldown",
		levelbonus = 1,
		options = {
			Castbar = true,
			Latency = false,
			DurationText = false,
			SpellText = false,
			SpellIcon = false,
		},
	},
	[3] = {
		Name = "Mirror",
		levelbonus = 1,
		options = {
			Castbar = true,
			Latency = false,
			DurationText = true,
			SpellText = true,
			SpellIcon = true,
		},
	},
	[4] = {
		Name = "Alternate",
		text = "AlternatePower",
		levelbonus = 3,
		options = {
			Castbar = true,
			Latency = false,
			DurationText = true,
			SpellText = true,
			SpellIcon = false,
		},
	},
	[5] = {
		Name = "Target",
		levelbonus = 2,
		options = {
			Castbar = true,
			Latency = false,
			DurationText = true,
			SpellText = true,
			SpellIcon = true,
		},
	},
	[6] = {
		Name = "Focus",
		levelbonus = 3,
		options = {
			Castbar = true,
			Latency = false,
			DurationText = true,
			SpellText = true,
			SpellIcon = true,
		},
	},
	[7] = {
		Name = "Mouseover",
		levelbonus = 3,
		options = {
			Castbar = true,
			Latency = false,
			DurationText = true,
			SpellText = true,
			SpellIcon = true,
		},
	},
}
local getbaridbyname = {
--	["Player"] = 1
}
for i=1,#frames do
	getbaridbyname[string.lower(frames[i].Name)] = i
end
getbaridbyname["vehicle"] = getbaridbyname["player"]

local events = {

--Spell START
	"UNIT_SPELLCAST_SENT",
	"UNIT_SPELLCAST_START",
	"UNIT_SPELLCAST_CHANNEL_START",
	"UNIT_SPELLCAST_DELAYED",
	"MIRROR_TIMER_START",
	
--Spell STOP
	"UNIT_SPELLCAST_STOP",
	"UNIT_SPELLCAST_SUCCEEDED",
	"UNIT_SPELLCAST_FAILED",
	"UNIT_SPELLCAST_FAILED_QUIET",
	"UNIT_SPELLCAST_INTERRUPTED",
	"UNIT_SPELLCAST_CHANNEL_STOP",
	"MIRROR_TIMER_STOP",
	
--Spell UPDATE
	"UNIT_SPELLCAST_CHANNEL_UPDATE",
	
--Cooldown
	"SPELL_UPDATE_COOLDOWN",
	--"SPELL_UPDATE_USABLE",
	--"ACTIONBAR_UPDATE_COOLDOWN",
	
--Event
	--"PLAYER_ENTER_COMBAT",
	--"PLAYER_LEAVE_COMBAT",
	--"PLAYER_REGEN_DISABLED",
	--"PLAYER_REGEN_ENABLED",
	"VARIABLES_LOADED",
	"PLAYER_ENTERING_WORLD",
	"PLAYER_LEAVING_WORLD",
	"COMBAT_LOG_EVENT_UNFILTERED",
	"ZONE_CHANGED_NEW_AREA",
	
--Other
	"PLAYER_TARGET_CHANGED",
	"ACTIVE_TALENT_GROUP_CHANGED",
	"UNIT_POWER",	--May be used for 5 sec rule (Castbar 10)
	"UNIT_POWER_BAR_SHOW",
	"UNIT_POWER_BAR_HIDE",
	
	"UPDATE_MOUSEOVER_UNIT",	--Needed for MouseOver buff lookup
	--"CURSOR_UPDATE",
	"UNIT_AURA",
	
--[[ Currently unused Events
	"MIRROR_TIMER_PAUSE",
	"START_AUTOREPEAT_SPELL",
	"STOP_AUTOREPEAT_SPELL",
	"UNIT_ATTACK",
	]]
	
	
}

local anchors = {
	["Cursor"] = "Cursor",
	["Static"] = "Static",
--	["Semi-Static"] = "Semi-Static",
}
local panchors = {
	["Cursor"] = "Cursor",
	["Static"] = "Static",
	["Semi-Static"] = "Semi-Static",
}

local directions = {
	["Clockwise"] = "Clockwise",
	["Counter clockwise"] = "Counter clockwise",
}

local bartextures = {}
for i=1,#CursorCastbarBarTexture do
	bartextures[i] = CursorCastbarBarTexture[i].Name
end

local MirrorbarIcons = {
	["EXHAUSTION"] = "Interface\\Icons\\Spell_Holy_PainSupression",
	["BREATH"] = "Interface\\Icons\\Spell_Shadow_DemonBreath",
	["FEIGNDEATH"] = "Interface\\Icons\\Ability_Rogue_FeignDeath",
	["UNKNOWN"] = "Interface\\Icons\\INV_Misc_QuestionMark",
}

local fstrata = {
	[1] = "BACKGROUND",
	[2] = "LOW",
	[3] = "MEDIUM",
	[4] = "HIGH",
	[5] = "DIALOG",
	[6] = "FULLSCREEN",
	[7] = "FULLSCREEN_DIALOG",
	[8] = "TOOLTIP",
}

local drawlayer = {
	[1] = "BACKGROUND",
	[2] = "BORDER",
	[3] = "ARTWORK",
	[4] = "OVERLAY",
	[5] = "HIGHLIGHT",
}

local unitids = {
	["player"] = "Player",
	["target"] = "Target",
	["mouseover"] = "Mouseover",
}

local aurafilter = {
	["HELPFUL"] = "BUFF",
	["PLAYER|HELPFUL"] = "BUFF cast by the PLAYER",
	["HELPFUL|CANCELABLE"] = "BUFF, cancelable",
	["HELPFUL|RAID"] = "BUFF that you can cast on your raid",
	
	["HARMFUL"] = "DEBUFF",
	["PLAYER|HARMFUL"] = "DEBUFF cast by the PLAYER",
	["HARMFUL|CANCELABLE"] = "DEBUFF, cancelable",	
}

local defaults = {
	profile = {
		enabled = true,
		hideblizzard = true,
		showpreview = true,
		global = {
			scale = 1,
			alpha = 1,
			anchor = "Cursor",
			locked = true,
			framestrata = 5,
			delay = 50,
			ofsx = 0,
			ofsy = 0,
		},
		Player = {
			enabled = true,
			scale = 1,
			alpha = 1,
			level = 1,
			anchor = "Cursor",
			point = {
				point = "CENTER", 
				relativeTo = "CursorCastbarMain", 
				relativePoint = "CENTER", 
				ofsx = 0,
				ofsy = 0,
			},
			Castbar = {
				enabled = true,
				direction = "Counter clockwise",
				rotation = 0,
				size = 70,
				alpha = 1,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarMain1", 
					relativePoint = "CENTER", 
					ofsx = 0,
					ofsy = 0,
				},
				drawlayer = 3,
				texture = 11,
				staticcolor = false,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
			Latency = {
				enabled = true,
				subtract = false,
				alpha = 0.35,
				drawlayer = 4,
			},
			DurationText = {
				enabled = true,
				size = 12,
				alpha = 1,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarMain1", 
					relativePoint = "CENTER", 
					ofsx = 0, 
					ofsy = -11,
				},
			},
			SpellText = {
				enabled = true,
				scale = 1,
				alpha = 1,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
				level = 4,
				radius = 34,
				charsize = 15,
				charspace = -9,
				rotanchor = 190,
				radius = 34,
			},
			SpellIcon = {
				enabled = true,
				design = "Square",--square or circle
				level = 3,
				scale = 1,
				size = 50,
				alpha = 1,
				drawlayer = 3,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarMain1", 
					relativePoint = "CENTER", 
					ofsx = 0, 
					ofsy = 0,
				},
			},
		},
		GCD = {
			enabled = true,
			scale = 1,
			alpha = 1,
			level = 1,
			anchor = "Cursor",
			point = {
				point = "CENTER", 
				relativeTo = "CursorCastbarMain", 
				relativePoint = "CENTER", 
				ofsx = 0,
				ofsy = 0,
			},
			Castbar = {
				enabled = true,
				direction = "Counter clockwise",
				rotation = 0,
				parent = "CursorCastbarMain2",
				size = 50,
				alpha = 1,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarMain2", 
					relativePoint = "CENTER", 
					ofsx = 0, 
					ofsy = 0,
				},
				level = 1,
				texture = 11,
				staticcolor = true,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
		},
		Mirror = {
			enabled = true,
			scale = 1,
			alpha = 1,
			level = 1,
			anchor = "Cursor",
			point = {
				point = "CENTER", 
				relativeTo = "CursorCastbarMain", 
				relativePoint = "CENTER", 
				ofsx = 0,
				ofsy = 0,
			},
			Castbar = {
				enabled = true,
				direction = "Counter clockwise",
				rotation = 0,
				parent = "CursorCastbarMain3",
				size = 90,
				alpha = 1,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarMain3", 
					relativePoint = "CENTER", 
					ofsx = 0, 
					ofsy = 0,
				},
				level = 1,
				texture = 11,
				staticcolor = true,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
			DurationText = {
				enabled = true,
				size = 12,
				alpha = 1,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarMain4", 
					relativePoint = "CENTER", 
					ofsx = 0, 
					ofsy = 40,
				},
			},
			SpellText = {
				enabled = true,
				scale = 1,
				alpha = 1,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
				level = 4,
				radius = 43,
				charsize = 19,
				charspace = -8,
				rotanchor = 190,
			},
			SpellIcon = {
				enabled = true,
				design = "Square",--square or circle
				level = 3,
				scale = 1,
				size = 50,
				alpha = 1,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarMain4", 
					relativePoint = "CENTER", 
					ofsx = 0, 
					ofsy = 0,
				},
			},
		},
		Target = {
			enabled = true,
			scale = 1,
			alpha = 1,
			level = 1,
			anchor = "Cursor",
			point = {
				point = "CENTER", 
				relativeTo = "CursorCastbarMain", 
				relativePoint = "CENTER", 
				ofsx = 0,
				ofsy = 0,
			},
			Castbar = {
				enabled = true,
				direction = "Counter clockwise",
				rotation = 0,
				parent = "CursorCastbarMain4",
				size = 110,
				alpha = 1,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarMain4", 
					relativePoint = "CENTER", 
					ofsx = 0, 
					ofsy = 0,
				},
				level = 2,
				texture = 11,
				staticcolor = false,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
	--[[		Latency = {
				enabled = true,
				subtract = false,
				alpha = 0.35,
			},]]
			DurationText = {
				enabled = true,
				size = 12,
				alpha = 1,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarMain4", 
					relativePoint = "CENTER", 
					ofsx = 0, 
					ofsy = 40,
				},
			},
			SpellText = {
				enabled = true,
				scale = 1,
				alpha = 1,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
				level = 4,
				radius = 52,
				charsize = 21,
				charspace = -7,
				rotanchor = 190,
			},
			SpellIcon = {
				enabled = true,
				design = "Square",--square or circle
				level = 3,
				scale = 1,
				size = 50,
				alpha = 1,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarMain4", 
					relativePoint = "CENTER", 
					ofsx = 0, 
					ofsy = 0,
				},
			},
		},
		Focus = {
			enabled = true,
			scale = 1,
			alpha = 1,
			level = 1,
			anchor = "Cursor",
			point = {
				point = "CENTER", 
				relativeTo = "CursorCastbarMain", 
				relativePoint = "CENTER", 
				ofsx = 0,
				ofsy = 0,
			},
			Castbar = {
				enabled = true,
				direction = "Counter clockwise",
				rotation = 0,
				parent = "CursorCastbarMain4",
				size = 130,
				alpha = 1,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarMain5", 
					relativePoint = "CENTER", 
					ofsx = 0, 
					ofsy = 0,
				},
				level = 2,
				texture = 11,
				staticcolor = false,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
	--[[		Latency = {
				enabled = true,
				subtract = false,
				alpha = 0.35,
			},]]
			DurationText = {
				enabled = true,
				size = 12,
				alpha = 1,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarMain5", 
					relativePoint = "CENTER", 
					ofsx = 0, 
					ofsy = 40,
				},
			},
			SpellText = {
				enabled = true,
				scale = 1,
				alpha = 1,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
				level = 4,
				radius = 62,
				charsize = 21,
				charspace = -7,
				rotanchor = 190,
			},
			SpellIcon = {
				enabled = true,
				design = "Square",--square or circle
				level = 3,
				scale = 1,
				size = 50,
				alpha = 1,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarMain5", 
					relativePoint = "CENTER", 
					ofsx = 0, 
					ofsy = 0,
				},
			},
		},
		Mouseover = {
			enabled = true,
			scale = 1,
			alpha = 1,
			level = 1,
			anchor = "Cursor",
			point = {
				point = "CENTER", 
				relativeTo = "CursorCastbarMain", 
				relativePoint = "CENTER", 
				ofsx = 0,
				ofsy = 0,
			},
			Castbar = {
				enabled = true,
				direction = "Counter clockwise",
				rotation = 0,
				parent = "CursorCastbarMain4",
				size = 130,
				alpha = 1,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarMain5", 
					relativePoint = "CENTER", 
					ofsx = 0, 
					ofsy = 0,
				},
				level = 2,
				texture = 11,
				staticcolor = false,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
	--[[		Latency = {
				enabled = true,
				subtract = false,
				alpha = 0.35,
			},]]
			DurationText = {
				enabled = true,
				size = 12,
				alpha = 1,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarMain5", 
					relativePoint = "CENTER", 
					ofsx = 0, 
					ofsy = 40,
				},
			},
			SpellText = {
				enabled = true,
				scale = 1,
				alpha = 1,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
				level = 4,
				radius = 71,
				charsize = 21,
				charspace = -6,
				rotanchor = 190,
			},
			SpellIcon = {
				enabled = true,
				design = "Square",--square or circle
				level = 3,
				scale = 1,
				size = 50,
				alpha = 1,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarMain5", 
					relativePoint = "CENTER", 
					ofsx = 0, 
					ofsy = 0,
				},
			},
		},
		Alternate = {
			enabled = true,
			scale = 1,
			alpha = 1,
			level = 1,
			anchor = "Cursor",
			point = {
				point = "CENTER", 
				relativeTo = "CursorCastbarMain", 
				relativePoint = "CENTER", 
				ofsx = 0,
				ofsy = 0,
			},
			Castbar = {
				enabled = true,
				direction = "Counter clockwise",
				rotation = 0,
				parent = "CursorCastbarMain4",
				size = 130,
				alpha = 1,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarMain5", 
					relativePoint = "CENTER", 
					ofsx = 0, 
					ofsy = 0,
				},
				level = 2,
				texture = 11,
				staticcolor = false,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
			DurationText = {
				enabled = true,
				size = 12,
				alpha = 1,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarMain5", 
					relativePoint = "CENTER", 
					ofsx = 0, 
					ofsy = 40,
				},
			},
			SpellText = {
				enabled = true,
				scale = 1,
				alpha = 1,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
				level = 4,
				radius = 71,
				charsize = 21,
				charspace = -6,
				rotanchor = 190,
			},
		},
		DotIndicators = {
			enabled = true,
			direction = "Counter clockwise",
			rotation = 0,
			scale = 1,
			alpha = 1,
			size = "Small", --"Small" or "Large"
		},
		BarIndicators = {
			enabled = true,
		}
	}
}

do	--create indicator defaults
	for i=1,8 do
		defaults.profile.DotIndicators[i] = {
			enabled = true,
			Spells = "Test"..i.."-1;Test"..i.."-2\nTest"..i.."-3",
			Type = "Cooldown", --"Cooldown" or "Aura"
			Target = "player",
			Filter = "HELPFUL",
			blink = false,
			blinkvalue = 1,	--seconds, will be converted to milliseconds in the OnUpdate func
			invert = false,
			color = {
				r = 1,
				g = 1,
				b = 1,
			},
		}
		defaults.profile.BarIndicators[i] = {
			enabled = true,
			Spells = "Test"..i.."-1;Test"..i.."-2\nTest"..i.."-3",
			Type = "Cooldown", --"Cooldown" or "Aura"
			Target = "player",
			Filter = "HELPFUL",
			Castbar = {
				enabled = true,
				direction = "Counter clockwise",
				rotation = 0,
				parent = "CursorCastbarBarIndicator",
				size = 90,
				alpha = 1,
				point = {
					point = "CENTER", 
					relativeTo = "CursorCastbarBarIndicator", 
					relativePoint = "CENTER", 
					ofsx = 0, 
					ofsy = 0,
				},
				level = 1,
				texture = 8,
				staticcolor = true,
				color = {
					r = 1,
					g = 1,
					b = 1,
				},
			},
		}
	end
end


local function optshow()
	optionsvisible = true
	optionsstrata = InterfaceOptionsFrame:GetFrameStrata()
	local ccbstrata = CursorCastbarMain:GetFrameStrata()
	local newstrata
	for i=1,#fstrata do
		if fstrata[i] == ccbstrata then
			newstrata = fstrata[(i-1)]
		end
	end
	InterfaceOptionsFrame:SetFrameStrata(newstrata)
	CursorCastbar:ToggleDotIndicators(optionsvisible)
	CursorCastbar:CheckAllIndicators()
end
local function opthide()
	optionsvisible = false
	InterfaceOptionsFrame:SetFrameStrata(optionsstrata)
	CursorCastbar:UpdateVisuals(false)
	CursorCastbar:ToggleDotIndicators(optionsvisible)
	CursorCastbar:CheckAllIndicators()
end
local function checkopt()
	if LibStub("AceConfigDialog-3.0").OpenFrames and LibStub("AceConfigDialog-3.0").OpenFrames.CursorCastbar then
		optshow()
	else
		opthide()
	end
end


function CursorCastbar:OnInitialize()
		
	self.db = LibStub("AceDB-3.0"):New("CursorCastbarDB", defaults, true)
	
	CursorCastbar:GetOptions()	--create options

	local LibDualSpec = LibStub("LibDualSpec-1.0")
	LibDualSpec:EnhanceDatabase(self.db, "CursorCastbar")
	LibDualSpec:EnhanceOptions(self.Options.args.profile, self.db)
	
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("CursorCastbar", CursorCastbar:GetOptions())
	LibStub("AceConfig-3.0"):RegisterOptionsTable("CursorCastbarSlashCommand", CursorCastbar.OptionsSlash, {"cursorcastbar", "ccb"})
	--[[	-- not using Blizzard's Interface options because of taint issues
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("CursorCastbar", "CursorCastbar")	
	self.optionsFrame:HookScript("OnShow", optshow)
	self.optionsFrame:HookScript("OnHide", opthide)]]
	--hooksecurefunc(LibStub("AceConfigDialog-3.0"), "Open", optshow)
	hooksecurefunc(LibStub("AceConfigDialog-3.0"), "Close", function(frame, name) if name == "CursorCastbar" then opthide() end end)
	hooksecurefunc(LibStub("AceConfigDialog-3.0"), "CloseAll", opthide)
	hooksecurefunc(LibStub("AceGUI-3.0"), "Release", checkopt)
	
--Check Playerclass
	playerClass = select(2,UnitClass("player"))
	playerGUID = UnitGUID("player")
	
--Create Frames
	CursorCastbar:CreateFrames()
	
end

function CursorCastbar:ToggleEnable()
	if CursorCastbar.enabled then
		CursorCastbar:OnEnable()
	else
		CursorCastbar:OnDisable()
	end
end

function CursorCastbar:OnEnable()
	
	local f = _G["CursorCastbarParse"]
	for k,v in pairs(events) do
		f:RegisterEvent(v)
	end
	
	f:SetScript("OnUpdate", function(self, elapsed)
		CursorCastbar:OnUpdate(self, elapsed)
	end)
	CursorCastbarMain:Show()
	CursorCastbar:CheckAllIndicators()
	CursorCastbar:UNIT_POWER_BAR_SHOW()
	
end

function CursorCastbar:OnDisable()
	
	local f = _G["CursorCastbarParse"]
	for k,v in pairs(events) do
		f:UnregisterEvent(v)
	end
	
	f:SetScript("OnUpdate", nil)
	CursorCastbarMain:Hide()
	for i = 1, #frames do
		CursorCastbar:EndBar(i, "OnDisable", nil, true)
	end
	
end

local old_MirrorTimer_Show = MirrorTimer_Show
function CursorCastbar:ToggleBlizzard()
	local tEvents = {
		"UNIT_SPELLCAST_START",
		"UNIT_SPELLCAST_STOP",
		"UNIT_SPELLCAST_INTERRUPTED",
		"UNIT_SPELLCAST_FAILED",
		"UNIT_SPELLCAST_DELAYED",
		"UNIT_SPELLCAST_CHANNEL_START",
		"UNIT_SPELLCAST_CHANNEL_UPDATE",
		"UNIT_SPELLCAST_CHANNEL_STOP",
	}
	local frame = _G["CastingBarFrame"]
	if frame then
		for _, event in pairs(tEvents) do
			if self.db.profile.hideblizzard then
				frame:UnregisterEvent(event)
				frame:Hide()
			else
				frame:RegisterEvent(event)
			end
		end
	end
	
	
	
	local tEvents = {
	--	"MIRROR_TIMER_START",
		"MIRROR_TIMER_PAUSE",
		"MIRROR_TIMER_STOP",
	}
	for i=1,MIRRORTIMER_NUMTIMERS do
		local frame = _G["MirrorTimer"..i]
		if frame then
			for _, event in pairs(tEvents) do
				if self.db.profile.hideblizzard then
					frame:UnregisterEvent(event)
					frame:Hide()
					MirrorTimer_Show = function() end
				else
					frame:RegisterEvent(event)
					MirrorTimer_Show = old_MirrorTimer_Show
				end
			end
		end
	end
end


function CursorCastbar:SetAlpha(frame,value)
	local f
	if type(frame) == "table" then
		f = frame
	elseif type(frame) == "string" then
		f = _G[frame]
	end
	if not f then return end
	
	local alpha
	local v = tonumber(value)
	if not v or v == nil then print("CCB: alpha value is incorrect") return end
	if v < 0 then v = -v end
	if v > 1 then v = v/100 end
	if v < 0 or v > 1 then print("CCB: Alpha value is incorrect") return end
	alpha = v
	
	if f and alpha then
		f:SetAlpha(alpha)
	end
	
end

function CursorCastbar:SetScale(frame,value)
	local f
	if type(frame) == "table" then
		f = frame
	elseif type(frame) == "string" then
		f = _G[frame]
	end
	if not f then return end
	
	local scale
	local v = tonumber(value)
	if not v or v == nil then print("CCB: scale value is incorrect") return end
	if v < 0 then v = -v end
	if v < 0 then print("CCB: scale value is incorrect") return end
	scale = v
	
	if f and scale then
		f:SetScale(scale)
	end
	
end

function CursorCastbar:SetFrameLevel(frame,value)
	local f
	if type(frame) == "table" then
		f = frame
	elseif type(frame) == "string" then
		f = _G[frame]
	end
	if not f then return end
	
	local baselevel = CursorCastbarMain:GetFrameLevel()
	
	if f and scale then
		f:SetFrameLevel(baselevel+value)
	end
	
end

function CursorCastbar:SetSize(frame,value)
	local f
	if type(frame) == "table" then
		f = frame
	elseif type(frame) == "string" then
		f = _G[frame]
	end
	if not f then return end
	
	local size
	local v = tonumber(value)
	if not v or v == nil then print("CCB: size value is incorrect") return end
	if v < 0 then v = -v end
	if v < 0 then print("CCB: size value is incorrect") return end
	size = v
	
	if f and size then
		if f.SetSize then
			f:SetSize(size,size)
		else
			f:SetWidth(size)
			f:SetHeight(size)
		end
	end
	
end

function CursorCastbar:SetVisible(frame,value)
	local f
	if type(frame) == "table" then
		f = frame
	elseif type(frame) == "string" then
		f = _G[frame]
	end
	if not f then return end
	
	if value then
		f:Show()
	else
		f:Hide()
	end
	
end

function CursorCastbar:SetPoint(frame, table, p, rf, rp, x, y)
	local f
	if type(frame) == "table" then
		f = frame
	elseif type(frame) == "string" then
		f = _G[frame]
	end
	if not f or f==nil then
		print("CCB_SetPoint: No Frame")	--DEBUG
		return
	end
	
	local point, relativeframe, relativepoint, ofsx, ofsy
	if table and table ~= {} then
		point, relativeframe, relativepoint, ofsx, ofsy = table.point, table.relativeTo, table.relativePoint, table.ofsx, table.ofsy
	elseif type(p)=="string" and ( type(rf)=="string" or type(rf)=="table" ) and type(rp)=="string" and tonumber(x) and tonumber(y) then
		point, relativeframe, relativepoint, ofsx, ofsy = p, rf, rp, x, y
	else
		print("CCB_SetPoint: Can not create points")	--DEBUG
		return
	end
	
	f:ClearAllPoints()
	f:SetPoint(point, relativeframe, relativepoint, ofsx, ofsy)
	
--	/run CursorCastbar:SetPoint("CursorCastbarMain1Fontstring",self.db.profile.Player.DurationText.point)
end

-- Slash commands
CursorCastbar.OptionsSlash = {
	type = "group",
	name = "Slash Command",
	order = -3,
	args = {
		config = {
			type = "execute",
			name = "Configure",
			desc = "Open the configuration dialog ( /ccb config )",
			func = function() CursorCastbar:ShowConfig() end,
			guiHidden = true,
		},
		enable = {
			type = "execute",
			name = "Enable",
			desc = "Enable CCB ( /ccb show )",
			func = function() CursorCastbar:OnEnable() end,
		},
		disable = {
			type = "execute",
			name = "Disable",
			desc = "Disable CCB ( /ccb hide )",
			func = function() CursorCastbar:OnDisable() end,
		},
	},
}


-- Config
function CursorCastbar:ShowConfig()
	-- not using Blizzard's Interface options because of taint issues
--	InterfaceOptionsFrame_OpenToCategory("CursorCastbar")
	LibStub("AceConfigDialog-3.0"):Open("CursorCastbar")
	optshow()
end


function CursorCastbar:CreateMainbarConfig(i)
	local t = {}
	local ot = frames[i].options
	if not ot then return end

	t.enable = {
		name = "Enable",
		desc = "Enables / disables the castbar",
		order = 0,
		type = "toggle",
		set = function(info,val)
			self.db.profile[info[1]].enabled = val
			CursorCastbar:CreateFrames()
		end,
		get = function(info) return self.db.profile[info[1]].enabled end
	}
	
	t.description = {
		name = "",
		order = 0.1,
		type = "description"
	}
	t.scale = {
		name = "Scale",
		desc = "frame scale",
		order = 0.2,
		type = "range",
		min = 0.1,
		max = 2,
		step = 0.1,
		set = function(info, val)
			self.db.profile[info[1]].scale = val
			CursorCastbar:CreateFrames()
			end,
		get = function(info) return self.db.profile[info[1]].scale end
	}
	t.alpha = {
		name = "Alpha",
		desc = "frame alpha",
		order = 0.3,
		type = "range",
		min = 0,
		max = 1,
		step = 0.05,
		set = function(info, val)
			self.db.profile[info[1]].alpha = val
			CursorCastbar:CreateFrames()
		end,
		get = function(info) return self.db.profile[info[1]].alpha end
	}
	t.level = {
		name = "Level",
		desc = "FrameLevel",
		order = 1,
		type = "range",
		min = 1,
		max = 20,
		step = 1,
		set = function(info, val)
			self.db.profile[info[1]].level = val
			CursorCastbar:CreateFrames()		
		end,
		get = function(info) return self.db.profile[info[1]].level end
	}
	t.anchorsetting = {
		name = "Anchor settings",
		order = 10,
		type = "header",
		width = "full",
	}
	t.anchor = {
		name = "Anchor",
		desc = "The frame/point the frame is anchored to.\n|cffff6d00Cursor|r means the standard behaviour (the Castbar moves with the cursor)\n|cffff6d00Semi-Static|r means that the Castbar will anchor to the point the Cursor was located when the cast was initiated.\n|cffff6d00Static|r means that the Castbar frame can be dragged in the UI.",
		order = 10.1,
		type = "select",
		values = panchors,
		set = function(info, val)
			self.db.profile[info[1]].anchor = val
			if val == "Static" then
				self.db.profile[info[1]].point.relativeTo = "UIParent"
			else
				self.db.profile[info[1]].point.relativeTo = "CursorCastbarMain"
			end
			CursorCastbar:CreateFrames()
		end,
		get = function(info) return self.db.profile[info[1]].anchor end
	}
	t.description2 = {
		name = "",
		order = 10.2,
		type = "description"
	}
	t.posx = {
		name = "X Offset",
		desc = "horizontal position",
		order = 10.3,
		type = "range",
	--	disabled = function() if self.db.profile[info[1]].anchor == "Static" or self.db.profile[info[1]].anchor == "Cursor" then return false else return true end end,
		min = -200,
		max = 200,
		step = 1,
		set = function(info, val) 
			self.db.profile[info[1]].point.ofsx = val
			CursorCastbar:CreateFrames()
		end,
		get = function(info) return self.db.profile[info[1]].point.ofsx end
	}
	t.posy = {
		name = "Y Offset",
		desc = "vertical position",
		order = 10.4,
		type = "range",
	--	disabled = function() if self.db.profile[info[1]].anchor == "Static" or self.db.profile[info[1]].anchor == "Cursor" then return false else return true end end,
		min = -200,
		max = 200,
		step = 1,
		set = function(info, val) 
			self.db.profile[info[1]].point.ofsy = val
			CursorCastbar:CreateFrames()
		end,
		get = function(info) return self.db.profile[info[1]].point.ofsy end
	}
	
	if ot.Castbar then
		t.Castbar = {
			name = "Castbar",
			order = 1,
			type = "group",
			args = {
				enable = {
					name = "Enable",
					desc = "Enables / disables the castbar",
					order = 0,
					type = "toggle",
					set = function(info,val)
						self.db.profile[info[1]].Castbar.enabled = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].Castbar.enabled end
				},
				description = {
					name = "",
					order = 1,
					type = "description"
				},
				direction = {
					name = "Direction",
					desc = "How the Castbar should be animated.",
					order = 2,
					type = "select",
					values = directions,
					set = function(info, val)
						self.db.profile[info[1]].Castbar.direction = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].Castbar.direction end
				},
				rotation = {
					name = "Rotation",
					desc = "Rotates the castbar's starting point",
					order = 3,
					type = "range",
					min = 0,
					max = 360,
					step = 90,
					set = function(info, val)
						self.db.profile[info[1]].Castbar.rotation = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].Castbar.rotation end
				},
				size = {
					name = "Size",
					desc = "Size",
					order = 4,
					type = "range",
					min = 20,
					max = 200,
					step = 1,
					set = function(info, val)
						self.db.profile[info[1]].Castbar.size = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].Castbar.size end
				},
				alpha = {
					name = "Alpha",
					desc = "Castbar alpha",
					order = 4.2,
					type = "range",
					min = 0,
					max = 1,
					step = 0.05,
					set = function(info, val)
						self.db.profile[info[1]].Castbar.alpha = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].Castbar.alpha end
				},
				texture = {
					name = "Texture",
					desc = "Choose the Castbar texture.",
					order = 6,
					type = "select",
					width = "full",
					values = bartextures,
					set = function(info, val)
						self.db.profile[info[1]].Castbar.texture = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].Castbar.texture end
				},
				staticcolor = {
					name = "Static Color",
					desc = "Enables / disables static color",
					order = 7,
					type = "toggle",
					set = function(info,val)
						self.db.profile[info[1]].Castbar.staticcolor = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].Castbar.staticcolor end
				},
				color = {
					name = "Color",
					desc = "Select color",
					order = 7.1,
					type = "color",
					get = function(info)
						local t = self.db.profile[info[1]].Castbar.color
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = self.db.profile[info[1]].Castbar.color
						t.r, t.g, t.b, t.a = r, g, b, a
						CursorCastbar:CreateFrames()
					end,
				},
				posx = {
					name = "X Offset",
					desc = "spell duration text horizontal position",
					order = 10.1,
					type = "range",
					min = -200,
					max = 200,
					step = 1,
					set = function(info, val) 
						self.db.profile[info[1]].Castbar.point.ofsx = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].Castbar.point.ofsx end
				},
				posy = {
					name = "Y Offset",
					desc = "spell duration text vertical position",
					order = 10.2,
					type = "range",
					min = -200,
					max = 200,
					step = 1,
					set = function(info, val) 
						self.db.profile[info[1]].Castbar.point.ofsy = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].Castbar.point.ofsy end
				},
			},
		}
	end
	
	if ot.Latency then
		t.Latency = {
			name = "Latency",
			order = 2,
			type = "group",
			args = {
				enable = {
					name = "Enable",
					desc = "Enables / disables the castbar",
					order = 0,
					type = "toggle",
					set = function(info,val)
						self.db.profile[info[1]].Latency.enabled = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].Latency.enabled end
				},
				subtract = {
					name = "Subtract Latency",
					desc = "Subtracts the network latency (lag) from cast time",
					order = 1,
					type = "toggle",
					set = function(info,val) 
						self.db.profile[info[1]].Latency.subtract = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].Latency.subtract end
				},
				alpha = {
					name = "Alpha",
					desc = "castbar alpha",
					order = 2,
					type = "range",
					min = 0,
					max = 1,
					step = 0.05,
					set = function(info, val)
						self.db.profile[info[1]].Latency.alpha = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].Latency.alpha end
				},
				
			},
		}
	end
	
	if ot.DurationText then
		t.DurationText = {
			name = "DurationText",
			order = 3,
			type = "group",
			args = {
				enable = {
					name = "Enable",
					desc = "Enables / disables the spell duration text",
					order = 0,
					type = "toggle",
					set = function(info,val)
						self.db.profile[info[1]].DurationText.enabled = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].DurationText.enabled end
				},
				description = {
					name = "",
					order = 0.1,
					type = "description"
				},
				size = {
					name = "Size",
					desc = "spell duration text size",
					order = 0.2,
					type = "range",
					min = 1,
					max = 40,
					step = 1,
					set = function(info, val)
						self.db.profile[info[1]].DurationText.size = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].DurationText.size end
				},
				alpha = {
					name = "Alpha",
					desc = "spell duration text alpha",
					order = 0.3,
					type = "range",
					min = 0,
					max = 1,
					step = 0.05,
					set = function(info, val)
						self.db.profile[info[1]].DurationText.alpha = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].DurationText.alpha end
				},
				posx = {
					name = "X Offset",
					desc = "spell duration text horizontal position",
					order = 2,
					type = "range",
					min = -200,
					max = 200,
					step = 1,
					set = function(info, val) 
						self.db.profile[info[1]].DurationText.point.ofsx = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].DurationText.point.ofsx end
				},
				posy = {
					name = "Y Offset",
					desc = "spell duration text vertical position",
					order = 2.1,
					type = "range",
					min = -200,
					max = 200,
					step = 1,
					set = function(info, val) 
						self.db.profile[info[1]].DurationText.point.ofsy = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].DurationText.point.ofsy end
				},
			},
		}
	end
	
	if ot.SpellText then
		t.SpellText = {
			name = "SpellText",
			order = 4,
			type = "group",
			args = {
				enable = {
					name = "Enable",
					desc = "Enables / disables the castbar spelltext",
					order = 0,
					type = "toggle",
					set = function(info, val)
						self.db.profile[info[1]].SpellText.enabled = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].SpellText.enabled end
				},
				description = {
					name = "",
					order = 1,
					type = "description"
				},
				rotanchor = {
					name = "Rotation",
					desc = "Rotates the text's starting point",
					order = 3,
					type = "range",
					min = 0,
					max = 360,
					step = 10,
					set = function(info, val)
						self.db.profile[info[1]].SpellText.rotanchor = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].SpellText.rotanchor end
				},
				radius = {
					name = "Radius",
					desc = "The radial text offset",
					order = 3.1,
					type = "range",
					min = 1,
					max = 200,
					step = 1,
					set = function(info, val)
						self.db.profile[info[1]].SpellText.radius = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].SpellText.radius end
				},
				charsize = {
					name = "Char Size",
					desc = "Size of the chars",
					order = 4,
					type = "range",
					min = 10,
					max = 50,
					step = 1,
					set = function(info, val)
						self.db.profile[info[1]].SpellText.charsize = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].SpellText.charsize end
				},
				charspace = {
					name = "Char Space",
					desc = "Spacing of the chars",
					order = 4.1,
					type = "range",
					min = -20,
					max = -2,
					step = 1,
					set = function(info, val)
						self.db.profile[info[1]].SpellText.charspace = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].SpellText.charspace end
				},
				color = {
					name = "Color",
					desc = "Select color",
					order = 5,
					type = "color",
					set = function(info, r, g, b, a)
						local t = self.db.profile[info[1]].SpellText.color
						t.r, t.g, t.b, t.a = r, g, b, a
						CursorCastbar:CreateFrames()
					end,
					get = function(info)
						local t = self.db.profile[info[1]].SpellText.color
						return t.r, t.g, t.b, t.a
					end,
				},
				alpha = {
					name = "Alpha",
					desc = "SpellText alpha",
					order = 5.1,
					type = "range",
					min = 0,
					max = 1,
					step = 0.05,
					set = function(info, val)
						self.db.profile[info[1]].SpellText.alpha = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].SpellText.alpha end
				},
			},
		}
	end
	
	if ot.SpellIcon then
		t.SpellIcon = {
			name = "SpellIcon",
			order = 5,
			type = "group",
			args = {
				enable = {
					name = "Enable",
					desc = "Enables / disables the SpellIcon",
					order = 0,
					type = "toggle",
					set = function(info,val)
						self.db.profile[info[1]].SpellIcon.enabled = val
						CursorCastbar:CreateFrames()
					end,
					get = function(info) return self.db.profile[info[1]].SpellIcon.enabled end
				},
				description = {
					name = "",
					order = 1,
					type = "description"
				},
			},
		}
	end

		
	return t
end


-- Options table
function CursorCastbar:GetOptions()
if not CursorCastbar.Options then
	CursorCastbar.Options = {
		type = "group",
		name = "CursorCastbar",
		handler = CursorCastbar,
		set = function(info, value) db[ info[#info] ] = value end,
		get = function(info) return db[ info[#info] ] end,
		args = {
			enable = {
				name = "Enable",
				desc = "Enables / disables CursorCastbar",
				order = 0,
				type = "toggle",
				set = function(info,val)
						CursorCastbar.enabled = val
						self.db.profile.enabled = val
						CursorCastbar:ToggleEnable()
					end,
				get = function(info) return self.db.profile.enabled end
			},
			hideblizzard = {
				name = "Hide default castbars",
				desc = "Show / Hide default Blizzard castbars\n (PlayerCastbar and MirrorBar)",
				type = "toggle",
				set = function(info,val) self.db.profile.hideblizzard = val; CursorCastbar:ToggleBlizzard() end,
				get = function(info) return self.db.profile.hideblizzard end
			},
			showpreview = {
				name = "Show preview",
				desc = "Show a preview of the castbars while in config mode\nMoving the config",
				type = "toggle",
				set = function(info,val)
					self.db.profile.showpreview = val
					CursorCastbar:UpdateVisuals(val)
					CursorCastbar:ToggleDotIndicators(val)
					CursorCastbar:ToggleBlizzard()
				end,
				get = function(info) return self.db.profile.showpreview end
			},
			global = {
				name = "Global Options",
				order = 1,
				type = "group",
				args = {
					delay = {
						name = "Update delay (ms)",
						desc = "CursorCastbar update delay in milliseconds.\n|cffff6d00Increasing|r the value results in less CPU/second usage but coarses the animation.\n|cffff6d00Decreasing|r the value results in more CPU/second usage but smoothes the animation.",
						order = 0,
						type = "range",
						min = 10,
						max = 500,
						step = 10,
						width = "full",
						set = function(info, val) self.db.profile.global.delay = val end,
						get = function(info) return self.db.profile.global.delay end
					},
					scale = {
						name = "Scale",
						desc = "CursorCastbar main frame scale",
						order = 1,
						type = "range",
						min = 0.2,
						max = 2,
						step = 0.1,
						set = function(info, val) self.db.profile.global.scale = val; CursorCastbar:SetScale(CursorCastbarMain,val) end,
						get = function(info) return self.db.profile.global.scale end
					},
					alpha = {
						name = "Alpha",
						desc = "CursorCastbar main frame alpha",
						order = 2,
						type = "range",
						min = 0,
						max = 1,
						step = 0.05,
						set = function(info, val) self.db.profile.global.alpha = val; CursorCastbar:SetAlpha(CursorCastbarMain,val) end,
						get = function(info) return self.db.profile.global.alpha end
					},
					anchor = {
						name = "Anchor",
						desc = "The frame/point CursorCastbar is anchored to",
						order = 3,
						type = "select",
						values = anchors,
						set = function(info, val) self.db.profile.global.anchor = val end,
						get = function(info) return self.db.profile.global.anchor end
					},
					locked = {
						name = "Locked",
						desc = "Unlock / lock CursorCastbar main frame to enable/disable dragging",
						order = 4,
						type = "toggle",
						set = function(info, val) self.db.profile.global.locked = val end,
						get = function(info) return self.db.profile.global.locked end
					},
					framestrata = {
						name = "Frame Strata",
						desc = "Controls the frame strata of the main CursorCastbar frame. Default: DIALOG",
						type = "select",
						order = 5,
						values = fstrata,
						set = function(info, value)
							self.db.profile.global.framestrata = value
							CursorCastbarMain:SetFrameStrata(fstrata[self.db.profile.global.framestrata])
						end,
						get = function(info, value)
							return self.db.profile.global.framestrata
						end,
					},
				},
			},
			--[[
			Player = {
				name = "Player",
				order = 2,
				type = "group",
				args = {
					enable = {
						name = "Enable",
						desc = "Enables / disables the Player castbar",
						order = 0,
						type = "toggle",
						set = function(info,val) self.db.profile.Player.enabled = val
							CursorCastbar:SetVisible("CursorCastbarMain1",val)
							CursorCastbar:UpdateVisuals(true, true)
						end,
						get = function(info) return self.db.profile.Player.enabled end
					},
					description = {
						name = "",
						order = 0.1,
						type = "description"
					},
					scale = {
						name = "Scale",
						desc = "CursorCastbar Player frame scale",
						order = 0.2,
						type = "range",
						min = 0.1,
						max = 2,
						step = 0.1,
						set = function(info, val) self.db.profile.Player.scale = val; CursorCastbar:SetScale(CursorCastbarMain1,val) end,
						get = function(info) return self.db.profile.Player.scale end
					},
					alpha = {
						name = "Alpha",
						desc = "CursorCastbar Player frame alpha",
						order = 0.3,
						type = "range",
						min = 0,
						max = 1,
						step = 0.05,
						set = function(info, val) self.db.profile.Player.alpha = val; CursorCastbar:SetAlpha(CursorCastbarMain1,val) end,
						get = function(info) return self.db.profile.Player.alpha end
					},
					level = {
						name = "Level",
						desc = "FrameLevel",
						order = 1,
						type = "range",
						min = 1,
						max = 20,
						step = 1,
						set = function(info, val) self.db.profile.Player.level = val; CursorCastbar:SetFrameLevel("CursorCastbarMain1",val) end,
						get = function(info) return self.db.profile.Player.level end
					},
					anchorsetting = {
						name = "Anchor settings",
						order = 10,
						type = "header",
						width = "full",
					},
					anchor = {
						name = "Anchor",
						desc = "The frame/point the PlayerCastbar is anchored to.\n|cffff6d00Cursor|r means the standard behaviour (the Castbar moves with the cursor)\n|cffff6d00Semi-Static|r means that the Castbar will anchor to the point the Cursor was located when the cast was initiated.\n|cffff6d00Static|r means that the Castbar frame can be dragged in the UI.",
						order = 10.1,
						type = "select",
						values = panchors,
						set = function(info, val)
							self.db.profile.Player.anchor = val
							if val == "Static" then
								self.db.profile.Player.point.relativeTo = "UIParent"
							--	CursorCastbar:SetPoint("CursorCastbarMain1",self.db.profile.Player.point)
							else
								self.db.profile.Player.point.relativeTo = "CursorCastbarMain"
							--	CursorCastbar:SetPoint("CursorCastbarMain1",{point = "CENTER", relativeTo = "CursorCastbarMain", relativePoint = "CENTER", ofsx = 0, ofsy = 0,})
							end
							CursorCastbar:SetPoint("CursorCastbarMain1",self.db.profile.Player.point)
						end,
						get = function(info) return self.db.profile.Player.anchor end
					},
					description2 = {
						name = "",
						order = 10.2,
						type = "description"
					},
					posx = {
						name = "X Offset",
						desc = "CursorCastbar Player spell duration text horizontal position",
						order = 10.3,
						type = "range",
						disabled = function() if self.db.profile.Player.anchor == "Static" or self.db.profile.Player.anchor == "Cursor" then return false else return true end end,
						min = -200,
						max = 200,
						step = 1,
						set = function(info, val) 
							self.db.profile.Player.point.ofsx = val;
							if self.db.profile.Player.anchor == "Static" then
								CursorCastbar:SetPoint("CursorCastbarMain1",self.db.profile.Player.point)
							end
						end,
						get = function(info) return self.db.profile.Player.point.ofsx end
					},
					posy = {
						name = "Y Offset",
						desc = "CursorCastbar Player spell duration text vertical position",
						order = 10.4,
						type = "range",
						disabled = function() if self.db.profile.Player.anchor == "Static" or self.db.profile.Player.anchor == "Cursor" then return false else return true end end,
						min = -200,
						max = 200,
						step = 1,
						set = function(info, val) 
							self.db.profile.Player.point.ofsy = val;
							if self.db.profile.Player.anchor == "Static" then
								CursorCastbar:SetPoint("CursorCastbarMain1",self.db.profile.Player.point)
							end
						end,
						get = function(info) return self.db.profile.Player.point.ofsy end
					},
					Castbar = {
						name = "Castbar",
						order = 1,
						type = "group",
						args = {
							enable = {
								name = "Enable",
								desc = "Enables / disables the Player castbar",
								order = 0,
								type = "toggle",
								set = function(info,val) self.db.profile.Player.Castbar.enabled = val 
									CursorCastbar:SetVisible("CursorCastbarMain1Bar",val)
									CursorCastbar:UpdateVisuals(true, true)
									for k,v in pairs(info) do print(k,v) end	
								end,
								get = function(info) return self.db.profile.Player.Castbar.enabled end
							},
							description = {
								name = "",
								order = 1,
								type = "description"
							},
							direction = {
								name = "Direction",
								desc = "How the Castbar should be animated.",
								order = 2,
								type = "select",
								values = directions,
								set = function(info, val) self.db.profile.Player.Castbar.direction = val end,
								get = function(info) return self.db.profile.Player.Castbar.direction end
							},
							rotation = {
								name = "Rotation",
								desc = "Rotates the castbar's starting point",
								order = 3,
								type = "range",
								min = 0,
								max = 360,
								step = 90,
								set = function(info, val) self.db.profile.Player.Castbar.rotation = val end,
								get = function(info) return self.db.profile.Player.Castbar.rotation end
							},
							size = {
								name = "Size",
								desc = "Size",
								order = 4,
								type = "range",
								min = 20,
								max = 150,
								step = 1,
								set = function(info, val) self.db.profile.Player.Castbar.size = val;
									CursorCastbar:SetSize("CursorCastbarMain1Bar",val);
									CursorCastbar:SetSize("CursorCastbarMain1Latency",val)
								end,
								get = function(info) return self.db.profile.Player.Castbar.size end
							},
							alpha = {
								name = "Alpha",
								desc = "CursorCastbar Player castbar alpha",
								order = 4.2,
								type = "range",
								min = 0,
								max = 1,
								step = 0.05,
								set = function(info, val) self.db.profile.Player.Castbar.alpha = val end,
								get = function(info) return self.db.profile.Player.Castbar.alpha end
							},
							texture = {
								name = "Texture",
								desc = "Choose the Castbar texture.",
								order = 6,
								type = "select",
								width = "full",
								values = bartextures,
								set = function(info, val) self.db.profile.Player.Castbar.texture = val; CursorCastbar:CreateFrame("Bars", "Player", 1, self.db.profile.Player.enabled and self.db.profile.Player.Castbar.enabled) end,
								get = function(info) return self.db.profile.Player.Castbar.texture end
							},
							staticcolor = {
								name = "Static Color",
								desc = "Enables / disables static color",
								order = 7,
								type = "toggle",
								set = function(info,val) self.db.profile.Player.Castbar.staticcolor = val end,
								get = function(info) return self.db.profile.Player.Castbar.staticcolor end
							},
							color = {
								name = "Color",
								desc = "Select color",
								order = 7.1,
								type = "color",
								get = function(info)
									local t = self.db.profile.Player.Castbar.color
									return t.r, t.g, t.b, t.a
								end,
								set = function(info, r, g, b, a)
									local t = self.db.profile.Player.Castbar.color
									t.r, t.g, t.b, t.a = r, g, b, a
								end,
							},
							posx = {
								name = "X Offset",
								desc = "CursorCastbar Player spell duration text horizontal position",
								order = 10.1,
								type = "range",
								min = -200,
								max = 200,
								step = 1,
								set = function(info, val) 
									self.db.profile.Player.Castbar.point.ofsx = val;
									CursorCastbar:SetPoint("CursorCastbarMain1Bar",self.db.profile.Player.Castbar.point)
									CursorCastbar:SetPoint("CursorCastbarMain1Latency",self.db.profile.Player.Castbar.point)
								end,
								get = function(info) return self.db.profile.Player.Castbar.point.ofsx end
							},
							posy = {
								name = "Y Offset",
								desc = "CursorCastbar Player spell duration text vertical position",
								order = 10.2,
								type = "range",
								min = -200,
								max = 200,
								step = 1,
								set = function(info, val) 
									self.db.profile.Player.Castbar.point.ofsy = val;
									CursorCastbar:SetPoint("CursorCastbarMain1Bar",self.db.profile.Player.Castbar.point)
									CursorCastbar:SetPoint("CursorCastbarMain1Latency",self.db.profile.Player.Castbar.point)
								end,
								get = function(info) return self.db.profile.Player.Castbar.point.ofsy end
							},
						},
					},
					Latency = {
						name = "Latency",
						order = 2,
						type = "group",
						args = {
							enable = {
								name = "Enable",
								desc = "Enables / disables the Player castbar",
								order = 0,
								type = "toggle",
								set = function(info,val)
									self.db.profile.Player.Latency.enabled = val
									CursorCastbar:UpdateVisuals(true, true)
								end,
								get = function(info) return self.db.profile.Player.Latency.enabled end
							},
							subtract = {
								name = "Subtract Latency",
								desc = "Subtracts the network latency (lag) from cast time",
								order = 1,
								type = "toggle",
								set = function(info,val) self.db.profile.Player.Latency.subtract = val end,
								get = function(info) return self.db.profile.Player.Latency.subtract end
							},
							alpha = {
								name = "Alpha",
								desc = "CursorCastbar Player castbar alpha",
								order = 2,
								type = "range",
								min = 0,
								max = 1,
								step = 0.05,
								set = function(info, val) self.db.profile.Player.Latency.alpha = val end,
								get = function(info) return self.db.profile.Player.Latency.alpha end
							},
							
						},
					},
					DurationText = {
						name = "DurationText",
						order = 3,
						type = "group",
						args = {
							enable = {
								name = "Enable",
								desc = "Enables / disables the Player spell duration text",
								order = 0,
								type = "toggle",
								set = function(info,val) self.db.profile.Player.DurationText.enabled = val
									CursorCastbar:SetVisible("CursorCastbarMain1Fontstring",val)
									CursorCastbar:UpdateVisuals(true, true)
								end,
								get = function(info) return self.db.profile.Player.DurationText.enabled end
							},
							description = {
								name = "",
								order = 0.1,
								type = "description"
							},
							size = {
								name = "Size",
								desc = "CursorCastbar Player spell duration text size",
								order = 0.2,
								type = "range",
								min = 1,
								max = 40,
								step = 1,
								set = function(info, val) self.db.profile.Player.DurationText.size = val end,
								get = function(info) return self.db.profile.Player.DurationText.size end
							},
							alpha = {
								name = "Alpha",
								desc = "CursorCastbar Player spell duration text alpha",
								order = 0.3,
								type = "range",
								min = 0,
								max = 1,
								step = 0.05,
								set = function(info, val) self.db.profile.Player.DurationText.alpha = val; CursorCastbar:SetAlpha("CursorCastbarMain1Fontstring",val) end,
								get = function(info) return self.db.profile.Player.DurationText.alpha end
							},
							posx = {
								name = "X Offset",
								desc = "CursorCastbar Player spell duration text horizontal position",
								order = 2,
								type = "range",
								min = -200,
								max = 200,
								step = 1,
								set = function(info, val) 
									self.db.profile.Player.DurationText.point.ofsx = val;
									CursorCastbar:SetPoint("CursorCastbarMain1Fontstring",self.db.profile.Player.DurationText.point)
								end,
								get = function(info) return self.db.profile.Player.DurationText.point.ofsx end
							},
							posy = {
								name = "Y Offset",
								desc = "CursorCastbar Player spell duration text vertical position",
								order = 2.1,
								type = "range",
								min = -200,
								max = 200,
								step = 1,
								set = function(info, val) 
									self.db.profile.Player.DurationText.point.ofsy = val;
									CursorCastbar:SetPoint("CursorCastbarMain1Fontstring",self.db.profile.Player.DurationText.point)
								end,
								get = function(info) return self.db.profile.Player.DurationText.point.ofsy end
							},
						},
					},
					SpellText = {
						name = "SpellText",
						order = 4,
						type = "group",
						args = {
							enable = {
								name = "Enable",
								desc = "Enables / disables the Player castbar",
								order = 0,
								type = "toggle",
								set = function(info, val)
									self.db.profile.Player.SpellText.enabled = val
									CursorCastbar:UpdateVisuals(true, true)
								end,
								get = function(info) return self.db.profile.Player.SpellText.enabled end
							},
							description = {
								name = "",
								order = 1,
								type = "description"
							},
							rotanchor = {
								name = "Rotation",
								desc = "Rotates the text's starting point",
								order = 3,
								type = "range",
								min = 0,
								max = 360,
								step = 10,
								set = function(info, val) self.db.profile.Player.SpellText.rotanchor = val end,
								get = function(info) return self.db.profile.Player.SpellText.rotanchor end
							},
							radius = {
								name = "Radius",
								desc = "The radial text offset",
								order = 3.1,
								type = "range",
								min = 1,
								max = 200,
								step = 1,
								set = function(info, val) self.db.profile.Player.SpellText.radius = val end,
								get = function(info) return self.db.profile.Player.SpellText.radius end
							},
							charsize = {
								name = "Char Size",
								desc = "Size of the chars",
								order = 4,
								type = "range",
								min = 10,
								max = 50,
								step = 1,
								set = function(info, val) self.db.profile.Player.SpellText.charsize = val end,
								get = function(info) return self.db.profile.Player.SpellText.charsize end
							},
							charspace = {
								name = "Char Space",
								desc = "Spacing of the chars",
								order = 4.1,
								type = "range",
								min = -20,
								max = -2,
								step = 1,
								set = function(info, val) self.db.profile.Player.SpellText.charspace = val end,
								get = function(info) return self.db.profile.Player.SpellText.charspace end
							},
							color = {
								name = "Color",
								desc = "Select color",
								order = 5,
								type = "color",
								set = function(info, r, g, b, a)
									local t = self.db.profile.Player.SpellText.color
									t.r, t.g, t.b, t.a = r, g, b, a
									CursorCastbar:UpdateSpellText(1)
								end,
								get = function(info)
									local t = self.db.profile.Player.SpellText.color
									return t.r, t.g, t.b, t.a
								end,
							},
							alpha = {
								name = "Alpha",
								desc = "CursorCastbar Player SpellText alpha",
								order = 5.1,
								type = "range",
								min = 0,
								max = 1,
								step = 0.05,
								set = function(info, val) self.db.profile.Player.SpellText.alpha = val end,
								get = function(info) return self.db.profile.Player.SpellText.alpha end
							},
						},
					},
					SpellIcon = {
						name = "SpellIcon",
						order = 5,
						type = "group",
						args = {
							enable = {
								name = "Enable",
								desc = "Enables / disables the Player castbar",
								order = 0,
								type = "toggle",
								set = function(info,val) self.db.profile.Player.SpellIcon.enabled = val
									CursorCastbar:UpdateVisuals(true, true)
								end,
								get = function(info) return self.db.profile.Player.SpellIcon.enabled end
							},
							description = {
								name = "",
								order = 1,
								type = "description"
							},
						},
					},
					
				},
			},
			]]
			--[[
			GCD = {
				name = "GlobalCooldown",
				order = 3,
				type = "group",
				args = CursorCastbar:CreateMainbarConfig(2)
			},
			Mirror = {
				name = "Mirrorbar",
				order = 4,
				type = "group",
				args = CursorCastbar:CreateMainbarConfig(3)
			},
			Target = {
				name = "Target",
				order = 5,
				type = "group",
				args = CursorCastbar:CreateMainbarConfig(4)
			},
			Focus = {
				name = "Focus",
				order = 6,
				type = "group",
				args = CursorCastbar:CreateMainbarConfig(5)
			},
			Mouseover = {
				name = "Mouseover",
				order = 7,
				type = "group",
				args = CursorCastbar:CreateMainbarConfig(6)
			},
			Alternate = {
				name = "AlternatePower",
				order = 8,
				type = "group",
				args = CursorCastbar:CreateMainbarConfig(7)
			},
			]]
			
			DotIndicators = {
				name = "Indicator (dot)",
				order = 10,
				type = "group",
				args = {
					enable = {
						name = "Enable",
						desc = "Enables / disables the Indicator dots",
						order = 0,
						type = "toggle",
						set = function(info,val)
							for i=1,8 do
								local t = CursorCastbar.Options.args.DotIndicators.args[tostring(i)]
								t.disabled = not val
								for k,v in pairs(t.args) do
									if k ~= "enable" then
										if val == false then
											t.args[k].disabled = not val
										else
											t.args[k].disabled = not self.db.profile.DotIndicators[i].enabled
										end
									end
								end
							end
							self.db.profile.DotIndicators.enabled = val
						end,
						get = function(info)
							local val = self.db.profile.DotIndicators.enabled
							for i=1,8 do
								local t = CursorCastbar.Options.args.DotIndicators.args[tostring(i)]
								t.disabled = not val
								for k,v in pairs(t.args) do
									if k ~= "enable" and t.enabled == true then
										if val == false then
											t.args[k].disabled = not val
										else
											t.args[k].disabled = not self.db.profile.DotIndicators[i].enabled
										end
									end
								end
							end
							return self.db.profile.DotIndicators.enabled
						end
					},
				},
			},
			BarIndicators = {
				name = "Indicator (bar)",
				order = 11,
				type = "group",
				args = {
					enable = {
						name = "Enable",
						desc = "Enables / disables the Indicator bars",
						order = 0,
						type = "toggle",
						set = function(info,val)
							for i=1,8 do
								local t = CursorCastbar.Options.args.BarIndicators.args[tostring(i)]
								t.disabled = not val
								for k,v in pairs(t.args) do
									if k ~= "enable" then
										if val == false then
											t.args[k].disabled = not val
										else
											t.args[k].disabled = not self.db.profile.BarIndicators[i].enabled
										end
									end
								end
							end
							self.db.profile.BarIndicators.enabled = val
						end,
						get = function(info)
							local val = self.db.profile.BarIndicators.enabled
							for i=1,8 do
								local t = CursorCastbar.Options.args.BarIndicators.args[tostring(i)]
								t.disabled = not val
								for k,v in pairs(t.args) do
									if k ~= "enable" and t.enabled == true then
										if val == false then
											t.args[k].disabled = not val
										else
											t.args[k].disabled = not self.db.profile.BarIndicators[i].enabled
										end
									end
								end
							end
							return self.db.profile.BarIndicators.enabled
						end
					},
				},
			},
			profile = {
				name = "Profile",
				order = -1,
				type = "group",
				args = {
				},
			},
		}
	}
	
	
	for i = 1, #frames do
		local t = frames[i]
		local rt = {
			name = t.text or t.Name,
			order = i+1,
			type = "group",
			args = CursorCastbar:CreateMainbarConfig(i)
		}
		CursorCastbar.Options.args[t.Name] = rt
	end
	
	for i=1,8 do	--DotIndicator substrings
		CursorCastbar.Options.args.DotIndicators.args[tostring(i)] = {
			name = "Dot "..i,
			order = i,
			type = "group",
			disabled = function() return not self.db.profile.DotIndicators.enabled end,
			args = {
				enable = {
					name = "Enable",
					desc = "Enables / disables Indicator Dot "..i,
					order = 0,
					type = "toggle",
					disabled = false,
					set = function(info,val)
						local t = CursorCastbar.Options.args.DotIndicators.args[tostring(i)].args
						for k,v in pairs(t) do
							if k ~= "enable" then
								t[k].disabled = not val
							end
						end
						self.db.profile.DotIndicators[i].enabled = val
					end,
					get = function(info)
						local t = CursorCastbar.Options.args.DotIndicators.args[tostring(i)].args
						for k,v in pairs(t) do
							if k ~= "enable" then
								t[k].disabled = not self.db.profile.DotIndicators[i].enabled
							end
						end
						return self.db.profile.DotIndicators[i].enabled
					end
				},
				invert = {
					name = "Invert",
					desc = "Invert conditions\nCD: shows if NOT on cooldown \nProc: Shows if NOT active (not buffed)",
					order = 0.2,
					type = "toggle",
					disabled = function() return not self.db.profile.DotIndicators[i].enabled end,
					set = function(info,val) self.db.profile.DotIndicators[i].invert = val end,
					get = function(info) return self.db.profile.DotIndicators[i].invert end
				},
				Type = {
					name = "Spell Type",
					desc = "The spell type you want to track",
					order = 1,
					type = "select",
					disabled = function() return not self.db.profile.DotIndicators[i].enabled end,
					values = {
						["Cooldown"] = "Cooldown",
						["Aura"] = "Aura (Buff/Debuff)",
					},
					set = function(info, val) self.db.profile.DotIndicators[i].Type = val;
						local t = CursorCastbar.Options.args.DotIndicators.args[tostring(i)].args
						if val == "Cooldown" or not self.db.profile.DotIndicators[i].enabled then
							--t.Target.set("","player")
							t.Target.disabled = true
							t.auraheader.disabled = true
							t.Filter.disabled = true
						else
							t.Target.disabled = false
							t.auraheader.disabled = false
							t.Filter.disabled = false
						end
					end,
					get = function(info) 
						local t = CursorCastbar.Options.args.DotIndicators.args[tostring(i)].args
						if self.db.profile.DotIndicators[i].Type == "Cooldown" or not self.db.profile.DotIndicators[i].enabled then
							--t.Target.set("","player")
							t.Target.disabled = true
							t.auraheader.disabled = true
							t.Filter.disabled = true
						else
							t.Target.disabled = false
							t.auraheader.disabled = false
							t.Filter.disabled = false
						end
						return self.db.profile.DotIndicators[i].Type;
					end
				},
				Spells = {
					name = "SpellNames",
					order = 2,
					type = "input",
					disabled = function() return not self.db.profile.DotIndicators[i].enabled end,
					multiline = true,
					width = "full",
					set = function(info,val) self.db.profile.DotIndicators[i].Spells = val; CursorCastbar:CreateSpellList() end,
					get = function(info) return self.db.profile.DotIndicators[i].Spells end
				},
				Target = {
					name = "Unit",
					desc = "The unit that should be checked.",
					order = 3,
					disabled = function() return not self.db.profile.DotIndicators[i].enabled end,
					type = "select",
					values = unitids,
					set = function(info, val) self.db.profile.DotIndicators[i].Target = val end,
					get = function(info) return self.db.profile.DotIndicators[i].Target end
				},
				auraheader = {
					name = "Aura Options",
					order = 4,
					type = "header",
					disabled = function() return not self.db.profile.DotIndicators[i].enabled end,
					width = "full",
				},
				Filter = {
					name = "Filter",
					desc = "The filter for the AuraCheck",
					order = 4.1,
					type = "select",
					disabled = function() return not self.db.profile.DotIndicators[i].enabled end,
					width = "full",
					values = aurafilter,
					set = function(info, val) self.db.profile.DotIndicators[i].Filter = val end,
					get = function(info) return self.db.profile.DotIndicators[i].Filter end
				},
				blinkheader = {
					name = "Animation",
					order = 5,
					type = "header",
					disabled = function() return not self.db.profile.DotIndicators[i].enabled end,
					width = "full",
				},
				blink = {
					name = "Blink",
					desc = "If enabled, the dot Indicator will blink when active",
					order = 5.1,
					type = "toggle",
					disabled = function() return not self.db.profile.DotIndicators[i].enabled end,
					set = function(info,val) self.db.profile.DotIndicators[i].blink = val; CursorCastbar.Options.args.DotIndicators.args[tostring(i)].args.blinkvalue.disabled = not val end,
					get = function(info) CursorCastbar.Options.args.DotIndicators.args[tostring(i)].args.blinkvalue.disabled = not (self.db.profile.DotIndicators[i].blink and self.db.profile.DotIndicators[i].enabled); return self.db.profile.DotIndicators[i].blink end
				},
				blinkvalue = {
					name = "Blink value (sec)",
					desc = "The blink time in seconds",
					order = 5.2,
					type = "range",
					disabled = function() return not self.db.profile.DotIndicators[i].enabled end,
					min = 0.1,
					max = 2,
					step = 0.1,
					set = function(info, val) self.db.profile.DotIndicators[i].blinkvalue = val end,
					get = function(info) return self.db.profile.DotIndicators[i].blinkvalue end
				},
			},
		}
	end
	
	for i=1,8 do	--BarIndicator substrings
		CursorCastbar.Options.args.BarIndicators.args[tostring(i)] = {
			name = "Bar "..i,
			order = i,
			type = "group",
			disabled = function() return not self.db.profile.BarIndicators.enabled end,
			args = {
				enable = {
					name = "Enable",
					desc = "Enables / disables Indicator Bar "..i,
					order = 0,
					type = "toggle",
					disabled = false,
					set = function(info,val)
						local t = CursorCastbar.Options.args.BarIndicators.args[tostring(i)].args
						for k,v in pairs(t) do
							if k ~= "enable" then
								t[k].disabled = not val
							end
						end
						self.db.profile.BarIndicators[i].enabled = val
					end,
					get = function(info)
						local t = CursorCastbar.Options.args.BarIndicators.args[tostring(i)].args
						for k,v in pairs(t) do
							if k ~= "enable" then
								t[k].disabled = not self.db.profile.BarIndicators[i].enabled
							end
						end
						return self.db.profile.BarIndicators[i].enabled
					end
				},
				description = {
					name = "",
					order = 0.1,
					type = "description",
					disabled = false,
				},
				Type = {
					name = "Spell Type",
					desc = "The spell type you want to track",
					order = 1,
					type = "select",
					values = {
						["Cooldown"] = "Cooldown",
						["Aura"] = "Aura (Buff/Debuff)",
					},
					set = function(info, val) self.db.profile.BarIndicators[i].Type = val;
						local t = CursorCastbar.Options.args.BarIndicators.args[tostring(i)].args
						if val == "Cooldown" then
							t.Target.set("","player")
							t.Target.disabled = true
							t.auraheader.disabled = true
							t.Filter.disabled = true
						else
							t.Target.disabled = false
							t.auraheader.disabled = false
							t.Filter.disabled = false
						end
					end,
					get = function(info) 
						local t = CursorCastbar.Options.args.BarIndicators.args[tostring(i)].args
						if self.db.profile.BarIndicators[i].Type == "Cooldown" then
							t.Target.set("","player")
							t.Target.disabled = true
							t.auraheader.disabled = true
							t.Filter.disabled = true
						else
							t.Target.disabled = false
							t.auraheader.disabled = false
							t.Filter.disabled = false
						end
						return self.db.profile.BarIndicators[i].Type;
					end
				},
				Spells = {
					name = "SpellNames",
					order = 2,
					type = "input",
					disabled = false,
					multiline = true,
					width = "full",
					set = function(info,val) self.db.profile.BarIndicators[i].Spells = val; CursorCastbar:CreateSpellList() end,
					get = function(info) return self.db.profile.BarIndicators[i].Spells end
				},
				Target = {
					name = "Unit",
					desc = "The unit that should be checked.",
					order = 3,
					type = "select",
					values = unitids,
					set = function(info, val) self.db.profile.BarIndicators[i].Target = val end,
					get = function(info) return self.db.profile.BarIndicators[i].Target end
				},
				auraheader = {
					name = "Aura Options",
					order = 4,
					type = "header",
					width = "full",
				},
				Filter = {
					name = "Filter",
					desc = "The filter for the AuraCheck",
					order = 4.1,
					type = "select",
					width = "full",
					values = aurafilter,
					set = function(info, val) self.db.profile.BarIndicators[i].Filter = val end,
					get = function(info) return self.db.profile.BarIndicators[i].Filter end
				},
				Castbar = {
					name = "Castbar",
					order = 1,
					type = "group",
					disabled = false,
					args = {
						enable = {
							name = "Enable",
							desc = "Enables / disables the Player castbar",
							order = 0,
							type = "toggle",
							set = function(info,val) 
									local t = CursorCastbar.Options.args.BarIndicators.args[tostring(i)].args.Castbar.args
									for k,v in pairs(t) do
										if k ~= "enable" then
											t[k].disabled = not val
										end
									end
									self.db.profile.BarIndicators[i].Castbar.enabled = val
								end,
							get = function(info) return self.db.profile.BarIndicators[i].Castbar.enabled end
						},
						description = {
							name = "",
							order = 1,
							type = "description"
						},
						direction = {
							name = "Direction",
							desc = "How the Castbar should be animated.",
							order = 2,
							type = "select",
							values = directions,
							set = function(info, val) self.db.profile.BarIndicators[i].Castbar.direction = val end,
							get = function(info) return self.db.profile.BarIndicators[i].Castbar.direction end
						},
						rotation = {
							name = "Rotation",
							desc = "Rotates the castbar's starting point",
							order = 3,
							type = "range",
							min = 0,
							max = 360,
							step = 90,
							set = function(info, val) self.db.profile.BarIndicators[i].Castbar.rotation = val end,
							get = function(info) return self.db.profile.BarIndicators[i].Castbar.rotation end
						},
						size = {
							name = "Size",
							desc = "Size",
							order = 4,
							type = "range",
							min = 20,
							max = 150,
							step = 1,
							set = function(info, val) self.db.profile.BarIndicators[i].Castbar.size = val;
								CursorCastbar:SetSize("CursorCastbarMain1Bar",val);
								CursorCastbar:SetSize("CursorCastbarMain1Latency",val)
							end,
							get = function(info) return self.db.profile.BarIndicators[i].Castbar.size end
						},
						alpha = {
							name = "Alpha",
							desc = "CursorCastbar Player castbar alpha",
							order = 4.2,
							type = "range",
							min = 0,
							max = 1,
							step = 0.05,
							set = function(info, val) self.db.profile.BarIndicators[i].Castbar.alpha = val end,
							get = function(info) return self.db.profile.BarIndicators[i].Castbar.alpha end
						},
						parent = {
							name = "Parent",
							desc = "Parent",
							order = 5,
							type = "select",
							values = {
								["CursorCastbarMain1"] = "CursorCastbarMain1",
								["UIParent"] = "UIParent",
							},
							set = function(info, val) self.db.profile.BarIndicators[i].Castbar.parent = val end,
							get = function(info) return self.db.profile.BarIndicators[i].Castbar.parent end
						},
						level = {
							name = "Level",
							desc = "FrameLevel",
							order = 6,
							type = "range",
							min = 1,
							max = 20,
							step = 1,
							set = function(info, val) self.db.profile.BarIndicators[i].Castbar.level = val; CursorCastbar:SetFrameLevel("CursorCastbarMain1",val) end,
							get = function(info) return self.db.profile.BarIndicators[i].Castbar.level end
						},
						color = {
							name = "Color",
							desc = "Select color",
							order = 7,
							type = "color",
							get = function(info)
								local t = self.db.profile.BarIndicators[i].Castbar.color
								return t.r, t.g, t.b, t.a
							end,
							set = function(info, r, g, b, a)
								local t = self.db.profile.BarIndicators[i].Castbar.color
								t.r, t.g, t.b, t.a = r, g, b, a
							end,
						},
						staticcolor = {
							name = "Static Color",
							desc = "Enables / disables static color",
							order = 8,
							type = "toggle",
							set = function(info,val) self.db.profile.BarIndicators[i].Castbar.staticcolor = val end,
							get = function(info) return self.db.profile.BarIndicators[i].Castbar.staticcolor end
						},
					},
				},
				DurationText = {
					name = "DurationText",
					order = 3,
					type = "group",
					disabled = false,
					args = {
					},
				},
				SpellText = {
					name = "SpellText",
					order = 4,
					type = "group",
					disabled = false,
					args = {
					},
				},
				SpellIcon = {
					name = "SpellIcon",
					order = 5,
					type = "group",
					disabled = false,
					args = {
					},
				},
			},
		}
	end
	
end

	CursorCastbar.Options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	CursorCastbar.Options.args.profile.order = -2
	
	return CursorCastbar.Options
end


local function get8coords(l,r,t,b,rota)
	
	rota = tonumber(rota)
	
	if rota == 90 then
		return l, b, r, b, l, t, r, t
	elseif rota == 180 then
		return r, b, r, t, l, b, l, t
	elseif rota == 270 then
		return r, t, l, t, r, b, l, b
	else
		return l, t, l, b, r, t, r, b
	end
	
end

do	--Create Frames

	local f = CreateFrame("Frame", "CursorCastbarParse", UIParent)
	f:SetFrameStrata("Background")
	f:ClearAllPoints()
	f:SetPoint("BOTTOM", UIParent, "TOP")
--	f:Show()
	local f = CreateFrame("Frame", "CursorCastbarMain", UIParent)
	f:SetFrameStrata("DIALOG")
	f:SetWidth(50)
	f:SetHeight(50)
	f:ClearAllPoints()
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	f:Show()
	
	local flevel = _G["CursorCastbarMain"]:GetFrameLevel()
	
	for i = 1,#frames do
		local f1 = CreateFrame("Frame", "CursorCastbarMain"..i, f)
		f1:SetWidth(50)
		f1:SetHeight(50)
		f1:ClearAllPoints()
		f1:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, 0)
		f1:Show()
		f1:SetFrameLevel(flevel + frames[i]["levelbonus"])
		f1.Name = frames[i].Name
	end
	
	local f10 = CreateFrame("Frame", "CursorCastbarDotIndicatorMain", f) 
	f10:SetWidth(50)
	f10:SetHeight(50)
	f10:Show()
	f10:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, 0)
	f10:SetFrameLevel(flevel + 0)
	f10.Name = "DotIndicatorMain"
	
	local f11 = CreateFrame("Frame", "CursorCastbarBarIndicatorMain", f) 
	f11:SetWidth(50)
	f11:SetHeight(50)
	f11:Show()
	f11:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, 0)
	f11:SetFrameLevel(flevel + 0)
	f11.Name = "BarIndicatorMain"
	
end

do	--Frame / child config

	CursorCastbar.Frames = {
		Bars = {},
		DotIndicators = {},
		BarIndicators = {},
	}
	
	for i = 1, #frames do
		CursorCastbar.Frames.Bars[i] = {
			Reverse = false,
			Text = frames[i].Fontstring or nil,
			IsChannel = false,
			StartTime = 0,
			EndTime = 0,
			SpellName = "SpellName",
			Icon = "",
			Type = "",
		}
	end
	
	for i = 1,8 do
		CursorCastbar.Frames.DotIndicators[i] = {
			Visible = false,
			EndTime = 0,
			NextBlink = 0,
			Name = "",
		}
		CursorCastbar.Frames.BarIndicators[i] = {
			Reverse = false,
			Text = true,
			IsChannel = false,
			StartTime = 0,
			EndTime = 0,
			SpellName = "SpellName",
			Icon = ""
		}
	end
	
end


do	--Frame Script Handling
	
	CursorCastbarParse:SetScript("OnEvent", function(self, event, ...)
--	CursorCastbar:SetScript("OnEvent", function(self, event, ...)
		if CursorCastbar[event]	then
			CursorCastbar[event](nil, self, event, ...)
		else
			CursorCastbar:OnEvent(self, event, ...)
		end
	end)
	
end


function CursorCastbar:OnEvent(self, event, ...)	--Collective event handler for all events without a unique function
	
	print("|cff4d4dff"..event.."|r", ...)
	local arg1, arg2, arg3, arg4, arg5 = ...
	local CurrentTime = GetTime()*1000
	
	if event == "PLAYER_TARGET_CHANGED" then	--arg1: 'up if you click the target directly, down if you press Escape to clear the target selection, LeftButton if you select the target using static frames in the UI, nil if the target moves out of range and is lost.'
		CursorCastbar:EndBar(4, event, nil, true) 
		if UnitExists("target") then
			if UnitName("target") and UnitGUID("target") ~= playerGUID then--~= UnitName("player") then
				local spellName, spellRank, displayName, texture, startTime, endTime = UnitCastingInfo("target")
				if spellName then
					CursorCastbar:StartBar(4, "default", false, false, startTime, endTime, spellName, texture) 
				else
					spellName, spellRank, displayName, texture, startTime, endTime = UnitChannelInfo("target") 
					if spellName then
						CursorCastbar:StartBar(4, "default", true, true, startTime, endTime, spellName, texture) 
					end
				end
			end
			CursorCastbar:CheckAuras(false, "target", event, CurrentTime)
		end
		
	elseif event == "SPELL_UPDATE_COOLDOWN"	--When a spell that has a cooldown is triggered it gets fired twice in quick succession and then again a few milliseconds later.
		or event == "SPELL_UPDATE_USABLE"	--This event is fired when a spell becomes useable or unusable. ATTENTION: Can have various quirky reasons to be fired!
		or event == "ACTIONBAR_UPDATE_COOLDOWN"	--arg1: 'if the cooldown is starting, the mouse button used to click the button. Known values: "leftButton" // if the cooldown is stopping or you are logging into a new zone, this is nil'
		then
			if not playerClass or playerClass == nil then
				playerClass = select(2,UnitClass("player"))
			end
			local start, duration = GetSpellCooldown(CursorCastbarGCSpellIDs[playerClass])
			local startTime = start*1000
			local effduration = duration*1000
			if effduration > 0 then CursorCastbarGC = effduration end
			
			CursorCastbar:StartBar(2, "default", true, false, startTime, startTime + CursorCastbarGC, "Global Cooldown", nil)
			
			
		--	print("|cff4d4dff"..event.."|r")
			
			CursorCastbar:CheckCooldowns(event, CurrentTime)
			
	elseif event == "MIRROR_TIMER_START" then	--Fired when some sort of timer starts. - arg1: 'timer ( for ex. "BREATH" )' - arg2: 'value ( start-time in ms, for ex. 180000 )' - arg3: 'maxvalue ( max-time in ms, for ex. 180000 )' - arg4: 'scale ( time added per second in seconds, for ex. -1 )' - arg5: 'paused' - arg6: 'label ( for ex. "Breath" )'
			local timer, value, maxvalue, scale, paused, label = ...
			if scale == -1 then
				local startTime = CurrentTime - (maxvalue-value)
				local endTime = CurrentTime + value
				activemirrorbar = timer
				CursorCastbar:StartBar(3, "default", true, true, startTime, endTime, label, MirrorbarIcons[timer] or "")
			elseif scale > 0 then
				local startTime = CurrentTime - (value / scale)
				local endTime = CurrentTime + ((maxvalue - value) / scale)
				activemirrorbar = timer
				CursorCastbar:StartBar(3, "default", false, false, startTime, endTime, label, MirrorbarIcons[timer] or "")
			end
	
	elseif event == "MIRROR_TIMER_STOP" then	--arg1: 'timer ( for ex. "BREATH" )'
			CursorCastbar:EndBar(3, event, nil, true)		
	
	elseif event == "UNIT_POWER" then
		local unitId, resource = ...
		if unit == 'player' then
			if UnitMana("player") < CursorCastbarCurrentMana then
				CursorCastbarCurrentMana = UnitMana("player")
				CursorCastbar:StartBar(5, "default", true, false, (GetTime()*1000), (GetTime()*1000)+(5000), "5 Sec", "")
			end
		end		
	
	elseif event == "UPDATE_MOUSEOVER_UNIT" then
		CursorCastbar:RefreshMOBuff(event, CurrentTime)
	
	elseif event == "CURSOR_UPDATE" then
		CursorCastbar:RefreshMOBuff(event, CurrentTime)
	
	elseif event == "UNIT_AURA" then
		local arg1 = ...
		if arg1 ~= "mouseover" and arg1 ~= "player" then return end
		if arg1 == "mouseover" then
			CursorCastbar:RefreshMOBuff(event, CurrentTime)
		elseif arg1 == "player" then
			local foodlocal = foodlocal or GetSpellInfo(433)
			local foodicon = foodicon or select(3, GetSpellInfo(433))
			local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3 = UnitBuff("player", foodlocal)
			
			if name and foodicon == icon then
				CursorCastbar:StartBar(1, "default", false, true, (expirationTime-duration)*1000, expirationTime*1000, spellName, icon)
				iseating = true
			elseif iseating == true then
				CursorCastbar:EndBar(1, eventtype, 0)
				iseating = false
			end
		end
	
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		CursorCastbar:CheckAllIndicators()
		
	elseif arg1 == "player" or arg1 == "target" then
	
		 if event == "UNIT_SPELLCAST_SUCCEEDED" then
			if arg1 == "target" and UnitGUID("target") ~= playerGUID then
				if arg5 ~= 75 and CursorCastbar.Frames.Bars[4].IsChannel == false then
					CursorCastbar:EndBar(4, event, arg4)
				end
			else
				if arg5 ~= 75 and CursorCastbar.Frames.Bars[1].IsChannel == false then
					CursorCastbar:EndBar(1, event, arg4)
				end
			end
		elseif event == "UNIT_SPELLCAST_CHANNEL_START"
			or event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
			local spellName, spellRank, displayName, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(arg1)
			if spellName then		
				if arg1 == "target" and UnitGUID("target") ~= playerGUID then
					CursorCastbar:StartBar(4, "default", true, true, startTime, endTime, spellName, texture)
				else
					CursorCastbar:CastLatency("start",arg4)
					CursorCastbar:StartBar(1, "default", true, true, startTime, endTime, spellName, texture, arg4)
				end
			end
		
		elseif event == "UNIT_SPELLCAST_CHANNEL_STOP"  then
			if arg1 == "target" and UnitGUID("target") ~= playerGUID then
				CursorCastbar:EndBar(4, event, arg4)
			else
				CursorCastbar:EndBar(1, event, arg4)
			end
		
		elseif event == "UNIT_SPELLCAST_DELAYED"  then
			local spellName, spellRank, displayName, texture, startTime, endTime, isTradeSkill = UnitCastingInfo(arg1)
			if arg1 == "target" and UnitGUID("target") ~= playerGUID then
				CursorCastbar:StartBar(4, "default", false, false, startTime, endTime, spellName, texture)
			else
				CursorCastbar:StartBar(1, "default", false, false, startTime, endTime, spellName, texture, entry)
			end
		
		elseif event == "UNIT_SPELLCAST_FAILED"
			or event == "UNIT_SPELLCAST_INTERRUPTED" then
			if arg1 == "target" and UnitGUID("target") ~= playerGUID then
				CursorCastbar:EndBar(4, event, arg4)
			else
				if arg2 == CursorCastbar.Frames.Bars[1].SpellName then
					CursorCastbar:EndBar(1, event, arg4)
					CursorCastbar:EndBar(2, event, nil, true)
				end
			end
		
		elseif event == "UNIT_SPELLCAST_SENT"  then
			if CursorCastbar.Frames.Bars[1].EndTime == 0 then				
			end
			CursorCastbar:CastLatency("sent",arg5)
		
		elseif event == "UNIT_SPELLCAST_START"  then
			local spellName, spellRank, displayName, texture, startTime, endTime, isTradeSkill = UnitCastingInfo(arg1)
			if arg1 == "target" and UnitGUID("target") ~= playerGUID then
				CursorCastbar:StartBar(4, "default", false, false, startTime, endTime, arg2, texture) 
			else
				CursorCastbar:CastLatency("start",arg4)
				CursorCastbar:StartBar(1, "default", false, false, startTime, endTime, arg2, texture, arg4)
			end
		
		elseif event == "UNIT_SPELLCAST_STOP"  then
			if arg1 == "target" and UnitGUID("target") ~= playerGUID then
				if CursorCastbar.Frames.Bars[4].IsChannel == false then
					if arg2 == CursorCastbar.Frames.Bars[4].SpellName then
						CursorCastbar:EndBar(4, event, arg4) 
					end
				end
			else
				if CursorCastbar.Frames.Bars[1].IsChannel == false then
					if arg2 == CursorCastbar.Frames.Bars[1].SpellName then
						CursorCastbar:EndBar(1, event, arg4) 
					end
				end
			end
		
		end
		
	end
	
end

function CursorCastbar:CreateEmptySpellList()
	CursorCastbar.SpellList = {
		BarIndicators = {},
		DotIndicators = {},
	}
	--create empty subfolders
	for i=1,8 do
		CursorCastbar.SpellList.BarIndicators[i] = {}
		CursorCastbar.SpellList.DotIndicators[i] = {}
	end
end

function CursorCastbar:CreateSpellList()

	CursorCastbar:CreateEmptySpellList()

	local t	
	for i=1,8 do
		--SpellList for BarIndicators
		t = CursorCastbar.SpellList.BarIndicators[i]
		for tValue in string.gmatch(self.db.profile.BarIndicators[i].Spells, "[^\n\r;][%w%s%p:][^\n\r;]+") do	--"[^;][%w%s%p:][^;]+") do
			if tValue and tValue ~= "" then
				if not t[tValue] then
					t[tValue] = true
				--	table.insert(t.Spells, tValue)
				end
			end
		end
		
		--SpellList for DotIndicators
		t = CursorCastbar.SpellList.DotIndicators[i]
		for tValue in string.gmatch(self.db.profile.DotIndicators[i].Spells, "[^\n\r;][%w%s%p:][^\n\r;]+") do	--"[^;][%w%s%p:][^;]+") do
			if tValue and tValue ~= "" then
				if not t[tValue] then
					t[tValue] = true
				--	table.insert(t.Spells, tValue)
				end
			end
		end
	end
	
	spelllistcreated = true
	
end

-- Check for all player buffs
--/run CursorCastbar:CheckAuras("TEST", GetTime()*1000)
function CursorCastbar:CheckAuras(all, target, event, CurrentTime)
	for i=1,8 do
		if self.db.profile.BarIndicators.enabled then
			local db = self.db.profile.BarIndicators[i]
			if db.enabled and db.Type == "Aura" and (db.Target == target or all == true) then
				if UnitExists(db.Target) then
				--	print("CCB: CheckAuras_Bar - "..i)
					local t = CursorCastbar.SpellList.BarIndicators[i]
					for s,v in pairs(t) do
						local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3 = UnitAura(db.Target, s, nil, db.Filter)
						if name then
						--	print("CCB: CA - StartBar "..i.."  >"..name.."<")
							CursorCastbar:StartBarIndicator(i, 5000, false, false, (expirationTime - duration)*1000, expirationTime*1000, name, icon)
							break
						end
					end
				end
			end
		end
		if self.db.profile.DotIndicators.enabled then
			local db = self.db.profile.DotIndicators[i]
			if db.enabled and db.Type == "Aura" and (db.Target == target or all == true) then
				if UnitExists(db.Target) then
				--	print("CCB: CheckAuras_Dot - "..i)
					local t = CursorCastbar.SpellList.DotIndicators[i]
					local visible, endtime = false, -1
					for s,v in pairs(t) do
						local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3 = UnitAura(db.Target, s, nil, db.Filter)
						if name then
						--	print("CCB: CA - StartBar "..i.."  >"..name.."<")
							visible = true
							endTime = expirationTime*1000
							break
						end
					end
					if db.invert == true then
						--endtime = -1
						visible = not visible
					end
					CursorCastbar.Frames.DotIndicators[i].Visible = visible
					CursorCastbar.Frames.DotIndicators[i].EndTime = endtime	--expirationTime*1000
					CursorCastbar.Frames.DotIndicators[i].NextBlink = CurrentTime + 0
				end
			end
		end
	end
end

-- Check for Cooldowns
function CursorCastbar:CheckCooldowns(event, CurrentTime)
	if not spelllistcreated then CursorCastbar:CreateSpellList() end
	for i=1,8 do
		if self.db.profile.BarIndicators.enabled then
			local db = self.db.profile.BarIndicators[i]
			if db.enabled and db.Type == "Cooldown" then
				local t = CursorCastbar.SpellList.BarIndicators[i]
				for s,v in pairs(t) do--[[
					local start, duration, enabled = GetSpellCooldown(s)
					if name then
						CursorCastbar.Frames.BarIndicators[i].Visible = visible
						CursorCastbar.Frames.BarIndicators[i].EndTime = expirationTime
						CursorCastbar.Frames.BarIndicators[i].NextBlink = CurrentTime + 0
						break
					end]]
				end
			end
		end
		if self.db.profile.DotIndicators.enabled then
			local db = self.db.profile.DotIndicators[i]
			if db.enabled and db.Type == "Cooldown" then
				local t = CursorCastbar.SpellList.DotIndicators[i]
				--debug
				print(t)
				
				for s,v in pairs(t) do
					local start, duration, enabled = GetSpellCooldown(s)
					
					if tonumber(start) then				
						local visible, endtime = false, -1
						
						if db.invert then
							if duration <= 1.5 then
								visible = true
							else
								endtime = start*1000 + duration*1000
							end
						else
							if duration > 1.5 then
								visible = true
								endtime = start*1000 + duration*1000
							end
						end
					
						CursorCastbar.Frames.DotIndicators[i].Visible = visible
						CursorCastbar.Frames.DotIndicators[i].EndTime = endtime
						if CurrentTime then CursorCastbar.Frames.DotIndicators[i].NextBlink = CurrentTime + 0 end
						break
					end
				end
			end
		end
	end
end

-- Check Mouseover for Buff
function CursorCastbar:RefreshMOBuff(event, CurrentTime)	
	if not spelllistcreated then CursorCastbar:CreateSpellList() end
	
	mouseoverGUID = UnitGUID("mouseover")
	
	if mouseoverGUID == nil then	--UnitExists("mouseover") == nil then
		for i=1,8 do
			if self.db.profile.BarIndicators[i].Target == "mouseover" then
				CursorCastbar:EndBarIndicator(i, "RefreshMOBuff")
			end
		end
		return
	else
		hasmouseover = true
		--mouseoverGUID = UnitGUID("mouseover")
		--[=[
		for i=1,8 do
			t = CursorCastbar.SpellList.BarIndicator.Mouseover[i]
			enabled = true
			for s=1,#t.Spells do
				if enabled and t.Filter ~= "" then
					local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3 = UnitAura("mouseover", t.Spells[s], nil, t.Filter)
					if name then
					--	print("CCB: MO - StartBar "..i.."  >"..name.."<")
						CursorCastbar:StartBar(3, "default", false, false, (expirationTime - duration)*1000, expirationTime*1000, name, icon)
					end
				end
			end
		end
		]=]
		for i=1,8 do
			if self.db.profile.BarIndicators.enabled == true then
				local db = self.db.profile.BarIndicators[i]
				if db.enabled and db.Type == "Aura" and db.Target == "mouseover" then
					CursorCastbar:EndBarIndicator(i, "RefreshMOBuff")
					local t = CursorCastbar.SpellList.BarIndicators[i]
					for s,v in pairs(t) do
						local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3 = UnitAura("mouseover", s, nil, db.Filter)
						if name then
						--	print("CCB: MO - StartBar "..i.."  >"..name.."<")
							CursorCastbar:StartBarIndicator(i, 5000, false, false, (expirationTime - duration)*1000, expirationTime*1000, name, icon)
							break
						end
					end
				end
			end
			if self.db.profile.DotIndicators.enabled == true then
				local db = self.db.profile.DotIndicators[i]
				if db.enabled and db.Type == "Aura" and db.Target == "mouseover" then
					local t = CursorCastbar.SpellList.DotIndicators[i]
					for s,v in pairs(t) do
						local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3 = UnitAura("mouseover", s, nil, db.Filter)
						if name then
						--	print("CCB: MO - StartBar "..i.."  >"..name.."<")
							CursorCastbar.Frames.DotIndicators[i].Visible = visible
							CursorCastbar.Frames.DotIndicators[i].EndTime = expirationTime*1000
							CursorCastbar.Frames.DotIndicators[i].NextBlink = CurrentTime + 0
							break
						end
					end
				end
			end
		end
	end
end


-- Cursor Position and Scale depending on passed frame
function CursorCastbar:GetCursorPosition(frame)
	local scale = UIParent:GetEffectiveScale()
	local framescale = frame:GetScale()
	local x, y = GetCursorPosition()
	x = (x / scale / framescale) - frame:GetWidth() / 2
	y = (y / scale / framescale) - frame:GetHeight() / 2
	
	return x,y
end


function CursorCastbar:UpdateBars(CurrentTime)
	if BarUpdateInProgress then return end
	BarUpdateInProgress = true
	
	for i = 1,#frames do
		local optstring = frames[i].Name
		if self.db.profile[optstring].enabled then
			local BarFrame = _G["CursorCastbarMain"..i.."Bar"]
			
			if BarFrame and BarFrame:IsVisible() then
				local Fontstring = _G["CursorCastbarMain"..i.."Fontstring"]
				local LatencyBar = _G["CursorCastbarMain"..i.."Latency"]
				
				if CursorCastbar.Frames.Bars[i].Type == "static" then
					local per = CursorCastbar.Frames.Bars[i].Percent
					if self.db.profile[optstring].Castbar.staticcolor then
						local ctable = self.db.profile[optstring].Castbar.color
						local red, green, blue, alpha = ctable.r, ctable.g, ctable.b, self.db.profile[optstring].Castbar.alpha
						BarFrame:SetVertexColor(red, green, blue, alpha)	--(self.db.profile[optstring].Castbar.color.r, self.db.profile[optstring].Castbar.color.g, self.db.profile[optstring].Castbar.color.b, self.db.profile[optstring].Castbar.alpha)
						if Fontstring then
							Fontstring:SetTextColor(red, green, blue, alpha)
						end
					else
						local alpha = self.db.profile[optstring].Castbar.alpha
						if self.db.profile[optstring].Castbar.direction == "Counter clockwise" then	--CursorCastbar.Frames.Bars[i].Reverse then
							local per = 100 - per
							BarFrame:SetVertexColor(1 - per/100 + 0.5, (per/100), 0, alpha)
							if Fontstring then
								Fontstring:SetTextColor(1 - per/100 + 0.5, (per/100), 0, alpha)
							end
						else
							BarFrame:SetVertexColor((per/100) + 0.25, 1 - per/100 , 0, alpha)
							if Fontstring then
								Fontstring:SetTextColor((per/100) + 0.25, 1 - per/100 , 0, alpha)
							end
						end
					end
					
					if CursorCastbar.Frames.Bars[i].IsChannel == true then
						per = 100 - per
					end
					
					local row = (math.floor((per / 1.5625)/8)) 
					local col = (math.floor((per - (row * 1.5625 * 8)) / 1.5625))

					-- TexCoord and Latency >>
					local tx1, tx2, ty1, ty2
					local tex = CursorCastbarBarTexture[self.db.profile[optstring].Castbar.texture]
					
					if self.db.profile[optstring].Castbar.direction == "Counter clockwise" then
						tx1, tx2, ty1, ty2 = (col * 0.125) + tex.x1Mod, (col  * 0.125) + tex.x2Mod, (row * 0.125) + tex.y1Mod, (row * 0.125) + tex.y2Mod
					else
						tx1, tx2, ty2, ty1 = (col * 0.125) + tex.x1Mod, (col  * 0.125) + tex.x2Mod, (row * 0.125) + tex.y1Mod, (row * 0.125) + tex.y2Mod
					end
					local l, r, t, b = tx1, tx2, ty1, ty2	--0,1,0,1	--0, 0.125, 0, 0.125 
					BarFrame:SetTexCoord(get8coords(l,r,t,b,self.db.profile[optstring].Castbar.rotation or 0))
					
					-- TexCoord and Latency <<
					
					if Fontstring then
						local t = CursorCastbar.Frames.Bars[i]
						Fontstring:SetText(""..t.StartTime.." / "..t.EndTime.."  "..CursorCastbar.Frames.Bars[i].Percent.."%")
					end
					
				else
					
					if CursorCastbar.Frames.Bars[i].EndTime > CurrentTime then
						local per = (CursorCastbar.Frames.Bars[i].EndTime - CurrentTime) / ((CursorCastbar.Frames.Bars[i].EndTime - CursorCastbar.Frames.Bars[i].StartTime) / 100)
						if per > 0 then
							if not self.db.profile[optstring].Castbar then --[[print("CCB fail at "..i)]] return end
							--Coloring the frames
							if self.db.profile[optstring].Castbar.staticcolor then
								local ctable = self.db.profile[optstring].Castbar.color
								local red, green, blue, alpha = ctable.r, ctable.g, ctable.b, self.db.profile[optstring].Castbar.alpha
								if i == 3 then
									local t = MirrorTimerColors[activemirrorbar]
									if t then
										red, green, blue = t.r, t.g, t.b
									end
								end
								BarFrame:SetVertexColor(red, green, blue, alpha)	--(self.db.profile[optstring].Castbar.color.r, self.db.profile[optstring].Castbar.color.g, self.db.profile[optstring].Castbar.color.b, self.db.profile[optstring].Castbar.alpha)
								if Fontstring then
									Fontstring:SetTextColor(red, green, blue, alpha)
								end
							else
								local alpha = self.db.profile[optstring].Castbar.alpha
								if self.db.profile[optstring].Castbar.direction == "Counter clockwise" then	--CursorCastbar.Frames.Bars[i].Reverse then
									local per = 100 - per
									BarFrame:SetVertexColor(1 - per/100 + 0.5, (per/100), 0, alpha)
									if Fontstring then
										Fontstring:SetTextColor(1 - per/100 + 0.5, (per/100), 0, alpha)
									end
								else
									BarFrame:SetVertexColor((per/100) + 0.25, 1 - per/100 , 0, alpha)
									if Fontstring then
										Fontstring:SetTextColor((per/100) + 0.25, 1 - per/100 , 0, alpha)
									end
								end
							end
							
							if CursorCastbar.Frames.Bars[i].IsChannel == true then
								per = 100 - per
							end
							local row = (math.floor((per / 1.5625)/8)) 
							local col = (math.floor((per - (row * 1.5625 * 8)) / 1.5625))

							-- TexCoord and Latency >>
								local tx1, tx2, ty1, ty2
								local tex = CursorCastbarBarTexture[self.db.profile[optstring].Castbar.texture]
								
								if self.db.profile[optstring].Castbar.direction == "Counter clockwise" then
									tx1, tx2, ty1, ty2 = (col * 0.125) + tex.x1Mod, (col  * 0.125) + tex.x2Mod, (row * 0.125) + tex.y1Mod, (row * 0.125) + tex.y2Mod
								else
									tx1, tx2, ty2, ty1 = (col * 0.125) + tex.x1Mod, (col  * 0.125) + tex.x2Mod, (row * 0.125) + tex.y1Mod, (row * 0.125) + tex.y2Mod
								end
								local l, r, t, b = tx1, tx2, ty1, ty2	--0,1,0,1	--0, 0.125, 0, 0.125 
								BarFrame:SetTexCoord(get8coords(l,r,t,b,self.db.profile[optstring].Castbar.rotation or 0))
								
								if self.db.profile[optstring].Latency and not tex.nolatency and LatencyBar and LatencyBar:IsVisible() then
									if self.db.profile[optstring].Latency.enabled and self.db.profile[optstring].Castbar.enabled then
										local --[[down, up, latencyHome,]] latency = CursorCastbar_CastLatency or select(4, GetNetStats())
										local casttime = (CursorCastbar.Frames.Bars[i].EndTime - CursorCastbar.Frames.Bars[i].StartTime)
										local per
										if latency >= casttime then
											per = 0
										else
											per = 100 - math.floor((latency) / (casttime/100))
										end
										local row = (math.floor((per / 1.5625)/8)) 
										local col = (math.floor((per - (row * 1.5625 * 8)) / 1.5625))						

										local tx1, tx2, ty1, ty2
										if self.db.profile[optstring].Castbar.direction == "Counter clockwise" then
											tx1, tx2, ty2, ty1 = (col * 0.125) + tex.x1Mod, (col  * 0.125) + tex.x2Mod, (row * 0.125) + tex.y1Mod, (row * 0.125) + tex.y2Mod
										else
											tx1, tx2, ty1, ty2 = (col * 0.125) + tex.x1Mod, (col  * 0.125) + tex.x2Mod, (row * 0.125) + tex.y1Mod, (row * 0.125) + tex.y2Mod
										end
										LatencyBar:SetTexCoord(get8coords(tx1, tx2, ty1, ty2, self.db.profile[optstring].Castbar.rotation or 0))
										LatencyBar:SetVertexColor(1, 1, 1, self.db.profile[optstring].Latency.alpha)
									else
										LatencyBar:SetTexCoord(0,0,0,0)
										LatencyBar:SetVertexColor(1,1,1,0)
									end
								end
							-- TexCoord and Latency <<
							
							if i == 1 or i == 4 then
								if Fontstring then
									Fontstring:SetText(string.format("%.2f", ((CursorCastbar.Frames.Bars[i].EndTime - CurrentTime)/1000)))
								end
							end
						else
							BarFrame:SetTexCoord(0, 0, 0, 0)
							BarFrame:SetVertexColor(1, 1, 1, 0)
							if Fontstring then
								Fontstring:SetText("")
								Fontstring:SetTextColor(1, 1, 1, 0)
							end
							CursorCastbar.Frames.Bars[i].Icon = "" 

							if LatencyBar then
								LatencyBar:SetTexCoord(0,0,0,0)
								LatencyBar:SetVertexColor(1, 1, 1, 0)
							end
						end
					else
						CursorCastbar:EndBar(i, "OnUpdate", CursorCastbar.Frames.Bars[i].Entry, true)
						BarFrame:SetTexCoord(0, 0, 0, 0)
						BarFrame:SetVertexColor(1, 1, 1, 0)
						if Fontstring then
							Fontstring:SetText("")
							Fontstring:SetTextColor(1, 1, 1, 0)
						end
						
						if LatencyBar then
							LatencyBar:SetTexCoord(0,0,0,0)
							LatencyBar:SetVertexColor(1, 1, 1, 0)
						end
					end
					
				end
			end
		end
	end
	
	BarUpdateInProgress = false
end


function CursorCastbar:UpdateDotIndicators(CurrentTime)
	if DotIndicatorUpdateInProgress then return end
	DotIndicatorUpdateInProgress = true
		
	--	/run local nb,e=GetTime(),GetTime()+10 for i=1,8 do CursorCastbar.Frames.DotIndicators[i]={Visible=true,EndTime=e,NextBlink=nb,Name="TestName"..i,} end
--Indicators
	for i=1,8 do
		if self.db.profile.DotIndicators[i].enabled then
			local Indicator = _G["CursorCastbarDotIndicator"..i]
			
			if Indicator then
				if CursorCastbar.Frames.DotIndicators[i].EndTime > 0 and CursorCastbar.Frames.DotIndicators[i].EndTime < CurrentTime then
					CursorCastbar.Frames.DotIndicators[i].EndTime = 0
					CursorCastbar.Frames.DotIndicators[i].Visible = not CursorCastbar.Frames.DotIndicators[i].Visible
				end
				if CursorCastbar.Frames.DotIndicators[i].Visible then
					if self.db.profile.DotIndicators[i].blink then
						if CursorCastbar.Frames.DotIndicators[i].NextBlink <= CurrentTime then
							CursorCastbar.Frames.DotIndicators[i].NextBlink = CurrentTime + (CursorCastbar.db.profile.DotIndicators[i].blinkvalue *  1000)
							if Indicator:IsVisible() then
								Indicator:Hide()
							else
								Indicator:Show()
							end
						end
					else
						if not Indicator:IsVisible() then
							Indicator:Show()
						end
					end
				else
					if Indicator:IsVisible() then
						Indicator:Hide()
					end
				end
			end
		end
	end
	
	DotIndicatorUpdateInProgress = false
end

--/run local t=GetTime()*1000; local tbl={Visible=true,StartTime=t,EndTime=t+5000}; CursorCastbar.Frames.BarIndicators[1]=tbl
function CursorCastbar:UpdateBarIndicators(CurrentTime)
	if BarIndicatorUpdateInProgress then return end
	BarIndicatorUpdateInProgress = true
	
	for i=1,8 do
		local opt = self.db.profile.BarIndicators[i]
		if opt.enabled then
			local BarFrame = _G["CursorCastbarBarIndicator"..i]
			local Fontstring = _G["CursorCastbarBarIndicator"..i.."Fontstring"]
		--	if not Fontstring then print("CCB fail at "..i) return nil end
		--	/run CursorCastbar.Frames.Bars[1].StartTime=GetTime(); CursorCastbar.Frames.Bars[1].EndTime = CursorCastbar.Frames.Bars[1].StartTime + 10
			----------------------------------------------------------------------------------------------------------------------------------------------
			----------------------------------------------------------------------------------------------------------------------------------------------
			if BarFrame then
				if CursorCastbar.Frames.BarIndicators[i].EndTime > CurrentTime then
					local per = (CursorCastbar.Frames.BarIndicators[i].EndTime - CurrentTime) / ((CursorCastbar.Frames.BarIndicators[i].EndTime - CursorCastbar.Frames.BarIndicators[i].StartTime) / 100)
					if per > 0 then
						--if not self.db.profile[optstring].Castbar then --[[print("CCB fail at "..i)]] return end
						--Coloring the frames
						if opt.Castbar.staticcolor then
							local ctable = opt.Castbar.color
							local red, green, blue, alpha = ctable.r, ctable.g, ctable.b, ctable.a
							BarFrame:SetVertexColor(opt.Castbar.color.r, opt.Castbar.color.g, opt.Castbar.color.b, opt.Castbar.alpha)
							if Fontstring then
								Fontstring:SetTextColor(red, green, blue, alpha)
							end
						else
							local alpha = opt.Castbar.alpha
							if opt.Castbar.direction == "Counter clockwise" then	--CursorCastbar.Frames.Bars[i].Reverse then
								local per = 100 - per
								BarFrame:SetVertexColor(1 - per/100 + 0.5, (per/100), 0, alpha)
								if Fontstring then
									Fontstring:SetTextColor(1 - per/100 + 0.5, (per/100), 0, alpha)
								end
							else
								BarFrame:SetVertexColor((per/100) + 0.25, 1 - per/100 , 0, alpha)
								if Fontstring then
									Fontstring:SetTextColor((per/100) + 0.25, 1 - per/100 , 0, alpha)
								end
							end
						end
						
						local row = (math.floor((per / 1.5625)/8)) 
						local col = (math.floor((per - (row * 1.5625 * 8)) / 1.5625))

						-- TexCoord and Latency >>
							local tx1, tx2, ty1, ty2
							local tex = CursorCastbarBarTexture[opt.Castbar.texture]
							
							if opt.Castbar.direction == "Counter clockwise" then
								tx1, tx2, ty1, ty2 = (col * 0.125) + tex.x1Mod, (col  * 0.125) + tex.x2Mod, (row * 0.125) + tex.y1Mod, (row * 0.125) + tex.y2Mod
							else
								tx1, tx2, ty2, ty1 = (col * 0.125) + tex.x1Mod, (col  * 0.125) + tex.x2Mod, (row * 0.125) + tex.y1Mod, (row * 0.125) + tex.y2Mod
							end
							local l, r, t, b = tx1, tx2, ty1, ty2	--0,1,0,1	--0, 0.125, 0, 0.125 
							BarFrame:SetTexCoord(get8coords(l,r,t,b,opt.Castbar.rotation or 0))
						
						-- TexCoord and Latency <<
						
						
						--[[
						if i == 1 or i == 4 then
							if Fontstring then
								Fontstring:SetText(string.format("%.2f", ((CursorCastbar.Frames.BarIndicators[i].EndTime - CurrentTime)/1000)))
							end
						end
						]]
					else
						BarFrame:SetTexCoord(0, 0, 0, 0)
						BarFrame:SetVertexColor(1, 1, 1, 0)
						if Fontstring then
							Fontstring:SetText("")
							Fontstring:SetTextColor(1, 1, 1, 0)
						end
					end
				else
					BarFrame:SetTexCoord(0, 0, 0, 0)
					BarFrame:SetVertexColor(1, 1, 1, 0)
					if Fontstring then
						Fontstring:SetText("")
						Fontstring:SetTextColor(1, 1, 1, 0)
					end
				end
			end
		end
	end
	
	BarIndicatorUpdateInProgress = false
end

function CursorCastbar:UpdateModel()
	if ModelUpdateInProgress then return end
	ModelUpdateInProgress = true
	
	for i = 1,#frames do
		
	end
	
	ModelUpdateInProgress = false
end


local MainFrame = _G["CursorCastbarMain"]
local nextupdate, nexttimedupdate, timedupdatedelay = 200, 0, 100	--in milliseconds
-- OnUpdate / Castbar + Blink animation
function CursorCastbar:OnUpdate(frame, elapsed)	--Castbar and Indicator animation
	
	local CurrentTime = GetTime()*1000
	
--MainFrame

--Anchor to Cursor
	local x, y = CursorCastbar:GetCursorPosition(MainFrame)
	MainFrame:ClearAllPoints()
	MainFrame:SetPoint( "BOTTOMLEFT", UIParent, "BOTTOMLEFT", x+self.db.profile.global.ofsx, y+self.db.profile.global.ofsy )
	--MainFrame:SetFrameStrata(fstrata[self.db.profile.global.framestrata])
	--MainFrame:Raise()
	
--Check for OptionsMenu and preview animation
	if optionsvisible and self.db.profile.showpreview then
		CursorCastbar:UpdateVisuals(true)
	end	
	
	--[[if CurrentTime >= nexttimedupdate and not optionsvisible then
		nexttimedupdate = CurrentTime + timedupdatedelay
	--	print("CCB: TimedUpdate executed")
	--	CursorCastbar:RefreshMOBuff("OnUpdate")
	end]]
	
--Time next update and proceed OR return
	if CurrentTime >= nextupdate then
		nextupdate = CurrentTime + (tonumber(self.db.profile.global.delay) or timedupdatedelay)
	else
		return
	end
--Update mouseover unit
	if not optionsvisible then
		if hasmouseover then
			if not UnitExists("mouseover") then
				mouseoverGUID = nil
				for i=1,8 do
					if self.db.profile.BarIndicators[i].Target == "mouseover" then
						CursorCastbar:EndBarIndicator(i, "RefreshMOBuff")
					end
				end
			end
		end
	--	CursorCastbar:RefreshMOBuff("OnUpdate")
	end
	
--CastBars
	CursorCastbar:UpdateBars(CurrentTime)
	
--DotIndicators
	if self.db.profile.DotIndicators.enabled then
		CursorCastbar:UpdateDotIndicators(CurrentTime)
	end

--BarIndicators
	if self.db.profile.BarIndicators.enabled then
		CursorCastbar:UpdateBarIndicators(CurrentTime)
	end
	
	
end


function CursorCastbar:BUFF(unitid,spellName)
--	print("CCB_BUFF: "..unitid..": "..spellName)
	return UnitBuff(unitid,spellName)
end

function CursorCastbar:DEBUFF(unitid,spellName)
--	print("CCB_DEBUFF: "..unitid..": "..spellname)
	return UnitDebuff(unitid,spellName)
end

function CursorCastbar:CheckAura(auraType, target, spellId, spellName, loss, CurrentTime)
	if not spelllistcreated then CursorCastbar:CreateSpellList() end
	if not auraType or auraType==nil or (auraType~="BUFF" and auraType~="DEBUFF") then
	--	print("CCB_CheckAura: auraType==nil")
	--	print(spellName) print(target)
		return
	end
	
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3 = CursorCastbar[auraType](nil, target, spellName)
	if expirationTime then expirationTime = expirationTime*1000 end	--milliseconds
	if duration then duration = duration*1000 end	--milliseconds
	
	if loss then
		name, _, icon = GetSpellInfo(spellId or spellName) or spellName, nil, nil
		expirationTime = -1
		duration = 0
	end
	--	print(name)

	if name then
		for i=1,8 do
			local db = self.db.profile.BarIndicators[i]
			if db.enabled and db.Type == "Aura" and db.Target == target then
				local t = CursorCastbar.SpellList.BarIndicators[i]
				if t[name] then
					local visible = not loss
				--	print("CCB: Spell is in table Bar"..i)
					CursorCastbar.Frames.BarIndicators[i].Visible = visible
					CursorCastbar.Frames.BarIndicators[i].StartTime = expirationTime - duration
					CursorCastbar.Frames.BarIndicators[i].EndTime = expirationTime
				end
			end
			local db = self.db.profile.DotIndicators[i]
			if db.enabled and db.Type == "Aura" and db.Target == target then
				local t = CursorCastbar.SpellList.DotIndicators[i]
				if t[name] then
					local visible = not loss
					if db.invert then
						visible = loss
					end
				--	print("CCB: Spell is in table Dot"..i)
					CursorCastbar.Frames.DotIndicators[i].Visible = visible
					CursorCastbar.Frames.DotIndicators[i].EndTime = expirationTime
					CursorCastbar.Frames.DotIndicators[i].NextBlink = CurrentTime + 0
					CursorCastbar.Frames.DotIndicators[i].Icon = icon or "Interface\AddOns\CursorCastbar\DotTextures\Indicator"
				end
			end
		end
	end

end

function CursorCastbar:CheckAllIndicators()
	for i=1,8 do
		CursorCastbar:EndBarIndicator(i, "CheckAllIndicators")
		
		CursorCastbar.Frames.DotIndicators[i].Visible = false
		CursorCastbar.Frames.DotIndicators[i].EndTime = 0
		CursorCastbar.Frames.DotIndicators[i].NextBlink = 0
	end
	
	local CurrentTime = GetTime()*1000
	CursorCastbar:CheckCooldowns("CheckAllIndicators", CurrentTime)
	CursorCastbar:CheckAuras(true, nil, "CheckAllIndicators", CurrentTime)
	
	--[[
	local CurrentTime = GetTime()*1000
	for i=1,8 do
		if self.db.profile.BarIndicators.enabled == true then
			local db = self.db.profile.BarIndicators[i]
			if db.enabled and db.Type == "Aura" then
				CursorCastbar:EndBarIndicator(i, "RefreshMOBuff")
				local t = CursorCastbar.SpellList.BarIndicators[i]
				if db.Type == "Aura" then
					for s,v in pairs(t) do
						local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3 = UnitAura(db.Target, s, nil, db.Filter)
						if name then
						--	print("CCB: MO - StartBar "..i.."  >"..name.."<")
							CursorCastbar:StartBarIndicator(i, 5000, false, false, (expirationTime - duration)*1000, expirationTime*1000, name, icon)
							break
						end
					end
				elseif db.Type == "Cooldown" then
					
				end
			end
		end
		if self.db.profile.DotIndicators.enabled == true then
			local db = self.db.profile.DotIndicators[i]
			if db.enabled then
				local t = CursorCastbar.SpellList.DotIndicators[i]
				if db.Type == "Aura" then
					local visible, endtime = false, 0
					for s,v in pairs(t) do
						local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3 = UnitAura(db.Target, s, nil, db.Filter)
						if db.invert == false and name then
						--	print("CCB: MO - StartBar "..i.."  >"..name.."<")
							visible = true
							endTime = expirationTime*1000
							break
						end
					end
					if visible == false and db.invert == true then
						visible = true
						endtime = 0
					end
					CursorCastbar.Frames.DotIndicators[i].Visible = visible
					CursorCastbar.Frames.DotIndicators[i].EndTime = endtime	--expirationTime*1000
					CursorCastbar.Frames.DotIndicators[i].NextBlink = CurrentTime + 0
				elseif db.Type == "Cooldown" then
					local visible, endtime = false, 0
					for s,v in pairs(t) do
						local start, duration, enabled = GetSpellCooldown(s);
						if start > 2 then
							visible = true
							endtime = (start+duration)*1000
							break
						end
					end
					if visible == false and db.invert == true then
						visible = true
						endtime = 0
					end
					CursorCastbar.Frames.DotIndicators[i].Visible = visible
					CursorCastbar.Frames.DotIndicators[i].EndTime = endtime	--expirationTime*1000
					CursorCastbar.Frames.DotIndicators[i].NextBlink = CurrentTime + 0
				end
			end
		end
	end
	]]
end


--	local t = {}; for i=1,130748 do local name = GetSpellInfo(i) if name == "Essen" then t[i]=true end end CursorCastbarDB.foodtable = t
--	local t = {}; for i=1,130748 do local name = GetSpellInfo(i) if name == "Trinken" then t[i]=true end end CursorCastbarDB.drinktable = t
--	local t = {}; for i=1,130748 do local name = GetSpellInfo(i) if name == "Erfrischung" then t[i]=true end end CursorCastbarDB.refreshtable = t

local spellbufftable = {
	[46924] = true
}
local e_tbl = {
["SPELL_AURA_REMOVED"] = {loss = true},
["SPELL_AURA_BROKEN"] = {loss = true},
["SPELL_AURA_BROKEN_SPELL"] = {loss = true},
["SPELL_AURA_APPLIED"] = {loss = false},
["SPELL_AURA_REFRESH"] = {loss = false},
["SPELL_AURA_APPLIED_DOSE"] = {loss = false},
}
function CursorCastbar:COMBAT_LOG_EVENT_UNFILTERED(self, event, ...)
--	print("|cffff6d00COMBAT_LOG_EVENT_UNFILTERED|r")
--	print(...)
	local CurrentTime = GetTime()*1000
	local timestamp, eventtype, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2, spellId, spellName, spellSchool, auraType = ...
	
	if sourceGUID == UnitGUID("player") and spellbufftable[spellId] then
		if eventtype == "SPELL_AURA_APPLIED" then
			local spellName, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(spellId)
			local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3 = UnitBuff("player", spellName)
			CursorCastbar:StartBar(getbaridbyname["player"], "default", false, true, CurrentTime, expirationTime*1000, spellName, icon)
		elseif eventtype == "SPELL_AURA_REMOVED" then
			CursorCastbar:EndBar(getbaridbyname["player"], eventtype, 0)
		end
	end
	
	local t = e_tbl[eventtype]
	if t then
	--	print(eventtype, auraType, destName, spellName)
		if destGUID == playerGUID--[[UnitGUID("player")]] then
			CursorCastbar:CheckAura(auraType, "player", spellId, spellName, t.loss, CurrentTime)
		end
		if destGUID == UnitGUID("target") then
			CursorCastbar:CheckAura(auraType, "target", spellId, spellName, t.loss, CurrentTime)
		end
		if destGUID == UnitGUID("mouseover") then
			CursorCastbar:RefreshMOBuff("CLEU", CurrentTime)
			CursorCastbar:CheckAura(auraType, "mouseover", spellId, spellName, t.loss, CurrentTime)
		end
--	else print("e_tbl is not found for "..eventtype)
	end
	
end


function CursorCastbar:UNIT_POWER(self, event, unit, powerType)
	if unit ~= "player" or powerType ~= "ALTERNATE" then return end
	
	local power = UnitPower("player", ALTERNATE_POWER_INDEX)
	local maxpower = UnitPowerMax("player", ALTERNATE_POWER_INDEX)
	local per = shortenvalue(100 / maxpower * power)
	if maxpower == 0 then per = 0 end
	
	local name = select(10, UnitAlternatePowerInfo("player"))
	
	--print(event, name, power, maxpower, per)
	
--	CursorCastbar:StartBar(7, "static", false, true, power, maxpower, name, nil, 0, per)
	
	local t = {
		Type = "static",
		Reverse = false,
		IsChannel = true,
		StartTime = power,
		EndTime = maxpower,
		SpellName = name,
		Icon = nil,
		Entry = 0,
		Percent = per,
		Frame = nil,
	}
	CursorCastbar.Frames.Bars[getbaridbyname["alternate"]] = t
	
end

function CursorCastbar:UNIT_POWER_BAR_SHOW(self, event, unit, ...)
--	print("Event:", event, "| Unit:", unit, "| etc:", ...)
	if unit ~= "player" and arg1 ~= "vehicle" then return end
	local name = select(10, UnitAlternatePowerInfo(unit))
	if name then
		local power = UnitPower(unit, SPELL_POWER_ALTERNATE_POWER)
		local maxpower = UnitPowerMax(unit, SPELL_POWER_ALTERNATE_POWER)
		--print(event, name, power, maxpower, per)
		CursorCastbar:StartBar(getbaridbyname["alternate"], "static", false, true, power, maxpower, name, nil, 0, per)
	end
end

function CursorCastbar:UNIT_POWER_BAR_HIDE(self, event, unit, ...)
	--print("Event:", event, "| Unit:", unit, "| etc:", ...)
	if unit ~= "player" and arg1 ~= "vehicle" then return end
	CursorCastbar:EndBar(getbaridbyname["alternate"], event, 0, true)
end


function CursorCastbar:PLAYER_TARGET_CHANGED()
	CursorCastbar:EndBar(getbaridbyname["target"], event, nil, true) 
	if UnitExists("target") then
		if UnitName("target") and UnitGUID("target") ~= playerGUID then--~= UnitName("player") then
			local spellName, spellRank, displayName, texture, startTime, endTime = UnitCastingInfo("target")
			if spellName then
				CursorCastbar:StartBar(getbaridbyname["target"], "default", false, false, startTime, endTime, spellName, texture) 
			else
				spellName, spellRank, displayName, texture, startTime, endTime = UnitChannelInfo("target") 
				if spellName then
					CursorCastbar:StartBar(getbaridbyname["target"], "default", true, true, startTime, endTime, spellName, texture) 
				end
			end
		end
		CursorCastbar:CheckAuras(false, "target", event, CurrentTime)
	end
end

function CursorCastbar:SPELL_UPDATE_COOLDOWN()
	if not playerClass or playerClass == nil then
		playerClass = select(2,UnitClass("player"))
	end
	local start, duration = GetSpellCooldown(CursorCastbarGCSpellIDs[playerClass])
	local startTime = start*1000
	local effduration = duration*1000
	if effduration > 0 then CursorCastbarGC = effduration end
	
	CursorCastbar:StartBar(getbaridbyname["gcd"], "default", true, false, startTime, startTime + CursorCastbarGC, "Global Cooldown", nil)
	
--	print("|cff4d4dff"..event.."|r")
	
	CursorCastbar:CheckCooldowns(event, CurrentTime)
end

function CursorCastbar:MIRROR_TIMER_START(self, event, timer, value, maxvalue, scale, paused, label)
	local CurrentTime = GetTime()*1000
	if scale == -1 then
		local startTime = CurrentTime - (maxvalue-value)
		local endTime = CurrentTime + value
		activemirrorbar = timer
		CursorCastbar:StartBar(getbaridbyname["mirror"], "default", true, true, startTime, endTime, label, MirrorbarIcons[timer] or "")
	elseif scale > 0 then
		local startTime = CurrentTime - (value / scale)
		local endTime = CurrentTime + ((maxvalue - value) / scale)
		activemirrorbar = timer
		CursorCastbar:StartBar(getbaridbyname["mirror"], "default", false, false, startTime, endTime, label, MirrorbarIcons[timer] or "")
	end
end

function CursorCastbar:MIRROR_TIMER_STOP()
	CursorCastbar:EndBar(getbaridbyname["mirror"], event, nil, true)
end

function CursorCastbar:UPDATE_MOUSEOVER_UNIT()
	local CurrentTime = GetTime()*1000
	CursorCastbar:RefreshMOBuff(event, CurrentTime)
end

function CursorCastbar:CURSOR_UPDATE()
	local CurrentTime = GetTime()*1000
	CursorCastbar:RefreshMOBuff(event, CurrentTime)
end

function CursorCastbar:UNIT_AURA(self, event, arg1)
	if arg1 ~= "mouseover" and arg1 ~= "player" then return end
	if arg1 == "mouseover" then
		CursorCastbar:RefreshMOBuff(event, CurrentTime)
	elseif arg1 == "player" then
		local foodlocal = foodlocal or GetSpellInfo(433)
		local foodicon = foodicon or select(3, GetSpellInfo(433))
		local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3 = UnitBuff("player", foodlocal)
		
		if name and foodicon == icon then
			CursorCastbar:StartBar(arg1, "default", false, true, (expirationTime-duration)*1000, expirationTime*1000, spellName, icon)
			iseating = true
		elseif iseating == true then
			CursorCastbar:EndBar(arg1, eventtype, 0)
			iseating = false
		end
	end
end

function CursorCastbar:ZONE_CHANGED_NEW_AREA()
	CursorCastbar:CheckAllIndicators()
end

function CursorCastbar:UNIT_SPELLCAST_SUCCEEDED(self, event, arg1, arg2, arg3, arg4, arg5)
	if arg1 ~= "player" and arg1 ~= "vehicle" and arg1 ~= "target" then return end
	if arg1 == "target" and UnitGUID("target") ~= playerGUID then
		if arg5 ~= 75 and CursorCastbar.Frames.Bars[getbaridbyname[arg1]].IsChannel == false then
			CursorCastbar:EndBar(arg1, event, arg4)
		end
	else
		if arg5 ~= 75 and CursorCastbar.Frames.Bars[getbaridbyname[arg1]].IsChannel == false then
			CursorCastbar:EndBar(arg1, event, arg4)
		end
	end
end

function CursorCastbar:UNIT_SPELLCAST_CHANNEL_START(self, event, arg1, arg2, arg3, arg4, arg5)
	if arg1 ~= "player" and arg1 ~= "vehicle" and arg1 ~= "target" then return end
	local spellName, spellRank, displayName, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(arg1)
	if spellName then		
		if arg1 == "target" and UnitGUID("target") ~= playerGUID then
			CursorCastbar:StartBar(arg1, "default", true, true, startTime, endTime, spellName, texture)
		else
			CursorCastbar:CastLatency("start",arg4)
			CursorCastbar:StartBar(arg1, "default", true, true, startTime, endTime, spellName, texture, arg4)
		end
	end
end
function CursorCastbar:UNIT_SPELLCAST_CHANNEL_UPDATE(...)
	CursorCastbar:UNIT_SPELLCAST_CHANNEL_START(...)
end

function CursorCastbar:UNIT_SPELLCAST_CHANNEL_STOP(self, event, arg1, arg2, arg3, arg4, arg5)
	if arg1 ~= "player" and arg1 ~= "vehicle" and arg1 ~= "target" then return end
	if arg1 == "target" and UnitGUID("target") ~= playerGUID then
		CursorCastbar:EndBar(arg1, event, arg4)
	else
		CursorCastbar:EndBar(arg1, event, arg4)
	end
end

function CursorCastbar:UNIT_SPELLCAST_DELAYED(self, event, arg1, arg2, arg3, arg4, arg5)
	if arg1 ~= "player" and arg1 ~= "vehicle" and arg1 ~= "target" then return end
	local spellName, spellRank, displayName, texture, startTime, endTime, isTradeSkill = UnitCastingInfo(arg1)
	if arg1 == "target" and UnitGUID("target") ~= playerGUID then
		CursorCastbar:StartBar(arg1, "default", false, false, startTime, endTime, spellName, texture)
	else
		CursorCastbar:StartBar(arg1, "default", false, false, startTime, endTime, spellName, texture, entry)
	end
end

function CursorCastbar:UNIT_SPELLCAST_FAILED(self, event, arg1, arg2, arg3, arg4, arg5)
	if arg1 ~= "player" and arg1 ~= "vehicle" and arg1 ~= "target" then return end
	if arg1 == "target" and UnitGUID("target") ~= playerGUID then
		CursorCastbar:EndBar(arg1, event, arg4)
	else
		if arg2 == CursorCastbar.Frames.Bars[getbaridbyname[arg1]].SpellName then
			CursorCastbar:EndBar(arg1, event, arg4)
			CursorCastbar:EndBar("gcd", event, nil, true)
		end
	end
end

function CursorCastbar:UNIT_SPELLCAST_FAILED_QUIET(self, event, arg1, arg2, arg3, arg4, arg5)
	if arg1 ~= "player" and arg1 ~= "vehicle" then return end
	CursorCastbar.CastLatencySpellTable[arg4] = nil
end

function CursorCastbar:UNIT_SPELLCAST_INTERRUPTED(...)
	CursorCastbar:UNIT_SPELLCAST_FAILED(...)
end

function CursorCastbar:UNIT_SPELLCAST_SENT(self, event, arg1, arg2, arg3, arg4, arg5)
	if CursorCastbar.Frames.Bars[getbaridbyname[arg1]].EndTime == 0 then				
	end
	CursorCastbar:CastLatency("sent",arg5)
end

function CursorCastbar:UNIT_SPELLCAST_START(self, event, arg1, arg2, arg3, arg4, arg5)
	if arg1 ~= "player" and arg1 ~= "vehicle" and arg1 ~= "target" then return end
	local spellName, spellRank, displayName, texture, startTime, endTime, isTradeSkill = UnitCastingInfo(arg1)
	if arg1 == "target" and UnitGUID("target") ~= playerGUID then
		CursorCastbar:StartBar(arg1, "default", false, false, startTime, endTime, arg2, texture) 
	else
		CursorCastbar:CastLatency("start",arg4)
		CursorCastbar:StartBar(arg1, "default", false, false, startTime, endTime, arg2, texture, arg4)
	end
end

function CursorCastbar:UNIT_SPELLCAST_STOP(self, event, arg1, arg2, arg3, arg4, arg5)
	if arg1 ~= "player" and arg1 ~= "vehicle" and arg1 ~= "target" then return end
	if arg1 == "target" and UnitGUID("target") ~= playerGUID then
		if CursorCastbar.Frames.Bars[getbaridbyname[arg1]].IsChannel == false then
			if arg2 == CursorCastbar.Frames.Bars[getbaridbyname[arg1]].SpellName then
				CursorCastbar:EndBar(arg1, event, arg4) 
			end
		end
	else
		if CursorCastbar.Frames.Bars[getbaridbyname[arg1]].IsChannel == false then
			if arg2 == CursorCastbar.Frames.Bars[getbaridbyname[arg1]].SpellName then
				CursorCastbar:EndBar(arg1, event, arg4) 
			end
		end
	end
end

--[[
function CursorCastbar:
	
end
]]

function CursorCastbar:PLAYER_ENTERING_WORLD()
--[[
--Check Playerclass
	playerClass = select(2,UnitClass("player"))
	playerGUID = UnitGUID("player")
	
--Create Frames
	CursorCastbar:CreateFrames()
	]]
--Activate Castbar visualization
--	CursorCastbar:SetScript("OnUpdate", function(self, elapsed)
	CursorCastbarParse:SetScript("OnUpdate", function(self, elapsed)
		CursorCastbar:OnUpdate(self, elapsed)
	end)
	
	CursorCastbar:CheckAllIndicators()
	
end

function CursorCastbar:PLAYER_LEAVING_WORLD()
	
--Check Playerclass
--	playerClass = select(2,UnitClass("player"))
--	playerGUID = UnitGUID("player")
	
--Deactivate Castbar visualization
	CursorCastbarParse:SetScript("OnUpdate", nil)
	
end

function CursorCastbar:ACTIVE_TALENT_GROUP_CHANGED(self, event, activegroup)
	
--	print("CCB: You are now in spec "..activegroup)
	
end


function CursorCastbar:StartBar(bar, typ, reverse, isChannel, StartTime, EndTime, SpellName, texture, entry, per)
	
	if type(bar) == "string" then
		bar = getbaridbyname[bar]
	end
	if not type(bar) == "number" then return end
	
	local optstring = frames[bar].Name
	
	if self.db.profile[optstring].enabled then
		local f = _G["CursorCastbarMain"..bar]
		if StartTime and EndTime then--and CursorCastbar.Frames.Bars[bar].StartTime == 0 then
			if self.db.profile[frames[bar].Name].Latency and self.db.profile[frames[bar].Name].Latency.subtract then
				local --[[down, up, latencyHome,]] latency = CursorCastbar_CastLatency or select(4, GetNetStats())
				EndTime = EndTime - latency
			end
			CursorCastbar.Frames.Bars[bar].Type = typ
			CursorCastbar.Frames.Bars[bar].Reverse = reverse
			CursorCastbar.Frames.Bars[bar].IsChannel = isChannel
			CursorCastbar.Frames.Bars[bar].StartTime = StartTime-- / 1000
			CursorCastbar.Frames.Bars[bar].EndTime = EndTime-- / 1000
			CursorCastbar.Frames.Bars[bar].SpellName = SpellName
			CursorCastbar.Frames.Bars[bar].Icon = texture
			CursorCastbar.Frames.Bars[bar].Entry = entry or 0
			CursorCastbar.Frames.Bars[bar].Percent = per or 0
		--	CursorCastbar:OnUpdate(nil, 0)
			
			local t = self.db.profile[optstring].SpellText
			if t and t.enabled == true then
				CursorCastbarShowText(CursorCastbar.Frames.Bars[bar].SpellName,
					t.charsize or 15,--Charsize.Value
					t.charspace or -9,--Charspace.Value
					t.radius or 34,--Radius.Value
					t.rotanchor or 190,--Rotanchor.Value
					82,--charrot
					_G["CursorCastbarMain"..bar],--pFrame
					t.color or {r = 1, g = 1, b = 1},--SpellStringColor.Value
					t.alpha or 1,--alpha
					2--fonttype
				)
			end
			
			local t = self.db.profile[optstring].SpellIcon
			if t and t.enabled == true then
				local f = _G["CursorCastbarMain"..bar.."Icon"]
				if f then
					if t.design == "Circle" then
					  SetPortraitToTexture(f, texture)
					else
					  f:SetTexture(texture)
					end
					f:Show()
				end
			end
			
			if bar == 1 and false then
				local mf = GetMouseFocus()	
				if mf and mfname ~= "WorldFrame" then			
					CursorCastbar.Frames.Bars[bar].Frame = mf
				end
				CursorCastbar:CreateModels(bar)
			end
			
			f:Show()
		end
	end
end

function CursorCastbar:EndBar(bar, event, entry, force)
--	if event and event~=nil then print(event) end	--DEBUG
	
	if type(bar) == "string" then
		bar = getbaridbyname[bar]
	end
	if not type(bar) == "number" then return end
	
	if CursorCastbar.Frames.Bars[bar].Entry ~= entry and not force then return end
	
	CursorCastbar.Frames.Bars[bar].IsChannel = false
	CursorCastbar.Frames.Bars[bar].StartTime = 0
	CursorCastbar.Frames.Bars[bar].EndTime = 0
	CursorCastbar.Frames.Bars[bar].SpellName = " "
	CursorCastbar.Frames.Bars[bar].Icon = ""
	CursorCastbar.Frames.Bars[bar].Entry = 0
	CursorCastbar.Frames.Bars[bar].Frame = nil
	
	local f = _G["CursorCastbarMain"..bar]
	if f then f:Hide() end
	
	local f = _G["CursorCastbarMain"..bar.."Text"]
	if f then f:Hide() end
	
	local f = _G["CursorCastbarMain"..bar.."Icon"]
	if f then f:Hide() end
	
end


function CursorCastbar:StartBarIndicator(bar, bartime, reverse, isChannel, StartTime, EndTime, SpellName, texture)
	
	if StartTime and EndTime then--and CursorCastbar.Frames.Bars[bar].StartTime == 0 then
		CursorCastbar.Frames.BarIndicators[bar].Reverse = reverse
		CursorCastbar.Frames.BarIndicators[bar].IsChannel = isChannel
		CursorCastbar.Frames.BarIndicators[bar].StartTime = StartTime-- / 1000
		CursorCastbar.Frames.BarIndicators[bar].EndTime = EndTime-- / 1000
		CursorCastbar.Frames.BarIndicators[bar].SpellName = SpellName
		CursorCastbar.Frames.BarIndicators[bar].Icon = texture
	end
end


function CursorCastbar:EndBarIndicator(bar, event)
--	if event and event~=nil then print(event) end	--DEBUG

	CursorCastbar.Frames.BarIndicators[bar].Visible = false
	CursorCastbar.Frames.BarIndicators[bar].IsChannel = false
	CursorCastbar.Frames.BarIndicators[bar].StartTime = 0
	CursorCastbar.Frames.BarIndicators[bar].EndTime = 0
	CursorCastbar.Frames.BarIndicators[bar].SpellName = " "
	CursorCastbar.Frames.BarIndicators[bar].Icon = ""
	
end

local visualsdelay = 0
function CursorCastbar:UpdateVisuals(show, force)
	if self.db.profile.showpreview == false then
		visualsdelay = 0
		for i = 1,#frames do
			CursorCastbar:EndBar(i, "Options:Hide", nil, true)
		end
		return
	end
	if force == true then
		visualsdelay = 0
		show = true
		for i=1,#frames do
			CursorCastbar:EndBar(i, "UpdateVisuals", nil, true)
		end
 	end
	if show == true then
		local icon = "Interface\\Icons\\INV_Misc_QuestionMark"
		local CurrentTime = GetTime()*1000
		if CurrentTime >= visualsdelay then
			visualsdelay = CurrentTime + 5000
			CursorCastbar:CastLatency("start","UpdateVisuals")
			for i=1,#frames do
				CursorCastbar:StartBar(i, "default", (math.random(0,1) == 0), (math.random(0,1) == 0), CurrentTime, CurrentTime + math.random(2,5)*1000, frames[i].Name.." test string", icon)
			end
		end
	else
		visualsdelay = 0
		for i = 1,#frames do
			CursorCastbar:EndBar(i, "Options:Hide", nil, true)
		end
	end
end

function CursorCastbar:UpdateSpellText(bar)
	local optstring = frames[bar].Name
	local t = self.db.profile[optstring].SpellText
	if t and t.enabled == true then
		CursorCastbarShowText(CursorCastbar.Frames.Bars[bar].SpellName,
			t.charsize or 15,--Charsize.Value
			t.charspace or -9,--Charspace.Value
			t.radius or 34,--Radius.Value
			t.rotanchor or 190,--Rotanchor.Value
			82,--charrot
			_G["CursorCastbarMain"..bar],--pFrame
			t.color or {r = 1, g = 1, b = 1},--SpellStringColor.Value
			t.alpha or 1,--alpha
			2--fonttype
		)
	end
end

function CursorCastbar:ToggleDotIndicators(visible)
	if self.db.profile.showpreview == false then return end
	for i=1,8 do
		local db = self.db.profile.BarIndicators[i]
		if db.enabled then
			CursorCastbar.Frames.BarIndicators[i].Visible = visible
		elseif visible == false then
			CursorCastbar.Frames.BarIndicators[i].Visible = visible
			--hide
		end
		local db = self.db.profile.DotIndicators[i]
		if db.enabled then
			CursorCastbar.Frames.DotIndicators[i].Visible = visible
		elseif visible == false then
			CursorCastbar.Frames.DotIndicators[i].Visible = visible
			local f = _G["CursorCastbarDotIndicator"..i]
			if f then
				f:Hide()
			end
		end
	end
end

--[[
/run CursorCastbar:CreateFrame("Bars", "Player", 1, true); CursorCastbar:CreateFrame("Bars", "GCD", 2, true); CursorCastbar:CreateFrame("Bars", "Mirror", 3, true); CursorCastbar:CreateFrame("Bars", "Target", 4, true)
/run for i=1,8 do CursorCastbar:CreateFrame("BarIndicators", "", i, true) end
/run for i=1,8 do CursorCastbar:CreateFrame("DotIndicators", "", i, true) end
]]
function CursorCastbar:CreateFrames(all)
	if all then
		--[[CursorCastbar:CreateFrame("Bars", "Player", 1, true)
		CursorCastbar:CreateFrame("Bars", "GCD", 2, true)
		CursorCastbar:CreateFrame("Bars", "Mirror", 3, true)
		CursorCastbar:CreateFrame("Bars", "Target", 4, true)
		CursorCastbar:CreateFrame("Bars", "Focus", 5, true)
		CursorCastbar:CreateFrame("Bars", "Mouseover", 6, true)
		CursorCastbar:CreateFrame("Bars", "Alternate", 7, true)]]
		for i=1,#frames do
			local t = frames[i]
			CursorCastbar:CreateFrame("Bars", t.Name, i, true)
		end
		for i=1,8 do
			CursorCastbar:CreateFrame("BarIndicators", "", i, true)
		end
		for i=1,8 do
			CursorCastbar:CreateFrame("DotIndicators", "", i, true)
		end
	else
		local t = self.db.profile
		--[[CursorCastbar:CreateFrame("Bars", "Player", 1, t["Player"].enabled)
		CursorCastbar:CreateFrame("Bars", "GCD", 2, t["GCD"].enabled)
		CursorCastbar:CreateFrame("Bars", "Mirror", 3, t["Mirror"].enabled)
		CursorCastbar:CreateFrame("Bars", "Target", 4, t["Target"].enabled)
		CursorCastbar:CreateFrame("Bars", "Focus", 5, t["Focus"].enabled)
		CursorCastbar:CreateFrame("Bars", "Mouseover", 6, t["Mouseover"].enabled)
		CursorCastbar:CreateFrame("Bars", "Alternate", 7, t["Alternate"].enabled)]]
		for i=1,#frames do
			local f = frames[i]
			CursorCastbar:CreateFrame("Bars", f.Name, i, t[f.Name].enabled)
		end
		local t = self.db.profile.BarIndicators
		if t.enabled then
			for i=1,8 do
				CursorCastbar:CreateFrame("BarIndicators", "", i, t[i].enabled)
			end
		end
		local t = self.db.profile.DotIndicators
		if t.enabled then
			for i=1,8 do
				CursorCastbar:CreateFrame("DotIndicators", "", i, t[i].enabled)
			end
		end
	end
end
--		/run CursorCastbar:SetCircularPoint("CursorCastbarMain2", nil, 89, 60)
function CursorCastbar:SetCircularPoint(frame, rf, angle, radius)
	
	local frame = _G[frame]
	local angle = tonumber(angle)
	local radius = tonumber(radius)
	
	while angle > 360 do
		angle = angle - 360
	end
	
	if not frame or frame == nil or angle == nil or angle < 0 or angle > 360 or radius == nil then
		print("CCB: Failure in SetCircularPoint - frame / angle / radius invalid")
		return
	end
	
	local x, y
	
	if angle == 270 then
		x = -radius
		y = 0
	elseif angle == 180 then
		x = 0
		y = -radius
	elseif angle == 90 then
		x = radius
		y = 0
	elseif angle == 0 or angle == 360 then
		x = 0
		y = radius
	elseif angle > 270 then
		x = -(radius * cos(angle-270))
		y = radius * sin(angle-270)
	elseif angle > 180 then
		x = -(radius * sin(angle-180))
		y = -(radius * cos(angle-180))
	elseif angle > 90 then
		x = radius * cos(angle-90)
		y = -(radius * sin(angle-90))
	else
		x = radius * sin(angle)
		y = radius * cos(angle)
	end
	
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", rf or frame:GetParent(), "CENTER", x, y)
	
end

function CursorCastbar:CreateFrame(frametype, name, i, visible)
	
	local f	
	local opttable-- = self.db.profile[optstring]
	
	local mf = _G["CursorCastbarMain"]
	local bimf = _G["CursorCastbarBarIndicatorMain"]
	local dimf = _G["CursorCastbarDotIndicatorMain"]
	local flevel, fstrata = mf:GetFrameLevel(), mf:GetFrameStrata()
	
	if frametype == "Bars" then
		opttable = self.db.profile[name]
		
		local pname = "CursorCastbarMain"..i
		local pf = _G[pname]
		if not pf then
			pf = CreateFrame("Frame", pname, mf)
		end
		pf:SetWidth(50)
		pf:SetHeight(50)
		pf:ClearAllPoints()
		local amf
		if opttable.anchor == "Static" then amf = "UIParent" end
		pf:SetPoint("CENTER", amf or mf, "CENTER", opttable.point.ofsx or 0, opttable.point.ofsx or 0)
		pf:Show()
		pf:SetFrameLevel(flevel + opttable.level)
		pf.Name = name
		
		-- SubFrames/Textures >>
		local tmpTexture = _G[pname.."Bar"]
		if not tmpTexture then
			tmpTexture = pf:CreateTexture(pname.."Bar", drawlayer[opttable.Castbar.drawlayer] or "ARTWORK", opttable.Castbar.drawlevel or 0)
		end
		tmpTexture:SetTexCoord(0,0,0,0)	--(0,0.125,0,0.125)
		tmpTexture:SetTexture("Interface\\Addons\\CursorCastbar\\BarTextures\\"..CursorCastbarBarTexture[opttable.Castbar.texture].Name or "Interface\\Addons\\CursorCastbar\\BarTextures\\borderlessblur_HighRes")
		tmpTexture:ClearAllPoints()
		tmpTexture:SetPoint("CENTER")
		tmpTexture:SetWidth(opttable.Castbar.size)
		tmpTexture:SetHeight(opttable.Castbar.size)
		
		local tmpTexture = _G[pname.."Latency"]
		if opttable.Latency and opttable.Latency.enabled then			
			if not tmpTexture then
				tmpTexture = pf:CreateTexture(pname.."Latency", drawlayer[opttable.Latency.drawlayer] or "OVERLAY", opttable.Latency.drawlevel or 0)
			end
			tmpTexture:SetTexCoord(0,0,0,0)	--(0,0.125,0,0.125)
			tmpTexture:SetTexture("Interface\\Addons\\CursorCastbar\\BarTextures\\"..CursorCastbarBarTexture[opttable.Castbar.texture].Name or "Interface\\Addons\\CursorCastbar\\BarTextures\\borderlessblur_HighRes")
			tmpTexture:ClearAllPoints()
			tmpTexture:SetPoint("CENTER")
			tmpTexture:SetWidth(opttable.Castbar.size)
			tmpTexture:SetHeight(opttable.Castbar.size)
			tmpTexture:Show()
		elseif tmpTexture and opttable.Latency.enabled == false then
			tmpTexture:Hide()
		end
		
		local fs = _G[pname.."Fontstring"]
		if opttable.DurationText and opttable.DurationText.enabled then
			if not fs then
				fs = pf:CreateFontString(pname.."Fontstring")
			end
			fs:SetWidth(260)
			fs:SetHeight(50)
		--	fs:SetFontObject(GameFontNormal)
			fs:SetFont("Fonts\\FRIZQT__.TTF", opttable.DurationText.size, ""--[["OUTLINE, MONOCHROME"]])
			fs:SetTextColor(0.5, 0.5, 1, 1)
			fs:SetJustifyH("CENTER")
			fs:SetJustifyV("TOP")
			fs:ClearAllPoints()
			local t = opttable.DurationText.point
			fs:SetPoint(t.point, t.relativeTo, t.relativePoint, t.ofsx, t.ofsy)
			fs:SetText("")	--("CCB Text "..i)
		--	fs:SetScale(opttable.DurationText.scale)
			fs:SetAlpha(opttable.DurationText.alpha)
			fs:Show()
		elseif fs and opttable.DurationText.enabled == false then
			fs:Hide()
		end
		
		if opttable.SpellText and opttable.SpellText.enabled then
			local tframe = _G[pname.."Text"]
			if not tframe then
				tframe = CreateFrame("Frame", pname.."Text", pf);
				tframe:SetAllPoints()
			end
		end
		CursorCastbar.Frames.Bars[i].SpellName = name.." test string"
		CursorCastbar:UpdateSpellText(i)
		
		local tmpTexture = _G[pname.."Icon"]
		if opttable.SpellIcon and opttable.SpellIcon.enabled then
			if not tmpTexture then
				tmpTexture = pf:CreateTexture(pname.."Icon", drawlayer[opttable.SpellIcon.drawlayer] or "ARTWORK", opttable.SpellIcon.drawlevel or 0)
			end
			tmpTexture:SetTexture("")
			tmpTexture:ClearAllPoints()
			local t = opttable.SpellIcon.point
			tmpTexture:SetPoint(t.point, t.relativeTo, t.relativePoint, t.ofsx, t.ofsy)
			tmpTexture:SetWidth(opttable.SpellIcon.size)
			tmpTexture:SetHeight(opttable.SpellIcon.size)
			tmpTexture:Hide()
		elseif tmpTexture and opttable.SpellIcon.enabled == false then
			tmpTexture:Hide()
		end
		-- SubFrames/Textures <<
		
		if not opttable.enabled then visible = false end
		if visible == true then
			pf:Show()
		else
			pf:Hide()
		end
		
		f = pf
		
	elseif frametype == "BarIndicators" then
		opttable = self.db.profile.BarIndicators[i]
	
		local pf = bimf	--_G["CursorCastbarBarIndicatorMain"]
		
		local tmpTexture = _G["CursorCastbarBarIndicator"..i]
		if not tmpTexture then
			tmpTexture = pf:CreateTexture("CursorCastbarBarIndicator"..i, "ARTWORK")
		--	tmpTexture.Name = name
		end
		tmpTexture:SetTexture("Interface\\Addons\\CursorCastbar\\BarTextures\\borderlessblur_HighRes")
		tmpTexture:SetTexCoord(0,0,0,0)
		tmpTexture:ClearAllPoints()
		tmpTexture:SetPoint("CENTER")
		tmpTexture:SetWidth(opttable.Castbar.size)
		tmpTexture:SetHeight(opttable.Castbar.size)
		
		if visible == true then
			tmpTexture:Show()
		else
			tmpTexture:Hide()
		end
		
		f = tmpTexture
	
	elseif frametype == "DotIndicators" then
		opttable = self.db.profile.DotIndicators[i]
		
		local pf = dimf	--_G["CursorCastbarDotIndicatorMain"]
	
		local tmpTexture = _G["CursorCastbarDotIndicator"..i]
		if not tmpTexture then
			tmpTexture = pf:CreateTexture("CursorCastbarDotIndicator"..i, "ARTWORK")
		--	tmpTexture.Name = name
		end
		tmpTexture:ClearAllPoints()
		tmpTexture:SetPoint("CENTER")
		tmpTexture:SetWidth(50)  
		tmpTexture:SetHeight(50) 
		tmpTexture:SetTexture("Interface\\Addons\\CursorCastbar\\BarTextures\\IndicatorLarge")
		local rot = 0 + (i * 15) - 15
		CursorCastbarTransform(math.cos(math.rad(rot)), -math.sin(math.rad(rot)),0.5,math.sin(math.rad(rot)), math.cos(math.rad(rot)),0.5, 0.5, 0.5, 1, tmpTexture:GetName())
		
		if visible == true then
			tmpTexture:Show()
		else
			tmpTexture:Hide()
		end
		
		f = tmpTexture
		
	end
	
	return f
	
end

CursorCastbar.CastLatencySpellTable = {}
function CursorCastbar:CastLatency(event,entry)
	local CurrentTime = GetTime()*1000
	local lag
	if event == "sent" then
		CursorCastbar.CastLatencySpellTable[entry] = {}
		CursorCastbar.CastLatencySpellTable[entry].Time = CurrentTime
		if CursorCastbar.db.profile.Player.anchor == "Semi-Static" then
			CursorCastbar.CastLatencySpellTable[entry].Point = {}
			CursorCastbar.CastLatencySpellTable[entry].Point.x, CursorCastbar.CastLatencySpellTable[entry].Point.y = CursorCastbar:GetCursorPosition(CursorCastbarMain1)
		end
	elseif event == "start" then
		if CursorCastbar.CastLatencySpellTable[entry] then
			lag = CurrentTime - CursorCastbar.CastLatencySpellTable[entry].Time
			CursorCastbar_CastLatency = lag
			if CursorCastbar.db.profile.Player.anchor == "Semi-Static" then
				local t = CursorCastbar.CastLatencySpellTable[entry].Point
				CursorCastbarMain1:ClearAllPoints()
				if t.x ~= nil and t.y ~= nil then
					CursorCastbarMain1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", t.x, t.y)
				else
					CursorCastbarMain1:SetPoint("CENTER", CursorCastbarMain, "CENTER", 0, 0)
				end
			end
			CursorCastbar.CastLatencySpellTable = {}
		else
			CursorCastbarMain1:ClearAllPoints()
			CursorCastbar:SetPoint("CursorCastbarMain1",self.db.profile.Player.point)
		end
	end
--	print(CursorCastbar_CastLatency)	--DEBUG
end

local maxtempmodels = 0
function CursorCastbar:CreateModels(bar)
	local fname = "CursorCastbarMain"..bar
	local f = _G[fname]
	-- >>> Visuals
	local nummodels = 3	--self.db.profile...
	if nummodels > maxtempmodels then maxtempmodels = nummodels end
	if true then
		for i=1,nummodels do
			local Model = _G[fname.."Model"..i]
			if not Model then
				Model = CreateFrame("Model", fname.."Model"..i, f);
			end
			Model:SetAllPoints( nil ); -- Fullscreen
			Model:Show();
			Model:SetLight( 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 );
			Model:SetModel("spells\\lightning_fel_precast_low_hand.mdx")
			Model:SetModelScale(0.02)
			Model:SetFacing(0)
			Model:SetFrameStrata(f:GetFrameStrata())
		end
		for i=nummodels+1,maxtempmodels do
			local Model = _G[fname.."Model"..i]
			if Model then
				Model:SetModelScale(0.0)
				Model:Hide()
			end
		end
		
		local UIScale = UIParent:GetEffectiveScale()
		local Hypotenuse = ( GetScreenWidth() ^ 2 + GetScreenHeight() ^ 2 ) ^ 0.5 * UIScale
		local starttime = CursorCastbar.Frames.Bars[bar].StartTime	-- / 1000
		local endtime = CursorCastbar.Frames.Bars[bar].EndTime	-- / 1000
		local scale = 0.02	--self.db.profile...
		local shape = "square"	--self.db.profile...
		local clockwise = true	--self.db.profile...
		local radius = 1	--self.db.profile...
		
		
		local rf = CursorCastbar.Frames.Bars[bar].Frame or f
		
		local lengthX, lengthY = rf:GetWidth(), rf:GetHeight()
		
		f:SetScript("OnUpdate", function(self)
			local X,Y
			X = ( (rf:GetRight() or 0) + (rf:GetLeft() or 0) ) /2
			Y = ( (rf:GetTop() or 0) + (rf:GetBottom() or 0) ) /2
			local currenttime = GetTime()*1000
			for i=1,nummodels do
				local Model = _G[fname.."Model"..i]
				if endtime >= currenttime then
					local ofsa = (360 / nummodels) * i
					local per = (endtime - currenttime) / ((endtime - starttime) / 100)
					local angle = 360/100*per + ofsa
					local ofsx, ofsy
					if shape == "square" then
						ofsx, ofsy = GetSquarePoint(angle, lengthX, lengthY, clockwise)
					else
						ofsx, ofsy = GetCircularPoint(angle, radius, clockwise)
					end
					Model:SetPosition( ( X + ofsx) / Hypotenuse, ( Y + ofsy) / Hypotenuse, 0 );
				end
				if CursorCastbar.Frames.Bars[bar].Frame then
					Model:SetModelScale(scale or 0.02)
				else
					Model:SetModelScale(0.0)
				end
			end
		end)
		
	end
-- <<< Visuals
end
