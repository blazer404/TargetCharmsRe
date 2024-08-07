--LOCALES: ruRU, enUS

local G_LOCALE = GetLocale();
if G_LOCALE == "ruRU" then
    TARGETCHARMS_TITLE = "TargetCharms";
    TARGETCHARMS_OPTIONS_ENABLE = "Включено";
    TARGETCHARMS_OPTIONS_PARTYONLY = "Только в группе/рейде";
    TARGETCHARMS_OPTIONS_TITLE = "Метки цели";
    TARGETCHARMS_OPTIONS_LAYOUT_TEXT = "Настроить:";
    TARGETCHARMS_OPTIONS_DRAG = "Перетаскивать";
    TARGETCHARMS_OPTIONS_SHOWONTARGET = "Только при выделении цели";
    TARGETCHARMS_OPTIONS_TOGGLEICON = "Кнопки для переключения";
    TARGETCHARMS_OPTIONS_SHOWICONS = "Показывать значки";
    TARGETCHARMS_OPTIONS_SCALE = "Масштаб";
    TARGETCHARMS_OPTIONS_OPACITY = "Прозрачность";
    TARGETCHARMS_OPTIONS_XSPACING = "Интервал по X";
    TARGETCHARMS_OPTIONS_YSPACING = "Интервал по Y";
    TARGETCHARMS_OPTIONS_SHOW_TITLE = "Отображение:";
    TARGETCHARMS_OPTIONS_CLOSE_BUTTON = "Закрыть";
    TARGETCHARMS_OPTIONS_MAIN_PROFILE = "Установить как основной профиль для копирования"
    TARGETCHARMS_OPTIONS_COPY_BUTTON = "Скопировать настройки из ";
    TARGETCHARMS_OPTIONS_PRESETS_TITLE = "Макет:";
    TARGETCHARMS_OPTIONS_READYCHECK_TITLE = "Кнопка готовности";
    TARGETCHARMS_OPTIONS_READYCHECK_TEXT = "Текст:";
    TARGETCHARMS_OPTIONS_FLARE_TITLE = "Метки на полу";
    TARGETCHARMS_OPTIONS_WIDTH = "Ширина";
    TARGETCHARMS_OPTIONS_PROFILE = "Профиль";
    TARGETCHARMS_PANEL_SHOW = "Показать настройки";
    TARGETCHARMS_PANEL_RESET = "Сбросить аддон";
    TARGETCHARMS_READYCHECK_TEXT = "Готовы?";
    TARGETCHARMS_MSG_TAG = "TargetCharms: ";
    TARGETCHARMS_CMD_HELP = "/TargetCharms [Reset|Setup]";
    TARGETCHARMS_SLASH1 = "/targetcharms";
    TARGETCHARMS_SLASH2 = "/tc";
    TARGETCHARMS_LOADED = "Загружен";
    TARGETCHARMS_ERROR_INVALIDCHAR = "Некорректный символ позиции";
    TARGETCHARMS_OPTIONS_RESET = "Позиции и значения сброшены";

    --Positions & Charms
    TARGETCHARMS_POSITION_UP = "^";
    TARGETCHARMS_POSITION_DOWN = "v";
    TARGETCHARMS_POSITION_LEFT = "<";
    TARGETCHARMS_POSITION_RIGHT = ">";
    TARGETCHARMS_CHARM1 = "1";
    TARGETCHARMS_CHARM2 = "2";
    TARGETCHARMS_CHARM3 = "3";
    TARGETCHARMS_CHARM4 = "4";
    TARGETCHARMS_CHARM5 = "5";
    TARGETCHARMS_CHARM6 = "6";
    TARGETCHARMS_CHARM7 = "7";
    TARGETCHARMS_CHARM8 = "8";
    TARGETCHARMS_CHARM9 = "9"; --Not currently used
    TARGETCHARMS_CHARM0 = "0";

    TARGETCHARMS_BLUEFLARE = "B";
    TARGETCHARMS_GREENFLARE = "G";
    TARGETCHARMS_PURPLEFLARE = "P";
    TARGETCHARMS_REDFLARE = "R";
    TARGETCHARMS_YELLOWFLARE = "Y";
    TARGETCHARMS_WHITEFLARE = "W";
    TARGETCHARMS_SILVERFLARE = "S";
    TARGETCHARMS_ORANGEFLARE = "O";
    TARGETCHARMS_DRAG = "D";
    TARGETCHARMS_CLEARFLARE = "X";

    --Lower case on CMDs
    TargetCharms_CMDS = { "reset", "setup" };

    TargetCharms_LayoutDefaults = {
        { "Стандартный", ">1>5v6<2v3>7v8<4v_>0" },
        { "Инвертированный", ">4>8v7<3v2>6v5<1v_>0" },
        { "Горизонтальный", ">1>2>3>4>5>6>7>8>0" },
        { "Вертикальный", ">1v2v3v4v5v6v7v8v0" },
        { "3x3", ">1v2v3>6^5^4>7v8v0" }
    };

    Flare_LayoutDefaults = {
        { "Стандартный", ">D>XVW<RvB>SvP<GvO>Y" },
        { "3x3", ">D>R>W>SvB<G<PvO>Y>X" },
        { "Горизонтальный", ">D>R>W>S>B>G>P>O>Y>X" },
        { "Вертикальный", ">DvRvWvSvBvGvPvOvYvX" },
        { "Классический", ">DVY>SVB<OVP>RVW<GV_>X" }
    };
