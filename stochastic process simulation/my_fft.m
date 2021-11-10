function my_fft(fs, x)
        n = length(x);
        X = fftshift(fft(x, n));
        f = fs*[-n/2:n/2-1]/n;
        plot(f, abs(X)/n);
end
        