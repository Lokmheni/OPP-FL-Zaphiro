function[adjacency_matrix] = Adjacency_matrix_computation(n_nodes, n_edges, idx_from, idx_to)
% Initialize the adjacency matrix with zeros
adjacency_matrix = zeros(n_edges, n_nodes);

% Iterate through each edge and set the adjacency matrix entry
for i = 1:n_edges
    from_node = idx_from(i);
    to_node = idx_to(i);
    adjacency_matrix(i, to_node) = -1; 
    adjacency_matrix(i, from_node) = +1;
end