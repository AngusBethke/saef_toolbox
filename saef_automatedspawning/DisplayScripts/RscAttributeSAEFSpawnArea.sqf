/*
	RscAttributeSAEFSpawnArea.sqf

	Description:
		Handles attribute functionality for the spawn area Zeus UI
*/

params
[
	"_mode",
	"_params",
	"_logic"
];

private
[
	 "_Cmb_Tag"
	,"_Cmb_AreaSize"
	,"_CkB_BlockPatrol"
	,"_CkB_BlockGarrison"
	,"_Edt_CustomTag"
	,"_Edt_CustomSide"
	,"_Edt_CustomUnits"
	,"_Edt_CustomLightVehicles"
	,"_Edt_CustomHeavyVehicles"
	,"_Edt_CustomParadropVehicles"
];

_Cmb_Tag = 2100;
_Cmb_AreaSize = 2101;
_CkB_BlockPatrol = 2800;
_CkB_BlockGarrison = 2801;
_Edt_CustomTag = 1400;
_Edt_CustomSide = 1401;
_Edt_CustomUnits = 1402;
_Edt_CustomLightVehicles = 1403;
_Edt_CustomHeavyVehicles = 1404;
_Edt_CustomParadropVehicles = 1405;

switch _mode do {
	case "onLoad": {
		_params params
		[
			"_display"
		];

		private
		[
			"_control"
			,"_areaTags"
			,"_index"
			,"_areaSizes"
		];

		// Set up the area tag list box
		_control = _display displayCtrl _Cmb_Tag;
		_areaTags = missionNamespace getVariable ["SAEF_AreaMarkerTags", []];

		// Add all the items returned by the area tags
		{
			_x params
			[
				"_tag"
				,"_name"
				,"_config"
				,["_overrides", []]
			];

			_index = _control lbAdd _name;
			_control lbSetData [_index, _tag];
		} forEach _areaTags;

		_control lbSetCurSel 0;

		// Set up the area size list box
		_areaSizes =
		[
			 ["Small", "SML"]
			,["Medium", "MED"]
			,["Large", "LRG"]
		];

		_control = _display displayCtrl _Cmb_AreaSize;

		{
			_x params
			[
				"_prettyName"
				,"_data"
			];

			_index = _control lbAdd _prettyName;
			_control lbSetData [_index, _data];
		} forEach _areaSizes;

		_control lbSetCurSel 1;

		// Temporary (create local helipad for viewer to visualise area size)
		private
		[
			"_hPad"
			,"_bbr"
			,"_maxWidth"
			,"_areaSize"
		];

		
		_hPad = "Land_JumpTarget_F" createVehicleLocal (getPos _logic);
		_hPad setPos (getPos _logic);
		_bbr = boundingBoxReal _hPad;
		_bbr params ["_p1", "_p2"];
		_maxWidth = abs ((_p2 select 0) - (_p1 select 0));

		_areaSize = 50;
		switch toUpper(_control lbData (lbCurSel _control)) do
		{
			case "SML": 
			{
				(missionNamespace getVariable ["SAEF_AreaSpawner_Small_Params", []]) params
				[
					["_tBaseAICount", 12],
					["_tBaseAreaSize", 60],
					["_tBaseActivationRange", 500]
				];

				_areaSize = _tBaseAreaSize;
			};
			case "MED": 
			{
				(missionNamespace getVariable ["SAEF_AreaSpawner_Small_Params", []]) params
				[
					["_tBaseAICount", 12],
					["_tBaseAreaSize", 60],
					["_tBaseActivationRange", 500]
				];
				
				_areaSize = _tBaseAreaSize;
			};
			case "LRG":
			{
				(missionNamespace getVariable ["SAEF_AreaSpawner_Small_Params", []]) params
				[
					["_tBaseAICount", 12],
					["_tBaseAreaSize", 60],
					["_tBaseActivationRange", 500]
				];
				
				_areaSize = _tBaseAreaSize;
			};
			default {};
		};

		_hPad setObjectScale ((_areaSize / _maxWidth) * 2);
		_logic setVariable ["LocalPad", _hPad, true];

	};
	case "confirmed": {
		_params params
		[
			"_display"
		];

		private
		[
			"_control"
			,"_index"
			,"_data"
			,"_tag"
			,"_size"
			,"_blockPatrol"
			,"_blockGarrison"
			,"_spawnSide"
			,"_spawnUnits"
			,"_spawnLightVehicles"
			,"_spawnHeavyVehicles"
			,"_spawnParaVehicles"
		];

		// Get current selected area tag
		_control = _display displayCtrl _Cmb_Tag;
		_index = lbCurSel _control;
		_data = _control lbData _index;

		_tag = _data;
		
		// Check if we have a custom override tag
		_control = _display displayCtrl _Edt_CustomTag;
		_data = ctrlText _control;
		if (_data != "") then
		{
			_tag = _data;
		};

		// Get current selected area size
		_control = _display displayCtrl _Cmb_AreaSize;
		_index = lbCurSel _control;
		_data = _control lbData _index;

		_size = _data;

		// Check if the Block Patrol Checkbox is checked
		_control = _display displayCtrl _CkB_BlockPatrol;
		_blockPatrol = cbChecked _control;

		// Check if the Block Garrison Checkbox is checked
		_control = _display displayCtrl _CkB_BlockGarrison;
		_blockGarrison = cbChecked _control;
		
		// Check if we have a custom side tag
		_control = _display displayCtrl _Edt_CustomSide;
		_spawnSide = ctrlText _control;
		
		// Check if we have a custom side tag
		_control = _display displayCtrl _Edt_CustomUnits;
		_spawnUnits = ctrlText _control;
		
		// Check if we have a custom side tag
		_control = _display displayCtrl _Edt_CustomLightVehicles;
		_spawnLightVehicles = ctrlText _control;
		
		// Check if we have a custom side tag
		_control = _display displayCtrl _Edt_CustomHeavyVehicles;
		_spawnHeavyVehicles = ctrlText _control;
		
		// Check if we have a custom side tag
		_control = _display displayCtrl _Edt_CustomParadropVehicles;
		_spawnParaVehicles = ctrlText _control;
		
		// Set all the variables
		_logic setVariable ["Tag", _tag, true]; 
		_logic setVariable ["Size", _size, true]; 
		_logic setVariable ["BlockPatrol", _blockPatrol, true]; 
		_logic setVariable ["BlockGarrison", _blockGarrison, true]; 
		_logic setVariable ["SpawnSide", _spawnSide, true]; 
		_logic setVariable ["SpawnUnits", _spawnUnits, true]; 
		_logic setVariable ["SpawnLightVehicles", _spawnLightVehicles, true]; 
		_logic setVariable ["SpawnHeavyVehicles", _spawnHeavyVehicles, true]; 
		_logic setVariable ["SpawnParaVehicles", _spawnParaVehicles, true]; 
		_logic setVariable ["Active", true, true];
	};
	case "onUnload": {
		private
		[
			"_hPad"
		];

		_hPad = _logic getVariable ["LocalPad", objNull];

		if (_hPad != objNull) then
		{
			deleteVehicle _hPad;
		};

		// Kick off the module
		["SAEF_AS_ModuleQueue", [_logic, [], true, true], "SAEF_AS_fnc_ModuleSpawnArea"] call RS_MQ_fnc_MessageEnqueue;
	};
};