--- Секция `Метки на земле` в настройках. Регистрирует настройки панели `FlareCharms`.


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
--- @param RIGHT string Имя правой подписи слайдеров (из SettingsControlMixin)
--- @param config table Параметры настройки: key, label, defaultValue, min, max, step, steps, precision, getter, setter
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
    o.formatters[RIGHT] = CreateSliderLabelFormatter(config.precision)
    local init = Settings.CreateSlider(category, s, o)
    init:SetParentInitializer(parentInit, function() return valueSetting:GetValue() end)
end

--- Строит список пресетов раскладки меток на земле для выпадающего списка
--- @param CUSTOM_LAYOUT string Значение пресета «своя раскладка»
--- @return table Данные для Settings.CreateDropdown
local function GetFlarePresetOptions(CUSTOM_LAYOUT)
    local container = Settings.CreateControlTextContainer()
    for _, v in ipairs(TC_DEFAULT_LAYOUTS_FLARE) do container:Add(v[2], v[1]) end
    container:Add(CUSTOM_LAYOUT, TARGETCHARMS_OPTIONS_CUSTOM_LAYOUT)
    return container:GetData()
end

--- Регистрирует выпадающий список пресетов раскладки меток на земле и скрывает его при выключенной панели
--- @param category table Категория настроек аддона
--- @param parentInit table Инициализатор-родитель (вложенность)
--- @param valueSetting table Настройка, значение которой управляет видимостью вложенных настроек
--- @param customLayoutMode table<string, boolean> Признаки ручного режима раскладки
--- @param CUSTOM_LAYOUT string Значение пресета «своя раскладка»
--- @param FindPresetPattern function Поиск шаблона среди пресетов
local function AddLayoutPresetDropdown(category, parentInit, valueSetting, customLayoutMode, CUSTOM_LAYOUT, FindPresetPattern)
    local s = Settings.RegisterProxySetting(
            category,
            "FL_PRESET",
            Settings.VarType.String,
            TARGETCHARMS_OPTIONS_PRESETS_TITLE,
            Defaults["FlareCharms"]["buttonTemplate"],
            function()
                return customLayoutMode["FlareCharms"] and CUSTOM_LAYOUT
                        or FindPresetPattern(TC_DEFAULT_LAYOUTS_FLARE, TargetCharms_Options["FlareCharms"]["buttonTemplate"])
                        or CUSTOM_LAYOUT
            end,
            function(v)
                if v == CUSTOM_LAYOUT then
                    customLayoutMode["FlareCharms"] = true
                else
                    customLayoutMode["FlareCharms"] = false
                    TargetCharms_Options["FlareCharms"]["buttonTemplate"] = v
                    SetupButtons("FlareCharms", "FlareCharms")
                end
            end
    )
    local init = Settings.CreateDropdown(category, s, function() return GetFlarePresetOptions(CUSTOM_LAYOUT) end)
    init:SetParentInitializer(parentInit, function() return valueSetting:GetValue() end)
end

--- Регистрирует поле ввода пользовательской раскладки меток на земле; показывается только в ручном режиме
--- @param category table Категория настроек аддона
--- @param layout table Вертикальная раскладка секции
--- @param parentInit table Инициализатор-родитель (вложенность)
--- @param valueSetting table Настройка, значение которой управляет видимостью вложенных настроек
--- @param customLayoutMode table<string, boolean> Признаки ручного режима раскладки
--- @param FindPresetPattern function Поиск шаблона среди пресетов
local function AddLayoutTemplateEditBox(category, layout, parentInit, valueSetting, customLayoutMode, FindPresetPattern)
    local s = Settings.RegisterProxySetting(
            category,
            "FL_TEMPLATE",
            Settings.VarType.String,
            TARGETCHARMS_OPTIONS_LAYOUT_TEXT,
            Defaults["FlareCharms"]["buttonTemplate"],
            function() return TargetCharms_Options["FlareCharms"]["buttonTemplate"] end,
            function(v)
                TargetCharms_Options["FlareCharms"]["buttonTemplate"] = v
                SetupButtons("FlareCharms", "FlareCharms")
            end
    )
    local init = Settings.CreateControlInitializer("TargetCharmsEditBoxControlTemplate", s)
    init:SetParentInitializer(parentInit, function() return valueSetting:GetValue() end)
    init:AddShownPredicate(function()
        return customLayoutMode["FlareCharms"]
                or not FindPresetPattern(TC_DEFAULT_LAYOUTS_FLARE, TargetCharms_Options["FlareCharms"]["buttonTemplate"])
    end)
    layout:AddInitializer(init)
end

