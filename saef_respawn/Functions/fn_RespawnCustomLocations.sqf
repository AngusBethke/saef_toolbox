/*
	Moved to saef_toolbox from the SAEF Mission Framework (Scripts\Player\Respawn.sqf).
	The framework keeps Scripts\Player\Respawn.sqf as a wrapper that forwards to RS_fnc_RespawnCustomLocations.
*/

/*
	Respawn.sqf

	Description:
		Custom respawn scripts should be executed here

	[player] execVM "Scripts\Player\Respawn.sqf";
*/

params
[
	"_unit",
	["_setup", false]
];

if (_setup) exitWith
{
	_unit addEventHandler ["Killed", {
		params ["_unit", "_killer", "_instigator", "_useEffects"];

		_unit setVariable ["SAEF_Respawn_LastDeath_Location", (getPos _unit), true];
	}];
};

private
[
	"_respawnLocations"
];

_respawnLocations = missionNamespace getVariable ["SAEF_Respawn_Locations", []];

if (!(_respawnLocations isEqualTo [])) then
{
	private
	[
		"_closestRespawnLocation",
		"_closestDistance"
	];
	_closestRespawnLocation = [0,0,0];
	_closestDistance = 999999;

	{
		private
		[
			"_respawnLocation",
			"_deathLocation",
			"_newDistance"
		];

		_respawnLocation = _x;

		if ((typeName _respawnLocation) isEqualTo "STRING") then
		{
			_respawnLocation = (markerPos _respawnLocation);
		};

		_deathLocation = _unit getVariable ["SAEF_Respawn_LastDeath_Location", [0,0,0]];
		_newDistance = (_deathLocation distance _respawnLocation);

		["SAEF Respawn", 0, format ["Location information: %1", [_respawnLocation, _deathLocation, _newDistance, _closestRespawnLocation, _closestDistance]]] call RS_fnc_LoggingHelper;

		if (_newDistance < _closestDistance) then
		{
			_closestRespawnLocation = _respawnLocation;
			_closestDistance = _newDistance;
		};

	} forEach _respawnLocations;
	
	if (!((_closestRespawnLocation isEqualTo [0,0,0]) || (_closestRespawnLocation isEqualTo [0,0]))) then
	{
		_unit setPos _closestRespawnLocation;
	};
};