%% main script for OPP-FL Zaphiro

clear;
close all;

disp(' ');
disp('*************************************************************');
disp('Optimal PMU Placement (OPP) for Fault Location (FL) - Zaphiro');
disp('*************************************************************');
disp(' ');
disp('May 2024');
disp(' ');

%%  Step 1: Data Loading and preprocessing
disp('STEP 1: Data Loading and preprocessing');
disp(' ');

% Load tab-separated data from file  - choose your desired Test Grid
linedata = load('DATA/Grid parameters S-EG.txt', 'FileType', 'text', 'Delimiter', '\t');
% linedata = load('DATA/Grid parameters E-F.txt', 'FileType', 'text', 'Delimiter', '\t');
% linedata = load('DATA/Grid parameters E-L.txt', 'FileType', 'text', 'Delimiter', '\t');
% linedata = load('DATA/Grid parameters N-J18J19.txt', 'FileType', 'text', 'Delimiter', '\t');
% linedata = load('DATA/Grid parameters S-BM.txt', 'FileType', 'text', 'Delimiter', '\t');
% linedata = load('DATA/Grid parameters S-BN.txt', 'FileType', 'text', 'Delimiter', '\t');
% linedata = load('DATA/Grid parameters S-ET.txt', 'FileType', 'text', 'Delimiter', '\t');
% linedata = readtable('DATA/Grid parameters IEEE 34.txt', 'FileType', 'text', 'Delimiter', '\t');

disp('Loading line parameters...');
disp(' ');

idx_line    = linedata(:,1);
idx_from    = linedata(:,2);
idx_to      = linedata(:,3);
l           = linedata(:,4);
R_prime     = linedata(:,5);
X_prime     = linedata(:,6);
B_prime     = linedata(:,7);
R_0         = linedata(:,8);
X_0         = linedata(:,9);
B_0         = linedata(:,10);
ampacity    = linedata(:,11);

disp('Printing data...');
disp('');
% Print the data 
%linedata = RenameVars(linedata);
% Uncomment to see the table containing the lines values 
%disp(linedata)

% Extract information
n_lines = length(idx_from);                                                % number of lines
n_buses = max([idx_from;idx_to]);                                          % number of nodes
n_spanning_trees = n_buses - height(unique(idx_from));                     % number of spanning trees
disp(['The network consists of ' int2str(n_buses) ' buses, ' ...
    int2str(n_lines), ' lines and ' ...
    int2str(n_spanning_trees), ' spanning trees.']);
disp(' ');


% Compute and Plot the Graph associated with the network
disp('Computing and displaying the Graph associated with the network...');
disp('');
table = table(idx_line, idx_from, idx_to, l, R_prime, X_prime, B_prime, R_0, X_0, B_0, ampacity);
G = GraphComputation_and_Plot(table);

%% Step 2: Basic Computations

% Spanning Trees Matrix Computation

disp('Spanning Trees Matrix Computation');
disp('');

spanning_trees_matrix = spanning_trees_matrix_computation(idx_from, idx_to, idx_line, n_spanning_trees, n_lines, n_buses);

disp('Spanning Trees Matrix: number of spanning trees x number of buses');

disp(spanning_trees_matrix);
disp(['Dimensions: ' num2str(size(spanning_trees_matrix))]);

% Zbus Matrix Computation -- Please note that shunt admittances are neglected and only branch elements are considered

% Adjacency matrix computation
disp('Adjacency Matrix computation');
disp('');

adjacency_matrix = Adjacency_matrix_computation(n_buses, n_lines, idx_from, idx_to);

disp('Adjacency Matrix: number of branches x number of buses')
disp(adjacency_matrix);
disp(['Dimensions: ' num2str(size(adjacency_matrix))]);

Zbus = compute_Zbus(n_buses, n_lines, idx_from, idx_to, R_prime, X_prime, l, B_prime, R_0, X_0, B_0);
disp('Zbus Matrix:');
disp(Zbus);
disp(['Dimensions: ' num2str(size(Zbus))]);

