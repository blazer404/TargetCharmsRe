local frameNames = TC_FRAME_NAMES;
local texturePaths = TC_TEXTURE_PATHS;

local buttonCharm = {
    ["TargetCharms"] = {},
    ["FlareCharms"] = {}
};


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

function MakeButton(frame, buttonNum, isMacro)
    local button = _G[frame .. "Charm" .. buttonNum];
    local template = "CharmTemplate, SecureCharmTemplate";
    if isMacro then
        template = "SecureCharmTemplate";
    end
    if button == nil then
        button = CreateFrame("Button", frame .. "Charm" .. buttonNum, _G[frame], template)
        button:RegisterForClicks("AnyDown");
        button:SetID(buttonNum);
        button:SetHeight(32);
        button:SetWidth(32);
        local texture = button:CreateTexture(button:GetName() .. "CharmTex");
        texture:SetDrawLayer("ARTWORK");
        if isMacro then
            button:SetAttribute("type", "macro")
            button:SetHeight(32);
            button:SetWidth(32);
            local textureColor = button:CreateTexture(button:GetName() .. "TextureColor");
            textureColor:SetDrawLayer("BORDER");
            textureColor:SetPoint("TOPLEFT", _G[button:GetName() .. "CharmTex"], "TOPLEFT", 5, -5);
            textureColor:SetPoint("BOTTOMRIGHT", _G[button:GetName() .. "CharmTex"], "BOTTOMRIGHT", -5, 5);
            local textureIcon = button:CreateTexture(button:GetName() .. "TextureIcon");
            textureIcon:SetDrawLayer("OVERLAY");
            textureIcon:SetAllPoints(button);
        end
    elseif isMacro and not _G[button:GetName() .. "TextureColor"] then
        button:SetAttribute("type", "macro")
        button:SetSize(32, 32);
        local textureColor = button:CreateTexture(button:GetName() .. "TextureColor");
        textureColor:SetDrawLayer("BORDER");
        textureColor:SetPoint("TOPLEFT", _G[button:GetName() .. "CharmTex"], "TOPLEFT", 5, -5);
        textureColor:SetPoint("BOTTOMRIGHT", _G[button:GetName() .. "CharmTex"], "BOTTOMRIGHT", -5, 5);
        local textureIcon = button:CreateTexture(button:GetName() .. "TextureIcon");
        textureIcon:SetDrawLayer("OVERLAY");
        textureIcon:SetAllPoints(button);
    end
    if isMacro then
        button:SetSize(32, 32);
    end
    return button;
end

function SetupButtons(frameInfo, frameTarget)
    local buttonString = TargetCharms_Options[frameInfo]["buttonTemplate"];
    local maxlen = strlen(buttonString);
    if mod(maxlen, 2) == 1 then
        maxlen = maxlen - 1
    end
    local buttonNum = 1;
    if maxlen > 40 then
        maxlen = 40;
    end

    local t
    for t = 1, maxlen, 2 do
        FormatButton(frameTarget, buttonNum, strsub(buttonString, t, t), strsub(buttonString, t + 1, t + 1), TargetCharms_Options[frameInfo]["Xspacing"], TargetCharms_Options[frameInfo]["Yspacing"]);
        buttonNum = buttonNum + 1;
    end

    for t = buttonNum, 20 do
        local button = _G[frameTarget .. "Charm" .. t];
        if button ~= nil then
            button:Hide();
        end
    end
end

