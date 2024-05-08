function[Zvect_mag] = compute_Zvect_mag(n_buses, n_lines, idx_from, idx_to, R_prime, X_prime, l, B_prime, R_0, X_0, B_0)
Zvect_mag = zeros(n_lines, 1);
for i=1:n_lines
    Zvect_mag(i) = sqrt(R_prime(i)^2 + X_prime(i)^2)*l(i);
end