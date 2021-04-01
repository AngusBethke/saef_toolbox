# SAEF Locations Toolset
This toolset provides a few functions useful in interacting with buildings and locations

## Functions
1. **In Building** - given a position returns the nearest building and whether or not that position is inside of it
```
private
[
  "_position",
  "_inBuildingInfo"
];

_position = (getPos player);

_inBuildingInfo = [_position] call RS_LC_fnc_InBuilding;
_inBuildingInfo params
[
	"_inside",
	"_building"
];
```

2. **List Locations** - returns all locations in a 40km radius from based world pos [0,0,0]
```
private
[
  "_locations"
];

_locations = [] call RS_LC_fnc_ListLocations;
```
