--- Секция `Метки цели` в настройках. Регистрирует настройки панели `TargetCharms`


--- Создаёт `родителя` для вложенных настроек — они показываются только при включённой панели
--- @param setting table Настройка-галочка «включено»
--- @return table Инициализатор родителя
local function CreateEnableGate(setting)
    return Settings.CreateControlInitializer("SettingsCheckboxControlTemplate", setting)
end

--- Регистрирует настройку-галочку и, если передан родитель, скрывает её при выключенной панели
--- @param category table Категория настроек аддона
--- @param parentInit table|nil Инициализатор-родитель (вложенность); nil для корневой настройки
--- @param valueSetting table|nil Настройка, значение которой управляет видимостью вложенных настроек
--- @param config table Параметры настройки: key, label, defaultValue, getter, setter
--- @return table Зарегистрированная настройка
local function AddCheckbox(category, parentInit, valueSetting, config)
    local s = Settings.RegisterProxySetting(
            category,
            config.key,
            Settings.VarType.Boolean,
            config.label,
            config.defaultValue,
            config.getter,
            config.setter
    )
    local init = Settings.CreateCheckbox(category, s)
    if parentInit then
        init:SetParentInitializer(parentInit, function() return valueSetting:GetValue() end)
    end
    return s
end

--- Регистрирует настройку-слайдер и скрывает её при выключенной панели
--- @param category table Категория настроек аддона
--- @param parentInit table Инициализатор-родитель (вложенность)
--- @param valueSetting table Настройка, значение которой управляет видимостью вложенных настроек
--- @param RIGHT string Имя правой подписи слайдера (из SettingsControlMixin)
--- @param config table Параметры настройки: key, label, defaultValue, min, max, step, steps, labelPrecision, getter, setter
--- @return table Зарегистрированная настройка
local function AddSlider(category, parentInit, valueSetting, RIGHT, config)
    local s = Settings.RegisterProxySetting(
            category,
            config.key,
            Settings.VarType.Number,
            config.label,
            config.defaultValue,
            config.getter,
            config.setter
    )
    local o = Settings.CreateSliderOptions(config.min, config.max, config.step)
    o.steps = config.steps
    o:SetLabelFormatter(RIGHT)
    o.formatters[RIGHT] = CreateSliderLabelFormatter(config.labelPrecision)
    local init = Settings.CreateSlider(category, s, o)
    init:SetParentInitializer(parentInit, function() return valueSetting:GetValue() end)
    return s
end

--- Строит список пресетов раскладки меток цели для выпадающего списка
--- @param presets table Список пресетов: {имя, шаблон}
--- @param CUSTOM_LAYOUT string Значение пресета «своя раскладка»
--- @return table Данные для Settings.CreateDropdown
local function GetTargetPresetOptions(presets, CUSTOM_LAYOUT)
    local container = Settings.CreateControlTextContainer()
    for _, v in ipairs(presets) do
        container:Add(v[2], v[1])
    end
    container:Add(CUSTOM_LAYOUT, TARGETCHARMS_OPTIONS_CUSTOM_LAYOUT)
    return container:GetData()
end

--- Регистрирует выпадающий список пресетов раскладки меток цели и скрывает его при выключенной панели
--- @param category table Категория настроек аддона
--- @param parentInit table Инициализатор-родитель (вложенность)
--- @param valueSetting table Настройка, значение которой управляет видимостью вложенных настроек
--- @param customLayoutMode table<string, boolean> Признаки ручного режима раскладки
--- @param CUSTOM_LAYOUT string Значение пресета «своя раскладка»
--- @param FindPresetPattern function Поиск шаблона среди пресетов
--- @param presets table Список пресетов: {имя, шаблон}
local function AddLayoutPresetDropdown(category, parentInit, valueSetting, customLayoutMode, CUSTOM_LAYOUT, FindPresetPattern, presets)
    local s = Settings.RegisterProxySetting(
            category,
            "TC_PRESET",
            Settings.VarType.String,
            TARGETCHARMS_OPTIONS_PRESETS_TITLE,
            Defaults["TargetCharms"]["buttonTemplate"],
            function()
                return customLayoutMode["TargetCharms"] and CUSTOM_LAYOUT
                        or FindPresetPattern(presets, TargetCharms_Options["TargetCharms"]["buttonTemplate"])
                        or CUSTOM_LAYOUT
            end,
            function(v)
                if v == CUSTOM_LAYOUT then
                    customLayoutMode["TargetCharms"] = true
                else
                    customLayoutMode["TargetCharms"] = false
                    TargetCharms_Options["TargetCharms"]["buttonTemplate"] = v
                    SetupButtons("TargetCharms", "TargetCharms")
                end
            end
    )
    local init = Settings.CreateDropdown(category, s, function() return GetTargetPresetOptions(presets, CUSTOM_LAYOUT) end)
    init:SetParentInitializer(parentInit, function() return valueSetting:GetValue() end)
