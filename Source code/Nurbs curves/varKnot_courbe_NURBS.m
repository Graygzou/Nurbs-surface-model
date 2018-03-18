function [] = varKnot_courbe_NURBS(poids, points_controle, n)
    leg_txt = [];
    leg_txt{1} = 'Polygone de contrôle';
    pas_couleur = 1/n;
    
    r = ((length(points_controle) + n + 1) - 2*n)-1;
    demi_r = floor(r/2);
    
    T1 = [zeros(1,n), (0:r)/r, ones(1,n)];
    T2 = [zeros(1,n), (0:demi_r)/r, ((demi_r/r)+0.1), ((demi_r+2):r)/r, ones(1,n)];
    T3 = [zeros(1,n), (ones(1,r+1)/2)+((0:r)/1000), ones(1,n)];
    T_conf = [T1 ; T2 ; T3];
    for curr_T=1:size(T_conf,1)
        T = T_conf(curr_T,:);
        
        %% Check : nombre de noeud = nb pts de controle + degre + 1
        if length(T) ~= length(points_controle) + n + 1
            warning('Problème de paramètrisation : Nombre incorrect de noeuds dans le vecteur nodal.');
        end

        courbe = []; % Nurbs
        t = linspace(T(1),T(end));
        for i = 1:length(t)
            courbe = [courbe, courbe_NURBS(T, poids, points_controle, n, t(i))];
        end

        % Affichage de la courbe courante
        figure(1)
        for k = 1:length(t)
            nurbs = plot3(courbe(1, :), courbe(2, :), courbe(3, :), 'Color', [0, curr_T*pas_couleur, 0], 'LineWidth', 2);
            hold on;
        end

        leg_txt{curr_T+1} = sprintf('NURBS config %d', curr_T);
        legend(leg_txt);
        hold on;

        clear courbe;
    end
end

