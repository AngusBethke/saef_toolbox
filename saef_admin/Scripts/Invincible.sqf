/*
	Moved to saef_toolbox from the SAEF Mission Framework (Scripts\Utility\Invincible.sqf).
*/

/*
	Invincible.sqf
	Description: Make Player Local to Script Execution Invincible
*/

_invincible = !(_this select 0);

player allowDamage _invincible;