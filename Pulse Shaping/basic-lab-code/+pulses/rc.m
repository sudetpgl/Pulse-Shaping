%Group: Sude Topgül & Antonia Juncu

function pulse = rc(filterspan, rolloff, n_os, design_type)
%RC This
%   Inputs:
%   filterspan: Filterspan in number of symbols
%   rolloff:
%   n_os: oversampling factor
%   type: freq or time
%   the period T is assumed to be 1

assert(mod(filterspan,2)==0,'filterspan must be an even number');
pulse = zeros(1,filterspan*n_os);
N = n_os * filterspan;

% centered time axis (length N)
t = ((0:N-1) - N/2) / n_os;   % in symbol periods, centered

switch lower(design_type)
    case 'time'
        pulse(1) = 1;
        arg = 2*rolloff .* t;
        denom = 1 - arg.^2;
        pulse = (sinc(t) .* cos(pi*rolloff.*t)) ./ denom;
        if any(abs(t) == 1/(2*rolloff))
            pulse(find(t)) = pi/4*sinc(1/(2*rolloff));
        end
    case 'freq'
        % frequency grid (cycles per symbol), centered
        df = 1 / N;
        f = ((-N/2):(N/2-1)) * df;  
        f0 = (1 - rolloff) / 2;
        f1 = (1 + rolloff) / 2;
        a = abs(f);
        idx1 = a <= f0;
        pulse(idx1) = 1;
        idx2 = (a > f0) & (a <= f1);
        if rolloff > 0
            pulse(idx2) = 0.5 * (1 + cos(pi * (a(idx2) - f0) / (f1 - f0)));
        end
        % time-domain via ifft; pulses_out currently centered so use ifftshift
        pulses_out = real(ifft(ifftshift(pulse)));
        % put main-lobe in the middle
        pulses_out = fftshift(pulses_out).';
        pulses_out = pulses_out(:).';
    end

end

% p1 = pulses.rc(200, 0.75, 8, 'freq');
% p2 = pulses.rc(200, 0.75, 8, 'time');
% plot(p1); figure; plot(p2); 

%plot(fftshift(abs(fft(rc(128, 0.35, 8, 'freq'))))); grid on
