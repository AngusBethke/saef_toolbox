/**
	@namespace RS_CP
	@class CivilianPresence
	@method RS_CP_fnc_GetWhiteListedLocations
	@file fn_GetWhiteListedLocations.sqf
	@summary Gets all whitelisted locations
    
	@param any _whiteList

	@return array

**/
/*
	fn_GetWhiteListedLocations.sqf
	Description: Gets all whitelisted locations
*/

params
[
	"_whiteList"
];

private
[
	"_locations",
	"_newLocations",
	"_whiteListedLocations"
];

// Input Parameters
_locations = [] call RS_LC_fnc_ListLocations;
_newLocations = [];
_whiteListedLocations = [];

if (_whiteList != "") then
{
	_whiteListedLocations = (call compile _whiteList);
};

if (!(_whiteListedLocations isEqualTo [])) then
{
	["RS Civilian Presence", 3, (format ["Starting Location Whitelist..."])] call RS_fnc_LoggingHelper;
	
	{
		private
		[
			"_pos",
			"_loc"
		];

		_pos = position _x;
		_loc = _x;
		
		{
			private
			[
				"_posWhite"
			];

			_posWhite = _x;
			if ((_pos distance2D _posWhite) <= 50) then
			{
				_newLocation = nearestLocation [_pos, ""];
				_newLocations pushBack _newLocation;
				["RS Civilian Presence", 3, (format ["White Listing Location %1 at position %2", (text _loc), _pos])] call RS_fnc_LoggingHelper;
			};
		} forEach _whiteListedLocations;
		
	} forEach _locations;
}
else
{
	["RS Civilian Presence", 2, (format ["No whitelisted locations found!"])] call RS_fnc_LoggingHelper;
};

// Return: Array
_newLocations

/*
	END
*/