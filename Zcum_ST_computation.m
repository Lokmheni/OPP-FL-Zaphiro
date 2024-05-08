function[Z_cum_ST] = Zcum_ST_computation(span_trees_impedance_matrix, n_lines, n_spanning_trees)
Zcum_ST = zeros(n_lines);

for i = 1:1:n_spanning_trees
    for j = n_lines:-1:1
        if span_trees_impedance_matrix(i,j) ~= 0
            Z_cum_ST(i,j) = sum(span_trees_impedance_matrix(i,1:j));
        end
    end
end
