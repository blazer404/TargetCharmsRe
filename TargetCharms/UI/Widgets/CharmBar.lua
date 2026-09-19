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

--- Создаёт на кнопке слои TextureColor и TextureIcon, используемые для подсветки макросных кнопок
--- @param button Button Кнопка
local function AddMacroTextures(button)
    local textureColor = button:CreateTexture(button:GetName() .. "TextureColor");
    textureColor:SetDrawLayer("BORDER");
    textureColor:SetPoint("TOPLEFT", _G[button:GetName() .. "CharmTex"], "TOPLEFT", 5, -5);
    textureColor:SetPoint("BOTTOMRIGHT", _G[button:GetName() .. "CharmTex"], "BOTTOMRIGHT", -5, 5);
    local textureIcon = button:CreateTexture(button:GetName() .. "TextureIcon");
    textureIcon:SetDrawLayer("OVERLAY");
    textureIcon:SetAllPoints(button);
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
            AddMacroTextures(button);
        end
    elseif isMacro and not _G[button:GetName() .. "TextureColor"] then
        button:SetAttribute("type", "macro")
        button:SetSize(32, 32);
        AddMacroTextures(button);
    end
    if isMacro then
        button:SetSize(32, 32);
    end
    return button;
end

--- Вычисляет максимальную длину разбираемой строки шаблона: чётная, не более `40` символов
--- @param buttonString string Строка-шаблон раскладки
--- @return number Максимальная длина (число символов, кратное двум)
local function GetMaxTemplateLength(buttonString)
    local maxlen = strlen(buttonString);
    if mod(maxlen, 2) == 1 then
        maxlen = maxlen - 1
    end
    if maxlen > 40 then
        maxlen = 40;
    end
    return maxlen;
end

--- Перестраивает панель по строке-шаблону раскладки:
--- по паре символов на каждую кнопку, лишние кнопки скрывает (максимум `20` позиций)
--- @param frameInfo string Имя панели, откуда брать настройки (TargetCharms/FlareCharms)
--- @param frameTarget string Имя панели, куда создавать кнопки
function SetupButtons(frameInfo, frameTarget)
    local buttonString = TargetCharms_Options[frameInfo]["buttonTemplate"];
    local maxlen = GetMaxTemplateLength(buttonString);

    local buttonNum = 1;

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

--- Параметры иконки метки цели по символу типа (`0`–`9`): номер метки, индекс текстуры и её кадрирование
--- @type table<string, { id:number, textureID:number, o1:number, o2:number, o3:number, o4:number, a1:number, a2:number, w:number, h:number }>
local targetCharmSpecs = {
    [TARGETCHARMS_CHARM0] = { id = 0, textureID = 2, o1 = 0.15, o2 = 0.85, o3 = 0.15, o4 = 0.85, a1 = 0, a2 = 0, w = 32, h = 32 },
    [TARGETCHARMS_CHARM1] = { id = 1, textureID = 1, o1 = 0, o2 = 0.25, o3 = 0, o4 = 0.25, a1 = 2, a2 = -2, w = 28, h = 28 },
    [TARGETCHARMS_CHARM2] = { id = 2, textureID = 1, o1 = 0.25, o2 = 0.5, o3 = 0, o4 = 0.25, a1 = 2, a2 = -2, w = 28, h = 28 },
    [TARGETCHARMS_CHARM3] = { id = 3, textureID = 1, o1 = 0.5, o2 = 0.75, o3 = 0, o4 = 0.25, a1 = 2, a2 = -2, w = 28, h = 28 },
    [TARGETCHARMS_CHARM4] = { id = 4, textureID = 1, o1 = 0.75, o2 = 1, o3 = 0, o4 = 0.25, a1 = 2, a2 = -2, w = 28, h = 28 },
    [TARGETCHARMS_CHARM5] = { id = 5, textureID = 1, o1 = 0, o2 = 0.25, o3 = 0.25, o4 = 0.5, a1 = 2, a2 = -2, w = 28, h = 28 },
    [TARGETCHARMS_CHARM6] = { id = 6, textureID = 1, o1 = 0.25, o2 = 0.5, o3 = 0.25, o4 = 0.5, a1 = 2, a2 = -2, w = 28, h = 28 },
    [TARGETCHARMS_CHARM7] = { id = 7, textureID = 1, o1 = 0.5, o2 = 0.75, o3 = 0.25, o4 = 0.5, a1 = 2, a2 = -2, w = 28, h = 28 },
    [TARGETCHARMS_CHARM8] = { id = 8, textureID = 1, o1 = 0.75, o2 = 1, o3 = 0.25, o4 = 0.5, a1 = 2, a2 = -2, w = 28, h = 28 },
    [TARGETCHARMS_CHARM9] = { id = 9, textureID = 4, o1 = 0, o2 = 1, o3 = 0, o4 = 1, a1 = 0, a2 = 0, w = 32, h = 32 },
};

