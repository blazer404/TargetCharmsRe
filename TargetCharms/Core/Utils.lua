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
