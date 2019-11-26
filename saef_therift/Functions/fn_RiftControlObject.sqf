/*
	fn_RiftControlObject.sqf
	Description: Turns an object into a rift control object
	[_object, _increment] call RS_Rift_fnc_RiftControlObject;
*/

private
[
	"_object",
	"_increment"
];

_object = _this select 0;
_increment = _this select 1;

// Enable Sounds on the Object - If this is the server
if (isServer) then
{
	[_object, (format ["RS_Rift_Run_%1_PointSounds", _increment])] spawn RS_Rift_fnc_CreateRiftInteractionSounds;
};

// Add ACE Action to the Object - If this is a player
if (hasInterface) then
{
	// Declare the Action
	_action = [(format ["TurnOffDevice_%1", _increment]), "Disable Device", "",
	{
		params ["_target", "_player", "_params"];
		
		// Increment Control Variable
		_devicesDisabled = missionNamespace getVariable ["Rift_ControlObjects_DevicesDisabled", 0];
		_devicesDisabled = _devicesDisabled + 1;
		missionNamespace setVariable ["Rift_ControlObjects_DevicesDisabled", _devicesDisabled, true];
		[] execVM "Scripts\Mission\IncrementMission.sqf";
		
		// Disable the target
		_target setVariable ["Rift_ControlObject_Enabled", false, true];
		missionNamespace setVariable [(format ["RS_Rift_Run_%1_PointSounds", (_params select 0)]), false, true];
		[player, [(format ["RS_Rift_ControlObject_Run_RadiationHandler_%1", (_params select 0)]), false, true]] remoteExecCall ["setVariable", 0, true];
		
		// Turn Off the Light
		//[_target, 1] remoteExecCall ["setDamage", 2, false];
		[_target, ["light_1_hit", 1]] remoteExecCall ["setHit", 0, true];
	},
	{
		params ["_target", "_player", "_params"];
		
		// Check condition
		(_target getVariable ["Rift_ControlObject_Enabled", true])
	},
	{},[_increment],[0,0,0], 5] call ace_interact_menu_fnc_createAction;

	// Map the Action to an Object
	[_object, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};