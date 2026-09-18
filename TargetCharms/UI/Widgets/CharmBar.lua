--- Построение панелей кнопок меток (цели и на земле)
--- Разбирает строку-шаблон раскладки, создаёт кнопки и позиционирует их, назначает макросы для меток цели и флажков на земле


--- @type string[]
local frameNames = TC_FRAME_NAMES;

--- @type string[]
local texturePaths = TC_TEXTURE_PATHS;

--- Номер текущей метки/флажка каждой кнопки панелей (TargetCharms / FlareCharms)
--- @type table<string, table<number, number>>
local buttonCharm = {
    ["TargetCharms"] = {},
    ["FlareCharms"] = {}
};

--- Возвращает таблицу соответствия кнопок выбранным меткам
--- @return table<string, table<number, number>> buttonCharm
function GetButtonCharm()
    return buttonCharm;
end

--- Создаёт (или возвращает существующую) кнопку панели
--- @param frame string Имя панели ("TargetCharms"/"FlareCharms")
--- @param buttonNum number Номер кнопки (1–20)
--- @param isMacro boolean true для макросных кнопок (флажки, drag-кнопка)
--- @return Button Кнопка с именем <frame>Charm<buttonNum>
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

--- Перестраивает панель по строке-шаблону раскладки:
--- по паре символов на каждую кнопку, лишние кнопки скрывает (максимум `20` позиций)
--- @param frameInfo string Имя панели, откуда брать настройки (TargetCharms/FlareCharms)
--- @param frameTarget string Имя панели, куда создавать кнопки
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

--- Позиционирует одну кнопку на панели
--- и настраивает её содержимое в зависимости от пар символов (`направление` + `тип` метки/флажка)
--- @param frame string Имя панели (TargetCharms/FlareCharms)
--- @param buttonNum number Позиция кнопки на панели
--- @param posChar string Символ направления (`^`/`v`/`<`/`>`)
--- @param typeNum string Символ типа метки/флажка
--- @param xSpacing number Горизонтальный зазор между кнопками
--- @param ySpacing number Вертикальный зазор между кнопками
--- @return boolean `true` - кнопка успешно размещена, `false` - нет кнопки
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

--- Записывает номер метки кнопки в buttonCharm и задаёт текстуру основной иконки кнопки
--- @param frame string Имя панели
--- @param button Button Кнопка
--- @param buttonNum number Позиция кнопки
--- @param id number Номер метки (0–9) или флажка
--- @param textureID number Индекс текстуры в TC_TEXTURE_PATHS
--- @param o1 number Левая граница кадрирования
--- @param o2 number Правая граница кадрирования
--- @param o3 number Нижняя граница кадрирования
--- @param o4 number Верхняя граница кадрирования
--- @param a1 number Горизонтальный сдвиг иконки относительно центра
--- @param a2 number Вертикальный сдвиг иконки относительно центра
--- @param w number Ширина текстуры
--- @param h number Высота текстуры
function MakeCharm(frame, button, buttonNum, id, textureID, o1, o2, o3, o4, a1, a2, w, h)
    buttonCharm[frame][buttonNum] = id;
    local texture = _G[button:GetName() .. "CharmTex"];
    if texture then
        SetTexture(button, texture, textureID, o1, o2, o3, o4, a1, a2, w, h);
    end
end

--- Задаёт текстуре файл, координаты кадрирования и размер/привязку к центру кнопки
--- @param button Button Кнопка-родитель
--- @param texture Texture Текстура
--- @param textureID number Индекс текстуры в TC_TEXTURE_PATHS
--- @param o1 number Левая граница кадрирования
--- @param o2 number Правая граница кадрирования
--- @param o3 number Нижняя граница кадрирования
--- @param o4 number Верхняя граница кадрирования
--- @param a1 number Горизонтальный сдвиг от центра кнопки
--- @param a2 number Вертикальный сдвиг от центра кнопки
--- @param w number Ширина текстуры
--- @param h number Высота текстуры
function SetTexture(button, texture, textureID, o1, o2, o3, o4, a1, a2, w, h)
    texture:ClearAllPoints();
    texture:SetWidth(w);
    texture:SetHeight(h);
    texture:SetTexture(texturePaths[textureID]);
    texture:SetTexCoord(o1, o2, o3, o4);
    texture:SetPoint("CENTER", button, "CENTER", 0, 0);
end

--- Устанавливает масштаб фрейма-контейнера панели
--- @param scale number Новый масштаб (0.5–3.0)
--- @param id number Индекс панели в TC_FRAME_NAMES (1/3/5)
function SetFrameScale(scale, id)
    local tmpFrame = _G[frameNames[id]];
    tmpFrame:SetScale(scale);
end
