/*
	fn_HeightBasedViewDistance.sqf

	Description: 
		Monitors player height above Terrain and modifies their view distance accordingly, 
		the higher you are, the higher your view distance. This is to help mitigate FPS impact when 
		descending into a town, as an airborne vehicle.

	How to call: 
		[
			_fixedCeiling		// (Optional) The height at which the view distance max will be reached
		] spawn SAEF_VD_fnc_HeightBasedViewDistance;
*/

params
[
	["_fixedCeiling", 150]
];

player setVariable ["SAEF_HeightBasedViewDistance_Run", true, true];

private
[
	"_scriptTag"
];
_scriptTag = "SAEF_VD_fnc_HeightBasedViewDistance";

[_scriptTag, 0, (format ["Initialising for [%1], to disable this set variable [SAEF_HeightBasedViewDistance_Run] to false", player])] call RS_fnc_LoggingHelper;

addMissionEventHandler ["EachFrame", {
	if (player getVariable ["SAEF_HeightBasedViewDistance_Run", false]) then
	{
		private
		[
			"_unit",
			"_uav",
			"_height"
		];

		// UAV Fix
		_unit = player;
		_uav = getConnectedUAV player;

		if (_uav != objNull) then
		{
			private
			[
				"_controlArray"
			];

			_controlArray = UAVControl _uav;
			_controlArray params
			[
				["_conPlayer_1", objNull],
				["_conPlayer_1_Seat", ""],
				["_conPlayer_2", objNull],
				["_conPlayer_2_Seat", ""]
			];

			// We need to make sure that the player is currently actively controlling the UAV, otherwise it's gonna increase view distance unnecessarily
			if (((_conPlayer_1 == player) && (_conPlayer_1_Seat != "")) || ((_conPlayer_2 == player) && (_conPlayer_2_Seat != ""))) then
			{
				_unit = _uav;
			};
		};

		_height = (getPosATL _unit) select 2;
		
		if (_height != (player getVariable ["SAEF_HeightBasedViewDistance_ControlHeight", 0])) then
		{
			private
			[
				"_srvViewDistance",
				"_minViewDistance",
				"_viewDistance"
			];

			// Get some variables
			_srvViewDistance = (missionNamespace getVariable ["Aircraft_ObjectViewDistance", [5000, 50]]);
			_srvViewDistance params ["_maxViewDistance", "_shdViewDistance"];
			_minViewDistance = (missionNamespace getVariable ["Infantry_ViewDistance", 1200]);
		
			// Default Declarations
			player setVariable ["SAEF_HeightBasedViewDistance_ControlHeight", _height, true];
			_viewDistance = _minViewDistance;
			
			if (_height > 5) then
			{
				if (_height > _fixedCeiling) then
				{
					_viewDistance = _maxViewDistance;
				}
				else
				{
					_viewDistance = _minViewDistance + ((_maxViewDistance - _minViewDistance) * (_height / _fixedCeiling));
				};
			};
			
			if (_viewDistance < _minViewDistance) then
			{
				_viewDistance = _minViewDistance;
			};
			
			if (_viewDistance > _maxViewDistance) then
			{
				_viewDistance = _maxViewDistance;
			};

			// We only want to adjust this if something needs to change
			if (viewDistance != _viewDistance) then
			{
				setViewDistance _viewDistance;
				setObjectViewDistance [_viewDistance, _shdViewDistance];
			};
		};
	};
}];