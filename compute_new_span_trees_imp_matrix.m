function [new_span_trees_imp_matrix] = compute_new_span_trees_imp_matrix(PMU_node, second_option, max_line, n_lines, n_spanning_trees, spanning_trees_impedance_matrix, spanning_trees_matrix)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

new_span_trees_imp_matrix = spanning_trees_impedance_matrix;

for s = 1:1:n_spanning_trees
    if spanning_trees_impedance_matrix(s, PMU_node) ~= 0
        new_span_trees_imp_matrix = [new_span_trees_imp_matrix; spanning_trees_impedance_matrix(s,:)];
        break
    end
end

% disp(new_span_trees_imp_matrix);

for i = size(new_span_trees_imp_matrix, 1)-1:-1:1
    if new_span_trees_imp_matrix(i, PMU_node) ~= 0 || new_span_trees_imp_matrix(i, second_option) ~= 0
        new_span_trees_imp_matrix(i, :) = [];
    end
end

% disp(new_span_trees_imp_matrix);

new_span_trees_imp_matrix(:,PMU_node:max_line) = [];
new_span_trees_imp_matrix = flipud(new_span_trees_imp_matrix);
% disp(new_span_trees_imp_matrix);