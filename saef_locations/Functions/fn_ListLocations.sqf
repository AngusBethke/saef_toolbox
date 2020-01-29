/*
	fn_ListLocations.sqf
	Description: Returns a list of all town locations on map
	Parameters: None
	Returns: <array> Array of Location Objects
*/

private
[
	"_allLocations"
];

_allLocations = nearestLocations [[0,0,0], ["NameCity", "NameCityCapital", "NameVillage", "NameLocal"], 40000];

// Return All Town Locations
_allLocations