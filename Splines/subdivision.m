function [points_spline] = subdivision(points, n, nb_subdivisions, fermee)
    if nargin < 4
        fermee = true;
    end

    for j = 1:nb_subdivisions
        %% Doubler les points de contrôle
        points_spline = [];

        for i = 1:size(points, 2)
            points_spline = [points_spline, points(:, i), points(:, i)];
        end

        for j = 1:n
            milieux = [];

            for k = 1:size(points_spline, 2)
                if fermee && (k == size(points_spline, 2))
                    % On ferme la spline en considérant que le premier et le
                    % dernier point sont voisins
                    point_droite = points_spline(:, 1);
                    point_gauche = points_spline(:, k);
                else
                    point_droite = points_spline(:, k+1);
                    point_gauche = points_spline(:, k);
                end

                milieux = [milieux, 0.5 * point_gauche + 0.5 * point_droite];
            end

            points_spline = milieux;
        end
        
        points = points_spline;
    end
end