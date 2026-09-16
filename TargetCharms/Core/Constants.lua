-- Constants
TARGETCHARMS_VERSION = C_AddOns.GetAddOnMetadata("TargetCharms", "Version");
TARGETCHARMS_DB_VERSION = "1.6.4";

TC_FRAME_NAMES = {
    "TargetCharms",
    "TopCharm",
    "ReadyCharm",
    "TopReady",
    "FlareCharms",
    "TopFlare",
};

TC_TEXTURE_PATHS = {
    "interface\\targetingframe\\UI-RaidTargetingIcons.blp",
    "interface\\buttons\\UI-Quickslot.blp",
    "interface\\buttons\\UI-GroupLoot-Pass-Up.blp",
    "interface\\icons\\ability_hunter_snipershot.blp"
};

TC_DEFAULT_LAYOUTS_CHARMS = {
    { "Стандартный", ">8>7v6<5v4>3v2<1v_>0" },
    { "Инвертированный", ">0>1v2<3v4>5v6<7v_>8" },
    { "Горизонтальный", ">8>7>6>5>4>3>2>1>0" },
    { "Вертикальный", ">8v7v6v5v4v3v2v1v0" },
    { "3x3", ">8v7v6>5^4^3>2v1v0" }
};

TC_DEFAULT_LAYOUTS_FLARE = {
    { "Стандартный", ">D>W>RvB<SvG>PvO<Yv_>X" },
    { "Инвертированный", ">D>X>YvO<PvG>SvB<Rv_>W" },
    { "Горизонтальный", ">D>W>R>B>S>G>P>O>Y>X" },
    { "Вертикальный", ">D>WvRvBvSvGvPvOvYvX" },
    { "3x3", ">D>WvRvB>S^G^P>OvYvX" }
};

TC_DEFAULTS = {
    ["TargetCharms"] = {
        ["X"] = nil,
        ["Y"] = nil,
        ["enabled"] = true,
        ["partyOnly"] = false,
        ["barscale"] = 1.0,
        ["Xspacing"] = 0,
        ["Yspacing"] = 0,
        ["draggable"] = true,
        ["toggleicon"] = false,
        ["alphaVal"] = 0.5,
        ["showontarget"] = true,
        ["buttonTemplate"] = TC_DEFAULT_LAYOUTS_CHARMS[1][2],
    },
    ["ReadyCharm"] = {
        ["X"] = nil,
        ["Y"] = nil,
        ["enabled"] = true,
        ["partyOnly"] = false,
        ["barscale"] = 1.0,
        ["draggable"] = true,
        ["alphaVal"] = 0.5,
        ["width"] = 60,
        ["text"] = TARGETCHARMS_READYCHECK_TEXT,
    },
    ["FlareCharms"] = {
        ["X"] = nil,
        ["Y"] = nil,
        ["enabled"] = true,
        ["partyOnly"] = false,
        ["barscale"] = 1.0,
        ["draggable"] = true,
        ["alphaVal"] = 0.5,
        ["Xspacing"] = 0,
        ["Yspacing"] = 0,
        ["showicons"] = false,
        ["buttonTemplate"] = TC_DEFAULT_LAYOUTS_FLARE[1][2],
    },
};

Defaults = TC_DEFAULTS;
