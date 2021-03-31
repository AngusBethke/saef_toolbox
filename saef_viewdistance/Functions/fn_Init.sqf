/*
	fn_Init.sqf

	Description: 
		Initialises the event handlers for the server

	How to call: 
		[
			_defaultServerVD,		// (Optional) The default view distance for the server
			_defaultPlayerVD,		// (Optional) The default view distance for the player
			_defaultAircraftVD,		// (Optional) The default view distance for the aircraft
			_defaultShadowVD,		// (Optional) The default shadow view distance for everyone
			_defaultFixedCeiling	// (Optional) The capped ceiling for max view distance based on height
		] call SAEF_VD_fnc_Init;
*/

params
[
	["_defaultServerVD", 1200],
	["_defaultPlayerVD", 1200],
	["_defaultAircraftVD", 5000],
	["_defaultShadowVD", 50],
	["_defaultFixedCeiling", 150]
];

// Initialise all our variables
["SERVER", _defaultServerVD, _defaultPlayerVD, _defaultAircraftVD, _defaultShadowVD, _defaultFixedCeiling] call SAEF_VD_fnc_ViewDistance;

// Singleplayer debug - as the connected event handler will not fire in SP
if (isServer && hasInterface) then
{
	[] call SAEF_VD_fnc_PlayerInit;
};

addMissionEventHandler ["PlayerConnected",
{
	params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];

	// Setup the view distance for the player
	[] remoteExecCall ["SAEF_VD_fnc_PlayerInit", _owner, false];
}];