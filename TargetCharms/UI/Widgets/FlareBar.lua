--- Панель меток на земле: режим перемещения
--- Включает/выключает перетаскивание панели меток на земле и синхронизирует подписи/текстуру панели в режиме перемещения


---@type string[]
local frameNames = TC_FRAME_NAMES;

--- Переводит панель в режим перемещения
function MoveFlares()
    local frame = _G[frameNames[5]];
    frame:EnableMouse(true);
    _G[frameNames[5] .. "_Tex"]:SetColorTexture(0, 1, 0);
    _G[frameNames[5] .. "Text"]:SetText(TARGETCHARMS_OPTIONS_FLARE_MOVE_TEXT);

    for buttonNum = 1, 20 do
        local button = _G[frameNames[5] .. "Charm" .. buttonNum];
        if button ~= nil then
            button:Hide();
        end
    end

    local frame = _G["FlareMoveButton"];
    frame:SetText(TARGETCHARMS_OPTIONS_FLARE_LOCK_BUTTON);
end

--- Выход из режима перемещения
function LockFlares()
    if (not InCombatLockdown()) then
        local frame = _G[frameNames[5]];
        frame:EnableMouse(false);
        _G[frameNames[5] .. "_Tex"]:SetTexture();
        _G[frameNames[5] .. "Text"]:SetText();

        local button = _G["FlareMoveButton"];
        if button ~= nil then
            button:SetText(TARGETCHARMS_OPTIONS_FLARE_MOVE_BUTTON);
        end
        SetupButtons(frameNames[5], frameNames[5]);
    end
end
