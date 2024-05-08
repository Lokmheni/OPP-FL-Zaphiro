function [possible_FLs] = compute_possible_FLs(possible_FLs, n_bifurc,PMU_nodes, n_lines, n_spanning_trees, span_trees_root_impedance_matrix, spanning_trees_matrix, x_FL, idx_from, idx_line)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
for i=2:1:n_bifurc
    PMU_node = PMU_nodes(i);
    if PMU_node ~=1
        [~,max_line] = compute_max_line(PMU_node, idx_from, idx_line, n_spanning_trees,n_lines, spanning_trees_matrix);
        for j = 1:1:length(idx_from)
            if idx_from(j) == PMU_node && j ~= PMU_node
                second_option = idx_line(j);
                break
            end
        end
        new_span_trees_imp_matrix{i} = compute_new_span_trees_imp_matrix(PMU_node, second_option, max_line, n_lines, n_spanning_trees, span_trees_root_impedance_matrix, spanning_trees_matrix);
        x_FL_new{i} = x_FL;
        rowIndices = PMU_node:max_line;
        colIndices = PMU_node:max_line;
        
        % Remove the submatrix
        x_FL_new{i}(rowIndices, :) = [];
        x_FL_new{i}(:, colIndices) = [];

        x_tilde_new{i} = new_span_trees_imp_matrix{i} * x_FL_new{i};

        unique_entries_new{i} = zeros(1, size(x_tilde_new{i}, 2));

        for j = 1:1:size(new_span_trees_imp_matrix{i},2)
            unique_entries_new{i}(1,j) = count_unique_entries(x_tilde_new{i}(:,j));
        end
        %disp(unique_entries_new{2});
        if max_line ~= n_lines && max_line ~= 0
            possible_FLs(i, 1:PMU_node-1) = unique_entries_new{i}(1:PMU_node-1);
            possible_FLs(i, max_line+1:n_lines) = unique_entries_new{i}(PMU_node:end);
        else
            possible_FLs(i, 1:PMU_node-1) = unique_entries_new{i}(1:PMU_node-1);
            %possible_FLs(i, max_line+1:n_lines) = unique_entries_new(PMU_node:end);
        end
        disp(possible_FLs);
    end
end
end