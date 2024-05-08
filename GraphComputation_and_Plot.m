function [G] = GraphComputation_and_Plot(data)

% Extract edge labels as cell array of character vectors
edge_labels = cellstr(num2str(data{:, 1}));

% Create an empty directed graph
G = digraph();

% Add edges to the graph and assign labels
for i = 1:size(data, 1)
    from_bus = data{i, 2};
    to_bus = data{i, 3};
    weight = data{i, 4};
    G = addedge(G, from_bus, to_bus, weight);
end

h = plot(G);
labeledge(h,data{:, 2},data{:, 3}, edge_labels);

% Rotate the figure
view(-90, 90); % Adjust the angles as needed