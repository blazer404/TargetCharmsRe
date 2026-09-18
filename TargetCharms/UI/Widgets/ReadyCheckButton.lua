--- Кнопка проверки готовности
--- Применяет сохранённые позицию/масштаб/прозрачность кнопки готовности, подгоняет её размер под длину текста


---@type string[]
local frameNames = TC_FRAME_NAMES;

--- Подгоняет размер кнопки и контейнера под ширину/высоту текста с учётом отступов
function AutoSizeReadyButton()
    local button = _G[frameNames[3]]
    local parent = _G[frameNames[4]]
    local fs = button:GetFontString()
    if not fs then return end
    local textWidth = fs:GetStringWidth() or 0
    local textHeight = fs:GetStringHeight() or 0
    if textHeight == 0 then
        textHeight = 12
    end
    local padX, padY = 12, 8
    local width = math.ceil(textWidth) + padX * 2
    local height = math.ceil(textHeight) + padY * 2
    if textWidth == 0 then
        width = height
    end
    button:SetWidth(width)
    button:SetHeight(height)
    parent:SetWidth(width)
    parent:SetHeight(height)
    fs:ClearAllPoints()
    fs:SetPoint("CENTER", button, "CENTER", 0, -1)
end

--- Расставляет кнопку готовности по сохранённой позиции, задаёт масштаб, текст и запускает авторазмер после отрисовки
function SetUpReadyButton()
    local tmpFrame = _G[frameNames[4]];
    if (TargetCharms_Options[frameNames[3]]["X"] ~= nil) then
        _G[frameNames[4]]:ClearAllPoints();
        _G[frameNames[4]]:SetPoint("BOTTOMLEFT", TargetCharms_Options[frameNames[3]]["X"], TargetCharms_Options[frameNames[3]]["Y"]);
    else
        _G[frameNames[4]]:ClearAllPoints();
        _G[frameNames[4]]:SetPoint("TOPLEFT", _G["UIParent"], "TOP", 0, 0);
    end
    tmpFrame:SetAlpha(TargetCharms_Options[frameNames[3]]["alphaVal"]);
    tmpFrame = _G[frameNames[3]];
    tmpFrame:SetScale(TargetCharms_Options[frameNames[3]]["barscale"]);
    tmpFrame:SetText(TargetCharms_Options[frameNames[3]]["text"]);
    C_Timer.After(0, AutoSizeReadyButton);
end
