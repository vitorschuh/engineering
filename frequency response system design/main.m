clc; clear all;
s = tf('s');

G = (-0.56*s)/(0.16*s^2 - 0.26*s + 8);
figure(1)
step(feedback(G,1));

% k=-271,4 para que o erro seja igual a 0,05dB
k = -271.4;
C = k/s;
figure(2)
bode(G); hold on;
bode(C*G);
legend('G(s)','C(s)G(s)');

% lead
a2 = 52.2729;
tau = 0.01152;
freq1 = 1/(a2*tau);
freq2 = 1/tau;
fasemax = asin((a2-1)/(a2+1));
lead = (a2*tau*s + 1)/(tau*s + 1);
H = C * lead * G;
figure(3);
bode(H);

% SC completo
figure(4);
bode(G); hold on;
bode(C*G); hold on;
bode(H);
legend('G(s)','C(s)G(s)','Clead(s)C(s)G(s)');