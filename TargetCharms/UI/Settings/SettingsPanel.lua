--- Методы окна настроек аддона


--- Сохранённый обработчик OnHide окна настроек (восстанавливается после одноразового вызова)
--- @type function|nil
local _origSettingsPanelOnHide

--- Открывает панель настроек аддона (`/tc setup`)
function ShowSetup()
    if not TargetCharms_SettingsCategoryID then return end
    if not InCombatLockdown() then
        _G[TC_FRAME_NAMES[1]]:Show()
        _G[TC_FRAME_NAMES[3]]:Show()
        _G[TC_FRAME_NAMES[4]]:Show()
        _G[TC_FRAME_NAMES[6]]:Show()
    end
    if SettingsPanel and not _origSettingsPanelOnHide then
        _origSettingsPanelOnHide = SettingsPanel:GetScript("OnHide")
        SettingsPanel:SetScript(
                "OnHide",
                function(self)
                    if _origSettingsPanelOnHide then
                        _origSettingsPanelOnHide(self)
                    end
                    SettingsPanel:SetScript("OnHide", _origSettingsPanelOnHide)
                    _origSettingsPanelOnHide = nil
                    HideSetup()
                end
        )
    end
    Settings.OpenToCategory(TargetCharms_SettingsCategoryID)
end

--- Скрывает окно настроек, применяет текущие настройки и восстанавливает состояние панелей
function HideSetup()
    UpdateGlobal()
    LockFlares()
    SetupButtons(TC_FRAME_NAMES[1], TC_FRAME_NAMES[1])
    SetupButtons(TC_FRAME_NAMES[5], TC_FRAME_NAMES[5])
    CheckFrameViewState()
    CheckReadyButtonViewState()
    CheckFlareFrameViewState()
end

--- Копирует глобальный профиль в персонажа: обновляет настройки и перестраивает панели
function CopySetup()
    HideSetup();
    TargetCharms_Options = CopyOldValues(CloneTable(TargetCharms_OptionsGlobal), TargetCharms_OptionsGlobal);
    TargetCharms_ResetCustomLayoutMode();
    SetupTargetCharms();
    TargetCharms_SettingsRefresh();
    ShowSetup();
end

--- Если профиль персонажа глобальный — записывает текущие настройки персонажа в глобальные
function UpdateGlobal()
    if TargetCharms_OptionsGlobal["Name"] == UnitName("player") then
        TargetCharms_OptionsGlobal = CopyOldValues(CloneTable(TargetCharms_OptionsGlobal), TargetCharms_Options);
    end
end
