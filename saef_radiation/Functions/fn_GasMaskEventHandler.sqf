/**
	@namespace RS_Radiation
	@class Radiation
	@method RS_Radiation_fnc_GasMaskEventHandler
	@file fn_GasMaskEventHandler.sqf
	@summary Runs our handler on player event

**/

/*
	fn_GasMaskEventHandler.sqf
	Description: Runs our handler on player event
*/

if (!hasInterface) exitWith {};

player addEventHandler ["Take", {
	[player] spawn RS_Radiation_fnc_GasMaskHandler;
}];

player addEventHandler ["Put", {
	[player] spawn RS_Radiation_fnc_GasMaskHandler;
}];

player addEventHandler ["Killed", {
	[player] spawn RS_Radiation_fnc_GasMaskHandler;
}];