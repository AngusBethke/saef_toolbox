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
		_uidArray = _uidArray + [_uid];
		missionNamespace setVariable ["ST_TrackUIDs", _uidArray, true];
		
		// Increase the Total Player Count
		_countPlayers = missionNamespace getVariable "ST_TotalPlayerCount";
		_countPlayers = _countPlayers + 1;
		missionNamespace setVariable ["ST_TotalPlayerCount", _countPlayers, true];
		
		// Add Player Name to the Array of Joined Players
		_playerNames = missionNamespace getVariable "ST_MissionAttendees";
		_playerNames = _playerNames + [_name];
		missionNamespace setVariable ["ST_MissionAttendees", _playerNames, true];
	};
}];

/*
	END
*/