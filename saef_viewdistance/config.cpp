class CfgPatches
{
	class SAEF_TOOLBOX_VIEWDISTANCE
	{
		version=2;
		units[]=
		{
			"SAEF_ModuleViewDistance"
		};
		weapons[]={};
		author="Rabid Squirrel";
		requiredVersion=0.1;
		requiredAddons[]=
		{
			"A3_Data_F",
			"SAEF_TOOLBOX_DIAGNOSTICS",
			"A3_Modules_F"
		};
	};
};

class CfgFunctions
{
	class SAEF_VD
	{
		class ViewDistance
		{
			file = "saef_viewdistance\Functions";
			class HeightBasedViewDistance {};
			class Init {};
			class ModuleViewDistance {};
			class PlayerInit {};
			class ViewDistance {};
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

	class SAEF_ModuleViewDistance: Module_F
	{
		scope = 2;
		scopeCurator = 0;
		displayName = "View Distance";
		//icon = "\myTag_addonName\data\iconNuke_ca.paa";
		category = "SAEF_Modules";

		function = "SAEF_VD_fnc_ModuleViewDistance";
		functionPriority = 1;
		isGlobal = 0;
		isTriggerActivated = 1;
		isDisposable = 1;
		is3DEN = 0;

		// Menu displayed when the module is placed or double-clicked on by Zeus
		//curatorInfoType = "RscDisplayAttributesSAEFSpawnArea";

		class Attributes: AttributesBase
		{
			class ServerViewDistance: Edit
			{
				property = "SAEF_ModuleViewDistance_ServerViewDistance";
				displayName = "Server View Distance";
				tooltip = "The view distance used by the server";
				typeName = "NUMBER";
				defaultValue = "1200";
			};

			class PlayerViewDistance: Edit
			{
				property = "SAEF_ModuleViewDistance_PlayerViewDistance";
				displayName = "Player View Distance";
				tooltip = "The view distance used by the server";
				typeName = "NUMBER";
				defaultValue = "1200";
			};
            
			class AircraftViewDistance: Edit
			{
				property = "SAEF_ModuleViewDistance_AircraftViewDistance";
				displayName = "Aircraft View Distance";
				tooltip = "The view distance used by the automated height based view distance handler";
				typeName = "NUMBER";
				defaultValue = "5000";
			};

			class ShadowViewDistance: Combo
			{
				property = "SAEF_ModuleViewDistance_ShadowViewDistance";
				displayName = "Shadow View Distance";
				tooltip = "The view distance of shadows";
				typeName = "NUMBER";
				defaultValue = "50";
				class Values
				{
					class TwentyFive	{ name = "25";	    value = 25; };
					class Fifty	        { name = "50"; 	    value = 50; };
					class SeventyFive	{ name = "75"; 	    value = 75; };
					class OneHundred	{ name = "100"; 	value = 100; };
				};
			};

			class FixedCeiling: Combo
			{
				property = "SAEF_ModuleViewDistance_FixedCeiling";
				displayName = "Fixed Ceiling";
				tooltip = "The height used by the automated height based view distance handler to forcefully cap the height";
				typeName = "NUMBER";
				defaultValue = "150";
				class Values
				{
					class OneHundred	{ name = "100"; 	value = 100; };
					class OneFifty	    { name = "150"; 	value = 150; };
					class TwoHundred    { name = "200"; 	value = 200; };
					class TwoFifty	    { name = "250"; 	value = 250; };
				};
			};

			class ModuleDescription: ModuleDescription{};
		};

		class ModuleDescription: ModuleDescription
		{
			description = "Manages the view distance and related handlers";
			sync[] = {}; // Array of synced entities (can contain base classes)
		};
	};
};