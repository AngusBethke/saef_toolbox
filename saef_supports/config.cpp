class CfgPatches
{
	class SAEF_TOOLBOX_SUPPORTS
	{
		version=2;
		units[]={};
		weapons[]={};
		author="Rabid Squirrel";
		requiredVersion=0.1;
		requiredAddons[]=
		{
			"A3_Data_F",
			"SAEF_TOOLBOX_MESSAGEQUEUE",
			"SAEF_TOOLBOX_VEHICLE"
		};
	};
};

/*
	ACE support actions (air, transport and mobile support objects) and helicopter/paradrop insertion.
	Moved from the mission-side Toolbox (Toolbox\AceSupportActions, Toolbox\ASA_Insertion) in the SAEF Mission
	Framework. Function names are unchanged (SAEF_ASA_fnc_*, SAEF_ASA_INS_fnc_*), so missions that still register
	their own copies keep working: the mod's versions are final and take precedence.
*/
class CfgFunctions
{
	class SAEF_ASA
	{
		class AceSupportActions
		{
			file = "saef_supports\AceSupportActions\Functions";
			class CustomCallsigns {};
			class DeploymentBeacon {};
			class HandleDeploymentBeaconPlacement {};
			class InitPlayer {};
			class InitServer {};
			class MobileSupportObject {};
			class MSO_AddActions {};
			class MSO_AddSubFolders {};
			class Player_PersonalSupportActions {};
			class Player_VehicleInteraction {};
			class SupportHandler_Player {};
			class SupportHandler_Server {};
			class TimeUntilGivenTime {};
		};
	};

	class SAEF_ASA_INS
	{
		class AceSupportActions
		{
			file = "saef_supports\Insertion\Functions";
			class HandleInsertion {};
			class HandleParadrop_Cargo {};
			class HandleParadrop_Player {};
			class HelicopterInsertion {};
			class HelicopterInsertion_AddAction {};
			class HelicopterInsertion_EnsureDoorsAreOpen {};
			class HelicopterInsertion_HandleFastRope {};
			class HelicopterInsertion_HandleLanding {};
			class HelicopterInsertion_HandleRecursion {};
			class HelicopterInsertion_NoPlayersInVehicle {};
			class HelicopterInsertion_PlayerFastRope {};
			class HelicopterInsertion_WaitForStart {};
			class HelicopterInsertion_Waypoints {};
			class Init {};
			class SpawnVehicle {};
		};
	};
};