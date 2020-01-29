/*
	fn_CP_AddCustomLocations.sqf
	Description: Creates any custom locations before Civilian Presence needs them
*/

// Call the PreInitVariable Initialisation Function - if it doesn't find one, this should carry on regardless
if (!isNil "RS_fnc_PreInitVariables") then
{
	[] call RS_fnc_PreInitVariables;
};

_locations = missionNamespace getVariable ["RS_CivilianPresence_CustomLocations", []];

if (_locations isEqualTo []) then 
{
	diag_log format ["[RS Civilian Presence] [INFO] No Custom Locations Found"];
}
else
{
	{
		_name = _x select 0;
		_location = _x select 1;
		_customVariables = _x select 2;
		
		// Create the Location
		_customLocation = createLocation _location;
		
		// Set the location's name
		_customLocation setText _name;
		
		// Apply custom variables to the location
		{
			_customLocation setVariable _x;
		} forEach _customVariables;
		
		diag_log format ["[RS Civilian Presence] [INFO] Added Custom Location %1, at position %2", _name, (_location select 1)];
		
	} forEach _locations;
};