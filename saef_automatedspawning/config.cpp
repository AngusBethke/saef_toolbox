class CfgPatches
{
	class SAEF_TOOLBOX_AUTOMATEDSPAWNING
	{
		version=2;
		units[]=
		{
			"SAEF_ModuleSpawnArea"
			,"SAEF_ModuleSpawnHunterKiller"
			,"SAEF_ModuleSpawnHunterKillerPosition"
			,"SAEF_ModuleSpawnAreaVehicle"
			,"SAEF_ModuleSpawnAreaConfigCore"
			,"SAEF_ModuleSpawnAreaConfigUnits"
			,"SAEF_ModuleSpawnAreaConfigLightVehicles"
			,"SAEF_ModuleSpawnAreaConfigHeavyVehicles"
			,"SAEF_ModuleSpawnAreaConfigParaVehicles"
		};
		weapons[]={};
		author="Rabid Squirrel";
		requiredVersion=0.1;
		requiredAddons[]=
		{
			"A3_Data_F",
			"SAEF_TOOLBOX_PLAYER",
			"SAEF_TOOLBOX_MESSAGEQUEUE",
			"SAEF_TOOLBOX_DIAGNOSTICS",
			"A3_Modules_F"
		};
	};
};

class CfgFunctions
{
	class SAEF_AS
	{
		class AutomatedSpawning
		{
			file = "saef_automatedspawning\Functions";
			class Area {};
			class ConfigCore3DENValidation {};
			class ConfigCoreValidation {};
			class CounterAttack {};
			class CuratorHint {};
			class DynamicAttack {};
			class EvaluateAiCount {};
			class EvaluationParameter {};
			class ExportConfig {};
			class GetSynchronizedObjects {};
			class Handler {};
			class HunterKiller {};
			class Init 
			{
				postInit = 1;
			};
			class ModuleSpawnArea {};
			class ModuleSpawnAreaConfigCore {};
			class ModuleSpawnAreaVehicle {};
			class ModuleSpawnHunterKiller {};
			class ModuleSpawnHunterKillerPosition {};
			class Persistence {};
			class Radius {};
			class Recursive {};
			class Spawner {};
			class UpdateAiCount_Remote {};
			class UpdateAiCount {};
			class Variable {};
			class Vehicle {};
		};
	};
};

class Cfg3DEN
{
	class EventHandlers
	{
		class SAEF_AS_3DEN_EventHandlers
		{
			OnMissionSave = "[] call SAEF_AS_fnc_ConfigCore3DENValidation;";
		};
	};
};

class Extended_PreInit_EventHandlers {
    class SAEF_AutomatedSpawning_PreInitEvent {
        init = "call compile preprocessFileLineNumbers 'saef_automatedspawning\Functions\XEH_preInit.sqf'";
    };
};

class CfgFactionClasses
{
	class NO_CATEGORY;
	class SAEF_Modules: NO_CATEGORY
	{
		displayName = "SAEF";
	};
};

class CfgVehicles
{
	class Logic;

	class Module_F: Logic
	{
		class AttributesBase
		{
			class Default;
			class Edit;					// Default edit box (i.e., text input field)
			class Combo;				// Default combo box (i.e., drop-down menu)
			class Checkbox;				// Default checkbox (returned value is Boolean)
			class CheckboxNumber;		// Default checkbox (returned value is Number)
			class ModuleDescription;	// Module description
			class Units;				// Selection of units on which the module is applied
		};
		// Description base classes, for more information see below
		class ModuleDescription
		{
			class AnyBrain;
		};
	};

	class SAEF_ModuleSpawnArea: Module_F
	{
		scope = 2;
		scopeCurator = 2;
		displayName = "AI Spawn Area";
		//icon = "\myTag_addonName\data\iconNuke_ca.paa";
		category = "SAEF_Modules";

		function = "SAEF_AS_fnc_ModuleSpawnArea";
		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		// Menu displayed when the module is placed or double-clicked on by Zeus
		curatorInfoType = "RscDisplayAttributesSAEFSpawnArea";

		class Attributes: AttributesBase
		{
			/*	
				// Parameter structure
				_params:
				[
					true 								// Block the Patrol Portion of the Area
					,false 								// Block the Garrison Portion of the Area
					,"RS_EnemyUnits" 					// Variable pointer to array of units for spawning
					,"RS_EnemySide" 					// Variable pointer to side of units for spawning
					,"RS_EnemyLightVehicles" 			// Variable pointer to array of light vehicles for spawning
					,"RS_EnemyHeavyVehicles" 			// Variable pointer to array of heavy vehicles for spawning
					,{true} 							// Optional: Code block for extra validation passed to GetClosestPlayer
					,[] 								// Optional: Array of scripts run against the spawned group
					,{true}								// Optional: Code block for extra validation passed to the Message Queue
				]
			*/