else
    TARGETCHARMS_TITLE = "TargetCharms";

    TARGETCHARMS_OPTIONS_ENABLE = "Enabled";
    TARGETCHARMS_OPTIONS_PARTYONLY = "Show only in Party/Raid";
    TARGETCHARMS_OPTIONS_TITLE = "TargetCharms";
    TARGETCHARMS_OPTIONS_LAYOUT_TEXT = "Customize:";
    TARGETCHARMS_OPTIONS_DRAG = "Draggable";
    TARGETCHARMS_OPTIONS_SHOWONTARGET = "Show only while Targeting";
    TARGETCHARMS_OPTIONS_TOGGLEICON = "Togglable Buttons";
    TARGETCHARMS_OPTIONS_SHOWICONS = "Show Icons";
    TARGETCHARMS_OPTIONS_SCALE = "Scale";
    TARGETCHARMS_OPTIONS_OPACITY = "Opacity";
    TARGETCHARMS_OPTIONS_XSPACING = "X Spacing";
    TARGETCHARMS_OPTIONS_YSPACING = "Y Spacing";
    TARGETCHARMS_OPTIONS_SHOW_TITLE = "Display:";
    TARGETCHARMS_OPTIONS_CLOSE_BUTTON = "Close";
    TARGETCHARMS_OPTIONS_MAIN_PROFILE = "Set As Main Profile To Copy"
    TARGETCHARMS_OPTIONS_COPY_BUTTON = "Copy Settings From ";
    TARGETCHARMS_OPTIONS_PRESETS_TITLE = "Preset Layouts:";
    TARGETCHARMS_OPTIONS_READYCHECK_TITLE = "Ready Button";
    TARGETCHARMS_OPTIONS_READYCHECK_TEXT = "Text:";
    TARGETCHARMS_OPTIONS_FLARE_TITLE = "World Markers";
    TARGETCHARMS_OPTIONS_WIDTH = "Width";
    TARGETCHARMS_OPTIONS_PROFILE = "Profile";
    TARGETCHARMS_PANEL_SHOW = "Show Setup";
    TARGETCHARMS_PANEL_RESET = "Reset Addon";
    TARGETCHARMS_OPTIONS_RESET = "Position and Values Reset";

    TARGETCHARMS_READYCHECK_TEXT = "Ready?";
    TARGETCHARMS_MSG_TAG = "TargetCharms: ";
    TARGETCHARMS_CMD_HELP = "/TargetCharms [Reset|Setup]";
    TARGETCHARMS_SLASH1 = "/targetcharms";
    TARGETCHARMS_SLASH2 = "/tc";
    TARGETCHARMS_LOADED = "Loaded";
    TARGETCHARMS_ERROR_INVALIDCHAR = "Invalid Position Character";

    --Positions & Charms
    TARGETCHARMS_POSITION_UP = "^";
    TARGETCHARMS_POSITION_DOWN = "v";
    TARGETCHARMS_POSITION_LEFT = "<";
    TARGETCHARMS_POSITION_RIGHT = ">";
    TARGETCHARMS_CHARM1 = "1";
    TARGETCHARMS_CHARM2 = "2";
    TARGETCHARMS_CHARM3 = "3";
    TARGETCHARMS_CHARM4 = "4";
    TARGETCHARMS_CHARM5 = "5";
    TARGETCHARMS_CHARM6 = "6";
    TARGETCHARMS_CHARM7 = "7";
    TARGETCHARMS_CHARM8 = "8";
    TARGETCHARMS_CHARM9 = "9"; --Not currently used
    TARGETCHARMS_CHARM0 = "0";

    TARGETCHARMS_BLUEFLARE = "B";
    TARGETCHARMS_GREENFLARE = "G";
    TARGETCHARMS_PURPLEFLARE = "P";
    TARGETCHARMS_REDFLARE = "R";
    TARGETCHARMS_YELLOWFLARE = "Y";
    TARGETCHARMS_WHITEFLARE = "W";
    TARGETCHARMS_SILVERFLARE = "S";
    TARGETCHARMS_ORANGEFLARE = "O";
    TARGETCHARMS_DRAG = "D";
    TARGETCHARMS_CLEARFLARE = "X";

    --Lower case on CMDs
    TargetCharms_CMDS = { "reset", "setup" };

    TargetCharms_LayoutDefaults = {
        { "Standard", ">1>5v6<2v3>7v8<4v_>0" },
        { "Inverted", ">4>8v7<3v2>6v5<1v_>0" },
        { "Horizontal", ">1>2>3>4>5>6>7>8>0" },
        { "Vertical", ">1v2v3v4v5v6v7v8v0" },
        { "3x3", ">1v2v3>6^5^4>7v8v0" }
    };

    Flare_LayoutDefaults = {
        { "Standard", ">D>XVW<RvB>SvP<GvO>Y" },
        { "3x3", ">D>R>W>SvB<G<PvO>Y>X" },
        { "Horizontal", ">D>R>W>S>B>G>P>O>Y>X" },
        { "Vertical", ">DvRvWvSvBvGvPvOvYvX" },
        { "Classic", ">DVY>SVB<OVP>RVW<GV_>X" }
    };
end
