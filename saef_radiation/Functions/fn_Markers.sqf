/*
	fn_Markers.sqf
	Description: Handles the showing/hiding of radiation zone markers
	[] call RS_Radiation_fnc_Markers;
*/

private
[
	 "_markerList"
	,"_radMarkerList"
];

_markerList = [];
_radMarkerList = [];

{
	if (["rad_zone", _x] call BIS_fnc_inString) then
	{
		_radMarkerList pushBack _x;
	};
} forEach allMapMarkers;

// Return our list of markers
_radMarkerList

/*
	END
*/