% Zvect computation: 1xn_lines vector containing in element i the impedance of line i
Zvect = compute_Zvect(n_buses, n_lines, idx_from, idx_to, R_prime, X_prime, l, B_prime, R_0, X_0, B_0);
disp('Vector Zvect (containing at entry i the complex impedance of line i):');
disp(['Dimensions: ' num2str(size(Zvect))]);
disp(Zvect);

disp('Vector Zvect_mag (containing at entry i the magnitude of the impedance of line i):');
Zvect_mag = compute_Zvect_mag(n_buses, n_lines, idx_from, idx_to, R_prime, X_prime, l, B_prime, R_0, X_0, B_0);
disp(['Dimensions: ' num2str(size(Zvect_mag))]);
disp(Zvect_mag);

span_trees_root_impedance_matrix = span_trees_root_impedance_matrix_computation(spanning_trees_matrix, Zvect_mag);
disp('Spanning Trees Root impedance matrix');
disp(['Dimensions: ' num2str(size(span_trees_root_impedance_matrix))]);
disp(span_trees_root_impedance_matrix);

Zcum_ST = Zcum_ST_computation(span_trees_root_impedance_matrix, n_lines, n_spanning_trees);
disp('"Cumulative" Spanning Trees impedance matrix');
disp(['Dimensions: ' num2str(size(Zcum_ST))]);
disp(Zcum_ST);

%% PMU Placement Matrix

%% Find bifurcations
PMU_nodes = compute_bifurcations(idx_from);               % The selected "candidate" nodes for PMU placements are at the bifurcations
disp('Looking for bifurcations...');
n_bifurc = length(PMU_nodes);
disp(['Number of bifurcations: ' num2str(n_bifurc)]);
disp("Candidate buses for PMU placements: ");
disp(PMU_nodes);
disp(['Dimensions: ' num2str(size(PMU_nodes))]);

%%
spanning_trees_matrices_opt1 = spanning_trees_impedance_matrix_opt_one_computation(span_trees_root_impedance_matrix, PMU_nodes, n_spanning_trees, n_lines, idx_line, idx_from);
spanning_trees_matrices_opt2 = spanning_trees_impedance_matrix_opt_two_computation(span_trees_root_impedance_matrix, PMU_nodes, n_spanning_trees, n_lines, idx_line, idx_from);

disp('Spanning Trees matrices depending on PMU position')
for i = 1:1:length(PMU_nodes)
    PMU_node = PMU_nodes(i);
    disp(['PMU at node ' int2str(PMU_node)]);
    disp('Option 1:');
    disp(spanning_trees_matrices_opt1{i});
    disp('Option 2:');
    disp(spanning_trees_matrices_opt2{i});

end

%%
% for i = 1:1:length(PMU_nodes)
%     PMU_node = PMU_nodes(i);
%     max_line = compute_max_line(PMU_node, idx_from, idx_line, n_spanning_trees,n_lines, spanning_trees_matrix);
% end

% 
% Z_tilde_matrix = zeros(n_spanning_trees, n_lines, n_bifurc);
% for i=1:length(PMU_nodes)
%     PMU_node = PMU_nodes(i);
%     Z_tilde_matrix(:,:,i) = Z_tilde_matrix_computation(idx_from, idx_to, idx_line, span_trees_root_impedance_matrix, spanning_trees_matrix, PMU_node, n_buses, n_lines, n_spanning_trees);
%     disp(['PMU at node ' ...
%         int2str(PMU_node), '. Z_tilde = ']);
%     disp(Z_tilde_matrix(:,:,i));
%     disp('');
% end

% for i=1:length(PMU_nodes)
%     PMU_node = PMU_nodes(i);
%     Z_tilde_matrix(:,:,i) = Z_tilde_matrix_modif_computation(idx_from, idx_to, idx_line, span_trees_impedance_matrix, spanning_trees_matrix, PMU_node, n_buses, n_lines, n_spanning_trees);
%     disp(['PMU at node ' ...
%         int2str(PMU_node), '. Z_tilde = ']);
%     disp(Z_tilde_matrix(:,:,i));
%     disp('');
% end

% Fault Location Vectors
 
