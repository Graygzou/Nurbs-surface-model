function [] = varDegre_surface_NURBS(config, poids, points_controle, n_u, n_v, num, fermee)
    leg_txt = [];
    leg_txt{1} = 'Polygone de contrôle';
    pas_couleur = 1/(n_u*n_v);
    for curr_degre_v=2:n_v
        for curr_degre_u=2:n_u
            
            noeuds_u = []; % Vecteur nodal
            noeuds_v = [];

            r = ((size(points_controle,1) + curr_degre_u + 1) - 2*curr_degre_u)-1;
            % Creation de la suite du vecteur nodale
            switch(config)
                case -1
                    % Cas special du cone
                    noeuds_u = [0, 0, 0, pi/2, pi/2, pi, pi, 3*pi/2, 3*pi/2, 2*pi, 2*pi, 2*pi];
                case 1
                    noeuds_u = [zeros(1,curr_degre_u), (0:r)/r, ones(1,curr_degre_u)];
                case 2
                    noeuds_u = [zeros(1,curr_degre_u), (0:demi_r)/r, ((demi_r/r)+0.1), ((demi_r+2):r), ones(1,curr_degre_u)];
                case 3
                    noeuds_u = [zeros(1,curr_degre_u), (ones(1,r+1)/2)+((0:r)/1000), ones(1,curr_degre_u)];
                otherwise
                    return
            end

            r = ((size(points_controle,2) + curr_degre_v + 1) - 2*curr_degre_v)-1;
            % Creation de la suite du vecteur nodale
            switch(config)
                case -1
                    % Cas special du cone
                    noeuds_v = [0, 0, 0, pi/2, pi/2, pi, pi, 3*pi/2, 3*pi/2, 2*pi, 2*pi, 2*pi];
                case 1
                    noeuds_v = [zeros(1,curr_degre_v), (0:r)/r, ones(1,curr_degre_v)];
                case 2
                    noeuds_v = [zeros(1,curr_degre_v), (0:demi_r)/r, ((demi_r/r)+0.1), ((demi_r+2):r), ones(1,curr_degre_v)];
                case 3
                    noeuds_v = [zeros(1,curr_degre_v), (ones(1,r+1)/2)+((0:r)/1000), ones(1,curr_degre_v)];
                otherwise
                    return
            end

            %% Debut de l'algorithme
            u = linspace(noeuds_u(1),noeuds_u(end));
            v = linspace(noeuds_v(1),noeuds_v(end));

            %% Partie 1
            % Calcul du Numérateur
            % Pour j fixé
            coeffs = points_controle;
            coeffs(:,:,1) = coeffs(:,:,1) .* poids;
            coeffs(:,:,2) = coeffs(:,:,2) .* poids;
            coeffs(:,:,3) = coeffs(:,:,3) .* poids;

            numerateur = [];
            % boucle pour les t
            for i = 1:length(v)
                intermediaire = [];
                % boucle pour les points de controle de la courbe courante
                for j = 1:size(coeffs,1)
                    intermediaire = [intermediaire, ...
                        courbe_NURBS(noeuds_v, poids(j,:), [coeffs(j,:,1); coeffs(j,:,2); coeffs(j,:,3)], curr_degre_v, v(i))];
                end
                numerateur = [numerateur ; intermediaire];
            end

            %% "Reshape"
            j = 1;
            X_splines = zeros(size(numerateur,1)/3, size(numerateur,2));
            Y_splines = zeros(size(numerateur,1)/3, size(numerateur,2));
            Z_splines = zeros(size(numerateur,1)/3, size(numerateur,2));
            for i = 1:3:(size(numerateur,1))
                X_splines(j,:) = numerateur(i,:);
                Y_splines(j,:) = numerateur(i+1,:);
                Z_splines(j,:) = numerateur(i+2,:);
                j = j+1;
            end

%             if fermee
%                 if num == 9
%                     %% Ajoute de la bande manquante
%                     X_aff = [X_splines, X_splines(:,1)];
%                     Y_aff = [Y_splines, Y_splines(:,1)];
%                     Z_aff = [Z_splines, Z_splines(:,1)];
%                 else
%                     %% Ajoute de la bande manquante
%                     X_aff = [X_splines ; X_splines(1,:)];
%                     Y_aff = [Y_splines ; Y_splines(1,:)];
%                     Z_aff = [Z_splines ; Z_splines(1,:)];
%                 end
%             else
%                 X_aff = X_splines;
%                 Y_aff = Y_splines;
%                 Z_aff = Z_splines;
%             end
% 
%             %% Affichage
%             figure(2)
%             surf(X_aff, Y_aff, Z_aff);
%             xlabel('X');
%             ylabel('Y');
%             zlabel('Z');

            %% Affichage des points de controle
            hold on;
            plot3(points_controle(:,:,1), points_controle(:,:,2), points_controle(:,:,3), '*r-');
            title(sprintf('Surface NURBS de degré (%d, %d)', n_u, n_v));
            hold off;

            splines_colonnes = [];
            new_poids = ones(size(X_splines));
            for i = 1:length(u)
                % boucle pour les points de controle de la courbe courante
                intermediaire = [];
                for j = 1:size(X_splines,1)
                    intermediaire = [intermediaire , ...
                        courbe_NURBS(noeuds_u, new_poids(j,:), [X_splines(j,:); Y_splines(j,:); Z_splines(j,:)], curr_degre_u, u(i))];
                end
                splines_colonnes = [splines_colonnes ; intermediaire];
            end

            %% "Reshape"
            j = 1;
            X_splines = zeros(size(splines_colonnes,1)/3, size(splines_colonnes,2));
            Y_splines = zeros(size(splines_colonnes,1)/3, size(splines_colonnes,2));
            Z_splines = zeros(size(splines_colonnes,1)/3, size(splines_colonnes,2));
            for i = 1:3:(size(splines_colonnes,1))
                X_splines(j,:) = splines_colonnes(i,:);
                Y_splines(j,:) = splines_colonnes(i+1,:);
                Z_splines(j,:) = splines_colonnes(i+2,:);
                j = j+1;
            end

            if fermee
                %% Ajoute les deux bandes manquantes
                X_splines = [X_splines ; X_splines(1,:)];
                Y_splines = [Y_splines ; Y_splines(1,:)];
                Z_splines = [Z_splines ; Z_splines(1,:)];

                X_splines = [X_splines, X_splines(:,1)];
                Y_splines = [Y_splines, Y_splines(:,1)];
                Z_splines = [Z_splines, Z_splines(:,1)];
            end

            %% Affichage
            figure(3)
            hold on;
            surf(X_splines, Y_splines, Z_splines,'FaceColor',[curr_degre_v*curr_degre_u*pas_couleur,0,0]);
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            hold off;

            %% Affichage des points de controle
            hold on;
            plot3(points_controle(:,:,1), points_controle(:,:,2), points_controle(:,:,3), '*r-');
            title(sprintf('Surface NURBS de degré (%d, %d)', n_u, n_v));
            hold on;

            if curr_degre_v == n_v && curr_degre_u == n_u
                leg_txt{curr_degre_v*curr_degre_u} = 'Courbe de NURBS';
            else
                leg_txt{curr_degre_v*curr_degre_u} = sprintf('NURBS degré (%d,%d)',curr_degre_v, curr_degre_u);
            end
            %legend(leg_txt);
            hold on;

            clear courbe;
        end
    end
end

