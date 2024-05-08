function Zbus = compute_Zbus(n_buses, n_lines, idx_from, idx_to, R_prime, X_prime, l, B_prime, R_0, X_0, B_0)
    % Initialize Ybus matrix
    Ybus = zeros(n_buses, n_buses);

    % Construct the impedance matrix Z for each branch
    Z = (R_prime + 1i*X_prime);
    

    % Construct the diagonal matrix B_diag with shunt admittances
    % B_diag = zeros(n_buses, n_buses);
    % for i = 1:n_lines
    %     B_diag(idx_from(i), idx_from(i)) = B_diag(idx_from(i), idx_from(i)) + B_prime(i) / 2 + 1i * (X_0(i) + B_0(i) / 2);
    %     B_diag(idx_to(i), idx_to(i)) = B_diag(idx_to(i), idx_to(i)) + B_prime(i) / 2 + 1i * (X_0(i) + B_0(i) / 2);
    % end

    % Populate the Zbus matrix
    for i = 1:n_lines
        Zbus(idx_from(i), idx_to(i)) = Z(i);
        Zbus(idx_to(i), idx_from(i)) = Zbus(idx_from(i), idx_to(i));
    end

    % Add diagonal elements
    %Ybus = Ybus + B_diag;  % neglected

    % Compute Zbus matrix
    %Zbus = inv(Ybus);
end
