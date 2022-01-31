/**
	@namespace SAEF_AS
	@class AutomatedSpawning
	@method SAEF_AS_fnc_CuratorHint
	@file fn_CuratorHint.sqf
	@summary Allows a message to be hinted only to the curator (Zeus)
	@param string _message
**/
/*
	fn_CuratorHint.sqf

	Description:
		Allows a message to be hinted only to the curator (Zeus)
*/

params
[
	"_message"
];

// If this player is a curator
if (!isNull (getAssignedCuratorLogic player)) then
{
	hint _message;
};