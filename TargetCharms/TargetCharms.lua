--- Точка входа аддона:
--- * обработка событий
--- * инициализация панелей и настроек
--- * позиционирование фреймов


--- @type string[]
local frameNames = TC_FRAME_NAMES;

--- Выводит текст в чат с зелёным префиксом аддона
--- @param text string Текст сообщения без префикса
function TargetCharms_msg(text)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00" .. TARGETCHARMS_MSG_TAG .. "|r" .. text);
end

-- TODO понять зачем оно и можно ли избавится
--- Заглушка, нигде не вызывается (оставлена от прежней версии)
--- @param frame Frame Игнорируется
--- @param offset number Игнорируется
function resetTop(frame, offset) end

--- Регистрирует события для OnEvent и подключает слэш-команды.
--- Вызывается из TargetCharms.xml в OnLoad фрейма
--- @param self Frame Панель TargetCharms (родитель кнопок меток)
function TargetCharms_OnLoad(self)
    self:RegisterEvent("VARIABLES_LOADED");
    self:RegisterEvent("PARTY_LEADER_CHANGED");
    self:RegisterEvent("GROUP_ROSTER_UPDATE");
    self:RegisterEvent("PLAYER_TARGET_CHANGED");
    self:RegisterEvent("GROUP_ROSTER_UPDATE");
    TargetCharms_RegisterSlashCommands();
end

--- Инициализирует или мигрирует SavedVariables (глобальные и персонажа), приводит значения к допустимым
local function InitVarsOnLoaded()
    if TargetCharms_OptionsGlobal == nil or TARGETCHARMS_DB_VERSION ~= TargetCharms_OptionsGlobal["Version"] then
        TargetCharms_OptionsGlobal = CopyOldValues(Defaults, Defaults);
        TargetCharms_OptionsGlobal["Version"] = TARGETCHARMS_DB_VERSION;
        TargetCharms_OptionsGlobal["Name"] = UnitName("player");
        TargetCharms_Options = CopyOldValues(TargetCharms_OptionsGlobal, TargetCharms_OptionsGlobal);
    end
    if TargetCharms_Options == nil or TARGETCHARMS_DB_VERSION ~= TargetCharms_Options["Version"] then
        TargetCharms_Options = CopyOldValues(TargetCharms_OptionsGlobal, TargetCharms_Options);
        CopyValues(TargetCharms_Options, TargetCharms_OptionsGlobal);
        TargetCharms_Options["Version"] = TARGETCHARMS_DB_VERSION;
    end

    NormalizeOptionValues();
end

--- Обработчик событий:
--- * при VARIABLES_LOADED инициализирует настройки и панели,
--- * при прочих событиях обновляет видимость панелей.
--- @param self Frame Панель, получившая событие
--- @param event string Название игрового события (например "VARIABLES_LOADED")
function TargetCharms_OnEvent(self, event)
    if event == "VARIABLES_LOADED" then
        InitVarsOnLoaded();

        SetupTargetCharms();

        TargetCharms_InitSettings();

        TargetCharms_msg(TARGETCHARMS_VERSION .. " - " .. TARGETCHARMS_LOADED);
    end
    if event ~= "PLAYER_TARGET_CHANGED" then
        CheckReadyButtonViewState();
        CheckFlareFrameViewState();
        if event == "PLAYER_REGEN_ENABLED" then
            _G[frameNames[1]]:UnregisterEvent("PLAYER_REGEN_ENABLED");
            --LockFlares();
        end
    end
    CheckFrameViewState();
end

--- Расставляет все фреймы и кнопки согласно настройкам (раскладка, кнопка готовности, hide/show).
function SetupTargetCharms()
    SetupFrames();
    SetupButtons(frameNames[1], frameNames[1]);
    SetupButtons(frameNames[5], frameNames[5]);
    SetUpReadyButton();
    SetTargetHideShow();
end

--- Сбрасывает настройки к значениям по умолчанию и перестраивает панели.
function TargetCharms_Reset()
    TargetCharms_Options = CloneTable(Defaults);
    TargetCharms_Options["Version"] = TARGETCHARMS_DB_VERSION;
    TargetCharms_Options["Name"] = UnitName("player");
    TargetCharms_ResetCustomLayoutMode();
    SetupTargetCharms();
    CheckFrameViewState();
    CheckReadyButtonViewState();
    CheckFlareFrameViewState();
    UpdateGlobal();
    TargetCharms_SettingsRefresh();
    TargetCharms_msg(TARGETCHARMS_OPTIONS_RESET);
end

--- Применяет сохранённые позицию, масштаб и прозрачность одной панели
--- @param index number Индекс панели в TC_FRAME_NAMES (1 — метки цели, 5 — метки на земле)
--- @param defaultX number Значение left при отсутствии сохранённой позиции
--- @param defaultY number Значение top при отсутствии сохранённой позиции
local function ApplyPanelOptions(index, defaultX, defaultY)
    local frameBar = frameNames[index];
    local frameBody = frameNames[index + 1];
    if (TargetCharms_Options[frameBar]["X"] ~= nil) then
        _G[frameBody]:ClearAllPoints()
        _G[frameBody]:SetPoint("BOTTOMLEFT", TargetCharms_Options[frameBar]["X"], TargetCharms_Options[frameBar]["Y"]);
    else
        _G[frameBody]:ClearAllPoints()
        _G[frameBody]:SetPoint("TOPLEFT", _G["UIParent"], "TOP", defaultX, defaultY);
    end
    _G[frameBar]:SetScale(TargetCharms_Options[frameBar]["barscale"]);
    _G[frameBody]:SetAlpha(TargetCharms_Options[frameBar]["alphaVal"]);
end

--- Применяет сохранённые позицию, масштаб и прозрачность панелей целей и меток на земле
function SetupFrames()
    ApplyPanelOptions(1, 0, -20);
    ApplyPanelOptions(5, 100, 0);
end

--- Сохраняет позицию панели в настройки персонажа; если активен глобальный профиль —
--- сразу записывает её и в глобальные настройки.
---@param frameId number Индекс панели в TC_FRAME_NAMES (1/3/5)
---@param x number Координата left
---@param y number Координата top (корректируется до нижнего края панели)
function UpdateLocation(frameId, x, y)
    local frame = frameNames[frameId];
    TargetCharms_Options[frame]["X"] = x;
    TargetCharms_Options[frame]["Y"] = y;
    if TargetCharms_OptionsGlobal["Name"] == UnitName("player") then
        TargetCharms_OptionsGlobal[frame]["X"] = TargetCharms_Options[frame]["X"];
        TargetCharms_OptionsGlobal[frame]["Y"] = TargetCharms_Options[frame]["Y"];
    end
end
