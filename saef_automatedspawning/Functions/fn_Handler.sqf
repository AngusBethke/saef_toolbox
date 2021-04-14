/*
	fn_Handler.sqf
	
	Description: 
		Handles the distribution of each area spawner on mission load.

	How to Call:
		[] call SAEF_AS_fnc_Handler;
*/

private
[
	"_scriptTag"
	,"_allMapMarkers"
	,"_areaTags"
	,"_areaMarkers"
];

_scriptTag = "SAEF_AS_fnc_Handler";
[_scriptTag, 3, "<IN>"] call RS_fnc_LoggingHelper;

// Variable Declerations
_allMapMarkers = allMapMarkers;
_areaTags = (missionNamespace getVariable ["SAEF_AreaMarkerTags", []]);
_areaMarkers = [];

if (_areaTags isEqualTo []) exitWith
{
	[_scriptTag, 1, "Cannot find any area tags under the variable [SAEF_AreaMarkerTags]"] call RS_fnc_LoggingHelper;
};

// Cultivate our markers to use for the areas
{
	/*	
		// Parameter structure
		_x:
		[
			"ei_area"							// The tag for the area
			,"CSAT"								// Descriptive name for the tag
			,"ei_area_config"					// The config point for this tag
			,[									// The overrides array
				[
					"ei_area_sml_3"					// Marker that is being overwritten
					,"ei_area_sml_3_config"			// The config pointer for this marker override
				]
			]
		]
	*/

	_x params
	[
		"_tag"
		,"_name"
		,"_config"
		,["_overrides", []]
	];

	{
		_x params ["_marker"];
		
		if ([toUpper(_tag), toUpper(_marker)] call BIS_fnc_InString) then
		{
			private
			[
				"_specificOverride"
			];

			_specificOverride = "";
			{
				_x params
				[
					"_ovrMarker"
					,"_override"
				];
				
				if (toUpper(_ovrMarker) == toUpper(_marker)) then
				{
					_specificOverride = _override;
				};
			} forEach _overrides;

			_areaMarkers pushback [_tag, _config, _marker, _specificOverride];
		};
	} forEach _allMapMarkers;
} forEach _areaTags;

// Execute our area spawners for each area
{
	_x params
	[
		"_tag"
		,"_config"
		,"_marker"
		,"_override"
	];

	private
	[
		"_initVariable"
	];

	_initVariable = (format["Area_%1_Initialised", _marker]);

	// Only run if we haven't initialised this zone already
	if (!(missionNamespace getVariable [_initVariable, false])) then
	{
		private
		[
			"_params"
		];

		_params = [];
		if (_override == "") then
		{
			_params = missionNamespace getVariable [_config, []];
		}
		else
		{
			_params = missionNamespace getVariable [_override, []];
		};

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

		// If we don't have params we should jump ship
		if (!(_params isEqualTo [])) then
		{
			private
			[
				"_activeVariable"
			];

			// Add our variable to the parameters
			_activeVariable = (format["Area_%1_Active", _marker]);
			_params = [_marker, _initVariable, _activeVariable] + _params;

			// Call our area function
			_params call SAEF_AS_fnc_Area;
		}
		else
		{
			[_scriptTag, 3, (format ["No parameters found for variable [%1] or [%2]", _config, _override])] call RS_fnc_LoggingHelper;
		};
	}
	else
	{
		[_scriptTag, 3, (format ["Area already initialised for [%1]", _marker])] call RS_fnc_LoggingHelper;
	};

} forEach _areaMarkers;

[_scriptTag, 3, "<OUT>"] call RS_fnc_LoggingHelper;

/*
	END
*/