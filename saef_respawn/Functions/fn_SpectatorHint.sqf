/*
	Spectator_Hint.sqf
	Description: Handles Hint Display for whether respawn is enabled or disabled.
	Passed Variables: type <string>
*/

private 
[
	"_type",
	"_text",
	"_image"
];

_type = _this select 0;

if ((missionNamespace getVariable ["RespawnHandlerHint", false]) && (player getVariable ["RespawnHandlerHint", false])) then
{
	switch (_type) do
	{
		case "Disabled" : {
			_text = "Please be Advised: Respawn is Now Disabled";
			_image = "<br/><img image='saef_respawn\Images\gas_red.paa' align='center' size='5'/>";
			
			hint parseText (_text + _image);
		};
		case "Enabled" : {
			_text = "Please be Advised: Respawn is Now Enabled";
			_image = "<br/><img image='saef_respawn\Images\gas_white.paa' align='center' size='5'/>";
			
			hint parseText (_text + _image);
		};
		default {
			["RS Respawn", 2, (format ["Hint type %1 not recognised", _type])] call RS_fnc_LoggingHelper;
		};
	};
};