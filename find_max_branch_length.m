function max_length_spanning_tree = find_max_branch_length(spanning_tree)
    % Providing a radial network, outputs the maximum number of lines in a single spanning tree
    %
    % Parameters:
    % ----------
    % spanning_tree (matrix): Matrix that contains the impedance of every line in a spanning tree. The lines of this matrix correspond to the spanning trees
    %
    % Returns:
    % -------
    % max_length_spanning_tree (int): Number of lines in the longest spanning tree

    max_length_spanning_tree = 0;

    for i = 1:size(spanning_tree, 1)
        sum_val = 0;

        for j = 1:size(spanning_tree, 2)
            if spanning_tree(i, j) > 0
                sum_val = sum_val + 1;
            end
        end

        if sum_val > max_length_spanning_tree
            max_length_spanning_tree = sum_val;
        end
    end
end
