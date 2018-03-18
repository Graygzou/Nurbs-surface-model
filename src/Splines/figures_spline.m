function [X,Y,Z] = figures_spline(num)
    switch(num)
        case 1
            % Exemple de base : Grille
            [X,Y] = meshgrid(0:0.25:1,0:0.25:1);
            Z = exp(-((X-1/2).^2+(Y-1/2).^2));
        case 2
            % Tore 1
            X = [0 1/4 1/2 1/4; 1/2*ones(1,4); 1 3/4 1/2 3/4; 1/2*ones(1,4)];
            Y = [1/2*ones(1,4); 0 1/4 1/2 1/4; 1/2*ones(1,4); 1 3/4 1/2 3/4];
            Z = repmat([1/2 1 1/2 0],4,1);
        case 3
            % Tore 2
            X = meshgrid(0:4,0:5);
            Z = [2 1 1 1 2;
                 2 2 2 2 2;
                 2 3 3 3 2;
                 2 3 3 3 2;
                 2 2 2 2 2;
                 2 1 1 1 2];
            Y = [2 3 3 3 2;
                 2 4 4 4 2;
                 2 3 3 3 2;
                 2 1 1 1 2;
                 2 0 0 0 2;
                 2 1 1 1 2];
    end
    %% Affichage
    figure(1)
    surf([X; X(1,:)],[Y; Y(1,:)],[Z; Z(1,:)],'FaceColor','interp'); % permet de visualiser la grille de points 3D
    title('Figure choisie');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    hold on;
    plot3(X, Y, Z, '*r-');
end

