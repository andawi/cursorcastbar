--[[
-------------------------------------------------------------------------------------------------------------
CursorCastbar 
by Duugu (EU - Die silberne Hand - Horde) / humfras (EU - Dalvengyr)
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
2.4
- Added option to individually rotate all castbars (0°,90°,180°,270°)
- Added option to anchor CCB on the position of the last spellcast (e.g. above target frame) - Needs some more testing

2.3
- fixed lag-indicator misbehaviour on certain circumstances

2.2.9
- FIX: bug on login (esp. when shapeshifted) 
- workaround for corrupted/incomplete config/SVars

2.2.8
- patch 4.2 adjustments

2.2.7
- changed GCD system to a proper one

2.2.6
- added 4 more Indicator
- code enhancements

2.2.5
- enhanced proc/cooldown check functionality

2.2.4
- added options to choose static color for: Player CastBar, GC Bar, Mirror Bar and Targe CastBar
- fixed misbehavior when "Movable" anchor is choosen

2.2.3
- change PROC and CD indicator functions to use actual duration
- added some textures (experimental)

2.2.2
- continuation by humfras
- adjustments for Patch 4.1

2.2.1
- Settings are now automatically saved within the current active profile (see Profiles/First Spec, Second Spec for profiles)

2.2
- Options panel is now scrollable if required
- Five second bar removed. 
- New option: Indicator>Invert
    Shows the indicator if the spell is READY instead if the spell is on cooldown.
- New options tab: Profiles
    Profiles are saved per account
    Selected profile for first and second talent spec is saved per character
- Bug fix: Proc names with punctuation characters are now working as intended (eg. Arcane Missils proc buff "Arcane Missils!")
- Bug fix: bars for channel spells should now work as expected (player and target)

2.1
- Indocators: multiple spellIDs or spell names separated with ;

2.0
- Several fixes and changes for 4.0 
- Bug with hunters Steady Shot and Auto Shot fixed.
- Gobal cooldown fomular changed

1.7
- New tab: "5 Sec Bar" - Shows a bar for the 5 second rule mana regeneration (default: disabled)
- Bugfix: Hopefully solved a bug within the indicator feature

1.6
- New tab: "Indicator" - Shows up to 4 indicators for different buff/debuff/proc gains or spell cooldowns.

1.5
- New option: "CastBar" > "Show Latency" - Shows the network latency within the cast bar.
- Bugfix: 'Invisible movable cast bar frame bug' fixed
- New bar textures: "High-Res thin", "High-Res thin blur"

1.4.1
- Bugfix: Minimap Button Frame not longer breaks CCB

1.4
- New options: TargetBar, TargetIcon, TargetText (these options are disabled as default)
- 3 new HighRes textures available (1024x1024 instead of 512x512 pixels)
  (64x64HighResThinBorder", "64x64HighResThickBorder", and "64x64HighResBold)

1.3.2
- New option: "Direction"
- New option: "Level" to set the bars/texts drawing level

1.3.1
- Bugfix: LUA error on addon's first load fixed

1.3
- Bugfix: Unsupported characters in spell names fixed
- Removed page: "Visuals" (settings are moved to the new pages)
- New element: Spell Icon
- New element: Mirror Bar (breath, fatigue, etc.)
- New pages: "CastBar", "GCBar", "MirrorBar", "SwingBar", "SpellIcon", and "SpellText" with loads of new options
- New option "Opacity" (page "Global")
- New options "Anchor"/"Not Movable"

1.2.1
- fixed a bug with option "Show Spell Name".
- Option "Show Spell Name" is now checked as default

1.2
- New option to show the current spell as string (tab "Global") (default = off)
- New options to customize the spell string (tab "Visuals")
- Two new bar textures (bold-sharp and bold-blur)
- Separate bar textures for cast bar and gc bar

1.1
- better cast bar texture + optional (blur) texture
- support for totem/rogue/druid 1 second global cooldown 
- option to move cast time number
- options to show cast bar/global cooldown bar individually 
- option to scale bars and number individually 
- option to hide the default Blizzard cast bar

1.0
- Inital version
-------------------------------------------------------------------------------------------------------------
--]]

-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
local function getglobal(name)
	return _G[name]
end
local function setglobal(name, var)
	_G[name] = var
end
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
CursorCastbarLastLoad = 0
CursorCastbarOptionsSettings = {} 													
CursorCastbarOptionsProfiles = {}
CursorCastbarOptionsProfileNames = {}
local CursorCastbarCurrentSpec = 1
local CursorCastbartocVersion = select(4, GetBuildInfo())
local CursorCastbarGC = 1500
CursorCastbarIndicators = {
									[1] = 	{
											Visible = false,
											EndTime = -1,
											NextBlink = -1,
											Name = "",
											},
									[2] = 	{
											Visible = false,
											EndTime = -1,
											NextBlink = -1,
											Name = "",
											},
									[3] = 	{
											Visible = false,
											EndTime = -1,
											NextBlink = -1,
											Name = "",
											},
									[4] = 	{
											Visible = false,
											EndTime = -1,
											NextBlink = -1,
											Name = "",
											},
									[5] = 	{
											Visible = false,
											EndTime = -1,
											NextBlink = -1,
											Name = "",
											},
									[6] = 	{
											Visible = false,
											EndTime = -1,
											NextBlink = -1,
											Name = "",
											},
									[7] = 	{
											Visible = false,
											EndTime = -1,
											NextBlink = -1,
											Name = "",
											},
									[8] = 	{
											Visible = false,
											EndTime = -1,
											NextBlink = -1,
											Name = "",
											},
									}
local CursorCastbarBlinkDuration = 8
local CursorCastbarBlinkEach = 0.25
local CursorCastbarBars = {
								[1] = 	{
										Reverse = false,
										Text = true,
										IsChannel = false,
										StartTime = 0,
										EndTime = 0,
										SpellName = "",
										Icon = ""
										},	--Player Castbar
								[2] = 	{
										Reverse = false,
										Text = false,
										IsChannel = false,
										StartTime = 0,
										EndTime = 0,
										SpellName = "",
										Icon = ""
										},	--GC bar
								[3] = 	{
										Reverse = false,
										Text = false,
										IsChannel = false,
										StartTime = 0,
										EndTime = 0,
										SpellName = "",
										Icon = ""
										},	--Mirror bar
								[4] = 	{
										Reverse = false,
										Text = true,
										IsChannel = false,
										StartTime = 0,
										EndTime = 0,
										SpellName = "",
										Icon = ""
										},	--Target Castbar
								[5] = 	{
										Reverse = true,
										Text = true,
										IsChannel = false,
										StartTime = 0,
										EndTime = 0,
										SpellName = "",
										Icon = ""
										},										
							}
local CursorCastbarBarTexture =	{ 								
									[1] = 	{
											Name = "BarTextures\\64x64sharp",
											Size = 512,
											Rows = 8,
											Cols = 8,
											x1Mod = 0.001,
											x2Mod = 0.125,
											y1Mod = 0.001,
											y2Mod = 0.125,
											},
									[2] = 	{
											Name = "BarTextures\\64x64blur", 
											Size = 512,
											Rows = 8,
											Cols = 8,
											x1Mod = 0.001,
											x2Mod = 0.125,
											y1Mod = 0.001,
											y2Mod = 0.125,
											},
									[3] = 	{
											Name = "BarTextures\\64x64BoldSharp", 
											Size = 512,
											Rows = 8,
											Cols = 8,
											x1Mod = 0.001,
											x2Mod = 0.125,
											y1Mod = 0.001,
											y2Mod = 0.125,
											},
									[4] = 	{
											Name = "BarTextures\\64x64BoldBlur", 
											Size = 512,
											Rows = 8,
											Cols = 8,
											x1Mod = 0.001,
											x2Mod = 0.125,
											y1Mod = 0.001,
											y2Mod = 0.125,
											},
									[5] = 	{
											Name = "BarTextures\\64x64HighResThinBorder", 
											Size = 1024,
											Rows = 8,
											Cols = 8,
											x1Mod = 0.001,
											x2Mod = 0.125,
											y1Mod = 0.001,
											y2Mod = 0.125,
											},
									[6] = 	{
											Name = "BarTextures\\64x64HighResThickBorder", 
											Size = 1024,
											Rows = 8,
											Cols = 8,
											x1Mod = 0.001,
											x2Mod = 0.125,
											y1Mod = 0.001,
											y2Mod = 0.125,
											},
									[7] = 	{
											Name = "BarTextures\\64x64HighResBold", 
											Size = 1024,
											Rows = 8,
											Cols = 8,
											x1Mod = 0.001,
											x2Mod = 0.125,
											y1Mod = 0.001,
											y2Mod = 0.125,
											},				
									[8] = 	{
											Name = "BarTextures\\64x64HighResThinThinBorder", 
											Size = 1024,
											Rows = 8,
											Cols = 8,
											x1Mod = 0.001,
											x2Mod = 0.125,
											y1Mod = 0.001,
											y2Mod = 0.125,
											},				
									[9] = 	{
											Name = "BarTextures\\64x64HighResThinThinBorderBlur", 
											Size = 1024,
											Rows = 8,
											Cols = 8,
											x1Mod = 0.001,
											x2Mod = 0.125,
											y1Mod = 0.001,
											y2Mod = 0.125,
											},		
									[10] = 	{
											Name = "BarTextures\\Runes_HighRes", 
											Size = 1024,
											Rows = 8,
											Cols = 8,
											x1Mod = 0.001,
											x2Mod = 0.125,
											y1Mod = 0.001,
											y2Mod = 0.125,
											},				
											
									}
local CursorCastbarCurrentTexture = 1
local CursorCastbarGCSpellIDs = {
	["DEATHKNIGHT"] = 47541,
	["DRUID"] = 5176,
	["HUNTER"] = 56641,
	["MAGE"] = 133,
	["PALADIN"] = 20154,
	["PRIEST"] = 585,
	["ROGUE"] = 1752,
	["SHAMAN"] = 403,
	["WARLOCK"] = 686,
	["WARRIOR"] = 34428,
}
local CursorCastbarNoGCLocalSpellNames = {}
local CursorCastbarNoGCSpellIDs = {
									6807,
									16188,
									34026,
									3045,
									23989,
									2139,
									11958,
									11129,
									12042,
									12043,
									20271,
									20216,
									14751,
									14177,
									14185,
									5277,
									2983,
									1856,
									17116,
									16166,
									20554,
									18708,
									18288,
									100,
									845,
									78,
									30151,
									2565,
									12328,
									23230,
									24275,
									31884,
									44041,
									20549,
									30283,
									}
local CursorCastbarCurrentMana = 100000
local bList = {}
local ScrollContainerObj = nil
local CursorCastbarNewPointLocked = 0

---------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
CursorCastbar_StaticColoring = 0;
CursorCastbar_Color = {
red = 1,	--0 to 1
green = 1,	--0 to 1
blue = 1,	--0 to 1
};

local function get8coords(l,r,t,b,rota)
--	local tlx, tly, blx, bly, trx, try, brx, bry = l, t, b, l, r, t, r, b
--	return l, t, l, b, r, t, r, b
	
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

CreateFrame("Frame", "CCB_LastSpellcastPoint", UIParent)
CCB_LastSpellcastPoint:SetFrameStrata("DIALOG")
CCB_LastSpellcastPoint:SetWidth(50)  
CCB_LastSpellcastPoint:SetHeight(50) 
CCB_LastSpellcastPoint:SetPoint("CENTER",UIPARENT,"CENTER",0,0)
CCB_LastSpellcastPoint:Show()
function CursorCastbarOnUpdate(self, elapsed) 
	if CursorCastbarOptionsSettings["Global"].Enabled.Value == CursorCastbarOptionsCONSTChecked	then
		
        --CursorCastbarGC = (1.5 / (1 + (GetCombatRating(CR_HASTE_SPELL) / 3279))) * 1000
		if CursorCastbarGC < 1000 then CursorCastbarGC = 1000 end
		local _, class = UnitClass("player")
		local SSF = GetShapeshiftForm(true)
		if class == "ROGUE" or (SSF == 3 and class == "DRUID") then
			CursorCastbarGC = 1000
		end

		local MainFrame = getglobal("CursorCastbarMain")

		if CursorCastbarOptionsSettings["Global"].Anchor.Value == 1 then
			local scale = UIParent:GetEffectiveScale()
			local framescale = MainFrame:GetScale()
			local x, y = GetCursorPosition()
			x = (x / scale / framescale) - MainFrame:GetWidth() / 2
			y = (y / scale / framescale) - MainFrame:GetHeight() / 2
			MainFrame:ClearAllPoints()
			MainFrame:SetPoint( "BOTTOMLEFT", UIParent, "BOTTOMLEFT", x, y )
		elseif CursorCastbarOptionsSettings["Global"].Anchor.Value == 6 and CursorCastbarNewPointLocked == 0 then
			MainFrame:ClearAllPoints()
			MainFrame:SetPoint(CCB_LastSpellcastPoint:GetPoint())
		end

        
        
		local IndicatorFrame = getglobal("CursorCastbarMain11")
		if IndicatorFrame:IsVisible() then
			local CurrentTime = GetTime()
			for x = 1, 8, 1 do 
				IndicatorTexture = getglobal("CursorCastbarMain11Indicator"..x)
			--	print("Indikator: "..x)		--debug
				local doCheck
				local isOver = false
				local triggeredvalue
				for tValue in string.gmatch(CursorCastbarOptionsSettings["Indicator"]["Indicator"..x.."Spell"].Value, "[^;][%w%s%p:][^;]+") do 
					if CursorCastbarOptionsSettings["Indicator"]["Indicator"..x.."Target"].Value == 2 then
						local start, duration, enabled = GetSpellCooldown(tValue)
						if ((start ~= nil) and (start > 0)) and (duration >= 2) then
						--[[	if duration >= 2 then
								print(tValue.." is on cooldown.")
							elseif start == 0 and duration == 0 then
								print(tValue.." is usable.")
							end]]
							doCheck = true
							triggeredvalue = tValue
						end
						if (not duration or duration <= 1.5) and (tValue == triggeredvalue) then
							isOver = true
						end
					elseif CursorCastbarOptionsSettings["Indicator"]["Indicator"..x.."Target"].Value == 1 then
						local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura("player", tValue)
						local proc
						if name ~= nil then
							if duration >= 0 then
							--	print("Aura active!")	--debug
								proc = true
							end
						else
						--	print("Aura NOT active")	--debug
							proc = false
						end
						
						if not duration or (duration ~= 0 and duration <= 1.5) or not proc then		--(duration ~= 0 and duration <= 1.5) checks for constant buffs
							isOver = true
						end
						if proc then
							doCheck = true
						end
					end
				end

				if CursorCastbarIndicators[x].Visible == true and CursorCastbarIndicators[x].EndTime > -1 and (doCheck) then
					if --[[CursorCastbarIndicators[x].EndTime < CurrentTime]] isOver then	
						CursorCastbarIndicators[x].Visible = false
						CursorCastbarIndicators[x].EndTime = -1
						CursorCastbarIndicators[x].NextBlink = -1
                        if CursorCastbarOptionsSettings["Indicator"]["Indicator"..x.."Invert"].Value == CursorCastbarOptionsCONSTUnChecked then                        
                                                IndicatorTexture:Hide()
												--CD , hide if rdy
											--	print("Indicator Process 1")	--debug
                        else							
                            IndicatorTexture:Hide()
						--	print("Indicator Process 2")	--debug
                        end
                        
					else
                        if CursorCastbarOptionsSettings["Indicator"]["Indicator"..x.."Invert"].Value == CursorCastbarOptionsCONSTUnChecked then                        
                            if CursorCastbarOptionsSettings["Indicator"].IndicatorBlink.Value == CursorCastbarOptionsCONSTChecked then 
                                if CursorCastbarIndicators[x].NextBlink < CurrentTime then
                                    CursorCastbarIndicators[x].NextBlink = CurrentTime + CursorCastbarBlinkEach
                                    if not IndicatorTexture:IsVisible() then
										--CD , blink
                                        IndicatorTexture:Show()
									--	print("Indicator Process 3")	--debug
                                    else
										--CD , blink
                                        IndicatorTexture:Hide()
									--	print("Indicator Process 4")	--debug
                                    end
                                end
                            else
                                if not IndicatorTexture:IsVisible() then
                                    IndicatorTexture:Show()
								--	print("Indicator Process 5")	--debug
                                end
                            end
                        else
							--CD , revers
                            IndicatorTexture:Hide()
						--	print("Indicator Process 6")	--debug
                        end
					end
				else 
                    if CursorCastbarOptionsSettings["Indicator"]["Indicator"..x.."Invert"].Value == CursorCastbarOptionsCONSTUnChecked then                        
                        if IndicatorTexture:IsVisible() then
                            IndicatorTexture:Hide()
						--	print("Indicator Process 7")	--debug
                        end
                    else
						--revers , show if rdy
                        IndicatorTexture:Show()
					--	print("Indicator Process 8")	--debug
                    end
				end
			end
		end
		
        
        
        
		for x = 1, 4, 1 do 
			local BarFrame = getglobal("CursorCastbarMainBar"..x)
			local Fontstring = getglobal("CursorCastbarMainFS"..x)
			if x == 5 then
				BarFrame = getglobal("CursorCastbarMainBar10")
				Fontstring = getglobal("CursorCastbarMainFS10")
			end


			local CurrentTime = GetTime()

			if CursorCastbarBars[x].SpellName then					
				if CursorCastbarBars[x].SpellName ~= "" and x == 1 then
					if CursorCastbarOptionsSettings["SpellText"].ShowSpellName.Value == CursorCastbarOptionsCONSTChecked	then
						CursorCastbarShowText(CursorCastbarBars[x].SpellName,
						CursorCastbarOptionsSettings["SpellText"].Charsize.Value,
						CursorCastbarOptionsSettings["SpellText"].Charspace.Value,
						CursorCastbarOptionsSettings["SpellText"].Radius.Value,
						CursorCastbarOptionsSettings["SpellText"].Rotanchor.Value,
						82, 
						getglobal("CursorCastbarMain5"),
						CursorCastbarOptionsSettings["SpellText"].SpellStringColor.Value,
						2)	
						CursorCastbarBars[x].SpellName = "" 
					end
				end						
				if CursorCastbarBars[x].SpellName ~= "" and x == 4 then
					if CursorCastbarOptionsSettings["TargetText"].ShowSpellName.Value == CursorCastbarOptionsCONSTChecked	then
						CursorCastbarShowText(CursorCastbarBars[x].SpellName,
						CursorCastbarOptionsSettings["TargetText"].Charsize.Value,
						CursorCastbarOptionsSettings["TargetText"].Charspace.Value,
						CursorCastbarOptionsSettings["TargetText"].Radius.Value,
						CursorCastbarOptionsSettings["TargetText"].Rotanchor.Value,
						82, 
						getglobal("CursorCastbarMain8"),
						CursorCastbarOptionsSettings["TargetText"].SpellStringColor.Value,
						2)	
						CursorCastbarBars[x].SpellName = "" 
					end
				end						
			end	

			if x < 5 then
				if CursorCastbarBars[x].Icon then					
					if CursorCastbarBars[x].Icon ~= "" then
						local tmpTexture = getglobal("CursorCastbarMainIcon"..x)
						tmpTexture:SetTexture(CursorCastbarBars[x].Icon)
					else
						local tmpTexture = getglobal("CursorCastbarMainIcon"..x)
						tmpTexture:SetTexture("")
					end
				end
			end
			
			if CursorCastbarBars[x].EndTime > CurrentTime then
				local per = (CursorCastbarBars[x].EndTime - CurrentTime) / ((CursorCastbarBars[x].EndTime - CursorCastbarBars[x].StartTime) / 100)     
				if per > 0 then
					--Coloring the frames
					if x == 1 and CursorCastbarOptionsSettings["CastBar"].CBStaticColor.Value == CursorCastbarOptionsCONSTChecked then
						local red, green, blue = CursorCastbarOptionsSettings["CastBar"].CBColor.Value.r, CursorCastbarOptionsSettings["CastBar"].CBColor.Value.g, CursorCastbarOptionsSettings["CastBar"].CBColor.Value.b
						BarFrame:SetVertexColor(red, green, blue, CursorCastbarOptionsSettings["Global"].Opacity.Value/100)
						Fontstring:SetTextColor(red, green, blue, CursorCastbarOptionsSettings["Global"].Opacity.Value/100)
					elseif x == 2 and CursorCastbarOptionsSettings["GCBar"].GCStaticColor.Value == CursorCastbarOptionsCONSTChecked then
						local red, green, blue = CursorCastbarOptionsSettings["GCBar"].GCColor.Value.r, CursorCastbarOptionsSettings["GCBar"].GCColor.Value.g, CursorCastbarOptionsSettings["GCBar"].GCColor.Value.b
						BarFrame:SetVertexColor(red, green, blue, CursorCastbarOptionsSettings["Global"].Opacity.Value/100)
						Fontstring:SetTextColor(red, green, blue, CursorCastbarOptionsSettings["Global"].Opacity.Value/100)
					elseif x == 3 and CursorCastbarOptionsSettings["MirrorBar"].MStaticColor.Value == CursorCastbarOptionsCONSTChecked then
						local red, green, blue = CursorCastbarOptionsSettings["MirrorBar"].MColor.Value.r, CursorCastbarOptionsSettings["MirrorBar"].MColor.Value.g, CursorCastbarOptionsSettings["MirrorBar"].MColor.Value.b
						BarFrame:SetVertexColor(red, green, blue, CursorCastbarOptionsSettings["Global"].Opacity.Value/100)
						Fontstring:SetTextColor(red, green, blue, CursorCastbarOptionsSettings["Global"].Opacity.Value/100)
					elseif x == 4 and CursorCastbarOptionsSettings["TargetBar"].TBStaticColor.Value == CursorCastbarOptionsCONSTChecked then
						local red, green, blue = CursorCastbarOptionsSettings["TargetBar"].TBColor.Value.r, CursorCastbarOptionsSettings["TargetBar"].TBColor.Value.g, CursorCastbarOptionsSettings["TargetBar"].TBColor.Value.b
						BarFrame:SetVertexColor(red, green, blue, CursorCastbarOptionsSettings["Global"].Opacity.Value/100)
						Fontstring:SetTextColor(red, green, blue, CursorCastbarOptionsSettings["Global"].Opacity.Value/100)
					else
						if CursorCastbarBars[x].Reverse then
							per = 100 - per
							BarFrame:SetVertexColor(1 - per/100 + 0.5, (per/100), 0, CursorCastbarOptionsSettings["Global"].Opacity.Value/100)
							Fontstring:SetTextColor(1 - per/100 + 0.5, (per/100), 0, CursorCastbarOptionsSettings["Global"].Opacity.Value/100)
						else
							BarFrame:SetVertexColor((per/100) + 0.25, 1 - per/100 , 0, CursorCastbarOptionsSettings["Global"].Opacity.Value/100)
							Fontstring:SetTextColor((per/100) + 0.25, 1 - per/100 , 0, CursorCastbarOptionsSettings["Global"].Opacity.Value/100)
						end
					end
						
					local row = (math.floor((per / 1.5625)/8)) 
					local col = (math.floor((per - (row * 1.5625 * 8)) / 1.5625))

					if x == 1 then
						local tx1, tx2, ty1, ty2
						if CursorCastbarOptionsSettings["CastBar"].Direction.Value == 1 then
							tx1, tx2, ty1, ty2 = (col * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["CastBar"].TextureCB.Value].x1Mod, (col  * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["CastBar"].TextureCB.Value].x2Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["CastBar"].TextureCB.Value].y1Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["CastBar"].TextureCB.Value].y2Mod
						else
							tx1, tx2, ty2, ty1 = (col * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["CastBar"].TextureCB.Value].x1Mod, (col  * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["CastBar"].TextureCB.Value].x2Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["CastBar"].TextureCB.Value].y1Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["CastBar"].TextureCB.Value].y2Mod
						end
						local l, r, t, b = tx1, tx2, ty1, ty2	--0,1,0,1	--0, 0.125, 0, 0.125 
						BarFrame:SetTexCoord(get8coords(l,r,t,b,CursorCastbarOptionsSettings["CastBar"].Rotation.Value or 0))
						
						if CursorCastbarOptionsSettings["CastBar"].ShowLatency.Value == CursorCastbarOptionsCONSTChecked	then
							local down, up, latencyHome, latency = GetNetStats() 
							local per = 100 - math.floor((latency/1000) / ((CursorCastbarBars[x].EndTime - CursorCastbarBars[x].StartTime) / 100))
							local row = (math.floor((per / 1.5625)/8)) 
							local col = (math.floor((per - (row * 1.5625 * 8)) / 1.5625))						

							local tx1, tx2, ty1, ty2
							if CursorCastbarOptionsSettings["CastBar"].Direction.Value == 1 then
								tx1, tx2, ty2, ty1 = (col * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["CastBar"].TextureCB.Value].x1Mod, (col  * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["CastBar"].TextureCB.Value].x2Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["CastBar"].TextureCB.Value].y1Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["CastBar"].TextureCB.Value].y2Mod
							else
								tx1, tx2, ty1, ty2 = (col * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["CastBar"].TextureCB.Value].x1Mod, (col  * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["CastBar"].TextureCB.Value].x2Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["CastBar"].TextureCB.Value].y1Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["CastBar"].TextureCB.Value].y2Mod
							end
							getglobal("CursorCastbarMainBar1Latency"):SetTexCoord(get8coords(tx1, tx2, ty1, ty2, CursorCastbarOptionsSettings["CastBar"].Rotation.Value or 0))
							getglobal("CursorCastbarMainBar1Latency"):SetVertexColor(1, 1, 1, 0.33)
						end 
