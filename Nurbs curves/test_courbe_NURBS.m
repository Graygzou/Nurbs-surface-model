close all;
clc;
clear all;

taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

figure('Name','Figure choisie','Position',[0,0,0.33*L,0.5*H]);

%% Choix du polygone de contrôle
num = -1;
disp(['Veuillez choisir votre polygone de contrôle :']);
disp(['=============================================']);
disp(['1 : polygone de controle 7pts : en 2D.']);
disp(['2 : polygone de controle 6pts : en 3D.']);
disp(['3 : polygone de controle Cone']);
while num == -1 || num > 3 || num < 1
    num = input('Numero : ');
end
[ points_controle, poids] = polygones(num);

%% Choix du degré
n = -1;
while n == -1 || n < 1
    n = input('Degré : ');
end

%% Choix de la variation
disp(['Paramètre variants :']);
disp(['====================']);
disp(['1 : le degré.']);
disp(['2 : le vecteur nodal.']);
disp(['3 : le poids.']);
disp(['4 : Aucun paramètre.']);
choix = input('choix :');

if choix ~= 2 && num ~= 3
    %% Choix du vecteur nodal
    disp(['Veuillez choisir votre vecteur de noeud :']);
    disp(['=========================================']);
    disp(['1 : T = [..., 0, 1/x, 2/x, 3/x, ..., x-1/x, 1, ...]']);
    disp(['2 : T = [..., 1/4, 1/2, 3/4, ...]']);
    disp(['3 : T = [..., 1/4, (1/4)+0.5, 3/4, ...]']);
    config = input('T :');
else
    if num == 3
        config = -1
    end
end

%% Debut de l'algorithme
switch(choix)
    case 3
        % Variation du poids
        varWeight_courbe_NURBS(config, poids, points_controle, n);
    case {1,2}
        % Affichage du polygone de controle.
        figure(1)
        leg_ctrl = plot3(points_controle(1, :), points_controle(2, :), points_controle(3, :), '*k-');
        hold on;
        title(sprintf('NURBS de degré %d', n));
        
        switch(choix)
            case 1
                % Variation du degré
                varDegre_courbe_NURBS(config, poids, points_controle, n);
            case 2
                % Variation du vecteur nodal
                varKnot_courbe_NURBS(poids, points_controle, n);
        end
    case 4
        disp(['Affiche en 3ème dimension :']);
        disp(['==========================']);
        disp(['1 : Z.']);
        disp(['2 : le poids.']);
        aff = input('choix :');
        
        % Affichage du polygone de controle.
        figure(1)
        switch (aff)
            case 1
                leg_ctrl = plot3(points_controle(1, :), points_controle(2, :), points_controle(3, :), '*k-');
            case 2
                % Polygone de controle standard
                leg_ctrl = plot3(points_controle(1, :), points_controle(2, :), poids, '*r--');
                hold on;
                % Polygone de controle avec poids
                leg_ctrl2 = plot3(points_controle(1, :), points_controle(2, :), ones(1,length(points_controle(2, :))), '*b--'); 
        end
        title(sprintf('NURBS de degré %d', n));
        hold on;

        T = []; % Vecteur nodal
        r = ((length(points_controle) + n + 1) - 2*n)-1;
        % Creation de la suite du vecteur nodale
        switch(config)
            case -1
                % Cas special du cone
                T = [0, 0, 0, pi/2, pi/2, pi, pi, 3*pi/2, 3*pi/2, 2*pi, 2*pi, 2*pi];
            case 1
                T = [zeros(1,n), (0:r)/r, ones(1,n)];
            case 2
                T = [zeros(1,n), (0:demi_r)/r, ((demi_r/r)+0.1), ((demi_r+2):r), ones(1,n)];
            case 3
                T = [zeros(1,n), (ones(1,r+1)/2)+((0:r)/1000), ones(1,n)];
                rgb = [0, 0, pas_couleur*curr_W];
            otherwise
                disp(['Config choisie : T = [..., 0, 1/4, 1/2, 3/4, 1, ...]']);
                T = [zeros(1,n), (0:r)/r, ones(1,n)];
        end

        %% Check : nombre de noeud = nb pts de controle + degre + 1
        if length(T) ~= length(points_controle) + n + 1
            warning('Problème de paramètrisation : Nombre incorrect de noeuds dans le vecteur nodal.');
        end

        courbe = []; % Nurbs
        weight = [];
        t = linspace(T(1),T(end));
        for i = 1:length(t)
            [curr_c, curr_weight] = courbe_NURBS(T, poids, points_controle, n, t(i));
            courbe = [courbe, curr_c];
            weight = [weight, curr_weight];
        end
        
        % Affichage de la courbe courante
        figure(1)      
        switch (aff)
            case 1
                for k = 1:length(t)
                    nurbs = plot3(courbe(1, :), courbe(2, :), courbe(3, :), 'Color', 'r', 'LineWidth', 2);
                    hold on;
                end
            case 2
                % Projection de la courbe NURBS w = 1
                % et Sans la projection
                for k = 1:length(t)
                    nurbs = plot3(courbe(1, :), courbe(2, :), ones(1,length(courbe(2, :))), 'Color', 'b', 'LineWidth', 2);
                    hold on;
                    nurbs2 = plot3(courbe(1, :), courbe(2, :), weight, 'Color', 'r', 'LineWidth', 2);
                    hold on;
                end
        end

        leg_txt{2} = 'Courbe NURBS';
        switch (aff)
            case 1
                legend([leg_ctrl; nurbs], 'Polygone de contrôle','Courbe NURBS');
            case 2
                %legend([leg_ctrl, leg_ctrl2, nurbs, nurbs2], 'Polygone de contrôle w=1','Polygone de contrôle','Courbe NURBS w=1','Courbe NURBS');
        end
        
        if num == 3
            nb_pts = size(courbe,2);
            X = [courbe(1,:);
                 zeros(1,nb_pts)];
            Y = [courbe(2,:);
                 zeros(1,nb_pts)];
            Z = [ones(1,nb_pts);
                 zeros(1,nb_pts)];
            surf(X,Y,Z,'FaceColor',[0.8 0.8 0.8])
        end
        
end