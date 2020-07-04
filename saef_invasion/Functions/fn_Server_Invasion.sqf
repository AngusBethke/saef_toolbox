/* 
	fn_Server_Invasion.sqf
	
	Description: 
		Handles the spawning of the planes, and assigning units to those planes.
		
	How to Call:
		[] call RS_INV_fnc_Server_Invasion;
		
	Called by:
		fn_Init_ServerInvasion.sqf
*/

private
[
	"_allPlayers",
	"_countSeats",
	"_countPlanes",
	"_positions"
];

// Cultivate player list
_allPlayers = allPlayers - (entities "HeadlessClient_F");
_countSeats = (missionNamespace getVariable ["RS_INV_PlaneSeatCount", 4]);
_countPlanes = ceil ((count _allPlayers) / _countSeats);

// Default Spawn Positions
_positions = missionNamespace getVariable ["RS_INV_PlaneSpawnPositionArray", []];

// Error out if we have no spawn positions
if (_positions isEqualTo []) exitWith
{
	["RS_INV_fnc_Server_Invasion", 1, "No spawn positions found for plane in variable 'RS_INV_PlaneSpawnPositionArray'!", false] call RS_fnc_LoggingHelper;
};

// Set the player's assigned plane and slot
for "_i" from 0 to _countPlanes do
{
	// If we've emptied the array then we need to populate it again
	if (_positions isEqualTo []) then
	{
		_positions = missionNamespace getVariable ["RS_INV_PlaneSpawnPositionArray", []];
	};

	// Derive our spawn positions
	_position = selectRandom _positions;
	_positions = _positions - [_position];
	_position = _position + [true];
	
	_plane = _position call RS_INV_fnc_Server_SpawnPlane;
	
	for "_j" from 0 to _countSeats do
	{
		if (!(_allPlayers isEqualTo [])) then
		{
			// Get the player and remove them from the array
			_player = selectRandom _allPlayers;
			_allPlayers = _allPlayers - [_player];
			
			// Assign the player a seat and a plane
			_player setVariable ["RS_INV_AssignedPlane", [(_plane, _j], true];
		}:
	};
};

// Mark the Invasion Started for the Client Script Portion to pick it up
missionNamespace setVariable ["RS_INV_Invasion_Started", true, true];

/*
	END
*/