--~ 					elseif x == 5 then
--~ 						local tx1, tx2, ty1, ty2
--~ 						if CursorCastbarOptionsSettings["5 Sec Bar"].Direction.Value == 1 then
--~ 							tx1, tx2, ty1, ty2 = (col * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["5 Sec Bar"].Texture.Value].x1Mod, (col  * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["5 Sec Bar"].Texture.Value].x2Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["5 Sec Bar"].Texture.Value].y1Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["5 Sec Bar"].Texture.Value].y2Mod
--~ 						else
--~ 							tx1, tx2, ty2, ty1 = (col * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["5 Sec Bar"].Texture.Value].x1Mod, (col  * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["5 Sec Bar"].Texture.Value].x2Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["5 Sec Bar"].Texture.Value].y1Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["5 Sec Bar"].Texture.Value].y2Mod
--~ 						end
--~ 						getglobal("CursorCastbarMainBar10"):SetTexCoord(tx1, tx2, ty1, ty2)
					elseif x == 2 then
						local tx1, tx2, ty1, ty2
						if CursorCastbarOptionsSettings["GCBar"].Direction.Value == 1 then
							tx1, tx2, ty1, ty2 = (col * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["GCBar"].TextureGC.Value].x1Mod, (col  * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["GCBar"].TextureGC.Value].x2Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["GCBar"].TextureGC.Value].y1Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["GCBar"].TextureGC.Value].y2Mod
						else
							tx1, tx2, ty2, ty1 = (col * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["GCBar"].TextureGC.Value].x1Mod, (col  * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["GCBar"].TextureGC.Value].x2Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["GCBar"].TextureGC.Value].y1Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["GCBar"].TextureGC.Value].y2Mod
						end
						BarFrame:SetTexCoord(get8coords(tx1, tx2, ty1, ty2, CursorCastbarOptionsSettings["GCBar"].Rotation.Value or 0))
					elseif x == 3 then
						local tx1, tx2, ty1, ty2
						if CursorCastbarOptionsSettings["MirrorBar"].Direction.Value == 1 then
							tx1, tx2, ty1, ty2 = (col * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["MirrorBar"].TextureMB.Value].x1Mod, (col  * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["MirrorBar"].TextureMB.Value].x2Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["MirrorBar"].TextureMB.Value].y1Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["MirrorBar"].TextureMB.Value].y2Mod
						else
							tx1, tx2, ty2, ty1 = (col * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["MirrorBar"].TextureMB.Value].x1Mod, (col  * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["MirrorBar"].TextureMB.Value].x2Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["MirrorBar"].TextureMB.Value].y1Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["MirrorBar"].TextureMB.Value].y2Mod
						end
						BarFrame:SetTexCoord(get8coords(tx1, tx2, ty1, ty2, CursorCastbarOptionsSettings["MirrorBar"].Rotation.Value or 0))
					elseif x == 4 then
						local tx1, tx2, ty1, ty2
						if CursorCastbarOptionsSettings["TargetBar"].Direction.Value == 1 then
							tx1, tx2, ty1, ty2 = (col * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["TargetBar"].Texture.Value].x1Mod, (col  * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["TargetBar"].Texture.Value].x2Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["TargetBar"].Texture.Value].y1Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["TargetBar"].Texture.Value].y2Mod
						else
							tx1, tx2, ty2, ty1 = (col * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["TargetBar"].Texture.Value].x1Mod, (col  * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["TargetBar"].Texture.Value].x2Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["TargetBar"].Texture.Value].y1Mod, (row * 0.125) + CursorCastbarBarTexture[CursorCastbarOptionsSettings["TargetBar"].Texture.Value].y2Mod
						end
						BarFrame:SetTexCoord(get8coords(tx1, tx2, ty1, ty2, CursorCastbarOptionsSettings["TargetBar"].Rotation.Value or 0))
					end
				
					if x == 1 then
						if CursorCastbarBars[x].Text and CursorCastbarOptionsSettings["CastBar"].ShowNumber.Value == CursorCastbarOptionsCONSTChecked then
							Fontstring:SetText(string.format("%.2f", (CursorCastbarBars[x].EndTime - CurrentTime)))
						else
							Fontstring:SetText("")
						end
					end
--~ 					if x == 5 then
--~ 						if CursorCastbarBars[x].Text and CursorCastbarOptionsSettings["5 Sec Bar"].ShowNumber.Value == CursorCastbarOptionsCONSTChecked then
--~ 							Fontstring:SetText(string.format("%.2f", (CursorCastbarBars[x].EndTime - CurrentTime)))
--~ 						else
--~ 							Fontstring:SetText("")
--~ 						end
--~ 					end
					if x == 4 then
						if CursorCastbarBars[x].Text and CursorCastbarOptionsSettings["TargetBar"].ShowNumber.Value == CursorCastbarOptionsCONSTChecked then
							Fontstring:SetText(string.format("%.2f", (CursorCastbarBars[x].EndTime - CurrentTime)))
						else
							Fontstring:SetText("")
						end
					end
				else
					BarFrame:SetTexCoord(0, 0, 0, 0)
					BarFrame:SetVertexColor(1, 1, 1, 0)
					if CursorCastbarBars[x].Text then
						Fontstring:SetText("")
						Fontstring:SetTextColor(1, 1, 1, 0)
					end
					CursorCastbarBars[x].Icon = "" 

					getglobal("CursorCastbarMainBar1Latency"):SetTexCoord(0,0,0,0)
					getglobal("CursorCastbarMainBar1Latency"):SetVertexColor(1, 1, 1, 0)
				end
			else 
				CursorCastbarBars[x].SpellName = " " 
				CursorCastbarBars[x].StartTime = 0
				CursorCastbarBars[x].EndTime = 0
				BarFrame:SetTexCoord(0, 0, 0, 0)
				BarFrame:SetVertexColor(1, 1, 1, 0)
				if CursorCastbarBars[x].Text then
					Fontstring:SetText("")
					Fontstring:SetTextColor(1, 1, 1, 0)
				end
				CursorCastbarBars[x].Icon = ""
				
				if x == 1 then
					getglobal("CursorCastbarMainBar1Latency"):SetTexCoord(0,0,0,0)
					getglobal("CursorCastbarMainBar1Latency"):SetVertexColor(1, 1, 1, 0)
					CursorCastbarNewPointLocked = 0
				end
			end
		end
	end
	
end 
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarOnLoad(self) 

--~     CursorCastbarOptionsInitOption(self)

	_G[self:GetName()]:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	_G[self:GetName()]:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP" )
	_G[self:GetName()]:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE" )
	_G[self:GetName()]:RegisterEvent("UNIT_SPELLCAST_DELAYED" )
	_G[self:GetName()]:RegisterEvent("UNIT_SPELLCAST_FAILED" )
	_G[self:GetName()]:RegisterEvent("UNIT_SPELLCAST_FAILED_QUIET" )
	_G[self:GetName()]:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED" )
	_G[self:GetName()]:RegisterEvent("UNIT_SPELLCAST_SENT" )
	_G[self:GetName()]:RegisterEvent("UNIT_SPELLCAST_START" )
	_G[self:GetName()]:RegisterEvent("UNIT_SPELLCAST_STOP" )
	_G[self:GetName()]:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	_G[self:GetName()]:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
	_G[self:GetName()]:RegisterEvent("PLAYER_ENTERING_WORLD")
	_G[self:GetName()]:RegisterEvent("MIRROR_TIMER_START")
	_G[self:GetName()]:RegisterEvent("MIRROR_TIMER_PAUSE")
	_G[self:GetName()]:RegisterEvent("MIRROR_TIMER_STOP")
	_G[self:GetName()]:RegisterEvent("PLAYER_TARGET_CHANGED")
	_G[self:GetName()]:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	_G[self:GetName()]:RegisterEvent("SPELL_UPDATE_COOLDOWN")
    _G[self:GetName()]:RegisterEvent("SPELL_UPDATE_USABLE")
	
	

	_G[self:GetName()]:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")		--arg1 Unit 	arg2 Spell name 	arg3 Spell rank 
	_G[self:GetName()]:RegisterEvent("PLAYER_ENTER_COMBAT")			--player engages auto-attack
	_G[self:GetName()]:RegisterEvent("PLAYER_LEAVE_COMBAT")			--	"
	_G[self:GetName()]:RegisterEvent("START_AUTOREPEAT_SPELL")		--
	_G[self:GetName()]:RegisterEvent("STOP_AUTOREPEAT_SPELL")			--
	_G[self:GetName()]:RegisterEvent("UNIT_ATTACK")					-- 1 unit	Fired when a units attack is affected (such as the weapon being swung). 
	_G[self:GetName()]:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	_G[self:GetName()]:RegisterEvent("UNIT_POWER")		-- 1 msg
	_G[self:GetName()]:RegisterEvent("VARIABLES_LOADED")		-- 1 msg
    

    
end 
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
SLASH_CURSORCASTBAR1, SLASH_CURSORCASTBAR2 = "/cursorcastbar", "/ccb";
SlashCmdList["CURSORCASTBAR"] = function (args)
	local optframe = _G["CursorCastbarOptions"]
	if not optframe:IsVisible() then
		InterfaceOptionsFrame_OpenToCategory(optframe);
		if optframe.collapsed then
			for i, button in pairs(InterfaceOptionsFrameAddOns.buttons) do
				if (type(button) == "table" and button.element == optframe) then
					OptionsListButtonToggle_OnClick(button.toggle);
					break
				end
			end
		end
	end
end
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

function CursorCastbarGetBuffDuration(buffName) 
	if buffName then
		local tEndTime = 0
		local i, bname, _, _, _, _, _, bexpirationTime = 0, " "
		local dname, _, _, _, _, _, dexpirationTime
		while bname or dname do
			i = i + 1
			bname, _, _, _, _, _, bexpirationTime = UnitAura("player", i, "HELPFUL")
			dname, _, _, _, _, _, dexpirationTime = UnitAura("player", i, "HARMFUL")
			if bname then
				if string.lower(bname) == string.lower(buffName) then
					tEndTime = bexpirationTime
				end
			end
			if dname then
				if string.lower(dname) == string.lower(buffName) then
					tEndTime = dexpirationTime
				end
			end
		end
		return tEndTime
	else
		return 0
	end
end

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarLastSpellCastPoint()
	local MainFrame = getglobal("CursorCastbarMain")
	local scale = UIParent:GetEffectiveScale()
	local framescale = MainFrame:GetScale()
	local x, y = GetCursorPosition()
	x = (x / scale / framescale) - MainFrame:GetWidth() / 2
	y = (y / scale / framescale) - MainFrame:GetHeight() / 2
	CCB_LastSpellcastPoint:ClearAllPoints()
	CCB_LastSpellcastPoint:SetPoint( "BOTTOMLEFT", UIPARENT, "BOTTOMLEFT", x, y )
