/*
	Moved to saef_toolbox from the SAEF Mission Framework (Scripts\Vehicle\InsertExtract_ion.sqf).
	The framework keeps Scripts\Vehicle\InsertExtract_ion.sqf as a wrapper that forwards to SAEF_VEH_fnc_InsertExtract.
*/

/*
	InsertExtract_ion.sqf

	Description: 
		Scripted Helicopter Extraction
	
	How to Call: 
		["marker_1", pos_1] execVM "Scripts\Vehicle\InsertExtract_ion.sqf";
		["marker_1", pos_1, "RHS_MELB_MH6M", "INSERT"] execVM "Scripts\Vehicle\InsertExtract_ion.sqf";
*/

params
[
	"_startMarker",
	"_exPos",
	["_heloType", "B_Heli_Transport_03_F"],
	["_type", "EXTRACT"]
];

private
[
	"_helipad",
	"_moveMarker"
];

_helipad = "Land_HelipadEmpty_F" createVehicle (getPosASL _exPos); 
_moveMarker = createMarker [(format["%1_%2", _type, _exPos]), (getPosASL _exPos)]; 

// Spawn the Helicopter
private
[
	"_veh"
];

_veh = [[(markerPos _startMarker) select 0, (markerPos _startMarker) select 1, 30], (markerDir _startMarker), _heloType, WEST] call BIS_fnc_spawnVehicle;

// Set some Default settings for the Group
private
[
	"_helo",
	"_heloCrew",
	"_heloGroup"
];

_helo = _veh select 0;
_heloCrew = crew _helo;
_heloGroup = group (_heloCrew select 0);
_heloGroup move (getMarkerPos _moveMarker);

if (_type == "INSERT") then 
{
	missionNamespace setVariable ["InsertionHelicopter", _helo, true];
};

{
	_x params ["_unit"];

	_unit flyInHeight 30;
	_unit allowFleeing 0;
	_unit allowDammage false;
} forEach units _heloGroup;

_heloGroup setBehaviour "CARELESS";
_helo allowDammage false;

// Wait Until Heli is close to extraction point, and then order them to land
waitUntil {
	sleep 1; 
	(_helo distance2D (markerPos _moveMarker) < 150)
};

_heloGroup setSpeedMode "LIMITED";

// Bug Fix to Prevent Helo from Hovering above the ground
waitUntil {
	sleep 1; 
	(unitReady (leader _heloGroup))
};

private
[
	"_landType"
];

_landType = "GET IN";
if (_type == "INSERT") then 
{
	_landType = "GET OUT";
};

if (_heloType == "B_Heli_Transport_03_F") then 
{
	_helo animateDoor ["Door_rear_source", 1, false];
};

// Land
_helo land _landType;
_helo landAT _helipad;

if (_type == "EXTRACT") then 
{
	[_heloType, "ExtractComplete"] spawn SAEF_VEH_fnc_WaitForPlayersInVehicle;
	
	// Wait for mission variable to order Helos to Leave
	waitUntil {
		sleep 1; 
		missionNamespace getVariable ["ExtractComplete", false]
	};
}
else {
	waitUntil {
		sleep 1; 
		((_helo distance _exPos) < 4)
	};
	
	// Force players out of the Helo
	{
		_x params ["_unit"];

		if (isPlayer _unit) then 
		{
			[_unit, ["Eject", _helo]] remoteExecCall ["action", _unit, false]; 
		};
		
	} forEach (crew _helo);
};

_heloGroup move (getMarkerPos _startMarker);
_heloGroup setSpeedMode "NORMAL";

if (_type == "INSERT") then 
{
	// Wait Until Heli is close to extraction point, and then order them to land
	waitUntil {
		sleep 1; 
		(_helo distance2D (markerPos _startMarker) < 150)
	};

	missionNamespace setVariable ["InsertionHelicopter", nil, true];

	/* 	
		Double Check that there are no players in the Helo, if there are, Eject them 
		Else deletes all the crew in the Helo	
	*/
	{
		_x params ["_unit"];

		if (isPlayer _unit) then
		{
			[_unit, ["Eject", _helo]] remoteExecCall ["action", _unit, false]; 
		}
		else
		{
			deleteVehicle _unit;
		};
	} forEach crew _helo;

	// Deletes the Helo
	deleteVehicle _helo;
};