--- Регистрирует всю секцию настроек панели меток на земле
--- @param category table Категория настроек аддона
--- @param layout table Вертикальная раскладка секции
--- @param RIGHT string Имя правой подписи слайдеров (из SettingsControlMixin)
--- @param customLayoutMode table<string, boolean> Признаки ручного режима раскладки
--- @param CUSTOM_LAYOUT string Значение пресета «своя раскладка»
--- @param FindPresetPattern function Поиск шаблона среди пресетов
function TargetCharms_RegisterFlareSettings(category, layout, RIGHT, customLayoutMode, CUSTOM_LAYOUT, FindPresetPattern)
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(TARGETCHARMS_OPTIONS_FLARE_TITLE))

    local flEnabledSetting = AddCheckbox(category, nil, nil, {
        key = "FL_ENABLED",
        label = TARGETCHARMS_OPTIONS_ENABLE,
        defaultValue = true,
        getter = function() return TargetCharms_Options["FlareCharms"]["enabled"] end,
        setter = function(v)
            TargetCharms_Options["FlareCharms"]["enabled"] = v;
            CheckFlareFrameViewState()
        end,
    })
    local flParent = CreateEnableGate(flEnabledSetting)

    AddCheckbox(category, flParent, flEnabledSetting, {
        key = "FL_DRAG",
        label = TARGETCHARMS_OPTIONS_DRAG,
        defaultValue = false,
        getter = function() return TargetCharms_Options["FlareCharms"]["draggable"] end,
        setter = function(v)
            TargetCharms_Options["FlareCharms"]["draggable"] = v;
            SetupButtons("FlareCharms", "FlareCharms")
        end,
    })

    AddCheckbox(category, flParent, flEnabledSetting, {
        key = "FL_PARTY",
        label = TARGETCHARMS_OPTIONS_PARTYONLY,
        defaultValue = false,
        getter = function() return TargetCharms_Options["FlareCharms"]["partyOnly"] end,
        setter = function(v)
            TargetCharms_Options["FlareCharms"]["partyOnly"] = v;
            CheckFlareFrameViewState()
        end,
    })

    AddCheckbox(category, flParent, flEnabledSetting, {
        key = "FL_ICONS",
        label = TARGETCHARMS_OPTIONS_SHOWICONS,
        defaultValue = true,
        getter = function() return TargetCharms_Options["FlareCharms"]["showicons"] end,
        setter = function(v)
            TargetCharms_Options["FlareCharms"]["showicons"] = v;
            SetupButtons("FlareCharms", "FlareCharms")
        end,
    })

    AddSlider(category, flParent, flEnabledSetting, RIGHT, {
        key = "FL_SCALE",
        label = TARGETCHARMS_OPTIONS_SCALE,
        defaultValue = 1.0,
        min = 0.5, max = 3.0, step = 0.1, steps = 25, precision = 0.1,
        getter = function() return TargetCharms_Options["FlareCharms"]["barscale"] end,
        setter = function(v)
            v = SnapSliderValue(v, 0.5, 3.0, 0.1);
            TargetCharms_Options["FlareCharms"]["barscale"] = v;
            SetFrameScale(v, 5)
        end,
    })

    AddSlider(category, flParent, flEnabledSetting, RIGHT, {
        key = "FL_OPACITY",
        label = TARGETCHARMS_OPTIONS_OPACITY,
        defaultValue = 0.5,
        min = 0.1, max = 1.0, step = 0.1, steps = 9, precision = 0.1,
        getter = function() return TargetCharms_Options["FlareCharms"]["alphaVal"] end,
        setter = function(v)
            v = SnapSliderValue(v, 0.1, 1.0, 0.1);
            TargetCharms_Options["FlareCharms"]["alphaVal"] = v;
            TopFlare:SetAlpha(v)
        end,
    })

    AddSlider(category, flParent, flEnabledSetting, RIGHT, {
        key = "FL_XSPACING",
        label = TARGETCHARMS_OPTIONS_XSPACING,
        defaultValue = 0,
        min = -20, max = 20, step = 1, steps = 40, precision = 1,
        getter = function() return TargetCharms_Options["FlareCharms"]["Xspacing"] end,
        setter = function(v)
            v = SnapSliderValue(v, -20, 20, 1);
            TargetCharms_Options["FlareCharms"]["Xspacing"] = v;
            SetupButtons("FlareCharms", "FlareCharms")
        end,
    })

    AddSlider(category, flParent, flEnabledSetting, RIGHT, {
        key = "FL_YSPACING",
        label = TARGETCHARMS_OPTIONS_YSPACING,
        defaultValue = 0,
        min = -20, max = 20, step = 1, steps = 40, precision = 1,
        getter = function() return TargetCharms_Options["FlareCharms"]["Yspacing"] end,
        setter = function(v)
            v = SnapSliderValue(v, -20, 20, 1);
            TargetCharms_Options["FlareCharms"]["Yspacing"] = v;
            SetupButtons("FlareCharms", "FlareCharms")
        end,
    })

    AddLayoutPresetDropdown(category, flParent, flEnabledSetting, customLayoutMode, CUSTOM_LAYOUT, FindPresetPattern)

    AddLayoutTemplateEditBox(category, layout, flParent, flEnabledSetting, customLayoutMode, FindPresetPattern)
end
