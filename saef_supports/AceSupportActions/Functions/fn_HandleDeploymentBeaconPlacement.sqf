/*
	fn_HandleDeploymentBeaconPlacement.sqf

	Description:

*/

params
[
	"_beaconObj",
	"_beaconName",
	"_deployPara",
	"_position",
	"_direction"
];

// Move the beacon to the player
_beaconObj setPos _position;
_beaconObj setDir _direction;

// Create marker if it doesn't exist or move it if it does
private
[
	"_beaconMarkerName"
];

_beaconMarkerName = format ["SAEF_ASA_DeployObject_%1", (vehicleVarName _beaconObj)];

if (((markerPos _beaconMarkerName) isEqualTo [0,0,0]) || ((markerPos _beaconMarkerName) isEqualTo [0,0])) then
{
	private
	[
		"_beaconMarker"
	];

	// We do everything locally for a marker until the last step, as the entire marker's state is broadcasted for each change
	_beaconMarker = createMarkerLocal [_beaconMarkerName, _position];
	_beaconMarker setMarkerDirLocal _direction;
	_beaconMarker setMarkerTypeLocal "hd_arrow";
	_beaconMarker setMarkerColorLocal "colorBLUFOR";
	_beaconMarker setMarkerText _beaconName;
}
else
{
	// We do everything locally for a marker until the last step, as the entire marker's state is broadcasted for each change
	_beaconMarkerName setMarkerPosLocal _position;
	_beaconMarkerName setMarkerDir _direction;
};

// Mark the beacon as para deployment
_beaconObj setVariable ["SAEF_ASA_DeployObject_Para", _deployPara, true];