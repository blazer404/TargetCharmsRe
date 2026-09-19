--- Секция `Кнопка готовности` в настройках. Регистрирует настройки кнопки `ReadyCharm`.


--- Создаёт `родителя` для вложенных настроек — они показываются только при включённой панели
--- @param setting table Настройка-галочка `включено`
--- @return table Инициализатор родителя
local function CreateEnableGate(setting)
    return Settings.CreateControlInitializer("SettingsCheckboxControlTemplate", setting)
end

--- Регистрирует настройку-галочку и, если передан родитель, скрывает её при выключенной кнопке
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

--- Регистрирует настройку-слайдер и скрывает её при выключенной кнопке
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

--- Регистрирует поле ввода текста кнопки готовности; скрывается при выключенной кнопке
--- @param category table Категория настроек аддона
--- @param layout table Вертикальная раскладка секции
--- @param parentInit table Инициализатор-родитель (вложенность)
--- @param valueSetting table Настройка, значение которой управляет видимостью вложенных настроек
--- @param config table Параметры настройки: key, label, defaultValue, getter, setter
local function AddTextEditBox(category, layout, parentInit, valueSetting, config)
    local s = Settings.RegisterProxySetting(
            category,
            config.key,
            Settings.VarType.String,
            config.label,
            config.defaultValue,
            config.getter,
            config.setter
    )
    local init = Settings.CreateControlInitializer("TargetCharmsEditBoxControlTemplate", s)
    init:SetParentInitializer(parentInit, function() return valueSetting:GetValue() end)
    layout:AddInitializer(init)
end

--- Регистрирует всю секцию настроек кнопки готовности
--- @param category table Категория настроек аддона
--- @param layout table Вертикальная раскладка секции
--- @param RIGHT string Имя правой подписи слайдеров (из SettingsControlMixin)
function TargetCharms_RegisterReadySettings(category, layout, RIGHT)
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(TARGETCHARMS_OPTIONS_READYCHECK_TITLE))

    local rcEnabledSetting = AddCheckbox(category, nil, nil, {
        key = "RC_ENABLED",
        label = TARGETCHARMS_OPTIONS_ENABLE,
        defaultValue = true,
        getter = function() return TargetCharms_Options["ReadyCharm"]["enabled"] end,
        setter = function(v)
            TargetCharms_Options["ReadyCharm"]["enabled"] = v;
            CheckReadyButtonViewState()
        end,
    })
    local rcParent = CreateEnableGate(rcEnabledSetting)

    AddCheckbox(category, rcParent, rcEnabledSetting, {
        key = "RC_DRAG",
        label = TARGETCHARMS_OPTIONS_DRAG,
        defaultValue = false,
        getter = function() return TargetCharms_Options["ReadyCharm"]["draggable"] end,
        setter = function(v) TargetCharms_Options["ReadyCharm"]["draggable"] = v end,
    })

    AddCheckbox(category, rcParent, rcEnabledSetting, {
        key = "RC_PARTY",
        label = TARGETCHARMS_OPTIONS_PARTYONLY,
        defaultValue = false,
        getter = function() return TargetCharms_Options["ReadyCharm"]["partyOnly"] end,
        setter = function(v)
            TargetCharms_Options["ReadyCharm"]["partyOnly"] = v;
            CheckReadyButtonViewState()
        end,
    })

    AddSlider(category, rcParent, rcEnabledSetting, RIGHT, {
        key = "RC_SCALE",
        label = TARGETCHARMS_OPTIONS_SCALE,
        defaultValue = 1.0,
        min = 0.5,
        max = 3.0,
        step = 0.1,
        steps = 25,
        labelPrecision = 0.1,
        getter = function() return TargetCharms_Options["ReadyCharm"]["barscale"] end,
        setter = function(v)
            v = SnapSliderValue(v, 0.5, 3.0, 0.1);
            TargetCharms_Options["ReadyCharm"]["barscale"] = v;
            _G["ReadyCharm"]:SetScale(v)
        end,
    })

    AddSlider(category, rcParent, rcEnabledSetting, RIGHT, {
        key = "RC_OPACITY",
        label = TARGETCHARMS_OPTIONS_OPACITY,
        defaultValue = 1.0,
        min = 0.1,
        max = 1.0,
        step = 0.1,
        steps = 9,
        labelPrecision = 0.1,
        getter = function() return TargetCharms_Options["ReadyCharm"]["alphaVal"] end,
        setter = function(v)
            v = SnapSliderValue(v, 0.1, 1.0, 0.1);
            TargetCharms_Options["ReadyCharm"]["alphaVal"] = v;
            TopReady:SetAlpha(v)
        end,
    })

    AddTextEditBox(category, layout, rcParent, rcEnabledSetting, {
        key = "RC_TEXT",
        label = TARGETCHARMS_OPTIONS_READYCHECK_TEXT,
        defaultValue = Defaults["ReadyCharm"]["text"],
        getter = function() return TargetCharms_Options["ReadyCharm"]["text"] end,
        setter = function(v)
            TargetCharms_Options["ReadyCharm"]["text"] = v
            local readyButton = _G["ReadyCharm"]
            if readyButton then
                readyButton:SetText(v)
            end
            AutoSizeReadyButton()
        end,
    })
end
