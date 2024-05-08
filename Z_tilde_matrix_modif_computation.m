function[Z_tilde_modif] = Z_tilde_modif_computation(idx_from, idx_to, idx_line, span_trees_impedance_matrix, spanning_trees_matrix, PMU_node, n_buses, n_lines, n_spanning_trees)

n_span_new = find_max_branch_length(span_trees_impedance_matrix);

Z_tilde_modif = zeros(n_span_new);
