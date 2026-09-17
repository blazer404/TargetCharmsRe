-- Utility functions

--Code by Grayhoof (SCT)
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

function StepDecimals(step)
	local d = 0
	local s = step
	while s - math.floor(s) > 1e-6 do
		d = d + 1
		s = s * 10
	end
	return d
end

function SnapSliderValue(v, minValue, maxValue, step)
	v = math.max(minValue, math.min(maxValue, v))
	local steps = math.floor((v - minValue) / step + 0.5)
	local value = minValue + steps * step
	return tonumber(string.format("%." .. StepDecimals(step) .. "f", value))
end

function CreateSliderLabelFormatter(step)
	local decimals = StepDecimals(step)
	local fmt = "%." .. decimals .. "f"
	return function(value)
		return string.format(fmt, value)
	end
end
