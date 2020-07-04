class CfgPatches
{
	class SAEF_TOOLBOX_INVASION
	{
		version=2;
		units[]={};
		weapons[]={};
		author="Rabid Squirrel";
		requiredVersion=0.1;
		requiredAddons[]=
		{
			"A3_Data_F"
		};
	};
};

class CfgFunctions
{
	class RS
	{
		class Invasion
		{
			file = "saef_invasion\Functions";
			class Client_AddDropAction {};
			class Client_Flak {};
			class Client_Invasion {};
			class Client_MisDropItems {};
			class Client_MountPlayer {};
			class Client_MoveIn {};
			class Client_PlayerParaTouchDown {};
			class Client_RemoteParaPlane {};
			class Client_Screen {};
			class Server_AAFire {};
			class Server_AAGuns {};
			class Server_AmbientAirDrop {};
			class Server_AmbientAirDropPara {};
			class Server_Invasion {};
			class Server_ParaDelete {};
			class Server_PlaneCleanup {};
			class Server_PlaneLights {};
			class Server_PlayerAirDrop {};
			class Server_SpawnExtraAI {};
			class Server_SpawnPlane {};
			class Server_WatchCargoNumber {};
		};
	};
};