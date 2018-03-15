%% recupere une liste de points cliqués sur la fenetre
function [X,Y,P] = saisi_points(ajouter_temps)

disp('Veuillez saisir des points.');
clearvars all -except ajouter_temps; close all;
figure(1);
axis([0 1 0 1])
b=1;
t = 1;
X=[];
Y=[];
disp('Taper RETURN apres le dernier point.');
while ( b==1 )
[x,y,b]= ginput(1);

if ajouter_temps
    X=[X [x; t]];
    Y=[Y [y; t]];
    disp('Des temps equidistants ont ete ajoutes.');
else
    X = [X x];
    Y = [Y y];
end
t = t + 1;

figure(1)
hold on
plot(x,y,'r+'); %dessine les points un à un
hold off
end;
P=[X;Y];

hold on;

disp('Fin de saisie des points.');
end
