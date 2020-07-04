/*	
	fn_DynaSpawnValidation.sqf
	Author: Angus Bethke
	Required Mod(s): CBA
	Description: 
		Handles validation of input variables for DynaSpawn							
*/

params
[
	"_spawnPos",
	"_type",
	"_faction",
	"_facSide",
	"_areaOfOperation"
];

private
[
	"_posValid",
	"_spValid",
	"_azi",
	"_typeArray",
	"_grpValid",
	"_grValid",
	"_unitType"
];

["DynaSpawn", 4, (format ["[Validation] <IN> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;

// Uppercase Type
_type = toUpper(_type);

// Check if the SpawnPos is Valid
_posValid = [_spawnPos] call RS_DS_fnc_PositionValidation;
_spValid = (_posValid select 0);
_spawnPos = (_posValid select 1);
_azi = (_posValid select 2);

if (!_spValid) exitWith
{
	["DynaSpawn", 1, (format ["Spawn Position [%1] for DynaSpawn is not Valid!", _spawnPos])] call RS_fnc_LoggingHelper;
	
	// Return that this is not valid
	[false, []]
};

// Check to see if Type is Valid
_typeArray = ["PAT", "DEF", "CA", "HK", "GAR", "NON"];
if (!(_type in _typeArray)) then
{
	["DynaSpawn", 2, (format ["Type [%1] passed to DynaSpawn is not Valid! Defaulting to [%2]", _type, "NON"])] call RS_fnc_LoggingHelper;
	_type = "NON";
};

// If Type is Valid then use the Type to Check the SecondPos
if (_type == "CA" OR _type == "GAR" OR (_type == "HK" AND _usePara)) then
{
	_posValid = [_secondPos] call RS_DS_fnc_PositionValidation;
	_spValid = (_posValid select 0);
	_secondPos = (_posValid select 1);

	if (!_spValid) exitWith
	{
		["DynaSpawn", 1, (format ["Second Position [%1] for DynaSpawn is not Valid!", _secondPos])] call RS_fnc_LoggingHelper;
	
		// Return that this is not valid
		[false, []]
	};
};

// Check if the Unit/Group/Vehicle Passed is Valid
_grpValid = [_faction] call RS_DS_fnc_UnitValidation;
_grValid = (_grpValid select 0);
_unitType = (_grpValid select 1);

if (!_grValid) exitWith
{
	["DynaSpawn", 1, (format ["Units [%1] passed to DynaSpawn are not Valid!", _faction])] call RS_fnc_LoggingHelper;
	
	// Return that this is not valid
	[false, []]
};

//	Faction Side Validation
if (_facSide != WEST AND _facSide != EAST AND _facSide != INDEPENDENT AND _facSide != CIVILIAN) then
{
	["DynaSpawn", 2, (format ["Side [%1] passed to DynaSpawn is not Valid! Defaulting to %2", _facSide, EAST])] call RS_fnc_LoggingHelper;
	_facSide = EAST;
};

// Area of Operation Validation
if (_areaOfOperation < 1 OR _areaOfOperation > 4000) then
{
	["DynaSpawn", 2, (format ["AO Size [%1] passed to DynaSpawn is not Valid! Defaulting to %2", _areaOfOperation, 50])] call RS_fnc_LoggingHelper;
	_areaOfOperation = 50;
};

["DynaSpawn", 4, (format ["[Validation] <OUT> | Parameters: %1", _this])] call RS_fnc_LoggingHelper;

// Return valid and our variables
[true, [_spawnPos, _azi, _type, _secondPos, _faction, _unitType, _facSide, _areaOfOperation]]

/*
	END
*/