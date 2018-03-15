function [ points_controle, poids ] = polygones(num)
    switch(num)
        case 1
            %% Exemple de base
            points_controle = [0, 1, 1, 2, 3, 2, 1;
                               0, 0, 1, 1, 0, -1, -0.5;
                               0, 0, 0, 0, 0, 0, 0];
            poids = ones(1,size(points_controle,2));
        case 2
            %% Exemple de base plus petit
            points_controle = [0, 1, 3, 5, 1, 0;
                               0, 1, 0.5, 2, 2, 0;
                               0, 0, 0, 8, 6, 3];
            poids = ones(1,size(points_controle,2));
        case 3
            %% Cercle
            points_controle = [1 1 0 -1 -1 -1 0  1 1;
                               0 1 1 1 0 -1 -1 -1  0;
                               0 0 0 0 0 0 0 0 0]; 
            poids = [1, sqrt(2)/2, 1, sqrt(2)/2, 1, sqrt(2)/2, 1, sqrt(2)/2, 1];
    end
end

