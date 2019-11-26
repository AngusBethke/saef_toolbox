/*
	fn_GasMaskHandler.sqf
	Description: Handles hiding and showing of the gasmask
	[_unit] spawn RS_Radiation_fnc_GasMaskHandler;
*/

private
[
	 "_unit"
	,"_maskBase"
	,"_maskLayer"
	,"_maskFound"
];

_unit = _this select 0;

_maskBase = missionNamespace getVariable ["RS_Radiation_CompatibleGasMasks", []];
_maskLayer = "";
_maskFound = false;

{
	if ((goggles player) == (_x select 0)) then
	{
		_maskLayer = (_x select 1);
		_maskFound = true
	};
} forEach _maskBase;

// If the player is dead then we need to force end the mask
if (!alive _unit) then
{
	_maskFound = false;
};

if (_maskFound && !(_unit getVariable ["RS_Radiation_Wearing_Gasmask", false])) then
{
	_unit setVariable ["RS_Radiation_Wearing_Gasmask", true, true];
	_unit setVariable ["RS_Radiation_Current_Gasmask", _maskLayer, true];
	
	// Play Sound
	playsound "gm_alter_1";
	sleep 0.7;
	
	// Display screen overlay
	("RS_Radiation_Gasmask" call BIS_fnc_rscLayer) cutRsc [_maskLayer, "PLAIN", -1, false];
	
	// Play the Gasmask Sound
	[_unit] spawn RS_Radiation_fnc_GasMaskSound;
}
else
{
	if (!(_maskFound) || (_maskLayer != _unit getVariable ["RS_Radiation_Current_Gasmask", ""])) then
	{
		_runCheckAgain = false;
		if (_maskLayer != _unit getVariable ["RS_Radiation_Current_Gasmask", ""]) then
		{
			_runCheckAgain = true;
		};
		
		_hadGasMask = _unit getVariable ["RS_Radiation_Wearing_Gasmask", false];
		_unit setVariable ["RS_Radiation_Wearing_Gasmask", false, true];
		_unit setVariable ["RS_Radiation_Current_Gasmask", "", true];
		
		// Raise Volume
		if (_hadGasMask) then
		{
			playsound "gm_alter_1";
			sleep 0.7;
		};
		
		// Remove screen overlay
		("RS_Radiation_Gasmask" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
		
		// Recursive call to switch to different gasmask if changed
		if (_runCheckAgain) then
		{
			sleep 4;
			[_unit] spawn RS_Radiation_fnc_GasMaskHandler;
		};
	};
};