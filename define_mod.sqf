btc_custom_loc = [
/*
    DESCRIPTION: [POS(Array),TYPE(String),NAME(String),RADIUS (Number),IS OCCUPIED(Bool)]
    Possible types: "NameVillage","NameCity","NameCityCapital","NameLocal","Hill","Airport","NameMarine", "StrongpointArea", "BorderCrossing", "VegetationFir"
    EXAMPLE: [[13132.8,3315.07,0.00128174],"NameVillage","Mountain 1",800,true]
*/
];

/*
    Here you can tweak spectator view during respawn screen.
*/
BIS_respSpecAi = false;                  // Allow spectating of AI
BIS_respSpecAllowFreeCamera = false;     // Allow moving the camera independent from units (players)
BIS_respSpecAllow3PPCamera = false;      // Allow 3rd person camera
BIS_respSpecShowFocus = false;           // Show info about the selected unit (dissapears behind the respawn UI)
BIS_respSpecShowCameraButtons = true;    // Show buttons for switching between free camera, 1st and 3rd person view (partially overlayed by respawn UI)
BIS_respSpecShowControlsHelper = true;   // Show the controls tutorial box
BIS_respSpecShowHeader = true;           // Top bar of the spectator UI including mission time
BIS_respSpecLists = true;                // Show list of available units and locations on the left hand side

/*
    Here you can specify which equipment should be added or removed from the arsenal.
    Please take care that there are different categories (weapons, magazines, items, backpacks) for different pieces of equipment into which you have to classify the classnames.
    In all cases, you need the classname of an object.

    Attention: The function of these lists depends on the setting in the mission parameter (Restrict arsenal).
        - "Full": here you have only the registered items in the arsenal available.
        - "Remove only": here all registered items are removed from the arsenal. This only works for the ACE3 arsenal!

    Example(s):
        private _weapons = [
            "arifle_MX_F",          //Classname for the rifle MX
            "arifle_MX_SW_F",       //Classname for the rifle MX LSW
            "arifle_MXC_F"          //Classname for the rifle MXC
        ];

        private _items = [
            "G_Shades_Black",
            "G_Shades_Blue",
            "G_Shades_Green"
        ];
*/
private _weapons = [
    "rhs_weap_M107",
    "rhs_weap_m16a4_imod_M203",
    "rhs_weap_XM2010",
    "rhs_weap_m24sws",
    "rhs_weap_m249_pip_S",
    "rhs_weap_m27iar_grip",
    "rhs_weap_m4a1",
    "rhs_weap_m4a1_m203s",
    "rhs_weap_M590_5RD",
    "rhsusf_weap_MP7A2",
    /* pistols */
    "rhsusf_weap_glock17g4",
    "rhsusf_weap_m1911a1",
    "rhsusf_weap_m9",
    /* launchers */
    "launch_NLAW_F",
    "rhs_weap_M136_hp",
    "rhs_weap_m72a7"
];
private _magazines = [
    /* nades */
    "SmokeShellGreen",
    "ACE_M84",
    "HandGrenade",
    /* explosives */
    "SatchelCharge_Remote_Mag",
    "ClaymoreDirectionalMine_Remote_Mag",
    /* */
    "ToolKit"
];
private _items = [
    /* uniformen */
    "rhs_uniform_cu_ucp",
    "U_B_FullGhillie_sard",
    "rhs_uniform_abu",
    "U_B_PilotCoveralls",
    /* vesten */
    "rhsusf_spcs_ucp_teamleader",
    "rhsusf_spcs_ucp_squadleader",
    "rhsusf_spcs_ucp_sniper",
    "rhsusf_spcs_ucp_saw",
    "rhsusf_spcs_ucp_rifleman",
    "rhsusf_spcs_ucp_rifleman_alt",
    "rhsusf_spcs_ucp_medic",
    "rhsusf_spcs_ucp_machinegunner",
    "rhsusf_spcs_ucp_grenadier",
    "rhsusf_spcs_ucp_crewman",
    /* helmets */
    "rhsusf_ach_helmet_ucp",
    "rhsusf_ach_helmet_ESS_ucp",
    "rhsusf_ach_helmet_headset_ucp",
    "rhsusf_ach_helmet_headset_ess_ucp",
    "rhsusf_cvc_ess",
    "rhs_Booniehat_ucp",
    "rhsusf_hgu56p_visor_green",
    "rhsusf_patrolcap_ucp",
    /* facewaear */
    "rhsusf_shemagh_gogg_tan",
    "rhsusf_shemagh2_gogg_tan",
    "rhsusf_shemagh_gogg_od",
    "rhsusf_shemagh2_gogg_od",
    "rhsusf_shemagh_od",
    "rhsusf_shemagh2_od",
    "rhsusf_shemagh_tan",
    "rhsusf_shemagh2_tan",
    "rhs_googles_black",
    "rhs_googles_clear",
    "G_Aviator",
    /* items */
    "B_UavTerminal",
    "rhsusf_bino_m24_ARD",
    "rhsusf_bino_leopold_mk4",
    "ACE_Vector"
];
private _backpacks = [
    "rhsusf_assault_eagleaiii_ucp",
    "B_UAV_01_backpack_F",
    "ACE_TacticalLadder_Pack",
    "ace_gunbag_Tan"
];

