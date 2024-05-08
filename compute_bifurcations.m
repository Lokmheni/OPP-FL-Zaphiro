function [bifurcation_points, binary] = compute_bifurcations(idx_from)
    % Find unique indices and their counts
    [unique_indices, ~, idx_counts] = unique(idx_from);
    counts = accumarray(idx_counts, 1);

    % Find indices with more than one occurrence
    potential_bifurcations = unique_indices(counts > 1);

    % Initialize bifurcation points array
    bifurcation_points = [];

    % Iterate through potential bifurcation points
    for i = 1:numel(potential_bifurcations)
        idx = potential_bifurcations(i);
        occurrences = find(idx_from == idx);

        % Check if the index occurs at multiple positions
        if numel(occurrences) > 1
            bifurcation_points = [bifurcation_points; idx];
        end
    end
    binary = 0;
    % Check if the feeder node (node 1) is already in the bifurcation points array
    if ~any(bifurcation_points == 1)
        binary = 1;
        bifurcation_points = [1; bifurcation_points]; % Add feeder node if not already present
    end

    % Remove duplicates
    bifurcation_points = unique(bifurcation_points);
end
