clc; clear all;
s = tf('s');

% planta 1
G1 = (s+30)/((s+1)*(s+3));
figure(1)
step(G1); xlim([0 10]); ylim([-10 20]); % normalizando com a step response 

% def para plotar uma reta tangente a step response
[y,t] = step(G1,0:0.001:10);
h = mean(diff(t));
dy = gradient(y, h);                                            
[~,idx] = max(dy);                                             
b = [t([idx-1,idx+1]) ones(2,1)] \ y([idx-1,idx+1]);           
tv = [-b(2)/b(1); (1-b(2))/b(1)];                              
f = [t ones(size(t))] * b;                                     
figure(2);
plot(t, y); ylim([-10 20]);
hold on
plot(t, f,'--', 'Color', 'green');ylim([-10 20]);                     
plot(t(idx), y(idx), 'o','MarkerSize',6, 'MarkerEdgeColor','green', 'MarkerFaceColor',[1 .6 .6]);ylim([-10 20]);                   
hold off
grid

%projeto do primeiro PID
L = 0.118;
T = 1.732; % [0.118~1.85]
K = 10;
a = (K*L)/T;
Ti = 2*L;
Td = L/2;
Kp = 1.2/a;
Ki = Kp/Ti;
Kd = Kp*Td;
C1 = pid(Kp,Ki,Kd);

% avaliando o sistema após a adiçao do PID
figure(3);
step(feedback(C1*G1,1)); 
figure(4);
step(feedback(1,C1*G1)); 

% otimizaçao da resposta a referencia
% overshot 0%
Ti = T;
Td = L/2;
Kp = .6/a;
Ki = Kp/Ti;
Kd = Kp*Td;
C1alt1 = pid(Kp,Ki,Kd);
% overshot 20%
Ti = 1.4*T;
Td = .47*L;
Kp = .95/a;
Ki = Kp/Ti;
Kd = Kp*Td;
C1alt2 = pid(Kp,Ki,Kd);

% otimizaçao da resposta a perturbaçao
% overshot 0%
Ti = 2.4*L;
Td = .47*L;
Kp = .95/a;
Ki = Kp/Ti;
Kd = Kp*Td;
C1alt3 = pid(Kp,Ki,Kd);
% overshot 20%
Ti = 2*L;
Td = .42*L;
Kp = 1.2/a;
Ki = Kp/Ti;
Kd = Kp*Td;
C1alt4 = pid(Kp,Ki,Kd);

% planta 2
G2 = (s+30)/(s^3+18*s^2+99*s+162); 
figure(5);
step(G2);
figure(6);
rlocus(G2);
kc = 135;
figure(7);
step(feedback(G2*kc,1));
Tc = 0.5;
Ti = .25;
Td = .0625;
Kp = 81;
Ki = Kp/Ti;
Kd = Kp*Td;
C2 = pid(Kp,Ki,Kd);
figure(8); step(feedback(C2*G2,1));

%% parte 2
s=tf('s');

% planta 3
G3=12/((s+1)*(s+3)*(s+7));
[y,t] = step(G3,0:0.001:10);
h = mean(diff(t));
dy = gradient(y, h);                                            
[~,idx] = max(dy);                                             
b = [t([idx-1,idx+1]) ones(2,1)] \ y([idx-1,idx+1]);           
tv = [-b(2)/b(1); (1-b(2))/b(1)];                              
f = [t ones(size(t))] * b;                                     
figure(9);
plot(t, y); 
hold on
plot(t, f,'--', 'Color', 'green');                    
plot(t(idx), y(idx), 'o','MarkerSize',6, 'MarkerEdgeColor','green', 'MarkerFaceColor',[1 .6 .6]);
hold off
grid

% projeto do PID para a planta 3
L = 0.272;
T = 1.799;
K = 0.57;
a = K*L/T;
Ti = 2*L;
Td = L/2;
Kp = 1.2/a;
Ki = Kp/Ti;
Kd = Kp*Td;
C3 = pid(Kp,Ki,Kd);
figure(10); step(feedback(C3*G3,1));

% planta 3 alterada 
s=tf('s');
G3tunned=160.75/((s+9.733)*(s^2 + 1.267*s + 18.67));
[y,t] = step(G3tunned,0:0.001:10);
h = mean(diff(t));
dy = gradient(y, h);                                            
[~,idx] = max(dy);                                             
b = [t([idx-1,idx+1]) ones(2,1)] \ y([idx-1,idx+1]);           
tv = [-b(2)/b(1); (1-b(2))/b(1)];                              
f = [t ones(size(t))] * b;                                     
figure(11);
plot(t, y); 
hold on
plot(t, f,'--', 'Color', 'green');                     
plot(t(idx), y(idx), 'o','MarkerSize',6, 'MarkerEdgeColor','green', 'MarkerFaceColor',[1 .6 .6]);                   
hold off
grid

% projeto do PID para a planta 3 alterada
L = 0.19;
T = .315;
K = .8862;
a = K*L/T;
Ti = 2*L;
Td = L/2;
Kp = 1.2/a;
Ki = Kp/Ti;
Kd = Kp*Td;
C3t = pid(Kp,Ki,Kd);
figure(12); step(feedback(C3t*G3tunned,1));

%% planta cesinha
s=tf('s');
gc=(0.1)/(s^2 + 1.1*s + 0.15);
[y,t] = step(gc,0:0.001:30);
h = mean(diff(t));
dy = gradient(y, h);                                            
[~,idx] = max(dy);                                             
b = [t([idx-1,idx+1]) ones(2,1)] \ y([idx-1,idx+1]);           
tv = [-b(2)/b(1); (1-b(2))/b(1)];                              
f = [t ones(size(t))] * b;                                     
figure(9);
plot(t, y); 
hold on
plot(t, f,'--', 'Color', 'green');                    
plot(t(idx), y(idx), 'o','MarkerSize',6, 'MarkerEdgeColor','green', 'MarkerFaceColor',[1 .6 .6]);
hold off
grid