--- Глобальные `константы` аддона: версия, имена фреймов, пути к текстурам, раскладки панелей, настройки по умолчанию, etc


--- `Версия` аддона, прочитанная `из метаданных` .toc (поля ## Version)
TARGETCHARMS_VERSION = C_AddOns.GetAddOnMetadata("TargetCharms", "Version");

--- `Версия` структуры данных настроек (для `миграции` при обновлении)
TARGETCHARMS_DB_VERSION = "1.6.4";

--- Имена фреймов панелей.
--- Для каждой панели два фрейма: сама панель с кнопками (нечётный индекс)
--- и её контейнер Top* (чётный индекс), который как раз перетаскивается мышью.
--- * `1`=TargetCharms/`2`=TopCharm — метки цели
--- * `3`=ReadyCharm/`4`=TopReady — кнопка готовности
--- * `5`=FlareCharms/`6`=TopFlare — метки на земле
--- @type string[] Индексы 1,3,5 — панели; 2,4,6 — контейнеры Top*
TC_FRAME_NAMES = {
    "TargetCharms",
    "TopCharm",
    "ReadyCharm",
    "TopReady",
    "FlareCharms",
    "TopFlare",
};

--- Таблица путей к текстурам кнопок
--- * `1` — атлас иконок меток цели (UI-RaidTargetingIcons)
--- * `2` — базовый фон кнопок (UI-Quickslot)
--- * `3` — иконка очистки флажков
--- * `4` — запасная иконка для девятой метки
--- @type string[]
TC_TEXTURE_PATHS = {
    "interface\\targetingframe\\UI-RaidTargetingIcons.blp",
    "interface\\buttons\\UI-Quickslot.blp",
    "interface\\buttons\\UI-GroupLoot-Pass-Up.blp",
    "interface\\icons\\ability_hunter_snipershot.blp"
};

--- Строковые шаблоны раскладки кнопок панели меток цели
--- Коды:
--- *  `^`/`v`/`<`/`>` — направление роста
--- * `цифры` — номер иконки метки
--- * `_` — разделитель
--- @type table[] Пары { название, шаблон }
TC_DEFAULT_LAYOUTS_CHARMS = {
    { "Стандартный", ">8>7v6<5v4>3v2<1v_>0" },
    { "Инвертированный", ">0>1v2<3v4>5v6<7v_>8" },
    { "Горизонтальный", ">8>7>6>5>4>3>2>1>0" },
    { "Вертикальный", ">8v7v6v5v4v3v2v1v0" },
    { "3x3", ">8v7v6>5^4^3>2v1v0" }
};

--- То же для панели меток на земле: буквы — цвета флажков (`R`/`G`/`B`/`Y`/`etc`), `X` — очистка
--- @type table[] Пары { название, шаблон }
TC_DEFAULT_LAYOUTS_FLARE = {
    { "Стандартный", ">D>W>RvB<SvG>PvO<Yv_>X" },
    { "Инвертированный", ">D>X>YvO<PvG>SvB<Rv_>W" },
    { "Горизонтальный", ">D>W>R>B>S>G>P>O>Y>X" },
    { "Вертикальный", ">D>WvRvBvSvGvPvOvYvX" },
    { "3x3", ">D>WvRvB>S^G^P>OvYvX" }
};

--- Настройки по умолчанию для трёх панелей:
--- * метки цели
--- * кнопка готовности
--- * метки на земле
--- @type table Ключи — имена панелей из `TC_FRAME_NAMES` (без Top*)
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

--- Алиас Defaults дублирует `TC_DEFAULTS`.
--- Используйте `TC_DEFAULTS` напрямую!
Defaults = TC_DEFAULTS;
