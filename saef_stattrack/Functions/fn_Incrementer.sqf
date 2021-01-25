/*
	fn_Incrementer.sqf
	Description: Adds given increment to given variable
	Author: Angus Bethke (a.k.a. Rabid Squirrel)
*/

params
[
	"_variable",
	"_value",
	["_pureValue", false]
];

private
[
	"_retrievedVariable"
];

// Decider based on whether value is an array
if (_pureValue) then
{
	_retrievedVariable = missionNamespace getVariable [_variable, 0];
	_retrievedVariable = _retrievedVariable + _value;
	missionNamespace setVariable [_variable, _retrievedVariable, true];
}
else
{
	_retrievedVariable = missionNamespace getVariable [_variable, []];
	_retrievedVariable pushBack _value;
	missionNamespace setVariable [_variable, _retrievedVariable, true];
};