--- Параметры цветного флажка по символу типа: номер флажка, кадрирование иконки, цвет и макрос
--- @type table<string, { id:number, o1:number, o2:number, o3:number, o4:number, r:number, g:number, b:number, macro:string }>
local flareColorSpecs = {
    [TARGETCHARMS_BLUEFLARE] = { id = 1, o1 = 0.25, o2 = 0.5, o3 = 0.25, o4 = 0.5, r = 0, g = .5, b = 1, macro = "/cwm 1\n/wm 1" },
    [TARGETCHARMS_GREENFLARE] = { id = 2, o1 = 0.75, o2 = 1, o3 = 0, o4 = 0.25, r = 0, g = 1, b = .2, macro = "/cwm 2\n/wm 2" },
    [TARGETCHARMS_PURPLEFLARE] = { id = 3, o1 = 0.5, o2 = 0.75, o3 = 0, o4 = 0.25, r = .5, g = 0, b = 1, macro = "/cwm 3\n/wm 3" },
    [TARGETCHARMS_REDFLARE] = { id = 4, o1 = 0.5, o2 = 0.75, o3 = 0.25, o4 = 0.5, r = 1, g = 0, b = 0, macro = "/cwm 4\n/wm 4" },
    [TARGETCHARMS_YELLOWFLARE] = { id = 5, o1 = 0, o2 = 0.25, o3 = 0, o4 = 0.25, r = 1, g = 1, b = 0, macro = "/cwm 5\n/wm 5" },
    [TARGETCHARMS_ORANGEFLARE] = { id = 6, o1 = 0.25, o2 = 0.5, o3 = 0, o4 = 0.25, r = 1, g = .5, b = 0, macro = "/cwm 6\n/wm 6" },
    [TARGETCHARMS_SILVERFLARE] = { id = 7, o1 = 0, o2 = 0.25, o3 = 0.25, o4 = 0.5, r = .5, g = .5, b = .5, macro = "/cwm 7\n/wm 7" },
    [TARGETCHARMS_WHITEFLARE] = { id = 8, o1 = 0.75, o2 = 1, o3 = 0.25, o4 = 0.5, r = 1, g = 1, b = 1, macro = "/cwm 8\n/wm 8" },
};

--- Настраивает кнопку панели меток цели по символу типа: иконка, видимость и макрос `/tm`
--- @param frame string Имя панели (TargetCharms)
--- @param buttonNum number Номер кнопки
--- @param typeNum string Символ типа метки (`0`–`9` или неизвестный)
--- @return Button Кнопка
local function FormatTargetCharm(frame, buttonNum, typeNum)
    local button = MakeButton(frame, buttonNum, false);
    local spec = targetCharmSpecs[typeNum];
    if spec then
        MakeCharm(frame, button, buttonNum, spec.id, spec.textureID, spec.o1, spec.o2, spec.o3, spec.o4, spec.a1, spec.a2, spec.w, spec.h);
        button:Show();
    else
        button:Hide();
    end
    local charmId = buttonCharm[frame][buttonNum];
    if charmId and charmId >= 0 then
        button:SetAttribute("type", "macro")
        button:SetAttribute("macrotext", "/tm " .. charmId);
    end
    return button;
end

