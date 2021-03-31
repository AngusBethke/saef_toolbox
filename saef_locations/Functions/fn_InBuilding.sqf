/*	
	fn_InBuilding.sqf

	Description: 
		Returns a boolean value and the building based on whether or not a passed position is inside a building
*/

params
[
	"_position"
];

// Grab the nearest building and information about that building
private
[
	"_building",
	"_relPos",
	"_boundingBox"
];

_building = nearestObject [_position, "HouseBase"];
_relPos = _building worldToModel _position;
_boundingBox = boundingBox _building;

// Min and Max from the bounding box Array
private
[
	"_min",
	"_max"
];

_min = _boundingBox select 0;
_max = _boundingBox select 1;

// Relative Positions from the relPos Array
private
[
	"_myX",
	"_myY",
	"_myZ"
];

_myX = _relPos select 0;
_myY = _relPos select 1;
_myZ = _relPos select 2;

// Logical Tests
private
[
	"_inside"
];

if ((_myX > (_min select 0)) and (_myX < (_max select 0))) then 
{
	if ((_myY > (_min select 1)) and (_myY < (_max select 1))) then 
	{
		if ((_myZ > (_min select 2)) and (_myZ < (_max select 2))) then 
		{
			_inside = true;
		} 
		else 
		{ 
			_inside = false; 
		};
	} 
	else 
	{ 
		_inside = false; 
	};
} 
else 
{ 
	_inside = false; 
};

// Returns: Boolean
[_inside, _building]