/**
	@namespace RS_ST
	@class StatTrack
	@method RS_ST_fnc_TrackDeaths
	@file fn_TrackDeaths.sqf
	@summary If a player is killed, increase the casualty counter

**/


/*
	fn_TrackDeaths.sqf
	Description: If a player is killed, increase the casualty counter
	Author: Angus Bethke (a.k.a. Rabid Squirrel)
*/

_deathHandlerId = addMissionEventHandler ["EntityKilled", 
{
	// Get Basic Parameters
	params ["_killed", "_killer", "_instigator"];
	
	// Log the stat if "_killed" is a player
	if (isPlayer _killed) then
	{
		_casCount = missionNamespace getVariable "ST_Casualties";
		_casCount = _casCount + 1;
		missionNamespace setVariable ["ST_Casualties", _casCount, true];
		
		// For now to make sure it does indeed get logged
		["OnDeath"] call RS_ST_fnc_LogInfo;
	};
	
	// Check if this unit is a civilian
	_civilian = (([getNumber (configfile >> "CfgVehicles" >> typeOf _killed >> "side")] call BIS_fnc_sideType) == CIVILIAN);
	
	// Fix for ACE - Still buggy, counter arbitrarily stops at 7
	_killer = if (isNull _killer) then 
			{
				_killed getVariable ["ace_medical_lastDamageSource", _killer];
			} 
			else 
			{ 
				_killer
			};
	
	// If the AI isn't friendly, and was killed by a player track the kill
	if (!(_civilian) && ((isPlayer _killer) && (!isPlayer _killed))) then
	{
		_killCount = missionNamespace getVariable "ST_KillCount";
		_killCount = _killCount + 1;
		missionNamespace setVariable ["ST_KillCount", _killCount, true];
	};
	
	// If the AI is civilian, and was killed by a player track the kill
	if (_civilian && ((isPlayer _killer) && (!isPlayer _killed))) then
	{
		_civKillCount = missionNamespace getVariable "ST_CivKillCount";
		_civKillCount = _civKillCount + 1;
		missionNamespace setVariable ["ST_CivKillCount", _civKillCount, true];
	};
	
	// If a player was killed by another player, track the kill
	if ((isPlayer _killer) && (isPlayer _killed)) then
	{
		_ffCount = missionNamespace getVariable "ST_FriendlyFire";
		_ffCount = _ffCount + 1;
		missionNamespace setVariable ["ST_FriendlyFire", _ffCount, true];
	};
}];

/*
	END
*/