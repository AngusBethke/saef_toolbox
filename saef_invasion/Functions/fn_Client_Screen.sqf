/**
	@namespace RS_INV
	@class Invasion
	@method RS_INV_fnc_Client_Screen
	@file fn_Client_Screen.sqf
	@summary Screen used to cover up player movement to aircraft
	
	@usage ```[] spawn RS_INV_fnc_Client_Screen;```
	
**/

/* 
	fn_Client_Screen.sqf 
	
	Description:
		Screen used to cover up player movement to aircraft
		
	How to Call:
		[] spawn RS_INV_fnc_Client_Screen;
*/

titleCut ["","BLACK OUT", 2];
sleep 2;
titleCut ["", "BLACK FADED", 999];
["<t font='PuristaBold' size='1.5' align='center'>" + (missionNamespace getVariable ["RS_INV_Client_Screen_Text", "June 6th, 1944"]) + "<br/>" + "</t>",0,0.35,5,-1,0,3011] spawn bis_fnc_dynamicText;
sleep 7;
titleCut ["", "BLACK IN", 2];

/*
	
*/