end

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarOnEvent(self, event, ...) 
    if CursorCastbarOptionsSettings then
        if CursorCastbarOptionsSettings["Global"].Enabled.Value == CursorCastbarOptionsCONSTChecked	then
            local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = ...
            if event == "PLAYER_TARGET_CHANGED" then
                CursorCastbarEndBar(4) 
                if UnitExists("target") then
                    if UnitName("target") then--~= UnitName("player") then
                        local spellName, spellRank, displayName, texture, startTime, endTime = UnitCastingInfo("target")
                        if spellName then
                            CursorCastbarStartBar(4, endTime-startTime, false, false, startTime, endTime, spellName, texture) 
                        else
                            spellName, spellRank, displayName, texture, startTime, endTime = UnitChannelInfo("target") 
                            if spellName then
                                CursorCastbarStartBar(4, endTime-startTime, true, true, startTime, endTime, arg2, texture) 
                            end
                        end
                    end
                end
            end
            
            if event == "MIRROR_TIMER_PAUSE" then
            
            elseif event == "SPELL_UPDATE_COOLDOWN" or event == "SPELL_UPDATE_USABLE" or event == "ACTIONBAR_UPDATE_COOLDOWN" then
						
						if not CursorCastbarPlayerClass or CursorCastbarPlayerClass == nil then return end
						
						local start, duration = GetSpellCooldown(CursorCastbarGCSpellIDs[CursorCastbarPlayerClass])
						local startTime = start*1000
						local effduration = duration*1000
						CursorCastbarGC = effduration
						
						CursorCastbarStartBar(2, CursorCastbarGC, true, false, startTime, startTime + CursorCastbarGC, "Global Cooldown", nil)
					--[[	
						if not CursorCastbarNoGCLocalSpellNames[arg2] then
							CursorCastbarGC = select(2,GetSpellCooldown(CursorCastbarGCSpellIDs[CursorCastbarPlayerClass]))
							if string.find(string.upper(arg2), "TOTEM") then
								CursorCastbarStartBar(2, 1000, true, false, startTime, startTime + 1000, "Global Cooldown", nil) 
							else
								CursorCastbarStartBar(2, CursorCastbarGC, true, false, startTime, startTime + CursorCastbarGC, "Global Cooldown", nil) 
							end
						end
						
						if not CursorCastbarNoGCLocalSpellNames[arg2] then
							CursorCastbarGC = select(2,GetSpellCooldown(CursorCastbarGCSpellIDs[CursorCastbarPlayerClass]))
							CursorCastbarGetGC()
                            if string.find(string.upper(arg2), "TOTEM") then
                                CursorCastbarStartBar(2, 1000, true, false, GetTime() * 1000, GetTime() * 1000 + 1000, "Global Cooldown", nil) 
                            else
                                CursorCastbarStartBar(2, CursorCastbarGC, true, false, GetTime() * 1000, GetTime() * 1000 + CursorCastbarGC, "Global Cooldown", nil) 
                            end
                        end
					]]
            elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
			--	return	--comment this out if you want to perform the operation
                local timestamp, eventtype, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2, spellId, spellName, spellSchool
				if tonumber((select(4, GetBuildInfo()))) == 40100 then
					timestamp, eventtype, hideCaster, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellId, spellName, spellSchool = ...
                elseif tonumber((select(4, GetBuildInfo()))) >= 40200 then
					timestamp, eventtype, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2, spellId, spellName, spellSchool = ...
				else
					print("Your WoW Version is not support by CursorCastBar. Indicators wont work.")
					return
				end
				if eventtype == "SPELL_AURA_REMOVED" or eventtype == "SPELL_AURA_BROKEN" or eventtype == "SPELL_AURA_BROKEN_SPELL" or eventtype == "SPELL_AURA_APPLIED" or eventtype == "SPELL_AURA_REFRESH" then
                    local tvisible = false
                    if eventtype == "SPELL_AURA_REMOVED" or eventtype == "SPELL_AURA_BROKEN" or eventtype == "SPELL_AURA_BROKEN_SPELL" then
                        tvisible = false
                    elseif eventtype == "SPELL_AURA_APPLIED" or "SPELL_AURA_REFRESH" then
                        tvisible = true
                    end
                    if destName == UnitName("player") then
                        local CurrentTime = GetTime()
                        
						for i = 1,8 do
							if CursorCastbarOptionsSettings["Indicator"]["Indicator"..i.."Target"].Value == 1 then
								for tValue in string.gmatch(CursorCastbarOptionsSettings["Indicator"]["Indicator"..i.."Spell"].Value, "[^;][%w%s%p:][^;]+") do 
									if tValue == spellName then
										CursorCastbarIndicators[i].Visible = tvisible 
										CursorCastbarIndicators[i].EndTime = CurrentTime + CursorCastbarGetBuffDuration(spellName)
										CursorCastbarIndicators[i].NextBlink = CurrentTime + CursorCastbarBlinkEach
									end
								end
							end
						end
						
                    end
                elseif eventtype == "SPELL_CAST_SUCCESS" or eventtype == "SPELL_DAMAGE" or eventtype == "SPELL_HEAL" or eventtype == "SPELL_UPDATE_COOLDOWN" or eventtype == "SPELL_UPDATE_USABLE" or eventtype == "ACTIONBAR_UPDATE_COOLDOWN" then
                    if sourceName == UnitName("player") then
                        local CurrentTime = GetTime()
                        local cooldown = 0
						
						for i = 1,8 do
							if CursorCastbarOptionsSettings["Indicator"]["Indicator"..i.."Target"].Value == 2 then
								for tValue in string.gmatch(CursorCastbarOptionsSettings["Indicator"]["Indicator"..i.."Spell"].Value, "[^;][%w%s%p:][^;]+") do 
                                            if tValue == spellName then
                                                CursorCastbarIndicators[i].Visible = true 
                                                CursorCastbarIndicators[i].EndTime = CurrentTime + cooldown
                                                CursorCastbarIndicators[i].NextBlink = CurrentTime + CursorCastbarBlinkEach
                                            end
								end
							end
						end						
                    end
                end

            elseif event == "MIRROR_TIMER_STOP" then
                CursorCastbarEndBar(3) 
                
            elseif event == "MIRROR_TIMER_START"  then
				local timer, value, maxvalue, scale, paused, label = ...
                if scale == -1 then
                    local startTime = (GetTime() * 1000) - (maxvalue-value)
                    local endTime = (GetTime() * 1000) + value
                    CursorCastbarStartBar(3, maxvalue, true, true, startTime, endTime, label, nil) 
                elseif scale == 10 then
                    local startTime = (GetTime() * 1000) - (value / 10)
                    local endTime = (GetTime() * 1000) + ((maxvalue - value) / 10)
                    CursorCastbarStartBar(3, maxvalue, false, false, startTime, endTime, label, nil) 
                end
                
            elseif event == "UNIT_POWER" then					
                local unitId, resource = ...
                if unit == 'player' then
                    if UnitMana("player") < CursorCastbarCurrentMana then
                        CursorCastbarCurrentMana = UnitMana("player")
                        CursorCastbarStartBar(5, (5000), true, false, (GetTime()*1000), (GetTime()*1000)+(5000), "5 Sec", "") 
                    end
                end
        
            elseif arg1 == "player" or arg1 == "target" then
                if event == "UNIT_SPELLCAST_SUCCEEDED" then
                    if arg1 == "target" then
                        if arg5 ~= 75 and CursorCastbarBars[4].IsChannel == false then
                            CursorCastbarEndBar(4) 
                        end
                    else
                        if arg5 ~= 75 and CursorCastbarBars[1].IsChannel == false then
                            CursorCastbarEndBar(1)
                        end
                    end
                    
                elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
                    local spellName, spellRank, displayName, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(arg1)
                    if spellName then		
                        if arg1 == "target" then
                            CursorCastbarStartBar(4, endTime-startTime, true, true, startTime, endTime, spellName, texture) 
                        else
                            CursorCastbarStartBar(1, endTime-startTime, true, true, startTime, endTime, spellName, texture) 
						--[[	if not CursorCastbarNoGCLocalSpellNames[arg2] then
								CursorCastbarGC = select(2,GetSpellCooldown(CursorCastbarGCSpellIDs[CursorCastbarPlayerClass]))
                                if string.find(string.upper(arg2), "TOTEM") then
                                    CursorCastbarStartBar(2, 1000, true, false, startTime, startTime + 1000, "Global Cooldown", nil) 
                                else
                                    CursorCastbarStartBar(2, CursorCastbarGC, true, false, startTime, startTime + CursorCastbarGC, "Global Cooldown", nil) 
                                end
                            end]]
                        end
                    end
                    
                elseif event == "UNIT_SPELLCAST_CHANNEL_STOP"  then
                        if arg1 == "target" then
                            CursorCastbarEndBar(4) 
                        else
                            CursorCastbarEndBar(1) 
                        end

                elseif event == "UNIT_SPELLCAST_CHANNEL_UPDATE"  then

                    local spellName, spellRank, displayName, texture, startTime, endTime, isTradeSkill, interrupt = UnitChannelInfo(arg1)
                    if spellName then		
                        if arg1 == "target" then
                            CursorCastbarStartBar(4,    endTime-startTime,  true,       true,       startTime, EndTime, spellName,       texture) 
                        else
                            CursorCastbarStartBar(1, endTime-startTime, true, true, startTime,  EndTime, spellName, texture) 
                        end
                    end
                
                elseif event == "UNIT_SPELLCAST_DELAYED"  then
                    local spellName, spellRank, displayName, texture, startTime, endTime, isTradeSkill = UnitCastingInfo(arg1)
                    if arg1 == "target" then
                        CursorCastbarStartBar(4, 0, false, false, startTime, endTime, spellName, texture) 
                    else
                        CursorCastbarStartBar(1, 0, false, false, startTime, endTime, spellName, texture) 
                    end
                
                elseif event == "UNIT_SPELLCAST_FAILED"  then
                    
                elseif event == "UNIT_SPELLCAST_INTERRUPTED"  then
                    if arg1 == "target" then
                        CursorCastbarEndBar(4) 
                    else
                        CursorCastbarEndBar(1) 
                        CursorCastbarEndBar(2) 
                    end
                    
                elseif event == "UNIT_SPELLCAST_SENT"  then
                    if CursorCastbarBars[1].EndTime == 0 then				
					--[[	if not CursorCastbarNoGCLocalSpellNames[arg2] then
							CursorCastbarGC = select(2,GetSpellCooldown(CursorCastbarGCSpellIDs[CursorCastbarPlayerClass]))
                            if string.find(string.upper(arg2), "TOTEM") then
                                CursorCastbarStartBar(2, 1000, true, false, GetTime() * 1000, GetTime() * 1000 + 1000, "Global Cooldown", nil) 
                            else
                                CursorCastbarStartBar(2, CursorCastbarGC, true, false, GetTime() * 1000, GetTime() * 1000 + CursorCastbarGC, "Global Cooldown", nil) 
                            end
                        end]]
                    end
					--	if CursorCastbarNewPointLocked == 0 then
							CursorCastbarLastSpellCastPoint()
					--		CursorCastbarNewPointLocked = 1
					--	end
                
                elseif event == "UNIT_SPELLCAST_START"  then
                    local spellName, spellRank, displayName, texture, startTime, endTime, isTradeSkill = UnitCastingInfo(arg1)
                    if arg1 == "target" then
                        CursorCastbarStartBar(4, endTime-startTime, false, false, startTime, endTime, arg2, texture) 
                    else
						CursorCastbarStartBar(1, endTime-startTime, false, false, startTime, endTime, arg2, texture)
						CursorCastbarNewPointLocked = 1
					--[[	if not CursorCastbarNoGCLocalSpellNames[arg2] then
								CursorCastbarGC = select(2,GetSpellCooldown(CursorCastbarGCSpellIDs[CursorCastbarPlayerClass]))
                                if string.find(string.upper(arg2), "TOTEM") then
                                    CursorCastbarStartBar(2, 1000, true, false, startTime, startTime + 1000, "Global Cooldown", nil) 
                                else
                                    CursorCastbarStartBar(2, CursorCastbarGC, true, false, startTime, startTime + CursorCastbarGC, "Global Cooldown", nil) 
                                end
                        end]]
                    end
                    
                elseif event == "UNIT_SPELLCAST_STOP"  then
                    if arg1 == "target" then
                        if CursorCastbarBars[4].IsChannel == false then
                            if arg2 == CursorCastbarBars[4].SpellName then
                                CursorCastbarEndBar(4) 
                            end
                        end
                    else
                        if CursorCastbarBars[1].IsChannel == false then
                            if arg2 == CursorCastbarBars[1].SpellName then
                                CursorCastbarEndBar(1) 
                            end
                        end
                    end
                end
            end
            
            if event == "ACTIVE_TALENT_GROUP_CHANGED"  then
                CursorCastbarCurrentSpec = GetActiveTalentGroup()
                CursorCastbarOptionsLoadProfile(CursorCastbarOptionsProfileNames[CursorCastbarOptionsSettings["Profiles"]["Profiles"..CursorCastbarCurrentSpec.."Spec"].Value])
                CursorCastbarUpdateVisuals()
            end
            if event == "PLAYER_ENTERING_WORLD"  then
                for x = 1, table.getn(CursorCastbarNoGCSpellIDs), 1 do
                    local name = GetSpellInfo(CursorCastbarNoGCSpellIDs[x]) 
                    if name then
                        CursorCastbarNoGCLocalSpellNames[name] = x
                    end
                end
                CursorCastbarCurrentSpec = GetActiveTalentGroup()
                CursorCastbarOptionsLoadProfile(CursorCastbarOptionsProfileNames[CursorCastbarOptionsSettings["Profiles"]["Profiles"..CursorCastbarCurrentSpec.."Spec"].Value])
                CursorCastbarUpdateVisuals()
				
				CursorCastbarPlayerClass = select(2,UnitClass("player"))
            end
        end
    end
end
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarStartBar(bar, bartime, reverse, isChannel, StartTime, EndTime, SpellName, texture) 
	if StartTime and EndTime then
		if CursorCastbarOptionsSettings["CastBar"].SubtractLag.Value == CursorCastbarOptionsCONSTChecked	then
			local down, up, latency = GetNetStats()
			EndTime = EndTime - latency
		end
		CursorCastbarBars[bar].Reverse = reverse
		CursorCastbarBars[bar].IsChannel = isChannel
		CursorCastbarBars[bar].StartTime = StartTime / 1000
		CursorCastbarBars[bar].EndTime = EndTime / 1000
		CursorCastbarBars[bar].SpellName = SpellName
		CursorCastbarBars[bar].Icon = texture
		CursorCastbarOnUpdate(0)
		if bar == 1 then
			CursorCastbarNewPointLocked = 1
		end
	end
end
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarEndBar(bar) 
	CursorCastbarBars[bar].IsChannel = false
	CursorCastbarBars[bar].StartTime = 0
	CursorCastbarBars[bar].EndTime = 0
	CursorCastbarBars[bar].SpellName = " "
	CursorCastbarBars[bar].Icon = ""
	if bar == 1 then
		CursorCastbarNewPointLocked = 0
	end
end
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarUpdateBar(bar, bartime) 

end
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
local f = CreateFrame("Frame", "CursorCastbarMain", UIParent)
f:SetFrameStrata("DIALOG")
f:SetWidth(50)  
f:SetHeight(50) 
f:Show()
local flevel = getglobal("CursorCastbarMain"):GetFrameLevel() 
local f1 = CreateFrame("Frame", "CursorCastbarMain1", f) f1:SetWidth(50) f1:SetHeight(50) f1:Show() f1:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, 0)
f1:SetFrameLevel(flevel + 1)
local f2 = CreateFrame("Frame", "CursorCastbarMain2", f) f2:SetWidth(50) f2:SetHeight(50) f2:Show() f2:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, 0)
f2:SetFrameLevel(flevel + 1)
local f3 = CreateFrame("Frame", "CursorCastbarMain3", f) f3:SetWidth(50) f3:SetHeight(50) f3:Show() f3:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, 0)
f3:SetFrameLevel(flevel + 1)
local f4 = CreateFrame("Frame", "CursorCastbarMain4", f) f4:SetWidth(50) f4:SetHeight(50) f4:Show() f4:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, 0)
f4:SetFrameLevel(flevel + 2)
local f5 = CreateFrame("Frame", "CursorCastbarMain5", f) f5:SetWidth(50) f5:SetHeight(50) f5:Show() f5:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, 0)
f5:SetFrameLevel(flevel + 3)
local f6 = CreateFrame("Frame", "CursorCastbarMain6", f) f6:SetWidth(50) f6:SetHeight(50) f6:Show() f6:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, 0)
f6:SetFrameLevel(flevel + 1)
local f7 = CreateFrame("Frame", "CursorCastbarMain7", f) f7:SetWidth(50) f7:SetHeight(50) f7:Show() f7:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, 0)
f7:SetFrameLevel(flevel + 3)
local f8 = CreateFrame("Frame", "CursorCastbarMain8", f) f8:SetWidth(50) f8:SetHeight(50) f8:Show() f8:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, 0)
f8:SetFrameLevel(flevel + 3)
local f9 = CreateFrame("Frame", "CursorCastbarMain9", f) f9:SetWidth(50) f9:SetHeight(50) f9:Show() f9:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, 0)
f9:SetFrameLevel(flevel + 2)





--~ local f10 = CreateFrame("Frame", "CursorCastbarMain10", f) f10:SetWidth(50) f10:SetHeight(50) f10:Show() f10:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, 0)
--~ f10:SetFrameLevel(flevel + 1)
--~ local tmpTexture = f10:CreateTexture("CursorCastbarMainBar10", "ARTWORK")
--~ tmpTexture:SetTexCoord(0,0.125,0,0.125)
--~ tmpTexture:SetTexture("Interface\\Addons\\CursorCastbar\\"..CursorCastbarBarTexture[CursorCastbarCurrentTexture].Name)
--~ tmpTexture:SetPoint("CENTER")
--~ tmpTexture:SetWidth(70)  
--~ tmpTexture:SetHeight(70) 
--~ local fs = f10:CreateFontString("CursorCastbarMainFS10") 
--~ fs:SetWidth(260)  
--~ fs:SetHeight(50) 
--~ fs:SetFontObject(GameFontNormal)
--~ fs:SetTextColor(0.5, 0.5, 1, 1)
--~ fs:SetJustifyH("CENTER")
--~ fs:SetJustifyV("TOP")
--~ fs:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, -11)
--~ fs:SetText("XX")




local f11 = CreateFrame("Frame", "CursorCastbarMain11", f) 
f11:SetWidth(50) 
f11:SetHeight(50) 
f11:Show() 
f11:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, 0)
f11:SetFrameLevel(flevel + 0)
for i = 1,8 do
	local fname = "CursorCastbarMain11Indicator"..i
	local tmpTexture = f11:CreateTexture(fname, "ARTWORK")
	tmpTexture:SetTexture("")
	tmpTexture:SetPoint("CENTER")
	tmpTexture:SetWidth(50)  
	tmpTexture:SetHeight(50) 
	tmpTexture:SetTexture("Interface\\Addons\\CursorCastbar\\BarTextures\\Indicator")
	--~ tmpTexture:Hide()
end


local tmpTexture = f1:CreateTexture("CursorCastbarMainBar1", "ARTWORK")
tmpTexture:SetTexCoord(0,0.125,0,0.125)
tmpTexture:SetTexture("Interface\\Addons\\CursorCastbar\\"..CursorCastbarBarTexture[CursorCastbarCurrentTexture].Name)
tmpTexture:SetPoint("CENTER")
tmpTexture:SetWidth(70)  
tmpTexture:SetHeight(70) 
local tmpTexture = f1:CreateTexture("CursorCastbarMainBar1Latency", "OVERLAY")
tmpTexture:SetTexCoord(0,0.125,0,0.125)
tmpTexture:SetTexture("Interface\\Addons\\CursorCastbar\\"..CursorCastbarBarTexture[CursorCastbarCurrentTexture].Name)
tmpTexture:SetPoint("CENTER")
tmpTexture:SetWidth(70)  
tmpTexture:SetHeight(70) 
local tmpTexture = f2:CreateTexture("CursorCastbarMainBar2", "ARTWORK")
tmpTexture:SetTexCoord(0,0.125,0,0.125)
tmpTexture:SetTexture("Interface\\Addons\\CursorCastbar\\"..CursorCastbarBarTexture[CursorCastbarCurrentTexture].Name)
tmpTexture:SetPoint("CENTER")
tmpTexture:SetWidth(50)  
tmpTexture:SetHeight(50) 
local tmpTexture = f3:CreateTexture("CursorCastbarMainBar3", "ARTWORK")
tmpTexture:SetTexCoord(0,0.125,0,0.125)
tmpTexture:SetTexture("Interface\\Addons\\CursorCastbar\\"..CursorCastbarBarTexture[CursorCastbarCurrentTexture].Name)
tmpTexture:SetPoint("CENTER")
tmpTexture:SetWidth(90)  
tmpTexture:SetHeight(90) 
local tmpTexture = f6:CreateTexture("CursorCastbarMainBar4", "ARTWORK")
tmpTexture:SetTexCoord(0,0.125,0,0.125)
tmpTexture:SetTexture("Interface\\Addons\\CursorCastbar\\"..CursorCastbarBarTexture[CursorCastbarCurrentTexture].Name)
tmpTexture:SetPoint("CENTER")
tmpTexture:SetWidth(90)  
tmpTexture:SetHeight(90) 

local fs = f4:CreateFontString("CursorCastbarMainFS1") 
fs:SetWidth(260)  
fs:SetHeight(50) 
fs:SetFontObject(GameFontNormal)
fs:SetTextColor(0.5, 0.5, 1, 1)
fs:SetJustifyH("CENTER")
fs:SetJustifyV("TOP")
fs:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, -11)
fs:SetText("")
local fs = f4:CreateFontString("CursorCastbarMainFS2") 
fs:SetWidth(260)  
fs:SetHeight(50) 
fs:SetFontObject(GameFontNormal)
fs:SetTextColor(0.5, 0.5, 1, 1)
fs:SetJustifyH("CENTER")
fs:SetJustifyV("TOP")
fs:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, -11)
fs:SetText("")
local fs = f4:CreateFontString("CursorCastbarMainFS3") 
fs:SetWidth(260)  
fs:SetHeight(50) 
fs:SetFontObject(GameFontNormal)
fs:SetTextColor(0.5, 0.5, 1, 1)
fs:SetJustifyH("CENTER")
fs:SetJustifyV("TOP")
fs:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, -11)
fs:SetText("")
local fs = f9:CreateFontString("CursorCastbarMainFS4") 
fs:SetWidth(260)  
fs:SetHeight(50) 
fs:SetFontObject(GameFontNormal)
fs:SetTextColor(0.5, 0.5, 1, 1)
fs:SetJustifyH("CENTER")
fs:SetJustifyV("TOP")
fs:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, -11)
fs:SetText("44444")

