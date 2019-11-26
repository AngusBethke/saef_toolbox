/*
	fn_ChemicalDetectorHandler.sqf
	Description: Handles the chemical detector's display value
	[_markerList, _size, _unit, _variable] spawn RS_Radiation_fnc_ChemicalDetectorHandler;
*/

private
[
	 "_pos"
	,"_size"
	,"_unit"
	,"_variable"
	,"_marker"
];

_markerList = _this select 0;
_size = _this select 1;
_unit = _this select 2;
_variable = _this select 3;

while { (_unit getVariable [_variable, false]) && (alive _unit) } do
	
	// Get our closest marker
	_marker = "";
	{
		if ((_unit distance (markerPos _x)) < (_unit distance (markerPos _marker))) then
		{
			_marker = _x;
		};
	} forEach _markerList;

	// Set the position for radiation checks
	_pos = markerPos _marker;
	
	if (_unit getVariable ["RS_ChemicalDetector_Running", false]) then
	{
		// Get the object that is our chemical detector
		private _ui = uiNamespace getVariable "RscWeaponChemicalDetector";
		private _obj = _ui displayCtrl 101;
		
		if ((_unit distance _pos) <= _size) then
		{
			// Adjust the threat level on the detector
			_dFactor = 1;
			if ((_unit distance _pos) != 0) then
			{
				_dFactor = (1 - (_unit distance _pos) / _size);
			};
			
			_obj ctrlAnimateModel ["Threat_Level_Source", _dFactor, true];
		}
		else
		{
			_obj ctrlAnimateModel ["Threat_Level_Source", 0, true];
		};
	};
	
	sleep 1;
};

// Make sure if the unit dies and the variable is still active that we restart the handler
waitUntil {
	sleep 10;
	(alive player)
};

if (_unit != player) then
{
	diag_log format ["[RS] [ChemicalDetector] [INFO] Unit: %1 is not Player: %2", _unit, player];
	_unit = player;
};

// Restart
if (_unit getVariable [_variable, false]) then
{
	diag_log format ["[RS] [ChemicalDetector] [INFO] Chemical Detector Handler restarting for variable: %1", _variable];
	[_markerList, _size, _unit, _variable] spawn RS_Radiation_fnc_ChemicalDetectorHandler;
};