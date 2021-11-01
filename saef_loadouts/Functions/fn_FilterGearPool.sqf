/*
	fn_FilterGearPool.sqf

	Description:
		Filters the gear pool based on DLC that the user owns

	How to Call:
		[
			_randomGearPool		// Pool of gear to be filtered (array of classnames)
		] call RS_LD_fnc_FilterGearPool;
*/

params
[
	"_randomGearPool"
];

// If this is this is not a player we can hand the whole object back
if (!hasInterface) exitWith 
{
	_randomGearPool
};

// We need to filter the random gear pool by DLC we own
{
	_x params ["_item"];

	private
	[
		"_configTypes",
		"_configType"
	];

	_configTypes =
	[
		"CfgWeapons",
		"CfgVehicles",
		"CfgGlasses"
	];

	_configType = "";
	{
		_x params ["_testConfigType"];

		if (isClass (configFile >> _testConfigType >> _item)) exitWith
		{
			_configType = _testConfigType;
		};
	} forEach _configTypes;

	if (_configType != "") then
	{
		private
		[
			"_dlcInfo"
		];

		_dlcInfo = getAssetDLCInfo [_item, configFile >> _configType];
		_dlcInfo params
		[
			"_isDlc",			// Boolean - the asset belongs to a DLC
			"_isOwned",			// Boolean
			"_isInstalled",		// Boolean
			"_isAvailable",		// Boolean
			"_appID",			// String - actual steam item ID or "0" for none or "-1" for unknown
			"_DLCName"			// String - actual DLC name or ""
		];

		if (!_isOwned) then
		{
			_randomGearPool = _randomGearPool - [_item];
		};
	};
} forEach _randomGearPool;

// Return the gear pool
_randomGearPool