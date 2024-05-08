function[x_tilde_one] = x_tilde_one_computation(spanning_trees_matrices_opt1, x_FL, n_lines, PMU_nodes, i)

%x_tilde_one(:,:,i) = zeros(n_spanning_trees, n_lines);

%disp(['PMU node: ' int2str(PMU_nodes(i))]);


PMU_node = PMU_nodes(i);     

% for j = 1:1:length(idx_from)
%     if idx_from(j) == PMU_node && j ~= PMU_node
%         second_option = idx_line(j);
%         break
%     end
% end
% 
% for s = 1:1:n_spanning_trees
%     for l = n_lines:-1:1
%         if spanning_trees_matrix(s,second_option) == 1 && spanning_trees_matrix(s,l) == 1
%             max_line = l;
%             break;
%         end
%     end
% end


range1 = (n_lines - length(spanning_trees_matrices_opt1(1,:)) + 1):n_lines;
%range2 = (n_lines - length(spanning_trees_matrices_opt2(1,:)) + 1):n_lines;

x_tilde_one = spanning_trees_matrices_opt1 * x_FL(range1,:);
%x_tilde_two = spanning_trees_matrices_opt2 * x_FL(range2,:); 

x_tilde_one(:,1:PMU_node-1) = zeros();
%x_tilde_two(:,max_line+1:n_lines) = zeros();

end