local tmpTexture = f5:CreateTexture("CursorCastbarMainIcon1", "ARTWORK")
tmpTexture:SetTexture("")
tmpTexture:SetPoint("CENTER")
tmpTexture:SetWidth(50)  
tmpTexture:SetHeight(50) 
tmpTexture:Hide()
local tmpTexture = f5:CreateTexture("CursorCastbarMainIcon2", "ARTWORK")
tmpTexture:SetTexture("")
tmpTexture:SetPoint("CENTER")
tmpTexture:SetWidth(50)  
tmpTexture:SetHeight(50) 
tmpTexture:Hide()
local tmpTexture = f5:CreateTexture("CursorCastbarMainIcon3", "ARTWORK")
tmpTexture:SetTexture("")
tmpTexture:SetPoint("CENTER")
tmpTexture:SetWidth(50)  
tmpTexture:SetHeight(50) 
tmpTexture:Hide()
local tmpTexture = f7:CreateTexture("CursorCastbarMainIcon4", "ARTWORK")
tmpTexture:SetTexture("")
tmpTexture:SetPoint("CENTER")
tmpTexture:SetWidth(50)  
tmpTexture:SetHeight(50) 
tmpTexture:Hide()
---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarUpdateVisuals()
	local MainFrame = getglobal("CursorCastbarMain")
	if CursorCastbarOptionsSettings["Global"].Anchor.Value == 1 then
		MainFrame:ClearAllPoints()
		MainFrame:SetPoint( "BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0 )
	elseif CursorCastbarOptionsSettings["Global"].Anchor.Value == 2 then
		MainFrame:ClearAllPoints()
		MainFrame:SetPoint( "LEFT", UIParent, "LEFT", 50, 0 )
		MainFrame:SetScript("OnDragStart", function(self) end) MainFrame:SetScript("OnDragStop", function(self) end)
	elseif CursorCastbarOptionsSettings["Global"].Anchor.Value == 3 then
		MainFrame:ClearAllPoints()
		MainFrame:SetPoint( "TOP", UIParent, "TOP", 0, -50 )
	elseif CursorCastbarOptionsSettings["Global"].Anchor.Value == 4 then
		MainFrame:ClearAllPoints()
		MainFrame:SetPoint( "RIGHT", UIParent, "RIGHT", -50, 0 )
	elseif CursorCastbarOptionsSettings["Global"].Anchor.Value == 5 then
		if CursorCastbarOptionsSettings["Global"].Locked.Value == CursorCastbarOptionsCONSTUnChecked then
			MainFrame:SetScript("OnDragStart", function(self) getglobal("CursorCastbarMain"):StartMoving() end)
			MainFrame:SetScript("OnDragStop", 	function(self) 
													getglobal("CursorCastbarMain"):StopMovingOrSizing() 
	
													CursorCastbarOptionsSettings["Anchors"] = {}
													for q = 1, getglobal("CursorCastbarMain"):GetNumPoints(), 1 do
														a, p, pa, x, y = getglobal("CursorCastbarMain"):GetPoint(q) 
														if a then
															if p then
																p = p:GetName()
															else
																p = "nil"
															end
															pa = pa or "nil"
															x = x or "nil"
															y = y or "nil"
															table.insert(CursorCastbarOptionsSettings["Anchors"], 	{ 
																												["a"] = a,
																												["p"] = p,
																												["pa"] = pa,
																												["x"] = x,
																												["y"] = y,
																												})
														end
													end
												end)
			MainFrame:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="", tile = false, tileSize = 0, edgeSize = 32, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
			MainFrame:SetMovable(true)
			MainFrame:EnableMouse(true)
			MainFrame:SetClampedToScreen(true)
			MainFrame:RegisterForDrag("LeftButton")
		else
			MainFrame:SetScript("OnDragStart", function(self) getglobal("CursorCastbarMain"):StartMoving() end)
			MainFrame:SetScript("OnDragStop", function(self) getglobal("CursorCastbarMain"):StopMovingOrSizing() end)
			MainFrame:SetBackdrop({bgFile="", edgeFile="", tile = false, tileSize = 0, edgeSize = 32, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
			MainFrame:SetMovable(true)
			MainFrame:EnableMouse(false)
			MainFrame:SetClampedToScreen(true)
			MainFrame:RegisterForDrag("LeftButton")
		end
		table.foreach(CursorCastbarOptionsSettings["Anchors"], 
			function(index, value)
				if value["p"] then
					getglobal("CursorCastbarMain"):ClearAllPoints()
					getglobal("CursorCastbarMain"):SetPoint(value["a"], getglobal(value["p"]), value["pa"], value["x"], value["y"])
				else
					getglobal("CursorCastbarMain"):ClearAllPoints()
					getglobal("CursorCastbarMain"):SetPoint(value["a"], nil, value["pa"], value["x"], value["y"])
				end
			end)
	end
	if CursorCastbarOptionsSettings["Global"].Anchor.Value ~= 5 then
		MainFrame:SetBackdrop({bgFile="", edgeFile="", tile = false, tileSize = 0, edgeSize = 32, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
		MainFrame:SetMovable(false)
		MainFrame:EnableMouse(false)
		MainFrame:SetClampedToScreen(false)
		MainFrame:RegisterForDrag("")
		MainFrame:SetScript("OnDragStart", function(self) end) MainFrame:SetScript("OnDragStop", function(self) end)
	end

	local f = getglobal("CursorCastbarMain")
	if CursorCastbarOptionsSettings["Global"].Enabled.Value == CursorCastbarOptionsCONSTChecked	then
		getglobal("CursorCastbarMain"):Show()
	else
		getglobal("CursorCastbarMain"):Hide()
	end 


	local flevel = getglobal("CursorCastbarMain"):GetFrameLevel() 
	local f1 = getglobal("CursorCastbarMain1")
	f1:SetFrameLevel(flevel + CursorCastbarOptionsSettings["CastBar"].Level.Value)

--~ 	local f10 = getglobal("CursorCastbarMain10")
--~ 	f10:SetFrameLevel(flevel + CursorCastbarOptionsSettings["5 Sec Bar"].Level.Value)

	local f2 = getglobal("CursorCastbarMain2")
	f2:SetFrameLevel(flevel + CursorCastbarOptionsSettings["GCBar"].Level.Value)
	local f3 = getglobal("CursorCastbarMain3")
	f3:SetFrameLevel(flevel + CursorCastbarOptionsSettings["MirrorBar"].Level.Value)
	local f4 = getglobal("CursorCastbarMain4")
	f4:SetFrameLevel(flevel + CursorCastbarOptionsSettings["SpellText"].Level.Value)
	local f5 = getglobal("CursorCastbarMain5")
	f5:SetFrameLevel(flevel + CursorCastbarOptionsSettings["SpellIcon"].Level.Value)
	local f6 = getglobal("CursorCastbarMain6")
	f6:SetFrameLevel(flevel + CursorCastbarOptionsSettings["TargetBar"].Level.Value)
	local f7 = getglobal("CursorCastbarMain7")
	f7:SetFrameLevel(flevel + CursorCastbarOptionsSettings["TargetIcon"].Level.Value)
	if getglobal("CursorCastbarMain5Text") then
		getglobal("CursorCastbarMain5Text"):SetFrameLevel(flevel + CursorCastbarOptionsSettings["SpellText"].Level.Value)
	end
	if getglobal("CursorCastbarMain8Text") then
		getglobal("CursorCastbarMain8Text"):SetFrameLevel(flevel + CursorCastbarOptionsSettings["TargetText"].Level.Value)
	end
	
	f:SetScale(CursorCastbarOptionsSettings["Global"].Scale.Value)
	
--~ 	local tmpTexture = getglobal("CursorCastbarMainBar10")
--~ 	tmpTexture:SetTexture("Interface\\Addons\\CursorCastbar\\"..CursorCastbarBarTexture[CursorCastbarOptionsSettings["5 Sec Bar"].Texture.Value].Name)
--~ 	tmpTexture:SetPoint("CENTER")
--~ 	tmpTexture:SetWidth(CursorCastbarOptionsSettings["5 Sec Bar"].Scale.Value)  
--~ 	tmpTexture:SetHeight(CursorCastbarOptionsSettings["5 Sec Bar"].Scale.Value) 
--~ 	local fs = getglobal("CursorCastbarMainFS10") 
--~ 	fs:SetWidth(260)  
--~ 	fs:SetHeight(50) 
--~ 	fs:SetFontObject(GameFontNormal)
--~ 	fs:SetJustifyH("CENTER")
--~ 	fs:SetJustifyV("TOP")
--~ 	fs:SetPoint("CENTER", "CursorCastbarMain", "CENTER", CursorCastbarOptionsSettings["5 Sec Bar"].FSx.Value, CursorCastbarOptionsSettings["5 Sec Bar"].FSy.Value)
--~ 	fs:SetTextHeight(CursorCastbarOptionsSettings["5 Sec Bar"].FSScale.Value)
	
	local tmpTexture = getglobal("CursorCastbarMainBar1")
	tmpTexture:SetTexture("Interface\\Addons\\CursorCastbar\\"..CursorCastbarBarTexture[CursorCastbarOptionsSettings["CastBar"].TextureCB.Value].Name)
	tmpTexture:SetPoint("CENTER")
	tmpTexture:SetWidth(CursorCastbarOptionsSettings["CastBar"].CBScale.Value)  
	tmpTexture:SetHeight(CursorCastbarOptionsSettings["CastBar"].CBScale.Value) 
	local tmpTexture = getglobal("CursorCastbarMainBar1Latency")
	tmpTexture:SetTexture("Interface\\Addons\\CursorCastbar\\"..CursorCastbarBarTexture[CursorCastbarOptionsSettings["CastBar"].TextureCB.Value].Name)
	tmpTexture:SetVertexColor(1, 1, 1, 0.33)
	tmpTexture:SetPoint("CENTER")
	tmpTexture:SetWidth(CursorCastbarOptionsSettings["CastBar"].CBScale.Value)  
	tmpTexture:SetHeight(CursorCastbarOptionsSettings["CastBar"].CBScale.Value) 

	local tmpTexture = getglobal("CursorCastbarMainBar2")
	tmpTexture:SetTexture("Interface\\Addons\\CursorCastbar\\"..CursorCastbarBarTexture[CursorCastbarOptionsSettings["GCBar"].TextureGC.Value].Name)
	tmpTexture:SetPoint("CENTER")
	tmpTexture:SetWidth(CursorCastbarOptionsSettings["GCBar"].GCScale.Value)  
	tmpTexture:SetHeight(CursorCastbarOptionsSettings["GCBar"].GCScale.Value) 
	local tmpTexture = getglobal("CursorCastbarMainBar3")
	tmpTexture:SetTexture("Interface\\Addons\\CursorCastbar\\"..CursorCastbarBarTexture[CursorCastbarOptionsSettings["MirrorBar"].TextureMB.Value].Name)
	tmpTexture:SetPoint("CENTER")
	tmpTexture:SetWidth(CursorCastbarOptionsSettings["MirrorBar"].MBScale.Value)  
	tmpTexture:SetHeight(CursorCastbarOptionsSettings["MirrorBar"].MBScale.Value) 
	local tmpTexture = getglobal("CursorCastbarMainBar4")
	tmpTexture:SetTexture("Interface\\Addons\\CursorCastbar\\"..CursorCastbarBarTexture[CursorCastbarOptionsSettings["TargetBar"].Texture.Value].Name)
	tmpTexture:SetPoint("CENTER")
	tmpTexture:SetWidth(CursorCastbarOptionsSettings["TargetBar"].Scale.Value)  
	tmpTexture:SetHeight(CursorCastbarOptionsSettings["TargetBar"].Scale.Value) 

	local tmpTexture = getglobal("CursorCastbarMainIcon1")
	tmpTexture:SetTexture("")
	tmpTexture:SetPoint("CENTER", CursorCastbarOptionsSettings["SpellIcon"].Iconx.Value, CursorCastbarOptionsSettings["SpellIcon"].Icony.Value)
	tmpTexture:SetWidth(CursorCastbarOptionsSettings["SpellIcon"].IconScale.Value)  
	tmpTexture:SetHeight(CursorCastbarOptionsSettings["SpellIcon"].IconScale.Value) 
	local tmpTexture = getglobal("CursorCastbarMainIcon4")
	tmpTexture:SetTexture("")
	tmpTexture:SetPoint("CENTER", CursorCastbarOptionsSettings["TargetIcon"].Iconx.Value, CursorCastbarOptionsSettings["TargetIcon"].Icony.Value)
	tmpTexture:SetWidth(CursorCastbarOptionsSettings["TargetIcon"].IconScale.Value)  
	tmpTexture:SetHeight(CursorCastbarOptionsSettings["TargetIcon"].IconScale.Value) 
	
	local fs = getglobal("CursorCastbarMainFS1") 
	fs:SetWidth(260)  
	fs:SetHeight(50) 
	fs:SetFontObject(GameFontNormal)
	fs:SetJustifyH("CENTER")
	fs:SetJustifyV("TOP")
	fs:SetPoint("CENTER", "CursorCastbarMain", "CENTER", CursorCastbarOptionsSettings["CastBar"].FSx.Value, CursorCastbarOptionsSettings["CastBar"].FSy.Value)
	fs:SetTextHeight(CursorCastbarOptionsSettings["CastBar"].FSScale.Value)
	local fs = getglobal("CursorCastbarMainFS2") 
	fs:SetWidth(260)  
	fs:SetHeight(50) 
	fs:SetFontObject(GameFontNormal)
	fs:SetJustifyH("CENTER")
	fs:SetJustifyV("TOP")
	fs:SetPoint("CENTER", "CursorCastbarMain", "CENTER", 0, -11)
	fs:SetTextHeight(CursorCastbarOptionsSettings["CastBar"].FSScale.Value)
	local fs = getglobal("CursorCastbarMainFS4") 
	fs:SetWidth(260)  
	fs:SetHeight(50) 
	fs:SetFontObject(GameFontNormal)
	fs:SetJustifyH("CENTER")
	fs:SetJustifyV("TOP")
	fs:SetPoint("CENTER", "CursorCastbarMain", "CENTER", CursorCastbarOptionsSettings["TargetBar"].FSx.Value, CursorCastbarOptionsSettings["TargetBar"].FSy.Value)
	fs:SetTextHeight(CursorCastbarOptionsSettings["TargetBar"].FSScale.Value)
	
	local icon = nil
	if CursorCastbarOptionsSettings["SpellIcon"].ShowSpellIcon.Value == CursorCastbarOptionsCONSTChecked then
		icon = "Interface\\Icons\\Spell_Nature_TimeStop"
	end
	if CursorCastbarOptionsSettings["TargetIcon"].ShowSpellIcon.Value == CursorCastbarOptionsCONSTChecked then
		icon = "Interface\\Icons\\Spell_Nature_TimeStop"
	end
--~ 	if CursorCastbarOptionsSettings["5 Sec Bar"].Show5SBar.Value == CursorCastbarOptionsCONSTChecked then
--~ 		CursorCastbarStartBar(5, 5000, true, false, (GetTime() * 1000), (GetTime() * 1000) + 2500, "5 Sec Bar string", icon) 
--~ 	end
	if CursorCastbarOptionsSettings["SpellText"].ShowSpellName.Value == CursorCastbarOptionsCONSTChecked then
		CursorCastbarStartBar(1, 5000, false, false, (GetTime() * 1000), (GetTime() * 1000) + 2500, "Player test string", icon) 
		CursorCastbarStartBar(2, 5000, true, false, (GetTime() * 1000), (GetTime() * 1000) + 2500, "Global Cooldown", icon) 
		CursorCastbarStartBar(3, 5000, true, true, (GetTime() * 1000), (GetTime() * 1000) + 2500, arg6, icon) 
		if getglobal("CursorCastbarMain5Text") then
			getglobal("CursorCastbarMain5Text"):Show()
		end
	else
		CursorCastbarStartBar(1, 5000, false, false, (GetTime() * 1000), (GetTime() * 1000) + 2500, " ", icon) 
		CursorCastbarStartBar(2, 5000, true, false, (GetTime() * 1000), (GetTime() * 1000) + 2500, " ", icon) 
		CursorCastbarStartBar(3, 5000, true, false, (GetTime() * 1000), (GetTime() * 1000) + 2500, " ", icon) 
		if getglobal("CursorCastbarMain5Text") then
			getglobal("CursorCastbarMain5Text"):Hide()
		end
	end
	
	
	if CursorCastbarOptionsSettings["TargetText"].ShowSpellName.Value == CursorCastbarOptionsCONSTChecked then
		CursorCastbarStartBar(4, 5000, false, false, (GetTime() * 1000), (GetTime() * 1000) + 2500, "Target test string", icon) 
		if getglobal("CursorCastbarMain8Text") then
			getglobal("CursorCastbarMain8Text"):Show()
		end
	else
		CursorCastbarStartBar(4, 5000, false, false, (GetTime() * 1000), (GetTime() * 1000) + 2500, " ", icon) 
		if getglobal("CursorCastbarMain8Text") then
			getglobal("CursorCastbarMain8Text"):Hide()
		end
	end
	
	if CursorCastbarOptionsSettings["CastBar"].ShowCastbar.Value == CursorCastbarOptionsCONSTChecked	then
		getglobal("CursorCastbarMainBar1"):Show()
		if CursorCastbarOptionsSettings["CastBar"].ShowLatency.Value == CursorCastbarOptionsCONSTChecked	then
			getglobal("CursorCastbarMainBar1Latency"):Show()
		else
			getglobal("CursorCastbarMainBar1Latency"):Hide()
		end 
	else
		getglobal("CursorCastbarMainBar1"):Hide()
	end 
	
	local IndicatorFrame = getglobal("CursorCastbarMain11")
	if CursorCastbarOptionsSettings["Indicator"].IndicatorShow.Value == CursorCastbarOptionsCONSTChecked	then
		IndicatorFrame:Show()
 		IndicatorFrame:SetScale(CursorCastbarOptionsSettings["Indicator"].IndicatorScale.Value/100)
		local flevel = getglobal("CursorCastbarMain"):GetFrameLevel() 
		IndicatorFrame:SetFrameLevel(flevel + CursorCastbarOptionsSettings["Indicator"].IndicatorLevel.Value)

		for i = 1,8 do
			_G["CursorCastbarMain11Indicator"..i]:SetVertexColor(CursorCastbarOptionsSettings["Indicator"]["Indicator"..i.."Color"].Value.r, CursorCastbarOptionsSettings["Indicator"]["Indicator"..i.."Color"].Value.g, CursorCastbarOptionsSettings["Indicator"]["Indicator"..i.."Color"].Value.b)
		end

		if CursorCastbarOptionsSettings["Indicator"].IndicatorLarge.Value == CursorCastbarOptionsCONSTChecked then
			for i = 1,8 do
				_G["CursorCastbarMain11Indicator"..i]:SetTexture("Interface\\Addons\\CursorCastbar\\BarTextures\\IndicatorLarge")
			end
		else
			for i = 1,8 do
				_G["CursorCastbarMain11Indicator"..i]:SetTexture("Interface\\Addons\\CursorCastbar\\BarTextures\\Indicator")
			end
		end

		
		local CurrentTime = GetTime()
		for x = 1, 8, 1 do 
			IndicatorTexture = getglobal("CursorCastbarMain11Indicator"..x)
			local rot = CursorCastbarOptionsSettings["Indicator"].IndicatorRotate.Value + (x * 10) - 10
			if CursorCastbarOptionsSettings["Indicator"].IndicatorLarge.Value == CursorCastbarOptionsCONSTChecked then
				rot = CursorCastbarOptionsSettings["Indicator"].IndicatorRotate.Value + (x * 15) - 15
			end
			CursorCastbarTransform(math.cos(math.rad(rot)), -math.sin(math.rad(rot)),0.5,math.sin(math.rad(rot)), math.cos(math.rad(rot)),0.5, 0.5, 0.5, 1, getglobal("IndicatorTexture"):GetName())
			IndicatorTexture:Hide()
			CursorCastbarIndicators[x].Visible = true 
			CursorCastbarIndicators[x].EndTime = CurrentTime + 2.5
			CursorCastbarIndicators[x].NextBlink = CurrentTime + CursorCastbarBlinkEach
		end
	else
		IndicatorFrame:Hide()
	end
	
--~ 	if CursorCastbarOptionsSettings["5 Sec Bar"].Show5SBar.Value == CursorCastbarOptionsCONSTChecked	then
--~ 		getglobal("CursorCastbarMainBar10"):Show()
--~ 	else
--~ 		getglobal("CursorCastbarMainBar10"):Hide()
--~ 	end 
	if CursorCastbarOptionsSettings["GCBar"].ShowGCBar.Value == CursorCastbarOptionsCONSTChecked	then
		getglobal("CursorCastbarMainBar2"):Show()
	else
		getglobal("CursorCastbarMainBar2"):Hide()
	end 
	if CursorCastbarOptionsSettings["MirrorBar"].ShowMB.Value == CursorCastbarOptionsCONSTChecked	then
		getglobal("CursorCastbarMainBar3"):Show()
	else
		getglobal("CursorCastbarMainBar3"):Hide()
	end 
	if CursorCastbarOptionsSettings["TargetBar"].Show.Value == CursorCastbarOptionsCONSTChecked	then
		getglobal("CursorCastbarMainBar4"):Show()
	else
		getglobal("CursorCastbarMainBar4"):Hide()
	end 
	if CursorCastbarOptionsSettings["SpellIcon"].ShowSpellIcon.Value == CursorCastbarOptionsCONSTChecked	then
		getglobal("CursorCastbarMainIcon1"):Show()
	else
		getglobal("CursorCastbarMainIcon1"):Hide()
	end 
	if CursorCastbarOptionsSettings["TargetIcon"].ShowSpellIcon.Value == CursorCastbarOptionsCONSTChecked	then
		getglobal("CursorCastbarMainIcon4"):Show()
	else
		getglobal("CursorCastbarMainIcon4"):Hide()
	end 
	
	local tEvents = {
					"UNIT_SPELLCAST_START",
					"UNIT_SPELLCAST_STOP",
					"UNIT_SPELLCAST_INTERRUPTED",
					"UNIT_SPELLCAST_FAILED",
					"UNIT_SPELLCAST_DELAYED",
					"UNIT_SPELLCAST_CHANNEL_START",
					"UNIT_SPELLCAST_CHANNEL_UPDATE",
					"UNIT_SPELLCAST_CHANNEL_STOP",
					"MIRROR_TIMER_START",
					"MIRROR_TIMER_PAUSE",
					"MIRROR_TIMER_STOP",
					}
	for _, event in pairs(tEvents) do
		if CursorCastbarOptionsSettings["Global"].HideBlizzard.Value == CursorCastbarOptionsCONSTChecked	then
			getglobal("CastingBarFrame"):UnregisterEvent(event)	
		else
			getglobal("CastingBarFrame"):RegisterEvent(event)
		end
	end					
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarOptionsOutputDropDown_OnLoad(frame, source, value)
	local tname = frame:GetName()
	UIDropDownMenu_Initialize(frame, function(self) 
										local entry = { func = function(self) CursorCastbarOptionsOutputDropDown_OnClick(self, tname) end }
                                        local i = 1
                                        while source[i] do  
                          
												entry.text = source[i]
												entry.value = value;
												if (UIDropDownMenu_GetSelectedValue(self) == entry.value) then
														entry.checked = true
												else
														entry.checked = nil
												end
												UIDropDownMenu_AddButton(entry)
                                                i = i + 1
										end	
									end);
	UIDropDownMenu_SetSelectedValue(frame, source[value], 1);
	UIDropDownMenu_SetSelectedID(frame, value);
	if CursorCastbartocVersion >= 30000 then
		UIDropDownMenu_SetText(frame, source[value])
	else
		UIDropDownMenu_SetText(source[value], frame)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarOptionsOutputDropDown_OnClick(self, tname)
	UIDropDownMenu_SetSelectedID(getglobal(tname), self:GetID())
	CursorCastbarOptionsSaveSettings(CursorCastbarOptionsActualOptionsTemplate)
    if CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsActualOptionsTemplate][string.sub(tname, string.find(tname, "Settings")+8)].OnClick then
        CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsActualOptionsTemplate][string.sub(tname, string.find(tname, "Settings")+8)].OnClick(self)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarOptionsShowOptionsHelp(self, framename, inout)
	if CursorCastbarOptionsSettings["Global"].CursorCastbarShowHelpTooltips.Value == CursorCastbarOptionsCONSTChecked	then
		local tLocale = "" 
		if CursorCastbarOptionsLocales[GetLocale()] then
			tLocale = GetLocale().."Help" 
		else
			tLocale = "enENHelp" 
		end
		if CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsActualOptionsTemplate][string.sub(framename, string.find(framename, "Settings")+8)][tLocale] ~= "" then
			if inout == true then
					CursorCastbarOptionsTooltip:ClearLines() 
					CursorCastbarOptionsTooltip:SetOwner(self)--, "ANCHOR_TOPLEFT") 
					CursorCastbarOptionsTooltip:AddLine(CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsActualOptionsTemplate][string.sub(framename, string.find(framename, "Settings")+8)][tLocale], 1, 1, 1, 1) 
					CursorCastbarOptionsTooltip:Show() 
			else
					CursorCastbarOptionsTooltip:ClearLines() 
					CursorCastbarOptionsTooltip:Hide() 
			end
		end
	else
		CursorCastbarOptionsTooltip:ClearLines() 
		CursorCastbarOptionsTooltip:Hide() 
	end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarOptionsHighlightButtons()
	for x = 1, CursorCastbarOptionsNoOptionsFrameTemplates, 1 do
		getglobal("CursorCastbarOptionsTabs"..CursorCastbarOptionsOptionsTemplate[x]):UnlockHighlight()  
	end
	getglobal("CursorCastbarOptionsTabs"..CursorCastbarOptionsActualOptionsTemplate):LockHighlight() 
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarOptionsLoadSettings()
	local tLocale = "" 
	if CursorCastbarOptionsLocales[GetLocale()] then
		tLocale = GetLocale() 
	else
		tLocale = "enEN" 
	end
	
