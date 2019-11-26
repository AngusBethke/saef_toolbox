/*
	fn_MarkerHandler.sqf
	Description: Handles the showing/hiding of radiation zone markers
	[_unit, _markerList] call RS_Radiation_fnc_MarkerHandler;
*/


private
[
	 "_unit"
	,"_radMarkerList"
	,"_size"
	,"_markerList"
	,"_control"
];

_unit = _this select 0;
_radMarkerList = _this select 1;
_size = 500;
_markerList = [];

{
	_mPos = markerPos _x;
	
	// Derive Some Variables From External Functions
	_gridInfo = [_size, _mPos] call RS_Radiation_fnc_GetGridInfo;
	_posGrid = (_gridInfo select 0);
	_gridSize = (_gridInfo select 1);

	for "_i" from 0 to (_gridSize - 1) do
	{
		for "_j" from 0 to (_gridSize - 1) do
		{
			// Get the Position and Marker Name
			_pos = ((_posGrid select _i) select _j);
			_sanMarkName = ((_x splitString "_") joinString "-");
			_markerName = format ["%1-RadiationMarker_%2_%3", _sanMarkName, (_pos select 0), (_pos select 1)];
			
			// Spawn the Marker with Parameters
			_marker = createMarkerLocal [_markerName, _pos];
			_markerName setMarkerAlphaLocal 0;
			_markerName setMarkerShapeLocal "RECTANGLE";
			_markerName setMarkerSizeLocal [75, 75];
			_markerName setMarkerColorLocal "colorOPFOR";
			_markerName setMarkerDirLocal random(360);
			
			// Add Marker to List of Markers to Clean Up
			_markerList pushBack _markerName;
	
			sleep 0.025;
		};
	};
} forEach _radMarkerList;

// Add the controller for the markers
[] call RS_Radiation_fnc_MarkerAceAction;

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
					_mMarker = format["%1_%2_%3", (_mArr select 0), (_mArr select 1), (_mArr select 2)];
					_perc = (1 - (((markerPos _mMarker) distance2D (markerPos _marker)) / _size));
					
					// Show the marker
					_marker setMarkerAlphaLocal _perc;
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