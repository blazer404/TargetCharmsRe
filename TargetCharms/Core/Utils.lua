--- Утилиты общего назначения. Не зависят от специфики аддона и могут использоваться повторно


--- Рекурсивно создаёт `глубокую копию` таблицы
--- @generic T
--- @param t T Копируемая таблица
--- @return T Глубокая копия t
--- @author `Grayhoof` (SCT)
function CloneTable(t)
    -- return a copy of the table t
    local new = {};            -- create a new table
    local i, v = next(t, nil); -- i is an index of t, v = t[i]
    while i do
        if type(v) == "table" then
            v = CloneTable(v);
        end
        new[i] = v;
        i, v = next(t, i); -- get next index
    end
    return new;
end

--- Возвращает количество десятичных знаков шага после запятой
--- @param step number Величина шага (например 0.1, 0.25, 1)
--- @return number Количество знаков после запятой (для шага 0,1 вернет 1, для шага 0.25 - 2, и тд)
function StepDecimals(step)
    local d = 0
    local s = step
    while s - math.floor(s) > 1e-6 do
        d = d + 1
        s = s * 10
    end
    return d
end

--- Ограничивает значение диапазоном и привязывает к кратности шага.
--- Используется для ползунков настроек.
--- @param v number Исходное значение
--- @param minValue number Нижняя граница диапазона
--- @param maxValue number Верхняя граница диапазона
--- @param step number Шаг привязки
--- @return number Приведённое значение, округлённое до точности шага
function SnapSliderValue(v, minValue, maxValue, step)
    v = math.max(minValue, math.min(maxValue, v))
    local steps = math.floor((v - minValue) / step + 0.5)
    local value = minValue + steps * step
    return tonumber(string.format("%." .. StepDecimals(step) .. "f", value))
end

--- Возвращает функцию форматирования значений с фиксированным числом знаков.
--- Используется как подпись для ползунков.
--- @param step number Величина шага, определяющая точность вывода
--- @return function Функция (value: number) -> string
function CreateSliderLabelFormatter(step)
    local decimals = StepDecimals(step)
    local fmt = "%." .. decimals .. "f"
    return function(value)
        return string.format(fmt, value)
    end
end
