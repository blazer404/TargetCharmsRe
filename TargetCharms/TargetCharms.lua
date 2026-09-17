local frameNames = TC_FRAME_NAMES;

function TargetCharms_msg(text)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00" .. TARGETCHARMS_MSG_TAG .. "|r" .. text);
end

function resetTop(frame, offset)

end

function TargetCharms_OnLoad(self)
    self:RegisterEvent("VARIABLES_LOADED");
    self:RegisterEvent("PARTY_LEADER_CHANGED");
    self:RegisterEvent("GROUP_ROSTER_UPDATE");
    self:RegisterEvent("PLAYER_TARGET_CHANGED");
    self:RegisterEvent("GROUP_ROSTER_UPDATE");
    TargetCharms_RegisterSlashCommands();
end

function TargetCharms_OnEvent(self, event)
    if event == "VARIABLES_LOADED" then
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

function SetupTargetCharms()
    SetupFrames();
    SetupButtons(frameNames[1], frameNames[1]);
    SetupButtons(frameNames[5], frameNames[5]);
    SetUpReadyButton();
    SetTargetHideShow();
end

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

function SetupFrames()
    local tmpFrame = _G[frameNames[1]];
    if (TargetCharms_Options[frameNames[1]]["X"] ~= nil) then
        _G[frameNames[2]]:ClearAllPoints()
        _G[frameNames[2]]:SetPoint("BOTTOMLEFT", TargetCharms_Options[frameNames[1]]["X"], TargetCharms_Options[frameNames[1]]["Y"]);
    else
        _G[frameNames[2]]:ClearAllPoints()
        _G[frameNames[2]]:SetPoint("TOPLEFT", _G["UIParent"], "TOP", 0, -20);
    end
    tmpFrame:SetScale(TargetCharms_Options[frameNames[1]]["barscale"]);
    tmpFrame = _G[frameNames[2]];
    tmpFrame:SetAlpha(TargetCharms_Options[frameNames[1]]["alphaVal"]);
    tmpFrame = _G[frameNames[5]];
    if (TargetCharms_Options[frameNames[5]]["X"] ~= nil) then
        _G[frameNames[6]]:ClearAllPoints();
        _G[frameNames[6]]:SetPoint("BOTTOMLEFT", TargetCharms_Options[frameNames[5]]["X"], TargetCharms_Options[frameNames[5]]["Y"]);
    else
        _G[frameNames[6]]:ClearAllPoints()
        _G[frameNames[6]]:SetPoint("TOPLEFT", _G["UIParent"], "TOP", 100, 0);
    end
    tmpFrame:SetScale(TargetCharms_Options[frameNames[5]]["barscale"]);
    tmpFrame = _G[frameNames[6]];
    tmpFrame:SetAlpha(TargetCharms_Options[frameNames[5]]["alphaVal"]);
end

function UpdateLocation(frameId, x, y)
    local frame = frameNames[frameId];
    TargetCharms_Options[frame]["X"] = x;
    TargetCharms_Options[frame]["Y"] = y;
    if TargetCharms_OptionsGlobal["Name"] == UnitName("player") then
        TargetCharms_OptionsGlobal[frame]["X"] = TargetCharms_Options[frame]["X"];
        TargetCharms_OptionsGlobal[frame]["Y"] = TargetCharms_Options[frame]["Y"];
    end
end
