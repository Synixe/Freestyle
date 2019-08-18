// Register freestyle modules
["Synixe Freestyle", "Spawn Location", {
	params ["_location", ""];
	missionNamespace setVariable ["SFS_SPAWN_POS", _location, true];
}] call zen_custom_modules_fnc_register;

if (side player != sideLogic) then {
	// Start as spectator, wait for spawn location
	[{time > 0 && !(isNull player)}, {
		player setPosASL [0,0,5];
		player enableSimulation false;
		[true] call ace_spectator_fnc_setSpectator;

		SFS_SPAWN_PFH = [{
			if !((missionNamespace getVariable ["SFS_SPAWN_POS", []]) isEqualTo []) then {
				[player, SFS_SPAWN_POS, true] call BIS_fnc_moveToRespawnPosition;
				player enableSimulation true;
				[false] call ace_spectator_fnc_setSpectator;
				[SFS_SPAWN_PFH] call CBA_fnc_removePerFrameHandler;
				SFS_SPAWN_PFH = nil;
			};
		}, 1] call CBA_fnc_addPerFrameHandler;
	}] call CBA_fnc_waitUntilAndExecute;
};
