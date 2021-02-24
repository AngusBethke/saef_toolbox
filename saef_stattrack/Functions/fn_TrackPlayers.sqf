/*
	fn_TrackPlayers.sqf
	Description: Log players who have joined the server, with their names and UID
	Author: Angus Bethke (a.k.a. Rabid Squirrel)
*/

_playerHandlerId = addMissionEventHandler ["PlayerConnected",
{
	//Get Basic Parameters
	params ["_id", "_uid", "_name", "_jip", "_owner"];
	
	// Get UIDs
	_uidArray = missionNamespace getVariable "ST_TrackUIDs";
	_playerNew = true;
	
	// Make sure the player doesn't already exist
	{
		if (_uid == _x) then
		{
			_playerNew = false;
		};
	} forEach _uidArray;
	
	// Make sure the connected client isn't the server
	if (_id == 2) then
	{
		_playerNew = false;
	};
	
	//Make sure the connected client isn't the headless clientOwner
	if (_name == "headlessclient") then
	{
		_playerNew = false;
	};
	
	if (_playerNew) then
	{
		// Add the UID to the UID Array
		["ST_TrackUIDs", _uid] call RS_ST_fnc_Incrementer;
		
		// Increase the Total Player Count
		["ST_TotalPlayerCount", 1, true] call RS_ST_fnc_Incrementer;
		
		// Add Player Name to the Array of Joined Players
		["ST_MissionAttendees", _name] call RS_ST_fnc_Incrementer;
	};
}];

while {missionNamespace getVariable ["ST_TrackPlayers", false]} do
{
	sleep 120;

	{
		private
		[
			"_player",
			"_uid",
			"_name",
			"_uidArray",
			"_playerArray"
		];

		_player = _x;
		_uid = getPlayerUID _player;
		_name = name _player;

		_uidArray = missionNamespace getVariable "ST_TrackUIDs";
		_playerArray = missionNamespace getVariable "ST_MissionAttendees";

		if (!(_uid in _uidArray)) then
		{
			// Add the UID to the UID Array
			["ST_TrackUIDs", _uid] call RS_ST_fnc_Incrementer;
		};

		if (!(_name in _playerArray)) then
		{
			// Add Player Name to the Array of Joined Players
			["ST_MissionAttendees", _name] call RS_ST_fnc_Incrementer;
		};
		
		if (!(_uid in _uidArray) && !(_name in _playerArray)) then
		{
			// Increase the Total Player Count
			["ST_TotalPlayerCount", 1, true] call RS_ST_fnc_Incrementer;
		};
		
	} forEach (allPlayers - entities "HeadlessClient_F");

	private
	[
		"_uidFullArray"
	];

	_uidFullArray = missionNamespace getVariable "ST_TrackUIDs";
	_totalPlayerCount = missionNamespace getVariable "ST_TotalPlayerCount";

	if (_totalPlayerCount != (count _uidFullArray)) then
	{
		missionNamespace setVariable ["ST_TotalPlayerCount", (count _uidFullArray), true];
	};
};

/*
	END
*/