/*
	fn_FindRiftInteractionPoint.sqf
	Description:
		Helper for location of rift interaction points based on audio cues
		
	How to Call:
		[
			_size,
			_unit,
			_variable
		] spawn RS_Rift_fnc_FindRiftInteractionPoint;
*/

params
[
	"_size",
	"_unit",
	"_variable"
];

// Log load to server
_message = format ["[RS] [FindRiftInteractionPoint] [INFO] Handler started with parameters: %1", [_size, _unit, _variable]];
diag_log _message;

_rftMarkerList = [];

{
	if (["rift_zone", _x] call BIS_fnc_inString) then
	{
		_rftMarkerList pushBack _x;
	};
} forEach allMapMarkers;


while { (_unit getVariable [_variable, false]) && (alive _unit) } do
{
	// Get our closest marker
	_closestMarkerObject = [_rftMarkerList, _size] call RS_Radiation_fnc_GetClosestMarker;
	_marker = (_closestMarkerObject select 0);
	_size = (_closestMarkerObject select 1);

	if (_marker != "") then
	{
		_pos = (markerPos _marker);
		
		if ((_unit getVariable [_variable, false]) && ((_unit distance _pos) <= _size) && (alive _unit)) then
		{
			while { (_unit getVariable [_variable, false]) && ((_unit distance _pos) <= _size) && (alive _unit)} do
			{
				_reldir = (_unit getRelDir _pos);
				
				if ((_relDir <= 90) || (_relDir >= 270)) then
				{
					playSound "emp_rift_soft";
				};
				
				if ((_relDir <= 45) || (_relDir >= 315)) then
				{
					playSound "emp_rift_soft";
				};
				
				if ((_relDir <= 15) || (_relDir >= 345)) then
				{
					playSound "emp_rift_soft";
				};
				
				sleep 10;
			};
		};
	};
	
	sleep 5;
};

diag_log format ["[RS] [FindRiftInteractionPoint] [INFO] Handler stopped for variable: %1", _variable];

/*
	END
*/