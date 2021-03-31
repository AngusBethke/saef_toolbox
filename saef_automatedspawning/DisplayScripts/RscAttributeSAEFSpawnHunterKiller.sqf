/*
	RscAttributeSAEFSpawnHunterKiller.sqf

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
	,"_Cmb_SquadSize"
	,"_Cmb_SearchArea"
	,"_Cmb_RespawnTime"
	,"_CkB_LightVehicle"
	,"_CkB_HeavyVehicle"
	,"_CkB_Persistence"
	,"_CkB_ParadropVehicle"
	,"_CkB_DynamicPosition"
	,"_Edt_CustomTag"
];

_Cmb_Tag = 2110;
_Cmb_SquadSize = 2111;
_Cmb_SearchArea = 2112;
_Cmb_RespawnTime = 2113;
_CkB_LightVehicle = 2810;
_CkB_HeavyVehicle = 2811;
_CkB_Persistence = 2812;
_CkB_ParadropVehicle = 2813;
_CkB_DynamicPosition = 2814;
_Edt_CustomTag = 1410;

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
			,"_comboSetup"
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

		// Set up the squad size list box
		_comboSetup =
		[
			 ["2", "2"]
			,["4", "4"]
			,["6", "6"]
			,["8", "8"]
			,["10", "10"]
			,["12", "12"]
		];

		_control = _display displayCtrl _Cmb_SquadSize;

		{
			_x params
			[
				"_prettyName"
				,"_data"
			];

			_index = _control lbAdd _prettyName;
			_control lbSetData [_index, _data];
		} forEach _comboSetup;

		_control lbSetCurSel 1;

		// Set up the search area list box
		_comboSetup =
		[
			 ["500m", "500"]
			,["1km", "1000"]
			,["2km", "2000"]
			,["4km", "4000"]
		];

		_control = _display displayCtrl _Cmb_SearchArea;

		{
			_x params
			[
				"_prettyName"
				,"_data"
			];

			_index = _control lbAdd _prettyName;
			_control lbSetData [_index, _data];
		} forEach _comboSetup;

		_control lbSetCurSel 3;

		// Set up the respawn list box
		_comboSetup =
		[
			 ["1 Minute", "60"]
			,["2 Minutes", "120"]
			,["4 Minutes", "240"]
		];

		_control = _display displayCtrl _Cmb_RespawnTime;

		{
			_x params
			[
				"_prettyName"
				,"_data"
			];

			_index = _control lbAdd _prettyName;
			_control lbSetData [_index, _data];
		} forEach _comboSetup;

		_control lbSetCurSel 1;
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
			,"_squadSize"
			,"_searchArea"
			,"_lightVehicle"
			,"_heavyVehicle"
			,"_persistence"
			,"_respawnTime"
			,"_paraVehicle"
			,"_dynamicPosition"
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

		// Get current selected squad size
		_control = _display displayCtrl _Cmb_SquadSize;
		_index = lbCurSel _control;
		_data = _control lbData _index;

		_squadSize = (call compile _data);

		// Get current selected search area
		_control = _display displayCtrl _Cmb_SearchArea;
		_index = lbCurSel _control;
		_data = _control lbData _index;

		_searchArea = (call compile _data);

		// Get current selected search area
		_control = _display displayCtrl _Cmb_RespawnTime;
		_index = lbCurSel _control;
		_data = _control lbData _index;

		_respawnTime = (call compile _data);

		// Check if the Block Patrol Checkbox is checked
		_control = _display displayCtrl _CkB_LightVehicle;
		_lightVehicle = cbChecked _control;

		// Check if the Block Patrol Checkbox is checked
		_control = _display displayCtrl _CkB_HeavyVehicle;
		_heavyVehicle = cbChecked _control;

		// Check if the Block Patrol Checkbox is checked
		_control = _display displayCtrl _CkB_Persistence;
		_persistence = cbChecked _control;

		// Check if the Block Patrol Checkbox is checked
		_control = _display displayCtrl _CkB_ParadropVehicle;
		_paraVehicle = cbChecked _control;

		// Check if the Block Patrol Checkbox is checked
		_control = _display displayCtrl _CkB_DynamicPosition;
		_dynamicPosition = cbChecked _control;
		
		// Set all the variables
		_logic setVariable ["Tag", _tag, true]; 
		_logic setVariable ["SquadSize", _squadSize, true]; 
		_logic setVariable ["SearchArea", _searchArea, true]; 
		_logic setVariable ["LightVehicle", _lightVehicle, true]; 
		_logic setVariable ["HeavyVehicle", _heavyVehicle, true]; 
		_logic setVariable ["Persistence", _persistence, true]; 
		_logic setVariable ["RespawnTime", _respawnTime, true]; 
		_logic setVariable ["ParaVehicle", _paraVehicle, true]; 
		_logic setVariable ["DynamicPosition", _dynamicPosition, true]; 
		_logic setVariable ["Active", true, true];
	};
	case "onUnload": {
		// Kick off the module
		["SAEF_AS_ModuleQueue", [_logic, [], true, true], "SAEF_AS_fnc_ModuleSpawnHunterKiller"] call RS_MQ_fnc_MessageEnqueue;
	};
};