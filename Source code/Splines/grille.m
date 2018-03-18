function [] = grille ()
    clear all;
    clc;
    close all;
    
    taille_ecran = get(0,'ScreenSize');
    L = taille_ecran(3);
    H = taille_ecran(4);

    figure('Name','Figure choisie','Position',[0,0,0.33*L,0.5*H]);
    figure('Name','Première approximation','Position',[L/3,0,0.33*L,0.5*H]);
    figure('Name','Deuxième approximation','Position',[2*L/3,0,0.33*L,0.5*H]);
    
    num = -1;
    %% Choix de la figure
    disp(['Veuillez choisir votre polygone de contrôle :']);
    disp(['1 : Exemple de base : Grille']);
    disp(['2 : Tore 1']);
    disp(['3 : Tore 2']);
    while num == -1 || num > 3 || num < 1
        num = input('Numero : ');
    end
    [X,Y,Z] = figures_spline(num);

    %% Mise en place de la Grille
    Grille=zeros(size(X,1),size(X,2),3);
    Grille(:,:,1)=X;
    Grille(:,:,2)=Y;
    Grille(:,:,3)=Z;
    
    %% Choix du degré
    n = -1;
    while n == -1 || n < 1
        n = input('Degré : ');
    end
    
    %% Choix du degré
    nb_subdivisions = -1;
    while nb_subdivisions == -1 || nb_subdivisions < 1
        nb_subdivisions = input('Nombre de subdivisions : ');
    end
    
    % ===========================
    %  Debut de l'algorithme
    % ===========================
    %% Etape 1 : premiere approximation
    splines_lignes = [];
    splines_colonnes = [];
    
    for i = 1:length(X)
        splines_lignes = [splines_lignes ; ...
            subdivision([Grille(i,:,1); Grille(i,:,2); Grille(i,:,3)], n, nb_subdivisions)];
    end
    
    %% "Reshape"
    j = 1;
    X_splines = zeros(size(splines_lignes,1)/3, size(splines_lignes,2));
    Y_splines = zeros(size(splines_lignes,1)/3, size(splines_lignes,2));
    Z_splines = zeros(size(splines_lignes,1)/3, size(splines_lignes,2));
    for i = 1:3:(size(splines_lignes,1))
        X_splines(j,:) = splines_lignes(i,:);
        Y_splines(j,:) = splines_lignes(i+1,:);
        Z_splines(j,:) = splines_lignes(i+2,:);
        j = j+1;
    end

    %% Ajout de la bande manquante
    X_aff = [X_splines ; X_splines(1,:)];
    Y_aff = [Y_splines ; Y_splines(1,:)];
    Z_aff = [Z_splines ; Z_splines(1,:)];
    
    %% Affichage
    figure(2)
    plot3(X_aff, Y_aff, Z_aff);
    
    %% Etape 2 : deuxième approximation
    for i = 1:size(X_splines,2)
        splines_colonnes = [splines_colonnes ; ...
            subdivision([X_splines(:,i)'; Y_splines(:,i)'; Z_splines(:,i)'], n, nb_subdivisions)];
    end
    
    %% Reshape
    j = 1;
    X_splines = zeros((size(splines_colonnes,1)/3), size(splines_colonnes,2));
    Y_splines = zeros((size(splines_colonnes,1)/3), size(splines_colonnes,2));
    Z_splines = zeros((size(splines_colonnes,1)/3), size(splines_colonnes,2));
    for i = 1:3:(size(splines_colonnes,1))
        X_splines(j,:) = splines_colonnes(i,:);
        Y_splines(j,:) = splines_colonnes(i+1,:);
        Z_splines(j,:) = splines_colonnes(i+2,:);
        j = j+1;
    end
    
    %% Ajoute les deux bandes manquantes
    X_splines = [X_splines ; X_splines(1,:)];
    Y_splines = [Y_splines ; Y_splines(1,:)];
    Z_splines = [Z_splines ; Z_splines(1,:)];
    
    X_splines = [X_splines X_splines(:,1)];
    Y_splines = [Y_splines Y_splines(:,1)];
    Z_splines = [Z_splines Z_splines(:,1)];
    
    %% Affichage
    figure(3)
    surf(X_splines, Y_splines, Z_splines);

end