function FormatButton(frame, buttonNum, posChar, typeNum, xSpacing, ySpacing)
    if frame == frameNames[1] then
        if typeNum == TARGETCHARMS_CHARM0 then
            button = MakeButton(frame, buttonNum, false);
            MakeCharm(frame, button, buttonNum, 0, 2, 0.15, 0.85, 0.15, 0.85, 0, 0, 32, 32);
            button:Show();
        elseif typeNum == TARGETCHARMS_CHARM1 then
            button = MakeButton(frame, buttonNum, false);
            MakeCharm(frame, button, buttonNum, 1, 1, 0, 0.25, 0, 0.25, 2, -2, 28, 28);
            button:Show();
        elseif typeNum == TARGETCHARMS_CHARM2 then
            button = MakeButton(frame, buttonNum, false);
            MakeCharm(frame, button, buttonNum, 2, 1, 0.25, 0.5, 0, 0.25, 2, -2, 28, 28);
            button:Show();
        elseif typeNum == TARGETCHARMS_CHARM3 then
            button = MakeButton(frame, buttonNum, false);
            MakeCharm(frame, button, buttonNum, 3, 1, 0.5, 0.75, 0, 0.25, 2, -2, 28, 28);
            button:Show();
        elseif typeNum == TARGETCHARMS_CHARM4 then
            button = MakeButton(frame, buttonNum, false);
            MakeCharm(frame, button, buttonNum, 4, 1, 0.75, 1, 0, 0.25, 2, -2, 28, 28);
            button:Show();
        elseif typeNum == TARGETCHARMS_CHARM5 then
            button = MakeButton(frame, buttonNum, false);
            MakeCharm(frame, button, buttonNum, 5, 1, 0, 0.25, 0.25, 0.5, 2, -2, 28, 28);
            button:Show();
        elseif typeNum == TARGETCHARMS_CHARM6 then
            button = MakeButton(frame, buttonNum, false);
            MakeCharm(frame, button, buttonNum, 6, 1, 0.25, 0.5, 0.25, 0.5, 2, -2, 28, 28);
            button:Show();
        elseif typeNum == TARGETCHARMS_CHARM7 then
            button = MakeButton(frame, buttonNum, false);
            MakeCharm(frame, button, buttonNum, 7, 1, 0.5, 0.75, 0.25, 0.5, 2, -2, 28, 28);
            button:Show();
        elseif typeNum == TARGETCHARMS_CHARM8 then
            button = MakeButton(frame, buttonNum, false);
            MakeCharm(frame, button, buttonNum, 8, 1, 0.75, 1, 0.25, 0.5, 2, -2, 28, 28);
            button:Show();
        elseif typeNum == TARGETCHARMS_CHARM9 then
            button = MakeButton(frame, buttonNum, false);
            MakeCharm(frame, button, buttonNum, 9, 4, 0, 1, 0, 1, 0, 0, 32, 32);
            button:Show();
        else
            button = MakeButton(frame, buttonNum, false);
            button:Hide();
        end
        -- bind button action as a macros
        local charmId = buttonCharm[frame][buttonNum];
        if charmId and charmId >= 0 then
            button:SetAttribute("type", "macro")
            button:SetAttribute("macrotext", "/tm " .. charmId);
		end
    else
        if typeNum == TARGETCHARMS_DRAG then
            button = _G[frame .. "Charm" .. buttonNum];
            if button == nil then
                button = CreateFrame("Button", frame .. "Charm" .. buttonNum, _G[frame], "DragCharmTemplate")
            end
            button:SetID(buttonNum);
            button:SetSize(16, 16);
            local dragTexIcon = _G[button:GetName() .. "TextureIcon"];
            if dragTexIcon then dragTexIcon:SetTexture() end
            local dragTexColor = _G[button:GetName() .. "TextureColor"];
            if dragTexColor then dragTexColor:SetTexture() end
            if TargetCharms_Options["FlareCharms"]["draggable"] then
                button:RegisterForClicks("AnyDown");
                button:Show();
            else
                button:Hide();
            end
        elseif typeNum == TARGETCHARMS_BLUEFLARE then
            button = MakeButton(frame, buttonNum, true);
            MakeCharm(frame, button, buttonNum, 1, 2, 0.15, 0.85, 0.15, 0.85, 0, 0, 32, 32);
            if TargetCharms_Options[frameNames[5]]["showicons"] then
                SetTexture(button, _G[button:GetName() .. "TextureIcon"], 1, 0.25, 0.5, 0.25, 0.5, 6, -5, 20, 20);
            else
                _G[button:GetName() .. "TextureIcon"]:SetTexture();
            end
            local textureColor = _G[button:GetName() .. "TextureColor"];
            textureColor:SetColorTexture(0, .5, 1);
            button:SetAttribute("macrotext", "/cwm 1\n/wm 1");
            button:Show();
        elseif typeNum == TARGETCHARMS_GREENFLARE then
            button = MakeButton(frame, buttonNum, true);
            MakeCharm(frame, button, buttonNum, 2, 2, 0.15, 0.85, 0.15, 0.85, 0, 0, 32, 32);
            if TargetCharms_Options[frameNames[5]]["showicons"] then
                SetTexture(button, _G[button:GetName() .. "TextureIcon"], 1, 0.75, 1, 0, 0.25, 6, -5, 20, 20);
            else
                _G[button:GetName() .. "TextureIcon"]:SetTexture();
            end
            local textureColor = _G[button:GetName() .. "TextureColor"];
            textureColor:SetColorTexture(0, 1, .2);
            button:SetAttribute("macrotext", "/cwm 2\n/wm 2");
            button:Show();
        elseif typeNum == TARGETCHARMS_PURPLEFLARE then
            button = MakeButton(frame, buttonNum, true);
            MakeCharm(frame, button, buttonNum, 3, 2, 0.15, 0.85, 0.15, 0.85, 0, 0, 32, 32);
            if TargetCharms_Options[frameNames[5]]["showicons"] then
                SetTexture(button, _G[button:GetName() .. "TextureIcon"], 1, 0.5, 0.75, 0, 0.25, 6, -5, 20, 20);
            else
                _G[button:GetName() .. "TextureIcon"]:SetTexture();
            end
            local textureColor = _G[button:GetName() .. "TextureColor"];
            textureColor:SetColorTexture(.5, 0, 1);
            button:SetAttribute("macrotext", "/cwm 3\n/wm 3");
            button:Show();
        elseif typeNum == TARGETCHARMS_REDFLARE then
            button = MakeButton(frame, buttonNum, true);
            MakeCharm(frame, button, buttonNum, 4, 2, 0.15, 0.85, 0.15, 0.85, 0, 0, 32, 32);
            if TargetCharms_Options[frameNames[5]]["showicons"] then
                SetTexture(button, _G[button:GetName() .. "TextureIcon"], 1, 0.5, 0.75, 0.25, 0.5, 6, -5, 20, 20);
            else
                _G[button:GetName() .. "TextureIcon"]:SetTexture();
            end
            local textureColor = _G[button:GetName() .. "TextureColor"];
            textureColor:SetColorTexture(1, 0, 0);
            button:SetAttribute("macrotext", "/cwm 4\n/wm 4");
            button:Show();
        elseif typeNum == TARGETCHARMS_YELLOWFLARE then
            button = MakeButton(frame, buttonNum, true);
            MakeCharm(frame, button, buttonNum, 5, 2, 0.15, 0.85, 0.15, 0.85, 0, 0, 32, 32);
            if TargetCharms_Options[frameNames[5]]["showicons"] then
                SetTexture(button, _G[button:GetName() .. "TextureIcon"], 1, 0, 0.25, 0, 0.25, 6, -5, 20, 20);
            else
                _G[button:GetName() .. "TextureIcon"]:SetTexture();
            end
            local textureColor = _G[button:GetName() .. "TextureColor"];
            textureColor:SetColorTexture(1, 1, 0);
            button:SetAttribute("macrotext", "/cwm 5\n/wm 5");
            button:Show();
        elseif typeNum == TARGETCHARMS_ORANGEFLARE then
            button = MakeButton(frame, buttonNum, true);
            MakeCharm(frame, button, buttonNum, 6, 2, 0.15, 0.85, 0.15, 0.85, 0, 0, 32, 32);
            if TargetCharms_Options[frameNames[5]]["showicons"] then
                SetTexture(button, _G[button:GetName() .. "TextureIcon"], 1, 0.25, 0.5, 0, 0.25, 6, -5, 20, 20);
            else
                _G[button:GetName() .. "TextureIcon"]:SetTexture();
            end
            local textureColor = _G[button:GetName() .. "TextureColor"];
            textureColor:SetColorTexture(1, .5, 0);
            button:SetAttribute("macrotext", "/cwm 6\n/wm 6");
            button:Show();
        elseif typeNum == TARGETCHARMS_SILVERFLARE then
            button = MakeButton(frame, buttonNum, true);
            MakeCharm(frame, button, buttonNum, 7, 2, 0.15, 0.85, 0.15, 0.85, 0, 0, 32, 32);
            if TargetCharms_Options[frameNames[5]]["showicons"] then
                SetTexture(button, _G[button:GetName() .. "TextureIcon"], 1, 0, 0.25, 0.25, 0.5, 6, -5, 20, 20);
            else
                _G[button:GetName() .. "TextureIcon"]:SetTexture();
            end
            local textureColor = _G[button:GetName() .. "TextureColor"];
            textureColor:SetColorTexture(.5, .5, .5);
            button:SetAttribute("macrotext", "/cwm 7\n/wm 7");
            button:Show();
        elseif typeNum == TARGETCHARMS_WHITEFLARE then
            button = MakeButton(frame, buttonNum, true);
            MakeCharm(frame, button, buttonNum, 8, 2, 0.15, 0.85, 0.15, 0.85, 0, 0, 32, 32);
            if TargetCharms_Options[frameNames[5]]["showicons"] then
                SetTexture(button, _G[button:GetName() .. "TextureIcon"], 1, 0.75, 1, 0.25, 0.5, 6, -5, 20, 20);
            else
                _G[button:GetName() .. "TextureIcon"]:SetTexture();
            end
            local textureColor = _G[button:GetName() .. "TextureColor"];
            textureColor:SetColorTexture(1, 1, 1);
            button:SetAttribute("macrotext", "/cwm 8\n/wm 8");
            button:Show();
        elseif typeNum == TARGETCHARMS_CLEARFLARE then
            button = MakeButton(frame, buttonNum, true);
            MakeCharm(frame, button, buttonNum, 0, 2, 0.15, 0.85, 0.15, 0.85, 0, 0, 32, 32);
            SetTexture(button, _G[button:GetName() .. "TextureIcon"], 3, 0, 1, 0, 1, 3, -2, 26, 26);
            _G[button:GetName() .. "TextureColor"]:SetTexture();
            button:SetAttribute("macrotext", "/cwm 1\n/cwm 2\n/cwm 3\n/cwm 4\n/cwm 5\n/cwm 6\n/cwm 7\n/cwm 8");
            button:Show();
        else
            button = MakeButton(frame, buttonNum, true);
            button:Hide();
        end
    end
    if button ~= nil then
        button:ClearAllPoints();
        if strlower(posChar) == TARGETCHARMS_POSITION_DOWN then
            button:SetPoint("TOPLEFT", _G[frame .. "Charm" .. tostring(buttonNum - 1)], "BOTTOMLEFT", 0, 0 - ySpacing);
        elseif posChar == TARGETCHARMS_POSITION_UP then
            button:SetPoint("BOTTOMLEFT", _G[frame .. "Charm" .. tostring(buttonNum - 1)], "TOPLEFT", 0, 0 + ySpacing);
        elseif posChar == TARGETCHARMS_POSITION_RIGHT then
            button:SetPoint("TOPLEFT", _G[frame .. "Charm" .. tostring(buttonNum - 1)], "TOPRIGHT", 0 + xSpacing, 0);
        elseif posChar == TARGETCHARMS_POSITION_LEFT then
            button:SetPoint("TOPRIGHT", _G[frame .. "Charm" .. tostring(buttonNum - 1)], "TOPLEFT", 0 - xSpacing, 0);
        else
            --ERROR--
            button:SetPoint("TOPLEFT", _G[frame .. "Charm" .. tostring(buttonNum - 1)], "TOPRIGHT", 0, 0 - ySpacing);
            buttonCharm[frame][buttonNum] = 0;
            button:Hide();
            print(TARGETCHARMS_ERROR_INVALIDCHAR);
            return false;
        end
    end
    return true;
