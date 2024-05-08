function[spanning_trees_impedance_matrix_opt_one, spanning_trees_impedance_matrix_opt_two] = spanning_trees_impedance_matrix_computation (span_trees_root_impedance_matrix, PMU_nodes, n_spanning_trees, n_lines, idx_line, idx_from)
% spanning_trees_impedance_matrix = span_trees_root_impedance_matrix;


%spanning_trees_impedance_matrix = zeros(n_spanning_trees, n_lines, length(PMU_nodes));

for i = length(PMU_nodes):-1:1
    disp(i);
    if PMU_nodes(i) == 1
       spanning_trees_impedance_matrix_opt_one{i} = span_trees_root_impedance_matrix;
       spanning_trees_impedance_matrix_opt_two{i} = [];
    else
        spanning_trees_impedance_matrix_opt_one{i} = span_trees_root_impedance_matrix(:,PMU_nodes(i):n_lines);
        for s=1:1:n_spanning_trees
            if span_trees_root_impedance_matrix(s, PMU_nodes(i)) == 0
                spanning_trees_impedance_matrix_opt_one{i}(s,:) = zeros(1, length(spanning_trees_impedance_matrix_opt_one{i}));
            end
        end

        for j = 1:1:length(idx_from)
            if idx_from(j) == PMU_nodes(i)
                if j ~= PMU_nodes(i)
                    second_option = idx_line(j);
                end
            end
        end
        %second_option = idx_line(PMU_nodes(i));
        disp(second_option);
        spanning_trees_impedance_matrix_opt_two{i} = span_trees_root_impedance_matrix(:,second_option:n_lines);
        for s=1:1:n_spanning_trees
            if span_trees_root_impedance_matrix(s, second_option) == 0
                spanning_trees_impedance_matrix_opt_two{i}(s,:) = zeros(1, length(spanning_trees_impedance_matrix_opt_two{i}));
            end
        end
    end
end