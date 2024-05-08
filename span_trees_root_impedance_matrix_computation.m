function[span_tree_impedance_matrix] = span_trees_root_impedance_matrix_computation(spanning_trees_matrix, Zvect_mag)
span_tree_impedance_matrix = spanning_trees_matrix * diag(Zvect_mag);