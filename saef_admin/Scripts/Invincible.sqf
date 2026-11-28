/*
	Moved to saef_toolbox from the SAEF Mission Framework (Scripts\Utility\Invincible.sqf).
	The framework keeps Scripts\Utility\Invincible.sqf as a wrapper that forwards to \saef_admin\Scripts\Invincible.sqf.
*/

/*
	Invincible.sqf
	Description: Make Player Local to Script Execution Invincible
*/

_invincible = !(_this select 0);

player allowDamage _invincible;