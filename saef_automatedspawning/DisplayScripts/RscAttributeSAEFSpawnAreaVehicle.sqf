/*
	RscAttributeSAEFSpawnAreaVehicle.sqf

	Description:
		Handles attribute functionality for the spawn area vehicle Zeus UI
*/

params
[
	"_mode",
	"_params",
	"_logic"
];

private
[
	 "_CkB_LightVehicle"
	,"_CkB_HeavyVehicle"
];

_CkB_LightVehicle = 2820;
_CkB_HeavyVehicle = 2821;

switch _mode do {
	case "onLoad": {
		_params params
		[
			"_display"
		];

		// Set up the area tag list box
		_control = _display displayCtrl _CkB_LightVehicle;
		_control cbSetChecked true;
		_logic setVariable ["LightVehicle", true, true]; 
	};
	case "confirmed": {
		_params params
		[
			"_display"
		];

		// Check if the Light Vehicle Checkbox is checked
		_control = _display displayCtrl _CkB_LightVehicle;
		_lightVehicle = cbChecked _control;

		// Check if the Heavy Vehicle Checkbox is checked
		_control = _display displayCtrl _CkB_HeavyVehicle;
		_heavyVehicle = cbChecked _control;
		
		// Set all the variables
		_logic setVariable ["LightVehicle", _lightVehicle, true]; 
		_logic setVariable ["HeavyVehicle", _heavyVehicle, true]; 
	};
	case "onUnload": {
		// We aren't doing anything
	};
};