if (GetLocale() == "deDE") then
	CursorCastbar_Locale =	{
							["ProfilNames"] = 	{
												[1] = "test", 
												[2] = "test1", 
												},					
							["AnchorNames"] = 	{
												[1] = "Mauszeiger", 
												[2] = "UI Links", 
												[3] = "UI Oben", 
												[4] = "UI Rechts", 
												[5] = "Verschiebbar", 	
												[6] = "Cursorposition bei Zauberstart",
												},
							["TextureNames"] =	{ 								
												[1] = 	"Scharf",
												[2] = 	"Unscharf", 
												[3] = 	"Fett + Scharf", 
												[4] = 	"Fett + Unscharf", 												
												[5] = 	"HighRes-Rand duenn", 
												[6] = 	"HighRes-Rand dick", 
												[7] = 	"HighRes-Fett", 												
												[8] = 	"HighRes-Dünn", 
												[9] = 	"HighRes-Dünn unschaf", 											
												[10] = 	"HighRes-Runes",	
												},
							["Directions"] =	{ 								
												[1] = 	"Gegen Uhrzeigersinn",
												[2] = 	"Im Uhrzeigersinn", 
												},
							["OptionsLabels"] = {
												"Global", 
												"Spieler\nCastBar", 
												"Spieler\nSpellText", 
												"Spieler\nSpellIcon", 
												"Global\nCooldown", 
												"Mirror\nBar", 
--~ 												"Swing\nBar", 
												"Ziel\nCastBar", 
												"Ziel\nSpellText", 
												"Ziel\nSpellIcon",
												"Indikator",
												"Profile",
												} ,		
							["Categories"] = 	{
												[1] = "Proc", 
												[2] = "Cooldown", 
												},					
							["Type"] = 			{
												[1] = "Aktiv", 
												[2] = "Erhalt", 
												[3] = "Verlust", 
												},
							["Save"] = 			"Speichern als/Erstellen",
							["Load"] = 			"Laden",
							["NoName"] = 		"Profilname ist leer",
							["WrongName"] = 	"Unbekannter Profilname",
							}
end