clear all;

%noeuds = [0, 1, 2, 3, 4, 4.1, 5.1, 6.1, 7.1]
%noeuds = [0, 0, 0, 0, 1/4, 1/2, 3/4, 1, 1, 1, 1];
noeuds = [-1 -1 -1 -1 0 1 2 3 3 3 3];
%noeuds = [0, 1, 2, 3, 3, 4, 5, 5, 7.1];
%noeuds = [1 1 1 2 3 3.5 3.6 4 5 5 5];
% ici px = degre + 1 = 3 (donc p3)
%         p0 p1 p2 p3
%noeuds = [0 0.2 0.4 0.6 0.8 1];

x = linspace(noeuds(1),noeuds(end));

% degree
n = 2;

figure;
for i = 0:(length(noeuds)-1)-n-1
    results = [];
    for j = 1:length(x)
        results = [results, [x(j); N(noeuds, i+1, n, x(j))]];
    end
    
    plot(results(1,:), results(2,:));
    hold on;
end