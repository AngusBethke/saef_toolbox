/*
	fn_RiftMarkerHandler.sqf
	Description: Handles the showing/hiding of radiation zone markers
	[] spawn RS_Rift_fnc_RiftMarkerHandler;
*/

private
[
	"_markerList"
	,"_rftMarkerList"
];

_markerList = [];
_rftMarkerList = [];

{
	if (["rift_zone", _x] call BIS_fnc_inString) then
	{
		_rftMarkerList pushBack _x;
	};
} forEach allMapMarkers;

{
	_mPos = markerPos _x;
	_pos = [(((_mPos select 0) - random(100)) + 100), (((_mPos select 1) - random(100)) + 100)];

	// Get the Position and Marker Name
	_sanMarkName = ((_x splitString "_") joinString "-");
	_markerName = format ["%1_RiftMarker_%2", _x, _forEachIndex];
	
	// Spawn the Marker with Parameters
	_marker = createMarker [_markerName, _pos];
	_markerName setMarkerShape "ELLIPSE";
	_markerName setMarkerSize [250, 250];
	_markerName setMarkerColor "colorCivilian";
	_markerName setMarkerAlpha 0.25;
	_markerName setMarkerDir random(360);
	
	// Add Marker to List of Markers to Clean Up
	_markerList pushBack _markerName;
} forEach _rftMarkerList;

// Hang tight until it's time to delete all the markers
waitUntil {
	sleep 10;
	(missionNamespace getVariable ["RS_RiftClosed", false])
};

// Delete the rift markers
{
	deleteMarker _x;
} forEach _markerList;