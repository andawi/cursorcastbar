CursorCastbarCONSTPi = 3.14159265;
--------------------------------------------------------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarTransform(TA, TB, TC, TD, TE, TF, x, y, size, objName)
	local ULx = ( TB*TF - TC*TE )             / (TA*TE - TB*TD) / size;
	local ULy = ( -(TA*TF) + TC*TD )          / (TA*TE - TB*TD)  / size;
	local LLx = ( -TB + TB*TF - TC*TE )       / size / (TA*TE - TB*TD);
	local LLy = ( TA - TA*TF + TC*TD )        / (TA*TE - TB*TD) / size;
	local URx = ( TE + TB*TF - TC*TE )        / size / (TA*TE - TB*TD);
	local URy = ( -TD - TA*TF + TC*TD )       / (TA*TE - TB*TD) / size;
	local LRx = ( TE - TB + TB*TF - TC*TE )   / size / (TA*TE - TB*TD);
	local LRy = ( -TD + TA -(TA*TF) + TC*TD ) / (TA*TE - TB*TD) / size;
	getglobal(objName):SetTexCoord(ULx + x, ULy + y, LLx  + x, LLy  + y , URx + x , URy  + y, LRx + x , LRy + y );
end
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
function CursorCastbarShowText(text, charsize, charspace, rad, rotanchor, charrot, pframe, color, alpha, fonttype)
	if not text then text = "" end
	local tlen = string.len(text);
	local tframe
	if getglobal(pframe:GetName().."Text") then
		tframe = getglobal(pframe:GetName().."Text");
	else
		tframe = CreateFrame("Frame", pframe:GetName().."Text", pframe);
		tframe:SetAllPoints()
	end
	tframe:ClearAllPoints()
	tframe:SetPoint("CENTER", pframe:GetName(), "CENTER" , 0, 0);
	tframe:SetWidth(tlen * 20);
	tframe:SetHeight(20);

	local raus = false;
	local x = 1;
	while raus == false do
		if getglobal(pframe:GetName().."TextTexture"..x) then
			getglobal(pframe:GetName().."TextTexture"..x):Hide();
			x = x + 1;
		else
			raus = true;
		end
	end
 	local tfont = CursorCastbarChars[fonttype].name;
	local takt = 1 + rotanchor;
	
	local i = 1
	local curpos = 1
	while string.sub(text, i, i) ~= "" do
		local c = i
		if string.byte(string.sub(text, i, i)) == 195 then
			tchar = string.char(string.byte(string.sub(text, i, i)), string.byte(string.sub(text, i+1, i+1)))
			ttchar = string.char(string.byte(string.sub(text, i, i)), string.byte(string.sub(text, i+1, i+1)))
			i = i + 2
		else
			tchar = string.sub(text, i, i)
			ttchar = string.sub(text, i, i)
			i = i + 1
		end
	
		local ttexture = Nil;
		if tchar == "(" or tchar == ")" or tchar == "." or tchar == "%" or tchar == "+" or tchar == "-" or tchar == "*" or tchar == "?" or tchar == "[" or tchar == "^" or tchar == "$" then
			ttchar = "%"..tchar
		end
		if string.find(" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_'abcdefghijklmnopqrstuvwxyz{|}~ÀÁÂÄÈÉÊÌÍÎÒÓÔÖÙÚÛÜÝßàáâäèéêìíîòóôöùúûüý", ttchar) == Nil then
			tchar = " "
		end
		if not CursorCastbarChars[tfont][tchar] then
			tchar = " "
		end

		if getglobal(pframe:GetName().."TextTexture"..curpos) then
			ttexture = getglobal(pframe:GetName().."TextTexture"..curpos);
		else
			ttexture = tframe:CreateTexture(pframe:GetName().."TextTexture"..curpos,"DIALOG")
		end
		if CursorCastbarChars[tfont][tchar].size then
			takt = takt - (CursorCastbarChars[tfont][tchar].size * charspace);
		else
			takt = takt - (1 * charspace);
		end

		local x = rad * cos(takt);
		local y = rad * sin(takt);
		ttexture:SetPoint("CENTER", pframe:GetName().."Text", "CENTER" , x, y);
		ttexture:SetTexture("");
		ttexture:SetTexture("Interface\\Addons\\CursorCastbar\\Fonts\\"..tfont.."\\white\\"..CursorCastbarChars[fonttype].prefix..CursorCastbarChars[tfont][tchar].no);

		ttexture:SetWidth(charsize);
		ttexture:SetHeight(charsize);
		ttexture:SetVertexColor(color.r, color.g, color.b, 1);--CursorCastbarOptionsSettings["Global"].Opacity.Value/100);
		local rot = takt + charrot;
		rot = rot * (-1);																							
		CursorCastbarTransform(math.cos(math.rad(rot)), -math.sin(math.rad(rot)),0.5,math.sin(math.rad(rot)), math.cos(math.rad(rot)),0.5, 0.5, 0.5, 0.75, ttexture:GetName());
		ttexture:Show();
		curpos = curpos + 1
	end
	tframe:Show();
end