end

function MakeCharm(frame, button, buttonNum, id, textureID, o1, o2, o3, o4, a1, a2, w, h)
    buttonCharm[frame][buttonNum] = id;
    local texture = _G[button:GetName() .. "CharmTex"];
    if texture then
        SetTexture(button, texture, textureID, o1, o2, o3, o4, a1, a2, w, h);
    end
end

function SetTexture(button, texture, textureID, o1, o2, o3, o4, a1, a2, w, h)
    texture:ClearAllPoints();
    texture:SetWidth(w);
    texture:SetHeight(h);
    texture:SetTexture(texturePaths[textureID]);
    texture:SetTexCoord(o1, o2, o3, o4);
    texture:SetPoint("CENTER", button, "CENTER", 0, 0);
end

function SetFrameScale(scale, id)
    local tmpFrame = _G[frameNames[id]];
    tmpFrame:SetScale(scale);
end

local _origSettingsPanelOnHide

function ShowSetup()
    if not TargetCharms_SettingsCategoryID then return end
    if not InCombatLockdown() then
        _G[frameNames[1]]:Show()
        _G[frameNames[3]]:Show()
        _G[frameNames[4]]:Show()
        _G[frameNames[6]]:Show()
    end
    if SettingsPanel and not _origSettingsPanelOnHide then
        _origSettingsPanelOnHide = SettingsPanel:GetScript("OnHide")
        SettingsPanel:SetScript("OnHide", function(self)
            if _origSettingsPanelOnHide then _origSettingsPanelOnHide(self) end
            SettingsPanel:SetScript("OnHide", _origSettingsPanelOnHide)
            _origSettingsPanelOnHide = nil
            HideSetup()
        end)
    end
    Settings.OpenToCategory(TargetCharms_SettingsCategoryID)
end

function HideSetup()
    UpdateGlobal()
    LockFlares()
    SetupButtons(frameNames[1], frameNames[1])
    SetupButtons(frameNames[5], frameNames[5])
    CheckFrameViewState()
    CheckReadyButtonViewState()
    CheckFlareFrameViewState()
end



function CopySetup()
    HideSetup();
    TargetCharms_Options = CopyOldValues(CloneTable(TargetCharms_OptionsGlobal), TargetCharms_OptionsGlobal);
    TargetCharms_ResetCustomLayoutMode();
    SetupTargetCharms();
    TargetCharms_SettingsRefresh();
    ShowSetup();
end

function UpdateGlobal()
    if TargetCharms_OptionsGlobal["Name"] == UnitName("player") then
        TargetCharms_OptionsGlobal = CopyOldValues(CloneTable(TargetCharms_OptionsGlobal), TargetCharms_Options);
    end
end 