			class Tag: Edit
			{
				property = "SAEF_ModuleSpawnArea_Tag";
				displayName = "Area Tag";
				tooltip = "Tag to create the area under, this will correspond to your mission configuration";
				defaultValue = "(((missionNamespace getVariable [""SAEF_AreaMarkerTags"", [[""tag""]]]) select 0) select 0)";
			};

			class Size: Combo
			{
				property = "SAEF_ModuleSpawnArea_Size";
				displayName = "Area Size";
				tooltip = "Basic descriptors for area size";
				typeName = "STRING";
				defaultValue = """SML""";
				class Values
				{
					class Small		{ name = "Small";	value = "SML"; };
					class Medium	{ name = "Medium"; 	value = "MED"; };
					class Large		{ name = "Large"; 	value = "LRG"; };
				};
			};

			class BlockPatrol: Checkbox
			{
				property = "SAEF_ModuleSpawnArea_BlockPatrol";
				displayName = "Block Patrol";
				tooltip = "Whether or not to block the patrol in this area";
				defaultValue = "false";
			};

			class BlockGarrison: Checkbox
			{
				property = "SAEF_ModuleSpawnArea_BlockGarrison";
				displayName = "Block Garrison";
				tooltip = "Whether or not to block the garrison in this area";
				defaultValue = "false";
			};

			class SpawnSide: Edit
			{
				property = "SAEF_ModuleSpawnArea_SpawnSide";
				displayName = "Side Variable (Optional)";
				tooltip = "(Optional) Variable pointer to side of units for spawning";
				defaultValue = """""";
			};

			class SpawnUnits: Edit
			{
				property = "SAEF_ModuleSpawnArea_SpawnUnits";
				displayName = "Unit Variable (Optional)";
				tooltip = "(Optional) Variable pointer to array of units for spawning";
				defaultValue = """""";
			};

			class SpawnLightVehicles: Edit
			{
				property = "SAEF_ModuleSpawnArea_SpawnLightVehicles";
				displayName = "Light Vehicle Variable (Optional)";
				tooltip = "(Optional) Variable pointer to array of light vehicles for spawning";
				defaultValue = """""";
			};

			class SpawnHeavyVehicles: Edit
			{
				property = "SAEF_ModuleSpawnArea_SpawnHeavyVehicles";
				displayName = "Heavy Vehicle Variable (Optional)";
				tooltip = "(Optional) Variable pointer to array of heavy vehicles for spawning";
				defaultValue = """""";
			};

			class SpawnParaVehicles: Edit
			{
				property = "SAEF_ModuleSpawnArea_SpawnParaVehicles";
				displayName = "Paradrop Vehicle Variable (Optional)";
				tooltip = "(Optional) Variable pointer to array of paradrop vehicles for spawning";
				defaultValue = """""";
			};

			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "Creates a controlled area that handles AI spawns for garrisons and patrols";
			sync[] = {"SAEF_ModuleSpawnAreaVehicle"}; // Array of synced entities (can contain base classes)

			class SAEF_ModuleSpawnAreaVehicle
			{
				description = "The linked vehicle spawn positions"
				position = 0;
				direction = 0;
				optional = 1;
				duplicate = 1;
			};
		};
	};

	class SAEF_ModuleSpawnHunterKiller: Module_F
	{
		scope = 2;
		scopeCurator = 2;
		displayName = "AI Spawn Hunter Killer";
		//icon = "\myTag_addonName\data\iconNuke_ca.paa";
		category = "SAEF_Modules";

		function = "SAEF_AS_fnc_ModuleSpawnHunterKiller";
		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		// Menu displayed when the module is placed or double-clicked on by Zeus
		curatorInfoType = "RscDisplayAttributesSAEFSpawnHunterKiller";

		class Attributes: AttributesBase
		{
			class Tag: Edit
			{
				property = "SAEF_ModuleSpawnHunterKiller_Tag";
				displayName = "Spawn Tag";
				tooltip = "Tag to create the units under, this will correspond to your mission configuration";
				defaultValue = "(((missionNamespace getVariable [""SAEF_AreaMarkerTags"", [[""tag""]]]) select 0) select 0)";
			};