disp('Fault location vectors matrix:');
x_FL = FL_matrix_computation(idx_from, n_lines, idx_line, spanning_trees_matrix, span_trees_root_impedance_matrix, n_spanning_trees, Zvect, Zvect_mag, Zcum_ST);
disp(['Dimensions: ' num2str(size(x_FL))]);
disp(x_FL);
% 
%% Fault Location uniqueness vectors --- Single PMU cases
for i = 1:1:n_bifurc
    PMU_node = PMU_nodes(i);
    if PMU_node == 1
        x_tilde_one(:,:,i) = span_trees_root_impedance_matrix*x_FL;
    else
        x_tilde_one(:,:,i) = x_tilde_one_computation(spanning_trees_matrices_opt1{i}, x_FL, n_lines, PMU_nodes, i);        
        x_tilde_two(:,:,i) = x_tilde_two_computation(spanning_trees_matrices_opt2{i}, n_spanning_trees, x_FL, n_lines, PMU_nodes, i, idx_from, idx_line, spanning_trees_matrix);
    end
end

possible_FLs_basic = max_FL_computation(x_FL, x_tilde_one, n_spanning_trees, x_tilde_two, span_trees_root_impedance_matrix, n_bifurc, PMU_nodes, n_lines, idx_from, idx_line, spanning_trees_matrix);

%% Display Intermediate Results
disp('************Intermediate Results*****************')
for i = 1:1:n_bifurc
    PMU_node = PMU_nodes(i);
    disp(['PMU at node ' num2str(PMU_nodes(i))]);
    disp('Number of possible FLs: ');
    disp(possible_FLs_basic(i,:));
    disp('');
end

%% Basic configuration: PMU at feeder and 1 PMU in another bifurcation node
possible_FLs = possible_FLs_basic;
possible_FLs_root = possible_FLs(1,:);
max_possible_FLs_root = compute_max_possible_FLs(possible_FLs_root);
possible_FLs = compute_possible_FLs(possible_FLs, n_bifurc,PMU_nodes, n_lines, n_spanning_trees, span_trees_root_impedance_matrix, spanning_trees_matrix, x_FL, idx_from, idx_line);
max_possible_FLs_two_PMUs = compute_max_possible_FLs(possible_FLs);

%% Display Results

disp('**********Results using PMU at feeder plus one more PMU****************')
for i = 1:1:n_bifurc
    PMU_node = PMU_nodes(i);
    disp(['PMU at feeder and node ' num2str(PMU_nodes(i))]);
    disp('Number of possible FLs: ');
    disp(possible_FLs(i,:));
    disp('');
    disp(['Maximum number of FLs: ' num2str(max_possible_FLs_two_PMUs(i))]);
    disp('');
end

%% TEST feeder plus 2 PMUs

k = 3;      % number of possible FLs allowed

combination = 0;

