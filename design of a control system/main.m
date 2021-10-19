clc; clear all;
s=tf('s');

% modelando o circuito G2(s)
G2=(0.251*s+0.01255)/(s^2+0.659*s+0.01674);
zero(G2);
pole(G2);

% extraíndo características de interesse para o análise e projeto
figure(1); pzmap(G2);
figure(2); rlocus(G2);
figure(3); step(G2);

% controlador PI com componente proporcional k=1
C1=1+1/s;
figure(4); step(feedback(C1*G2,1));

%% controlador PI ajustado através do método da resposta ao salto

% plot da linha tangente
[y,t] = step(G2,0:0.001:180);
h = mean(diff(t));
dy = gradient(y, h);                                            
[~,idx] = max(dy);                                             
b = [t([idx,idx+1]) ones(2,1)] \ y([idx,idx+1]);           
tv = [-b(2)/b(1); (1-b(2))/b(1)];                              
f = [t ones(size(t))] * b;                                     
figure(5);
plot(t, y); ylim([0 1.5]); xlim([0 180]);
hold on
plot(t, f,'--', 'Color', 'green');                     
plot(t(idx), y(idx), 'o','MarkerSize',6, 'MarkerEdgeColor','green', 'MarkerFaceColor',[1 .6 .6]);                   
hold off
grid

% métricas obtidas da resposta ao salto
L = .0001;
T = 2.977;
K = .747;
a = K*L/T;
k = .35/a;
Ti = 1.2*T;

% controlador PI
C2=(k*(s+1/Ti))/s;
figure(6); step(feedback(C2*G2,1));

% esforços de controle
figure(7), step(feedback(C1,G2));
figure(8), step(feedback(C2,G2));