--~ 	local kids = { getglobal("CursorCastbarOptionsTabsSettings"):GetChildren() }
	local kids = nil
    if ScrollContainerObj then 
        kids = { ScrollContainerObj.Content:GetChildren() } 
    end
	for _,child in ipairs(kids) do
        if string.find(child:GetName(), "Settings") then 
            child:Hide() 
        end
	end
    
	local tempSorttable = {} 
	for index in pairs(CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsActualOptionsTemplate]) do 
		table.insert(tempSorttable, index) 
	end
	table.sort(tempSorttable, 	function(a, b) 
									if CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsActualOptionsTemplate][a]["Sort"] < CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsActualOptionsTemplate][b]["Sort"] then
										return true 
									else
										return false 
									end
								end	
	) 	
	local tcoly = {[1] = -10, [2] = -10, [3] = -10, [4] = -10, [5] = -10, [6] = -10, };
	table.foreach(tempSorttable, 
		function(key, value)						
			local tvalue = "" 
			local ttype = "" 
			local tdescription = "" 
			local tmin = "" 
			local tmax = "" 
			local tstep = "" 
			local ttemplate = "" 
			local tOnValueChanged = nil 
			local tOnClick = nil 
			local tOnShow = nil 
			local tOnHide = nil 
			local tFrameName = nil 
			local tSmall = false 
			local tSource = nil
			local tFloat = false
			local tCol = 1
			table.foreach(CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsActualOptionsTemplate][value], 
				function(nkey, nvalue)
					if nkey == "Value" then
						tvalue = CursorCastbarOptionsSettings[CursorCastbarOptionsActualOptionsTemplate][value]["Value"] 
					end
					if nkey == "Type" then
						ttype = nvalue 
					end
					if nkey == "Template" then
						ttemplate = nvalue 
					end
					if nkey == tLocale.."Description" then
						tdescription = nvalue 
					end
					if nkey == "Min" then
						tmin = nvalue 
					end
					if nkey == "Max" then
						tmax = nvalue 
					end
					if nkey == "Step" then
						tstep = nvalue 
					end
					if nkey == "Template" then
						ttemplate = nvalue 
					end
					if nkey == "OnValueChanged" then
						tOnValueChanged = nvalue 
					end
					if nkey == "OnClick" then
						tOnClick = nvalue 
					end
					if nkey == "OnShow" then
						tOnShow = nvalue 
					end
					if nkey == "OnHide" then
						tOnHide = nvalue 
					end
					if nkey == "Col" then
						tCol = nvalue;
					end
					if nkey == "Small" then
						tSmall = nvalue 
					end
					if nkey == "Source" then
						tSource = nvalue 
					end
					if nkey == "Float" then
						tFloat = nvalue 
					end					
				end
			) 


            
            
            if value then	
                if CursorCastbarOptionsActualOptionsTemplate == "Profiles" and (value ~= "Profiles1Spec" and value ~= "Profiles2Spec") then
                    tvalue = CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsActualOptionsTemplate][value]["Value"]
                end
                if ttype == "Space" then
                    tcoly[tCol] = tcoly[tCol] - 10;
                else
                
--~ local tParentFrameObj = getglobal("CursorCastbarOptionsTabsSettings")
local tParentFrameObj = ScrollContainerObj.Content
                
                
                    local tframe = nil 
                    local taddspace = 0
                    if getglobal("CursorCastbarOptionsTabsSettings"..value) == Nil then
                        tframe = CreateFrame(ttype, "CursorCastbarOptionsTabsSettings"..value, tParentFrameObj, ttemplate) 
                    else
                        tframe = getglobal("CursorCastbarOptionsTabsSettings"..value) 
                    end
                    if getglobal("CursorCastbarOptionsTabsSettings"..value.."FS") then
                        getglobal("CursorCastbarOptionsTabsSettings"..value.."FS"):SetText(tdescription) 
                    end
                    
                    if ttemplate == "CursorCastbarOptionsCheckTemplate" or ttemplate == "CursorCastbarOptionsColorPickerTemplate" or ttemplate == "CursorCastbarOptionsClickButtonTemplate" then
                        tframe:SetScript("OnClick", tOnClick) 
                    end
                    if ttemplate == "CursorCastbarOptionsSliderTemplate" then
                        tframe:SetScript("OnValueChanged", tOnValueChanged) 
                        if tSmall == true then
                            tframe:SetWidth(115)
                        else
                            tframe:SetWidth(230)
                        end
                    end
                    tframe:SetScript("OnShow", tOnShow) 
                    tframe:SetScript("OnHide", tOnHide) 
    
                    if ttype == "Button" then
                        if ttemplate == "CursorCastbarOptionsDropdownTemplate" then
                            if tframe then
                                taddspace = taddspace + 8
                                CursorCastbarOptionsOutputDropDown_OnLoad(tframe, tSource, tvalue)
                                if CursorCastbartocVersion >= 30000 then
                                    UIDropDownMenu_SetButtonWidth(tframe, 100)
                                    UIDropDownMenu_SetWidth(tframe, 100)
                                else
                                    UIDropDownMenu_SetButtonWidth(100, tframe)
                                    UIDropDownMenu_SetWidth(100, tframe)
                                end
                                
                                if tOnClick then    
--~                                     tframe:SetScript("OnClick", tOnClick) 
                                end
                                
                            end
                        end
                        -- colorpicker
                        if ttemplate == "CursorCastbarOptionsColorPickerTemplate" then
                            tframe:SetBackdropColor(tvalue.r, tvalue.g, tvalue.b) 
                        end
                        -- simple button
                        if ttemplate == "CursorCastbarOptionsClickButtonTemplate" then
                            if tvalue ~= 0 then
                                tframe:SetText(tvalue) 
                            end
                            if tSmall == true then
                                tframe:SetWidth(100)
                            else
                                tframe:SetWidth(150)
                            end
                        end
                    end

                    local tempx = 8;
                    if tCol == 2 then
                        tempx = 70;
                    end
                    if tCol == 3 then
                        tempx = 240;
                    end
                    if tCol == 4 then
                        tempx = 250;
                    end
                    if tCol == 5 then
                        tempx = 300;
                    end
                    if tCol == 6 then
                        tempx = 215
                    end
                    
                    if ttype == "EditBox" then
                        tframe:SetPoint("TOPLEFT", tParentFrameObj ,"TOPLEFT",tempx + 6,tcoly[tCol]);
                        if tSmall == true then
                            tframe:SetWidth(40)
                            getglobal(tframe:GetName().."Middle"):SetWidth(40)
                        else
                            tframe:SetWidth(120)
                            getglobal(tframe:GetName().."Middle"):SetWidth(120)
                        end

                    elseif ttype == "CheckButton" then
                        tframe:SetPoint("TOPLEFT", tParentFrameObj ,"TOPLEFT",tempx ,tcoly[tCol]+2);
                    else
                        tframe:SetPoint("TOPLEFT", tParentFrameObj ,"TOPLEFT",tempx ,tcoly[tCol]);
                    end

                    if ttemplate == "CursorCastbarOptionsDropdownTemplate" then
                        tframe:SetPoint("TOPLEFT", tParentFrameObj ,"TOPLEFT",tempx-19,tcoly[tCol] - 4);
                    end
                    
                    if ttype == "Slider" then
                        tframe:SetMinMaxValues(tmin, tmax);
                        tframe:SetValueStep(tstep);
                        tframe:SetValue(tvalue);
                        getglobal(tframe:GetName().."High"):SetText(tmax);
                        getglobal(tframe:GetName().."Low"):SetText(tmin);
                        if tFloat ~= false then
                            getglobal(tframe:GetName().."FSVal"):SetText(string.format("%."..tFloat.."f", tvalue))
                        else
                            getglobal(tframe:GetName().."FSVal"):SetText(tvalue)
                        end
                    end
        
                    if ttype == "EditBox" then
                        tframe:SetMaxLetters(tmax);
                        tframe:SetText(tvalue);
                    end
                    if ttype == "Frame" then
                        getglobal("CursorCastbarOptionsTabsSettings"..value.."FS"):SetText(tdescription..": "..tvalue);
                    end
        
                    if ttype == "CheckButton" then
                        if tvalue == CursorCastbarOptionsCONSTChecked then
                            tframe:SetChecked(true);
                        elseif tvalue == CursorCastbarOptionsCONSTUnChecked then
                            tframe:SetChecked(false);
                        end
                    end

                    tframe:Show();
                    tcoly[tCol] = tcoly[tCol] - 22 - taddspace
                end
            end
		end
	) 
    
    local theight = 0
    table.foreach(tcoly,    function(i, v) 
                                if v < theight then 
                                    theight = v 
                                end
                            end)
    ScrollContainerObj.Content:SetHeight((theight * -1)*1.1)
    
    
    
    
    CursorCastbarOptionsSettingsTemplate["Profiles"]["Profiles1Spec"].Source = CursorCastbarOptionsProfileNames
    CursorCastbarOptionsSettingsTemplate["Profiles"]["Profiles2Spec"].Source = CursorCastbarOptionsProfileNames
    
    
    
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarOptionsSaveSettings()
	local kids = { ScrollContainerObj.Content:GetChildren() }  -- get all options
    
	for _,child in ipairs(kids) do
		if child:IsVisible() then 
            if string.find(child:GetName(), "Settings") then 
                if CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsActualOptionsTemplate] then
                    
                    
                    if CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsActualOptionsTemplate][string.sub(child:GetName(), string.find(child:GetName(), "Settings")+8)] then

if CursorCastbarOptionsActualOptionsTemplate ~= "Profiles" or (string.sub(child:GetName(), string.find(child:GetName(), "Settings")+8) == "Profiles1Spec" or string.sub(child:GetName(), string.find(child:GetName(), "Settings")+8) == "Profiles2Spec") then

                            if CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsActualOptionsTemplate][string.sub(child:GetName(), string.find(child:GetName(), "Settings")+8)].Type == "Button" and CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsActualOptionsTemplate][string.sub(child:GetName(), string.find(child:GetName(), "Settings")+8)].Template == "CursorCastbarOptionsColorPickerTemplate" then
                                local r, g, b = child:GetBackdropColor() 
                                CursorCastbarOptionsSettings[CursorCastbarOptionsActualOptionsTemplate][string.sub(child:GetName(), string.find(child:GetName(), "Settings")+8)].Value.r = r 
                                CursorCastbarOptionsSettings[CursorCastbarOptionsActualOptionsTemplate][string.sub(child:GetName(), string.find(child:GetName(), "Settings")+8)].Value.g = g 
                                CursorCastbarOptionsSettings[CursorCastbarOptionsActualOptionsTemplate][string.sub(child:GetName(), string.find(child:GetName(), "Settings")+8)].Value.b = b 
                            end
                            if CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsActualOptionsTemplate][string.sub(child:GetName(), string.find(child:GetName(), "Settings")+8)].Type == "Slider" then
                                CursorCastbarOptionsSettings[CursorCastbarOptionsActualOptionsTemplate][string.sub(child:GetName(), string.find(child:GetName(), "Settings")+8)].Value = child:GetValue() 
                            end
                            if CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsActualOptionsTemplate][string.sub(child:GetName(), string.find(child:GetName(), "Settings")+8)].Type == "Button" and CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsActualOptionsTemplate][string.sub(child:GetName(), string.find(child:GetName(), "Settings")+8)].Template == "CursorCastbarOptionsDropdownTemplate" then
                                CursorCastbarOptionsSettings[CursorCastbarOptionsActualOptionsTemplate][string.sub(child:GetName(), string.find(child:GetName(), "Settings")+8)].Value = UIDropDownMenu_GetSelectedID(child)
                            end
                            if CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsActualOptionsTemplate][string.sub(child:GetName(), string.find(child:GetName(), "Settings")+8)].Type == "CheckButton" then
                                if child:GetChecked() == 1 then
                                    CursorCastbarOptionsSettings[CursorCastbarOptionsActualOptionsTemplate][string.sub(child:GetName(), string.find(child:GetName(), "Settings")+8)].Value = CursorCastbarOptionsCONSTChecked 
                                end
                                if child:GetChecked() == nil then
                                    CursorCastbarOptionsSettings[CursorCastbarOptionsActualOptionsTemplate][string.sub(child:GetName(), string.find(child:GetName(), "Settings")+8)].Value = CursorCastbarOptionsCONSTUnChecked 
                                end
                            end
                            if CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsActualOptionsTemplate][string.sub(child:GetName(), string.find(child:GetName(), "Settings")+8)].Type == "EditBox" then
                                CursorCastbarOptionsSettings[CursorCastbarOptionsActualOptionsTemplate][string.sub(child:GetName(), string.find(child:GetName(), "Settings")+8)].Value = child:GetText() 
                            end
end
                    end
                end                
            end            
		end
	end
	
	
	
	CursorCastbarOptionsSettings["Anchors"] = {}
	for q = 1, getglobal("CursorCastbarMain"):GetNumPoints(), 1 do
		a, p, pa, x, y = getglobal("CursorCastbarMain"):GetPoint(q) 
		if a then
			if p then
				p = p:GetName()
			else
				p = "nil"
			end
			pa = pa or "nil"
			x = x or "nil"
			y = y or "nil"
			table.insert(CursorCastbarOptionsSettings["Anchors"], 	{ 
																["a"] = a,
																["p"] = p,
																["pa"] = pa,
																["x"] = x,
																["y"] = y,
																})
		end
	end
	
	
	CursorCastbarUpdateVisuals()
	CursorCastbarCurrentMana = 100000
    
    
local CursorCastbarCurrentSpec = GetActiveTalentGroup()
if CursorCastbarOptionsSettings["Profiles"]["Profiles"..CursorCastbarCurrentSpec.."Spec"].Value and CursorCastbarCurrentSpec then
    CursorCastbarOptionsSaveProfile(CursorCastbarOptionsProfileNames[CursorCastbarOptionsSettings["Profiles"]["Profiles"..CursorCastbarCurrentSpec.."Spec"].Value])
end
    

end
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- called with framname for self the colorpicker is opened 
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarOptionsColorPickerPrepare(target)
	CursorCastbarOptionsOptionsColorPickerActualFrame = target 
	local r,g,b,a = getglobal(target):GetBackdropColor() 
	ColorPickerFrame.previousValues = {r,g,b} 
	ColorPickerFrame.func = CursorCastbarOptionsColorPickerChangeColor 
	ColorPickerFrame.cancelFunc = CursorCastbarOptionsColorPickerCancel 
	ColorPickerFrame.hasOpacity = false 
	ColorSwatch:SetTexture(getglobal(target):GetBackdropColor()) 
	ColorPickerFrame:SetColorRGB(getglobal(target):GetBackdropColor()) 
	ColorPickerFrame:Show() 	
end
--------------------------------------------------------------------------------------------------------------------------------
-- color selected - set it
--------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarOptionsColorPickerChangeColor()
	getglobal(CursorCastbarOptionsOptionsColorPickerActualFrame):SetBackdropColor(ColorPickerFrame:GetColorRGB()) 
	CursorCastbarOptionsSaveSettings() 
end
--------------------------------------------------------------------------------------------------------------------------------
-- cancel - set the old color
--------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarOptionsColorPickerCancel(prevvals)
	getglobal(CursorCastbarOptionsOptionsColorPickerActualFrame):SetBackdropColor(unpack(prevvals)) 
	ColorPickerFrame:Hide() 
	CursorCastbarOptionsSaveSettings() 
	CursorCastbarOptionsOptionsColorPickerActualFrame = "" 
end
------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------
function CursorCastbarOptionsOpenOnLoad(self)
    CursorCastbarOptionsInitOption(self)
    CursorCastbarOptionsInitAll()
    _G[self:GetName()]:RegisterEvent("VARIABLES_LOADED") 
end
------------------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------
function CursorCastbarOptionsOpenOnEvent(self, event, ...)
	local panel = getglobal("CursorCastbarOptions")
	panel.name = "CursorCastbar" 
	panel:ClearAllPoints()
	InterfaceOptions_AddCategory(panel) 
    
    CursorCastbarOptionsUpdate()
    CursorCastbarOptionsSaveProfile(true)
    CursorCastbarOptionsLoadSettings() 
    CursorCastbarUpdateVisuals()
