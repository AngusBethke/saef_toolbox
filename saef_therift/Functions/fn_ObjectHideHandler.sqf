/**
	@namespace RS_Rift
	@class TheRift
	@method RS_Rift_fnc_ObjectHideHandler
	@file fn_ObjectHideHandler.sqf
	@summary Handles hiding and showing of objects based on what state of the rift they're in.

**/

/*
	fn_ObjectHideHandler.sqf
	Description: Handles hiding and showing of objects based on what state of the rift they're in.
*/

private
[
	"_unit"
	,"_rift"
	,"_riftEntities"
	,"_riftObjects"
	,"_riftPlayers"
	,"_riftUnits"
];

_unit = _this select 0;
_rift = _this select 1;

_riftEntities = [];
_riftObjects = [];
_riftPlayers = [];
_riftUnits = [];

{
	if (_x getVariable ["RS_Rift_Object", false]) then
	{
		_riftEntities = _riftEntities + [_x];
	};
} forEach (entities "All");

{
	if (_x getVariable ["RS_Rift_Object", false]) then
	{
		_riftObjects = _riftObjects + [_x];
	};
} forEach (allMissionObjects "All");

{
	if (_x getVariable ["RS_Rift_Object", false]) then
	{
		_riftPlayers = _riftPlayers + [_x];
	};
} forEach allPlayers;

{
	if (_x getVariable ["RS_Rift_Object", false]) then
	{
		_riftUnits = _riftUnits + [_x];
	};
} forEach allUnits;

switch _rift do
{
	case "INSIDE":
	{
		{
			if (_x != _unit) then
			{
				_x hideObject false;
			};
		} forEach _riftEntities;
		
		{
			if (_x != _unit) then
			{
				_x hideObject false;
			};
		} forEach _riftObjects;
		
		{
			if (_x != _unit) then
			{
				_x hideObject false;
			};
		} forEach _riftPlayers;
		
		{
			if (_x != _unit) then
			{
				_x hideObject false;
			};
		} forEach _riftUnits;
	};
	case "OUTSIDE":
	{
		{
			if (_x != _unit) then
			{
				_x hideObject true;
			};
		} forEach _riftEntities;
		
		{
			if (_x != _unit) then
			{
				_x hideObject true;
			};
		} forEach _riftObjects;
		
		{
			if (_x != _unit) then
			{
				_x hideObject true;
			};
		} forEach _riftPlayers;
		
		{
			if (_x != _unit) then
			{
				_x hideObject true;
			};
		} forEach _riftUnits;
	};
	default
	{
		["RS Rift", 2, (format ["Rift type %1 Not Recognised", _rift])] call RS_fnc_LoggingHelper;
	};
};

/*
	END
*/