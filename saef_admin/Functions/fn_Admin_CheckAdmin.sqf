/*
	fn_Admin_CheckAdmin.sqf
	Description: Checks if the Player is an Admin. If so, marks them as an Admin.
	How to Call: [] spawn RS_fnc_Admin_CheckAdmin;
*/

player setVariable ["RS_IsAdmin", false, true];
missionNamespace setVariable ["RS_RunCheckAdmin", true, true];

while {missionNamespace getVariable "RS_RunCheckAdmin"} do
{
	if ((serverCommandAvailable "#logout") || (isServer) || (player getVariable ["RS_AdminOverride", false])) then
	{
		player setVariable ["RS_IsAdmin", true, true];
	}
	else
	{
		player setVariable ["RS_IsAdmin", false, true];
	};
	
	sleep 60;
};