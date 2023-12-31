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
TargetCharms_CMDS = {"reset", "setup"};

TargetCharms_LayoutDefaults = {
	{"Стандартный", ">1>5v6<2v3>7v8<4v_>0"},
	{"Инвертированный",">4>8v7<3v2>6v5<1v_>0"},
	{"Горизонтальный",">1>2>3>4>5>6>7>8>0"},
	{"Вертикальный",">1v2v3v4v5v6v7v8v0"},
	{"3x3",">1v2v3>6^5^4>7v8v0"}
};

Flare_LayoutDefaults = {
	{"Стандартный", ">D>XVW<RvB>SvP<GvO>Y"},
	{"3x3",">D>R>W>SvB<G<PvO>Y>X"},
	{"Горизонтальный",">D>R>W>S>B>G>P>O>Y>X"},
	{"Вертикальный",">DvRvWvSvBvGvPvOvYvX"},
	{"Классический",">DVY>SVB<OVP>RVW<GV_>X"}
};
				
