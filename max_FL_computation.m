function[unique_entries] = max_FL_computation(x_FL, x_tilde_one, n_spanning_trees, x_tilde_two, span_trees_root_impedance_matrix, n_bifurc, PMU_nodes, n_lines, idx_from, idx_line, spanning_trees_matrix)

    for i = 1:1:n_bifurc
        PMU_node = PMU_nodes(i);
        %disp(['PMU node: ' int2str(PMU_nodes(i))]);
        if PMU_node == 1
            x_tilde_one(:,:,i) = span_trees_root_impedance_matrix*x_FL;
            unique_entries_one = zeros(n_bifurc, length(x_tilde_one(1,:,i)));
            
            for j = 1:1:n_lines
                unique_entries_one(i, j) = count_unique_entries(x_tilde_one(:,j, i));
            end
            unique_entries = unique_entries_one;

        else
            % disp(x_tilde_one(:,:,i));
            % disp('Number of possible FLs: ');
            % disp(unique_entries_one(i,:));
            % disp(unique_entries_one(i,:));
            unique_entries_one = zeros(n_bifurc, length(x_tilde_one(1,:,i)));
            unique_entries_two = zeros(n_bifurc, length(x_tilde_two(1,:,i)));
        
            for j = 1:1:n_lines
                unique_entries_one(i, j) = count_unique_entries(x_tilde_one(:,j, i));
                unique_entries_two(i, j) = count_unique_entries(x_tilde_two(:,j, i));
                unique_entries(i,j) = unique_entries_one(i,j);
            end
            [second_option, max_line] = compute_max_line(PMU_node, idx_from, idx_line, n_spanning_trees,n_lines, spanning_trees_matrix);
            % disp(max_line);
            % disp(unique_entries_one);
            % disp(unique_entries_two);
            unique_entries(i,1:PMU_node-1) = unique_entries_one(i,1:PMU_node-1);
            unique_entries(i, second_option:n_lines) = unique_entries_two(i, second_option:n_lines);
            %unique_entries(PMU_node:max_line) = unique_entries_one(PMU_node:max_line);
                    
       end
                % disp(unique_entries_one(i,:));
                % disp(unique_entries_two(i,:));
    end
end


