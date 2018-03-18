clear all;
clc;
close all;

taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

figure('Name','Figure choisie','Position',[0,0,0.33*L,0.5*H]);
figure('Name','Première approximation','Position',[L/3,0,0.33*L,0.5*H]);
figure('Name','Deuxième approximation','Position',[2*L/3,0,0.33*L,0.5*H]);

%% Choix du polygone de contrôle
num = -1;
disp(['Veuillez choisir votre polygone de contrôle :']);
disp(['=============================================']);
disp(['1 : Exemple de base : Grille.']);
disp(['2 : Tore 1']);
disp(['3 : Tore 2']);
disp(['---------------------------------------------']);
disp(['4 : surfaces avec des bosses']);
disp(['5 : Vaisseau TIE Fighter.']);
disp(['6 : Surface simple unimodale']);
disp(['7 : Surface du polygone de controle 1 des courbes.']);
disp(['8 : figure précédente modifié.']);
disp(['9 : Visage.']);
while num == -1 || num > 9 || num < 1
    num = input('Numero : ');
end
%% Choix de la figure
[X,Y,Z, poids] = figures(num);
points_controle=zeros(size(X,1),size(X,2),3);
points_controle(:,:,1)=X;
points_controle(:,:,2)=Y;
points_controle(:,:,3)=Z;

%% Choix du degré de u
n_u = -1;
while n_u == -1 || n_u < 1
    n_u = input('Degré de u : ');
end

%% Choix du degré de v
n_v = -1;
while n_v == -1 || n_v < 1
    n_v = input('Degré de v : ');
end

fermee = -1;
while fermee ~= 0 && fermee ~= 1
    fermee = input('Fermée ? (1: oui | 0: non) : ');
end

%% Check : le degré (provient des splines)
if n_u <= size(points_controle, 1)
    warning('Problème de paramètrisation : degré trop important par rapport au nombre de noeud.');
end
if n_v <= size(points_controle, 2)
    warning('Problème de paramètrisation : degré trop important par rapport au nombre de noeud.');
end

noeuds_u = []; % Vecteur nodal
noeuds_v = []; % Vecteur nodal

%% Choix du vecteur nodal de u
disp(['Veuillez choisir votre vecteur de noeud :']);
disp(['=============================================']);
disp(['1 : noeuds_u = [..., 0, 1/x, 2/x, 3/x, ..., x-1/x, 1, ...]']);
disp(['2 : noeuds_u = [..., 1/4, 1/2, 3/4, ...]']);
disp(['3 : noeuds_u = [..., 1/4, (1/4)+0.5, 3/4, ...]']);
config = input('noeuds_u :');
r = ((size(points_controle,1) + n_u + 1) - 2*n_u)-1;
demi_r = floor(r/2)
% Creation de la suite du vecteur nodale
switch(config)
    case -1
        % Cas special du cone
        noeuds_u = [0, 0, 0, pi/2, pi/2, pi, pi, 3*pi/2, 3*pi/2, 2*pi, 2*pi, 2*pi];
    case 1
        noeuds_u = [zeros(1,n_u), (0:r)/r, ones(1,n_u)];
    case 2
        noeuds_u = [zeros(1,n_u), (0:demi_r)/r, ((demi_r/r)+0.1), ((demi_r+2):r)/r, ones(1,n_u)];
    case 3
        noeuds_u = [zeros(1,n_u), (ones(1,r+1)/2)+((0:r)/1000), ones(1,n_u)];
    otherwise
        return
end

%% Choix du vecteur nodal de v
disp(['Veuillez choisir votre vecteur de noeud :']);
disp(['1 : noeuds_v = [..., 0, 1/x, 2/x, 3/x, ..., x-1/x, 1, ...]']);
disp(['2 : noeuds_v = [..., 1/4, 1/2, 3/4, ...]']);
disp(['3 : noeuds_v = [..., 1/4, (1/4)+0.5, 3/4, ...]']);
config = input('noeuds_v :');
r = ((size(points_controle,2) + n_v + 1) - 2*n_v)-1;
demi_r = floor(r/2)
% Creation de la suite du vecteur nodale
switch(config)
    case -1
        % Cas special du cone
        noeuds_v = [0, 0, 0, pi/2, pi/2, pi, pi, 3*pi/2, 3*pi/2, 2*pi, 2*pi, 2*pi];
    case 1
        noeuds_v = [zeros(1,n_v), (0:r)/r, ones(1,n_v)];
    case 2
        noeuds_v = [zeros(1,n_v), (0:demi_r)/r, ((demi_r/r)+0.1), ((demi_r+2):r)/r, ones(1,n_v)];
    case 3
        noeuds_v = [zeros(1,n_v), (ones(1,r+1)/2)+((0:r)/1000), ones(1,n_v)];
    otherwise
        return
end

%% Check_2 : nombre de noeud = nb pts de controle + degre + 1
if length(noeuds_u) ~= size(points_controle, 1) + n_u + 1
    warning('Problème de paramètrisation : Nombre incorrect de noeuds dans le vecteur nodal.');
end
if length(noeuds_v) ~= size(points_controle, 2) + n_v + 1
    warning('Problème de paramètrisation : Nombre incorrect de noeuds dans le vecteur nodal.');
end

disp(['Paramètre variants :']);
disp(['====================']);
disp(['1 : le degré.']);
disp(['2 : le vecteur nodal.']);
disp(['3 : le poids.']);
disp(['4 : Aucun paramètre.']);
choix = input('choix :');
switch(choix)
    case 1
        varDegre_surface_NURBS(config, poids, points_controle, n_u, n_v, num, fermee)
    case 2
        varKnot_surface_NURBS(config, poids, points_controle, n_u, n_v, num, fermee)
    case 3
    case 4
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
                    courbe_NURBS(noeuds_v, poids(j,:), [coeffs(j,:,1); coeffs(j,:,2); coeffs(j,:,3)], n_v, v(i))];
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

        if fermee
            %% Ajoute de la bande manquante
            X_aff = [X_splines, X_splines(:,1)];
            Y_aff = [Y_splines, Y_splines(:,1)];
            Z_aff = [Z_splines, Z_splines(:,1)];
        else
            X_aff = X_splines;
            Y_aff = Y_splines;
            Z_aff = Z_splines;
        end

        %% Affichage
        figure(2)
        surf(X_aff, Y_aff, Z_aff);
        xlabel('X');
        ylabel('Y');
        zlabel('Z');

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
                    courbe_NURBS(noeuds_u, new_poids(j,:), [X_splines(j,:); Y_splines(j,:); Z_splines(j,:)], n_u, u(i))];
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

            X_splines = [X_splines X_splines(:,1)];
            Y_splines = [Y_splines Y_splines(:,1)];
            Z_splines = [Z_splines Z_splines(:,1)];
        end

        %% Affichage
        figure(3)
        surf(X_splines, Y_splines, Z_splines);
        xlabel('X');
        ylabel('Y');
        zlabel('Z');

        %% Affichage des points de controle
        hold on;
        plot3(points_controle(:,:,1), points_controle(:,:,2), points_controle(:,:,3), '*r-');
        title(sprintf('Surface NURBS de degré (%d, %d)', n_u, n_v));
        hold off;
end