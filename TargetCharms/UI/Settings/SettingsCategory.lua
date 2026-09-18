--- Каркас категории настроек. Создаёт категорию в окне настроек, вызывает регистрацию секций


--- @type string Название аддона (значение ... при загрузке через .toc)
local addonName = ...

--- Значение, означающее `пользовательский` шаблон раскладки, а не один из пресетов
local CUSTOM_LAYOUT = "CUSTOM"

--- @type table<string, boolean> Признак ручного режима раскладки для каждой панели
local customLayoutMode = {}

--- Ищет `шаблон` раскладки в списке `пресетов`
--- @param defaults table[] Список пресетов (пары { название, шаблон })
--- @param template string Искомый шаблон
--- @return string|nil Совпавший шаблон или nil
local function FindPresetPattern(defaults, template)
    if not template then
        return nil
    end
    for _, preset in ipairs(defaults) do
        if preset[2] == template then
            return preset[2]
        end
    end
end

--- Сбрасывает флаг ручного режима раскладки у обеих панелей.
--- Вызывается при копировании или сбросе профиля.
function TargetCharms_ResetCustomLayoutMode()
    customLayoutMode["TargetCharms"] = false
    customLayoutMode["FlareCharms"] = false
end

--- @type string[] Имена настроек, которые нужно перерисовать после обновления интерфейса настроек
local settingsRefreshVariables = {
    "TC_ENABLED", "TC_DRAG", "TC_PARTY", "TC_SHOWTARGET", "TC_TOGGLE", "TC_SCALE", "TC_OPACITY", "TC_XSPACING", "TC_YSPACING", "TC_TEMPLATE", "TC_PRESET",
    "RC_ENABLED", "RC_DRAG", "RC_PARTY", "RC_SCALE", "RC_OPACITY", "RC_TEXT",
    "FL_ENABLED", "FL_DRAG", "FL_PARTY", "FL_ICONS", "FL_SCALE", "FL_OPACITY", "FL_XSPACING", "FL_YSPACING", "FL_TEMPLATE", "FL_PRESET",
    "PROFILE_MAIN",
};

--- Просит движок настроек перерисовать упомянутые настройки
function TargetCharms_SettingsRefresh()
    if type(Settings.GetSetting) ~= "function" or not TargetCharms_SettingsCategoryID then
        return ;
    end
    for index = 1, #settingsRefreshVariables do
        Settings.NotifyUpdate(settingsRefreshVariables[index]);
    end
end

--- Создаёт категорию настроек, вызывает регистрацию секций.
--- Вызывается один раз при инициализации аддона (VARIABLES_LOADED).
function TargetCharms_InitSettings()
    local category, layout = Settings.RegisterVerticalLayoutCategory(addonName)
    local RIGHT = MinimalSliderWithSteppersMixin.Label.Right

    TargetCharms_RegisterTargetSettings(category, layout, RIGHT, customLayoutMode, CUSTOM_LAYOUT, FindPresetPattern);

    TargetCharms_RegisterFlareSettings(category, layout, RIGHT, customLayoutMode, CUSTOM_LAYOUT, FindPresetPattern);

    TargetCharms_RegisterReadySettings(category, layout, RIGHT);

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(TARGETCHARMS_OPTIONS_PROFILE))

    Settings.CreateCheckbox(
            category,
            Settings.RegisterProxySetting(
                    category,
                    "PROFILE_MAIN",
                    Settings.VarType.Boolean,
                    TARGETCHARMS_OPTIONS_MAIN_PROFILE,
                    false,
                    function() return TargetCharms_OptionsGlobal["Name"] == UnitName("player") end,
                    function(v)
                        if v then
                            TargetCharms_OptionsGlobal["Name"] = UnitName("player")
                        else
                            TargetCharms_OptionsGlobal["Name"] = nil
                        end
                    end
            )
    )

    local sourceProfileName = TargetCharms_OptionsGlobal["Name"]
    local copyInitializer = CreateSettingsButtonInitializer(
            sourceProfileName and (TARGETCHARMS_OPTIONS_SOURCE .. " " .. sourceProfileName) or TARGETCHARMS_OPTIONS_SOURCE,
            TARGETCHARMS_OPTIONS_COPY_SETTINGS,
            function() CopySetup() end,
            nil,
            true
    )
    copyInitializer:AddShownPredicate(function()
        local source = TargetCharms_OptionsGlobal["Name"]
        return source ~= nil and source ~= UnitName("player")
    end)
    layout:AddInitializer(copyInitializer)

    Settings.RegisterAddOnCategory(category)
    TargetCharms_SettingsCategoryID = category:GetID()

    EventRegistry:RegisterCallback("Settings.Defaulted", function() TargetCharms_Reset() end)

    EventRegistry:RegisterCallback("Settings.CategoryDefaulted", function(_, defaultedCategory)
        if defaultedCategory == category then
            TargetCharms_Reset()
        end
    end)
end
