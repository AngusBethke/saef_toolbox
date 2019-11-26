/*
	fn_RiftMarkerHandler.sqf
	Description: Handles the showing/hiding of radiation zone markers
	[] spawn RS_Rift_fnc_RiftMarkerHandler;
*/

private
[
	"_markerList"
	,"_rftMarkerList"
	,"_size"
];

_markerList = [];
_rftMarkerList = [];
_size = 500;

{
	if (["rift_zone", _x] call BIS_fnc_inString) then
	{
		_rftMarkerList pushBack _x;
	};
} forEach allMapMarkers;

{
	_mPos = markerPos _x;
	
	// Derive Some Variables From External Functions
	_gridInfo = [(_size / 2), _mPos] call RS_Radiation_fnc_GetGridInfo;
	_posGrid = (_gridInfo select 0);
	_gridSize = (_gridInfo select 1);

	for "_i" from 0 to (_gridSize - 1) do
	{
		for "_j" from 0 to (_gridSize - 1) do
		{
			// Get the Position and Marker Name
			_pos = ((_posGrid select _i) select _j);
			_markerName = format ["%1_RiftMarker_%2_%3", _x, (_pos select 0), (_pos select 1)];
			_perc = (1 - ((_mPos distance2D _pos) / _size));
			
			// Spawn the Marker with Parameters
			_marker = createMarker [_markerName, _pos];
			_markerName setMarkerShape "RECTANGLE";
			_markerName setMarkerSize [75, 75];
			_markerName setMarkerColor "colorCivilian";
			_markerName setMarkerAlpha _perc;
			_markerName setMarkerDir random(360);
			
			// Add Marker to List of Markers to Clean Up
			_markerList pushBack _markerName;
	
			sleep 0.025;
		};
	};
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