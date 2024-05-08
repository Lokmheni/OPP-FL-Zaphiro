function unique_count = count_unique_entries(arr)
    nonZeroValues = arr(arr ~= 0);
    unique_values = unique(nonZeroValues);
    unique_count = length(unique_values);
end