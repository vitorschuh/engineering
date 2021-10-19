clc; clear all;

% frequencia de amostragem 
fs = 175e6;
t = [-0.01:(1/fs):0.01];

% lista de coeficientes das mensagens
an = [1, 9, 1, 0, 0, 5, 9, 1];

% lista de  frequencias dos cossenos
wn = [640*pi, 1040*pi, 1700*pi, 2800*pi, 4600*pi, 7400*pi, 12200*pi, 20000*pi];

%% mensagens
ml = (1/10)*(10 + an(1)*cos(wn(1).*t) + an(2)*cos(wn(2).*t) + an(3)*cos(wn(3).*t) + an(4)*cos(wn(4).*t) + an(5)*cos(wn(5).*t) + an(6)*cos(wn(6).*t) + an(7)*cos(wn(7).*t) + an(8)*cos(wn(8).*t));
mr = (1/10)*(10 + an(8)*cos(wn(1).*t) + an(7)*cos(wn(2).*t) + an(6)*cos(wn(3).*t) + an(5)*cos(wn(4).*t) + an(4)*cos(wn(5).*t) + an(3)*cos(wn(6).*t) + an(2)*cos(wn(7).*t) + an(1)*cos(wn(8).*t));
figure(1)
subplot(2,1,1); plot(t, ml); xlabel('t(s)'); ylabel('m_L(t)'); title('Sinal modulante m_L(t)');
subplot(2,1,2); plot(t, mr); xlabel('t(s)'); ylabel('m_R(t)'); title('Sinal modulante m_R(t)');
figure(2)
subplot(2,1,1); my_fft(fs, ml); xlabel('f(hz)'); ylabel('M_L(f)'); title('Espectro do sinal m_L(t)'); xlim([-.01e6 .01e6]);
subplot(2,1,2); my_fft(fs, mr); xlabel('f(hz)'); ylabel('M_R(f)'); title('Espectro do sinal m_R(t)'); xlim([-.01e6 .01e6]);

% m(t) = [ml(t) + mr(t)] + [ml(t) - mr(t)]cos(2wpt) + kcos(wpt)

% frequencia do sinal piloto = 19e3 hz
wp = 2 * pi * 19e3;
wphz = 19e3;

% amplitude do sinal piloto = 30%
k = .3;

% subportadora 
subp = cos(2 * wp .* t);

% piloto
pilot = k .* cos(wp.*t);

%% multiplexacao estereo
m = (ml + mr) + (ml - mr) .* subp + pilot;
figure(3)
subplot(2,1,1); plot(t, m); xlabel('t(s)'); ylabel('m(t)'); title('Sinal multiplexado');
subplot(2,1,2); my_fft(fs, m); xlabel('f(hz)'); ylabel('M(f)'); title('Espectro do sinal multiplexado'); xlim([-.01e6 .01e6]);

% frequencia central da portadora, fl = 76MHz e fl = 76.2MHz
wc = 76.1e6;

% amplitude maxima da mensagem
Am = (max(m) - min(m))/2;

% wm 
wm = 20000*pi; % rad/s
wmhz = 10e3; % hz

% delta w
% bw = 2deltaw + 2wm => deltaw = (bw - 2wm)2
deltaw = (180e3 - wmhz)/2;

% kf
kf = 2 * pi * (deltaw/Am);

% integracao do sinal da mensagem
a = (1/fs) .* cumsum(m);

%% sinais de portadora
figure(4);
subplot(2,1,1); plot(t, cos(wc * 2 * pi .* t)); xlabel('t(s)'); ylabel('p(t)'); title('Sinal de portadora no domínio tempo'); xlim([-5e-6 5e-6]); ylim([-1.5 1.5]);
subplot(2,1,2); my_fft(fs, cos(wc * 2 * pi .* t)); xlabel('f(hz)'); ylabel('P(f)'); title('Espectro do sinal de portadora'); % xlim([-.01e6 .01e6]);

%% mod fm
mmod = cos(2 * wc * pi .* t + kf .* a);
figure(5);
plot(t, mmod); xlabel('t(s)'); ylabel('s_{mod}(t)'); title('Sinal modulado em FM'); ylim([-1.5 1.5]); xlim([-.8e-6 .8e-6]); 
figure(6);
subplot(2,1,1); my_fft(fs, mmod); xlabel('f(hz)'); ylabel('S_{mod}(f)'); title('Espectro do sinal modulado em FM'); ylim([0 0.07]);
subplot(2,1,2); my_fft(fs, mmod); xlabel('f(hz)'); ylabel('S_{mod}(f)'); title('Ampliação das componentes do eixo positivo'); xlim([7.595e7 7.630e7]); ylim([0 0.07]);

