function[Zvect] = compute_Zvect(n_buses, n_lines, idx_from, idx_to, R_prime, X_prime, l, B_prime, R_0, X_0, B_0)
Zvect = zeros(n_lines, 1);
for i=1:n_lines
    Zvect(i) = (R_prime(i) + 1i*X_prime(i))*l(i);
end