			class SquadSize: Combo
			{
				property = "SAEF_ModuleSpawnHunterKiller_SquadSize";
				displayName = "Squad Size";
				tooltip = "The number of units in a Squad (this will be overridden if light or heavy vehicle is set)";
				typeName = "NUMBER";
				defaultValue = "4";
				class Values
				{
					class Two		{ name = "2";	value = 2; };
					class Four		{ name = "4"; 	value = 4; };
					class Six		{ name = "6"; 	value = 6; };
					class Eight		{ name = "8"; 	value = 8; };
					class Ten		{ name = "10"; 	value = 10; };
					class Twelve	{ name = "12"; 	value = 12; };
				};
			};

			class SearchArea: Combo
			{
				property = "SAEF_ModuleSpawnHunterKiller_SearchArea";
				displayName = "Search Area";
				tooltip = "The size of area in which the AI will hunt for players";
				typeName = "NUMBER";
				defaultValue = "4000";
				class Values
				{
					class Small		{ name = "500m";	value = 500; };
					class Medium	{ name = "1km"; 	value = 1000; };
					class Large		{ name = "2km"; 	value = 2000; };
					class XLarge	{ name = "4km"; 	value = 4000; };
				};
			};

			class LightVehicle: Checkbox
			{
				property = "SAEF_ModuleSpawnArea_LightVehicle";
				displayName = "Light Vehicle";
				tooltip = "Whether or not to spawn a light vehicle for the hunt (will override squad size and heavy vehicle)";
				defaultValue = "false";
			};

			class HeavyVehicle: Checkbox
			{
				property = "SAEF_ModuleSpawnArea_HeavyVehicle";
				displayName = "Heavy Vehicle";
				tooltip = "Whether or not to spawn a heavy vehicle for the hunt (will override squad size)";
				defaultValue = "false";
			};

			class Persistence: Checkbox
			{
				property = "SAEF_ModuleSpawnArea_Persistence";
				displayName = "Persist Hunter Killer";
				tooltip = "If this is enabled the Hunter Killer will respawn on the initial position after squad death (will need to be disabled by variable)";
				defaultValue = "false";
			};

			class RespawnTime: Combo
			{
				property = "SAEF_ModuleSpawnHunterKiller_RespawnTime";
				displayName = "Persistence Respawn Time";
				tooltip = "The time it takes for the Hunter Killer to respawn after they've been killed if you are persisting them";
				typeName = "NUMBER";
				defaultValue = "120";
				class Values
				{
					class OneMin	{ name = "1 Minute";	value = 60; };
					class TwoMin	{ name = "2 Minutes"; 	value = 120; };
					class FourMin	{ name = "4 Minutes"; 	value = 240; };
				};
			};

			class ParaVehicle: Checkbox
			{
				property = "SAEF_ModuleSpawnHunterKiller_ParaVehicle";
				displayName = "Paradrop Squad";
				tooltip = "Whether or not to spawn a paradrop vehicle for the the Hunter Killer Squad to be paradropped into the AO";
				defaultValue = "false";
			};

			class DynamicPosition: Checkbox
			{
				property = "SAEF_ModuleSpawnHunterKiller_DynamicPosition";
				displayName = "Use Dynamic Position";
				tooltip = "Whether or not to utilise dynamic positioning for spawns (useful in the case of chasing persistent spawns)";
				defaultValue = "false";
			};

			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "Creates a hunter killer squad that will hunt player in the specified area";
		};
	};

	class SAEF_ModuleSpawnHunterKillerPosition: Module_F
	{
		scope = 2;
		scopeCurator = 2;
		displayName = "AI Spawn Hunter Killer (Position)";
		//icon = "\myTag_addonName\data\iconNuke_ca.paa";
		category = "SAEF_Modules";

		function = "SAEF_AS_fnc_ModuleSpawnHunterKillerPosition";
		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		// Menu displayed when the module is placed or double-clicked on by Zeus
		curatorInfoType = "RscDisplayAttributesSAEFSpawnHunterKillerPosition";

		class Attributes: AttributesBase
		{
			class Tag: Edit
			{
				property = "SAEF_ModuleSpawnHunterKillerPosition_Tag";
				displayName = "Spawn Tag";
				tooltip = "Tag to create the position under, this will correspond to your mission configuration";
				defaultValue = "(((missionNamespace getVariable [""SAEF_AreaMarkerTags"", [[""tag""]]]) select 0) select 0)";
			};

			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "Creates a point at which a hunter killer team can be spawned using the dynamic positioning system";
			sync[] = {}; // Array of synced entities (can contain base classes)
		};
	};
	
