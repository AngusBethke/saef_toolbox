/**
	@namespace RS_Rift
	@class TheRift
	@method RS_Rift_fnc_CreateRiftInteractionCamera
	@file fn_CreateRiftInteractionCamera.sqf
	@summary Creates a camera and links screens to that camera

	@param object _object
	@param array _objects
	@param object _focusObject
	@param object _cam

	@usage ```[_object, _objects, _focusObject] call RS_Rift_fnc_CreateRiftInteractionCamera;```
**/

/*
	fn_CreateRiftInteractionCamera.sqf
	Description: Creates a camera and links screens to that camera
	[_object, _objects, _focusObject] call RS_Rift_fnc_CreateRiftInteractionCamera;
*/

private
[
	"_object"
	,"_objects"
	,"_focusObject"
	,"_cam"
];

_object = _this select 0;
_objects = _this select 1;
_focusObject = _this select 2;
_cameraNum = missionNamespace getVariable ["RS_Rift_CameraIterations", 0];
missionNamespace setVariable ["RS_Rift_CameraIterations", (_cameraNum + 1), true];
_cameraName = format ["rendertarget%1_rift", _cameraNum];

// Create the Camera
_cam = "camera" camCreate [(getpos _object) select 0, (getpos _object) select 1, ((getpos _object) select 2) + 1];
_cam camSetFov 0.6;
_cam camSetTarget _focusObject; 
_cam camCommit 2;
_cameraName setPiPEffect [3, 1, 0.6, 1.2, 0, [0, 0, 0, 0], [0.1, 0.1, 0.9, 0.8], [0.299, 0.587, 0.114, 0]];
_cam cameraEffect ["INTERNAL", "BACK",_cameraName];

{
	_obj = _x;
	_obj setObjectTexture [0, format["#(argb,256,256,1)r2t(%1,1.0)", _cameraName]];
} forEach _objects;
