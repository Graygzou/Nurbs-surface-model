[x,y] = saisi_points(false);

n = 0;

while n == 0 || n > length(x)
    n = input('Degré de la spline (n > nombre de points) ?');
end

    

legende = [];
figure;

plot([x x(1)], [y y(1)], 'r*-.');
legende{1} = 'Polygone de contrôle';
hold on;

pas_couleur = 1/length(x);
for k = 2:length(x)
    [points_spline] = subdivision([x;y], k, 3);
    
    if k == n
        plot([points_spline(1,:) points_spline(1,1)], [points_spline(2,:) points_spline(2,1)], 'Color', 'r', 'LineWidth',3);
    else if k == length(x)
            plot([points_spline(1,:) points_spline(1,1)], [points_spline(2,:) points_spline(2,1)], 'Color', [pas_couleur*k,0,pas_couleur*k], 'LineWidth',3);
        else
            plot([points_spline(1,:) points_spline(1,1)], [points_spline(2,:) points_spline(2,1)], 'Color', [pas_couleur*k,0,pas_couleur*k]);
        end
    end
    
    legende{k} = sprintf('Spline de degré %d', k);
    legend(legende);
    hold on;
end