for i = n_bifurc:-1:2
    PMU_node_one = PMU_nodes(i);
    for j = 2:1:n_bifurc
        PMU_node_two = PMU_nodes(j);
        if PMU_node_one < PMU_node_two
            combination = combination + 1;
            span_trees_matrix_PMU_root = compute_span_trees_matrix_PMU_root(PMU_node_one, PMU_node_two, span_trees_root_impedance_matrix, idx_from, idx_line, n_spanning_trees,n_lines, spanning_trees_matrix);
            x_FL_test = x_FL;
            [~, max_line_two] = compute_max_line(PMU_node_two, idx_from, idx_line, n_spanning_trees,n_lines, spanning_trees_matrix);
            x_FL_test(PMU_node_two:max_line_two, PMU_node_two:max_line_two) = 0;
            x_test = span_trees_matrix_PMU_root*x_FL_test;
            [second_option_PMU_node_one, ~] = compute_max_line(PMU_node_one, idx_from, idx_line, n_spanning_trees,n_lines, spanning_trees_matrix);
            possible_FLs_double_PMU = possible_FLs(i,:);
            for l = PMU_nodes(j-1):1:PMU_node_two    % linea che finisce nel nodo che viene prima della bifurcation prima di PMU_node_two
                entries = count_unique_entries(x_test(:,l));
                possible_FLs_double_PMU(l) = entries;
            end
            if max_line_two ~= 0
                for l = max_line_two:1:second_option_PMU_node_one-1
                    entries = count_unique_entries(x_test(:,l));
                    possible_FLs_double_PMU(l) = entries;
                end
    
                for l = PMU_node_two:1:max_line_two
                    possible_FLs_double_PMU(l) = possible_FLs(j, l);
                end
            end
            max_possible_FLs_two_PMUs(combination) = compute_max_possible_FLs(possible_FLs_double_PMU);
            sum_possible_FLs(combination) = sum(possible_FLs_double_PMU);

            disp(['PMU at feeder plus PMU at node ' num2str(PMU_node_one) ...
                ' and PMU at node ' num2str(PMU_node_two)])
            disp(possible_FLs_double_PMU);
            disp(['Maximum: ' num2str(max_possible_FLs_two_PMUs(combination)) ' possible FLs in a single line']);
            disp(['Total possible FLs: ' num2str(sum_possible_FLs(combination))]);
            

            if combination == 1
                best = sum_possible_FLs(1);
                best_combination = [PMU_node_one, PMU_node_two];
                best_PMU_one = PMU_node_one;
                best_PMU_two = PMU_node_two;
            end


            if max_possible_FLs_two_PMUs(combination) <= k
                disp(['Two PMUs and one at feeder are needed to obtain at maximum ' num2str(max_possible_FLs_two_PMUs(combination)) ' possible FLs']);
                if sum_possible_FLs(combination) < best
                    best = sum_possible_FLs(combination);
                    best_combination = [PMU_node_one, PMU_node_two];
                    best_PMU_one = PMU_node_one;
                    best_PMU_two = PMU_node_two;
                end
            end
        end
    end
end

if min(max_possible_FLs_two_PMUs) > k
    disp('Need for more than 2 PMUs in addition to the one at feeder');
end

disp(['Best Placement: PMU at feeder plus PMU at node ' num2str(best_PMU_one) ' and at node ' num2str(best_PMU_two)]);



%%










%%
% PMU_node_one = 2;
% PMU_node_two = 5;
% span_trees_matrix_PMU_root = compute_span_trees_matrix_PMU_root(PMU_node_one, PMU_node_two, span_trees_root_impedance_matrix, idx_from, idx_line, n_spanning_trees,n_lines, spanning_trees_matrix);
% %disp(span_trees_matrix_PMU_root);                               
% x_FL_test = x_FL;
% [~, max_line_two] = compute_max_line(PMU_node_two, idx_from, idx_line, n_spanning_trees,n_lines, spanning_trees_matrix);
% x_FL_test(PMU_node_two:max_line_two, PMU_node_two:max_line_two) = 0;
% x_test = span_trees_matrix_PMU_root*x_FL_test;
% disp(x_test);
% [second_option_PMU_node_one, m] = compute_max_line(PMU_node_one, idx_from, idx_line, n_spanning_trees,n_lines, spanning_trees_matrix);
% possible_FLs_double_PMU = possible_FLs(2,:);
% for i = 4:1:PMU_node_two    % linea che finisce nel nodo che viene prima della bifurcation prima di PMU_node_two
%     entries = count_unique_entries(x_test(:,i));
%     possible_FLs_double_PMU(i) = entries;
% end
% 
% for i = max_line_two:1:second_option_PMU_node_one-1
%     entries = count_unique_entries(x_test(:,i));
%     possible_FLs_double_PMU(i) = entries;
% end
% 
% for i = PMU_node_two:1:max_line_two
%     possible_FLs_double_PMU(i) = possible_FLs(4, i);
% end
% 
% disp(possible_FLs_double_PMU);

%% Test PMU at 1,4,7

