class CfgPatches
{
	class SAEF_TOOLBOX_CIVILIANPRESENCE
	{
		version=2;
		units[]={"RS_CP_ModuleCivilianPresence"};
		weapons[]={};
		author="Rabid Squirrel";
		requiredVersion=0.1;
		requiredAddons[]=
		{
			"A3_Data_F",
			"SAEF_TOOLBOX_LOCATIONS",
			"SAEF_TOOLBOX_HEADLESS",
			"SAEF_TOOLBOX_DIAGNOSTICS",
			"A3_Modules_F"
		};
	};
};

class CfgFunctions
{
	class RS_CP
	{
		class CivilianPresence
		{
			file = "saef_civilianpresence\Functions";
			class AddCustomLocations {};
			class CheckAgainstTotalRunningAi {};
			class CoreCreateUnit {};
			class CoreDeactivation {};
			class CoreDeleteUnit {};
			class CoreGetObjects {};
			class CoreHandleUnits {};
			class CoreInit {};
			class GetCompatibleFacesFromConfig {};
			class GetWhiteListedLocations {};
			class Handler {};
			class Init {};
			class ModuleCivilianPresence {};
			class SpawnPositionModule {};
			class SpawnPresenceModule {};
			class SpawnSafePointModule {};
			class UnitInit {};
			class UnitTypeHandler {};
		};
	};
};

class CfgVehicles
{
	class ModuleCivilianPresence_F;
	class RS_CP_ModuleCivilianPresence: ModuleCivilianPresence_F
	{
		// Standard object definitions
		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "RS Civilian Presence"; // Name displayed in the menu

		// Name of function triggered once conditions are met
		function = "RS_CP_fnc_ModuleCivilianPresence";
	};
};

class Extended_PreInit_EventHandlers {
    class SAEF_CivilianPresence_PreInitEvent {
        init = "call compile preprocessFileLineNumbers 'saef_civilianpresence\Functions\XEH_preInit.sqf'";
    };
};