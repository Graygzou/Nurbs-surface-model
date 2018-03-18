%% Paramètres
% noeuds : vecteur nodal
% coeffs : valeur multiplié avec la fonction de base N
% n : degré
% t : \in [0, 1]
function res = surface_NURBS(noeuds, coeffs, n, t)
%% Calcule le point P(x,y,z) correspondant � la NURBS � l'instant t voulu.

m = length(noeuds);

res = zeros(size(coeffs));

for i = 1:(m-n-1)
    res = res + (N(noeuds, i, n, t) * coeffs);
end

% m = length(noeuds);
% N_base = zeros(1,m-n-1);
% 
% for i = 1:(m-n-1)
%     N_base(i) = N(noeuds, i, n, t);
% end
% 
% res = zeros(size(coeffs));
% for i=1:length(N_base)
%     res = N_base .* coeffs(i,:);
% end

end

