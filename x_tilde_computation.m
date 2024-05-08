function[x_tilde] = x_tilde_computation(n_spanning_trees, n_lines, n_bifurc, PMU_nodes)

x_tilde_one = zeros(n_spanning_trees, n_lines, n_bifurc);

    %disp(['PMU node: ' int2str(PMU_nodes(i))]);
    if PMU_nodes(i) == 1
        x_tilde_one(:,:,i) = span_trees_root_impedance_matrix*x_FL;
    else
    
        PMU_node = PMU_nodes(i);     
    
        for j = 1:1:length(idx_from)
            if idx_from(j) == PMU_nodes(i) && j ~= PMU_nodes(i)
                second_option = idx_line(j);
                break
            end
        end
    
        for s = 1:1:n_spanning_trees
            for l = n_lines:-1:1
                if spanning_trees_matrix(s,second_option) == 1 && spanning_trees_matrix(s,l) == 1
                    max_line = l;
                    break;
                end
            end
        end
    
    
        range1 = (n_lines - length(spanning_trees_matrices_opt1{i}(1,:)) + 1):n_lines;
        range2 = (n_lines - length(spanning_trees_matrices_opt2{i}(1,:)) + 1):n_lines;
        
        x_tilde_one(:,:,i) = spanning_trees_matrices_opt1{i} * x_FL(range1,:);
        x_tilde_two(:,:,i) = spanning_trees_matrices_opt2{i} * x_FL(range2,:); 
    
        x_tilde_one(:,1:PMU_nodes(i)-1,i) = zeros();
        x_tilde_two(:,max_line+1:n_lines,i) = zeros();

    end
x_tilde{1} = x_tilde_one;
x_tilde{2} = x_tilde_two;
end