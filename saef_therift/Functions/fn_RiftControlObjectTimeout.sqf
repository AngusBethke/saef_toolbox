/**
	@namespace RS_Rift
	@class TheRift
	@method RS_Rift_fnc_RiftControlObjectTimeout
	@file fn_RiftControlObjectTimeout.sqf
	@summary Handles control object timeout hints

	@param int _delay

	@usages ```	
	How to call:
		[_delay] spawn RS_Rift_fnc_RiftControlObjectTimeout;
	``` @endusages

**/

/*
	fn_RiftControlObjectTimeout.sqf

	Description: 
		Handles control object timeout hints

	How to call:
		[_delay] spawn RS_Rift_fnc_RiftControlObjectTimeout;
*/

// Non players need not see the hint
if (!hasInterface) exitWith {};

params
[
	"_delay"
];

private
[
	"_increment",
	"_percentage",
	"_total"
];

_increment = (_delay / 100);
_percentage = (100 / _delay);
_total = 0;

while {_total < 100} do
{
	_total = _total + _percentage;

	if (_total > 100) then
	{
		_total = 100;
	};

	hintSilent ((format ["[<!>] Disabling Device %1", (round _total)]) + "%...  [<!>]");

	sleep _increment;
};