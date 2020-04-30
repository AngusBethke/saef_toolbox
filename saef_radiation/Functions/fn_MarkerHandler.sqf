/*
	fn_MarkerHandler.sqf
	Description: Handles the showing/hiding of radiation zone markers
	[_unit, _markerList, _size] call RS_Radiation_fnc_MarkerHandler;
*/

params
[
	"_unit"
	,"_radMarkerList"
	,"_size"
];

private
[
	 "_markerList"
];

_markerList = [];

{
	_pos = markerPos _x;
	_mArr = _x splitString "_";
	
	_useSize = _size;
	if ((count _mArr) == 4) then
	{
		_useSize = parseNumber (_mArr select 2);
	};
	
	// Get the Position and Marker Name
	_sanMarkName = ((_x splitString "_") joinString "-");
	for "_i" from 1 to 3 do
	{
		_markerName = format ["%1-RadiationMarker_%2_%3", _sanMarkName, _forEachIndex, _i];
		
		// Spawn the Marker with Parameters
		_marker = createMarkerLocal [_markerName, _pos];
		_markerName setMarkerAlphaLocal 0;
		_markerName setMarkerShapeLocal "ELLIPSE";
		_markerName setMarkerSizeLocal [ceil(_useSize * (_i / 3)), ceil(_useSize * (_i / 3))];
		
		switch _i do
		{
			case 1:
			{
				_markerName setMarkerColorLocal "colorOPFOR";
			};
			case 2:
			{
				_markerName setMarkerColorLocal "ColorOrange";
			};
			default 
			{
				_markerName setMarkerColorLocal "ColorYellow";
			};
		};
		
		_markerName setMarkerDirLocal random(360);
		_markerName setMarkerBrushLocal "Cubism";
		
		// Add Marker to List of Markers to Clean Up
		_markerList pushBack _markerName;
	};
} forEach _radMarkerList;

// Add the controller for the markers
[] call RS_Radiation_fnc_MarkerAceAction;

// Log load to server
_message = format ["[RS] [MarkerHandler] [INFO] Handler started with parameters: %1", [_unit, "RS_RadiationZone_Run_RadiationMarkerHandler"]];
diag_log _message;

if (!isServer) then
{
	_message remoteExecCall ["diag_log", 2, false]; 
};

// Loop Controller for the Markers
_control = !(_unit getVariable ["RS_RadiationZone_ShowMarkers", false]);
while {_unit getVariable ["RS_RadiationZone_Run_RadiationMarkerHandler", false]} do
{
	// Make sure we don't do the marker check every time
	if !(_control isEqualTo (_unit getVariable ["RS_RadiationZone_ShowMarkers", false])) then
	{
		_control = (_unit getVariable ["RS_RadiationZone_ShowMarkers", false]);
		
		if (_unit getVariable ["RS_RadiationZone_ShowMarkers", false]) then
		{
			{
				_marker = _x;
				
				if ((markerAlpha _marker) == 0) then
				{
					// Derive some information about the marker
					_mArr = _marker splitString "-";
					_mArr = _mArr - [(_mArr select ((count _mArr) - 1))];
					_mMarker = _mArr joinString "_";
					
					_useSize = _size;
					if ((count _mArr) == 4) then
					{
						_useSize = parseNumber (_mArr select 2);
					};
					
					// Show the marker
					_marker setMarkerAlphaLocal 0.25;
				};
			} forEach _markerList;
		}
		else
		{
			{
				_marker = _x;
				
				if ((markerAlpha _marker) != 0) then
				{
					// Hide the marker
					_marker setMarkerAlphaLocal 0;
				};
			} forEach _markerList;
		};
	};
	
	sleep 5;
};