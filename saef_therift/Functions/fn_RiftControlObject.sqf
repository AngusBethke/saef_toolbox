/*
	fn_RiftControlObject.sqf

	Description: 
		Turns an object into a rift control object

	How to call:
		[_objectString, _delay] call RS_Rift_fnc_RiftControlObject;
*/

params
[
	"_objectString",
	["_delay", 0]
];

if (isNil _objectString) exitWith
{
	["Rift: Control Object", 1, (format ["Object [%1] does not exist, cannot initialise rift control object!", _objectString])] call RS_fnc_LoggingHelper;
};

private
[
	"_object",
	"_soundVariable"
];

_object = (call compile _objectString);
_soundVariable = (format ["RS_Rift_Run_%1_PointSounds", _objectString]);

// Enable Sounds on the Object - If this is the server
if (isServer) then
{
	[_object, _soundVariable] spawn RS_Rift_fnc_CreateRiftInteractionSounds;
	[_object, "Register"] call RS_Rift_fnc_RegisterRiftControlObject;
};

// Add ACE Action to the Object - If this is a player
if (hasInterface) then
{
	// Declare the Action
	_action = [(format ["TurnOffDevice_%1", _objectString]), "Disable Device", "",
	{
		params ["_target", "_player", "_params"];
		_params params ["_soundVariable", "_delay"];
			
		// Disable the target
		_target setVariable ["Rift_ControlObject_Enabled", false, true];
		
		[_soundVariable, _delay, _target] spawn { 
			params
			[
				"_soundVariable",
				"_delay",
				"_target"
			];

			if (_delay > 0) then
			{
				//[_delay] remoteExec ["RS_Rift_fnc_RiftControlObjectTimeout", 0, false];
				
				sleep _delay;
			};

			// Mark object disabled globally
			[_target, "Disable"] remoteExecCall ["RS_Rift_fnc_RegisterRiftControlObject", 2, true];

			// Disable the sounds
			missionNamespace setVariable [_soundVariable, false, true];
			
			// Turn Off the Light
			[_target, ["light_1_hit", 1]] remoteExecCall ["setHit", 0, true];
			_target setDamage 1;

			// Let everyone know the device is disabled
			"[<!>] Device Disabled [<!>]" remoteExecCall ["hintSilent", 0, false];
		};
	},
	{
		params ["_target", "_player", "_params"];
		
		// Check condition
		(_target getVariable ["Rift_ControlObject_Enabled", true])
	},
	{},
	[_soundVariable, _delay],[0,0,0], 5] call ace_interact_menu_fnc_createAction;

	// Map the Action to an Object
	[_object, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};