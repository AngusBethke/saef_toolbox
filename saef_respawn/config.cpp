class CfgPatches
{
	class SAEF_TOOLBOX_RESPAWN
	{
		version=2;
		units[]=
		{
			"RS_ModuleRespawn",
			"RS_ModuleRespawnPenalty"
		};
		weapons[]={};
		author="Rabid Squirrel";
		requiredVersion=0.1;
		requiredAddons[]=
		{
			"A3_Data_F",
			"SAEF_TOOLBOX_ADMIN",
			"SAEF_TOOLBOX_STATTRACK",
			"SAEF_TOOLBOX_DIAGNOSTICS",
			"A3_Modules_F"
		};
	};
};

class CfgFunctions
{
	class RS
	{
		class Respawn
		{
			file = "saef_respawn\Functions";
			class ForceRespawnSelf {};
			class Handler_TimedRespawn {};
			class Handler_WaveRespawn_PenaltyHandler {};
			class Handler_WaveRespawn_Player_PenaltyTime {};
			class Handler_WaveRespawn {};
			class InitRespawnHandler 
			{
				postInit = 1;
			};
			class ModuleRespawn {};
			class PlayerOnKilled {};
			class RespawnDelayedStart {};
			class RespawnHints {};
			class RespawnInformation {};
			class RespawnPlayerHandler {};
			class RespawnPlayerInit {};
			class SpectatorHint {};
		};
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

	class RS_ModuleRespawn: Module_F
	{
		scope = 2;
		scopeCurator = 0;
		displayName = "Respawn";
		//icon = "\myTag_addonName\data\iconNuke_ca.paa";
		category = "SAEF_Modules";

		function = "RS_fnc_ModuleRespawn";
		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		// Menu displayed when the module is placed or double-clicked on by Zeus
		//curatorInfoType = "RscDisplayAttributesSAEFSpawnArea";

		class Attributes: AttributesBase
		{
			class Type: Combo
			{
				property = "RS_ModuleRespawn_Type";
				displayName = "Type";
				tooltip = "The type of respawn handler to kick off";
				typeName = "STRING";
				defaultValue = """wave""";
				class Values
				{
					class Wave		{ name = "Wave";	value = "wave"; };
					class Timed     { name = "Timed";	value = "time"; };
				};
			};

			class Time: Combo
			{
				property = "RS_ModuleRespawn_Time";
				displayName = "Time";
				tooltip = "Default Respawn time (used by both wave and timed respawn)";
				typeName = "NUMBER";
				defaultValue = "300";
				class Values
				{
					class Five		{ name = "5 minutes";	value = 300; };
					class Ten	    { name = "10 minutes"; 	value = 600; };
					class Fifteen	{ name = "15 minutes"; 	value = 900; };
					class Twenty	{ name = "20 minutes"; 	value = 1200; };
				};
			};

			class HoldTime: Combo
			{
				property = "RS_ModuleRespawn_HoldTime";
				displayName = "Hold Time";
				tooltip = "The time to hold the respawn open for (used by both wave and timed respawn)";
				typeName = "NUMBER";
				defaultValue = "30";
				class Values
				{
					class Thirty		{ name = "30 seconds";	value = 30; };
					class FourtyFive	{ name = "45 seconds";	value = 45; };
					class OneMin		{ name = "1 minute"; 	value = 60; };
				};
			};

			class MaxTime: Combo
			{
				property = "RS_ModuleRespawn_MaxTime";
				displayName = "Max Time";
				tooltip = "The max time that the respawn will last for (used by wave respawn)";
				typeName = "NUMBER";
				defaultValue = "900";
				class Values
				{
					class Ten	    	{ name = "10 minutes"; 	value = 600; };
					class Fifteen		{ name = "15 minutes"; 	value = 900; };
					class Twenty		{ name = "20 minutes"; 	value = 1200; };
					class TwentyFive	{ name = "25 minutes"; 	value = 1500; };
				};
			};

			class PlayerThreshold: Combo
			{
				property = "RS_ModuleRespawn_PlayerThreshold";
				displayName = "Player Threshold";
				tooltip = "The amount of players required to kick-off the respawn (used by wave respawn)";
				typeName = "NUMBER";
				defaultValue = "5";
				class Values
				{
					class Two		{ name = "2"; 	value = 2; };
					class Three		{ name = "3"; 	value = 3; };
					class Four		{ name = "4"; 	value = 4; };
					class Five		{ name = "5"; 	value = 5; };
					class Six		{ name = "6"; 	value = 6; };
					class Seven		{ name = "7"; 	value = 7; };
					class Eight		{ name = "8"; 	value = 8; };
					class Nine		{ name = "9"; 	value = 9; };
					class Ten		{ name = "10"; 	value = 10; };
				};
			};

			class PenaltyTime: Combo
			{
				property = "RS_ModuleRespawn_PenaltyTime";
				displayName = "Penalty Time";
				tooltip = "The penalty time added when a player dies (used by wave respawn)";
				typeName = "NUMBER";
				defaultValue = "30";
				class Values
				{
					class None			{ name = "No Penalty";	value = 0; };
					class Fifteen		{ name = "15 seconds";	value = 15; };
					class Thirty		{ name = "30 seconds";	value = 30; };
					class FourtyFive	{ name = "45 seconds";	value = 45; };
					class OneMin		{ name = "1 minute"; 	value = 60; };
				};
			};

			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "Creates a SAEF respawn handler";
			sync[] = {}; // Array of synced entities (can contain base classes)
		};
	};

	class RS_ModuleRespawnPenalty: Module_F
	{
		scope = 2;
		scopeCurator = 0;
		displayName = "Respawn (Penalty)";
		//icon = "\myTag_addonName\data\iconNuke_ca.paa";
		category = "SAEF_Modules";

		//function = "RS_fnc_ModuleRespawnPenalty";
		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		// Menu displayed when the module is placed or double-clicked on by Zeus
		//curatorInfoType = "RscDisplayAttributesSAEFSpawnArea";

		class Attributes: AttributesBase
		{
			class PenaltyFactor: Combo
			{
				property = "RS_ModuleRespawnPenalty_PenaltyFactor";
				displayName = "Penalty Factor";
				tooltip = "The penalty factor applied to the synchronised unit";
				typeName = "NUMBER";
				defaultValue = "0.5";
				class Values
				{
					class Fifty				{ name = "50%"; 	value = 0.5; };
					class Hundred			{ name = "100%"; 	value = 1; };
					class HundredFifty		{ name = "150%"; 	value = 1.5; };
					class TwoHundred		{ name = "200%"; 	value = 2; };
				};
			};

			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "Creates a SAEF penalty setting";
			sync[] = {}; // Array of synced entities (can contain base classes)
		};
	};
};