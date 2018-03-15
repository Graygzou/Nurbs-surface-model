[x,y] = saisi_points(false);

n = 0;

while n == 0 || n > length(x)
    n = input('Degré de la spline (n > nombre de points) ?');
end



legende = [];
figure;

plot(x, y, 'r*-.');
legende{1} = 'Polygone de contrôle';
hold on;

pas_couleur = 1/length(x);
for k = 2:length(x)
    [points_spline] = subdivision([x;y], k, true);
    if k == n
        plot(points_spline(1,:), points_spline(2,:), 'Color', 'r', 'LineWidth',4);
    else
        plot(points_spline(1,:), points_spline(2,:), 'Color', [0, 0, pas_couleur*k]);
    end
    
    if k == length(x)
        legende{k} = 'Courbe de Bézier';
    else
        legende{k} = sprintf('Spline de degré %d', k);
    end
    legend(legende);
    hold on;
end