/**
	@namespace RS_INV
	@class Invasion
	@method RS_INV_fnc_Client_Reset
	@file fn_Client_Reset.sqf
	@summary Handles the clientside portion of the invasion process
	
	@param object _plane

	@todo param _plane but not included in usage call?

	@usage ```[] call RS_INV_fnc_Client_Reset;```
	
**/

/* 
	fn_Client_Reset.sqf
	
	Description: 
		Handles the clientside portion of the invasion process
		
	How to Call:
		[] call RS_INV_fnc_Client_Reset;
		
	Called by:
		fn_Server_PlaneCleanup.sqf
*/

params
[
	"_plane"
];

private
[
	"_respawnMarkers",
	"_respawnMarker"
];

// Kick any non-players out of this
if !(hasInterface) exitWith {};

// Kick any players not in the plane out of this
if !((vehicle player) == _plane) exitWith {};

// Find all the respawn markers
_respawnMarkers = [];
{
	if (["respawn", _x] call BIS_fnc_inString) then
	{
		_respawnMarkers pushBack _x;
	};
} forEach allMapMarkers;

// Find the respawn marker
_respawnMarker = "";
{
	_marker = (toLower _x);
	// If we have a default respawn marker - use it
	if (_marker == "respawn") then
	{
		_respawnMarker = _marker;
	};
	
	if ((toLower (format["respawn_%1", (side player)])) == _marker) then
	{
		_respawnMarker = _marker;
	};
	
} forEach _respawnMarkers;

// Move the player to their respawn marker
player setPos (markerPos _respawnMarker);
hint "[RS Invasion] Something has gone wrong! Please attempt the drop again...";

/*
	END
*/