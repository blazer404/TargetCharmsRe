-- Constants

TARGETCHARMS_FRAME_NAMES = {
    "TargetCharms",
    "TopCharm",
    "ReadyCharm",
    "TopReady",
    "FlareCharms",
    "TopFlare",
};

TARGETCHARMS_TEXTURE_PATHS = {
    "interface\\targetingframe\\UI-RaidTargetingIcons.blp",
    "interface\\buttons\\UI-Quickslot.blp",
    "interface\\buttons\\UI-GroupLoot-Pass-Up.blp",
    "interface\\icons\\ability_hunter_snipershot.blp"
};

TargetCharms_LayoutDefaults = {
    { "Стандартный", ">8>7v6<5v4>3v2<1v_>0" },
    { "Инвертированный", ">0>1v2<3v4>5v6<7v_>8" },
    { "Горизонтальный", ">8>7>6>5>4>3>2>1>0" },
    { "Вертикальный", ">8v7v6v5v4v3v2v1v0" },
    { "3x3", ">8v7v6>5^4^3>2v1v0" }
};

Flare_LayoutDefaults = {
    { "Стандартный", ">D>W>RvB<SvG>PvO<Yv_>X" },
    { "Инвертированный", ">D>X>YvO<PvG>SvB<Rv_>W" },
    { "Горизонтальный", ">D>W>R>B>S>G>P>O>Y>X" },
    { "Вертикальный", ">D>WvRvBvSvGvPvOvYvX" },
    { "3x3", ">D>WvRvB>S^G^P>OvYvX" }
};
