/*
	Moved to saef_toolbox from the SAEF Mission Framework (Scripts\Player\RespawnPoints.sqf).
*/

/*
	RespawnPoints.sqf

	Description:
		Handles usage of the respawn points

	Usage:
		["Activate", ["redeploy_point_1"]] spawn RS_fnc_RespawnPoints;
		["AceAction", ["redeploy_action_object_1", "redeploy_point"]] spawn RS_fnc_RespawnPoints;
*/

params
[
	"_type",
	["_params", []]
];

private
[
	"_variablePrefix"
];

_variablePrefix = "SAEF_RespawnPoint";

if (toUpper(_type) == "ACTIVATE") exitWith
{
	// Only the server should manage this
	if (!isServer) exitWith {};

	_params params
	[
		"_marker",
		["_markerType", "hd_flag"]
	];

	_marker setMarkerType _markerType;

	missionNamespace setVariable [(format ["%1_%2_Active", _variablePrefix, _marker]), true, true];
};

if (toUpper(_type) == "ACEACTION") exitWith
{
	// Only the players should manage this
	if (!hasInterface) exitWith {};

	_params params
	[
		"_strActionObject",
		"_markerPrefix"
	];

	if (isNil _strActionObject) exitWith 
	{
		["Scripts\Player\RespawnPoints.sqf", 2, (format ["Unable to find object [%1] in mission...", _strActionObject])] call RS_fnc_LoggingHelper;
	};

	private
	[
		"_markers"
	];

	_markers = [];

	{
		if ([_markerPrefix, _x] call BIS_fnc_inString) then
		{
			_markers pushBack _x;
		}
	} forEach allMapMarkers;

	private
	[
		"_actionObject",
		"_actionName",
		"_action"
	];

	// Parse the Object
	_actionObject = (call compile _strActionObject);

	// Create the parent action
	_actionName = (format ["SAEF_RespawnAction_%1", (vehicleVarName _actionObject)]);
	_action = [_actionName, "Deploy Points", "", {}, {true}, {}, [], [0,0,0], 100] call ace_interact_menu_fnc_createAction;
	[_actionObject, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

	{
		private
		[
			"_marker",
			"_childActionName"
		];

		_marker = _x;
		_childActionName = (format ["SAEF_RespawnAction_%1_Marker_%2", (vehicleVarName _actionObject), _forEachIndex]);

		["Scripts\Player\RespawnPoints.sqf", 0, (format ["DEBUG - Adding Action: %1", _childActionName])] call RS_fnc_LoggingHelper;

		// Create the child actions
		_action = [_childActionName, (markerText _marker), "", 
			{
				params ["_target", "_player", "_params"];
				_params params ["_variablePrefix", "_marker"];

				// Teleport player to that marker
				player setPos (markerPos _marker);
			},
			{
				params ["_target", "_player", "_params"];
				_params params ["_variablePrefix", "_marker"];

				// Ensure spawn point is active
				(missionNamespace getVariable [(format ["%1_%2_Active", _variablePrefix, _marker]), false])
			},
			{}, [_variablePrefix, _marker], [0,0,0], 100
		] call ace_interact_menu_fnc_createAction;

		[_actionObject, 0, ["ACE_MainActions", _actionName], _action] call ace_interact_menu_fnc_addActionToObject;
	} forEach _markers;
};