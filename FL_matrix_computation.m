function[x_FL] = FL_matrix_computation(idx_from, n_lines, idx_line, spanning_trees_matrix, span_trees_impedance_matrix, n_spanning_trees, Zvect, Zvect_mag, Zcum_ST)

x_FL = zeros(n_lines, n_lines);
Z_cum = zeros(n_lines, n_lines);
span = zeros(n_lines);
% span_imp = zeros(n_lines);


for line=1:1:n_lines                                        %iterate over all possible FLs (i.e. over all lines)     
    for j=1:1:n_spanning_trees                              %iterate over all spanning trees
        if spanning_trees_matrix(j,line) == 1               %if the line is in the spanning tree, store the spanning tree's impedances
            span = spanning_trees_matrix(j,:);
            %span_imp = span_trees_impedance_matrix(j,:);
            break
        end
    end


    lower_bound = 0;
    upper_bound = 0;
    for i = 1:1:n_lines
        if any(span(i) == 1) && any(i < line)
            lower_bound = lower_bound + Zvect_mag(i);
            upper_bound = lower_bound + Zvect_mag(line);
        end

    end
    for row = 1:1:n_lines
        for j=1:1:size(span_trees_impedance_matrix,1)
            if spanning_trees_matrix(j,row)
                Z_cum(row, line) = sum(span_trees_impedance_matrix(j,1:row-1));
                break
            end
        end

        if span(row) == 1
            if row == line
                x_FL(row, line) = 1;
            else
                x_FL(row, line) = 0;
            end
        else
            if ((Z_cum(row, line) <= lower_bound && (Z_cum(row, line)+Zvect_mag(row) <= lower_bound)) || (Z_cum(row, line) >= upper_bound))
                x_FL(row,line) = 0;
            else 
                if ((Z_cum(row, line) <= lower_bound) && (Z_cum(row, line)+Zvect_mag(row) >= lower_bound)) || ((Z_cum(row, line) >= lower_bound) && (Z_cum(row, line) <= upper_bound))
                x_FL(row,line) = 1;
                end
            end
            %x_FL(row,line) = ~((Z_cum(row, line) <= lower_bound && (Z_cum(row, line)+Zvect_mag(row) <= lower_bound)) || (Z_cum(row, line) >= upper_bound));
        end
    % sanity check
    % if line == 13
    %     disp(['EXAMPLE: LINE' int2str(line)]);
    %     disp(Z_cum);
    %     disp(upper_bound);
    %     disp(x_FL(:,line))
    %     disp(span)
    %     disp('----------------------------------')
    %     break
    end
    if line == 8
        % disp('LINE = 8');
        % disp(span);
        % disp('upper_bound = ');
        % disp(upper_bound);
        % disp('lower_bound = ');
        % disp(lower_bound);
        % disp(Z_cum(:, 8));
        % disp(x_FL(:,8))
    end
end
% disp(Z_cum(15,:));
end

% x_FL = zeros(n_lines);
% up_bound = zeros(1, n_lines);
% low_bound = zeros(1, n_lines);
% %Z_cum = zeros(n_spanning_trees, n_lines);
% 
% 
% for faulted_line = 1:1:n_lines
%     for row = 1:1:n_lines
%         for s=1:1:n_spanning_trees
%             if spanning_trees_matrix(s,faulted_line) == 1 && spanning_trees_matrix(s,row) == 1
%                 disp(spanning_trees_matrix(s,:));
%                 disp(faulted_line);
%                 disp(row);
%                 if row <= faulted_line
%                     x_FL(row, faulted_line) = 1;
%                 else
%                     x_FL(row, faulted_line) = 0;
%                 end
%                 break
%             else
%                 if spanning_trees_matrix(s, faulted_line) == 1 && span_trees_impedance_matrix(s, row) == 0
%                     up_bound(faulted_line) = Zcum_ST(s, faulted_line) + Zvect_mag(faulted_line);
%                     low_bound(faulted_line) = Zcum_ST(s, faulted_line);
%                     if any(Zcum_ST(s, row) < up_bound) && any(Zcum_ST(s, row) > low_bound)
%                         % disp('Bounds');
%                         % disp(up_bound);
%                         % disp(low_bound);
%                         x_FL(row,faulted_line) = 1;
%                         break
%                     end
%                 end
%             end
%         end
% 
%     end
%     disp('Bounds');
%     disp(up_bound);
%     disp(low_bound);
% end
