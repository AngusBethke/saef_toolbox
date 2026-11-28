/*
	fn_initPlayerSupports.sqf

	Description:
		Initialises player support related variables and scripts

	How to Call:
		[] call SAEF_ASA_fnc_InitPlayer;
*/

// Should only execute on players
if (!hasInterface) exitWith {};

[] spawn 
{
	private
	[
		"_control"
	];

	// Control for loop breakout
	_control = 1;

	waitUntil {
		sleep 1;

		_control = _control + 1;

		((missionNamespace getVariable ["SAEF_ASA_Supports_ServerInitComplete", false]) || (_control == 100))
	};

	// Only initialise the actions if breakout condition was not met
	if (_control < 100) then
	{
		// Add personal support actions
		[] call SAEF_ASA_fnc_Player_PersonalSupportActions;

		// Add designator actions
		["DeployAction"] call SAEF_ASA_fnc_MobileSupportObject;

		// Add deployment actions if any
		private
		[
			"_deploymentObjects"
		];

		_deploymentObjects = missionNamespace getVariable ["SAEF_ASA_DeploymentBeacons", []];

		{
			private
			[
				"_deploymentObject"
			];

			_deploymentObject = _x;

			["DeployAction", _deploymentObject] call SAEF_ASA_fnc_DeploymentBeacon;
			["CargoActions", _deploymentObject] call SAEF_ASA_fnc_DeploymentBeacon;

		} forEach _deploymentObjects;

		// Add deployment movement object actions if any
		private
		[
			"_deploymentMovementObjects"
		];

		_deploymentMovementObjects = missionNamespace getVariable ["SAEF_ASA_DeploymentMovementObjects", []];

		{
			_x params
			[
				"_beaconObjString",
				"_beaconName",
				["_deployPara", false]
			];

			{
				private
				[
					"_deploymentMovementObject",
					"_params"
				];

				_deploymentMovementObject = _x;
				_params = [_beaconObjString, _beaconName, _deploymentMovementObject];

				["MoveAction", _params] call SAEF_ASA_fnc_DeploymentBeacon;

			} forEach _deploymentMovementObjects;

		} forEach _deploymentObjects;
	};
};