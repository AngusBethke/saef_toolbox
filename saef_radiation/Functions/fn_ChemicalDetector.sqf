/*
	fn_ChemicalDetector.sqf
	Description: Handles hiding and showing of the chemical detector
	[] call RS_Radiation_fnc_ChemicalDetector;
*/

private
[
	 "_maskLayer"
	,"_action"
];

_action = ["toggle_chem_detector","Chemical Detector","saef_radiation\Images\rad_icon.paa",
	{
		if (!(player getVariable ["RS_ChemicalDetector_Running", false])) then
		{
			player setVariable ["RS_ChemicalDetector_Running", true, true];
			
			// Display screen overlay
			("RS_ChemicalDetector" call BIS_fnc_rscLayer) cutRsc ["RscWeaponChemicalDetector", "PLAIN", 1, false];
		}
		else
		{
			player setVariable ["RS_ChemicalDetector_Running", false, true];
		
			// Remove screen overlay
			("RS_ChemicalDetector" call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
		};
	}, 
	{!visibleMap}
] call ace_interact_menu_fnc_createAction;
 
// Add the action to the Player
[player, 1, ["ACE_SelfActions"], _action, true] call ace_interact_menu_fnc_addActionToObject;