	class SAEF_ModuleSpawnAreaVehicle: Module_F
	{
		scope = 2;
		scopeCurator = 2;
		displayName = "AI Spawn Area (Vehicle Selection)";
		//icon = "\myTag_addonName\data\iconNuke_ca.paa";
		category = "SAEF_Modules";

		function = "SAEF_AS_fnc_ModuleSpawnAreaVehicle";
		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		// Menu displayed when the module is placed or double-clicked on by Zeus
		curatorInfoType = "RscDisplayAttributesSAEFSpawnAreaVehicle";

		class Attributes: AttributesBase
		{
			class LightVehicle: Checkbox
			{
				property = "SAEF_ModuleSpawnAreaVehicle_LightVehicle";
				displayName = "Light Vehicle";
				tooltip = "Whether or not this should be a light vehicle spawn";
				defaultValue = "true";
			};

			class HeavyVehicle: Checkbox
			{
				property = "SAEF_ModuleSpawnAreaVehicle_HeavyVehicle";
				displayName = "Heavy Vehicle";
				tooltip = "Whether or not this should be a light vehicle spawn (will be overridden by light vehicle)";
				defaultValue = "false";
			};

			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "Creates a point at which a random one of the configured vehicles is spawned";
			sync[] = {"SAEF_ModuleSpawnArea"}; // Array of synced entities (can contain base classes)

			class SAEF_ModuleSpawnArea
			{
				description = "The spawn area for which this module applies"
				position = 1;
				direction = 1;
				optional = 0;
				duplicate = 0;
			};
		};
	};

	class SAEF_ModuleSpawnAreaConfigCore: Module_F
	{
		scope = 2;
		scopeCurator = 0;
		displayName = "Config - Spawning Core";
		//icon = "\myTag_addonName\data\iconNuke_ca.paa";
		category = "SAEF_Modules";

		function = "SAEF_AS_fnc_ModuleSpawnAreaConfigCore";
		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		// Menu displayed when the module is placed or double-clicked on by Zeus
		//curatorInfoType = "RscDisplayAttributesSAEFSpawnAreaVehicle";

		class Attributes: AttributesBase
		{
			class Tag: Edit
			{
				property = "SAEF_ModuleSpawnAreaConfigCore_Tag";
				displayName = "Area Tag";
				tooltip = "Tag to create the area config under";
				defaultValue = "(((missionNamespace getVariable [""SAEF_AreaMarkerTags"", [[""tag""]]]) select 0) select 0)";
			};

			class Name: Edit
			{
				property = "SAEF_ModuleSpawnAreaConfigCore_Name";
				displayName = "Area Name";
				tooltip = "The descriptive name for the area";
				defaultValue = """""";
			};

			class Side: Combo
			{
				property = "SAEF_ModuleSpawnArea_Side";
				displayName = "Side";
				tooltip = "The side that will be spawned";
				typeName = "STRING";
				defaultValue = """east""";
				class Values
				{
					class OpFor		{ name = "OpFor";		value = "east"; };
					class BluFor	{ name = "BluFor"; 		value = "west"; };
					class GreenFor	{ name = "GreenFor"; 	value = "independent"; };
					class Civilian	{ name = "Civilian"; 	value = "civilian"; };
				};
			};

			class BlockPatrol: Checkbox
			{
				property = "SAEF_ModuleSpawnAreaConfigCore_BlockPatrol";
				displayName = "Block Patrol";
				tooltip = "Whether or not to block the patrol in this area";
				defaultValue = "false";
			};

			class BlockGarrison: Checkbox
			{
				property = "SAEF_ModuleSpawnAreaConfigCore_BlockGarrison";
				displayName = "Block Garrison";
				tooltip = "Whether or not to block the garrison in this area";
				defaultValue = "false";
			};

			class DefaultEnding: Checkbox
			{
				property = "SAEF_ModuleSpawnAreaConfigCore_DefaultEnding";
				displayName = "Disable after empty";
				tooltip = "Whether or not to create a trigger that handles the default disabling of the area after it has been cleared";
				defaultValue = "true";
			};

			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "Creates the necessary configuration for this area";
			sync[] = 
			{
				"SAEF_ModuleSpawnAreaConfigUnits",
				"SAEF_ModuleSpawnAreaConfigLightVehicles",
				"SAEF_ModuleSpawnAreaConfigHeavyVehicles",
				"SAEF_ModuleSpawnAreaConfigParaVehicles"
			};

			class SAEF_ModuleSpawnAreaConfigUnits
			{
				description = "The linked units that will be added to the config"
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 0;
			};

