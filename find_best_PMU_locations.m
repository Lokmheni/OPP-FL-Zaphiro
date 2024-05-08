function PMU_placement = find_best_PMU_locations(PMU_nodes, possible_FLs_root, max_possible_FLs_root, span_trees_root_impedance_matrix, PMU_placement, k, n_bifurc, n_lines, n_spanning_trees, spanning_trees_matrix, x_FL, idx_from, idx_line)
    % Loop over all the possible locations to find the set of PMUs such that ∆z = 0 for the specified k. 
    % Adds PMUs one after the other ranking them by the smallest resulting ∆z.

    fprintf("-------- Step 4.2 ------ try to place PMUs and decrease the ∆z\n"); 

    max_iterations = length(PMU_nodes);
    min_max_possible_FLs = max_possible_FLs_root;

    possible_FLs_inter = possible_FLs_root;

    PMU_nodes_inter = PMU_nodes;
    % this is the "main" loop, it represent the number of iterations, installation of additional PMUs, if we add a PMU at every location we get ∆z = 0 by construction
    for i = 1:1:max_iterations
        fprintf("# PMUs required: %d?\n", i+2);

        PMU_position_itermediate = PMU_placement;

        best_new_location = PMU_nodes(1);

        for j = 1:1:length(PMU_nodes_inter) % as we will remove element from "allowed_PMU_locations", be careful
            node = PMU_nodes_inter(j);
            PMU_position_itermediate = [PMU_position_itermediate, node];

            %delta_z = delta_z_calculator_multiple_PMUs(PMU_position_itermediate, span_trees_root_impedance_matrix, k);
            possible_FLs_new = compute_possible_FLs(possible_FLs_inter, n_bifurc,PMU_nodes, n_lines, n_spanning_trees, span_trees_root_impedance_matrix, spanning_trees_matrix, x_FL, idx_from, idx_line);
            max_possible_FLs_new = max(compute_max_possible_FLs(possible_FLs_new));
            
            possible_FLs_inter = possible_FLs_new;
            disp(['Max possible FLs: ' num2str(max_possible_FLs_new)]);
            if min_max_possible_FLs > max_possible_FLs_new
                j_best = j;
                best_new_location = node;
                disp(['Best new Location: ' num2str(node)]);
                min_max_possible_FLs = max_possible_FLs_new;
            end

            PMU_position_itermediate(PMU_position_itermediate == node) = [];
            disp(['PMU_position_intermediate: ' num2str(PMU_position_itermediate)]);
        end
        
        PMU_placement = [PMU_placement, best_new_location];
        if min_max_possible_FLs > max_possible_FLs_new
            PMU_nodes_inter(j) = [];
        end
        disp(min_max_possible_FLs);
        fprintf("PMU_position: ");
        disp(PMU_placement);

        if min_max_possible_FLs == k
            fprintf("\n# PMUs required: %d✅\n", i+2);
            break;
        end
    end

    fprintf("\n-------- Step 4.2:done ------\n");

end
