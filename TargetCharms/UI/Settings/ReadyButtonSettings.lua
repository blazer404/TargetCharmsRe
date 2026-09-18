--- Секция `Кнопка готовности` в настройках. Регистрирует настройки кнопки `ReadyCharm`.


--- Создаёт `родителя` для вложенных настроек — они показываются только при включённой панели
--- @param setting table Настройка-галочка `включено`
--- @return table Инициализатор родителя
local function CreateEnableGate(setting)
    return Settings.CreateControlInitializer("SettingsCheckboxControlTemplate", setting)
end

--- Регистрирует всю секцию настроек кнопки готовности
--- @param category table Категория настроек аддона
--- @param layout table Вертикальная раскладка секции
--- @param RIGHT string Имя правой подписи слайдеров (из SettingsControlMixin)
function TargetCharms_RegisterReadySettings(category, layout, RIGHT)
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(TARGETCHARMS_OPTIONS_READYCHECK_TITLE))

    local rcEnabledSetting = Settings.RegisterProxySetting(
            category,
            "RC_ENABLED",
            Settings.VarType.Boolean,
            TARGETCHARMS_OPTIONS_ENABLE,
            true,
            function() return TargetCharms_Options["ReadyCharm"]["enabled"] end,
            function(v)
                TargetCharms_Options["ReadyCharm"]["enabled"] = v;
                CheckReadyButtonViewState()
            end
    )
    local rcEnabled = Settings.CreateCheckbox(category, rcEnabledSetting)
    local rcParent = CreateEnableGate(rcEnabledSetting)

    do
        local s = Settings.RegisterProxySetting(
                category,
                "RC_DRAG",
                Settings.VarType.Boolean,
                TARGETCHARMS_OPTIONS_DRAG,
                false,
                function() return TargetCharms_Options["ReadyCharm"]["draggable"] end,
                function(v) TargetCharms_Options["ReadyCharm"]["draggable"] = v end
        )
        local init = Settings.CreateCheckbox(category, s)
        init:SetParentInitializer(rcParent, function() return rcEnabledSetting:GetValue() end)
    end

    do
        local s = Settings.RegisterProxySetting(
                category,
                "RC_PARTY",
                Settings.VarType.Boolean,
                TARGETCHARMS_OPTIONS_PARTYONLY,
                false,
                function() return TargetCharms_Options["ReadyCharm"]["partyOnly"] end,
                function(v)
                    TargetCharms_Options["ReadyCharm"]["partyOnly"] = v;
                    CheckReadyButtonViewState()
                end
        )
        local init = Settings.CreateCheckbox(category, s)
        init:SetParentInitializer(rcParent, function() return rcEnabledSetting:GetValue() end)
    end

    do
        local s = Settings.RegisterProxySetting(
                category,
                "RC_SCALE",
                Settings.VarType.Number,
                TARGETCHARMS_OPTIONS_SCALE,
                1.0,
                function() return TargetCharms_Options["ReadyCharm"]["barscale"] end,
                function(v)
                    v = SnapSliderValue(v, 0.5, 3.0, 0.1);
                    TargetCharms_Options["ReadyCharm"]["barscale"] = v;
                    _G["ReadyCharm"]:SetScale(v)
                end
        )
        local o = Settings.CreateSliderOptions(0.5, 3.0, 0.1)
        o.steps = 25
        o:SetLabelFormatter(RIGHT)
        o.formatters[RIGHT] = CreateSliderLabelFormatter(0.1)
        local init = Settings.CreateSlider(category, s, o)
        init:SetParentInitializer(rcParent, function() return rcEnabledSetting:GetValue() end)
    end

    do
        local s = Settings.RegisterProxySetting(
                category,
                "RC_OPACITY",
                Settings.VarType.Number,
                TARGETCHARMS_OPTIONS_OPACITY,
                1.0,
                function() return TargetCharms_Options["ReadyCharm"]["alphaVal"] end,
                function(v)
                    v = SnapSliderValue(v, 0.1, 1.0, 0.1);
                    TargetCharms_Options["ReadyCharm"]["alphaVal"] = v;
                    TopReady:SetAlpha(v)
                end
        )
        local o = Settings.CreateSliderOptions(0.1, 1.0, 0.1)
        o.steps = 9
        o:SetLabelFormatter(RIGHT)
        o.formatters[RIGHT] = CreateSliderLabelFormatter(0.1)
        local init = Settings.CreateSlider(category, s, o)
        init:SetParentInitializer(rcParent, function() return rcEnabledSetting:GetValue() end)
    end

    do
        local s = Settings.RegisterProxySetting(
                category,
                "RC_TEXT",
                Settings.VarType.String,
                TARGETCHARMS_OPTIONS_READYCHECK_TEXT,
                Defaults["ReadyCharm"]["text"],
                function() return TargetCharms_Options["ReadyCharm"]["text"] end,
                function(v)
                    TargetCharms_Options["ReadyCharm"]["text"] = v
                    local readyButton = _G["ReadyCharm"]
                    if readyButton then
                        readyButton:SetText(v)
                    end
                    AutoSizeReadyButton()
                end
        )
        local init = Settings.CreateControlInitializer("TargetCharmsEditBoxControlTemplate", s)
        init:SetParentInitializer(rcParent, function() return rcEnabledSetting:GetValue() end)
        layout:AddInitializer(init)
    end
end