%% Test multiple PMU placement
% for i=2:1:n_bifurc
%     PMU_node = PMU_nodes(i);
%     % disp(['PMU TEST: ' num2str(PMU_node)]);
%     new_span_trees_root_impedance_matrix{i} = zeros(0,n_lines);
% 
%     for s = 1:1:n_spanning_trees
%         if spanning_trees_matrix(s, PMU_node)
%             newRow = span_trees_root_impedance_matrix(s, :);
%             new_span_trees_root_impedance_matrix{i} = vertcat(new_span_trees_root_impedance_matrix{i}, newRow);
%             new_span_trees_root_impedance_matrix{i}(:,PMU_node:n_lines) = 0;
%             break           
%         end
%     end
% 
%    for s = 1:1:n_spanning_trees
%        if ~spanning_trees_matrix(s, PMU_node-1) 
%          newRow = span_trees_root_impedance_matrix(s, :);
%          new_span_trees_root_impedance_matrix{i} = vertcat(new_span_trees_root_impedance_matrix{i}, newRow);
%        end
%    end
% 
%     x_FL_new = FL_matrix_computation(idx_from, n_lines, idx_line, spanning_trees_matrix, new_span_trees_root_impedance_matrix{i}, n_spanning_trees, Zvect, Zvect_mag, Zcum_ST);
% 
%     x_tilde_one_new{i} = new_span_trees_root_impedance_matrix{i}*x_FL_new;
% 
%     disp(['PMU node: ' num2str(PMU_node)]);
%     disp(x_tilde_one_new{i}(:,:));
% 
%     unique_entries_one = zeros(n_bifurc, length(x_tilde_one_new{i}(:,:)));
% 
%     for j = 1:1:length(new_span_trees_root_impedance_matrix(1,:))
%         unique_entries_one(i, j) = count_unique_entries(x_tilde_one_new{i}(:,j));
%     end
% 
%     max_line = 0;
%     for j = 1:1:length(idx_from)
%         if idx_from(j) == PMU_node && j ~= PMU_node
%             second_option = idx_line(j);
%             break
%         end
%     end
%     for s = 1:1:n_spanning_trees
%         for l = 1:1:n_lines
%             if spanning_trees_matrix(s,l) == 1 && (spanning_trees_matrix(s,PMU_node) == 1 || spanning_trees_matrix(s,second_option) == 1)
%                 max_line = max(max_line, l);
%                 break
%             end
%         end
%     end
%     unique_entries = unique_entries_one;
%     unique_entries(i,PMU_node:max_line) = possible_FLs(i,PMU_node:max_line);
%     disp(['TEST PMU at 1 and ' num2str(PMU_node)]);
% end