end

--- Регистрирует поле ввода пользовательской раскладки меток цели; показывается только в ручном режиме
--- @param category table Категория настроек аддона
--- @param layout table Вертикальная раскладка секции
--- @param parentInit table Инициализатор-родитель (вложенность)
--- @param valueSetting table Настройка, значение которой управляет видимостью вложенных настроек
--- @param customLayoutMode table<string, boolean> Признаки ручного режима раскладки
--- @param FindPresetPattern function Поиск шаблона среди пресетов
--- @param presets table Список пресетов: {имя, шаблон}
local function AddLayoutTemplateEditBox(category, layout, parentInit, valueSetting, customLayoutMode, FindPresetPattern, presets)
    local s = Settings.RegisterProxySetting(
            category,
            "TC_TEMPLATE",
            Settings.VarType.String,
            TARGETCHARMS_OPTIONS_LAYOUT_TEXT,
            Defaults["TargetCharms"]["buttonTemplate"],
            function() return TargetCharms_Options["TargetCharms"]["buttonTemplate"] end,
            function(v)
                TargetCharms_Options["TargetCharms"]["buttonTemplate"] = v
                SetupButtons("TargetCharms", "TargetCharms")
            end
    )
    local init = Settings.CreateControlInitializer("TargetCharmsEditBoxControlTemplate", s)
    init:SetParentInitializer(parentInit, function() return valueSetting:GetValue() end)
    init:AddShownPredicate(function()
        return customLayoutMode["TargetCharms"]
                or not FindPresetPattern(presets, TargetCharms_Options["TargetCharms"]["buttonTemplate"])
    end)
    layout:AddInitializer(init)
end

