/**
	@namespace RS
	@class Headless
	@method RS_fnc_TransferOwnershipToHeadless
	@file fn_TransferOwnershipToHeadless.sqf
	@summary Transfers ownership of given objects to the Headless client if the Headless client is present
	
	@param array _arrayOfObjects List of units to transfer
	
	@note ```[unit_1] call RS_fnc_TransferOwnershipToHeadless;```
**/

/*
	Name:			fn_TransferOwnershipToHeadless.sqf
	Description:	Transfers ownership of given objects to the Headless client if the Headless client is present
	How to Call:	
		_arrayOfObjects call RS_fnc_TransferOwnershipToHeadless;
	Example:
		[unit_1] call RS_fnc_TransferOwnershipToHeadless;
*/

_objects = _this;

// Test if the Headless Client is present
_headlessPresent = false;
if (!isNil "HC1") then
{
	_headlessPresent = isPlayer HC1;
};

// If the headless client is present, transfer the given object to the headless
if (_headlessPresent) then
{
	_clientID = owner HC1;
	
	{
		_object = _x;
		if ((groupOwner (group _object)) != _clientID) then
		{
			_transfered = (group _object) setGroupOwner _clientID;
			
			if !(_transfered) then
			{
				["TransferOwnershipToHeadless", 1, (format ["Failed to transfer object %1 to the Headless client", _object])] call RS_fnc_LoggingHelper;
			};
		};
	} forEach _objects;
};