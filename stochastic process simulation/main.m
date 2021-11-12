clc; clear all;

dt = 2e-4;
l = -1;
h = 1;
t = l:dt:h-dt;
trap_impact = .5;

% metricas tc do art alan
tc_1 = [1e-3, 1e-3];
tc_2 = [1e-2, 1e-4];
tc_3 = [1e-1, 1e-5];
tc_4 = [1e-4, 1e-4];
tc_5 = [1e-3, 1e-5];

% verificacao do ruido
bitstream = rtn_simple(t, dt, tc_1, trap_impact);
figure(1); plot(t, bitstream); title('Bitstream de 50 bits referente ao fenômeno de ruído telegráfico aleatório');

%% simulacoes montecarlo
monte = 1;
p_avg = 0;
p_avg_filt = 0;
half_l = l/2;
half_h = h/2;
tau = half_l:dt:half_h-dt;
rx_ensemble_1 = zeros(1,length(tau));
rx_ensemble_1_filt = zeros(1,length(tau));

for i = 1:(monte)
    let = [0 0];
    p_rms = [0 0];
    ensemble_1(1,:) = rtn_simple(t, dt, tc_1, trap_impact);
    ensemble_1_filt(1,:) = fpb(ensemble_1, t, dt, 1);
   
    for p_1 = 1:length(t)
        p_rms(1) = p_rms(1) + ensemble_1(1,p_1)^2;
    end
    let(1) = let(1) + p_rms(1);
    
    for p_2 = 1:length(t)
        p_rms(2) = p_rms(2) + ensemble_1_filt(1,p_2)^2;
    end
    let(2) = let(2) + p_rms(2);
    
    for j = 1:length(rx_ensemble_1)
        rx_ensemble_1(j) = rx_ensemble_1(j) + ensemble_1(1,0.5*(length(ensemble_1(1,:)))) ...
            * ensemble_1(1,(0.5*(length(ensemble_1(1,:)))) - (0.5 * (length(tau))) + j);
        rx_ensemble_1_filt(j) = rx_ensemble_1_filt(j) + ensemble_1_filt(1,0.5*(length(ensemble_1_filt(1,:)))) ...
            * ensemble_1_filt(1,(0.5*(length(ensemble_1_filt(1,:)))) - (0.5 * (length(tau))) + j);
    end
    % plots montecarlo individuais
    figure(2); plot(t, ensemble_1); title('Ensemble de 100 sorteios da simulação monte carlo do processo aleatório pré-filtragem');
    figure(3); plot(t, ensemble_1_filt); title('Ensemble de 100 sorteios da simulação monte carlo do processo aleatório pós-filtragem');
    
    % sobreposição dos ensembles
    figure(4); plot(t, ensemble_1); hold on; plot(t, ensemble_1_filt); title('Sobreposição dos ensembles pré e pós-filtragem');
end

% reports de potencia
p_avg = let(1)/(length(t)*(monte));
p_avg
p_avg_filt = let(2)/(length(t)*(monte));
p_avg_filt

% plots de autocorrelacao
figure(5); plot(tau, rx_ensemble_1/monte); title('Autocorrelação rx do ensemble');
figure(6); plot(tau, rx_ensemble_1_filt/monte); title('Autocorrelação rx do ensemble filtrado');

%% densidade espectral de potencia rx_ensemble
figure(7); void_fft(1/dt,rx_ensemble_1); title('Densidade espectral de potência do ensemble');
[X_1, f_1] = return_fft(1/dt, rx_ensemble_1);
figure(8); loglog(f_1, abs(X_1)); title('Densidade espectral de potência do ensemble em escala log x log');

%% densidade espectral de potencia rx_ensemble_filt
figure(9); void_fft(1/dt,rx_ensemble_1_filt); title('Densidade espectral de potência do ensemble filtrado');
[X_2, f_2] = return_fft(1/dt, rx_ensemble_1_filt);
figure(10); loglog(f_2, abs(X_2)); title('Densidade espectral de potência do ensemble filtrado em escala log x log');

% funcoes auxiliares
function [x] = ht(t)
    for i = 1:length(t)
        if t(i) >= 0
            x(i) = (.905e3)*exp(-1e3*t(i));
        else
            x(i) = 0;
        end
    end   
end

function [y] = fpb(x, t, dt, monte)
    for i = 1:monte
        y = dt*(conv(ht(t),x(i,:), 'same'));
    end
end

function [X, f] = return_fft(fs, x)
        n = length(x);
        X = fftshift(fft(x, n));
        f = fs*[-n/2:n/2-1]/n;
end

function void_fft(fs, x)
        n = length(x);
        X = fftshift(fft(x, n));
        f = fs*[-n/2:n/2-1]/n;
        plot(f, abs(X)/n);
end
        
% algumas variáveis possuem o _1 no identificador pq a ideia era usar tc_1, tc_2, ..., tc_5