--- Регистрирует всю секцию настроек панели меток цели
--- @param category table Категория настроек аддона
--- @param layout table Вертикальная раскладка секции
--- @param RIGHT string Имя правой подписи слайдеров (из SettingsControlMixin)
--- @param customLayoutMode table<string, boolean> Признаки ручного режима раскладки
--- @param CUSTOM_LAYOUT string Значение пресета «своя раскладка»
--- @param FindPresetPattern function Поиск шаблона среди пресетов
function TargetCharms_RegisterTargetSettings(category, layout, RIGHT, customLayoutMode, CUSTOM_LAYOUT, FindPresetPattern)
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(TARGETCHARMS_OPTIONS_TITLE))

    local tcEnabledSetting = AddCheckbox(category, nil, nil, {
        key = "TC_ENABLED",
        label = TARGETCHARMS_OPTIONS_ENABLE,
        defaultValue = true,
        getter = function() return TargetCharms_Options["TargetCharms"]["enabled"] end,
        setter = function(v)
            TargetCharms_Options["TargetCharms"]["enabled"] = v;
            CheckFrameViewState()
        end,
    })
    local tcParent = CreateEnableGate(tcEnabledSetting)

    AddCheckbox(category, tcParent, tcEnabledSetting, {
        key = "TC_DRAG",
        label = TARGETCHARMS_OPTIONS_DRAG,
        defaultValue = false,
        getter = function() return TargetCharms_Options["TargetCharms"]["draggable"] end,
        setter = function(v) TargetCharms_Options["TargetCharms"]["draggable"] = v end,
    })

    AddCheckbox(category, tcParent, tcEnabledSetting, {
        key = "TC_PARTY",
        label = TARGETCHARMS_OPTIONS_PARTYONLY,
        defaultValue = false,
        getter = function() return TargetCharms_Options["TargetCharms"]["partyOnly"] end,
        setter = function(v)
            TargetCharms_Options["TargetCharms"]["partyOnly"] = v;
            CheckFrameViewState()
        end,
    })

    AddCheckbox(category, tcParent, tcEnabledSetting, {
        key = "TC_SHOWTARGET",
        label = TARGETCHARMS_OPTIONS_SHOWONTARGET,
        defaultValue = true,
        getter = function() return TargetCharms_Options["TargetCharms"]["showontarget"] end,
        setter = function(v)
            TargetCharms_Options["TargetCharms"]["showontarget"] = v;
            SetTargetHideShow()
        end,
    })

    AddCheckbox(category, tcParent, tcEnabledSetting, {
        key = "TC_TOGGLE",
        label = TARGETCHARMS_OPTIONS_TOGGLEICON,
        defaultValue = false,
        getter = function() return TargetCharms_Options["TargetCharms"]["toggleicon"] end,
        setter = function(v) TargetCharms_Options["TargetCharms"]["toggleicon"] = v end,
    })

    AddSlider(category, tcParent, tcEnabledSetting, RIGHT, {
        key = "TC_SCALE",
        label = TARGETCHARMS_OPTIONS_SCALE,
        defaultValue = 1.0,
        min = 0.5,
        max = 3.0,
        step = 0.1,
        steps = 25,
        labelPrecision = 0.1,
        getter = function() return TargetCharms_Options["TargetCharms"]["barscale"] end,
        setter = function(v)
            v = SnapSliderValue(v, 0.5, 3.0, 0.1);
            TargetCharms_Options["TargetCharms"]["barscale"] = v;
            SetFrameScale(v, 1)
        end,
    })

    AddSlider(category, tcParent, tcEnabledSetting, RIGHT, {
        key = "TC_OPACITY",
        label = TARGETCHARMS_OPTIONS_OPACITY,
        defaultValue = 0.5,
        min = 0.1,
        max = 1.0,
        step = 0.1,
        steps = 9,
        labelPrecision = 0.1,
        getter = function() return TargetCharms_Options["TargetCharms"]["alphaVal"] end,
        setter = function(v)
            v = SnapSliderValue(v, 0.1, 1.0, 0.1);
            TargetCharms_Options["TargetCharms"]["alphaVal"] = v;
            TopCharm:SetAlpha(v)
        end,
    })

    AddSlider(category, tcParent, tcEnabledSetting, RIGHT, {
        key = "TC_XSPACING",
        label = TARGETCHARMS_OPTIONS_XSPACING,
        defaultValue = 0,
        min = -20,
        max = 20,
        step = 1,
        steps = 40,
        labelPrecision = 1,
        getter = function() return TargetCharms_Options["TargetCharms"]["Xspacing"] end,
        setter = function(v)
            v = SnapSliderValue(v, -20, 20, 1);
            TargetCharms_Options["TargetCharms"]["Xspacing"] = v;
            SetupButtons("TargetCharms", "TargetCharms")
        end,
    })

    AddSlider(category, tcParent, tcEnabledSetting, RIGHT, {
        key = "TC_YSPACING",
        label = TARGETCHARMS_OPTIONS_YSPACING,
        defaultValue = 0,
        min = -20,
        max = 20,
        step = 1,
        steps = 40,
        labelPrecision = 1,
        getter = function() return TargetCharms_Options["TargetCharms"]["Yspacing"] end,
        setter = function(v)
            v = SnapSliderValue(v, -20, 20, 1);
            TargetCharms_Options["TargetCharms"]["Yspacing"] = v;
            SetupButtons("TargetCharms", "TargetCharms")
        end,
    })

    AddLayoutPresetDropdown(category, tcParent, tcEnabledSetting, customLayoutMode, CUSTOM_LAYOUT, FindPresetPattern, TC_DEFAULT_LAYOUTS_CHARMS)

    AddLayoutTemplateEditBox(category, layout, tcParent, tcEnabledSetting, customLayoutMode, FindPresetPattern, TC_DEFAULT_LAYOUTS_CHARMS)
end
