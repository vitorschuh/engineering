clc; clear all;

% frequencia de amostragem
fs = 4e6;

% lista de coeficientes das mensagens
an = [1, 9, 1, 0, 0, 5, 9, 1];

% lista de frequencias dos cossenos
wn = [600*pi, 900*pi, 1500*pi, 2400*pi, 3200*pi, 4200*pi, 5400*pi, 6800*pi];

% definicao das mensagens
t = [-1:1/fs:1];
m1 = 2 + an(1)*cos(wn(1).*t) + an(2)*cos(wn(2).*t) + an(3)*cos(wn(3).*t) + an(4)*cos(wn(4).*t) + an(5)*cos(wn(5).*t) + an(6)*cos(wn(6).*t) + an(7)*cos(wn(7).*t) + an(8)*cos(wn(8).*t);      
m2 = 6 + an(8)*cos(wn(1).*t) + an(7)*cos(wn(2).*t) + an(6)*cos(wn(3).*t) + an(5)*cos(wn(4).*t) + an(4)*cos(wn(5).*t) + an(3)*cos(wn(6).*t) + an(2)*cos(wn(7).*t) + an(1)*cos(wn(8).*t);      
m3 = 3 + cos(wn(1).*t) + 4*cos(wn(2).*t) + 9*cos(wn(3).*t) + 6*cos(wn(4).*t) + 3*cos(wn(5).*t) + 5*cos(wn(6).*t) + cos(wn(7).*t) + 5*cos(wn(8).*t);      

%% mensagens no tempo
figure(1);
subplot(3,1,1); plot(t, m1); axis([-0.017 0.017 -25 41]); xlabel('t(s)'); ylabel('m_1(t)'); title('Mensagem m_1(t)');
subplot(3,1,2); plot(t, m2); axis([-0.017 0.017 -25 41]); xlabel('t(s)'); ylabel('m_2(t)'); title('Mensagem m_2(t)');
subplot(3,1,3); plot(t, m3); axis([-0.017 0.017 -25 41]); xlabel('t(s)'); ylabel('m_3(t)'); title('Mensagem m_3(t)');

%% mensagens na frequencia
figure(2);
subplot(3,1,1); my_fft(fs, m1); xlim([-0.02*10e5 0.02*10e5]); xlabel('f(hz)'); ylabel('M_1(f)'); title('Espectro da mensagem m_1(t)');
subplot(3,1,2); my_fft(fs, m2); xlim([-0.02*10e5 0.02*10e5]); xlabel('f(hz)'); ylabel('M_2(f)'); title('Espectro da mensagem m_2(t)');
subplot(3,1,3); my_fft(fs, m3); xlim([-0.02*10e5 0.02*10e5]); xlabel('f(hz)'); ylabel('M_3(f)'); title('Espectro da mensagem m_3(t)');

%% como fl = 425khz e fh = 455khz (bw = 30khz), pode-se dividir a banda
% igualmente entre as tres mensagens

% frequencias centrais das portadoras
fp1 = 430e3*2*pi; 
fp2 = 440e3*2*pi;
fp3 = 450e3*2*pi;

% portadoras
p1 = cos(fp1.*t);
p2 = cos(fp2.*t);
p3 = cos(fp3.*t);

%% portadoras no dominio tempo
figure(3);
subplot(3,1,1); plot(t, p1); axis([-1.5*10e-5 1.5*10e-5 -1.3 1.3]); xlabel('t(s)'); ylabel('p_1(t)'); title('Portadora da mensagem m_1(t)');
subplot(3,1,2); plot(t, p2); axis([-1.5*10e-5 1.5*10e-5 -1.3 1.3]); xlabel('t(s)'); ylabel('p_2(t)'); title('Portadora da mensagem m_2(t)');
subplot(3,1,3); plot(t, p3); axis([-1.5*10e-5 1.5*10e-5 -1.3 1.3]); xlabel('t(s)'); ylabel('p_3(t)'); title('Portadora da mensagem m_3(t)');

%% portadoras no dominio frequencia
figure(4);
subplot(3,1,1); my_fft(fp1, p1); xlim([-0.5e6 0.5e6]); ylim([0 0.7]); xlabel('f(Hz)'); ylabel('P_1(f)'); title('Espectro da portadora da mensagem m_1(t)');
subplot(3,1,2); my_fft(fp2, p1); xlim([-0.5e6 0.5e6]); ylim([0 0.7]); xlabel('f(Hz)'); ylabel('P_2(f)'); title('Espectro da portadora da mensagem m_2(t)');
subplot(3,1,3); my_fft(fp3, p1); xlim([-0.5e6 0.5e6]); ylim([0 0.7]); xlabel('f(Hz)'); ylabel('P_3(f)'); title('Espectro da portadora da mensagem m_3(t)');

