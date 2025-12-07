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
t = ((0:N-1) - N/2) / n_os; 

switch lower(design_type)
    case 'time'
        pulse(1) = 1;
        numer = sin(pi .* (t) .* (1 - rolloff)) + (4*rolloff .* (t)) .* cos(pi .* (t) .* (1 + rolloff));
        denom = pi .* (t) .* (1 - (4*rolloff .* (t)).^2);
        idx_reg = (abs(abs(4*rolloff.*t) - 1) > 1e-8);
        pulse(idx_reg) = (numer(idx_reg) ./ denom(idx_reg) );
        idx0 = t == 0;
        if any(idx0)
           pulse(idx0) = (1 - rolloff + (4*rolloff/pi));
        end
        idx_sp = abs(abs(t) - 1/(4*rolloff)) < 0;
        if any(idx_sp)
            pulse(idx_sp) = (rolloff / sqrt(2)) * ( (1 + 2/pi) * sin(pi/(4*rolloff)) + (1 - 2/pi) * cos(pi/(4*rolloff)) );
        end
  
    case 'freq'
        % build RC spectrum then take sqrt
        du = 1 / filterspan;
        u = ((-N/2):(N/2-1)) * du;  
        u0 = (1 - rolloff) / 2;
        u1 = (1 + rolloff) / 2;
        a = abs(u);
        idx1 = a <= u0;
        pulse(idx1) = 1;
        idx2 = (a > u0) & (a <= u1);
        if rolloff > 0
            pulse(idx2) = 0.5 * (1 + cos(pi/rolloff * (a(idx2) - u0)));
        end
        pulse_root = sqrt(pulse);
        pulse_out = real(ifft(ifftshift(pulse_root)));
        pulse_out = fftshift(pulse_out).';
        pulse = pulse_out(:).';
    end

end