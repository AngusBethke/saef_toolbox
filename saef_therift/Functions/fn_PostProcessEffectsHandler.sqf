/*
	fn_PostProcessEffectsHandler.sqf
	Description: Handles switching between rift post process effects and when inside and outside the rift.
*/

private
[
	"_unit"
	,"_rift"
	,"_handle"
];

_unit = _this select 0;
_rift = _this select 1;

// Disable Currently Running Post Process Effects
_handle = player getVariable ["RS_RiftColorCorrections", 0];
if (_handle != 0) then 
{
	_handle ppEffectEnable false;
	ppEffectDestroy _handle;
};

_handle = player getVariable ["RS_RiftChromAberration", 0];
if (_handle != 0) then 
{
	_handle ppEffectEnable false;
	ppEffectDestroy _handle;
};

_handle = player getVariable ["RS_RiftWetDistortion", 0];
if (_handle != 0) then 
{
	_handle ppEffectEnable false;
	ppEffectDestroy _handle;
};

switch _rift do
{
	case "INSIDE":
	{
		// Color Corrections
		0 = ["ColorCorrections", 1500, [0.6, 1.2, 0, [0, 0, 0, 0], [0.1, 0.1, 0.9, 0.8], [0.299, 0.587, 0.114, 0]]] spawn 
		{
			params ["_name", "_priority", "_effect", "_handle"];
			while {
				_handle = ppEffectCreate [_name, _priority];
				_handle < 0
			} do {
				_priority = _priority + 1;
			};
			_handle ppEffectEnable true;
			_handle ppEffectAdjust _effect;
			_handle ppEffectCommit 1;
			waitUntil {ppEffectCommitted _handle};
			
			// Set the player's currently running effect
			player setVariable ["RS_RiftColorCorrections", _handle, true];
		};
		
		// Chromatic Aberration
		0 = ["ChromAberration", 200, [0.01, 0.01, true]] spawn 
		{
			params ["_name", "_priority", "_effect", "_handle"];
			while {
				_handle = ppEffectCreate [_name, _priority];
				_handle < 0
			} do {
				_priority = _priority + 1;
			};
			_handle ppEffectEnable true;
			_handle ppEffectAdjust _effect;
			_handle ppEffectCommit 5;
			waitUntil {ppEffectCommitted _handle};
			
			// Set the player's currently running effect
			player setVariable ["RS_RiftChromAberration", _handle, true];
		};
		
		// Wet Distortion
		0 = ["WetDistortion", 300, [1, 0.05, 0.05, 4.10, 3.70, 2.50, 1.85, 0.0054, 0.0041, 0.05, 0.0070, 0.5, 0.3, 10, 6]] spawn
		{
			params ["_name", "_priority", "_effect", "_handle"];
			while {
				_handle = ppEffectCreate [_name, _priority];
				_handle < 0
			} do {
				_priority = _priority + 1;
			};
			_handle ppEffectEnable true;
			_handle ppEffectAdjust _effect;
			_handle ppEffectCommit 5;
			waitUntil {ppEffectCommitted _handle};
			
			// Set the player's currently running effect
			player setVariable ["RS_RiftWetDistortion", _handle, true];
		};
	};
	case "OUTSIDE":
	{
		// At the moment outside is basically just going to disable the effects
	};
	default
	{
		diag_log format ["[RS Rift] [WARNING] Rift type %1 Not Recognised", _rift];
	};
};

/*
	END
*/