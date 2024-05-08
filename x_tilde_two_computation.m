function[x_tilde] = x_tilde_two_computation(spanning_trees_matrices_opt2, n_spanning_trees, x_FL, n_lines, PMU_nodes, i, idx_from, idx_line, spanning_trees_matrix)

PMU_node = PMU_nodes(i);    
second_option = 0;
max_line = 0;

for j = 1:1:length(idx_from)
    if idx_from(j) == PMU_node && j ~= PMU_node
        second_option = idx_line(j);
        break
    end
end
% %disp(second_option);
    
if second_option ~= 0
    for s = 1:1:n_spanning_trees
        for l = n_lines:-1:1
            if spanning_trees_matrix(s,second_option) == 1 && spanning_trees_matrix(s,l) == 1
                max_line = l;
                break;
            end
        end
    end
end

range = (n_lines - length(spanning_trees_matrices_opt2(1,:)) + 1):n_lines;

x_tilde = spanning_trees_matrices_opt2 * x_FL(range,:); 

x_tilde(:,max_line+1:n_lines) = zeros();
disp(spanning_trees_matrices_opt2);
end
