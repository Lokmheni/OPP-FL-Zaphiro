function [span_trees_matrix_PMU_root] = compute_span_trees_matrix_PMU_root(PMU_node_one, PMU_node_two, span_trees_root_impedance_matrix, idx_from, idx_line, n_spanning_trees,n_lines, spanning_trees_matrix)

span_trees_matrix_PMU_root = span_trees_root_impedance_matrix;

max_line = compute_max_line_bis(PMU_node_one, idx_from, idx_line, n_spanning_trees,n_lines, spanning_trees_matrix);
second_option_two = 0;
for j = 1:1:length(idx_from)
    if idx_from(j) == PMU_node_two && j ~= PMU_node_two
        second_option_two = idx_line(j);
        break
    end
end

for s= n_spanning_trees:-1:1
    if second_option_two ~= 0 && (spanning_trees_matrix(s, PMU_node_two) || spanning_trees_matrix(s, second_option_two))
        span_trees_matrix_PMU_root(s,:) = [];
        row = span_trees_root_impedance_matrix(s,:);
        for i = 1:1:n_lines
            if i >= PMU_node_two
                row(i) = 0;
            end
        end
        span_trees_matrix_PMU_root = vertcat(span_trees_matrix_PMU_root, row);
    end
end


for j = 1:1:n_lines
    if j < PMU_node_one || j > max_line
        span_trees_matrix_PMU_root(:, j) = 0;
    end
end
