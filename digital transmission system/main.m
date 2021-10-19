clc; clear all;
t = -1:1e-6:1;

%%Hjw = 7.5e12 / (jw^3 + 37e3jw^2 + 610e6jw 7.5e12)

b = 7.5*10^12;
a = [1  37*10^3  610*10^6  7.5*10^12];
[r, p, k] = residue(b, a);
[angle, mag] = cart2pol(real(r), imag(r));

%r =

%   1.0e+04 *

%   1.2400 + 0.0000i
%  -0.6200 - 0.6987i
%  -0.6200 + 0.6987i


%p =

%   1.0e+04 *

%  -2.4597 + 0.0000i
%  -0.6202 + 1.6324i
%  -0.6202 - 1.6324i


%k =

%     []


%angle =

%         0
%   -2.2966
%    2.2966


%mag =

%   1.0e+04 *

%    1.2400
%    0.9341
%    0.9341

ht = (12400.*exp(-24597.*t) + 18682.*exp(-6202.*t).*cos((-16324.*t)+2.2966)) .* u(t);
figure(1); plot(t, ht); xlim([0 0.1e-2]); title('Transformada inversa do canal aproximada na janela de settling');

ht2 = tf(b, a);
figure(2); impulse(ht2);

%% bitstream gen
ts = 7e-3;
dt = 1e-5;

n_ex = 10;
bitstream_ex = randi([0 1], 1, 2*n_ex);
[cod_ex, t_ex] = pam4(bitstream_ex, ts, dt);
figure(3); plot(t_ex, cod_ex); ylim([-3.5 3.5]); title('Amostra codificada em PAM4');

n = 200;
bitstream = randi([0 1], 1, 2*n);
[cod, t] = pam4(bitstream, ts, dt);
figure(4); plot(t, cod); ylim([-3.5 3.5]); title('Bitstream de 200x2 amostras codificada em PAM4')

%% sinal transmitido
ht = (12400.*exp(-24597.*t) + 18682.*exp(-6202.*t).*cos((-16324.*t)+2.2966)) .* u(t);
x = (conv(ht, cod)).*dt;
figure(5); plot(t,x(1:length(t))); title('Sinal transmitido');

%% eye
ts = .55e-3;
n_arg = round(((ts/2))/dt);
eyediagram(x(1:length(t)), n_arg, ts, 25);
