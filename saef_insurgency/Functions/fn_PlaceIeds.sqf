/*
	fn_PlaceIeds.sqf
	Description: Places Ieds on roads in a given radius.
*/

params
[
	 "_pos"
	,"_rad"
];

_roads = _pos nearRoads _rad;
_nIed = ceil(_rad/25);

for "_i" from 0 to (_nIed - 1) do
{
	// Select a random road segment then remove it from the array
	_road = selectRandom _roads;
	_roads = _roads - [_road];
	
	// Create an ied on the road segment
	_ied = "ACE_IEDUrbanSmall_Range_Ammo" createVehicle (position _road);
	
	// Reveal Mine to AI so that they wont accidentally set them off
	EAST revealMine _ied; 
	CIVILIAN revealMine _ied; 
	RESISTANCE revealMine _ied; 
	WEST revealMine _ied; 
};