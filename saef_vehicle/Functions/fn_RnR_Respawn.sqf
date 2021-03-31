/*
	fn_RnR_Respawn.sqf

	Description: 
		Respawns the Vehicle
*/

params
[
	"_vehString",
	"_object",
	"_vehType",
	["_additionalScripts", []]
];

private
[
	"_exit",
	"_vehVarName",
	"_vehicle"
];

hint format ["Vehicle: Respawn Starting..."];

_exit = false;
_vehVarName = _vehString;

// If it exists already we need to handle some stuff
if (!(isNil _vehString)) then
{
	_vehicle = (call compile _vehString);

	if (isEngineOn _vehicle) exitWith 
	{
		_exit = true;
		hint format ["Vehicle: Cannot respawn while the engine is running!"];
	};

	if (canMove _vehicle) exitWith 
	{
		_exit = true;
		hint format ["Vehicle: Cannot respawn while it is still functional!"];
	};

	hint format ["Vehicle: Respawning..."];

	// Reset the variable name
	_vehVarName = vehicleVarName _vehicle;
	_vehicle setVehicleVarName "";
	[_vehicle, ""] remoteExecCall ["setVehicleVarName", 0, true];

	sleep 5;
};

if (_exit) exitWith {};

// Create the new Vehicle
_vehicle = _vehType createVehicle (getPos _object);
_vehicle setDir (getDir _object);

// Run any addition scripts if needed
if (!(_additionalScripts isEqualTo [])) then
{
	{
		_x params
		[
			"_params",
			"_script"
		];

		// Add the vehicle object to our parameters
		_params = [_vehicle] + _params;
		
		// Execute the script
		_params execVM _script;
	} forEach _additionalScripts;
};

// Re-set the vehicle varname
[_vehicle, _vehVarName] call SAEF_VEH_fnc_RnR_GlobalRename;

// Reset the queue variable (this will automatically re-add the actions to all the players)
private
[
	"_checkVar"
];

_checkVar = (format ["SAEF_RnR_Vehicle_%1_Checked", _vehString]);

{
	_x params ["_player"];
	_player setVariable [_checkVar, false, true];
} forEach (allPlayers - (entities "HeadlessClient_F"));

hint format ["Vehicle: Respawn Complete..."];

/*
	END
*/