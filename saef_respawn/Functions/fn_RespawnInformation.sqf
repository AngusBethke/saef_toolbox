/*
	fn_RespawnInformation.sqf

	Description:
		Helper function to display information about the current respawn circumstances

	How to Call:
		[] call RS_fnc_RespawnInformation;
*/

params
[
	["_adminOverride", false],
	["_skipAdminInfo", false]
];

private
[
	"_isAdmin",
	"_hintStr",
	"_penaltyRespawnTimeLeft",
	"_respawnTimeLeft"
];

_isAdmin = (player getVariable ["RS_IsAdmin", false]);
_hintStr = "--------------------\n";
_hintStr = _hintStr + "Respawn Information:\n";
_hintStr = _hintStr + "--------------------\n\n";

_wr_RespawnTimeLeft = missionNamespace getVariable ["SAEF_Respawn_WaveRespawn_RespawnTimeLeft", 0];
_wr_PenaltyRespawnTimeLeft = missionNamespace getVariable ["SAEF_Respawn_WaveRespawn_PenaltyRespawnTimeLeft", 0];
_wr_MinTime = missionNamespace getVariable ["SAEF_Respawn_WaveRespawn_MinTime", 0];
_wr_PenaltyTime = missionNamespace getVariable ["SAEF_Respawn_WaveRespawn_PenaltyTime", 0];

_tr_RespawnTimeLeft = missionNamespace getVariable ["SAEF_Respawn_TimedRespawn_RespawnTimeLeft", 0];
_tr_WaitTime = missionNamespace getVariable ["SAEF_Respawn_TimedRespawn_WaitTime", 0];

if ((_isAdmin || _adminOverride) && !(_skipAdminInfo)) then
{
	// Running Handlers
	if (missionNamespace getVariable ["SAEF_Respawn_RunWaveRespawn", false]) then
	{
		_hintStr = _hintStr + "--------------------\n";
		_hintStr = _hintStr + "Wave Respawn Handler Information:\n";
		_hintStr = _hintStr + "--------------------\n";

		// Time left
		_hintStr = _hintStr + (format ["Time left until respawn starts: %1 seconds\n", _wr_RespawnTimeLeft]);
		_hintStr = _hintStr + (format ["Time left until penalty time ends: %1 seconds\n", _wr_PenaltyRespawnTimeLeft]);
		_hintStr = _hintStr + (format ["Time left until full respawn: %1 seconds\n", (_wr_RespawnTimeLeft + _wr_PenaltyRespawnTimeLeft)]);
	};

	if (missionNamespace getVariable ["SAEF_Respawn_RunTimedRespawn", false]) then
	{
		_hintStr = _hintStr + "--------------------\n";
		_hintStr = _hintStr + "Timed Respawn Handler Information:\n";
		_hintStr = _hintStr + "--------------------\n";

		// Time left
		_hintStr = _hintStr + (format ["Time left until respawn starts: %1 seconds\n", _tr_RespawnTimeLeft]);
	};

	if (!(missionNamespace getVariable ["SAEF_Respawn_RunWaveRespawn", false]) && !(missionNamespace getVariable ["SAEF_Respawn_RunTimedRespawn", false])) then
	{
		_hintStr = _hintStr + "No known respawn handlers running...\n";
	};
	
	_hintStr = _hintStr + "\n--------------------\n";
	_hintStr = _hintStr + "Non-admin user display:\n";
	_hintStr = _hintStr + "--------------------\n\n";
};

_hintStr = _hintStr + "Respawn time remaining:\n";
if ((missionNamespace getVariable ["SAEF_Respawn_RunWaveRespawn", false]) || (missionNamespace getVariable ["SAEF_Respawn_RunTimedRespawn", false])) then
{
	private
	[
		"_factor"
	];

	_factor = 0;

	if (missionNamespace getVariable ["SAEF_Respawn_RunWaveRespawn", false]) then
	{
		if (((_wr_RespawnTimeLeft != 0) || (_wr_PenaltyRespawnTimeLeft != 0)) && ((_wr_MinTime != 0) || (_wr_PenaltyTime != 0))) then
		{
			_factor = ((_wr_RespawnTimeLeft + _wr_PenaltyRespawnTimeLeft) / (_wr_MinTime + _wr_PenaltyTime)) * 10;
			_factor = ceil _factor;
		};
	};

	if (missionNamespace getVariable ["SAEF_Respawn_RunTimedRespawn", false]) then
	{
		if ((_tr_RespawnTimeLeft != 0) && (_tr_WaitTime != 0)) then
		{
			_factor = (_tr_RespawnTimeLeft / _tr_WaitTime) * 10;
			_factor = ceil _factor;
		};
	};

	// Time left
	if (_factor != 0) then
	{
		_hintStr = _hintStr + "[";
		
		for "_i" from 1 to _factor do
		{
			_hintStr = _hintStr + "*";
		};

		for "_i" from 1 to (10 - _factor) do
		{
			_hintStr = _hintStr + "-";
		};

		_hintStr = _hintStr + "]";
	}
	else
	{
		_hintStr = _hintStr + "[----------]";
	};
}
else
{
	_hintStr = _hintStr + "Unknown";
};

// Display the information:
hint _hintStr;