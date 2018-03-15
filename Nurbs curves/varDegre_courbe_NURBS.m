function [] = varDegre_courbe_NURBS(config, poids, points_controle, n)
    leg_txt = [];
    leg_txt{1} = 'Polygone de contrôle';
    pas_couleur = 1/n;
    for curr_degre=2:n
        
        T = []; % Vecteur nodal
        r = ((length(points_controle) + curr_degre + 1) - 2*curr_degre)-1;
        % Creation de la suite du vecteur nodale
        switch(config)
            case 1
                T = [zeros(1,curr_degre), (0:r)/r, ones(1,curr_degre)];
            case 2
                T = [zeros(1,curr_degre), (0:demi_r)/r, ((demi_r/r)+0.1), ((demi_r+2):r)/r, ones(1,curr_degre)]
            case 3
                T = [zeros(1,curr_degre), (ones(1,r+1)/2)+((0:r)/1000), ones(1,curr_degre)];
            otherwise
                return
        end

        %% Check : nombre de noeud = nb pts de controle + degre + 1
        if length(T) ~= length(points_controle) + curr_degre + 1
            warning('Problème de paramètrisation : Nombre incorrect de noeuds dans le vecteur nodal.');
        end

        courbe = []; % Nurbs
        t = linspace(T(1),T(end));
        for i = 1:length(t)
            courbe = [courbe, courbe_NURBS(T, poids, points_controle, curr_degre, t(i))];
        end

        % Affichage de la courbe courante
        figure(1)
        for k = 1:length(t)
            nurbs = plot3(courbe(1, :), courbe(2, :), courbe(3, :), 'Color', [pas_couleur*curr_degre, 0, 0], 'LineWidth', 2);
            hold on;
        end

        if curr_degre == n
            leg_txt{curr_degre} = 'Courbe de NURBS';
        else
            leg_txt{curr_degre} = sprintf('NURBS degré %d', curr_degre);
        end
        legend(leg_txt);
        hold on;

        clear courbe;
    end
end