end
--------------------------------------------------------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarOptionsUpdate()
	for x = 1, CursorCastbarOptionsNoOptionsFrameTemplates, 1 do
        if not CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]] then
			CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]] = {} 
		end

		table.foreach(CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsOptionsTemplate[x]], 
			function(key, value)
				if not CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]][key] then
					CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]][key] = {} 
				end
				table.foreach(value, 
					function(tkey, tvalue)
						if tkey == "Value" then
							if not CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]][key][tkey] then

								CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]][key][tkey] = tvalue
							end
						end
					end) 
			end
		) 
	end
		
end
--------------------------------------------------------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarOptionsInitAll()
	local tframe = nil 
	local y = -5 
	local xs = 0 
	for x = 1, CursorCastbarOptionsNoOptionsFrameTemplates, 1 do
        if not CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]] then
			CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]] = {} 
		end

		table.foreach(CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsOptionsTemplate[x]], 
			function(key, value)
				if not CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]][key] then
					CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]][key] = {} 
				end
				table.foreach(value, 
					function(tkey, tvalue)
						if tkey == "Value" then
							if not CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]][key][tkey] then

								CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]][key][tkey] = tvalue 
							end
						end
					end) 
			end
		) 
	end
		
	for x = 1, CursorCastbarOptionsNoOptionsFrameTemplates, 1 do
		for x = 1, CursorCastbarOptionsNoOptionsFrameTemplates, 1 do
			if CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]] then
				table.foreach(CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]], 
					function(key, value)
						if CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsOptionsTemplate[x]][key] == nil then
							CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]][key] = Nil 
						end
					end
				) 
			end
		end
		
		if getglobal("CursorCastbarOptionsTabs"..CursorCastbarOptionsOptionsTemplate[x]) then
			tframe = getglobal("CursorCastbarOptionsTabs"..CursorCastbarOptionsOptionsTemplate[x]) 
		else
			tframe = CreateFrame("Button", "CursorCastbarOptionsTabs"..CursorCastbarOptionsOptionsTemplate[x], getglobal("CursorCastbarOptionsTabs"), "UIPanelButtonTemplate") 
		end

		if x == 6 or x == 11 then 
			y = y - 30 
			xs = (((x-1)*75)) 
		end
		tframe:SetPoint("TOPLEFT", "CursorCastbarOptionsTabs", "TOPLEFT" , (((x-1)*75)+5) - xs, y) 
		tframe:SetWidth(76) 
		tframe:SetHeight(33) 
--~ 		tframe:SetFont("GameFontWhite", 5)
		tframe:SetText(CursorCastbar_Locale["OptionsLabels"][x]) 
		tframe.InternalName = CursorCastbarOptionsOptionsTemplate[x]
		tframe:SetScript("OnClick", function(self)
			CursorCastbarOptionsSaveSettings() 
			CursorCastbarOptionsActualOptionsTemplate = self.InternalName
			CursorCastbarOptionsHighlightButtons() 
			CursorCastbarOptionsLoadSettings() 
		end) 
	end
	
    ScrollContainerObj = CursorCastbarOptionsCreateContainer("ScrollFrame", _G["CursorCastbarOptionsTabs"], 340)
    ScrollContainerObj.Content:SetHeight(340)
    ScrollContainerObj:SetPoint("TOPLEFT", "CursorCastbarOptionsTabs", "TOPLEFT", 10, -100) 
    
	CursorCastbarOptionsHighlightButtons() 
	CursorCastbarOptionsLoadSettings() 
	CursorCastbarUpdateVisuals()
end
--------------------------------------------------------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarOptionsReset()
	CursorCastbarOptionsSettings = {} 														
	CursorCastbarOptionsActualOptionsTemplate = CursorCastbarOptionsOptionsTemplate[1] 				
	CursorCastbarOptionsOptionsColorPickerActualFrame = ""  								
	local y = -5 
	local xs = 0 
	for x = 1, CursorCastbarOptionsNoOptionsFrameTemplates, 1 do
		CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]] = {} 
		table.foreach(CursorCastbarOptionsSettingsTemplate[CursorCastbarOptionsOptionsTemplate[x]], 
			function(key, value)
				if not CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]][key] then
					CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]][key] = {} 
				end
				table.foreach(value, 
					function(tkey, tvalue)
						if tkey == "Value" then
							if not CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]][key][tkey] then
								CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]][key][tkey] = tvalue 
							end
						end
					end) 
			end
		) 
	end
	CursorCastbarOptionsHighlightButtons() 
	CursorCastbarOptionsLoadSettings() 
	CursorCastbarUpdateVisuals()	
end	
--------------------------------------------------------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarOptionsLoadProfile(argProfileName)
    if argProfileName then
        if argProfileName == "" then
            DEFAULT_CHAT_FRAME:AddMessage("CursorCastbar: "..CursorCastbar_Locale["NoName"])
        end
        if not CursorCastbarOptionsProfiles[argProfileName] then
            DEFAULT_CHAT_FRAME:AddMessage("CursorCastbar: "..CursorCastbar_Locale["WrongName"])
            return
        end

        for x = 1, CursorCastbarOptionsNoOptionsFrameTemplates, 1 do
            if CursorCastbarOptionsProfiles[argProfileName][CursorCastbarOptionsOptionsTemplate[x]] then
                if CursorCastbarOptionsOptionsTemplate[x] ~= "Profiles" then
                    table.foreach(CursorCastbarOptionsProfiles[argProfileName][CursorCastbarOptionsOptionsTemplate[x]], 
                        function(key, value)
                            table.foreach(value, 
                                function(tkey, tvalue)
                                    if tkey == "Value" --[[and (type(tvalue)=="string" or type(tvalue)=="number")]] then
										if x == nil or key == nil or tkey == nil or tvalue == nil then
											print("|cffff0000CursorCastBar|r: A part of your config seems corrupted. Please open the config menu and recheck your settings!")
										else
										--	print("x: "..x.." - key: "..key.." - tkey: "..tkey) print("tvalue: "..tvalue)
											CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]][key][tkey] = tvalue
										end
								--[=[	else
										print("The following table content is no number/string:")
										print("x: "..x) print("key: "..key) print("tkey: "..tkey) 
										print("typetvalue: "..type(tvalue))
										print(tvalue)
										CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]][key][tkey] = tvalue]=]
                                    end
                                end
                            ) 
                        end
                    ) 
                end
            end
        end
    else
        DEFAULT_CHAT_FRAME:AddMessage("CursorCastbar: "..CursorCastbar_Locale["NoName"])
	end
	CursorCastbarOptionsHighlightButtons() 
	CursorCastbarOptionsLoadSettings() 
	CursorCastbarUpdateVisuals()	
    
end	
--------------------------------------------------------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarOptionsSaveProfile(argProfileName)
    if argProfileName then
        
        local tProfileName = nil
        
        if argProfileName == true then
            if CursorCastbarOptionsProfileNames[1] == nil then
                tProfileName = "Default"
            else
                return
            end
        else
            tProfileName = argProfileName
        end
        
        if tProfileName == "" then
            DEFAULT_CHAT_FRAME:AddMessage("CursorCastbar: "..CursorCastbar_Locale["NoName"])
            return
        end
        
        if not CursorCastbarOptionsProfiles[tProfileName] then
            CursorCastbarOptionsProfiles[tProfileName] = {}
            table.insert(CursorCastbarOptionsProfileNames, tProfileName)
        end
        
        for x = 1, CursorCastbarOptionsNoOptionsFrameTemplates, 1 do
            if CursorCastbarOptionsOptionsTemplate[x] ~= "Profiles" then
                if not CursorCastbarOptionsProfiles[tProfileName][CursorCastbarOptionsOptionsTemplate[x]] then
                    CursorCastbarOptionsProfiles[tProfileName][CursorCastbarOptionsOptionsTemplate[x]] = {} 
                end

                table.foreach(CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]], 
                    function(key, value)
                        if not CursorCastbarOptionsProfiles[tProfileName][CursorCastbarOptionsOptionsTemplate[x]][key] then
                            CursorCastbarOptionsProfiles[tProfileName][CursorCastbarOptionsOptionsTemplate[x]][key] = {} 
                        end
                        table.foreach(value, 
                            function(tkey, tvalue)
                                if tkey == "Value" then
                                    CursorCastbarOptionsProfiles[tProfileName][CursorCastbarOptionsOptionsTemplate[x]][key][tkey] = tvalue 
                                end
                            end
                        ) 
                    end
                ) 
            end            
        end
            
        for x = 1, CursorCastbarOptionsNoOptionsFrameTemplates, 1 do
            for x = 1, CursorCastbarOptionsNoOptionsFrameTemplates, 1 do
                if CursorCastbarOptionsOptionsTemplate[x] ~= "Profiles" then
                    if CursorCastbarOptionsProfiles[tProfileName][CursorCastbarOptionsOptionsTemplate[x]] then
                        table.foreach(CursorCastbarOptionsProfiles[tProfileName][CursorCastbarOptionsOptionsTemplate[x]], 
                            function(key, value)
                                if CursorCastbarOptionsSettings[CursorCastbarOptionsOptionsTemplate[x]][key] == nil then
                                    CursorCastbarOptionsProfiles[tProfileName][CursorCastbarOptionsOptionsTemplate[x]][key] = Nil 
                                end
                            end
                        ) 
                    end
                end                
            end
        end
    else
        DEFAULT_CHAT_FRAME:AddMessage("CursorCastbar: "..CursorCastbar_Locale["NoName"])
        return
	end
end	
-------------------------------------------------------------------------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarOptionsCreateContainer(argFrameName, argParentObj, argContentHeight)    
    local scrollFrameObj = CreateFrame("ScrollFrame", "ScrollFrame", argParentObj)
    scrollFrameObj.ScrollValue = 0
    scrollFrameObj:SetPoint("TOPLEFT", argParentObj, "TOPLEFT")
    scrollFrameObj:SetPoint("BOTTOMRIGHT", argParentObj, "BOTTOMRIGHT")
    scrollFrameObj:EnableMouse(true)
    scrollFrameObj:EnableMouseWheel(true)
    scrollFrameObj:SetScript("OnMouseWheel",    function(self, value) -- down -1   up 1
                                                    local tParentHeight = _G["InterfaceOptionsFramePanelContainer"]:GetHeight() - 120
                                                    local tContentHeight = self.Content:GetHeight()
                                                    local tmp = self.ScrollValue
                                                    tmp = tmp + (-1 * (value * 20))
                                                    if tmp < 0 then tmp = 0 end
                                                    if tmp > 1000 then tmp = 1000 end
                                                    local diff = tContentHeight-tParentHeight
                                                    if diff > 0 then
                                                        if tmp > diff then tmp = diff end
                                                        self.ScrollValue = tmp
                                                        self.ScrollBar:SetValue(((1000/diff) * self.ScrollValue))
                                                    else
                                                        self.ScrollValue = 0
                                                        self.ScrollBar:SetValue(0)
                                                    end
                                                end)
    scrollFrameObj:SetScript("OnUpdate",    function(self)
                                                self.Content:ClearAllPoints()
                                                self.Content:SetPoint("TOPLEFT", 0, self.ScrollValue)
                                                self.Content:SetPoint("TOPRIGHT", 0, self.ScrollValue)
                                            end)
    
    local scrollbarObj = CreateFrame("Slider", "ScrollBar", scrollFrameObj, "UIPanelScrollBarTemplate")
    scrollFrameObj.ScrollBar = scrollbarObj
    scrollbarObj:SetPoint("TOPRIGHT", argParentObj, "TOPRIGHT", -7, -120)
    scrollbarObj:SetPoint("BOTTOMRIGHT", argParentObj, "BOTTOMRIGHT", -7, 16)
    scrollbarObj:SetMinMaxValues(0, 1000)
    scrollbarObj:SetValueStep(1)
    scrollbarObj:SetValue(0)
    scrollbarObj:SetWidth(16)
    scrollbarObj:Show()
    scrollbarObj:SetScript("OnValueChanged",    function(self, value)  
                                                    local tParent = self:GetParent()
                                                    local tParentHeight = _G["InterfaceOptionsFramePanelContainer"]:GetHeight() - 120
                                                    local tContentHeight = tParent.Content:GetHeight()
                                                    local diff = tContentHeight-tParentHeight
                                                    local tmp = (value / (1000/diff))
                                                    if diff > 0 then
                                                        if tmp > diff then tmp = diff end
                                                        tParent.ScrollValue = tmp
                                                        tParent.ScrollBar:SetValue(((1000/diff) * tParent.ScrollValue))
                                                    else
                                                        tParent.ScrollValue = 0
                                                        tParent.ScrollBar:SetValue(0)
                                                    end
                                                end)
    
    local contentObj = CreateFrame("Frame", "Content", scrollFrameObj)
    scrollFrameObj.Content = contentObj
    contentObj:SetHeight(argContentHeight)
    scrollFrameObj:SetScrollChild(contentObj)
    contentObj:Show() 

    return scrollFrameObj
end
-------------------------------------------------------------------------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarOptionsInitOption(self)
    CursorCastbarOptionsOptionsTemplate =   {
                                            "Global", "CastBar", "SpellText", "SpellIcon", "GCBar", "MirrorBar",
                                            "TargetBar", "TargetText", "TargetIcon", "Indicator", "Profiles"
                                            } 		
    CursorCastbarOptionsCONSTChecked = 1 												
    CursorCastbarOptionsCONSTUnChecked = -1 											
    CursorCastbarOptionsCONSTSaveValue = false 											
    CursorCastbarOptionsNoOptionsFrameTemplates = table.getn(CursorCastbarOptionsOptionsTemplate)
    CursorCastbarOptionsActualOptionsTemplate = CursorCastbarOptionsOptionsTemplate[1] 			
    CursorCastbarOptionsOptionsColorPickerActualFrame = ""  							
    CursorCastbarOptionsLocales = {enEN = true, deDE = true,} 
--~     CursorCastbarOptionsSettings = {} 													

