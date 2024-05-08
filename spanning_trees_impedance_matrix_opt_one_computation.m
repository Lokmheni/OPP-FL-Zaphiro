function[spanning_trees_impedance_matrices] = spanning_trees_impedance_matrix_opt_one_computation (span_trees_root_impedance_matrix, PMU_nodes, n_spanning_trees, n_lines, idx_line, idx_from)

for i = length(PMU_nodes):-1:1
    if PMU_nodes(i) == 1
       spanning_trees_impedance_matrices{i} = span_trees_root_impedance_matrix;
    else
        spanning_trees_impedance_matrices{i} = span_trees_root_impedance_matrix(:,PMU_nodes(i):n_lines);
        for s=1:1:n_spanning_trees
            if span_trees_root_impedance_matrix(s, PMU_nodes(i)) == 0
                spanning_trees_impedance_matrices{i}(s,:) = zeros(1, length(span_trees_root_impedance_matrix(1,PMU_nodes(i):n_lines)));
            end
        end
    end
end