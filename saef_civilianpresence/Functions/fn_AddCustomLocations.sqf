/**
	@namespace RS_CP
	@class CivilianPresence
	@method RS_CP_fnc_AddCustomLocations
	@file fn_AddCustomLocations.sqf
	@summary Creates any custom locations before Civilian Presence needs them

	@param int _customLocationString

**/
/*
	fn_AddCustomLocations.sqf
	Description: Creates any custom locations before Civilian Presence needs them
*/

params
[
	"_customLocationString"
];

private
[
	"_locations"
];

_locations = [];
if (_customLocationString != "") then
{
	_locations = (call compile _customLocationString);
};

if (_locations isEqualTo []) then 
{
	["RS Civilian Presence", 2, (format ["No Custom Locations Found"])] call RS_fnc_LoggingHelper;
}
else
{
	{
		_x params
		[
			"_name",
			"_location",
			"_customVariables"
		];
		
		// Create the Location
		_customLocation = createLocation _location;
		
		// Set the location's name
		_customLocation setText _name;
		
		// Apply custom variables to the location
		{
			_customLocation setVariable _x;
		} forEach _customVariables;
		
		["RS Civilian Presence", 3, (format ["Added Custom Location %1, at position %2", _name, (_location select 1)])] call RS_fnc_LoggingHelper;
		
	} forEach _locations;
};