--~ CursorCastbarOptionsProfiles = {ProfileNames = {}}
--~ CursorCastbarOptionsProfileNames = {}

    CursorCastbarOptionsSettingsTemplate = {}  											

    CursorCastbarOptionsSettingsTemplate["Global"] = 	
        {
        Enabled =	{
                        Sort = 1,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "Activate/deactivate addon",
                        enENDescription = "Enable",
                        deDEHelp = "Addon aktivieren/deaktivieren",
                        deDEDescription = "Aktivieren",
                        },
        Scale  = {
                        Sort = 2,
                        Type = "Slider", Value = 1, Min = 0.2, Max = 2, Step = 0.1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.2f", self:GetValue())) 
                                        end,
                        enENHelp = "Scale of the cast bar, global cooldown bar, and cast time",
                        enENDescription = "Overall Scale",
                        deDEHelp = "Skalierung der Castbar, der Global-Cooldown-Bar und der Castzeit",
                        deDEDescription = "Gesamtskalierung",
                        },
        Opacity  = {
                        Sort = 3,
                        Type = "Slider", Value = 100, Min = 0, Max = 100, Step = 5, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.2f", self:GetValue())) 
                                        end,
                        enENHelp = "Opacity for all components",
                        enENDescription = "Opacity",
                        deDEHelp = "Tranzsparenz aller Elemente",
                        deDEDescription = "Deckkraft",
                        },		
        Anchor = 		{
                        Sort = 4,  
                        Type = "Button", Value = 1, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbar_Locale["AnchorNames"], Col = 1,
                        enENHelp = "",
                        enENDescription = "Anchor Point",
                        deDEHelp = "",
                        deDEDescription = "Ankerpunkt",
                        },
        Locked =	{
                        Sort = 5,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "Locks/unlocks all cast bar frames (movable\not movable). self option is only valid if the option 'Anchor Point' is set to 'Movable'.",
                        enENDescription = "Locked",
                        deDEHelp = "Sperrt-/Entsperrt alle Castbar Frames (verschiebbar\nicht verschiebbar). Diese option ist nur gueltig wenn die Option 'Ankerpunkt' auf 'Movable' gesetzt ist.",
                        deDEDescription = "Gesperrt",
                        },
        HideBlizzard =	{
                        Sort = 6,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "",
                        enENDescription = "Hide Blizzard Cast Bar",
                        deDEHelp = "",
                        deDEDescription = "Blizzard Castbar verstecken",
                        },					
        CursorCastbarShowHelpTooltips =	{
                        Sort = 7,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "Show a tooltip for every CursorCastbar setting",
                        enENDescription = "Help Tooltips",
                        deDEHelp = "Zeigt diese Hilfe-Tooltips fuer die Optionen an",
                        deDEDescription = "Hilfe Tooltips",
                        },
        Reset = 		{
                        Sort = 8,
                        Type = "Button", Value = "Reset", Min = 0, Max = 0, Template = "CursorCastbarOptionsClickButtonTemplate",
                        OnClick = 	function(self)  
                                        CursorCastbarOptionsReset() 
                                    end,
                        enENHelp = "All settings will be set to default",
                        enENDescription = "Default Settings", 
                        deDEHelp = "Setzt alle Einstellungen auf die Standardwerte zurueck",
                        deDEDescription = "Standardeinstellungen",
                        },						
        } 
    CursorCastbarOptionsSettingsTemplate["CastBar"] = 	
        {
        ShowCastbar =	{
                        Sort = 1,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "",
                        enENDescription = "Show Cast Bar",
                        deDEHelp = "",
                        deDEDescription = "Cast Bar anzeigen",
                        },	
        CBScale  = {
                        Sort = 2,
                        Type = "Slider", Value = 78, Min = 20, Max = 150, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.2f", self:GetValue())) 
                                        end,
                        enENHelp = "Scale of the cast bar",
                        enENDescription = "CB Scale",
                        deDEHelp = "Skalierung der Castbar",
                        deDEDescription = "CB-Skalierung",
                        },
        TextureCB = 	{
                        Sort = 3,  
                        Type = "Button", Value = 7, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbar_Locale["TextureNames"], Col = 1,
                        enENHelp = "",
                        enENDescription = "CB Texture",
                        deDEHelp = "",
                        deDEDescription = "CB-Textur",
                        },
        Level  = {
                        Sort = 3.1,
                        Type = "Slider", Value = 2, Min = 1, Max = 10, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Drawing Level",
                        deDEHelp = "",
                        deDEDescription = "Darstellungsebene",
                        },						
        CBStaticColor =	{
                        Sort = 3.2,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "",
                        enENDescription = "Static color",
                        deDEHelp = "",
                        deDEDescription = "Feste Farbe",
                        },					
        CBColor = 	{
                        Sort = 3.3,
                        Type = "Button", Value = {r = 1, g = 1, b = 1}, Min = 0, Max = 0, Template = "CursorCastbarOptionsColorPickerTemplate", Col = 1,
                        OnClick = function(self) CursorCastbarOptionsColorPickerPrepare(self:GetName()); end,
                        enENHelp = "",
                        enENDescription = "Color",
                        deDEHelp = "",
                        deDEDescription = "Farbe",
                        },
		Direction = 		{
                        Sort = 3.5,  
                        Type = "Button", Value = 1, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbar_Locale["Directions"], Col = 1,
                        enENHelp = "",
                        enENDescription = "Direction",
                        deDEHelp = "",
                        deDEDescription = "Richtung",
                        },
		Rotation  = {
                        Sort = 3.6,
                        Type = "Slider", Value = 0, Min = 0, Max = 270, Step = 90, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Rotation",
                        deDEHelp = "",
                        deDEDescription = "Rotation",
                        },
        SubtractLag =	{
                        Sort = 4,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "Subtracts the network latency (lag) from cast time. To start the next cast before the current is finished.",
                        enENDescription = "Subtract Latency",
                        deDEHelp = "Zieht die Netzwerklatenz von der Castzeit ab um schon vor Abschluss des laufenden Zaubers einen neuen Zauber starten zu köennen",
                        deDEDescription = "Latenz abziehen",
                        },
        ShowLatency =	{
                        Sort = 4.5,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "Shows the network latency within the cast bar (lag). To start the next cast before the current is finished.",
                        enENDescription = "Show Latency",
                        deDEHelp = "Zeigt die Netzwerklatenz innerhalb der Castbar an, um schon vor Abschluss des laufenden Zaubers einen neuen Zauber starten zu köennen",
                        deDEDescription = "Latenz anzeigen",
                        },
        ShowNumber =	{
                        Sort = 5,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "",
                        enENDescription = "Show Cast Time As Number",
                        deDEHelp = "",
                        deDEDescription = "Castzeit als Zahl anzeigen",
                        },
        FSScale  = {
                        Sort = 6,
                        Type = "Slider", Value = 11, Min = 5, Max = 25, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.0f", self:GetValue())) 
                                        end,
                        enENHelp = "Scale of the cast time number",
                        enENDescription = "Number Scale",
                        deDEHelp = "Skalierung der Castzeit-Zahl",
                        deDEDescription = "Zahl Skalierung",
                        },						
        FSx  = {
                        Sort = 7,
                        Type = "Slider", Value = 0, Min = -100, Max = 100, Step = 5, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.0f", self:GetValue())) 
                                        end,
                        enENHelp = "x position of remaining cast time number",
                        enENDescription = "Number X Pos ",
                        deDEHelp = "x position der verbleibenden Zauberzeit",
                        deDEDescription = "Zahl X-Pos",
                        },						
        FSy  = {
                        Sort = 8,
                        Type = "Slider", Value = 25, Min = -100, Max = 100, Step = 5, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.0f", self:GetValue())) 
                                        end,
                        enENHelp = "y Position of remaining cast time number",
                        enENDescription = "Number Y Pos",
                        deDEHelp = "y position der verbleibenden Zauberzeit",
                        deDEDescription = "Zahl Y-Pos",
                        },										
        } 
    CursorCastbarOptionsSettingsTemplate["SpellText"] = 	
        {
        ShowSpellName =	{
                        Sort = 9,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
    --~ if self:GetChecked() ~= 1 then
    --~ DEFAULT_CHAT_FRAME:AddMessage("d")
    --~ 		CursorCastbarStartBar(1, 5000, false, false, (GetTime() * 1000), (GetTime() * 1000) + 2500, " ", icon) 
    --~ 		CursorCastbarUpdateVisuals()
    --~ end
                                    end,
                        enENHelp = "",
                        enENDescription = "Show Spell Name",
                        deDEHelp = "",
                        deDEDescription = "Zaubersname anzeigen",
                        },					
        Level  = {
                        Sort = 9.1,
                        Type = "Slider", Value = 4, Min = 1, Max = 10, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Drawing Level",
                        deDEHelp = "",
                        deDEDescription = "Darstellungsebene",
                        },						
        SpellStringColor = 	{
                        Sort = 10,
                        Type = "Button", Value = {r = 1, g = 1, b = 1}, Min = 0, Max = 0, Template = "CursorCastbarOptionsColorPickerTemplate", 
                        OnClick = function(self) CursorCastbarOptionsColorPickerPrepare(self:GetName()); end,
                        enENHelp = "",
                        enENDescription = "Spell Color",
                        deDEHelp = "Farbe des Zaubertextes",
                        deDEDescription = "Text Farbe",
                        },
        Radius  = {
                        Sort = 11,
                        Type = "Slider", Value = "34", Min = "1", Max = "200", Step = "1", Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "Radius of spell string",
                        enENDescription = "Spell Radius",
                        deDEHelp = "Radius des Zaubertextes",
                        deDEDescription = "Text Radius",
                        },	
        Charsize  = {
                        Sort = 12,
                        Type = "Slider", Value = "15", Min = "10", Max = "50", Step = "1", Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "Char size of spell string",
                        enENDescription = "Spell Size",
                        deDEHelp = "Groesse der zeichen fuer den Zaubertext",
                        deDEDescription = "Text Groesse",
                        },	
        Charspace  = {
                        Sort = 13,
                        Type = "Slider", Value = -9, Min = -20, Max = -2, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "Space between chars for spell string",
                        enENDescription = "Spell Space",
                        deDEHelp = "Zwischenraum zwischen den Zeichen fuer den Zaubertext",
                        deDEDescription = "Text zwischenr.",
                        },	
        Rotanchor  = {
                        Sort = 14,
                        Type = "Slider", Value = "190", Min = "0", Max = "360", Step = "10", Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "Spell string anchor ",
                        enENDescription = "Spell Anchor",
                        deDEHelp = "Anker fuer den Zaubertext",
                        deDEDescription = "Text Anker",
                        },						
        }
    CursorCastbarOptionsSettingsTemplate["SpellIcon"] = 	
        {
        ShowSpellIcon =	{
                        Sort = 1,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "",
                        enENDescription = "Show Spell Icon",
                        deDEHelp = "",
                        deDEDescription = "Zaubersymbol anzeigen",
                        },					
        Level  = {
                        Sort = 1.1,
                        Type = "Slider", Value = 3, Min = 1, Max = 10, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Drawing Level",
                        deDEHelp = "",
                        deDEDescription = "Darstellungsebene",
                        },						
        IconScale  = {
                        Sort = 6,
                        Type = "Slider", Value = 9, Min = 5, Max = 50, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.0f", self:GetValue())) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Icon Scale",
                        deDEHelp = "",
                        deDEDescription = "Symbol Skalierung",
                        },						
        Iconx  = {
                        Sort = 7,
                        Type = "Slider", Value = -32, Min = -50, Max = 50, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.0f", self:GetValue())) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Icon X Pos ",
                        deDEHelp = "",
                        deDEDescription = "Symbol X-Pos",
                        },						
        Icony  = {
                        Sort = 8,
                        Type = "Slider", Value = -4, Min = -50, Max = 50, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.0f", self:GetValue())) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Icon Y Pos ",
                        deDEHelp = "",
                        deDEDescription = "Symbol Y-Pos",
                        },			
        }
    CursorCastbarOptionsSettingsTemplate["GCBar"] = 	
        {
        ShowGCBar =	{
                        Sort = 1,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "",
                        enENDescription = "Show GC",
                        deDEHelp = "",
                        deDEDescription = "GC anzeigen",
                        },
        GCScale  = {
                        Sort = 2,
                        Type = "Slider", Value = 50, Min = 20, Max = 150, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.2f", self:GetValue())) 
                                        end,
                        enENHelp = "Scale of the global cooldown bar",
                        enENDescription = "GC Scale",
                        deDEHelp = "Skalierung der Global-Cooldown-Bar",
                        deDEDescription = "GC-Skalierung",
                        },	
        TextureGC = 	{
                        Sort = 3,  
                        Type = "Button", Value = 1, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbar_Locale["TextureNames"], Col = 1,
                        enENHelp = "",
                        enENDescription = "Texture",
                        deDEHelp = "",
                        deDEDescription = "Textur",
                        },
        Level  = {
                        Sort = 3.1,
                        Type = "Slider", Value = 2, Min = 1, Max = 10, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Drawing Level",
                        deDEHelp = "",
                        deDEDescription = "Darstellungsebene",
                        },						
        GCStaticColor =	{
                        Sort = 3.2,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "",
                        enENDescription = "Static color",
                        deDEHelp = "",
                        deDEDescription = "Feste Farbe",
                        },					
        GCColor = 	{
                        Sort = 3.3,
                        Type = "Button", Value = {r = 1, g = 1, b = 1}, Min = 0, Max = 0, Template = "CursorCastbarOptionsColorPickerTemplate", Col = 1,
                        OnClick = function(self) CursorCastbarOptionsColorPickerPrepare(self:GetName()); end,
                        enENHelp = "",
                        enENDescription = "Color",
                        deDEHelp = "",
                        deDEDescription = "Farbe",
                        },
        Direction = 		{
                        Sort = 3.5,  
                        Type = "Button", Value = 1, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbar_Locale["Directions"], Col = 1,
                        enENHelp = "",
                        enENDescription = "Direction",
                        deDEHelp = "",
                        deDEDescription = "Richtung",
                        },
		Rotation  = {
                        Sort = 3.6,
                        Type = "Slider", Value = 0, Min = 0, Max = 270, Step = 90, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Rotation",
                        deDEHelp = "",
                        deDEDescription = "Rotation",
                        },
        } 
    CursorCastbarOptionsSettingsTemplate["MirrorBar"] = 	
        {
        ShowMB =	{
                        Sort = 1,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "",
                        enENDescription = "Show Mirror Bar",
                        deDEHelp = "",
                        deDEDescription = "Mirror-Bar anzeigen",
                        },
        MBScale  = {
                        Sort = 2,
                        Type = "Slider", Value = 102, Min = 20, Max = 150, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.2f", self:GetValue())) 
                                        end,
                        enENHelp = "Scale of the mirror bar",
                        enENDescription = "Mirror Scale",
                        deDEHelp = "Skalierung der Mirror-Bar",
                        deDEDescription = "Mirror-Skalierung",
                        },	
        TextureMB = 	{
                        Sort = 3,  
                        Type = "Button", Value = 5, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbar_Locale["TextureNames"], Col = 1,
                        enENHelp = "",
                        enENDescription = "Texture",
                        deDEHelp = "",
                        deDEDescription = "Textur",
                        },
        Level  = {
                        Sort = 3.1,
                        Type = "Slider", Value = 2, Min = 1, Max = 10, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Drawing Level",
                        deDEHelp = "",
                        deDEDescription = "Darstellungsebene",
                        },						
        MStaticColor =	{
                        Sort = 3.2,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "",
                        enENDescription = "Static color",
                        deDEHelp = "",
                        deDEDescription = "Feste Farbe",
                        },					
        MColor = 	{
                        Sort = 3.3,
                        Type = "Button", Value = {r = 1, g = 1, b = 1}, Min = 0, Max = 0, Template = "CursorCastbarOptionsColorPickerTemplate", Col = 1,
                        OnClick = function(self) CursorCastbarOptionsColorPickerPrepare(self:GetName()); end,
                        enENHelp = "",
                        enENDescription = "Color",
                        deDEHelp = "",
                        deDEDescription = "Farbe",
                        },
        Direction = 		{
                        Sort = 3.5,  
                        Type = "Button", Value = 1, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbar_Locale["Directions"], Col = 1,
                        enENHelp = "",
                        enENDescription = "Direction",
                        deDEHelp = "",
                        deDEDescription = "Richtung",
                        },
		Rotation  = {
                        Sort = 3.6,
                        Type = "Slider", Value = 0, Min = 0, Max = 270, Step = 90, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Rotation",
                        deDEHelp = "",
                        deDEDescription = "Rotation",
                        },
        } 

        
    CursorCastbarOptionsSettingsTemplate["TargetBar"] = 	
        {
        Show =	{
                        Sort = 1,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "",
                        enENDescription = "Show Target Cast Bar",
                        deDEHelp = "",
                        deDEDescription = "Target Bar Anzeigen",
                        },	
        Scale  = {
                        Sort = 2,
                        Type = "Slider", Value = 139, Min = 20, Max = 150, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.2f", self:GetValue())) 
                                        end,
                        enENHelp = "Scale of the cast bar",
                        enENDescription = "Bar Scale",
                        deDEHelp = "Skalierung der Castbar",
                        deDEDescription = "Bar-Skalierung",
                        },
        Texture = 	{
                        Sort = 3,  
                        Type = "Button", Value = 5, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbar_Locale["TextureNames"], Col = 1,
                        enENHelp = "",
                        enENDescription = "Bar Texture",
                        deDEHelp = "",
                        deDEDescription = "Bar-Textur",
                        },
        Level  = {
                        Sort = 3.1,
                        Type = "Slider", Value = 2, Min = 1, Max = 10, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Drawing Level",
                        deDEHelp = "",
                        deDEDescription = "Darstellungsebene",
                        },						
        TBStaticColor =	{
                        Sort = 3.2,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "",
                        enENDescription = "Static color",
                        deDEHelp = "",
                        deDEDescription = "Feste Farbe",
                        },					
        TBColor = 	{
                        Sort = 3.3,
                        Type = "Button", Value = {r = 1, g = 1, b = 1}, Min = 0, Max = 0, Template = "CursorCastbarOptionsColorPickerTemplate", Col = 1,
                        OnClick = function(self) CursorCastbarOptionsColorPickerPrepare(self:GetName()); end,
                        enENHelp = "",
                        enENDescription = "Color",
                        deDEHelp = "",
                        deDEDescription = "Farbe",
                        },
        Direction = 		{
                        Sort = 3.5,  
                        Type = "Button", Value = 1, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbar_Locale["Directions"], Col = 1,
                        enENHelp = "",
                        enENDescription = "Direction",
                        deDEHelp = "",
                        deDEDescription = "Richtung",
                        },
        Rotation  = {
                        Sort = 3.6,
                        Type = "Slider", Value = 0, Min = 0, Max = 270, Step = 90, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Rotation",
                        deDEHelp = "",
                        deDEDescription = "Rotation",
                        },	
		SubtractLag =	{
                        Sort = 4,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "Subtracts the network latency (lag) from cast time.",
                        enENDescription = "Subtract Latency",
                        deDEHelp = "Zieht die Netzwerklatenz von der Castzeit ab.",
                        deDEDescription = "Latenz abziehen",
                        },
        ShowNumber =	{
                        Sort = 5,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "",
                        enENDescription = "Show Cast Time As Number",
                        deDEHelp = "",
                        deDEDescription = "Castzeit als Zahl anzeigen",
                        },
        FSScale  = {
                        Sort = 6,
                        Type = "Slider", Value = 12, Min = 5, Max = 25, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.0f", self:GetValue())) 
                                        end,
                        enENHelp = "Scale of the cast time number",
                        enENDescription = "Number Scale",
                        deDEHelp = "Skalierung der Castzeit-Zahl",
                        deDEDescription = "Zahl Skalierung",
                        },						
        FSx  = {
                        Sort = 7,
                        Type = "Slider", Value = 0, Min = -100, Max = 100, Step = 5, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.0f", self:GetValue())) 
                                        end,
                        enENHelp = "x position of remaining cast time number",
                        enENDescription = "Number X Pos ",
                        deDEHelp = "x position der verbleibenden Zauberzeit",
                        deDEDescription = "Zahl X-Pos",
                        },						
        FSy  = {
                        Sort = 8,
                        Type = "Slider", Value = -95, Min = -100, Max = 100, Step = 5, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.0f", self:GetValue())) 
                                        end,
                        enENHelp = "y Position of remaining cast time number",
                        enENDescription = "Number Y Pos",
                        deDEHelp = "y position der verbleibenden Zauberzeit",
                        deDEDescription = "Zahl Y-Pos",
                        },										
        } 
    CursorCastbarOptionsSettingsTemplate["TargetText"] = 	
        {
        ShowSpellName =	{
                        Sort = 9,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
    --~ if not self:GetChecked() then
    --~ 									CursorCastbarStartBar(4, 5000, false, false, (GetTime() * 1000), (GetTime() * 1000) + 2500, " ", icon) 
    --~ end
                                    end,
                        enENHelp = "",
                        enENDescription = "Show Spell Name",
                        deDEHelp = "",
                        deDEDescription = "Zaubersname anzeigen",
                        },					
        Level  = {
                        Sort = 9.1,
                        Type = "Slider", Value = 4, Min = 1, Max = 10, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Drawing Level",
                        deDEHelp = "",
                        deDEDescription = "Darstellungsebene",
                        },						
        SpellStringColor = 	{
                        Sort = 10,
                        Type = "Button", Value = {r = 1, g = 1, b = 1}, Min = 0, Max = 0, Template = "CursorCastbarOptionsColorPickerTemplate", 
                        OnClick = function(self) CursorCastbarOptionsColorPickerPrepare(self:GetName()); end,
                        enENHelp = "",
                        enENDescription = "Spell Color",
                        deDEHelp = "Farbe des Zaubertextes",
                        deDEDescription = "Text Farbe",
                        },
        Radius  = {
                        Sort = 11,
                        Type = "Slider", Value = "63", Min = "1", Max = "200", Step = "1", Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "Radius of spell string",
                        enENDescription = "Spell Radius",
                        deDEHelp = "Radius des Zaubertextes",
                        deDEDescription = "Text Radius",
                        },	
        Charsize  = {
                        Sort = 12,
                        Type = "Slider", Value = "21", Min = "15", Max = "60", Step = "1", Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "Char size of spell string",
                        enENDescription = "Spell Size",
                        deDEHelp = "Groesse der zeichen fuer den Zaubertext",
                        deDEDescription = "Text Groesse",
                        },	
        Charspace  = {
                        Sort = 13,
                        Type = "Slider", Value = -7, Min = -20, Max = -2, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "Space between chars for spell string",
                        enENDescription = "Spell Space",
                        deDEHelp = "Zwischenraum zwischen den Zeichen fuer den Zaubertext",
                        deDEDescription = "Text zwischenr.",
                        },	
        Rotanchor  = {
                        Sort = 14,
                        Type = "Slider", Value = "190", Min = "0", Max = "360", Step = "10", Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "Spell string anchor ",
                        enENDescription = "Spell Anchor",
                        deDEHelp = "Anker fuer den Zaubertext",
                        deDEDescription = "Text Anker",
                        },						
        }
    CursorCastbarOptionsSettingsTemplate["TargetIcon"] = 	
        {
        ShowSpellIcon =	{
                        Sort = 1,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "",
                        enENDescription = "Show Spell Icon",
                        deDEHelp = "",
                        deDEDescription = "Zaubersymbol anzeigen",
                        },					
        Level  = {
                        Sort = 1.1,
                        Type = "Slider", Value = 3, Min = 1, Max = 10, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Drawing Level",
                        deDEHelp = "",
                        deDEDescription = "Darstellungsebene",
                        },						
        IconScale  = {
                        Sort = 6,
                        Type = "Slider", Value = 16, Min = 5, Max = 50, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.0f", self:GetValue())) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Icon Scale",
                        deDEHelp = "",
                        deDEDescription = "Symbol Skalierung",
                        },						
        Iconx  = {
                        Sort = 7,
                        Type = "Slider", Value = -62, Min = -100, Max = 100, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.0f", self:GetValue())) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Icon X Pos ",
                        deDEHelp = "",
                        deDEDescription = "Symbol X-Pos",
                        },						
        Icony  = {
                        Sort = 8,
                        Type = "Slider", Value = 7, Min = -100, Max = 100, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.0f", self:GetValue())) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Icon Y Pos ",
                        deDEHelp = "",
                        deDEDescription = "Symbol Y-Pos",
                        },			
        }
        
    CursorCastbarOptionsSettingsTemplate["Indicator"] = 	
        {
        IndicatorShow =	{
                        Sort = 1,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "",
                        enENDescription = "Show Indicators",
                        deDEHelp = "",
                        deDEDescription = "Indikatoren anzeigen",
                        },					
        IndicatorLarge =	{
                        Sort = 1.05,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate", Col = 6,
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "",
                        enENDescription = "Large Indicator",
                        deDEHelp = "",
                        deDEDescription = "Grosser Indikator",
                        },	
                        
        IndicatorLevel  = {
                        Sort = 1.1,
                        Type = "Slider", Value = 5, Min = 1, Max = 10, Step = 1, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(self:GetValue()) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Drawing Level",
                        deDEHelp = "",
                        deDEDescription = "Darstellungsebene",
                        },						
        IndicatorScale  = {
                        Sort = 6,
                        Type = "Slider", Value = 260, Min = 30, Max = 350, Step = 10, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.0f", self:GetValue())) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Scale",
                        deDEHelp = "",
                        deDEDescription = "Skalierung",
                        },						
        IndicatorRotate = {
                        Sort = 7,
                        Type = "Slider", Value = 0, Min = -180, Max = 180, Step = 5, Template = "CursorCastbarOptionsSliderTemplate",
                        OnValueChanged = function(self) 
                                            if CursorCastbarOptionsCONSTSaveValue == true then 
                                                CursorCastbarOptionsSaveSettings() 
                                            end
                                            getglobal(self:GetName().."FSVal"):SetText(string.format("%.0f", self:GetValue())) 
                                        end,
                        enENHelp = "",
                        enENDescription = "Rotation",
                        deDEHelp = "",
                        deDEDescription = "Rotation",
                        },						
        IndicatorBlink =	{
                        Sort = 8,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "",
                        enENDescription = "Blink",
                        deDEHelp = "",
                        deDEDescription = "Blinken",
                        },					
        Indicator1Color = 	{
                        Sort = 9,
                        Type = "Button", Value = {r = 1, g = 1, b = 1}, Min = 0, Max = 0, Template = "CursorCastbarOptionsColorPickerTemplate", Col = 1,
                        OnClick = function(self) CursorCastbarOptionsColorPickerPrepare(self:GetName()); end,
                        enENHelp = "",
                        enENDescription = "Color    Indicator 1",
                        deDEHelp = "",
                        deDEDescription = "Farbe    Indkator 1",
                        },
        Indicator1Target = 		{
                        Sort = 10,  
                        Type = "Button", Value = 1, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbar_Locale["Categories"], Col = 1,
                        deDEHelp = "'Cooldown' auswaehlen um Zauber-Cooldowns zu ueberwachen (Zaubername in Feld 'Zauber' eintragen;\n'Proc' auswaehlen um Procs zu ueberwachen (Proc-Name in Feld 'Zauber' eintragen", enENHelp = "Select 'Cooldown' to track spell cooldowns (enter spell name into field 'Spell');\nSelect 'Proc' to track procs (enter proc name below into field 'Spell')",
                        enENDescription = "Type",
                        deDEDescription = "Art",
                        },
        Indicator1Spell = 			{
                        Sort = 11,
                        Type = "EditBox", Value = "", Max = 100,  Template = "CursorCastbarOptionsEditboxTemplate", Col = 1,
                        deDEHelp = "Der exakte Name des Zaubers oder Proc-Buff/Debuffs", enENHelp = "The exact name of the Spell or proc buff//debuff",
                        enENDescription = "Spell ", 
                        deDEDescription = "Zauber ", 
                        },
        Indicator1Invert = {
                        Sort = 12,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate",
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "Show indicator if spell is READY instead if spell is on cooldown.",
                        enENDescription = "Invert",
                        deDEHelp = "Indikator anzeigen wenn Zauber BEREIT ist statt wenn Zauber Cooldown hat.",
                        deDEDescription = "Umkehren",
                        },					
        Space201 = 		{Sort = 201, Type = "Space", Col = 1},
        Indicator2Color = {
                        Sort = 201.5,
                        Type = "Button", Value = {r = 1, g = 1, b = 1}, Min = 0, Max = 0, Template = "CursorCastbarOptionsColorPickerTemplate", Col = 1,
                        OnClick = function(self) CursorCastbarOptionsColorPickerPrepare(self:GetName()); end,
                        enENHelp = "", deDEHelp = "",
                        enENDescription = "Color    Indicator 2",
                        deDEHelp = "",
                        deDEDescription = "Farbe    Indkator 2",
                        },
        Indicator2Target = {
                        Sort = 206,  
                        Type = "Button", Value = 1, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbar_Locale["Categories"], Col = 1,
                        deDEHelp = "'Cooldown' auswaehlen um Zauber-Cooldowns zu ueberwachen (Zaubername in Feld 'Zauber' eintragen;\n'Proc' auswaehlen um Procs zu ueberwachen (Proc-Name in Feld 'Zauber' eintragen", enENHelp = "Select 'Cooldown' to track spell cooldowns (enter spell name into field 'Spell');\nSelect 'Proc' to track procs (enter proc name below into field 'Spell')",
                        enENDescription = "Type",
                        deDEDescription = "Art",
                        },
        Indicator2Spell = {
                        Sort = 208,
                        Type = "EditBox", Value = "", Max = 100,  Template = "CursorCastbarOptionsEditboxTemplate", Col = 1,
                        deDEHelp = "Der exakte Name des Zaubers oder Proc-Buff/Debuffs", enENHelp = "The exact name of the Spell or proc buff//debuff",
                        enENDescription = "Spell ", 
                        deDEDescription = "Zauber ", 
                        },					
        Indicator2Invert = {
                        Sort = 212,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate", Col = 1,
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "Show indicator if spell is READY instead if spell is on cooldown.",
                        enENDescription = "Invert",
                        deDEHelp = "Indikator anzeigen wenn Zauber BEREIT ist statt wenn Zauber Cooldown hat.",
                        deDEDescription = "Umkehren",
                        },	
        Space301 = 		{Sort = 301, Type = "Space", Col = 1},						
		Indicator3Color = {
                        Sort = 301.5,
                        Type = "Button", Value = {r = 1, g = 1, b = 1}, Min = 0, Max = 0, Template = "CursorCastbarOptionsColorPickerTemplate", Col = 1,
                        OnClick = function(self) CursorCastbarOptionsColorPickerPrepare(self:GetName()); end,
                        enENHelp = "", deDEHelp = "",
                        enENDescription = "Color    Indicator 3",
                        deDEHelp = "",
                        deDEDescription = "Farbe    Indkator 3",
                        },
        Indicator3Target = {
                        Sort = 306,  
                        Type = "Button", Value = 1, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbar_Locale["Categories"], Col = 1,
                        deDEHelp = "'Cooldown' auswaehlen um Zauber-Cooldowns zu ueberwachen (Zaubername in Feld 'Zauber' eintragen;\n'Proc' auswaehlen um Procs zu ueberwachen (Proc-Name in Feld 'Zauber' eintragen", enENHelp = "Select 'Cooldown' to track spell cooldowns (enter spell name into field 'Spell');\nSelect 'Proc' to track procs (enter proc name below into field 'Spell')",
                        enENDescription = "Type",
                        deDEDescription = "Art",
                        },
        Indicator3Spell = {
                        Sort = 308,
                        Type = "EditBox", Value = "", Max = 100,  Template = "CursorCastbarOptionsEditboxTemplate", Col = 1,
                        deDEHelp = "Der exakte Name des Zaubers oder Proc-Buff/Debuffs", enENHelp = "The exact name of the Spell or proc buff//debuff",
                        enENDescription = "Spell ", 
                        deDEDescription = "Zauber ", 
                        },					
        Indicator3Invert = {
                        Sort = 312,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate", Col = 1,
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "Show indicator if spell is READY instead if spell is on cooldown.",
                        enENDescription = "Invert",
                        deDEHelp = "Indikator anzeigen wenn Zauber BEREIT ist statt wenn Zauber Cooldown hat.",
                        deDEDescription = "Umkehren",
                        },	
        Space401 = 		{Sort = 401, Type = "Space", Col = 1},
        Indicator4Color = {
                        Sort = 401.5,
                        Type = "Button", Value = {r = 1, g = 1, b = 1}, Min = 0, Max = 0, Template = "CursorCastbarOptionsColorPickerTemplate",  Col = 1,
                        OnClick = function(self) CursorCastbarOptionsColorPickerPrepare(self:GetName()); end,
                        enENHelp = "", deDEHelp = "",
                        enENDescription = "Color    Indicator 4",
                        deDEHelp = "",
                        deDEDescription = "Farbe    Indkator 4",
                        },
        Indicator4Target = {
                        Sort = 406,  
                        Type = "Button", Value = 1, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbar_Locale["Categories"], Col = 1,
                        deDEHelp = "'Cooldown' auswaehlen um Zauber-Cooldowns zu ueberwachen (Zaubername in Feld 'Zauber' eintragen;\n'Proc' auswaehlen um Procs zu ueberwachen (Proc-Name in Feld 'Zauber' eintragen", enENHelp = "Select 'Cooldown' to track spell cooldowns (enter spell name into field 'Spell');\nSelect 'Proc' to track procs (enter proc name below into field 'Spell')",
                        enENDescription = "Type",
                        deDEDescription = "Art",
                        },
        Indicator4Spell = {
                        Sort = 408,
                        Type = "EditBox", Value = "", Max = 100,  Template = "CursorCastbarOptionsEditboxTemplate", Col = 1,
                        deDEHelp = "Der exakte Name des Zaubers oder Proc-Buff/Debuffs", enENHelp = "The exact name of the Spell or proc buff//debuff",
                        enENDescription = "Spell ", 
                        deDEDescription = "Zauber ", 
                        },										
        Indicator4Invert = {
                        Sort = 412,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate", Col = 1,
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "Show indicator if spell is READY instead if spell is on cooldown.",
                        enENDescription = "Invert",
                        deDEHelp = "Indikator anzeigen wenn Zauber BEREIT ist statt wenn Zauber Cooldown hat.",
                        deDEDescription = "Umkehren",
                        },					
        
    --~ 	Space113 = 		{Sort = 8.1, Type = "Space", Col = 6},
    --~ 	Space114 = 		{Sort = 8.1, Type = "Space", Col = 6},
        Space115 = 		{Sort = 8.1, Type = "Space", Col = 6},
        Space116 = 		{Sort = 8.1, Type = "Space", Col = 6},
        Space117 = 		{Sort = 8.1, Type = "Space", Col = 6},
        Space118 = 		{Sort = 8.1, Type = "Space", Col = 6},
        Space119 = 		{Sort = 8.1, Type = "Space", Col = 6},
        Space1111 = 		{Sort = 8.1, Type = "Space", Col = 6},
        Space1112 = 		{Sort = 8.1, Type = "Space", Col = 6},
        Space1113 = 		{Sort = 8.1, Type = "Space", Col = 6},
        Space11145 = 		{Sort = 8.1, Type = "Space", Col = 6},
		
		Space501 = 		{Sort = 501, Type = "Space", Col = 6},
        Indicator5Color = {
                        Sort = 501.5,
                        Type = "Button", Value = {r = 1, g = 1, b = 1}, Min = 0, Max = 0, Template = "CursorCastbarOptionsColorPickerTemplate",  Col = 6,
                        OnClick = function(self) CursorCastbarOptionsColorPickerPrepare(self:GetName()); end,
                        enENHelp = "", deDEHelp = "",
                        enENDescription = "Color    Indicator 5",
                        deDEHelp = "",
                        deDEDescription = "Farbe    Indkator 5",
                        },
        Indicator5Target = {
                        Sort = 506,  
                        Type = "Button", Value = 1, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbar_Locale["Categories"], Col = 6,
                        deDEHelp = "'Cooldown' auswaehlen um Zauber-Cooldowns zu ueberwachen (Zaubername in Feld 'Zauber' eintragen;\n'Proc' auswaehlen um Procs zu ueberwachen (Proc-Name in Feld 'Zauber' eintragen", enENHelp = "Select 'Cooldown' to track spell cooldowns (enter spell name into field 'Spell');\nSelect 'Proc' to track procs (enter proc name below into field 'Spell')",
                        enENDescription = "Type",
                        deDEDescription = "Art",
                        },
        Indicator5Spell = {
                        Sort = 508,
                        Type = "EditBox", Value = "", Max = 100,  Template = "CursorCastbarOptionsEditboxTemplate", Col = 6,
                        deDEHelp = "Der exakte Name des Zaubers oder Proc-Buff/Debuffs", enENHelp = "The exact name of the Spell or proc buff//debuff",
                        enENDescription = "Spell ", 
                        deDEDescription = "Zauber ", 
                        },										
        Indicator5Invert = {
                        Sort = 512,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate", Col = 6,
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "Show indicator if spell is READY instead if spell is on cooldown.",
                        enENDescription = "Invert",
                        deDEHelp = "Indikator anzeigen wenn Zauber BEREIT ist statt wenn Zauber Cooldown hat.",
                        deDEDescription = "Umkehren",
                        },
        Space601 = 		{Sort = 601, Type = "Space", Col = 6},
        Indicator6Color = {
                        Sort = 601.5,
                        Type = "Button", Value = {r = 1, g = 1, b = 1}, Min = 0, Max = 0, Template = "CursorCastbarOptionsColorPickerTemplate",  Col = 6,
                        OnClick = function(self) CursorCastbarOptionsColorPickerPrepare(self:GetName()); end,
                        enENHelp = "", deDEHelp = "",
                        enENDescription = "Color    Indicator 6",
                        deDEHelp = "",
                        deDEDescription = "Farbe    Indkator 6",
                        },
        Indicator6Target = {
                        Sort = 606,  
                        Type = "Button", Value = 1, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbar_Locale["Categories"], Col = 6,
                        deDEHelp = "'Cooldown' auswaehlen um Zauber-Cooldowns zu ueberwachen (Zaubername in Feld 'Zauber' eintragen;\n'Proc' auswaehlen um Procs zu ueberwachen (Proc-Name in Feld 'Zauber' eintragen", enENHelp = "Select 'Cooldown' to track spell cooldowns (enter spell name into field 'Spell');\nSelect 'Proc' to track procs (enter proc name below into field 'Spell')",
                        enENDescription = "Type",
                        deDEDescription = "Art",
                        },
        Indicator6Spell = {
                        Sort = 608,
                        Type = "EditBox", Value = "", Max = 100,  Template = "CursorCastbarOptionsEditboxTemplate", Col = 6,
                        deDEHelp = "Der exakte Name des Zaubers oder Proc-Buff/Debuffs", enENHelp = "The exact name of the Spell or proc buff//debuff",
                        enENDescription = "Spell ", 
                        deDEDescription = "Zauber ", 
                        },										
        Indicator6Invert = {
                        Sort = 612,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate", Col = 6,
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "Show indicator if spell is READY instead if spell is on cooldown.",
                        enENDescription = "Invert",
                        deDEHelp = "Indikator anzeigen wenn Zauber BEREIT ist statt wenn Zauber Cooldown hat.",
                        deDEDescription = "Umkehren",
                        },
        Space701 = 		{Sort = 701, Type = "Space", Col = 6},
        Indicator7Color = {
                        Sort = 701.5,
                        Type = "Button", Value = {r = 1, g = 1, b = 1}, Min = 0, Max = 0, Template = "CursorCastbarOptionsColorPickerTemplate",  Col = 6,
                        OnClick = function(self) CursorCastbarOptionsColorPickerPrepare(self:GetName()); end,
                        enENHelp = "", deDEHelp = "",
                        enENDescription = "Color    Indicator 7",
                        deDEHelp = "",
                        deDEDescription = "Farbe    Indkator 7",
                        },
        Indicator7Target = {
                        Sort = 706,  
                        Type = "Button", Value = 1, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbar_Locale["Categories"], Col = 6,
                        deDEHelp = "'Cooldown' auswaehlen um Zauber-Cooldowns zu ueberwachen (Zaubername in Feld 'Zauber' eintragen;\n'Proc' auswaehlen um Procs zu ueberwachen (Proc-Name in Feld 'Zauber' eintragen", enENHelp = "Select 'Cooldown' to track spell cooldowns (enter spell name into field 'Spell');\nSelect 'Proc' to track procs (enter proc name below into field 'Spell')",
                        enENDescription = "Type",
                        deDEDescription = "Art",
                        },
        Indicator7Spell = {
                        Sort = 708,
                        Type = "EditBox", Value = "", Max = 100,  Template = "CursorCastbarOptionsEditboxTemplate", Col = 6,
                        deDEHelp = "Der exakte Name des Zaubers oder Proc-Buff/Debuffs", enENHelp = "The exact name of the Spell or proc buff//debuff",
                        enENDescription = "Spell ", 
                        deDEDescription = "Zauber ", 
                        },										
        Indicator7Invert = {
                        Sort = 712,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate", Col = 6,
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "Show indicator if spell is READY instead if spell is on cooldown.",
                        enENDescription = "Invert",
                        deDEHelp = "Indikator anzeigen wenn Zauber BEREIT ist statt wenn Zauber Cooldown hat.",
                        deDEDescription = "Umkehren",
                        },
        Space801 = 		{Sort = 801, Type = "Space", Col = 6},
        Indicator8Color = {
                        Sort = 801.5,
                        Type = "Button", Value = {r = 1, g = 1, b = 1}, Min = 0, Max = 0, Template = "CursorCastbarOptionsColorPickerTemplate",  Col = 6,
                        OnClick = function(self) CursorCastbarOptionsColorPickerPrepare(self:GetName()); end,
                        enENHelp = "", deDEHelp = "",
                        enENDescription = "Color    Indicator 8",
                        deDEHelp = "",
                        deDEDescription = "Farbe    Indkator 8",
                        },
        Indicator8Target = {
                        Sort = 806,  
                        Type = "Button", Value = 1, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbar_Locale["Categories"], Col = 6,
                        deDEHelp = "'Cooldown' auswaehlen um Zauber-Cooldowns zu ueberwachen (Zaubername in Feld 'Zauber' eintragen;\n'Proc' auswaehlen um Procs zu ueberwachen (Proc-Name in Feld 'Zauber' eintragen", enENHelp = "Select 'Cooldown' to track spell cooldowns (enter spell name into field 'Spell');\nSelect 'Proc' to track procs (enter proc name below into field 'Spell')",
                        enENDescription = "Type",
                        deDEDescription = "Art",
                        },
        Indicator8Spell = {
                        Sort = 808,
                        Type = "EditBox", Value = "", Max = 100,  Template = "CursorCastbarOptionsEditboxTemplate", Col = 6,
                        deDEHelp = "Der exakte Name des Zaubers oder Proc-Buff/Debuffs", enENHelp = "The exact name of the Spell or proc buff//debuff",
                        enENDescription = "Spell ", 
                        deDEDescription = "Zauber ", 
                        },										
        Indicator8Invert = {
                        Sort = 812,
                        Type = "CheckButton", Value = CursorCastbarOptionsCONSTUnChecked, Template = "CursorCastbarOptionsCheckTemplate", Col = 6,
                        OnClick = 	function(self) 
                                        CursorCastbarOptionsSaveSettings()
                                    end,
                        enENHelp = "Show indicator if spell is READY instead if spell is on cooldown.",
                        enENDescription = "Invert",
                        deDEHelp = "Indikator anzeigen wenn Zauber BEREIT ist statt wenn Zauber Cooldown hat.",
                        deDEDescription = "Umkehren",
                        },

        

        }
    CursorCastbarOptionsSettingsTemplate["Profiles"] = 	
        {
        ProfilesNameToEdit = {
                        Sort = 2,
                        Type = "EditBox", Value = "", Max = 100,  Template = "CursorCastbarOptionsEditboxTemplate", Col = 1,
                        deDEHelp = "", enENHelp = "",
                        enENDescription = "   Profile Name", 
                        deDEDescription = "   Profilname", 
                        },										
        ProfilesSave = 		{
                        Sort = 3,
                        Type = "Button", Value = CursorCastbar_Locale["Save"], Min = 0, Max = 0, Template = "CursorCastbarOptionsClickButtonTemplate", Col = 1,
                        OnClick = 	function(self)  
                                        if _G["CursorCastbarOptionsTabsSettingsProfilesNameToEdit"] then
                                            CursorCastbarOptionsSaveProfile(_G["CursorCastbarOptionsTabsSettingsProfilesNameToEdit"]:GetText())
                                        end
                                    end,
                        enENHelp = "Save/Create Profile",
                        enENDescription = "Save/Create Profile", 
                        deDEHelp = "Profil speichern/erstellen",
                        deDEDescription = "Profil speichern/erstellen",
                        },						
        Space1114 = 		{Sort = 3.1, Type = "Space", Col = 6},
        Space1115 = 		{Sort = 3.1, Type = "Space", Col = 6},
        Space1116 = 		{Sort = 3.1, Type = "Space", Col = 6},
        ProfilesLoad = 		{
                        Sort = 4,
                        Type = "Button", Value = CursorCastbar_Locale["Load"], Min = 0, Max = 0, Template = "CursorCastbarOptionsClickButtonTemplate", Col = 6,
                        OnClick = 	function(self)  
                                        if _G["CursorCastbarOptionsTabsSettingsProfilesNameToEdit"] then
                                            CursorCastbarOptionsLoadProfile(_G["CursorCastbarOptionsTabsSettingsProfilesNameToEdit"]:GetText())
                                        end
                                    end,
                        enENHelp = "Load Profile",
                        enENDescription = "Load Profile", 
                        deDEHelp = "Profil laden",
                        deDEDescription = "Profil laden",
                        },			


        Space1114 = 		{Sort = 4.1, Type = "Space", Col = 1},
        Space1114 = 		{Sort = 4.1, Type = "Space", Col = 1},




        Profiles1Spec = {
                        Sort = 10,  
                        Type = "Button", Value = 1, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbarOptionsProfileNames, Col = 1,
                        OnClick = 	function(self)  
                                        if GetActiveTalentGroup() == 1 then
                                            CursorCastbarOptionsLoadProfile(CursorCastbarOptionsProfileNames[CursorCastbarOptionsSettings["Profiles"]["Profiles1Spec"].Value])
                                            CursorCastbarUpdateVisuals()
                                        end
                                    end,
                        deDEHelp = "", enENHelp = "",
                        enENDescription = "First Talent Spec Profile",
                        deDEDescription = "Profil erste Talentspezialisierung",
                        },
        Profiles2Spec = {
                        Sort = 11,  
                        Type = "Button", Value = 1, Template = "CursorCastbarOptionsDropdownTemplate", Source = CursorCastbarOptionsProfileNames, Col = 1,
                        deDEHelp = "", enENHelp = "",
                        enENDescription = "Second Talent Spec Profile",
                        deDEDescription = "Profil zweite Talentspezialisierung",
                        },


                        
                                    
        } 	
end






