% x_FL_new = x_FL;
% % x_FL_new = FL_matrix_computation(idx_from, n_lines, idx_line, spanning_trees_matrix, new_span_trees_root_impedance_matrix{i}, n_spanning_trees, Zvect, Zvect_mag, Zcum_ST);
% for i = n_bifurc:-1:2
%     new_span_trees_root_impedance_matrix{i} = span_trees_root_impedance_matrix;
%     PMU_node = PMU_nodes(i);
%     disp(['TEST: PMU at ' num2str(PMU_node)]);
%     for j = 1:1:length(idx_from)
%         if idx_from(j) == PMU_node && j ~= PMU_node
%             second_option = idx_line(j);
%             break
%         end
%     end
%     max_line = 0;
%     for s = 1:1:n_spanning_trees
%         for l = 1:1:n_lines
%             if spanning_trees_matrix(s,l) == 1 && (spanning_trees_matrix(s,PMU_node) == 1 || spanning_trees_matrix(s,second_option) == 1)
%                 max_line = max(max_line, l);
%                 break
%             end
%         end
%         % if spanning_trees_matrix(s, PMU_node) || spanning_trees_matrix(s, second_option)
%         %     % disp(['s is ' num2str(s)]);
%         %     % disp(new_span_trees_root_impedance_matrix{i});
%         %     new_row = span_trees_root_impedance_matrix(s,:);
%         %     new_span_trees_root_impedance_matrix{i} = vertcat(new_span_trees_root_impedance_matrix{i}, span_trees_root_impedance_matrix(s,:));
%         %     new_span_trees_root_impedance_matrix{i}(s,:) = [];
%         %     new_span_trees_root_impedance_matrix{i}(s,PMU_node+1:n_lines);
%         % end
%         if spanning_trees_matrix(s,PMU_node)
%             new_span_trees_root_impedance_matrix{i} = vertcat(new_span_trees_root_impedance_matrix{i}, span_trees_root_impedance_matrix(s,:));
%             new_span_trees_root_impedance_matrix{i}(size(new_span_trees_root_impedance_matrix{i},1:PMU_node-1),:) = zeros;
%             new_span_trees_root_impedance_matrix{i}(s,:) = [];
%             break
%         end
% 
%     end
%     disp(new_span_trees_root_impedance_matrix{i});
% end
% 
%     %x_tilde_one(:,:,i) = x_tilde_one_computation(new_span_trees_impedance_matrix, x_FL_new, n_lines, PMU_nodes, i);
%     %x_tilde_two(:,:,i) = x_tilde_two_computation(new_span_trees_impedance_matrix, n_spanning_trees, x_FL, n_lines, PMU_nodes, i, idx_from, idx_line, spanning_trees_matrix);
%     %x_tilde_one_new(:,:,i) = zeros(size(new_span_trees_root_impedance_matrix*x_FL_new));
% 
%     % disp(size(new_span_trees_root_impedance_matrix));
%     % disp(size(x_FL_new));
% 
%     x_tilde_one_new{i} = new_span_trees_root_impedance_matrix*x_FL_new;
% 
%     %disp(x_tilde_one_new);
% 
%     %disp(size(x_tilde_one_new(:,:,i)));
%     unique_entries_one = zeros(n_bifurc, length(x_tilde_one_new{i}(:,:)));
% 
%     for j = 1:1:length(new_span_trees_root_impedance_matrix(1,:))
%         unique_entries_one(i, j) = count_unique_entries(x_tilde_one_new{i}(:,j));
%     end
%     % disp('possible FLs');
%     % disp(max_line);
%     % disp(possible_FLs(i,PMU_node:max_line));
% 
%     unique_entries = unique_entries_one;
%     unique_entries(i,PMU_node:max_line) = possible_FLs(i,PMU_node:max_line);
%     disp(['TEST PMU at 1 and ' num2str(PMU_node)]);
%     disp(PMU_node:max_line);
%     disp(unique_entries(i,:));
% end






% % new_span_trees_root_impedance_matrix = span_trees_root_impedance_matrix;
% % for i = n_bifurc:-1:2
% %     PMU_node = PMU_nodes(i);
% % 
% %     %possible_FLs_new = zeros(n_bifurc, n_lines);
% % 
% %     possible_FLs_new(i,:) = possible_FLs(1,:);
% % 
% %     for j = 1:1:length(idx_from)
% %         if idx_from(j) == PMU_node && j ~= PMU_node
% %             second_option = idx_line(j);
% %             break
% %         end
% %     end
% %     max_line = 0;
% %     for s = 1:1:n_spanning_trees
% %         for l = n_lines:-1:1
% %             if spanning_trees_matrix(s,second_option) == 1 && spanning_trees_matrix(s,l) == 1
% %                 max_line = l;
% %                 break;
% %             end
% %         end
% %         new_span_trees_root_impedance_matrix(s,PMU_node:max_line) = 0;
% %     end
% % 
% %     x_FL_new = FL_matrix_computation(idx_from, n_lines, idx_line, spanning_trees_matrix, new_span_trees_root_impedance_matrix, n_spanning_trees, Zvect, Zvect_mag, Zcum_ST);
% % 
% %     x_tilde_one(:,:,i) = x_tilde_one_computation(spanning_trees_matrices_opt1{i}, x_FL, n_lines, PMU_nodes, i);
% %     x_tilde_two(:,:,i) = x_tilde_two_computation(spanning_trees_matrices_opt2{i}, n_spanning_trees, x_FL, n_lines, PMU_nodes, i, idx_from, idx_line, spanning_trees_matrix);
% %     possible_FLs_new = max_FL_computation(x_FL_new, x_tilde_one, x_tilde_two, new_span_trees_root_impedance_matrix, n_bifurc, PMU_nodes, n_lines, idx_from);
% % 
% % end
% % 
% % for i = n_bifurc:-1:2
% %     PMU_node = PMU_nodes(i);
% %     possible_FLs_new(i, PMU_node:max_line) = possible_FLs(i,PMU_node:max_line);
% %     disp(['TEST PMU at 1 AND ' num2str(PMU_node)]);
% %     disp(possible_FLs_new(i,:));
% % end