			class SAEF_ModuleSpawnAreaConfigLightVehicles
			{
				description = "The linked light vehicles that will be added to the config"
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 0;
			};

			class SAEF_ModuleSpawnAreaConfigHeavyVehicles
			{
				description = "The linked heavy vehicles that will be added to the config"
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 0;
			};

			class SAEF_ModuleSpawnAreaConfigParaVehicles
			{
				description = "The linked paradrop vehicles that will be added to the config"
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 0;
			};
		};
	};

	class SAEF_ModuleSpawnAreaConfigUnits: Module_F
	{
		scope = 2;
		scopeCurator = 0;
		displayName = "Config - Infantry Units";
		category = "SAEF_Modules";

		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		class Attributes: AttributesBase
		{
			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "Units synced to this module will be added to the overall configuration as infantry units";
			sync[] = {"SAEF_ModuleSpawnAreaConfigCore"};

			class SAEF_ModuleSpawnAreaConfigCore
			{
				description = "The core module"
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 0;
			};
		};
	};

	class SAEF_ModuleSpawnAreaConfigLightVehicles: Module_F
	{
		scope = 2;
		scopeCurator = 0;
		displayName = "Config - Light Vehicles";
		category = "SAEF_Modules";

		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		class Attributes: AttributesBase
		{
			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "Units synced to this module will be added to the overall configuration as light vehicles";
			sync[] = {"SAEF_ModuleSpawnAreaConfigCore"};

			class SAEF_ModuleSpawnAreaConfigCore
			{
				description = "The core module"
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 0;
			};
		};
	};

	class SAEF_ModuleSpawnAreaConfigHeavyVehicles: Module_F
	{
		scope = 2;
		scopeCurator = 0;
		displayName = "Config - Heavy Vehicles";
		category = "SAEF_Modules";

		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		class Attributes: AttributesBase
		{
			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "Units synced to this module will be added to the overall configuration as heavy vehicles";
			sync[] = {"SAEF_ModuleSpawnAreaConfigCore"};

			class SAEF_ModuleSpawnAreaConfigCore
			{
				description = "The core module"
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 0;
			};
		};
	};

	class SAEF_ModuleSpawnAreaConfigParaVehicles: Module_F
	{
		scope = 2;
		scopeCurator = 0;
		displayName = "Config - Paradrop Vehicles";
		category = "SAEF_Modules";

		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		class Attributes: AttributesBase
		{
			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "Units synced to this module will be added to the overall configuration as paradrop vehicles";
			sync[] = {"SAEF_ModuleSpawnAreaConfigCore"};

			class SAEF_ModuleSpawnAreaConfigCore
			{
				description = "The core module"
				position = 0;
				direction = 0;
				optional = 0;
				duplicate = 0;
			};
		};
	};
};

class IGUIBack;
class RscFrame;
class RscButtonMenuOK;
class RscButtonMenuCancel;
class RscText;
class RscCombo;
class RscCheckbox;
class RscEdit;
class RscControlsGroup;
class RscControlsGroupNoScrollbars;
class RscMapControl;
class RscButtonMenu;

class RscDisplayAttributes
{
	class Controls
	{
		class Background;
		class Title;
		class Content
		{
			class controls;
		};
		class ButtonOK;
		class ButtonCancel;
	};
};

