/*
	fn_ChemicalDetector.sqf
	Description: Handles the chemical detector's display value
	[_markerList, _size, _unit, _variable] spawn RS_Radiation_fnc_ChemicalDetector;
*/

private
[
	 "_pos"
	,"_defaultSize"
	,"_size"
	,"_unit"
	,"_variable"
	,"_marker"
];

_markerList = _this select 0;
_defaultSize = _this select 1;
_unit = _this select 2;
_variable = _this select 3;

while { (_unit getVariable [_variable, false]) && (alive _unit) } do
{
	// Get our closest marker
	_marker = "";
	{
		_distance = 99999;
		if (_marker != "") then
		{
			_distance = (_unit distance (markerPos _marker));
		};

		if ((_unit distance (markerPos _x)) < _distance) then
		{
			_marker = _x;
		};
	} forEach _markerList;

	// Set the position for radiation checks
	_pos = markerPos _marker;
	_mArr = _x splitString "_";
	
	// If our marker has 4 elements, then we parse the third one to the determine our zone's size
	_size = _defaultSize;
	if ((count _mArr) == 4) then
	{
		_size = parseText(_mArr select 2);
	};
	
	if (("ChemicalDetector_01_watch_F" in (assignedItems _unit)) && visibleWatch && ((_unit distance _pos) <= _size)) then
	{
		// Display screen overlay
		("RS_ChemicalDetector" call BIS_fnc_rscLayer) cutRsc ["RscWeaponChemicalDetector", "PLAIN", 1, false];
		
		// Get the object that is our chemical detector
		private _ui = uiNamespace getVariable "RscWeaponChemicalDetector";
		private _obj = _ui displayCtrl 101;
		
		while {((_unit distance _pos) <= _size) && visibleWatch} do
		{
			// Adjust the threat level on the detector
			_dFactor = 1;
			if ((_unit distance _pos) != 0) then
			{
				_dFactor = (1 - (_unit distance _pos) / _size);
			};
			
			_obj ctrlAnimateModel ["Threat_Level_Source", _dFactor, true];
			
			sleep 1;
		};
		
		_obj ctrlAnimateModel ["Threat_Level_Source", 0, true];
	}
	else
	{
		// Remove screen overlay
		("RS_ChemicalDetector" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
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
	[_markerList, _defaultSize, _unit, _variable] spawn RS_Radiation_fnc_ChemicalDetectorHandler;
};
