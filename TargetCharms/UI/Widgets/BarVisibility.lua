--- Видимость панелей аддона
--- Решает, когда показывать панелей меток и кнопку готовности и применяет show/hide к фреймам


--- @type string[]
local frameNames = TC_FRAME_NAMES;

--- Определяет, нужно ли показывать панель:
--- * включена, и либо не только в группе,
--- * либо персонаж в группе (с правами рл/ассист)
--- @param frameKey string Имя панели из TC_FRAME_NAMES (1/3/5)
--- @return boolean true, если панель должна быть видимой
function ShouldShow(frameKey)
    if not TargetCharms_Options[frameKey]["enabled"] then return false end
    if not TargetCharms_Options[frameKey]["partyOnly"] then return true end
    return ((GetNumGroupMembers() > 0) and not UnitInRaid("player"))
            or (UnitInRaid("player") and (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")))
end

--- Показывает/скрывает панель меток цели по результату ShouldShow()
function CheckFrameViewState()
    if InCombatLockdown() then return end
    local bar = _G[frameNames[1]]
    if ShouldShow(frameNames[1]) then bar:Show() else bar:Hide() end
end

--- Показывает/скрывает контейнер панели меток на земле по её настройкам
function CheckFlareFrameViewState()
    if InCombatLockdown() then return end
    local bar = _G[frameNames[6]]
    if ShouldShow(frameNames[5]) then bar:Show() else bar:Hide() end
end

--- Показывает/скрывает кнопку готовности и её контейнер по настройкам кнопки
function CheckReadyButtonViewState()
    if InCombatLockdown() then return end
    local charmBar = _G[frameNames[3]]
    local topReady = _G[frameNames[4]]
    if ShouldShow(frameNames[3]) then
        charmBar:Show()
        topReady:Show()
    else
        charmBar:Hide()
        topReady:Hide()
    end
end

--- Задаёт контейнеру меток цели condition-драйвер:
--- панель видна, пока есть цель (если включена опция showontarget), либо всегда
--- @param frame string Имя контейнера (ожидается frameNames[2]); настройки читаются у frameNames[1]
function SetHideShow(frame)
    local condition = TargetCharms_Options[frameNames[1]]["showontarget"]
            and "[@target,exists] show; hide" or "show";
    RegisterAttributeDriver(_G[frameNames[2]], "state-visibility", condition);
end

--- Применяет целевой visibility-драйвер к контейнеру панели меток цели.
function SetTargetHideShow()
    SetHideShow(frameNames[2]);
end
