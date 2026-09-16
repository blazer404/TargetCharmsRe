TARGETCHARMS_DB_VERSION = "1.6.4";

local frameNames = TARGETCHARMS_FRAME_NAMES;

Defaults = {
    ["TargetCharms"] = {
        ["X"] = nil,
        ["Y"] = nil,
        ["enabled"] = true,
        ["partyOnly"] = false,
        ["barscale"] = 1.0,
        ["Xspacing"] = 0,
        ["Yspacing"] = 0,
        ["draggable"] = true,
        ["toggleicon"] = false,
        ["alphaVal"] = 0.5,
        ["showontarget"] = true,
        ["buttonTemplate"] = TargetCharms_LayoutDefaults[1][2],
    },
    ["ReadyCharm"] = {
        ["X"] = nil,
        ["Y"] = nil,
        ["enabled"] = true,
        ["partyOnly"] = false,
        ["barscale"] = 1.0,
        ["draggable"] = true,
        ["alphaVal"] = 0.5,
        ["width"] = 60,
        ["text"] = TARGETCHARMS_READYCHECK_TEXT,
    },
    ["FlareCharms"] = {
        ["X"] = nil,
        ["Y"] = nil,
        ["enabled"] = true,
        ["partyOnly"] = false,
        ["barscale"] = 1.0,
        ["draggable"] = true,
        ["alphaVal"] = 0.5,
        ["Xspacing"] = 0,
        ["Yspacing"] = 0,
        ["showicons"] = false,
        ["buttonTemplate"] = Flare_LayoutDefaults[1][2],
    },

};

--Code by Grayhoof (SCT)
function CloneTable(t)
    -- return a copy of the table t
    local new = {};                    -- create a new table
    local i, v = next(t, nil);        -- i is an index of t, v = t[i]
    while i do
        if type(v) == "table" then
            v = CloneTable(v);
        end
        new[i] = v;
        i, v = next(t, i);            -- get next index
    end
    return new;
end

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

function CopyOldValues(t, f)
    local temp = CloneTable(t);
    CopyValues(temp, f);
    return temp;
end

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