--- Настраивает кнопку-драг панели меток на земле; создаёт, если ещё не создана
--- @param frame string Имя панели (FlareCharms)
--- @param buttonNum number Номер кнопки
--- @return Button Кнопка
local function FormatFlareDrag(frame, buttonNum)
    local button = _G[frame .. "Charm" .. buttonNum];
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
    return button;
end

--- Настраивает кнопку-очистку цветных флажков
--- @param frame string Имя панели (FlareCharms)
--- @param button Button Кнопка
--- @param buttonNum number Номер кнопки
--- @return Button Кнопка
local function FormatFlareClear(frame, button, buttonNum)
    MakeCharm(frame, button, buttonNum, 0, 2, 0.15, 0.85, 0.15, 0.85, 0, 0, 32, 32);
    SetTexture(button, _G[button:GetName() .. "TextureIcon"], 3, 0, 1, 0, 1, 3, -2, 26, 26);
    _G[button:GetName() .. "TextureColor"]:SetTexture();
    button:SetAttribute("macrotext", "/cwm 1\n/cwm 2\n/cwm 3\n/cwm 4\n/cwm 5\n/cwm 6\n/cwm 7\n/cwm 8");
    button:Show();
    return button;
end

--- Настраивает цветной флажок: иконку (при включённых иконках) и цвет круга
--- @param frame string Имя панели (FlareCharms)
--- @param button Button Кнопка
--- @param buttonNum number Номер кнопки
--- @param spec table Описание флажка из flareColorSpecs
--- @return Button Кнопка
local function FormatFlareColor(frame, button, buttonNum, spec)
    MakeCharm(frame, button, buttonNum, spec.id, 2, 0.15, 0.85, 0.15, 0.85, 0, 0, 32, 32);
    local icon = _G[button:GetName() .. "TextureIcon"];
    if TargetCharms_Options[frameNames[5]]["showicons"] then
        SetTexture(button, icon, 1, spec.o1, spec.o2, spec.o3, spec.o4, 6, -5, 20, 20);
    else
        icon:SetTexture();
    end
    local textureColor = _G[button:GetName() .. "TextureColor"];
    textureColor:SetColorTexture(spec.r, spec.g, spec.b);
    button:SetAttribute("macrotext", spec.macro);
    button:Show();
    return button;
end

--- Настраивает кнопку панели меток на земле по символу типа: драг-кнопка, цветной флажок, очистка или скрытое состояние
--- @param frame string Имя панели (FlareCharms)
--- @param buttonNum number Номер кнопки
--- @param typeNum string Символ типа (`D`/цвета/`X` или неизвестный)
--- @return Button Кнопка
local function FormatFlareCharm(frame, buttonNum, typeNum)
    if typeNum == TARGETCHARMS_DRAG then
        return FormatFlareDrag(frame, buttonNum);
    end

    local button = MakeButton(frame, buttonNum, true);
    if typeNum == TARGETCHARMS_CLEARFLARE then
        return FormatFlareClear(frame, button, buttonNum);
    end

    local spec = flareColorSpecs[typeNum];
    if spec then
        return FormatFlareColor(frame, button, buttonNum, spec);
    end
    button:Hide();
    return button;
end

--- Позиционирует кнопку относительно предыдущей по символу направления
--- @param frame string Имя панели (TargetCharms/FlareCharms)
--- @param button Button Кнопка
--- @param buttonNum number Номер кнопки
--- @param posChar string Символ направления (`^`/`v`/`<`/`>`)
--- @param xSpacing number Горизонтальный зазор между кнопками
--- @param ySpacing number Вертикальный зазор между кнопками
--- @return boolean true - кнопка размещена, false - невалидный символ направления
local function PositionButton(frame, button, buttonNum, posChar, xSpacing, ySpacing)
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
    return true;
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
    local button;
    if frame == frameNames[1] then
        button = FormatTargetCharm(frame, buttonNum, typeNum);
    else
        button = FormatFlareCharm(frame, buttonNum, typeNum);
    end
    if button ~= nil then
        if not PositionButton(frame, button, buttonNum, posChar, xSpacing, ySpacing) then
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
