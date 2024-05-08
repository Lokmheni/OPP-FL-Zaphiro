function[new_spanning_trees_matrix] = Z_tilde_matrix_computation(idx_from, idx_to, idx_line, span_trees_impedance_matrix, spanning_trees_matrix, PMU_node, n_nodes, n_lines, n_spans)

Z_tilde = span_trees_impedance_matrix;
new_spanning_trees_matrix = Z_tilde;

lines = uint32.empty;
% 

    % for i = n_lines:-1:1 % Traverse the table from bottom to top
    %     % 
    %     from_bus = idx_from(i);
    %     to_bus = idx_to(i);
    % 
    %   if j == from_bus
    %       line = idx_line(i);
    %       lines(end+1) = line;
    %   end
    % end
% disp(lines);

new_spanning_trees_matrix(:, 1:PMU_node-1) = 0;
    
%disp(['Z_tilde for PMU placement at node ', int2str(PMU_node)]);
%disp(new_spanning_trees_matrix);

end



