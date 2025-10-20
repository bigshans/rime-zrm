function drop_duplicate_filter(input)
    local ws = {}
    for cand in input:iter() do
        if ws[cand.text] == nil then
            ws[cand.text] = 1
            yield(cand)
        end
    end
end

return drop_duplicate_filter
