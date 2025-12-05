function pulse = rc(filterspan, rolloff, n_os, design_type)
%RC This
%   Inputs:
%   filterspan: Filterspan in number of symbols
%   rolloff:
%   n_os: oversampling factor
%   type: freq or time

assert(mod(filterspan,2)==0,'filterspan must be an even number');
pulse = zeros(1,filterspan*n_os);
switch (design_type)
    case 'freq'
    df = 1 / filterspan * n_os;
    f = ((-filterspan * n_os/2):(filterspan * n_os/2-1)) * df;   % centered bins in cycles per symbol

    % RC band edges (cycles per symbol)
    f0 = (1 - rolloff) / 2;
    f1 = (1 + rolloff) / 2;

    % Build ideal raised-cosine magnitude on that centered grid
    H = zeros(1, filterspan * n_os);
    for k = 1:filterspan * n_os
        a = abs(f(k));
        if a <= f0
            H(k) = 1;
        elseif a <= f1
            % NOTE: denominator is (f1 - f0) which = rolloff
            H(k) = 0.5 * (1 + cos( pi * (a - f0) / (f1 - f0) ));
        else
            H(k) = 0;
        end
    end

    % IFFT to time-domain:
    % H is defined with zero-frequency at center, so ifft(ifftshift(H))
    h = real( ifft( ifftshift(H) ) );

    % Center the impulse response (so main lobe is in middle)
    h = fftshift(h);

    % Trim/pad to the requested output length (we already used Nfft = filterspan*n_os)
    pulse = h(:).';   % row vector

    % normalize energy (optional but recommended)
    pulse = pulse / sqrt(sum(abs(pulse).^2));


    case 'time'
        t_axis = (0:(n_os*filterspan-1))/n_os - (filterspan/2);
        for idx = 1:n_os*filterspan
                t = t_axis(idx);
                if abs(t) < 1e-12
                    pulse(idx) = (1 - rolloff) + 4*rolloff/pi;
                elseif rolloff ~= 0 && abs(abs(t) - 1/(2*rolloff)) < (1e-6)
                    pulse(idx) = (rolloff/sqrt(2)) * ( (1 + 2/pi) * sin(pi/(2*rolloff)) + (1 - 2/pi) * cos(pi/(2*rolloff)) );
                else
                    numerator   = sin(pi*t*(1 - rolloff)) + 4*rolloff*t.*cos(pi*t*(1 + rolloff));
                    denominator = pi*t.*(1 - (4*rolloff*t).^2);
                    pulse(idx) = numerator ./ denominator;
                end
        end
        pulse = pulse / sqrt(sum(pulse.^2));
        %test: pulse_td = pulses.rc(200, 0.75, 8, 'time');
end 

end

