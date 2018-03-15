function [] = varWeight_courbe_NURBS(config, poids, points_controle, n)
    leg_txt = [];
    leg_txt1 = [];
    pas_couleur = 1/n;
    taille = 3;
    nurbs = [];
    poly_controle = [];
    P = zeros(taille, length(poids));

    weight = 1;
    for i=1:taille
        P(i,:) = poids;
        P(i,floor(length(poids)/2)) = weight;
        weight = weight + 1;
    end
    
    
    
    for curr_W=1:size(P,1)
        
        %% Affichage du polygone de controle.
        figure(1)
        poly_controle = [poly_controle plot3(points_controle(1, :), points_controle(2, :), P(curr_W,:), 'Color', [curr_W*pas_couleur, 0, 0], 'Marker', '*', 'LineStyle', '-')];
        hold on;
        title(sprintf('NURBS de degré %d', n));
        
        leg_txt1{curr_W} = sprintf('Courbe NURBS, w_3 = %d', curr_W);
        
        %% Algo
        T = []; % Vecteur nodal
        r = ((length(points_controle) + n + 1) - 2*n)-1;
        demi_r = floor(r/2);
        % Creation de la suite du vecteur nodale
        switch(config)
            case 1
                T = [zeros(1,n), (0:r)/r, ones(1,n)];
            case 2
                T = [zeros(1,n), (0:demi_r)/r, ((demi_r/r)+0.1), ((demi_r+2):r)/r, ones(1,n)];
            case 3
                T = [zeros(1,n), (ones(1,r+1)/2)+((0:r)/1000), ones(1,n)];
            otherwise
                disp(['Config choisie : T = [..., 0, 1/4, 1/2, 3/4, 1, ...]']);
                T = [zeros(1,n), (0:r)/r, ones(1,n)];
        end

        %% Check : nombre de noeud = nb pts de controle + degre + 1
        if length(T) ~= length(points_controle) + n + 1
            warning('ProblÃšme de paramÃštrisation : nombre incorrect de noeuds dans le vecteur nodal.');
        end

        courbe = []; % Nurbs normalisÃ© (w=1)
        weight = []; % Nurbs
        t = linspace(T(1),T(end));
        for i = 1:length(t)
            [curr_c, curr_weight] = courbe_NURBS(T, P(curr_W,:), points_controle, n, t(i));
            courbe = [courbe, curr_c];
            weight = [weight, curr_weight];
        end

        %% Affichage de la courbe courante
        figure(1)
        for k = 1:length(t)
            % Dispo : courbe(3, :) //  P(curr_W,:) <= trop petit // ...
            %nurbs = plot3(courbe(1, :), courbe(2, :), courbe(3, :), 'Color', [curr_W*pas_couleur, 0, 0], 'LineWidth', 2);
            nurbs = [ nurbs, plot3(courbe(1, :), courbe(2, :), weight, 'Color', [curr_W*pas_couleur, 0, 0], 'LineWidth', 2)];
            hold on;
        end
        
        
        if curr_W == poids
            leg_txt{curr_W} = 'Polygone de contrôle, w_3 = 1';
        else
            leg_txt{curr_W} = sprintf('Polygone de contrôle, w_3 = %d', curr_W);
        end

        hold on;

        clear courbe;
    end
    legend([poly_controle, nurbs],[leg_txt,leg_txt1]);
end