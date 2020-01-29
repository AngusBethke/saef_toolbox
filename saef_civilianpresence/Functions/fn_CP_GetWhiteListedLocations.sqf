/*
	fn_CP_GetWhiteListedLocations.sqf
	Description: Gets all whitelisted locations
*/

// Input Parameters
_locations = [] call RS_LC_fnc_ListLocations;
_newLocations = [];
_whiteListedLocations = missionNamespace getVariable ["RS_CivilianPresence_WhiteListedLocations", []];

if ((count _whiteListedLocations) > 0) then
{
	diag_log format ["[RS Civilian Presence] [INFO] Starting Location Whitelist..."];
	
	{
		_pos = position _x;
		_loc = _x;
		
		{
			_posWhite = _x;
			if ((_pos distance2D _posWhite) <= 50) then
			{
				_newLocation = nearestLocation [_pos, ""];
				_newLocations = _newLocations + [_newLocation];
				diag_log format ["[RS Civilian Presence] [INFO] White Listing Location %1", (text _loc)];
			};
		} forEach _whiteListedLocations;
		
	} forEach _locations;
}
else
{
	diag_log format ["[RS Civilian Presence] [ERROR] No whitelisted locations found!"];
};

// Return: Array
_newLocations

/*
	END
*/