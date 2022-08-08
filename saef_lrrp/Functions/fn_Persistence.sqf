/*
	fn_Persistence.sqf

	Description:
		Manages the persistence setup from the profile namespace
*/

params
[
	"_type",
	["_params", []]
];

/*
	----------
	-- LOAD --
	----------

	Called on initialisation of the function library, creates necessary functionality
*/
if (toUpper(_type) == "INIT") exitWith
{
	// Only the server is allowed to load this
	if (!isServer) exitWith {};

	["LOAD"] call SAEF_LRRP_fnc_Persistence;
	
	addMissionEventHandler ["HandleDisconnect", {
		params ["_unit", "_id", "_uid", "_name"];
		["MAINTAIN_BERGEN_POOL", [_unit]] call SAEF_LRRP_fnc_Persistence;
	}];
};

/*
	----------
	-- LOAD --
	----------

	Called by init method, loads the information from persistence
*/
if (toUpper(_type) == "LOAD") exitWith
{
	// Only the server is allowed to load this
	if (!isServer) exitWith {};

	(profileNamespace getVariable ["SAEF_LRRP_Persistence", []]) params
	[
		["_commandTentLocation", [0,0,0]],
		["_commandTentDirection", 0],
		["_commandTentBergenCount", 60]
	];

	if (_commandTentLocation isEqualTo [0,0,0]) then
	{
		_commandTentLocation = (markerPos (missionNamespace getVariable ["SAEF_LRRP_CommandTent_Marker", "respawn"]));
		_commandTentDirection = (markerDir (missionNamespace getVariable ["SAEF_LRRP_CommandTent_Marker", "respawn"]))
	};

	missionNamespace setVariable ["SAEF_LRRP_CommandTent_BergenCount", _commandTentBergenCount, true];

	["Deploy", [_commandTentLocation, _commandTentDirection, _commandTentBergenCount]] spawn SAEF_LRRP_fnc_CommandTent;
};

/*
	----------
	-- SAVE --
	----------

	Called on deployment of the command tent, saves the information for persistence
*/
if (toUpper(_type) == "SAVE") exitWith
{
	// Only the server is allowed to save this
	if (!isServer) exitWith {};

	_params params
	[
		"_position",
		"_direction",
		"_bergenCount"
	];

	["SAEF_LRRP_fnc_Persistence", 0, (format ["Saving to server %1...", _params])] call RS_fnc_LoggingHelper;

	private
	[
		"_saefLRRPPersistence"
	];

	_saefLRRPPersistence = 
	[
		_position,					// Command Tent Location
		_direction,					// Command Tent Direction
		_bergenCount				// Command Tent Bergen Count
	];

	profileNamespace setVariable ["SAEF_LRRP_Persistence", _saefLRRPPersistence];

	// Save the profile namespace
	saveProfileNamespace;
};

/*
	-----------
	-- RESET --
	-----------

	No caller (must be called manually), resets the persistence values

	["RESET"] call SAEF_LRRP_fnc_Persistence;
*/
if (toUpper(_type) == "RESET") exitWith
{
	// Only the server is allowed to reset this
	if (!isServer) exitWith {};

	profileNamespace setVariable ["SAEF_LRRP_Persistence", nil];

	// Save the profile namespace
	saveProfileNamespace;
};

/*
	--------------------------
	-- MAINTAIN_BERGEN_POOL --
	--------------------------

	Called by the handle disconnect event handler, will maintain bergen pool on player disconnect
*/

if (toUpper(_type) == "MAINTAIN_BERGEN_POOL") exitWith
{
	// Only the server is allowed to execute this
	if (!isServer) exitWith {};

	_params params
	[
		"_unit"
	];

	if ((backpack _unit) in (missionNamespace getVariable ["SAEF_LRRP_AllowedBackpacks", []])) then
	{
		["BERGEN_UPDATE_SERVER", ["ADD"]] call SAEF_LRRP_fnc_CommandTent;
	};
};

// Log warning if type is not recognised
["SAEF_LRRP_fnc_Persistence", 2, (format ["Unrecognised type [%1], nothing is being executed!", _type])] call RS_fnc_LoggingHelper;