/* add all magazines, compatible items of whitelisted weapons */
{
    _magazines append (getArray (configfile >> "CfgWeapons" >> _x >> "magazines"));

    _weapon_muzzles = getArray (configFile >> "CfgWeapons" >> _x >> "muzzles");
    if (count _weapon_muzzles >= 2) then {
        _muzzle_class = _weapon_muzzles select 1;
        if !(isNil "_muzzle_class") then {
            _magazines append getArray (configFile >> "CfgWeapons" >> _x >> _muzzle_class >> "magazines")
        };
    };

    _items append ([_x] call CBA_fnc_compatibleItems);
} forEach _weapons;

/* add ace items */
{
    private _cnx = configName _x;
    if (_cnx isKindOf ["ACE_ItemCore", configFile >> "CfgWeapons"]) then {
        _items pushBackUnique _cnx;
    };
} forEach (configProperties [configFile >> "CfgWeapons", "isClass _x", true]);

btc_custom_arsenal = [_weapons, _magazines, _items, _backpacks];

/*
    Here you can specify which equipment is loaded on player connection.
*/

private _radio = ["TFAR_anprc152", "ACRE_PRC148"] select (isClass(configFile >> "cfgPatches" >> "acre_main"));
//Array of colored item: 0 - Desert, 1 - Tropic, 2 - Black, 3 - forest
private _uniforms = ["rhs_uniform_cu_ucp", "rhs_uniform_cu_ucp", "rhs_uniform_cu_ucp", "rhs_uniform_cu_ucp"];
private _uniformsCBRN = ["rhs_uniform_cu_ucp", "rhs_uniform_cu_ucp", "rhs_uniform_cu_ucp", "rhs_uniform_cu_ucp"];
private _uniformsSniper = ["rhs_uniform_cu_ucp", "rhs_uniform_cu_ucp", "rhs_uniform_cu_ucp", "rhs_uniform_cu_ucp"];
private _vests = ["rhsusf_spcs_ucp", "rhsusf_spcs_ucp", "rhsusf_spcs_ucp", "rhsusf_spcs_ucp"];
private _helmets = ["rhsusf_patrolcap_ucp", "rhsusf_patrolcap_ucp", "rhsusf_patrolcap_ucp", "rhsusf_patrolcap_ucp"];
private _hoods = ["", "", "", ""];
private _hoodCBRN = "";
private _laserdesignators = ["rhsusf_bino_m24_ARD", "rhsusf_bino_m24_ARD", "rhsusf_bino_m24_ARD", "rhsusf_bino_m24_ARD"];
private _night_visions = ["", "", "", ""];
private _weapons = ["", "", "", ""];
private _weapons_machineGunner = ["", "", "", ""];
private _weapons_sniper = ["", "", "", ""];
private _bipods = ["", "", "", ""];
private _pistols = ["rhsusf_weap_glock17g4", "rhsusf_weap_glock17g4", "rhsusf_weap_glock17g4", "rhsusf_weap_glock17g4"];
private _launcher_AT = ["", "", "", ""];
private _launcher_AA = ["", "", "", ""];
private _backpacks = ["", "", "", ""];
private _backpacks_big = ["", "", "", ""];
private _backpackCBRN = "";

btc_arsenal_loadout = [_uniforms, _uniformsCBRN, _uniformsSniper, _vests, _helmets, _hoods, [_hoodCBRN, _hoodCBRN, _hoodCBRN, _hoodCBRN], _laserdesignators, _night_visions, _weapons, _weapons_sniper, _weapons_machineGunner, _bipods, _pistols, _launcher_AT, _launcher_AA, _backpacks, _backpacks_big, [_backpackCBRN, _backpackCBRN, _backpackCBRN, _backpackCBRN], [_radio, _radio, _radio, _radio]];
