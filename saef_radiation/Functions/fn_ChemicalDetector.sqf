/**
	@namespace RS_Radiation
	@class Radiation
	@method RS_Radiation_fnc_ChemicalDetector
	@file fn_ChemicalDetector.sqf
	@summary Handles the chemical detector's display value

	@param array _markerList
	@param int _size
	@param unit _unit
	@param string _variable

	@usage ```[_markerList, _size, _unit, _variable] spawn RS_Radiation_fnc_ChemicalDetector;```

**/

/*
	fn_ChemicalDetector.sqf
	Description: Handles the chemical detector's display value
	[_markerList, _size, _unit, _variable] spawn RS_Radiation_fnc_ChemicalDetector;
*/

params
[
	"_markerList"
	,"_size"
	,"_unit"
	,"_variable"
];

private
[
	 "_message"
];

// Log load to server
_message = format ["[RS] [ChemicalDetector] [INFO] Handler started with parameters: %1", [_size, _unit, _variable]];
diag_log _message;

if (!isServer) then
{
	_message remoteExecCall ["diag_log", 2, false]; 
};

while { (_unit getVariable [_variable, false]) && (alive _unit) } do
{
	// Get our closest marker
	_closestMarkerObject = [_markerList, _size] call RS_Radiation_fnc_GetClosestMarker;
	_marker = (_closestMarkerObject select 0);
	_size = (_closestMarkerObject select 1);
	
	if (_marker != "") then
	{
		// Set the position for radiation checks
		_pos = markerPos _marker;
		_doNotBreak_Con = true;
		if (("ChemicalDetector_01_watch_F" in (assignedItems _unit)) && visibleWatch && ((_unit distance _pos) <= _size)) then
		{
			// Display screen overlay
			("RS_ChemicalDetector" call BIS_fnc_rscLayer) cutRsc ["RscWeaponChemicalDetector", "PLAIN", 1, false];
			
			// Get the object that is our chemical detector
			private _ui = uiNamespace getVariable "RscWeaponChemicalDetector";
			private _obj = _ui displayCtrl 101;
			
			while {((_unit distance _pos) <= _size) && visibleWatch && _doNotBreak_Con} do
			{
				// Adjust the threat level on the detector
				_dFactor = 1;
				if ((_unit distance _pos) != 0) then
				{
					_dFactor = (1 - (_unit distance _pos) / _size);
				};
				
				_obj ctrlAnimateModel ["Threat_Level_Source", _dFactor, true];
				
				// Do we need to break out?
				_newClosestMarkerObject = [_markerList, _size] call RS_Radiation_fnc_GetClosestMarker;
				_newMarker = (_newClosestMarkerObject select 0);
				
				// If our marker is still the same, then we shouldn't break out
				_doNotBreak_Con = (_newMarker == _marker);
				
				sleep 1;
			};
			
			_obj ctrlAnimateModel ["Threat_Level_Source", 0, true];
		}
		else
		{
			// Remove screen overlay
			("RS_ChemicalDetector" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
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
	[_markerList, _size, _unit, _variable] spawn RS_Radiation_fnc_ChemicalDetector;
};
