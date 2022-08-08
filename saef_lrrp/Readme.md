# SAEF LRRP Toolset
This provides functionality for the SAEF Long Range Recon Patrol toolset

### Example Configuration
This should be executed from your initMissionSetup.sqf or similar
```
/*
	------------------------------------
	-- SAEF LRRP | Setup the Loadouts --
	------------------------------------
*/

private
[
	"_helmetConfig",
	"_kitbagConfig",
	"_assaultBagConfig",
	"_vestConfig",
	"_lrRadioConfig",
	"_mg3AmmoConfig",
	"_mg3AmmoConfigX3",
	"_heatMissileConfig",
	"_hedpMissileConfig",
	"_heatMissileConfigX2",
	"_hedpMissileConfigX2",
	"_m72LawConfig",
	"_grenadeConfig",
	"_rifleGlConfig",
	"_rifleConfig",
	"_autoRifleConfig",
	"_mgConfig",
	"_lrRifleConfig"
];

_helmetConfig = ["GENERATE_CONFIG", ["Helmet", [[["H_HelmetB_camo", "H_HelmetB_camo", "SA_Helmet_KhakiG_U", "SA_HelmetSpec_KhakiG_U", "H_HelmetB_camo"], 1, "Item"]]]] call SAEF_LRRP_fnc_Gear;
_kitbagConfig = ["GENERATE_CONFIG", ["Kitbag", [[["SA_Backpack_Fast_KhakiGreen_U", "SA_Backpack_Fast_FleckS_U"], 1, "Backpack"]]]] call SAEF_LRRP_fnc_Gear;
_assaultBagConfig = ["GENERATE_CONFIG", ["Assault Bag", [[["SA_Backpack_KhakiGreen_U", "SA_Backpack_FleckS_U"], 1, "Backpack"]]]] call SAEF_LRRP_fnc_Gear;
_vestConfig = ["GENERATE_CONFIG", ["Armor", [[["SA_PlateCarrier_KhkU1", "SA_PlateCarrier_FleckU1", "SA_PlateCarrier_KhkU2", "SA_PlateCarrier_FleckU2"], 1, "Item"]]]] call SAEF_LRRP_fnc_Gear;
_lrRadioConfig = ["GENERATE_CONFIG", ["Long Range Radio", [["TFAR_mr3000_bwmod", 1, "Backpack"]]]] call SAEF_LRRP_fnc_Gear;
_mg3AmmoConfig = ["GENERATE_CONFIG", ["300rnd MG3 Ammo", [["UK3CB_MG3_100rnd_762x51_R", 3, "Magazine"]]]] call SAEF_LRRP_fnc_Gear;
_mg3AmmoConfigX3 = ["GENERATE_CONFIG_MULTI", ["300rnd MG3 Ammo", 3, [["UK3CB_MG3_100rnd_762x51_R", 3, "Magazine"]]]] call SAEF_LRRP_fnc_Gear;
_heatMissileConfig = ["GENERATE_CONFIG", ["MAAWS HEAT Missile", [["rhs_mag_maaws_HEAT", 1, "Magazine"]]]] call SAEF_LRRP_fnc_Gear;
_hedpMissileConfig = ["GENERATE_CONFIG", ["MAAWS HEDP Missile", [["rhs_mag_maaws_HEDP", 1, "Magazine"]]]] call SAEF_LRRP_fnc_Gear;
_heatMissileConfigX2 = ["GENERATE_CONFIG", ["2x MAAWS HEAT Missile", [["rhs_mag_maaws_HEAT", 2, "Magazine"]]]] call SAEF_LRRP_fnc_Gear;
_hedpMissileConfigX2 = ["GENERATE_CONFIG", ["2x MAAWS HEDP Missile", [["rhs_mag_maaws_HEDP", 2, "Magazine"]]]] call SAEF_LRRP_fnc_Gear;
_m72LawConfig = ["GENERATE_CONFIG", ["M72 LAW", [["rhs_weap_m72a7", 1, "Weapon"], ["rhs_m72a7_mag", 1, "Magazine"]]]] call SAEF_LRRP_fnc_Gear;
_grenadeConfig = ["GENERATE_CONFIG", ["Grenades", [["ACE_M84", 8, "Item"], ["rhs_charge_tnt_x2_mag", 2, "Item"], ["HandGrenade", 4, "Item"], ["SmokeShell", 4, "Item"]]]] call SAEF_LRRP_fnc_Gear;
_rifleGlConfig = ["GENERATE_CONFIG", ["Rifle", [["rhs_weap_g36kv_ag36", 1, "Weapon"]]]] call SAEF_LRRP_fnc_Gear;
_rifleConfig = ["GENERATE_CONFIG", ["Rifle", [["rhs_weap_g36c", 1, "Weapon"]]]] call SAEF_LRRP_fnc_Gear;
_autoRifleConfig = ["GENERATE_CONFIG", ["Rifle", [["rhs_weap_g36kv", 1, "Weapon"]]]] call SAEF_LRRP_fnc_Gear;
_mgConfig = ["GENERATE_CONFIG", ["Machine Gun", [["UK3CB_MG3_KWS_B", 1, "Weapon"]]]] call SAEF_LRRP_fnc_Gear;
_lrRifleConfig = ["GENERATE_CONFIG", ["Rifle", [["UK3CB_G3KA4", 1, "Weapon"]]]] call SAEF_LRRP_fnc_Gear;

private
[
	"_loadouts"
];

_loadouts = 
[
	(["GENERATE_LOADOUT_CONFIG", ["Squad Leader", "Loadouts\Factions\GermanRecon\SquadLeader.sqf", [_rifleGlConfig, _helmetConfig, _vestConfig, _lrRadioConfig, _mg3AmmoConfig, _m72LawConfig, _grenadeConfig]]] call SAEF_LRRP_fnc_Gear),
	(["GENERATE_LOADOUT_CONFIG", ["Rifleman", "Loadouts\Factions\GermanRecon\Rifleman.sqf", [_rifleConfig, _helmetConfig, _vestConfig, _assaultBagConfig, _mg3AmmoConfig, _m72LawConfig, _grenadeConfig]]] call SAEF_LRRP_fnc_Gear),
	(["GENERATE_LOADOUT_CONFIG", ["Medic", "Loadouts\Factions\GermanRecon\Medic.sqf", [_rifleConfig, _helmetConfig, _vestConfig, _kitbagConfig]]] call SAEF_LRRP_fnc_Gear),
	(["GENERATE_LOADOUT_CONFIG", ["Machine Gunner Assitant", "Loadouts\Factions\GermanRecon\MachinegunnerAsst.sqf", ([_rifleConfig, _helmetConfig, _vestConfig, _kitbagConfig] + _mg3AmmoConfigX3)]] call SAEF_LRRP_fnc_Gear),
	(["GENERATE_LOADOUT_CONFIG", ["Machine Gunner", "Loadouts\Factions\GermanRecon\Machinegunner.sqf", [_mgConfig, _helmetConfig, _vestConfig, _assaultBagConfig]]] call SAEF_LRRP_fnc_Gear),
	(["GENERATE_LOADOUT_CONFIG", ["Grenadier", "Loadouts\Factions\GermanRecon\Grenadier.sqf", [_rifleGlConfig, _helmetConfig, _vestConfig, _assaultBagConfig, _m72LawConfig, _grenadeConfig]]] call SAEF_LRRP_fnc_Gear),
	(["GENERATE_LOADOUT_CONFIG", ["Autorifleman", "Loadouts\Factions\GermanRecon\Autorifleman.sqf", [_autoRifleConfig, _helmetConfig, _vestConfig, _kitbagConfig, _grenadeConfig]]] call SAEF_LRRP_fnc_Gear),
	(["GENERATE_LOADOUT_CONFIG", ["Anti-Tank Assitant", "Loadouts\Factions\GermanRecon\Rifleman.sqf", [_rifleConfig, _helmetConfig, _vestConfig, _kitbagConfig, _heatMissileConfigX2, _hedpMissileConfigX2]]] call SAEF_LRRP_fnc_Gear),
	(["GENERATE_LOADOUT_CONFIG", ["Anti-Tank", "Loadouts\Factions\GermanRecon\AntiTank.sqf", [_rifleConfig, _helmetConfig, _vestConfig, _assaultBagConfig, _heatMissileConfig, _hedpMissileConfig]]] call SAEF_LRRP_fnc_Gear)
];

missionNamespace setVariable ["SAEF_LRRP_Loadouts", _loadouts, true];

/*
	---------------------------------------
	-- SAEF LRRP | Setup the Attachments --
	---------------------------------------
*/
private
[
	"_attachments"
];

_attachments =
[
	[
		"Loadouts\Helpers\AddAttachment.sqf", "SR Attachments", [
			["rhsusf_acc_T1_high", "SU-278/PVS"], 
			["rhsusf_acc_eotech_xps3", "Eotech XPS3"], 
			["rhsusf_acc_eotech_552", "Eotech M552 CCO"], 
			["rhsusf_acc_compm4", "M68 CCO"]
		]
	],
	[
		"Loadouts\Helpers\AddAttachment.sqf", "MR Attachments", [
			["rhsusf_acc_g33_T1", "G33 + XPS3"], 
			["rhsusf_acc_g33_xps3", "G33 + SU-278/PVS"], 
			["rhsusf_acc_su230_mrds", "SU230 (MRDS)"], 
			["rhsusf_acc_ACOG_RMR", "ACOG (RMR)"], 
			["hlc_optic_ATACR", "ATACR F1"]
		]
	]
];

missionNamespace setVariable ["SAEF_LRRP_Attachments", _attachments, true];

/*
	---------------------------------------------
	-- SAEF LRRP | Setup the allowed backpacks --
	---------------------------------------------
*/

private
[
	"_backpacks"
];

_backpacks = ["SAEF_Bergen_KHK_U", "SAEF_Bergen_SFW_U", "B_Carryall_oli"];

missionNamespace setVariable ["SAEF_LRRP_AllowedBackpacks", _backpacks, true];
```

### Example Initialisation
This should be executed in both player and server locality, i.e. from initPlayerLocal.sqf and initServer.sqf
```
/*
	-----------------------------------------
	-- SAEF LRRP | Initialise the function --
	-----------------------------------------

	Scope: InitServer.sqf & InitPlayerLocal.sqf

	Note: This must be done after variables are configured!
*/

[] call SAEF_LRRP_fnc_Init;
```