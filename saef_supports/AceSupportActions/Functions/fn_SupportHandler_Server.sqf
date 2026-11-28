/*
	fn_SupportHandler_Server.sqf

	Description:
		Handles progression of supports on the server

	How to Call:
		[
			"_vehicle",
			"_variableTag",
			"_unit",
			"_startPos",
			["_pilotLoadout", ""]
		] spawn SAEF_ASA_fnc_SupportHandler_Server;
*/

params
[
	"_vehicle",
	"_variableTag",
	"_unit",
	"_startPos",
	"_callsign",
	["_pilotLoadout", ""]
];

[format ["%1 now on station and available for tasking...", _callsign]] remoteExecCall ["hint", 0, false];

// Set global variable to handle exit from plane
missionNamespace setVariable [(format ["%1_Finished", _variableTag]), false, true];

// Wait until support is finished
waitUntil {
	sleep 1;
	(missionNamespace getVariable [(format ["%1_Finished", _variableTag]), false])
};

// Create an AI unit to fly the aircraft away
if (alive _vehicle) then
{
	private
	[
		"_group",
		"_pilot",
		"_waypoint",
		"_unitClassname"
	];

	switch (side _unit) do
	{
		case WEST:
		{
			_unitClassname = "B_Soldier_F";
		};

		case EAST:
		{
			_unitClassname = "O_Soldier_F";
		};

		case INDEPENDENT:
		{
			_unitClassname = "I_soldier_F";
		};

		default
		{
			_unitClassname = "B_Soldier_F";
		};
	};

	// Make the pilot a captive (so that he doesn't get shot at when departing)
	_group = createGroup [(side _unit), true];
	_pilot = _group createUnit [_unitClassname, [0,0,0], [], 5, "NONE"];
	_pilot setCaptive true;

	// Push the pilot into the vehicle
	_pilot moveInDriver _vehicle;
	_pilot allowDamage false;
	_vehicle allowDamage false;

	// Give the AI the pilot loadout if we have one
	if (_pilotLoadout != "") then
	{
		[_pilot] execVM _pilotLoadout;
	};

	// Setup the vehicle and pilot to be deleted
	[_group, _vehicle, _startPos] spawn 
	{
		params
		[
			"_group",
			"_vehicle",
			"_startPos"
		];

		sleep 1;

		private
		[
			"_waypoint",
			"_control"
		];

		_waypoint = _group addWaypoint [_startPos, 0];
		_waypoint setWaypointType "MOVE"; 
		_waypoint setWaypointSpeed "NORMAL";
		_waypoint setWaypointBehaviour "CARELESS";

		_control = 1;
		waitUntil {
			sleep 1;
			_control = _control + 1;

			((((leader _group) distance2D _startPos) <= 200) || (_control >= 480))
		};

		// Delete the pilot and the vehicle
		{
			deleteVehicle _x;
		} forEach (units _group);
		
		deleteVehicle _vehicle;
	};
}
else
{
	missionNamespace setVariable [(format ["%1_Timer_Penalty", _variableTag]), (missionNamespace getVariable [(format ["%1_Timer", _variableTag]), 0]), true];
};

// Set the variable for time remaining until support is accessable
[
	true, 
	((missionNamespace getVariable [(format ["%1_Timer", _variableTag]), 0]) + (missionNamespace getVariable [(format ["%1_Timer_Penalty", _variableTag]), 0])), 
	(format ["%1_Available_Time", _variableTag])
] call SAEF_ASA_fnc_TimeUntilGivenTime;

// Sleep required time
sleep ((missionNamespace getVariable [(format ["%1_Timer", _variableTag]), 0]) + (missionNamespace getVariable [(format ["%1_Timer_Penalty", _variableTag]), 0]));

// Reset Time Penalty
missionNamespace setVariable [(format ["%1_Timer_Penalty", _variableTag]), 0, true];

// Re-enable the air support
missionNamespace setVariable [(format ["%1_Available", _variableTag]), true, true];