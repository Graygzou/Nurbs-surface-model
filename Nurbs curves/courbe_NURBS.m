function [P,P_bis] = courbe_NURBS(noeuds, poids, points_controle, n, t)
%% Calcule le point P(x,y) correspondant � la NURBS � l'instant t voulu.

m = length(noeuds);

denominateur = 0;
numerateur = 0;
test = 0;
for i = 1:m-n-1
    base = N(noeuds, i, n, t);
    denominateur = denominateur + (poids(i) * base);
    test = test + poids(i);
    numerateur = numerateur + (poids(i) * points_controle(:,i) * base);
end
P_bis = denominateur;
P = numerateur ./ denominateur;

end

