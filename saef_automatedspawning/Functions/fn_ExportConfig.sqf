/*
	fn_ExportConfig.sqf

	Description: Export the area config to clipboard
*/

private
[
	"_areaTags",
	"_structuredString"
];

_areaTags = (missionNamespace getVariable ["SAEF_AreaMarkerTags", []]);

if (!(_areaTags isEqualTo [])) exitWith
{
	private
	[
		"_variablesTracked"
	];
	_variablesTracked = [];

	_structuredString = (format ["// Tag Config %1", (toString [13,10])]);

	_variablesTracked pushBack "_areaTags";
	_structuredString = _structuredString + (format ["_areaTags = %1[%1", (toString [13,10])]);

	// Handle the tags
	{
		_x params
		[
			"_tag",
			"_name",
			"_config",
			["_overrides", []]
		];

		_structuredString = _structuredString + (format ["	[%1", (toString [13,10])]);
		_structuredString = _structuredString + (format ["		""%2"",%1		""%3"",%1		""%4""", (toString [13,10]), _tag, _name, _config]);

		if (!(_overrides isEqualTo [])) then
		{
			_structuredString = _structuredString + (format [",%1		[%1", (toString [13,10])]);
			{
				_structuredString = _structuredString + (format ["			%2", (toString [13,10]), _x]);

				// If this isn't the last override, add a comma
				if (_forEachIndex != ((count _overrides) - 1)) then
				{
					_structuredString = _structuredString + (format[",%1", (toString [13,10])]);
				};
			} forEach _overrides;
			_structuredString = _structuredString + (format ["%1		]", (toString [13,10])]);
		};

		_structuredString = _structuredString + (format ["%1	]", (toString [13,10])]);

		// If this isn't the last tag, add a comma
		if (_forEachIndex != ((count _areaTags) - 1)) then
		{
			_structuredString = _structuredString + (format [",%1", (toString [13,10])]);
		};
	} forEach _areaTags;

	_structuredString = _structuredString + (format ["%1];%1", (toString [13,10])]);
	_structuredString = _structuredString + (format ["missionNamespace setVariable [""SAEF_AreaMarkerTags"", _areaTags, true];%1%1", (toString [13,10])]);

	// Handle the config
	private
	[
		"_configCode"
	];

	_configCode = {
		_x params
		[
			"_tag",
			"_name",
			"_config",
			["_overrides", []]
		];

		_structuredString = _structuredString + (format ["// %2 Area Config %1", (toString [13,10]), _name]);

		private
		[
			"_params",
			"_paramCode",
			"_variable"
		];

		_params = missionNamespace getVariable [_config, []];

		_variable = format ["_var_%1", _config];
		_variablesTracked pushBack _variable;
		_structuredString = _structuredString + (format ["%2 = %1[%1", (toString [13,10]), _variable]);

		/*	
			// Parameter structure
			_params:
			[
				true 								// Block the Patrol Portion of the Area
				,false 								// Block the Garrison Portion of the Area
				,"RS_EnemyUnits" 					// Variable pointer to array of units for spawning
				,"RS_EnemySide" 					// Variable pointer to side of units for spawning
				,"RS_EnemyLightVehicles" 			// Variable pointer to array of light vehicles for spawning
				,"RS_EnemyHeavyVehicles" 			// Variable pointer to array of heavy vehicles for spawning
				,"RS_EnemyParaVehicles"				// Variable pointer to array of paradrop vehicles for spawning
				,{true} 							// Optional: Code block for extra validation passed to GetClosestPlayer
				,[] 								// Optional: Array of scripts run against the spawned group
				,{true}								// Optional: Code block for extra validation passed to the Message Queue
				,true								// Optional: Whether or not to include the default ending detector
			]
		*/

		_paramCode = {
			if ((typeName _x) == "STRING") then
			{
				_structuredString = _structuredString + (format ["	""%1""", _x]);
			}
			else
			{
				_structuredString = _structuredString + (format ["	%1", _x]);
			};

			// If this isn't the last variable, add a comma
			if (_forEachIndex != ((count _params) - 1)) then
			{
				_structuredString = _structuredString + (format [",%1", (toString [13,10])]);
			};
		};
		
		_paramCode forEach _params;
		
		_structuredString = _structuredString + (format ["%1];%1", (toString [13,10])]);
		_structuredString = _structuredString + (format ["missionNamespace setVariable [""%2"", _var_%2, true];%1%1", (toString [13,10]), _config]);

	}; 
	
	_configCode forEach _areaTags;

	// Handle the override config
	{
		_x params
		[
			"_tag",
			"_name",
			"_config",
			["_overrides", []]
		];

		private
		[
			"_modifiedOverrides"
		];

		_modifiedOverrides = [];

		{
			_x params ["_oTag", "_oConfig"];
			_modifiedOverrides pushBack [_oTag, (format ["%1 Override %2", _name, (_forEachIndex + 1)]), _oConfig];
		} forEach _overrides;

		_configCode forEach _modifiedOverrides;
	} forEach _areaTags;

	// Handle each set of parameters
	{
		_x params
		[
			"_tag",
			"_name",
			"_config",
			["_overrides", []]
		];

		private
		[
			"_params",
			"_paramCode"
		];

		_params = missionNamespace getVariable [_config, []];

		_paramCode = {
			if ((typeName _x) == "STRING") then
			{
				private
				[
					"_iConfig"
				];

				if (!([(format ["_var_%1", _x]), _structuredString] call BIS_fnc_InString)) then
				{
					_iConfig = missionNamespace getVariable [(format ["%1", _x]), []];
					_structuredString = _structuredString + (format ["// %2 %3 Config %1", (toString [13,10]), _name, _x]);
					
					if ((typeName _iConfig) == "SIDE") then
					{
						_variable = format ["_var_%1", _x];
						_variablesTracked pushBack _variable;
						_structuredString = _structuredString + (format ["%2 = %3;%1", (toString [13,10]), _variable, _iConfig]);
					};

					if ((typeName _iConfig) == "ARRAY") then
					{
						_variable = format ["_var_%1", _x];
						_variablesTracked pushBack _variable;
						_structuredString = _structuredString + (format ["%2 = %1[%1", (toString [13,10]), _variable]);

						{
							_structuredString = _structuredString + (format ["	""%1""", _x]);

							// If this isn't the last variable, add a comma
							if (_forEachIndex != ((count _iConfig) - 1)) then
							{
								_structuredString = _structuredString + (format [",%1", (toString [13,10])]);
							};
						} forEach _iConfig;
			
						_structuredString = _structuredString + (format ["%1];%1", (toString [13,10])]);
					};

					_structuredString = _structuredString + (format ["missionNamespace setVariable [""%2"", _var_%2, true];%1%1", (toString [13,10]), _x]);
				};
			};
		};
		
		_paramCode forEach _params;

		{
			_x params ["_tTag", "_tConfig"];

			_params = missionNamespace getVariable [_tConfig, []];
			_paramCode forEach _params;

		} forEach _overrides;

	} forEach _areaTags;

	private
	[
		"_variableString"
	];

	_variableString = (format ["private %1[%1", (toString [13,10])]);

	{
		_variableString = _variableString + (format ["	""%1""", _x]);

		// If this isn't the last variable, add a comma
		if (_forEachIndex != ((count _variablesTracked) - 1)) then
		{
			_variableString = _variableString + (format [",%1", (toString [13,10])]);
		};
	} forEach _variablesTracked;

	_variableString = _variableString + (format ["%1];%1%1", (toString [13,10])]);

	_structuredString = (format ["// ----- Exported SAEF Spawn Area Configuration Information ----- // %1%2", (toString [13,10]), _variableString]) + _structuredString;
	_structuredString = _structuredString + (format ["// ----- End of Exported SAEF Spawn Area Configuration Information ----- //"]);

	// Hand this off
	hint "Config Copied to Clipboard";
	copyToClipboard _structuredString;
};

hint "No config to export";