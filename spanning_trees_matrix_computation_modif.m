function[spanning_trees_matrix_modif] = spanning_trees_matrix_computation_modif(PMU_node, idx_from, idx_to, idx_line, n_spanning_trees, n_lines, n_buses)




% Identify the nodes that correspond to the end of one spanning tree
intermediate_nodes = unique(idx_from_new);
% intermediate_nodes = table2array(intermediate_nodes);
%intermediate_nodes
all_nodes = 1:n_buses';
%all_nodes
end_nodes = setdiff(all_nodes, intermediate_nodes);

% Traverse the spanning trees
for spanning_tree_index = 1:n_spanning_trees
    last_node = end_nodes(spanning_tree_index); % Start from the last node
    %spanning_trees_matrix(spanning_tree_index, last_node) = 0; % Add the last node to the current spanning tree
    
    for i = n_lines_new:-1:1 % Traverse the table from bottom to top
        from_bus = idx_from_new(i);
        to_bus = idx_to(i);
        line = idx_line(i);
        if to_bus == last_node
            last_node = from_bus;
            spanning_trees_matrix_modif(spanning_tree_index, line) = 1;
        end
    end
end