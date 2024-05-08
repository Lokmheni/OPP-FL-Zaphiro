function [max_line] = compute_max_line_bis(PMU_node, idx_from, idx_line, n_spanning_trees,n_lines, spanning_trees_matrix)

for j = 1:1:length(idx_from)
    if idx_from(j) == PMU_node && j ~= PMU_node
        second_option = idx_line(j);
        break
    end
end

for s = 1:1:n_spanning_trees
    for l = n_lines:-1:1
        if spanning_trees_matrix(s,PMU_node) == 1 && spanning_trees_matrix(s,l) == 1
            max_line = l;
            break;
        end
    end
end

end