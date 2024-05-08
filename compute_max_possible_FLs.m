function[maximum] = compute_max_possible_FLs(possible_FLs)

maximum = zeros(1, size(possible_FLs, 1));

% disp(size(maximum(1)));
% disp(size(possible_FLs(1,:)));

for i=1:1:size(possible_FLs, 1)
    maximum(i) = max(possible_FLs(i,:));
end