% 
% x_tilde_one = x_tilde{1};
% x_tilde_two = x_tilde{2};

% %unique_entries = max_FL_computation(x_tilde_one, x_tilde_two, n_bifurc, PMU_nodes);
% 
% 
% x_tilde_one = zeros(n_spanning_trees, n_lines, n_bifurc);
% 
% for i = 1:1:n_bifurc
%     disp(['PMU node: ' int2str(PMU_nodes(i))]);
%     if PMU_nodes(i) == 1
%         x_tilde_one(:,:,i) = span_trees_root_impedance_matrix*x_FL;
% 
%         unique_entries_one = zeros(n_bifurc, length(x_tilde_one(:,:,i)));
% 
%         for j = 1:1:n_lines
%             unique_entries_one(i, j) = count_unique_entries(x_tilde_one(:,j, i));
%         end
% 
%         disp(x_tilde_one(:,:,i));
%         disp('Number of possible FLs: ');
%         disp(unique_entries_one(i,:));
% 
%     else
%         PMU_node = PMU_nodes(i);     
% 
%         for j = 1:1:length(idx_from)
%             if idx_from(j) == PMU_nodes(i) && j ~= PMU_nodes(i)
%                 second_option = idx_line(j);
%                 break
%             end
%         end
% 
%         for s = 1:1:n_spanning_trees
%             for l = n_lines:-1:1
%                 if spanning_trees_matrix(s,second_option) == 1 && spanning_trees_matrix(s,l) == 1
%                     max_line = l;
%                     break;
%                 end
%             end
%         end
% 
% 
%         range1 = (n_lines - length(spanning_trees_matrices_opt1{i}(1,:)) + 1):n_lines;
%         range2 = (n_lines - length(spanning_trees_matrices_opt2{i}(1,:)) + 1):n_lines;
% 
%         x_tilde_one(:,:,i) = spanning_trees_matrices_opt1{i} * x_FL(range1,:);
%         x_tilde_two(:,:,i) = spanning_trees_matrices_opt2{i} * x_FL(range2,:); 
% 
%         x_tilde_one(:,1:PMU_nodes(i)-1,i) = zeros();
%         x_tilde_two(:,max_line+1:n_lines,i) = zeros();
% 
%         unique_entries_one = zeros(n_bifurc, length(x_tilde_one(:,:,i)));
%         unique_entries_two = zeros(n_bifurc, length(x_tilde_two(:,:,i)));
% 
%         for j = 1:1:n_lines
%             unique_entries_one(i, j) = count_unique_entries(x_tilde_one(:,j, i));
%             unique_entries_two(i, j) = count_unique_entries(x_tilde_two(:,j, i));
%         end
% 
%         for j = 1:1:length(idx_from)
%             if idx_from(j) == PMU_nodes(i) && j ~= PMU_nodes(i)
%                 unique_entries(i,j:n_lines) = unique_entries_two(i,j:n_lines);
%                 break
%             else
%                 unique_entries(i,j) = unique_entries_one(i,j);
%             end
%         end
% 
%         disp(x_tilde_one(:,1:second_option-1,i));
%         disp(x_tilde_two(:,second_option:n_lines,i));
%         disp('Number of possible FLs: ');
%         disp(unique_entries(i,:));
%         disp('');
%     end
% end









% 
% Z_tilde_matrix(5,:,2) = zeros(n_lines, 1);
% x_tilde_test = Z_tilde_matrix(:,:,2) * x_FL;
% 
% % for i=1:1:5
% %     Z_tilde_matrix(i,:,2) = zeros(n_lines, 1);
% % end
% x_tilde_test_2 = Z_tilde_matrix(:,:,2) * x_FL;



% x_FL_test_line_5 = [1.0 1.0 1.0 1.0 1.0 1.0 1.0 0.0 1.0 1.0 0.0 0.0 1.0 1.0 1.0 0.0];
% x_tilde_test_5 = Z_tilde_matrix(i,:,2);

