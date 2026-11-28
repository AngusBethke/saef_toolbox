/*
	fn_InitServer.sqf

	Description:
		Initialises support related variables on the server

	How to Call:
		[] call SAEF_ASA_fnc_InitServer;
*/

// Server execution only
if (!isServer) exitWith {};

// Main Support Variables
missionNamespace setVariable ["SAEF_ASA_Supports_Enabled", (missionNamespace getVariable ["SAEF_ASA_Supports_Enabled", true]), true];
missionNamespace setVariable ["SAEF_ASA_AirSupport_Enabled", (missionNamespace getVariable ["SAEF_ASA_AirSupport_Enabled", true]), true];
missionNamespace setVariable ["SAEF_ASA_TransportSupport_Enabled", (missionNamespace getVariable ["SAEF_ASA_TransportSupport_Enabled", true]), true];

// Air Support Tracking Variables
missionNamespace setVariable ["SAEF_ASA_AirSupport_Timer", (missionNamespace getVariable ["SAEF_ASA_AirSupport_Timer", 480]), true];
missionNamespace setVariable ["SAEF_ASA_AirSupport_Timer_Penalty", (missionNamespace getVariable ["SAEF_ASA_AirSupport_Timer_Penalty", 0]), true];
missionNamespace setVariable ["SAEF_ASA_AirSupport_Unlimited", (missionNamespace getVariable ["SAEF_ASA_AirSupport_Unlimited", false]), true];
missionNamespace setVariable ["SAEF_ASA_AirSupport_Available", (missionNamespace getVariable ["SAEF_ASA_AirSupport_Available", true]), true];
missionNamespace setVariable ["SAEF_ASA_AirSupport_Finished", (missionNamespace getVariable ["SAEF_ASA_AirSupport_Finished", true]), true];

// Transport Support Tracking Variables
missionNamespace setVariable ["SAEF_ASA_TransportSupport_Timer", (missionNamespace getVariable ["SAEF_ASA_TransportSupport_Timer", 0]), true];
missionNamespace setVariable ["SAEF_ASA_TransportSupport_Timer_Penalty", (missionNamespace getVariable ["SAEF_ASA_TransportSupport_Timer_Penalty", 0]), true];
missionNamespace setVariable ["SAEF_ASA_TransportSupport_Available", (missionNamespace getVariable ["SAEF_ASA_TransportSupport_Available", true]), true];
missionNamespace setVariable ["SAEF_ASA_TransportSupport_Finished", (missionNamespace getVariable ["SAEF_ASA_TransportSupport_Finished", true]), true];

// Time tracking
if (isServer && hasInterface) then
{
	missionNamespace setVariable ["SAEF_ASA_AirSupport_Available_Time", time, true];
	missionNamespace setVariable ["SAEF_ASA_TransportSupport_Available_Time", time, true];
}
else
{
	missionNamespace setVariable ["SAEF_ASA_AirSupport_Available_Time", serverTime, true];
	missionNamespace setVariable ["SAEF_ASA_TransportSupport_Available_Time", serverTime, true];
};

// Mobile Support Object Variables
missionNamespace setVariable ["SAEF_ASA_AllowedMSOCount", (missionNamespace getVariable ["SAEF_ASA_AllowedMSOCount", 9999]), true];
missionNamespace setVariable ["SAEF_ASA_ActiveMSOCount", (missionNamespace getVariable ["SAEF_ASA_ActiveMSOCount", 0]), true];
missionNamespace setVariable ["SAEF_ASA_MobileSupportObject", (missionNamespace getVariable ["SAEF_ASA_MobileSupportObject", "B_Static_Designator_01_F"]), true];

// Deployment Beacon
missionNamespace setVariable ["SAEF_ASA_DeploymentBeacons", (missionNamespace getVariable ["SAEF_ASA_DeploymentBeacons", []]), true];
missionNamespace setVariable ["SAEF_ASA_DeploymentMovementObjects", (missionNamespace getVariable ["SAEF_ASA_DeploymentMovementObjects", []]), true];

// Mark that setup is complete
missionNamespace setVariable ["SAEF_ASA_Supports_ServerInitComplete", true, true];