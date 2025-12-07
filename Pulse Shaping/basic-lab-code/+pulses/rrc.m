%Group: Sude Topgül & Antonia Juncu

function pulse = rrc(filterspan, rolloff, n_os, design_type)
%RRC This
%   Inputs:
%   filterspan: Filterspan in number of symbols
%   rolloff:
%   n_os: oversampling factor
%   type: freq or time
%   the period T is assumed to be 1

assert(mod(filterspan,2)==0,'filterspan must be an even number');
pulse = zeros(1,n_os*filterspan);
N = n_os * filterspan; 

% centered time axis
t = ((0:N-1) - N/2) / n_os;   % in symbol periods

switch lower(design_type)
    case 'time'
        tol = 1e-12;
        if rolloff == 0
            pulse = sinc(t);
        else
            % closed-form eq. (4.8)
            % general numerator/denominator
            numer = sin(pi .* (t) .* (1 - rolloff)) + (4*rolloff .* (t)) .* cos(pi .* (t) .* (1 + rolloff));
            denom = pi .* (t) .* (1 - (4*rolloff .* (t)).^2);
            % regular points
            idx_reg = (abs(t) > tol) & (abs(abs(4*rolloff.*t) - 1) > 1e-8);
            pulse(idx_reg) = ( numer(idx_reg) ./ denom(idx_reg) );
            % t == 0
            idx0 = abs(t) <= tol;
            if any(idx0)
                pulse(idx0) = (1 - rolloff + (4*rolloff/pi));
            end
            % t == +/- T/(4*rolloff)
            if rolloff ~= 0
                t_sp = 1 / (4*rolloff);
                idx_sp = abs(abs(t) - t_sp) < 1e-8;
                if any(idx_sp)
                    pulse(idx_sp) = (rolloff / sqrt(2)) * ( (1 + 2/pi) * sin(pi/(4*rolloff)) + (1 - 2/pi) * cos(pi/(4*rolloff)) );
                end
            end
        end

    case 'freq'
        % build RC spectrum then take sqrt
        df = 1 / N;
        f = ((-N/2):(N/2-1)) * df;
        f0 = (1 - rolloff) / 2;
        f1 = (1 + rolloff) / 2;
        Gu = zeros(1,N);
        a = abs(f);
        idx1 = a <= f0;
        Gu(idx1) = 1;
        idx2 = (a > f0) & (a <= f1);
        if rolloff > 0
            Gu(idx2) = 0.5 * (1 + cos(pi * (a(idx2) - f0) / (f1 - f0)));
        end
        Grrc = sqrt(Gu);
        g = real(ifft(ifftshift(Grrc)));
        pulse = fftshift(g).';
        pulse = pulse(:).';
      %  pulse = fftshift(abs(fft(pulse)));
    end

end