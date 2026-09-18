--- Работа с SavedVariables:
--- копирование настроек между профилем персонажа и глобальным профилем,
---а также приведение масштаба/прозрачности к допустимым значениям


--- @type string[]
local frameNames = TC_FRAME_NAMES;

--- Копирует настройки из таблицы `f` в таблицу `t` для трёх панелей.
--- @param t table Целевая таблица (куда копируем)
--- @param f table Источник (откуда копируем)
--- @return table t с перенесёнными значениями
function CopyValues(t, f)
    if (f ~= nil) then
        for i = 1, 5, 2 do
            --if ( f[frameNames[i]]~=nil) then
            for key, value in pairs(f[frameNames[i]]) do
                t[frameNames[i]][key] = value;
            end
            --end
        end
    end
    return t;
end

--- Глубокая копия `t`, в которую затем переносятся значения из `f`.
--- Используется для импорта глобального профиля в персонажа.
--- @param t table База для копии
--- @param f table Источник значений поверх копии
--- @return table Новая таблица с объединёнными значениями
function CopyOldValues(t, f)
    local temp = CloneTable(t);
    CopyValues(temp, f);
    return temp;
end

--- Нормализует `диапазоны` слайдеров и `шаг` изменения значения
--- * прозрачность - 0.1–1.0
--- * масштаб - 0.5–3.0
--- * шаг - 0.1 для всех
function NormalizeOptionValues()
    for _, block in ipairs({ frameNames[1], frameNames[3], frameNames[5] }) do
        local alpha = TargetCharms_Options[block]["alphaVal"] or 0
        if alpha < 0.1 then
            TargetCharms_Options[block]["alphaVal"] = 0.1
        elseif alpha > 1.0 then
            TargetCharms_Options[block]["alphaVal"] = 1.0
        end
        local scale = TargetCharms_Options[block]["barscale"] or 1.0
        scale = math.max(0.5, math.min(3.0, scale))
        scale = math.floor((scale - 0.5) / 0.1 + 0.5) * 0.1 + 0.5
        TargetCharms_Options[block]["barscale"] = tonumber(string.format("%.1f", scale))
    end
end
