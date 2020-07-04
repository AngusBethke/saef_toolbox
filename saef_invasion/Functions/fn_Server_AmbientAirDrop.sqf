/* 
	fn_Server_AmbientAirDrop.sqf
	
	Description:
		Creates the supplied number of planes that fly over the drop zone to drop empty parachutes.
		This is an effort to create an ambient environment feeling of a larger airborne invasion.
		
	How to Call:
		[
			_planeCount,
			_phaseVar
		] spawn RS_INV_fnc_Server_AmbientAirDrop;
*/

params
[
	"_planeCount",
	"_phaseVar"
];

private
[
	"_sMarkers",
	"_gMarkers",
	"_dMarkers",
	"_countPlanes",
	"_debug",
	"_plane"
];

_strMarker = missionNamespace getVariable ["RS_INV_AmbientAirDrop_Start", ""];
_endMarker = missionNamespace getVariable ["RS_INV_AmbientAirDrop_End", ""];
_drpMarker = missionNamespace getVariable ["RS_INV_AmbientAirDrop_Drop", ""];

_zoneSize = 1000;

while {(missionNamespace getVariable [_phaseVar, 1]) < 2} do
{
	for "_i" from 1 to _planeCount do
	{
		_startPosition = [
			((((markerPos _strMarker) select 0) + 50) - random(100)),
			((((markerPos _strMarker) select 0) + (_zoneSize / 2)) - ((_zoneSize / _planeCount) * _i)),
			(250 + (random 50))
		];
		
		_dropPosition = [
			((((markerPos _drpMarker) select 0) + 50) - random(100)),
			((((markerPos _drpMarker) select 0) + (_zoneSize / 2)) - ((_zoneSize / _planeCount) * _i)),
			(250 + (random 50))
		];
		
		_endPosition = [
			((((markerPos _endMarker) select 0) + 50) - random(100)),
			((((markerPos _endMarker) select 0) + (_zoneSize / 2)) - ((_zoneSize / _planeCount) * _i)),
			(250 + (random 50))
		];
		
		_plane = [_startPosition, _endPosition, "", (markerDir _strMarker), false] call RS_INV_fnc_Server_SpawnPlane;
		[_plane, _dropPosition] spawn RS_INV_fnc_Server_AmbientAirDropPara;
		[_plane, _endPosition] spawn RS_INV_fnc_Server_PlaneCleanup;
		
		["RS_INV_fnc_Server_AmbientAirDrop", 3, (format ["Invasion Function: Spawned Ambient Plane No.%1 (%2) and called [RS_INV_fnc_Server_AmbientAirDropPara] / [RS_INV_fnc_Server_PlaneCleanup]", _i, _plane]), true] call RS_fnc_LoggingHelper;
		
		if (_i == _countPlanes) then
		{
			["RS_INV_fnc_Server_AmbientAirDrop", 3, "All ambient planes spawned, waiting until they are deleted to re-initialise the script", true] call RS_fnc_LoggingHelper;
		};
		
		sleep 2;
	};
	
	waitUntil {sleep 10; (isNull _plane)};
};

/* 
	END
*/