%% demod fm
mdemod = fmdemod(mmod,wc,fs,kf/(2*pi));
figure(7);
subplot(3,1,1); plot(t, mdemod); xlabel('t(s)'); ylabel('s_{demod}(t)'); title('Sinal demodulado em FM'); xlim([-0.01 0.01]); ylim([-4 8])
subplot(3,1,2); my_fft(fs, mdemod); xlabel('f(hz)'); ylabel('S_{demod}(f)'); title('Espectro do sinal demodulado em FM');
subplot(3,1,3); my_fft(fs, mdemod); xlabel('f(hz)'); ylabel('S_{demod}(f)'); title('Ampliação das componentes do espectro do sinal demodulado'); xlim([-.01e6 .01e6]);% ylim([0 0.001])


%% demult 
impulso = t == 0;

% passa baixas de banda base
fc = 13e3/(fs/2);
[num, den] = butter(4, fc, 'low');
fpb = filtfilt(num, den, mdemod);
fpb_i = filtfilt(num, den, double(impulso));

figure(8);
my_fft(fs, mdemod); hold on; xlim([-1e5 1e5]); title('Filtros aplicados à mensagem demodulada');
my_fft(fs, fpb_i.*10e6); hold on; xlim([-.5e5 .5e5]);

% passa faixa centrado em 19kHz
fl_19 = 17e3/(fs/2);
fh_19 = 21e3/(fs/2);
[b_19, a_19] = butter(2, [fl_19, fh_19], 'bandpass');
fpf_19 = filtfilt(b_19, a_19, mdemod);
fpf_19_i = filtfilt(b_19, a_19, double(impulso));
my_fft(fs, fpf_19_i.*2e6); hold on; xlim([-.5e5 .5e5]);


% passa faixa centrado em 38kHz
fl_38 = 25e3/(fs/2);
fh_38 = 51e3/(fs/2);
[b_38, a_38] = butter(2, [fl_38, fh_38], 'bandpass');
fpf_38 = filtfilt(b_38, a_38, mdemod);
fpf_38_i = filtfilt(b_38, a_38, double(impulso));
my_fft(fs, fpf_38_i.*1e6); hold on; xlim([-.5e5 .5e5]);

%% duplicador de frequencia
dup_19 = (2 * (fpf_19 .* fpf_19) - 1);

% demodulador
multdemod = dup_19 .* fpf_38;

% filtro passa baixa da multiplicacao
fpb_sum = filtfilt(num, den, multdemod);

ml_bak = fpb + fpb_sum; % 2ml
mr_bak = fpb - fpb_sum; % 2mr

figure(9);
subplot(2,1,1); plot(t, ml_bak/2); hold on; title('Sobreposição da mensagem m_L(t) recuperada (azul) e emitida (laranja) no domínio tempo');
subplot(2,1,1); plot(t, ml, '--');
xlim([-.01 .01]); ylim([-3 5]);
subplot(2,1,2); plot(t, ml); hold on; title('Ampliação para uma janela de tempo menor');
xlim([-.002 .002]); ylim([-3 5]);
subplot(2,1,2); plot(t, ml_bak/2, '--');
xlim([-.002 .002]); ylim([-3 5]);

%%
figure(10);
subplot(2,1,1); plot(t, mr_bak/2); hold on; title('Sobreposição da mensagem m_R(t) recuperada (azul) e emitida (laranja) no domínio tempo');
subplot(2,1,1); plot(t, mr, '--'); 
xlim([-.01 .01]); ylim([-3 5]);
subplot(2,1,2); plot(t, mr_bak/2); hold on; title('Ampliação para uma janela de tempo menor');
xlim([-.002 .002]); ylim([-3 5]);
subplot(2,1,2); plot(t, mr, '--');
xlim([-.002 .002]); ylim([-3 5]);

%%
figure(11);
subplot(3,1,1); my_fft(fs, ml); title('Espectro da mensagem m_L emitida'); xlim([-.01e6 .01e6]);
subplot(3,1,2); my_fft(fs, ml_bak/2); title('Espectro da mensagem m_L recuperada'); xlim([-.01e6 .01e6]);
subplot(3,1,3); my_fft(fs, ml_bak/2); hold on; title('Sobreposição dos espectros da m_L recuperada (azul) e emitida (laranja)');
subplot(3,1,3); my_fft(fs, ml);
xlim([-.01e6 .01e6]);

figure(12);
subplot(3,1,1); my_fft(fs, mr); title('Espectro da mensagem m_R emitida'); xlim([-.01e6 .01e6]);
subplot(3,1,2); my_fft(fs, mr_bak/2); title('Espectro da mensagem m_R recuperada'); xlim([-.01e6 .01e6]);
subplot(3,1,3); my_fft(fs, mr_bak/2); hold on; title('Sobreposição dos espectros da m_R recuperada (azul) e emitida (laranja)');
subplot(3,1,3); my_fft(fs, mr);
xlim([-.01e6 .01e6]);