%% modulacao am dsb-sc
xm1 = m1.*p1;
xm2 = m2.*p2;
xm3 = m3.*p3;

%% mensagens modulados em am dsb-sc no dominio tempo
figure(5);
subplot(3,1,1); plot(t, xm1); axis([-0.017 0.017 -43 43]); xlabel('t(s)'); ylabel('xm_1(t)'); title('Mensagem m_1(t) modulada em amplitude');
subplot(3,1,2); plot(t, xm2); axis([-0.017 0.017 -43 43]); xlabel('t(s)'); ylabel('xm_2(t)'); title('Mensagem m_2(t) modulada em amplitude');
subplot(3,1,3); plot(t, xm3); axis([-0.017 0.017 -43 43]); xlabel('t(s)'); ylabel('xm_3(t)'); title('Mensagem m_3(t) modulada em amplitude');

%% mensagens modulados em am dsb-sc no dominio frequencia
figure(6);
subplot(3,1,1); my_fft(fs, xm1); xlim([0.41*10e5 0.47*10e5]); ylim([0 2.5]); xlabel('f(Hz)'); ylabel('XM_1(f)'); title('Espectro da mensagem m_1(t) modulada em amplitude');
subplot(3,1,2); my_fft(fs, xm2); xlim([0.41*10e5 0.47*10e5]); ylim([0 2.5]); xlabel('f(Hz)'); ylabel('XM_2(f)'); title('Espectro da mensagem m_2(t) modulada em amplitude');
subplot(3,1,3); my_fft(fs, xm3); xlim([0.41*10e5 0.47*10e5]); ylim([0 2.5]); xlabel('f(Hz)'); ylabel('XM_3(f)'); title('Espectro da mensagem m_3(t) modulada em amplitude');

% sinal completo transmitido no canal de comunicacao
xm = xm1 + xm2 + xm3;

%% sinal completo transmitido no dominio tempo
figure(7);
subplot(2,1,1); plot(t,xm); axis([-100*10e-5 100*10e-5 -110 110]); xlabel('t(s)'); ylabel('xm(t)'); title('Informa��o no canal de comunica��o');
subplot(2,1,2); plot(t,xm); axis([-1.5*10e-5 1.5*10e-5 -110 110]); xlabel('t(s)'); ylabel('xm(t)'); title('Informa��o aproximada');

%% espectro do sinal completo transmitido
figure(8);
subplot(2,1,1); my_fft(fs, xm); xlim([-1*1e6 1*1e6]); ylim([0 2.5]); xlabel('f(Hz)'); ylabel('XM(f)'); title('Espectro do canal de comunica��o no dom�nio frequ�ncia');
subplot(2,1,2); my_fft(fs, xm); xlim([0.41*1e6 0.47*1e6]); ylim([0 2.5]); xlabel('f(Hz)'); ylabel('XM(f)'); title('Espectro aproximado'); 

%% projeto dos filtros butterworth passa faixa
fl1 = 425e3/(fs/2); fh1 = 435e3/(fs/2);
[b1,a1] = butter(3,[fl1 fh1],'bandpass');
fbpm1 = filtfilt(b1,a1,xm);
fl2 = 435e3/(fs/2); fh2 = 445e3/(fs/2);
[b2,a2] = butter(3,[fl2 fh2],'bandpass');
fbpm2 = filtfilt(b2,a2,xm);
fl3 = 445e3/(fs/2); fh3 = 455e3/(fs/2);
[b3,a3] = butter(3,[fl3 fh3],'bandpass');
fbpm3 = filtfilt(b3,a3,xm);

%% mensagens filtradas no dominio tempo
figure(9);
subplot(3,1,1); plot(t,fbpm1); axis([-0.015 0.015 -35 35]); xlabel('t(s)'); ylabel('fbp_{m1}(t)'); 
subplot(3,1,2); plot(t,fbpm2); axis([-0.015 0.015 -35 35]); xlabel('t(s)'); ylabel('fbp_{m2}(t)'); 
subplot(3,1,3); plot(t,fbpm3); axis([-0.015 0.015 -35 35]); xlabel('t(s)'); ylabel('fbp_{m3}(t)'); 

