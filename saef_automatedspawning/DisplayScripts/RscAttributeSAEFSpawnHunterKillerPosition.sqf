/*
	RscAttributeSAEFSpawnHunterKillerPosition.sqf

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
];

_Cmb_Tag = 2110;

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
		];

		// Get current selected area tag
		_control = _display displayCtrl _Cmb_Tag;
		_index = lbCurSel _control;
		_data = _control lbData _index;

		_tag = _data;
		
		// Set all the variables
		_logic setVariable ["Tag", _tag, true]; 
		_logic setVariable ["Active", true, true];
	};
	case "onUnload": {
		// Kick off the module
		["SAEF_AS_ModuleQueue", [_logic, [], true, true], "SAEF_AS_fnc_ModuleSpawnHunterKillerPosition"] call RS_MQ_fnc_MessageEnqueue;
	};
};