function N_i_n = N(noeuds, i, n, u)
%% Fonction B-spline de base de degré n

% N_{{i,n}}=f_{{i,n}}N_{{i,n-1}}+g_{{i+1,n}}N_{{i+1,n-1}}

if n == 0
    if u >= noeuds(i) && u <= noeuds(i+1)
        N_i_n = 1;
    else
        N_i_n = 0;
    end
else
    if (noeuds(i + n) == noeuds(i))
        f = 0;
    else
        f = ((u - noeuds(i)) / (noeuds(i + n) - noeuds(i)));
    end
    
    if (noeuds(i + n + 1) == noeuds(i + 1))
        g = 0;
    else
        g = ((noeuds(i + n + 1) - u) / (noeuds(i + n + 1) - noeuds(i + 1)));
    end
    N_i_n = f * N(noeuds, i, n-1, u)+ g * N(noeuds, i+1, n-1, u);
end

end