%% espectro das mensagens filtradas
figure(10);
subplot(3,1,1); my_fft(fs, fbpm1); xlabel('f(hz)'); ylabel('f_1(hz)'); title('Filtro passa faixa para a mensagem m_1');
subplot(3,1,2); my_fft(fs, fbpm2); xlabel('f(hz)'); ylabel('f_2(hz)'); title('Filtro passa faixa para a mensagem m_2');
subplot(3,1,3); my_fft(fs, fbpm3); xlabel('f(hz)'); ylabel('f_3(hz)'); title('Filtro passa faixa para a mensagem m_3');

%% projeto dos modulos demoduladores multiplicadores
demodmult_m1 = 2*fbpm1.*p1;
demodmult_m2 = 2*fbpm2.*p2;
demodmult_m3 = 2*fbpm3.*p3;

%% demodulacao am dsb-sc no tempo 
figure (11);
subplot(3,1,1); plot(t, demodmult_m1); axis([-0.017 0.017 -44 82]); xlabel('t(s)'); ylabel('Amplitude do sinal (t)'); title('Sa�da do demodulador multiplicador da mensagem m_1(t)');
subplot(3,1,2); plot(t, demodmult_m2); axis([-0.017 0.017 -44 82]); xlabel('t(s)'); ylabel('Amplitude do sinal (t)'); title('Sa�da do demodulador multiplicador da mensagem m_2(t)');
subplot(3,1,3); plot(t, demodmult_m3); axis([-0.017 0.017 -44 82]); xlabel('t(s)'); ylabel('Amplitude do sinal (t)'); title('Sa�da do demodulador multiplicador da mensagem m_3(t)');

%% demodulacao am dsb-sc na frequencia
figure(12);
subplot(3,1,1); my_fft(fs, demodmult_m1); xlim([-0.02*10e5 0.02*10e5]); ylim([0 5]); xlabel('f(Hz)'); ylabel('Espectro do sinal (f)'); title('Espectro da sa�da do demodulador multiplicador da mensagem m_1(t)');
subplot(3,1,2); my_fft(fs, demodmult_m2); xlim([-0.02*10e5 0.02*10e5]); ylim([0 5]); xlabel('f(Hz)'); ylabel('Espectro do sinal (f)'); title('Espectro da sa�da do demodulador multiplicador da mensagem m_2(t)');
subplot(3,1,3); my_fft(fs, demodmult_m3); xlim([-0.02*10e5 0.02*10e5]); ylim([0 5]); xlabel('f(Hz)'); ylabel('Espectro do sinal (f)'); title('Espectro da sa�da do demodulador multiplicador da mensagem m_3(t)');

%% projeto dos filtros butterworth passa baixa
[b4,a4] = butter(3,(440e3*2)/fs,'low');
m1_bak = filtfilt(b4, a4, demodmult_m1);
[b5,a5] = butter(3,(440e3*2)/fs,'low');
m2_bak = filtfilt(b5, a5, demodmult_m2);
[b6,a6] = butter(3,(440e3*2)/fs,'low');
m3_bak = filtfilt(b6, a6, demodmult_m3);

%% mensagens recuperadas no tempo
figure(13);
subplot(3,1,1); plot(t, m1_bak); axis([-0.017 0.017 -25 41]); xlabel('t(s)'); ylabel('m_1(t)'); title('Mensagem m_1(t) recuperada');
subplot(3,1,2); plot(t, m2_bak); axis([-0.017 0.017 -25 41]); xlabel('t(s)'); ylabel('m_2(t)'); title('Mensagem m_2(t) recuperada');
subplot(3,1,3); plot(t, m3_bak); axis([-0.017 0.017 -25 41]); xlabel('t(s)'); ylabel('m_3(t)'); title('Mensagem m_3(t) recuperada');

%% espectro das mensagens recuperadas
figure(14);
subplot(3,1,1); my_fft(fs, m1_bak); xlim([-0.02*10e5 0.02*10e5]); ylim([0 5]); xlabel('f(Hz)'); ylabel('M_1(f)'); title('Espectro da mensagem m_1(t) recuperada');
subplot(3,1,2); my_fft(fs, m2_bak); xlim([-0.02*10e5 0.02*10e5]); ylim([0 5]); xlabel('f(Hz)'); ylabel('M_2(f)'); title('Espectro da mensagem m_2(t) recuperada'); 
subplot(3,1,3); my_fft(fs, m3_bak); xlim([-0.02*10e5 0.02*10e5]); ylim([0 5]); xlabel('f(Hz)'); ylabel('M_3(f)'); title('Espectro da mensagem m_3(t) recuperada');