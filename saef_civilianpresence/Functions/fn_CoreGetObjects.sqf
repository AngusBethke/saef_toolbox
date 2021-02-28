#include "\A3\modules_F_Tacops\Ambient\CivilianPresence\defines.inc"

/*
	fn_CoreGetobjects.sqf
	Description: Returns linked objects

	Originally Developed by Bohemia interactive
*/

params
[
    ["_module", objNull, [objNull]],
    ["_objectType", "", [""]]
];

private
[
    "_objectsTemp"
];

if (_objectType == "") exitwith 
{
    []
};

private _objects = _module getVariable _objectType;

if (isNil {_objects}) then
{
    private _area = _module getVariable ["#area", []];
    
    if (count _area == 0) then 
	{
        _area = [getPos _module];
        _area append (_module getVariable ["objectarea", []]);
        
        _module setVariable ["#area", _area];
    };
    
    _objectsTemp = (entities [["Logic"], []]) inAreaArray _area;
    
    _objects = [];
    {
        if ((_x getVariable ["LogicType", ""]) == _objectType) then 
		{
            _objects pushBack _x;
        };
    } forEach _objectsTemp;
};

_module setVariable [_objectType, _objects];

_objects