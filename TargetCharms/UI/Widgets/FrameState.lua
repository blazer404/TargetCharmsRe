-- Methods for frame visibility

local frameNames = TC_FRAME_NAMES;

function ShouldShow(frameKey)
    if not TargetCharms_Options[frameKey]["enabled"] then return false end
    if not TargetCharms_Options[frameKey]["partyOnly"] then return true end
    return ((GetNumGroupMembers() > 0) and not UnitInRaid("player"))
        or (UnitInRaid("player") and (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")))
end

function CheckFrameViewState()
    if InCombatLockdown() then return end
    local bar = _G[frameNames[1]]
    if ShouldShow(frameNames[1]) then bar:Show() else bar:Hide() end
end

function CheckFlareFrameViewState()
    if InCombatLockdown() then return end
    local bar = _G[frameNames[6]]
    if ShouldShow(frameNames[5]) then bar:Show() else bar:Hide() end
end

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

function SetHideShow(frame)
    local condition = TargetCharms_Options[frameNames[1]]["showontarget"]
        and "[@target,exists] show; hide" or "show";
    RegisterAttributeDriver(_G[frameNames[2]], "state-visibility", condition);
end

function SetTargetHideShow()
    SetHideShow(frameNames[2]);
end