class RscAttributeSAEFSpawnArea: RscControlsGroupNoScrollbars
{
	onSetFocus="[_this,""RscAttributeSAEFSpawnArea"",'SAEFDisplayScripts'] call (uinamespace getvariable ""BIS_fnc_initCuratorAttribute"")";
	idc = 2200;
	x = "0 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
	y = "0 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
	w = "24 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
	h = "21 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
	colorBackground[] = {0,0,0,0};
	class controls
	{
		class Lbl_Tag: RscText
		{
			idc = 1001;
			text = "Area Tag"; //--- ToDo: Localize;
			tooltip = "Tag to create the area under, this will correspond to your mission configuration";
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_BlockPatrol: RscText
		{
			idc = 1002;
			text = "Block Patrol"; //--- ToDo: Localize;
			tooltip = "Whether or not to block the patrol in this area";
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "5.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_BlockGarrison: RscText
		{
			idc = 1003;
			text = "Block Garrison"; //--- ToDo: Localize;
				tooltip = "Whether or not to block the garrison in this area";
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "7.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_AreaSize: RscText
		{
			idc = 1004;
			text = "Area Size"; //--- ToDo: Localize;
			tooltip = "Basic descriptors for area size";
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "9.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_CustomTag: RscText
		{
			idc = 1005;
			text = "Custom Tag"; //--- ToDo: Localize;
			tooltip = "(Optional) Custom tag to create the area under, this will correspond to your mission configuration";
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "15 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_CustomSide: RscText
		{
			idc = 1006;
			text = "Custom Side"; //--- ToDo: Localize;
			tooltip = "(Optional) Variable pointer to side of units for spawning";
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "15 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_CustomSettings: RscText
		{
			idc = 1007;
			text = "Custom Settings (Optional)"; //--- ToDo: Localize;
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "13.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "9 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_CustomSettingsCont: RscText
		{
			idc = 1008;
			text = "Custom Settings (Optional)"; //--- ToDo: Localize;
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "9 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_CustomUnits: RscText
		{
			idc = 1009;
			text = "Custom Units"; //--- ToDo: Localize;
			tooltip = "(Optional) Variable pointer to array of units for spawning";
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "3 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_CustomLightVehicles: RscText
		{
			idc = 10010;
			text = "Custom Light Vehicles"; //--- ToDo: Localize;
			tooltip = "(Optional) Variable pointer to array of light vehicles for spawning";
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "6 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_CustomHeavyVehicles: RscText
		{
			idc = 1011;
			text = "Custom Heavy Vehicles"; //--- ToDo: Localize;
			tooltip = "(Optional) Variable pointer to array of heavy vehicles for spawning";
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "9 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_CustomParadropVehicles: RscText
		{
			idc = 1012;
			text = "Custom Paradrop Vehicles"; //--- ToDo: Localize;
			tooltip = "(Optional) Variable pointer to array of paradrop vehicles for spawning";
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "12 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Cmb_Tag: RscCombo
		{
			idc = 2100;
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "3 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Cmb_AreaSize: RscCombo
		{
			idc = 2101;
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "11 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class CkB_BlockPatrol: RscCheckbox
		{
			idc = 2800;
			x = "12 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "5.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "1 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class CkB_BlockGarrison: RscCheckbox
		{
			idc = 2801;
			x = "12 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "7.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "1 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Edt_CustomTag: RscEdit
		{
			idc = 1400;
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "16 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Edt_CustomSide: RscEdit
		{
			idc = 1401;
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "16 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Edt_CustomUnits: RscEdit
		{
			idc = 1402;
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "4 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Edt_CustomLightVehicles: RscEdit
		{
			idc = 1403;
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "7 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Edt_CustomHeavyVehicles: RscEdit
		{
			idc = 1404;
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "10 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Edt_CustomParadropVehicles: RscEdit
		{
			idc = 1405;
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "13 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
	};
};

class RscDisplayAttributesSAEFSpawnArea: RscDisplayAttributes
{
	scriptName="RscDisplayAttributesSAEFSpawnArea";
	scriptPath="SAEFDisplayScripts";
	onLoad="[""onLoad"",_this,""RscDisplayAttributesSAEFSpawnArea"",'SAEFDisplayScripts'] call (uinamespace getvariable 'BIS_fnc_initDisplay')";
	onUnload="[""onUnload"",_this,""RscDisplayAttributesSAEFSpawnArea"",'SAEFDisplayScripts'] call (uinamespace getvariable 'BIS_fnc_initDisplay')";
	class Controls: Controls
	{
		class Background: Background
		{
		};
		class Title: Title
		{
		};
		class Content: Content
		{
			class Controls: controls
			{
				class SAEFSpawner: RscAttributeSAEFSpawnArea
				{};
			};
		};
		class ButtonOK: ButtonOK
		{
		};
		class ButtonCancel: ButtonCancel
		{
		};
	};
};

class RscAttributeSAEFSpawnHunterKiller: RscControlsGroupNoScrollbars
{
	onSetFocus="[_this,""RscAttributeSAEFSpawnHunterKiller"",'SAEFDisplayScripts'] call (uinamespace getvariable ""BIS_fnc_initCuratorAttribute"")";
	idc = 2200;
	x = "0 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
	y = "0 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
	w = "24 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
	h = "21 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
	colorBackground[] = {0,0,0,0};
	class controls
	{
		class Lbl_Tag: RscText
		{
			idc = 1001;
			text = "Area Tag"; //--- ToDo: Localize;
			tooltip = "Tag to create the units under, this will correspond to your mission configuration";
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_SquadSize: RscText
		{
			idc = 1002;
			text = "Squad Size"; //--- ToDo: Localize;
			tooltip = "The number of units in a Squad (this will be overridden if light or heavy vehicle is set)";
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "5.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_SearchArea: RscText
		{
			idc = 1003;
			text = "Search Area"; //--- ToDo: Localize;
			tooltip = "The size of area in which the AI will hunt for players";
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "9.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_LightVehicle: RscText
		{
			idc = 1004;
			text = "Light Vehicle"; //--- ToDo: Localize;
			tooltip = "Whether or not to spawn a light vehicle for the hunt (will override squad size and heavy vehicle)";
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "14 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_HeavyVehicle: RscText
		{
			idc = 1005;
			text = "Heavy Vehicle"; //--- ToDo: Localize;
			tooltip = "Whether or not to spawn a heavy vehicle for the hunt (will override squad size)";
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "16 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_CustomSettings: RscText
		{
			idc = 1006;
			text = "Custom Settings (Optional)"; //--- ToDo: Localize;
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "9 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_Persistence: RscText
		{
			idc = 1008;
			text = "Persist Squad"; //--- ToDo: Localize;
			tooltip = "If this is enabled the Hunter Killer will respawn on the initial position after squad death (will need to be disabled by variable)";
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "3 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_RespawnTime: RscText
		{
			idc = 1009;
			text = "Persistence Respawn Time"; //--- ToDo: Localize;
			tooltip = "The time it takes for the Hunter Killer to respawn after they've been killed if you are persisting them";
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "5.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_ParadropVehicle: RscText
		{
			idc = 1010;
			text = "Paradrop Squad"; //--- ToDo: Localize;
			tooltip = "Whether or not to spawn a paradrop vehicle for the the Hunter Killer Squad to be paradropped into the AO";
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "9.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_DynamicPosition: RscText
		{
			idc = 1011;
			text = "Dynamic Position"; //--- ToDo: Localize;
			tooltip = "Whether or not to utilise dynamic positioning for spawns (useful in the case of chasing persistent spawns)";
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "11.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_CustomTag: RscText
		{
			idc = 1012;
			text = "Custom Area Tag"; //--- ToDo: Localize;
			tooltip = "(Optional) Custom tag to create the area under, this will correspond to your mission configuration";
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "14 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Cmb_Tag: RscCombo
		{
			idc = 2110;
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "3 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Cmb_SquadSize: RscCombo
		{
			idc = 2111;
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "7 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Cmb_SearchArea: RscCombo
		{
			idc = 2112;
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "11 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Cmb_RespawnTime: RscCombo
		{
			idc = 2113;
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "7 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class CkB_LightVehicle: RscCheckbox
		{
			idc = 2810;
			x = "12 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "14 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "1 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class CkB_HeavyVehicle: RscCheckbox
		{
			idc = 2811;
			x = "12 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "16 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "1 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class CkB_Persistence: RscCheckbox
		{
			idc = 2812;
			x = "24 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "3 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "1 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class CkB_ParadropVehicle: RscCheckbox
		{
			idc = 2813;
			x = "24 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "9.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "1 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class CkB_DynamicPosition: RscCheckbox
		{
			idc = 2814;
			x = "24 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "11.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "1 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Edt_CustomTag: RscEdit
		{
			idc = 1410;
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "15 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
	};
};

class RscDisplayAttributesSAEFSpawnHunterKiller: RscDisplayAttributes
{
	scriptName="RscDisplayAttributesSAEFSpawnHunterKiller";
	scriptPath="SAEFDisplayScripts";
	onLoad="[""onLoad"",_this,""RscDisplayAttributesSAEFSpawnHunterKiller"",'SAEFDisplayScripts'] call 	(uinamespace getvariable 'BIS_fnc_initDisplay')";
	onUnload="[""onUnload"",_this,""RscDisplayAttributesSAEFSpawnHunterKiller"",'SAEFDisplayScripts'] call 	(uinamespace getvariable 'BIS_fnc_initDisplay')";
	class Controls: Controls
	{
		class Background: Background
		{
		};
		class Title: Title
		{
		};
		class Content: Content
		{
			class Controls: controls
			{
				class SAEFSpawner: RscAttributeSAEFSpawnHunterKiller
				{};
			};
		};
		class ButtonOK: ButtonOK
		{
		};
		class ButtonCancel: ButtonCancel
		{
		};
	};
};

class RscAttributeSAEFSpawnHunterKillerPosition: RscControlsGroupNoScrollbars
{
	onSetFocus="[_this,""RscAttributeSAEFSpawnHunterKillerPosition"",'SAEFDisplayScripts'] call (uinamespace getvariable ""BIS_fnc_initCuratorAttribute"")";
	idc = 2200;
	x = "0 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
	y = "0 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
	w = "24 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
	h = "21 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
	colorBackground[] = {0,0,0,0};
	class controls
	{
		class Lbl_Tag: RscText
		{
			idc = 1001;
			text = "Area Tag"; //--- ToDo: Localize;
			tooltip = "Tag to create the units under, this will correspond to your mission configuration";
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Cmb_Tag: RscCombo
		{
			idc = 2110;
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "3 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
	};
};

class RscDisplayAttributesSAEFSpawnHunterKillerPosition: RscDisplayAttributes
{
	scriptName="RscDisplayAttributesSAEFSpawnHunterKillerPosition";
	scriptPath="SAEFDisplayScripts";
	onLoad="[""onLoad"",_this,""RscDisplayAttributesSAEFSpawnHunterKillerPosition"",'SAEFDisplayScripts'] call 	(uinamespace getvariable 'BIS_fnc_initDisplay')";
	onUnload="[""onUnload"",_this,""RscDisplayAttributesSAEFSpawnHunterKillerPosition"",'SAEFDisplayScripts'] call 	(uinamespace getvariable 'BIS_fnc_initDisplay')";
	class Controls: Controls
	{
		class Background: Background
		{
		};
		class Title: Title
		{
		};
		class Content: Content
		{
			class Controls: controls
			{
				class SAEFSpawner: RscAttributeSAEFSpawnHunterKillerPosition
				{};
			};
		};
		class ButtonOK: ButtonOK
		{
		};
		class ButtonCancel: ButtonCancel
		{
		};
	};
};

class RscAttributeSAEFSpawnAreaVehicle: RscControlsGroupNoScrollbars
{
	onSetFocus="[_this,""RscAttributeSAEFSpawnAreaVehicle"",'SAEFDisplayScripts'] call (uinamespace getvariable ""BIS_fnc_initCuratorAttribute"")";
	idc = 2200;
	x = "0 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
	y = "0 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
	w = "24 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
	h = "8 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
	colorBackground[] = {0,0,0,0};
	class controls
	{
		class Lbl_LightVehicle: RscText
		{
			idc = 1021;
			text = "Light Vehicle"; //--- ToDo: Localize;
			tooltip = "Whether or not this should be a light vehicle spawn";
			x = "6 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "8 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class Lbl_HeavyVehicle: RscText
		{
			idc = 1022;
			text = "Heavy Vehicle"; //--- ToDo: Localize;
			tooltip = "Whether or not this should be a light vehicle spawn (will be overridden by light vehicle)";
			x = "18 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "9 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class CkB_LightVehicle: RscCheckbox
		{
			idc = 2820;
			x = "12 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "1 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
		class CkB_HeavyVehicle: RscCheckbox
		{
			idc = 2821;
			x = "24 * (((safezoneW / safezoneH) min 1.2) / 40) + (safezoneX + (safezoneW - ((safezoneW / safezoneH) min 1.2))/2)"; // * GUI_GRID_W + GUI_GRID_X;
			y = "1.5 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2)"; // * GUI_GRID_H + GUI_GRID_Y;
			w = "1 * (((safezoneW / safezoneH) min 1.2) / 40)"; // * GUI_GRID_W;
			h = "1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // * GUI_GRID_H;
		};
	};
};

class RscDisplayAttributesSAEFSpawnAreaVehicle: RscDisplayAttributes
{
	scriptName="RscDisplayAttributesSAEFSpawnAreaVehicle";
	scriptPath="SAEFDisplayScripts";
	onLoad="[""onLoad"",_this,""RscDisplayAttributesSAEFSpawnAreaVehicle"",'SAEFDisplayScripts'] call (uinamespace getvariable 'BIS_fnc_initDisplay')";
	onUnload="[""onUnload"",_this,""RscDisplayAttributesSAEFSpawnAreaVehicle"",'SAEFDisplayScripts'] call (uinamespace getvariable 'BIS_fnc_initDisplay')";
	class Controls: Controls
	{
		class Background: Background
		{
		};
		class Title: Title
		{
		};
		class Content: Content
		{
			class Controls: controls
			{
				class SAEFSpawner: RscAttributeSAEFSpawnAreaVehicle
				{};
			};
		};
		class ButtonOK: ButtonOK
		{
		};
		class ButtonCancel: ButtonCancel
		{
		};
	};
};

class CfgScriptPaths
{
	SAEFDisplayScripts = "saef_automatedspawning\DisplayScripts\";
};