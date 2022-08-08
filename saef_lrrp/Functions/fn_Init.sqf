/*
	fn_Init.sqf

	Description:
		Handles initialisation for LRRP mechanics
*/

// Should only initialise once
if (hasInterface && (player getVariable ["SAEF_LRRP_HasInitialised", false])) exitWith {};

// Players will initialise the tent functionality
if (hasInterface) then
{
	player setVariable ["SAEF_LRRP_HasInitialised", true, true];
	["Init"] call SAEF_LRRP_fnc_Tent;
	["Init"] call SAEF_LRRP_fnc_CommandTent;
	["INIT"] call SAEF_LRRP_fnc_Gear;
};

// Headless clients and players should be booted
if (!isServer) exitWith {};

// Loadouts
missionNamespace setVariable ["SAEF_LRRP_Loadouts", (missionNamespace getVariable ["SAEF_LRRP_Loadouts", []]), true];
missionNamespace setVariable ["SAEF_LRRP_LoadoutManager", (missionNamespace getVariable ["SAEF_LRRP_LoadoutManager", "Loadouts\Core.sqf"]), true];
missionNamespace setVariable ["SAEF_LRRP_Attachments", (missionNamespace getVariable ["SAEF_LRRP_Attachments", []]), true];

// Allowed Backpacks
missionNamespace setVariable ["SAEF_LRRP_AllowedBackpacks", (missionNamespace getVariable ["SAEF_LRRP_AllowedBackpacks", []]), true];

// Tents
missionNamespace setVariable ["SAEF_LRRP_Tent", (missionNamespace getVariable ["SAEF_LRRP_Tent", ["Land_TentSolar_01_olive_F", "Land_TentSolar_01_folded_olive_F"]]), true];

private
[
	"_commandTentExtras"
];

_commandTentExtras =
[
	["Land_SolarPanel_04_olive_F",360,[0.222427,-1.37158,0]],
	["Land_PortableCabinet_01_closed_olive_F",270,[1.51596,-0.626465,-0.45]],
	["Land_DeskChair_01_olive_F",360,[1.49959,0.333984,-0.4]],
	["Land_DeskChair_01_olive_F",360,[1.49919,0.883545,-0.4]],
	["Land_MultiScreenComputer_01_olive_F",180,[-0.283722,1.60767,-0.35]],
	["Land_PortableCabinet_01_closed_olive_F",0,[0.692703,1.62817,-0.45]]
];

missionNamespace setVariable ["SAEF_LRRP_CommandTent", (missionNamespace getVariable ["SAEF_LRRP_CommandTent", ["Land_TentDome_F", "Land_TentSolar_01_folded_olive_F", _commandTentExtras]]), true];

// Markers
missionNamespace setVariable ["SAEF_LRRP_CommandTent_Marker", (missionNamespace getVariable ["SAEF_LRRP_CommandTent_Marker", "respawn"]), true];

// Execute the load
["INIT"] call SAEF_LRRP_fnc_Persistence;