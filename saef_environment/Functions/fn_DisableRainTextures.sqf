/*
	Moved to saef_toolbox from the SAEF Mission Framework (Scripts\Utility\TurnOffRainTextures.sqf).
*/

/*
	TurnOffRainTextures.sqf

	Description:
		Turn off all the rain textures

	How to call:
		[] spawn SAEF_ENV_fnc_DisableRainTextures;
*/

// Delay until the handler is finished declaring variables
waitUntil {
	sleep 1;
	(missionNamespace getVariable ["RS_RainTexture_Started", false])
};

// Toggle all variables to false
missionNamespace setVariable ["RS_Rain_Texture_RunSitCheckFunction", false, true];
missionNamespace setVariable ["RS_RainTexture_allUnits", false, true];
missionNamespace setVariable ["RS_RainTexture_playableUnits", false, true];
missionNamespace setVariable ["RS_RainTexture_RunExpMaterialSwitch", false, true];
missionNamespace setVariable ["RS_RainTexture_RunLandVehicleHandler", false, true];
missionNamespace setVariable ["RS_RainTexture_RunAirVehicleHandler", false, true];
missionNamespace setVariable ["RS_RainTexture_RunShipVehicleHandler", false, true];
missionNamespace setVariable ["RS_RainTexture_RunBuildingHandler", false, true];
missionNamespace setVariable ["RS_RainTexture_RunThingHandler", false, true];
missionNamespace setVariable ["RS_RainTexture_Started", false, true];